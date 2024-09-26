#!/bin/bash

# Set the environment file path
ENV_FILE_PATH="/workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/.env"

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
fi

# Use the GitHub secret for NuGetApiKey
export NugetApiKey="${{ secrets.TRI_MONTHLY_TEMPO }}"
echo "NugetApiKey set from GitHub secret."

# Print the important variables
echo "Current Environment Variables:"
echo "Configuration: $Configuration"
echo "NugetApiKey: $NugetApiKey"
