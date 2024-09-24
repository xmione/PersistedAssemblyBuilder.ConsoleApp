// Used .net 9.0 Preview 7 framework for this and nuget package Blazor.Tools.Bundler version 3.1.2 (just updated)
using System;
using System.IO;
using System.Reflection;
using System.Reflection.Emit;
using Blazor.Tools.BlazorBundler.Entities.SampleObjects.Models;
using Blazor.Tools.BlazorBundler.Extensions;
using Blazor.Tools.BlazorBundler.Interfaces;
using Blazor.Tools.BlazorBundler.Utilities.Exceptions;

public class Program
{
    public static void Main(string[] args)
    {
        DynamicallyCreateAssembly();
    }

    private static void DynamicallyCreateAssembly()
    {
        try 
        {
            var contextAssemblyName = "Blazor.Tools.BlazorBundler.Interfaces";
            var assemblyFileName = $"{contextAssemblyName}.dll";
            var version = "1.0.0.0";
            var iViewModelTypeName = $"{contextAssemblyName}.IViewModel`2";
            var tempPath = Path.GetTempPath();
            var dllFilePath = $"{tempPath}.{contextAssemblyName}.dll";
            var employeeTypeAssemblyName = "Blazor.Tools.BlazorBundler.Entities.SampleObjects.Models";
            var employeeTypeName = $"{employeeTypeAssemblyName}.Employee";
            var iModelExtendedPropertiesTypeName = $"{contextAssemblyName}.IModelExtendedProperties";

            // Define the types for generic parameters
            Type modelType = typeof(Employee);
            Type modelExtendedPropertiesType = typeof(IModelExtendedProperties);

            // Create the assembly and module
            AssemblyName assemblyName = new AssemblyName(contextAssemblyName) { Version = new Version(version) };
            PersistedAssemblyBuilder assemblyBuilder = new PersistedAssemblyBuilder(assemblyName, typeof(object).Assembly);
            ModuleBuilder moduleBuilder = assemblyBuilder.DefineDynamicModule(assemblyFileName);

            // Define the generic type
            TypeBuilder typeBuilder = moduleBuilder.DefineType(
                iViewModelTypeName,
                TypeAttributes.Public | TypeAttributes.Interface | TypeAttributes.Abstract,
                null
            );

            // Define the generic parameters (without earlier techniques that did not work)
            GenericTypeParameterBuilder[] genericParamBuilders = typeBuilder.DefineGenericParameters(
                $"{employeeTypeName}",
                $"{iModelExtendedPropertiesTypeName}"
            );

            // Create the type
            Type createdType = typeBuilder.CreateTypeInfo().AsType();

            // Save the assembly to disk
            assemblyBuilder.Save(dllFilePath);

            // Load the dll file assembly using dll path extension method 
            var assembly = Assembly.LoadFile(dllFilePath);
            Type loadedType = assembly.GetType(createdType.FullName ?? string.Empty) ?? throw new InvalidOperationException("Loaded type is null.");

            // Construct expected type definition
            var expectedType = typeof(IViewModel<Employee, IModelExtendedProperties>);

            // Compare full names
            string createdTypeFullName = createdType.FullName ?? string.Empty;
            string loadedTypeFullName = loadedType.FullName ?? string.Empty;
            Console.WriteLine($"Expected Full Name: {expectedType.FullName}");
            Console.WriteLine($"Created Full Name: {createdTypeFullName}");
            Console.WriteLine($"Loaded Full Name: {loadedTypeFullName}");

            loadedType.DisplayTypeDifferences(expectedType);

            // Check if they match
            bool match = createdTypeFullName == expectedType.FullName && loadedTypeFullName == expectedType.FullName;
            Console.WriteLine(match ? "The types match." : "The types do not match.");
        }
        catch (Exception ex) 
        {
            AppLogger.WriteInfo(ex.Message);
        }
        
    }
}

