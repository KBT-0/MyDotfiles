# Install and select Atuin as the PowerShell history UI.

$ErrorActionPreference = "Stop"

if (-not (Get-Command atuin -ErrorAction SilentlyContinue)) {
    Write-Host "==> Installing Atuin..." -ForegroundColor Cyan
    winget install --id Atuinsh.Atuin --exact --source winget --accept-source-agreements --accept-package-agreements
}

$backendFile = Join-Path $HOME ".config\shell\history-backend"
New-Item -Path (Split-Path -Parent $backendFile) -ItemType Directory -Force | Out-Null
Set-Content -LiteralPath $backendFile -Value "atuin" -Encoding ascii

Write-Host ""
Write-Host "==> Done. Atuin is selected on this machine." -ForegroundColor Cyan
Write-Host "==> Open a new PowerShell tab. Ctrl+R and Up Arrow will open Atuin history search."
Write-Host "==> Sync history from Linux with: atuin login, then atuin sync"
