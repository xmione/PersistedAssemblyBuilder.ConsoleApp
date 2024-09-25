#!/bin/bash

# Set the environment file path
ENV_FILE_PATH=".env"

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

    # Accessing the variables in Bash
    echo "Current Environment Variables:"
    echo "Configuration: $Configuration"
    echo "Major Version: $MajorVersion"
    echo "Minor Version: $MinorVersion"
else
    echo "Environment file not found: $ENV_FILE_PATH"
fi
