# Check if the script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please re-open script with administrator."
    Read-Host -Prompt "Press enter to exit"
    return
}

# user input check before running
$check = Read-Host -Prompt "Are you sure you want to apply a Antivirus Exclusion to the folder? [Y/N] (Default = N)"
$check = $check.ToLower()

if ($check -ne "y"){
    return
}

$local_appdata_location = $env:LOCALAPPDATA
$install_location = $local_appdata_location + "\Programs\GreenLuma"
$folderPath = "$install_location"

# Check if the folder exists and create folder if not
if (-Not (Test-Path -Path $folderPath)) {
    New-Item -Path "$install_location" -ItemType Directory
}

# adds exclusion to install path
Add-MpPreference -ExclusionPath $folderPath
