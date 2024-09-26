#!/bin/bash

# Load environment variables from .env file
set -a
source /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/.env
set +a

# Create tasks.json file
cat <<EOL > .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "build debug",
      "command": "dotnet",
      "type": "process",
      "args": [
        "build",
        "--verbosity",
        "detailed",
        "\${workspaceFolder}\\PersistedAssemblyBuilder.ConsoleApp\\PersistedAssemblyBuilder.ConsoleApp.csproj",
        "/p:PackageVersion=\${PackageVersion}",
        "/p:Configuration=Debug",
        "/p:AssemblyVersion=\${AssemblyVersion}",
        "/p:FileVersion=\${FileVersion}",
        "/p:Version=\${PackageVersion}"
      ],
      "problemMatcher": "\$msCompile"
    },
    {
      "label": "build release",
      "command": "dotnet",
      "type": "process",
      "args": [
        "build",
        "--verbosity",
        "detailed",
        "\${workspaceFolder}\\PersistedAssemblyBuilder.ConsoleApp\\PersistedAssemblyBuilder.ConsoleApp.csproj",
        "/p:PackageVersion=\${PackageVersion}",
        "/p:Configuration=Release",
        "/p:AssemblyVersion=\${AssemblyVersion}",
        "/p:FileVersion=\${FileVersion}",
        "/p:Version=\${PackageVersion}"
      ],
      "problemMatcher": "\$msCompile"
    }
  ]
}
EOL
