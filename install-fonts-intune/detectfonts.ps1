function log() {
    Param (
        [string]$message
    )
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss tt"
    Write-Output "$date - $message"
}

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\fontDetect.log" -Force -Verbose

# Define the fonts you expect to be installed
$expectedFonts = @(
    @{ Name = "Noto Sans JP Black (TrueType)"; File = "NotoSansJP-Black.ttf" },
    @{ Name = "Font2 (TrueType)"; File = "Font2.ttf" }
)

# Set the registry path
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# Variable to track detection status
$allFontsDetected = $true

foreach ($font in $expectedFonts) {
    $fontName = $font["Name"]
    $fontFile = $font["File"]

    # Check if the font file exists in Windows\Fonts
    $fontPath = "$env:windir\Fonts\$fontFile"
    if (-not (Test-Path $fontPath)) {
        log "Font file $fontFile is missing in C:\Windows\Fonts."
        $allFontsDetected = $false
    } else {
        log "Font file $fontFile exists in C:\Windows\Fonts."
    }

    # Check if the registry entry exists
    try {
        $regEntry = Get-ItemProperty -Path $regpath -Name "$fontName" -ErrorAction Stop
        log "Registry entry found for $fontName: $($regEntry.$fontName)"
    } catch {
        log "Registry entry missing for $fontName."
        $allFontsDetected = $false
    }
}

Stop-Transcript

# Exit with appropriate code for Intune
if ($allFontsDetected) {
    log "All fonts detected successfully."
    Exit 0
} else {
    log "One or more fonts are missing."
    Exit 1
}

