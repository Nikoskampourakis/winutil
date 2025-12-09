function Microwin-GetOscdimg {
    [CmdletBinding()]
    param()

    # Define the expected path for oscdimg.exe
    $oscdimgPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "..\..\releases\oscdimg.exe"

    # Ensure the releases directory exists
    $releasesDir = Split-Path $oscdimgPath
    if (-not (Test-Path $releasesDir -PathType Container)) {
        Write-Verbose "Creating releases directory: $releasesDir"
        New-Item -ItemType Directory -Path $releasesDir -Force | Out-Null
    }

    # If oscdimg.exe is not found, attempt to obtain it
    if (-not (Test-Path $oscdimgPath -PathType Leaf)) {
        Write-Host "oscdimg.exe not found in '$oscdimgPath'. Attempting to download..." -ForegroundColor Yellow
        try {
            # Placeholder for actual download logic.
            # In a real scenario, this would involve Invoke-WebRequest or similar to fetch oscdimg.exe.
            # For example: Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2148107" -OutFile $oscdimgPath -UseBasicParsing -ErrorAction Stop
            # As the specific download URL or method is not provided, this remains a placeholder.
            Write-Verbose "Download initiated (replace with actual download logic for oscdimg.exe)"
        }
        catch {
            Write-Error "Failed to obtain oscdimg.exe: $($_.Exception.Message)"
            throw "Failed to obtain oscdimg.exe. Please ensure internet connectivity or place it manually in '$oscdimgPath'."
        }
    }

    # Final verification after any attempts to obtain the file
    if (-not (Test-Path $oscdimgPath -PathType Leaf)) {
        throw "Error: oscdimg.exe is still missing at '$oscdimgPath' after all attempts. Please check download source or place it manually."
    }

    Write-Verbose "oscdimg.exe found at '$oscdimgPath'."
    return $oscdimgPath
}
