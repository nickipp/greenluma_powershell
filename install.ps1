# sets where the default install location is
$install_location = "$env:LOCALAPPDATA\Programs\GreenLuma"

# Check if the folder exists and tell user to run other script first if it does not exist
if (-Not (Test-Path -Path $install_location)) {
    Write-Host "Run antivirus_exclusion script before running this script"
    return
}

# user input check to make sure before running
Write-Host "Greenluma will be installed at $install_location"
$check = Read-Host -Prompt "Are you sure you want to install GreenLuma? [Y/N] (Default = N)"
$check = $check.ToLower()

if ($check -ne "y"){
    exit
}

# catches exceptions and cancels the script from continuing if steam is not found to be installed
try {
    $KeyPath = "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam"
    $ValueName = "InstallPath"
    # Attempt to get the item property
    $property = Get-ItemProperty -Path $KeyPath -Name $ValueName -ErrorAction Stop
    $steam_path = $($property.$ValueName)
}
catch [System.Management.Automation.ItemNotFoundException] {
    Write-Host "Steam is not installed."
    return
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
    return
}

# Creates shortcut to greenluma folder on the desktop
$targetFolderPath = "$install_location"
$shortcutPath = "$env:USERPROFILE\Desktop\GreenLuma.lnk"

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $targetFolderPath
$shortcut.Save()

# change working directory to greenluma folder in the localappdata programs folder
Set-Location -Path $install_location

# downloads required files 7zip and password protected zip with greenluma
# hardcoded so need to manually updated everytime lol
try {
    Invoke-WebRequest https://gluma.weeniehut.duckdns.org/7za.exe -OutFile .\7za.exe
    Invoke-WebRequest https://gluma.weeniehut.duckdns.org/GreenLuma_2025_1.6.9-Steam006.zip -OutFile .\gluma.zip
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
    return
}

# uses 7zip to extract files to a temp directory
Start-Process -FilePath ".\7za.exe" -ArgumentList 'x', '"gluma.zip"', '-o".\temp"', '-p"cs.rin.ru"' -Wait -NoNewWindow

Move-Item -Path ".\temp\NormalMode\DLLInjector.exe" -Destination ".\"
Move-Item -Path ".\temp\NormalMode\DLLInjector.ini" -Destination ".\"
Move-Item -Path ".\temp\NormalMode\GreenLumaSettings_2025.exe" -Destination ".\"
Move-Item -Path ".\temp\StealthMode\DeleteSteamAppCache.exe" -Destination ".\"
Move-Item -Path ".\temp\NormalMode\GreenLuma_2025_x86.dll" -Destination ".\gluma.dll"

Remove-Item -Recurse ".\temp"
Remove-Item ".\7za.exe"
Remove-Item ".\gluma.zip"

$path = ".\DLLInjector.ini"
$file = (Get-Content "$path")

$steam_exe = "`"$steam_path\steam.exe`""

$dll_path = "`"$install_location\gluma.dll`""

$file = $file.Replace("Steam.exe","$steam_exe")
$file = $file.Replace("GreenLuma_2025_x86.dll","$dll_path")
$file = $file.Replace("UseFullPathsFromIni = 0","UseFullPathsFromIni = 1")
$file = $file.Replace("CommandLine = -inhibitbootstrap","CommandLine =")
$file = $file.Replace("WaitForProcessTermination = 1","WaitForProcessTermination = 0")
$file = $file.Replace("EnableFakeParentProcess = 0","EnableFakeParentProcess = 1")
$file = $file.Replace("CreateFiles = 0","CreateFiles = 1")
$file = $file.Replace("FileToCreate_1 =","FileToCreate_1 = StealthMode.bin")

$file = $file.Replace("BootImage = GreenLuma2025_Files\BootImage.bmp","BootImage =")
$file = $file.Replace("BootImageWidth = 500","BootImageWidth =")
$file = $file.Replace("BootImageHeight = 500","BootImageHeight =")
$file = $file.Replace("BootImageXOffest = 240","BootImageXOffest =")
$file = $file.Replace("BootImageYOffest = 280","BootImageYOffest =")

Set-Content -Path $path -Value $file