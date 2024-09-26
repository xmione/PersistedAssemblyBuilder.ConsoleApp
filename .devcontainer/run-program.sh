#!/bin/bash

# Check if the Configuration variable is set
if [ -z "$Configuration" ]; then
    echo "Error: Configuration environment variable is not set."
    exit 1
fi

# Run the .NET application with the specified Configuration
dotnet build "${workspaceFolder}/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp.csproj" --configuration "$Configuration"
dotnet "${workspaceFolder}/PersistedAssemblyBuilder.ConsoleApp/bin/$Configuration/net9.0/PersistedAssemblyBuilder.ConsoleApp.dll"
