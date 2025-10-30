# Check if the script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please re-open script with administrator."
    # Start-Process powershell.exe -Verb RunAs -ArgumentList "-File", "`"$($MyInvocation.MyCommand.Path)`""
    # exit
}

$check = Read-Host -Prompt "Are you sure you want to install GreenLuma, and apply a Antivirus Exclusion to the folder? [Y/N] (Default = N)"
$check = $check.ToLower()

if ($check -ne "y"){
    exit
}

Set-Location -Path $PSScriptRoot

$temp = Get-Location | Select-Object -expand Path

Add-MpPreference -ExclusionPath $temp

Start-Process -FilePath ".\7za.exe" -ArgumentList 'x', '"GreenLuma*.zip"', '-o".\temp"', '-p"cs.rin.ru"' -Wait -NoNewWindow

New-Item -Path ".\greenluma" -ItemType Directory
Move-Item -Path ".\temp\NormalMode\DLLInjector.exe" -Destination ".\greenluma\"
Move-Item -Path ".\temp\NormalMode\DLLInjector.ini" -Destination ".\greenluma\"
Move-Item -Path ".\temp\NormalMode\GreenLumaSettings_2025.exe" -Destination ".\greenluma\"
Move-Item -Path ".\temp\StealthMode\DeleteSteamAppCache.exe" -Destination ".\greenluma\"
Move-Item -Path ".\temp\StealthMode\user32SteamFamilies.dll" -Destination ".\greenluma\gluma.dll"

Remove-Item -Recurse ".\temp"

$path = ".\greenluma\DLLInjector.ini"
$file = (Get-Content "$path")

$steam_path = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" | Select-Object -expand InstallPath
$steam_exe = "`"$steam_path\steam.exe`""

$current_dir = Get-Location | Select-Object -expand Path
$dll_path = "`"$current_dir\greenluma\gluma.dll`""

$file = $file.Replace("Steam.exe","$steam_exe")
$file = $file.Replace("GreenLuma_2025_x86.dll","$dll_path")
$file = $file.Replace("UseFullPathsFromIni = 0","UseFullPathsFromIni = 1")
$file = $file.Replace("CommandLine = -inhibitbootstrap","CommandLine =")
$file = $file.Replace("WaitForProcessTermination = 1","WaitForProcessTermination = 0")
$file = $file.Replace("EnableFakeParentProcess = 0","EnableFakeParentProcess = 1")
$file = $file.Replace("CreateFiles = 0","CreateFiles = 1")
$file = $file.Replace("FileToCreate_1 =","FileToCreate_1 = StealthMode.bin")

Set-Content -Path $path -Value $file
