# Kemal's Dotfiles

![Terminal reference](docs/reference/terminal.png)

Cross-platform development environment configs managed with [chezmoi](https://chezmoi.io).

**Supported platforms:**
- 🪟 Windows (PowerShell 7)
- 🍎 macOS (zsh)
- 🐧 Linux (zsh)

---

## Quick start (full install)

Install everything on a new machine with one command.

### Windows (PowerShell 7)

Run PowerShell as Administrator:

```powershell
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-windows.ps1 | iex
```

Then open a new Windows Terminal PowerShell 7 tab and set the profile font to `JetBrainsMono Nerd Font`.

This installs PowerShell 7, Windows Terminal, chezmoi, Oh My Posh, lf + lfcd,
and `inshellisense` prediction menus. It also asks whether to install the
optional [Win-CodexBar](https://github.com/nesszer/Win-CodexBar) tray app;
the default answer is no.

### WSL / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-wsl.sh | bash
```

This installs base packages, chezmoi, the dotfiles, Oh My Posh, lf + lfcd,
zsh-autosuggestions, zsh-syntax-highlighting, and Atuin history search. It also
sets zsh as the default shell. The Avenox Claude Code status line is included.
If Waybar is already installed, the bootstrap asks whether to install the
optional codexbar-waybar integration; the default answer is no.

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-macos.sh | bash
```

This installs the same zsh-autosuggestions + zsh-syntax-highlighting stack,
Atuin history search, Oh My Posh, lf + lfcd, and the Avenox Claude Code status
line. It asks whether to install the optional CodexBar menu-bar app; the default
answer is no.

CodexBar prompts only run from the full bootstrap scripts. A normal
`chezmoi update` never installs or updates CodexBar. For unattended bootstrap,
set `DOTFILES_INSTALL_CODEXBAR=1` to opt in or `0` to skip the prompt.

---

## Partial install (just one tool)

Want the full WSL/Linux setup or just one tool? Run a single script.

### Available tools

| Tool | Description | Install script |
|---|---|---|
| Windows Bootstrap | Full Windows PowerShell setup | `bootstrap-windows.ps1` |
| Bootstrap | Full WSL/Linux setup | `bootstrap-wsl.sh` |
| macOS Bootstrap | Full macOS setup | `bootstrap-macos.sh` |
| Oh My Posh | Prompt theming | `install-ohmyposh.*` |
| lf | Terminal file manager with `lfcd` shell integration | `install-lf.*` |
| Zsh plugins | Autosuggestions and syntax highlighting for Linux/macOS | `install-zsh-plugins.sh` |
| Atuin | Default Linux/macOS shell history search on Ctrl-R and Up Arrow | `install-atuin.sh` |
| CodexBar | Optional macOS app, Windows tray app, or Linux Waybar integration | `install-codexbar.*` |
| Shell prediction menus | Optional IDE-style below-prompt suggestions via `inshellisense` | `install-shell-predictions.*` |
| PowerShell predictions | Optional PowerShell-native `PSReadLine` ListView suggestions | `install-psreadline-predictions.ps1` |

### One-line installers

**WSL / Linux:**

```bash
# Full WSL/Linux setup
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-wsl.sh | bash

# Oh My Posh
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-ohmyposh.sh | bash

# lf file manager
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-lf.sh | bash

# zsh-autosuggestions + zsh-syntax-highlighting
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-zsh-plugins.sh | bash

# Default Atuin history search
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-atuin.sh | bash

# Optional inshellisense prediction menus (selects it on this machine)
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-shell-predictions.sh | bash

# Optional codexbar-waybar (only when Waybar is already installed)
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-codexbar.sh | bash
```

**Windows (PowerShell):**

```powershell
# Full Windows PowerShell setup
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-windows.ps1 | iex

# Oh My Posh
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-ohmyposh.ps1 | iex

# lf file manager
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-lf.ps1 | iex

# Default live prediction menus via inshellisense
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-shell-predictions.ps1 | iex

# Optional PSReadLine ListView predictions instead of inshellisense
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-psreadline-predictions.ps1 | iex

# Optional Win-CodexBar tray app
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-codexbar.ps1 | iex
```

**macOS:**

```bash
# Full macOS setup
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-macos.sh | bash

# Optional CodexBar menu-bar app
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-codexbar.sh | bash
```

---

## What's in this repo

```
dotfiles/
├── home/                          # chezmoi-managed files (auto-applied)
│   ├── dot_zshrc                  # → ~/.zshrc (macOS)
│   ├── dot_bashrc                 # → ~/.bashrc (Linux)
│   ├── dot_config/                # -> ~/.config/
│   │   ├── shell/lfcd.sh
│   │   └── starship.toml
│   ├── dot_claude/                # Claude settings + Avenox status line
│   ├── dot_codex/                 # Codex config, rules, and native status line
│   └── AppData/                   # Windows-only files
│       └── Local/...
├── scripts/                       # Standalone single-tool installers
│   ├── bootstrap-windows.ps1
│   ├── bootstrap-wsl.sh
│   ├── bootstrap-macos.sh
│   ├── install-ohmyposh.sh
│   ├── install-lf.ps1
│   ├── install-lf.sh
│   ├── install-zsh-plugins.sh
│   ├── install-atuin.sh
│   ├── install-codexbar.ps1
│   ├── install-codexbar.sh
│   ├── install-shell-predictions.ps1
│   ├── install-shell-predictions.sh
│   ├── install-psreadline-predictions.ps1
│   └── ...
└── docs/                          # Setup notes
```

Oh My Posh uses the built-in `atomic` theme on PowerShell, bash, and zsh.

Shell history/prediction defaults:

- PowerShell/Windows: `inshellisense` shell plugin
- Zsh on WSL/Linux and macOS: Atuin-backed grey suggestions rendered by
  `zsh-autosuggestions`, command highlighting via `zsh-syntax-highlighting`,
  and Atuin search on `Ctrl-R` and Up Arrow

Atuin owns both `Ctrl-R` and Up Arrow for its richer history search. Grey inline
suggestions prefer Atuin's database and fall back to local Zsh history, with
`zsh-autosuggestions` handling their display and acceptance through Right
Arrow, End, or Shift+Tab. `zsh-syntax-highlighting` is sourced last so it can
wrap all ZLE widgets created by Atuin and zsh-autosuggestions. Oh My Posh,
lfcd, Atuin, and both Zsh plugins share the same managed `.zshrc`.

On WSL/Linux, `install-shell-predictions.sh` remains an optional alternative.
It installs `inshellisense` and writes the machine-local selection to
`~/.config/shell/history-backend`. In that mode neither the Zsh plugins nor
Atuin is loaded, so the interfaces do not compete. Run `install-atuin.sh` to
switch back. A normal `chezmoi update` installs/refreshes the Zsh plugins and
migrates existing WSL installs to Atuin; it
disables the inshellisense shell hook but does not uninstall the package.

On Windows, `PSReadLine` ListView is still available as an optional alternative. The prediction installers are intentionally mutually exclusive:

- `install-shell-predictions.ps1` enables `inshellisense` and removes PSReadLine prediction hooks from `$PROFILE`.
- `install-psreadline-predictions.ps1` enables PSReadLine `ListView` and removes the `inshellisense` profile hook.

This only changes profile integration; it does not uninstall the other tool.

### AI usage bars and status lines

CodexBar is deliberately opt-in and independent of Chezmoi updates:

- macOS installs the official CodexBar Homebrew cask when accepted.
- Windows installs `Finesssee.Win-CodexBar` through Winget when accepted.
- Linux offers codexbar-waybar only when `waybar` is already on `PATH`. Its
  installer adds the module files and CSS, but intentionally leaves the final
  `"custom/codexbar"` placement in the user's Waybar layout manual.

Claude Code on Linux and macOS uses the vendored
[Avenox status line](https://github.com/avenoxai/avenoxstatusline), refreshed
every three seconds. It needs `bash`, `git`, and `jq`; the full Linux/macOS
bootstraps install these dependencies. Native Windows is excluded because the
upstream status line is documented and tested for macOS/Linux Bash.

Codex cannot run the Avenox Claude `statusLine` command. It uses Codex's native
`tui.status_line` configuration instead; this repo already enables model and
reasoning, context remaining, five-hour and weekly limits, run/task state, and
approval mode.

---

## Pull just one file with chezmoi

If you already have chezmoi installed and only want one config:

```bash
chezmoi init https://github.com/KBT-0/MyDotfiles.git  # clone without applying
chezmoi cd                                          # go to source dir
# inspect or selectively copy what you want
chezmoi apply ~/.zshrc                              # apply just .zshrc
```

---

## Update an existing install

```bash
chezmoi update          # pull latest + apply
chezmoi diff            # preview what would change
chezmoi apply -v        # apply (verbose)
```

These commands update the managed Avenox script, but they do not install or
upgrade any optional CodexBar app or Waybar integration.

---

## Editing dotfiles

Don't edit `~/.zshrc` directly — edit it through chezmoi:

```bash
chezmoi edit ~/.zshrc       # opens the source file in $EDITOR
chezmoi apply               # applies your changes
chezmoi cd                  # cd into the source repo
git add . && git commit -m "tweak zsh" && git push
```

---

## Sources

- chezmoi: https://github.com/twpayne/chezmoi
- Oh My Posh: https://github.com/JanDeDobbeleer/oh-my-posh
- lf: https://github.com/gokcehan/lf
- zsh-autosuggestions: https://github.com/zsh-users/zsh-autosuggestions
- zsh-syntax-highlighting: https://github.com/zsh-users/zsh-syntax-highlighting
- atuin: https://github.com/atuinsh/atuin
- CodexBar (macOS/CLI): https://github.com/steipete/CodexBar
- Win-CodexBar: https://github.com/nesszer/Win-CodexBar
- codexbar-waybar: https://github.com/Marouan-chak/codexbar-waybar
- avenoxstatusline: https://github.com/avenoxai/avenoxstatusline
- inshellisense: https://github.com/microsoft/inshellisense
- PSReadLine: https://github.com/PowerShell/PSReadLine
- Starship: https://github.com/starship/starship
- fzf: https://github.com/junegunn/fzf

---

## License

MIT — feel free to copy anything you find useful.
