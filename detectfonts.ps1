function log() {
    Param (
        [string]$message
    )
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss tt"
    Write-Output "$date - $message"
}

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\fontDetect.log" -Force -Verbose

# Get the current location and set the fonts folder dynamically
$location = Get-Location
$FontDirectory = "$location\newfonts" # Adjust to match where your fonts are stored

# Get the fonts in the dynamic fonts folder
$fonts = Get-ChildItem -Path "$FontDirectory"

# Set the font REGPATH
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# Detect each font
foreach ($font in $fonts) {
    $basename = $font.BaseName
    $extension = $font.Extension
    $fullname = $font.FullName
    $fontname = $font.Name

    # Only process .ttf files
    if ($extension -eq ".ttf") {
        $fontValue = "$basename (TrueType)"
        log "Checking font: $fontValue"
    } else {
        log "Skipping unsupported file type: $fontname"
        continue
    }

    # Check if the font file exists in Windows\Fonts
    $fontPath = "$env:windir\Fonts\$fontname"
    if (Test-Path $fontPath) {
        log "Font file $fontname exists in C:\Windows\Fonts."
    } else {
        log "Font file $fontname is missing in C:\Windows\Fonts."
    }

    # Check if the registry entry exists using HKLM
    try {
        $regEntry = Get-ItemProperty -Path $regpath -Name "$fontValue" -ErrorAction Stop
        log "Registry entry found for $fontValue: $($regEntry.$fontValue)"
    } catch {
        log "Registry entry missing for $fontValue."
    }
}

Stop-Transcript

