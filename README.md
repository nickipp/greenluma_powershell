# greenluma_powershell
greenluma powershell script

# Installation

Open a powershell in the directory where you want to install Greenluma.
Make sure it is run as administrator.

# Windows 10 Users
To open a powershell in the folder, go to the folder in file explorer and in the top left there will be "File" button.
Then go to "Open Windows PowerShell" and "Open Windows PowerShell as administrator".

# Windows 11 Users


Run these commmands in your powershell in the desired directory.
Run them one at a time, one after another.

```
iwr https://github.com/nickipp/greenluma_powershell/raw/refs/heads/main/7za.exe -OutFile .\7za.exe ; iwr https://github.com/nickipp/greenluma_powershell/raw/refs/heads/main/GreenLuma_2025_1.6.6-Steam006.zip -OutFile .\GreenLuma_2025_1.6.6-Steam006.zip
```

```
iwr https://raw.githubusercontent.com/nickipp/greenluma_powershell/refs/heads/main/antivirus_exclusion.ps1 | iex
```

```
iwr https://raw.githubusercontent.com/nickipp/greenluma_powershell/refs/heads/main/install.ps1 | iex
```
