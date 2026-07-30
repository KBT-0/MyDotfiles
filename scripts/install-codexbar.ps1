# Install Win-CodexBar through Windows Package Manager.

$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Install 'App Installer' from Microsoft Store, then run this script again."
}

Write-Host "==> Installing Win-CodexBar..." -ForegroundColor Cyan
winget install `
    --id Finesssee.Win-CodexBar `
    --exact `
    --source winget `
    --accept-source-agreements `
    --accept-package-agreements

if ($LASTEXITCODE -ne 0) {
    throw "Win-CodexBar installation failed with exit code $LASTEXITCODE."
}

Write-Host "==> Win-CodexBar is ready. Launch it from the Start Menu and enable providers in Settings." -ForegroundColor Green
