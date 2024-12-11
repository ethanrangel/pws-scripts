function log() {
    Param (
        [string]$message
    )
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss tt"
    Write-Output "$date - $message"
}

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\fontUninstall.log" -Force -Verbose

# Get the current location and set the fonts folder dynamically
$location = Get-Location
$FontDirectory = "$location\newfonts" # Adjust to match where your fonts are stored

# Get the fonts in the dynamic fonts folder
$fonts = Get-ChildItem -Path "$FontDirectory"

# Set the font REGPATH
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# Unregister and delete each font
foreach ($font in $fonts) {
    $basename = $font.BaseName
    $extension = $font.Extension
    $fullname = $font.FullName
    $fontname = $font.Name

    # Only process .ttf files
    if ($extension -eq ".ttf") {
        $fontValue = "$basename (TrueType)"
        log "Font value to remove: $fontValue"
    } else {
        log "Skipping unsupported file type: $fontname"
        continue
    }

    # Remove the registry entry
    try {
        Remove-ItemProperty -Path $regpath -Name "$fontValue" -ErrorAction Stop
        log "Removed $fontValue from registry."
    } catch {
        log "Failed to remove $fontValue from registry: $_"
    }

    # Remove the font file from Windows\Fonts
    $fontPath = "$env:windir\Fonts\$fontname"
    if (Test-Path $fontPath) {
        try {
            Remove-Item -Path $fontPath -Force
            log "Removed $fontname from C:\Windows\Fonts."
        } catch {
            log "Failed to remove $fontname from C:\Windows\Fonts: $_"
        }
    } else {
        log "Font file $fontname not found in C:\Windows\Fonts."
    }
}

Stop-Transcript

