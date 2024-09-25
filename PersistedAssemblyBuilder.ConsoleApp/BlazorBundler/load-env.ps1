param (
    [string]$EnvFilePath = "$(MSBuildThisFileDirectory).env"
)

if (Test-Path $EnvFilePath) {
    Get-Content $EnvFilePath | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+?)\s*=\s*(.+?)\s*$") {
            $key = $matches[1].Trim()  # Trim any extra whitespace
            $value = $matches[2].Trim()  # Trim any extra whitespace
            [System.Environment]::SetEnvironmentVariable($key, $value, [System.EnvironmentVariableTarget]::Process)
            Write-Host "Set $key = $value"  # Debug output
        }
    }

    # Check all variables after setting
    Write-Host "Current Environment Variables:"
    Get-ChildItem env: | Where-Object { $_.Name -match 'Configuration|MajorVersion|MinorVersion|PatchVersion|RevisionVersion|Publish|IsRelease|GitComment|AssemblyVersion|FileVersion|ChangelogPath' }
} else {
    Write-Host "Environment file not found: $EnvFilePath"
}
