# Check if the script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please re-open script with administrator."
    return
}

# default install location in localappdata/programs
$install_location = "$env:LOCALAPPDATA\Programs\GreenLuma"

# user input check before running
Write-Host "Install Location: $install_location"
$check = Read-Host -Prompt "Are you sure you want to apply an antivirus exlusion to the folder above? [Y/N] (Default = N)"
$check = $check.ToLower()

if ($check -ne "y"){
    return
}

# Check if the folder exists and create folder if not
if (-Not (Test-Path -Path "$install_location")) {
    New-Item -Path "$install_location" -ItemType Directory
    if (-Not (Test-Path -Path "$install_location\AppList")) {
        New-Item -Path "$install_location\AppList" -ItemType Directory
        if (-Not (Test-Path -Path "$install_location\AppList\0.txt")) {
            New-Item -Path "$install_location\AppList\0.txt" -ItemType File
        }
    }
}

# adds exclusion to install path
Add-MpPreference -ExclusionPath "$install_location"