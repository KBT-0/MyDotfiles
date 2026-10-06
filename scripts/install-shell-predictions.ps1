# Install the optional PowerShell prediction UI: inshellisense.
# Selects it in ~/.config/shell/history-backend; the managed profile does the rest.

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string] $Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $extraPaths = @(
        "$HOME\.local\bin",
        "$env:APPDATA\npm",
        "$env:LOCALAPPDATA\Microsoft\WinGet\Links",
        "$env:ProgramFiles\nodejs",
        "$env:ProgramFiles\PowerShell\7"
    )

    $env:Path = (($machinePath, $userPath) + $extraPaths | Where-Object { $_ }) -join ";"
}

function Add-UserPath {
    param([string] $Path)

    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $parts = @()
    if ($userPath) {
        $parts = $userPath -split ';' | Where-Object { $_ }
    }

    if ($parts -notcontains $Path) {
        $newPath = (($parts + $Path) | Where-Object { $_ }) -join ';'
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    }

    if (($env:Path -split ';') -notcontains $Path) {
        $env:Path = "$Path;$env:Path"
    }
}

function Ensure-Node {
    Refresh-Path
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        return
    }

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "npm not found and winget is unavailable. Install Node.js LTS, then re-run this script."
    }

    Write-Step "Installing Node.js LTS..."
    winget install --id OpenJS.NodeJS.LTS --exact --source winget --accept-source-agreements --accept-package-agreements
    Refresh-Path

    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        throw "npm still not found. Open a new PowerShell tab and re-run this script."
    }
}

function Select-HistoryBackend {
    param([string] $Backend)

    $backendFile = Join-Path $HOME ".config\shell\history-backend"
    New-Item -Path (Split-Path -Parent $backendFile) -ItemType Directory -Force | Out-Null
    Set-Content -LiteralPath $backendFile -Value $Backend -Encoding ascii
}

Write-Step "Installing inshellisense..."
Ensure-Node
npm install -g @microsoft/inshellisense

$npmBin = Join-Path $env:APPDATA "npm"
if (Test-Path -LiteralPath $npmBin) {
    Add-UserPath $npmBin
}
Refresh-Path

if (-not (Get-Command is -ErrorAction SilentlyContinue)) {
    Write-Warning "inshellisense was installed, but 'is' is not visible in this PowerShell session yet. Open a new tab if needed."
} else {
    $isCommand = Get-Command is -ErrorAction SilentlyContinue
    & $isCommand.Source init pwsh | Out-Null
}

Select-HistoryBackend "inshellisense"

Write-Host ""
Write-Host "==> Done. inshellisense is selected on this machine. Run install-atuin.ps1 to switch back." -ForegroundColor Cyan
Write-Host "==> Open a new PowerShell tab, then run: is doctor" -ForegroundColor Cyan
