param(
    [string]$Destination = ".\stream-server",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$pluginRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$templateRoot = Join-Path $pluginRoot "assets\stream-server-template"
$target = Resolve-Path -Path (Split-Path -Parent $Destination) -ErrorAction SilentlyContinue

if (-not $target) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $Destination) -Force | Out-Null
}

if ((Test-Path $Destination) -and -not $Force) {
    throw "Destination already exists. Re-run with -Force to overwrite files: $Destination"
}

New-Item -ItemType Directory -Path $Destination -Force | Out-Null
Copy-Item -Path (Join-Path $templateRoot "*") -Destination $Destination -Recurse -Force

Write-Host "Created stream server project at $Destination"
Write-Host "Next steps:"
Write-Host "  1. Copy the folder to your Ubuntu VPS."
Write-Host "  2. Edit config/stream.conf with RTMP_URL and STREAM_KEY."
Write-Host "  3. Run sudo ./install.sh from the project directory."
Write-Host "  4. Use stream start high, stream status, and stream logs."
