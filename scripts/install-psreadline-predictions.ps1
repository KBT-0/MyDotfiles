# Install optional PowerShell PSReadLine ListView predictions.
# Selects it in ~/.config/shell/history-backend; the managed profile does the rest.

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string] $Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Ensure-PSGallery {
    try {
        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope CurrentUser -Force | Out-Null
        }

        $repo = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue
        if ($repo -and $repo.InstallationPolicy -ne "Trusted") {
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        }
    } catch {
        Write-Warning "PSGallery could not be prepared: $($_.Exception.Message)"
    }
}

function Ensure-PSReadLine {
    Write-Step "Installing/updating PSReadLine..."

    if (Get-Module -ListAvailable -Name PSReadLine) {
        Write-Host "PSReadLine already available." -ForegroundColor Green
        return
    }

    Ensure-PSGallery

    try {
        Install-Module PSReadLine -Scope CurrentUser -Force -AllowClobber -Repository PSGallery
    } catch {
        Write-Warning "PSReadLine install/update skipped: $($_.Exception.Message)"
    }
}

function Select-HistoryBackend {
    param([string] $Backend)

    $backendFile = Join-Path $HOME ".config\shell\history-backend"
    New-Item -Path (Split-Path -Parent $backendFile) -ItemType Directory -Force | Out-Null
    Set-Content -LiteralPath $backendFile -Value $Backend -Encoding ascii
}

Ensure-PSReadLine
Select-HistoryBackend "psreadline"

Write-Host ""
Write-Host "==> Done. PSReadLine ListView is selected on this machine. Run install-atuin.ps1 to switch back." -ForegroundColor Cyan
Write-Host "==> Open a new PowerShell tab." -ForegroundColor Cyan
