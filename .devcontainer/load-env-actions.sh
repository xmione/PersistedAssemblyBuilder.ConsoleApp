#!/bin/bash

# Set the environment file path
ENV_FILE_PATH="$GITHUB_WORKSPACE/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/.env"
echo "#" > ~/.bashrc
# Check if the .env file exists
if [ -f "$ENV_FILE_PATH" ]; then
    while IFS='=' read -r key value; do
        if [[ $key =~ ^# || -z $key ]]; then
            continue
        fi
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        export "$key=$value"
        echo "export $key=\"$value\"" >> ~/.bashrc
        echo "Set $key = $value"  # Debug output
    done < "$ENV_FILE_PATH"
    # Apply the changes to the current session
    source ~/.bashrc
else
    echo "Environment file not found: $ENV_FILE_PATH"
    ls -l "$ENV_FILE_PATH"  # Show file details
fi
