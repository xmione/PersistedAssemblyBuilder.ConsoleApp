#!/bin/bash
LOG_FILE="/workspaces/PersistedAssemblyBuilder.ConsoleApp/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  # Make all files in the directory executable
  for file in /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/*; do
    echo "sudo chmod +x $file"
    sudo chmod +x "$file"
  done

  # Make load-env-container.sh executable
  sudo chmod +x /workspaces/PersistedAssemblyBuilder.ConsoleApp/.devcontainer/load-env-container.sh

  # Make generate_tasks.sh executable
  sudo chmod +x /workspaces/PersistedAssemblyBuilder.ConsoleApp/.devcontainer/generate_tasks.sh

  # Run the PowerShell script (if needed)
  sudo pwsh /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/Get-Tools.ps1

  # Execute load-env-container.sh in an interactive shell
  if ! bash -i /workspaces/PersistedAssemblyBuilder.ConsoleApp/.devcontainer/load-env-container.sh; then
    echo "Failed to execute load-env-container.sh" | tee -a "$LOG_FILE"
    exit 1
  fi

  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
