# Check if the script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please re-open script with administrator."
    Read-Host -Prompt "Press enter to exit"
}

$check = Read-Host -Prompt "Are you sure you want to apply a Antivirus Exclusion to the folder? [Y/N] (Default = N)"
$check = $check.ToLower()

if ($check -ne "y"){
    exit
}

Remove-MpPreference -ExclusionPath $temp
