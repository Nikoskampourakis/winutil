# scripts/main.ps1
# This script initializes the WinUtil environment, loads functions, and configuration.
# It assumes $global:WinUtilProjectRoot has been defined by the calling script (e.g., start.ps1).

#region Load Functions
Write-Verbose "Loading WinUtil functions..."
Get-ChildItem (Join-Path $global:WinUtilProjectRoot "functions/**/*.ps1") | ForEach-Object {
    Write-Verbose "  Dot-sourcing $($_.Name)"
    . $_.FullName
}
Write-Verbose "All functions loaded."
#endregion

#region Load Configurations
Write-Verbose "Loading configurations..."
# Define a global config path for easy access to configuration files throughout the application.
$global:WinUtilConfigPath = Join-Path $global:WinUtilProjectRoot "config"

# Load application configuration using the global config path.
$applications = Get-Content (Join-Path $global:WinUtilConfigPath "applications.json") | ConvertFrom-Json
Write-Verbose "applications.json loaded."

# Other config files would be loaded similarly using $global:WinUtilConfigPath
# $appnavigation = Get-Content (Join-Path $global:WinUtilConfigPath "appnavigation.json") | ConvertFrom-Json
# $dns = Get-Content (Join-Path $global:WinUtilConfigPath "dns.json") | ConvertFrom-Json
# etc.
Write-Verbose "Configurations loaded."
#endregion

#region Initialize UI (if applicable)
# Example: Initialize-WPFUI # This would be called if main.ps1 is responsible for UI
#endregion

Write-Verbose "WinUtil initialization complete."
