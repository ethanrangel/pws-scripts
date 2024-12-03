# List of font names as they appear in the registry
$FontsToCheck = @(
    "NotoSansJP-Black",
    "NotoSansJP-Bold",
    "NotoSansJP-ExtraBold",
    "NotoSansJP-ExtraLight",
    "NotoSansJP-Light",
    "NotoSansJP-Medium",
    "NotoSansJP-Regular",
    "NotoSansJP-SemiBold",
    "NotoSansJP-Thin",
    "RobotoSlab-ExtraBold",
    "RobotoSlab-Regular"
)

$AllFontsInstalled = $true

foreach ($Font in $FontsToCheck) {
    # Check if the font exists in the registry
    if (-Not (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name $Font -ErrorAction SilentlyContinue)) {
        Write-Host "Missing font: $Font"
        $AllFontsInstalled = $false
        break
    }
}

# Exit code based on detection result
if ($AllFontsInstalled) {
    Write-Host "All fonts are installed."
    exit 0
} else {
    Write-Host "Some fonts are missing."
    exit 1
}
