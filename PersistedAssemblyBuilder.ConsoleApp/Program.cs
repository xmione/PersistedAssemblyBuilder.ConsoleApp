// Used .net 9.0 Preview 7 framework for this and nuget package Blazor.Tools.Bundler version 3.1.9 (updated 9/25)
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
            var iViewbaseTypeName = $"{contextAssemblyName}.IViewModel`2";
            var tempPath = Path.GetTempPath();
            var dllFilePath = $"{tempPath}.{contextAssemblyName}.dll";
            var employeeTypeAssemblyName = "Blazor.Tools.BlazorBundler.Entities.SampleObjects.Models";
            var employeeTypeName = $"{employeeTypeAssemblyName}.Employee";
            var iModelExtendedPropertiesTypeName = $"{contextAssemblyName}.IModelExtendedProperties";

            // Define the types for generic parameters
            Type baseType = typeof(Employee);
            Type modelExtendedPropertiesType = typeof(IModelExtendedProperties);

            // Create the assembly and module
            AssemblyName assemblyName = new AssemblyName(contextAssemblyName) { Version = new Version(version) };
            PersistedAssemblyBuilder assemblyBuilder = new PersistedAssemblyBuilder(assemblyName, typeof(object).Assembly);
            ModuleBuilder moduleBuilder = assemblyBuilder.DefineDynamicModule(assemblyFileName);

            // Define the generic type
            TypeBuilder typeBuilder = moduleBuilder.DefineType(
                iViewbaseTypeName,
                TypeAttributes.Public | TypeAttributes.Interface | TypeAttributes.Abstract,
                null
            );

            string[] typeParamNames = {"TModel", "TIModel"};
            GenericTypeParameterBuilder[] typeParams = typeBuilder.DefineGenericParameters(typeParamNames);

            GenericTypeParameterBuilder TModel = typeParams[0];
            GenericTypeParameterBuilder TIModel = typeParams[1];

            // Apply constraints to the type parameters.
            //
            // A type that is substituted for the first parameter, TModel,
            // must be a reference type and must have a parameterless
            // constructor.
            TModel.SetGenericParameterAttributes( GenericParameterAttributes.DefaultConstructorConstraint | GenericParameterAttributes.ReferenceTypeConstraint);

            // A type that is substituted for the second type
            // parameter must implement IExampleA and IExampleB, and
            // inherit from the trivial test class ExampleBase. The
            // interface constraints are specified as an array
            // containing the interface types.
            TIModel.SetBaseTypeConstraint(baseType);
            Type[] interfaceTypes = {modelExtendedPropertiesType};
            TIModel.SetInterfaceConstraints(interfaceTypes);

            // Define methods in the interface
            DefineInterfaceMethod(typeBuilder, "ToNewModel", typeParams[0]); // TModel ToNewModel();
            DefineInterfaceMethod(typeBuilder, "ToNewIModel", typeParams[1]); // TIModel ToNewIModel();
            DefineInterfaceTaskMethod(typeBuilder, "FromModel", typeof(Task<>).MakeGenericType(typeBuilder), typeParams[0]); // Task<IViewModel<TModel, TIModel>> FromModel(TModel model);
            DefineInterfaceTaskMethod(typeBuilder, "SetEditMode", typeof(Task<>).MakeGenericType(typeBuilder), typeof(bool)); // Task<IViewModel<TModel, TIModel>> SetEditMode(bool isEditMode);
            DefineInterfaceTaskMethod(typeBuilder, "SaveModelVM", typeof(Task<>).MakeGenericType(typeBuilder)); // Task<IViewModel<TModel, TIModel>> SaveModelVM();
            DefineInterfaceTaskMethod(typeBuilder, "SaveModelVMToNewModelVM", typeof(Task<>).MakeGenericType(typeBuilder)); // Task<IViewModel<TModel, TIModel>> SaveModelVMToNewModelVM();

            // Define method with IEnumerable<IViewModel<TModel, TIModel>> as return type and parameter
            Type iEnumerableViewModelType = typeof(IEnumerable<>).MakeGenericType(typeBuilder);
            DefineInterfaceTaskMethod(typeBuilder, "AddItemToList", typeof(Task<>).MakeGenericType(iEnumerableViewModelType), iEnumerableViewModelType);
            DefineInterfaceTaskMethod(typeBuilder, "UpdateList", typeof(Task<>).MakeGenericType(iEnumerableViewModelType), iEnumerableViewModelType, typeof(bool));
            DefineInterfaceTaskMethod(typeBuilder, "DeleteItemFromList", typeof(Task<>).MakeGenericType(iEnumerableViewModelType), iEnumerableViewModelType);

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
    
    private static void DefineInterfaceMethod(TypeBuilder typeBuilder, string methodName, Type returnType)
    {
        MethodBuilder methodBuilder = typeBuilder.DefineMethod(methodName,
            MethodAttributes.Public | MethodAttributes.Abstract | MethodAttributes.Virtual | MethodAttributes.HideBySig,
            returnType, Type.EmptyTypes);
    }

    private static void DefineInterfaceTaskMethod(TypeBuilder typeBuilder, string methodName, Type returnType, params Type[] parameterTypes)
    {
        MethodBuilder methodBuilder = typeBuilder.DefineMethod(methodName,
            MethodAttributes.Public | MethodAttributes.Abstract | MethodAttributes.Virtual | MethodAttributes.HideBySig,
            returnType, parameterTypes);
    }

}

