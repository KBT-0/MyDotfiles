# PowerShell 7 profile - mirrors the managed .zshrc used on WSL/Linux and macOS.

foreach ($MyDotfilesBinDir in @((Join-Path $HOME "bin"), (Join-Path $HOME ".local\bin"))) {
    if ((Test-Path -LiteralPath $MyDotfilesBinDir) -and (($env:Path -split ';') -notcontains $MyDotfilesBinDir)) {
        $env:Path = "$MyDotfilesBinDir;$env:Path"
    }
}
Remove-Variable MyDotfilesBinDir

# >>> lfcd integration >>>
# lf file manager integration.
function lfcd {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]] $LfArgs
    )

    $lfCommand = Get-Command lf.exe -ErrorAction SilentlyContinue
    if (-not $lfCommand) {
        Write-Warning "lf.exe not found. Run scripts/install-lf.ps1 from the dotfiles repo."
        return
    }

    $lastDir = & $lfCommand.Source -print-last-dir @LfArgs
    if ($LASTEXITCODE -ne 0) {
        return
    }

    if ($lastDir -and (Test-Path -LiteralPath $lastDir -PathType Container)) {
        Set-Location -LiteralPath $lastDir
    }
}

Set-Alias -Name lf -Value lfcd -Option AllScope -Force
# <<< lfcd integration <<<

# Oh My Posh prompt - same atomic theme used by the bash/zsh profiles.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config atomic | Invoke-Expression
}

# Zsh emacs keymap: Ctrl+A/E, Ctrl+K/U, Ctrl+W, Alt+Backspace, Alt+D, Alt+B/F, Ctrl+Y.
Set-PSReadLineOption -EditMode Emacs -BellStyle None
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+w -Function BackwardKillWord

# Same word boundaries as zsh WORDCHARS: paths, dashes and dots stay one word.
# "\" is treated like "/" so Windows paths delete as a whole too.
Set-PSReadLineOption -WordDelimiters ',:@+|''"`'

# Larger history, no duplicates; PSReadLine shares it between sessions.
Set-PSReadLineOption -MaximumHistoryCount 50000 -HistoryNoDuplicates

# Atuin + grey inline suggestions is the default, like zsh on Linux/macOS.
# install-shell-predictions.ps1 / install-psreadline-predictions.ps1 write a
# machine-local alternative to ~/.config/shell/history-backend.
$MyDotfilesHistoryBackend = "atuin"
$MyDotfilesBackendFile = Join-Path $HOME ".config\shell\history-backend"
if (Test-Path -LiteralPath $MyDotfilesBackendFile -PathType Leaf) {
    $MyDotfilesHistoryBackend = (Get-Content -LiteralPath $MyDotfilesBackendFile -TotalCount 1).Trim()
}

switch ($MyDotfilesHistoryBackend) {
    "inshellisense" {
        Set-PSReadLineOption -PredictionSource None
        $InshellisensePwshInit = Join-Path $HOME ".inshellisense\init\pwsh\init.ps1"
        if (Test-Path -LiteralPath $InshellisensePwshInit -PathType Leaf) {
            . $InshellisensePwshInit
        }
    }
    "psreadline" {
        # Throws when output is redirected (no VT); keep loading the rest.
        try { Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView } catch {}
    }
    default {
        # Grey suggestions; Right Arrow, End or Shift+Tab accepts them.
        # Throws when output is redirected (no VT); keep loading the rest.
        try { Set-PSReadLineOption -PredictionSource History -PredictionViewStyle InlineView } catch {}
        Set-PSReadLineKeyHandler -Chord Shift+Tab -Function AcceptSuggestion

        # Atuin owns Ctrl+R and Up Arrow for its richer history search.
        if (Get-Command atuin -ErrorAction SilentlyContinue) {
            atuin init powershell | Out-String | Invoke-Expression
        }
    }
}
Remove-Variable MyDotfilesHistoryBackend, MyDotfilesBackendFile
