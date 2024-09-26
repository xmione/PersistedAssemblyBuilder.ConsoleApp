#!/bin/bash

# Set the environment file path
ENV_FILE_PATH="$GITHUB_WORKSPACE/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/.env"

# Check if the .env file exists
if [ -f "$ENV_FILE_PATH" ]; then
    while IFS='=' read -r key value; do
        if [[ $key =~ ^# || -z $key ]]; then
            continue
        fi
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        export "$key=$value"
        echo "Set $key = $value"  # Debug output
    done < "$ENV_FILE_PATH"
else
    echo "Environment file not found: $ENV_FILE_PATH"
    echo "ls $ENV_FILE_PATH"
    ls $ENV_FILE_PATH
fi

# Ensure NugetApiKey is set from the environment variable
if [ -z "$NugetApiKey" ]; then
    echo "Warning: NugetApiKey is not set. Please check your GitHub Actions secrets."
else
    echo "NugetApiKey is set successfully."
fi

# Print the important variables
echo "Current Environment Variables:"
echo "Configuration: $Configuration"
echo "NugetApiKey: $NugetApiKey"
