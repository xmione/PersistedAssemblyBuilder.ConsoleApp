#!/bin/bash
LOG_FILE="/workspaces/PersistedAssemblyBuilder.ConsoleApp/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  # Make all files in the directory executable
  for file in /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/*; do
    echo "sudo chmod +x $file"
    sudo chmod +x "$file"
  done

  # Make load-env.sh executable
  sudo chmod +x /workspaces/PersistedAssemblyBuilder.ConsoleApp/.devcontainer/load-env.sh

  # Run the PowerShell script (if needed)
  sudo pwsh /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/Get-Tools.ps1

  # Execute load-env.sh in an interactive shell
  # if ! bash -i /workspaces/PersistedAssemblyBuilder.ConsoleApp/.devcontainer/load-env.sh; then
  #   echo "Failed to execute load-env.sh" | tee -a "$LOG_FILE"
  #   exit 1
  # fi

  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
