function log() {
    Param (
        [string]$message
    )
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss tt"
    Write-Output "$date - $message"
}

Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\fontInstall.log" -Force -Verbose

# Get the current location and set the fonts folder dynamically
$location = Get-Location
$FontDirectory = "$location\newfonts" # Adjust to match where your fonts are stored

# Get the fonts in the dynamic fonts folder
$fonts = Get-ChildItem -Path "$FontDirectory"

# Set the font REGPATH
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

# Set font values for each font
foreach ($font in $fonts) {
    $basename = $font.BaseName
    $extension = $font.Extension
    $fullname = $font.FullName
    $fontname = $font.Name

    # Only process .ttf files
    if ($extension -eq ".ttf") {
        $fontValue = "$basename (TrueType)"
        log "Font value is $fontValue"
    } else {
        log "Skipping unsupported file type: $fontname"
        continue
    }

    # Check if the font file exists in Windows\Fonts
    if (Test-Path "$env:windir\Fonts\$fontname") {
        log "Font $fontname already exists in C:\Windows\Fonts."
    } else {
        # Copy font file to Windows\Fonts
        Copy-Item -Path $fullname -Destination "$env:windir\Fonts" -Force
        log "Copied $fullname to C:\Windows\Fonts..."

        # Add font to registry using New-ItemProperty
        try {
            New-ItemProperty -Path $regpath -Name "$fontValue" -Type String -Value "$fontname" -Force
            log "Successfully added $fontValue to registry."
        } catch {
            log "Failed to add $fontValue to registry: $_"
        }
    }
}

Stop-Transcript

