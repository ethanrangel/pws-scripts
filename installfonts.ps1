####################################################
# Script: installfonts.ps1
# Scope: Install fonts from the specified directory
####################################################

# Define the directory where the font files are located
$FontDirectory = "C:\fontscripts\allfonts"

# List all fonts (.TTF and .OTF) in the directory
$Fonts = @(Get-ChildItem -Path "$FontDirectory\*.ttf").Name
$Fonts += @(Get-ChildItem -Path "$FontDirectory\*.otf").Name

# Register the fonts by copying them to the Fonts directory and updating the registry
foreach ($Font in $Fonts) {
    Copy-Item -Path "$FontDirectory\$Font" -Destination "$env:windir\Fonts" -Force
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $Font -PropertyType String -Value $Font -Force
}

Write-Host "Fonts installed successfully on the device!"
exit 0
