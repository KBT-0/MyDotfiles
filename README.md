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
Atuin history search, and PSReadLine inline suggestions with zsh-style keys. It also asks whether to install the
optional [Win-CodexBar](https://github.com/nesszer/Win-CodexBar) tray app;
the default answer is no.

### WSL / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-wsl.sh | bash
```

This installs base packages, chezmoi, the dotfiles, Oh My Posh, lf + lfcd,
zsh-autosuggestions, zsh-syntax-highlighting, and Atuin history search. It also
sets zsh as the default shell. The Claude Code status line is included.
If Waybar is already installed, the bootstrap asks whether to install the
optional codexbar-waybar integration; the default answer is no.

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-macos.sh | bash
```

This installs the same zsh-autosuggestions + zsh-syntax-highlighting stack,
Atuin history search, Oh My Posh, lf + lfcd, and the Claude Code status
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
| Atuin | Default shell history search on Ctrl-R and Up Arrow | `install-atuin.*` |
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

# Default Atuin history search (selects it on this machine)
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-atuin.ps1 | iex

# Optional inshellisense prediction menus
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/install-shell-predictions.ps1 | iex

# Optional PSReadLine ListView predictions instead of Atuin
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
│   ├── dot_claude/                # Claude settings + status line (sh / ps1)
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

- PowerShell/Windows: the same habits as zsh: Atuin on `Ctrl-R` and Up Arrow,
  grey PSReadLine inline suggestions (Right Arrow, End or Shift+Tab accepts),
  built-in syntax colouring, and the zsh emacs keymap (`Alt+Backspace`,
  `Ctrl+W`, `Alt+D`, `Ctrl+A/E/K/U`) with zsh `WORDCHARS` word boundaries
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

On Windows the managed `$PROFILE` reads the same `~/.config/shell/history-backend`
file. `install-shell-predictions.ps1` selects `inshellisense`,
`install-psreadline-predictions.ps1` selects PSReadLine `ListView`, and
`install-atuin.ps1` switches back. This only changes the selection; it does not
uninstall the other tool.

### AI usage bars and status lines

CodexBar is deliberately opt-in and independent of Chezmoi updates:

- macOS installs the official CodexBar Homebrew cask when accepted.
- Windows installs `Finesssee.Win-CodexBar` through Winget when accepted.
- Linux offers codexbar-waybar only when `waybar` is already on `PATH`. Its
  installer adds the module files and CSS, but intentionally leaves the final
  `"custom/codexbar"` placement in the user's Waybar layout manual.

Claude Code uses the same two-line status line everywhere, refreshed every
three seconds:

```
Opus 5.5 · high │  chezmoi │  main* │ #12
██████░░░░ 63% │ 5h 24% 2h12m · 7d 81% 3d4h │ cache 91% │ 💰$5.18 │ +156 -23
```

Model and effort, directory, git branch (`*` = uncommitted changes), PR; then
context usage, 5-hour and weekly limits with time left until each resets,
prompt cache hit ratio, estimated session cost, and lines changed. Linux/macOS
run `~/.claude/statusline.sh` (`bash`, `git`, `jq`; the bootstraps install
them). Windows runs `~/.claude/statusline.ps1` in PowerShell 7 with no extra
dependencies.

Codex cannot run a status line command. Its native `tui.status_line` is set to
the closest built-in items: model and reasoning, directory, git branch, PR,
context used, five-hour and weekly limits, estimated cost, branch changes,
run/task state, and approval mode.

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

These commands update the managed status line scripts, but they do not install or
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
- inshellisense: https://github.com/microsoft/inshellisense
- PSReadLine: https://github.com/PowerShell/PSReadLine
- Starship: https://github.com/starship/starship
- fzf: https://github.com/junegunn/fzf

---

## License

MIT — feel free to copy anything you find useful.
