####################################################
# Script: uninstallfonts.ps1
# Scope: Uninstall fonts from the specified directory
####################################################

# Define the directory where the font files are located
$FontDirectory = "C:\fontscripts\allfonts"

# List all fonts (.TTF and .OTF) in the directory
$Fonts = @(Get-ChildItem -Path "$FontDirectory\*.ttf").Name
$Fonts += @(Get-ChildItem -Path "$FontDirectory\*.otf").Name

# Unregister the fonts by removing their files and registry entries
foreach ($Font in $Fonts) {
    try {
        Remove-Item -Path "C:\Windows\Fonts\$Font" -Force
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $Font -Force
    } catch {
        Write-Host "Error removing font: $Font"
        Write-Host $_
    }
}

Write-Host "Fonts uninstalled successfully!"
exit 0
