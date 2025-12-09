param(
    [Parameter(Mandatory=$true)]
    [boolean]$Enable
)

# Function to safely set registry values, creating path if it doesn't exist
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [object]$Value,
        [Microsoft.PowerShell.Commands.Registry.RegistryValueKind]$Type = [Microsoft.PowerShell.Commands.Registry.RegistryValueKind]::DWord
    )
    try {
        if (-not (Test-Path -Path $Path)) {
            New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force -ErrorAction Stop
    } catch {
        Write-Warning "Failed to set registry value '$Name' at '$Path': $($_.Exception.Message)"
    }
}

# Function to safely remove registry values
function Remove-RegistryValue {
    param(
        [string]$Path,
        [string]$Name
    )
    try {
        if (Test-Path -Path $Path) {
            Remove-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
        }
    } catch {
        Write-Warning "Failed to remove registry value '$Name' at '$Path': $($_.Exception.Message)"
    }
}

if ($Enable) {
    Write-Host "Enabling Digital Markets Act compliant options..."

    # 1. Allow Edge Management (making it less integrated and easier to uninstall/manage)
    # These policies aim to allow easier uninstallation/management of Microsoft Edge.
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4FAC-B736-621817C43C3A}" -Name "DontRun" -Value 1
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "AllowsUninstall" -Value 1
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium" -Value 0

    # 2. Allow Microsoft Store Uninstall and signal for other system APPX packages
    # This sets a WinUtil-specific flag, which the UI/other functions can check to present
    # uninstall options for Store and other core AppX packages, enabling their removal.
    Set-RegistryValue -Path "HKLM:\SOFTWARE\WinUtil" -Name "DMASupport" -Value 1

    # 3. Enable more Default Browser Options
    # These policies ensure users can freely set their default browser without OS interference.
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DisableDefaultBrowserPrompt" -Value 0
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PreventSettingDefaultBrowser" -Value 0
    # Clear UserChoice hash for HTTP/HTTPS protocols to force the OS to re-prompt for default browser selection,
    # ensuring user's new choice sticks upon next browser launch.
    Remove-RegistryValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice" -Name "Hash"
    Remove-RegistryValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice" -Name "Hash"

    Write-Host "Digital Markets Act compliant options enabled."
} else {
    Write-Host "Disabling Digital Markets Act compliant options (reverting to default behavior)..."

    # Revert Edge management changes
    Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate\Clients\{56EB18F8-B008-4FAC-B736-621817C43C3A}" -Name "DontRun"
    Remove-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "AllowsUninstall"
    Remove-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium"

    # Revert DMASupport flag
    Remove-RegistryValue -Path "HKLM:\SOFTWARE\WinUtil" -Name "DMASupport"

    # Revert Default Browser Options changes
    Remove-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DisableDefaultBrowserPrompt"
    Remove-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PreventSettingDefaultBrowser"
    # Note: Explicitly removing the 'Hash' is a user-driven action and doesn't need to be reverted automatically.
    # The OS will manage it if the user sets a new default.

    Write-Host "Digital Markets Act compliant options disabled."
}