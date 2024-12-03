####################################################
# Script: detectfonts_v2.ps1
# Scope: Detect if the specified font files exist in C:\Windows\Fonts
####################################################

# List of font file names (with extensions) to check in the Fonts directory
$FontFilesToCheck = @(
    "NotoSansJP-Black.ttf",
    "NotoSansJP-Bold.ttf",
    "NotoSansJP-ExtraBold.ttf",
    "NotoSansJP-ExtraLight.ttf",
    "NotoSansJP-Light.ttf",
    "NotoSansJP-Medium.ttf",
    "NotoSansJP-Regular.ttf",
    "NotoSansJP-SemiBold.ttf",
    "NotoSansJP-Thin.ttf",
    "RobotoSlab-ExtraBold.ttf",
    "RobotoSlab-Regular.ttf"
)

$AllFontsInstalled = $true

foreach ($FontFile in $FontFilesToCheck) {
    # Check if the font file exists in C:\Windows\Fonts
    if (-Not (Test-Path "C:\Windows\Fonts\$FontFile")) {
        Write-Host "Missing font file: $FontFile"
        $AllFontsInstalled = $false
        break
    }
}

# Exit code based on detection result
if ($AllFontsInstalled) {
    Write-Host "All font files are installed."
    exit 0
} else {
    Write-Host "Some font files are missing."
    exit 1
}

