# functions/private/Find-AppsByNameOrDescription.ps1
function Find-AppsByNameOrDescription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$SearchTerm
    )

    Write-Verbose "Searching for apps with term: '$SearchTerm'"

    $appsData = @() # Initialize as empty array

    # The bug often occurs when functions try to re-calculate paths to config files
    # relative to their own $PSScriptRoot, which can be inconsistent if the script is dot-sourced.
    # This fix ensures we use the globally defined $global:WinUtilConfigPath.
    if (-not (Get-Variable -Name WinUtilConfigPath -Scope Global -ErrorAction SilentlyContinue)) {
        Write-Error "Global WinUtilConfigPath variable is not defined. Ensure WinUtil has been properly initialized." -ErrorAction Stop
    }

    # Now, consistently load the applications.json using the global config path.
    # This resolves the bug of inconsistent path resolution for configuration files.
    try {
        $appsData = Get-Content (Join-Path $global:WinUtilConfigPath "applications.json") | ConvertFrom-Json
    } catch {
        Write-Error "Failed to load applications.json from '$global:WinUtilConfigPath'. Error: $($_.Exception.Message)" -ErrorAction Stop
    }

    $results = $appsData | Where-Object {
        $_.Name -like "*$SearchTerm*" -or $_.Description -like "*$SearchTerm*"
    }

    $results
}
