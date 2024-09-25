#!/bin/bash
LOG_FILE="/workspaces/PersistedAssemblyBuilder.ConsoleApp/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  # Make all files in the directory executable
  for file in /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/*; do
    echo "sudo chmod +x $file"
    sudo chmod +x "$file"
  done

  # Run the PowerShell script (if needed)
  sudo pwsh /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/Get-Tools.ps1

  # Invoke the load-env.sh script with the full path
 if ! bash /workspaces/PersistedAssemblyBuilder.ConsoleApp/.devcontainer/load-env.sh; then
    echo "Failed to execute load-env.sh" | tee -a "$LOG_FILE"
    exit 1
 fi

  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
