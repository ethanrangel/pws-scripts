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

    if ($extension -eq ".ttf") {
        $fontValue = "$basename (TrueType)"
        log "Font value is $fontValue"
    }

    if ([string]::IsNullOrEmpty($fontValue)) {
        log "Font not found or unsupported format"
    } else {
        if (Test-Path "$env:windir\Fonts\$fontname") {
            log "Font $fontname already exists"
        } else {
            Copy-Item -Path $fullname -Destination "$env:windir\Fonts" -Force
            log "Copied $fullname to C:\Windows\Fonts..."
            reg.exe add $regpath /v "$fontValue" /t REG_SZ /d "$fontname" /f | Out-Host
            log "Added $fontValue to registry"
        }
    }
}

Stop-Transcript
