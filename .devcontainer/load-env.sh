#!/bin/bash

# Set the environment file path
ENV_FILE_PATH="/workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/.env"

# Check if the .env file exists
if [ -f "$ENV_FILE_PATH" ]; then
    # Read each line of the .env file
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        if [[ $key =~ ^# || -z $key ]]; then
            continue
        fi
        # Trim whitespace and export
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        export "$key=$value"
        echo "Set $key = $value"  # Debug output
    done < "$ENV_FILE_PATH"
else
    echo "Environment file not found: $ENV_FILE_PATH"
fi

# Prompt user to input NugetApiKey if it's not already set
if [ -z "$NugetApiKey" ]; then
    read -p "Please enter your NugetApiKey: " NugetApiKey
    export NugetApiKey
    echo "NugetApiKey set."
else
    echo "NugetApiKey already set."
fi

# Optionally, print all the important variables to confirm they are set
echo "Current Environment Variables:"
echo "Configuration: $Configuration"
echo "NugetApiKey: $NugetApiKey"
