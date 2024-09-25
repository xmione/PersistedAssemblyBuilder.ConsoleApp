#!/bin/bash
LOG_FILE="/workspaces/PersistedAssemblyBuilder.ConsoleApp/initializebashfiles.log"

{
  echo "Running initializebashfiles.sh"

  # Make all files in the directory executable
  for file in /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/*; do
    echo "sudo chmod +x $file"
    sudo chmod +x $file
  done

  sudo pwsh /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/Get-Tools.ps1
  sudo pwsh /workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/load-env.ps1 -EnvFilePath "/workspaces/PersistedAssemblyBuilder.ConsoleApp/PersistedAssemblyBuilder.ConsoleApp/BlazorBundler/.env"
  echo "initializebashfiles completed"
} 2>&1 | tee -a "$LOG_FILE"
