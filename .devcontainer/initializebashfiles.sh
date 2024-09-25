#!/bin/bash
LOG_FILE="/workspaces/PersistedAssemblyBuilder.ConsoleApp/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  # Make all files in the directory executable
  for file in /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/*; do
    sudo chmod +x "$file"
  done

  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
