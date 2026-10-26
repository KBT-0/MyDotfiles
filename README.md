# Kemal's Dotfiles

![Terminal reference](docs/reference/terminal.png)

Cross-platform development environment configs managed with [chezmoi](https://chezmoi.io).

**Supported platforms:**
- 🪟 Windows (PowerShell 7)
- 🍎 macOS (zsh or fish)
- 🐧 Linux / WSL (zsh or fish), optionally with a Hyprland + Noctalia desktop

---

## Modules

`chezmoi init` asks two questions once per machine and remembers the answers
(`~/.config/chezmoi/chezmoi.toml`):

| Module | Choices | What it controls |
|---|---|---|
| `shell` | `fish` (Linux default), `zsh` (macOS default) | Whether `~/.config/fish` is managed. Windows always uses PowerShell 7. |
| `desktop` | `hyprland-noctalia` (default), `none` | Linux only. Hyprland, Noctalia bar, kitty, uwsm, GTK/Qt themes, btop and the ssh-agent environment. Pick `none` on WSL or servers. |

Change an answer later with `chezmoi init --prompt`.

---

## Quick start (full install)

Install everything on a new machine with one command.

### Windows (PowerShell 7)

Run PowerShell as Administrator:

```powershell
irm https://raw.githubusercontent.com/KBT-0/MyDotfiles/main/scripts/bootstrap-windows.ps1 | iex
```

The managed Windows Terminal settings only touch the theme: dark, and the tab
close button is hidden so switching tabs can't close one (close with
`Ctrl+Shift+W` or middle-click). Profiles and everything else stay local.

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
MyDotfiles/                        # chezmoi source dir (chezmoi cd)
├── .chezmoi.toml.tmpl             # module questions (shell, desktop)
├── .chezmoiignore                 # per-OS / per-module filtering
├── dot_zshrc, dot_bashrc          # → ~/.zshrc, ~/.bashrc
├── dot_config/                    # → ~/.config/
│   ├── fish/                      # fish module: Oh My Posh, Atuin, direnv, fnm
│   ├── shell/lfcd.sh
│   ├── atuin/                     # Atuin history search config
│   ├── nvim/                      # LazyVim-based Neovim config
│   ├── kitty/                     # desktop module: kitty terminal
│   ├── hypr/  noctalia/  uwsm/    # desktop module: Hyprland (Lua config), Noctalia bar
│   ├── gtk-3.0/ gtk-4.0/ qt6ct/   # desktop module: dark GTK/Qt theme
│   ├── btop/  environment.d/      # desktop module: btop, ssh-agent socket
├── dot_claude/                    # Claude Code: settings (merged), CLAUDE.md, status line, notifications
├── dot_codex/                     # Codex config, rules, and native status line
├── AppData/                       # Windows Terminal theme (merged)
├── readonly_Documents/PowerShell/ # Windows $PROFILE
├── run_onchange_after_*.sh.tmpl   # installs/refreshes zsh tools on change
├── archive/                       # old Hyprland config, reference only, never applied
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

Oh My Posh uses the built-in `atomic` theme on PowerShell, bash, zsh, and fish.

The fish module keeps CachyOS's fish defaults and adds Oh My Posh, Atuin
(`Ctrl-R`, Up Arrow), direnv, and fnm (Node version switching on `cd`).

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
██████░░░░ 63% │ 5h 24%  2h12m · 7d 81%  3d4h │ cache 91% │ 💰$5.18 │ +156 -23
```

Model and effort, directory, git branch (`*` = uncommitted changes), PR; then
context usage, 5-hour and weekly limits with time left until each resets,
prompt cache hit ratio, estimated session cost, and lines changed. Linux/macOS
run `~/.claude/statusline.sh` (`bash`, `git`, `jq`; the bootstraps install
them). Windows runs `~/.claude/statusline.ps1` in PowerShell 7 with no extra
dependencies.

The status line also writes the current rate limits to
`~/.claude/rate-limits.json`, so other tools (MyAgentKit's budget guard) can
read them without calling the API.

`~/.claude/settings.json` is merged, not replaced: chezmoi manages only the
shared keys (model, effort, plugins, status line, notifications, hooks) and
leaves machine-local ones such as `env`, `permissions.allow` and `autoMode`
untouched. `~/.claude/CLAUDE.md` holds the global instructions.

### Claude Code notifications

Claude Code's own notification fires at the end of every turn, even when Claude
will keep going (a subagent or workflow still running). The managed hooks
replace it (`preferredNotifChannel: "notifications_disabled"`) and notify only
when Claude is really waiting on you:

| When | Notification |
|---|---|
| Claude asks a question (`AskUserQuestion`) | *Claude · project — Soru soruyor* + the question |
| A permission prompt is waiting | *Claude · project — İzin bekliyor* |
| The turn ended and nothing will resume it | *Claude · project — Cevabını bekliyor* + start of the last message |

- No "waiting" notification while any background task (shell command,
  subagent, workflow, monitor...) or scheduled wakeup is still in flight, because
  Claude resumes by itself. A never-ending one (dev server, `/loop`) therefore
  keeps that session quiet; its questions and permission prompts still notify.
- Background sessions (`claude --bg`, run by the Claude daemon) stay silent:
  they have no terminal to show a popup in, so only their sound would arrive.
- The hook returns the escape sequence in `terminalSequence`, so Claude Code
  writes it to the right terminal itself: kitty (OSC 99), Ghostty/Warp
  (OSC 777), Windows Terminal/WezTerm/iTerm2 (OSC 9). It also works over SSH and in tmux.
- A bell marks the waiting tab: 🔔 in kitty (`bell_on_tab`), the bell icon in
  Windows Terminal. Switching to the tab clears it.
- kitty only: the notification shows up as **Claude** with the Claude icon
  (`~/.claude/notify-icon.png`) instead of kitty's. No popup and no sound if you are
  already looking at that window: the hook asks kitty over its local
  remote-control socket (`allow_remote_control socket-only`), because kitty's
  own `o=unfocused` also swallowed popups while you were in a sibling tab. A
  kitty started before this setting has no socket, so it always notifies until restarted.
  Clicking it (or, in Noctalia, its
  action button) jumps to the tab where Claude is waiting. Each session reuses one
  notification, which closes when you send your next message.
- Hyprland: `focus_on_activate` is enabled for kitty only, so that jump also
  works across workspaces. `Super+N` invokes the latest notification while its
  popup is still on screen.
- A short, soft sound (`~/.claude/notify.wav`) plays via `pw-play`/`paplay`/`afplay`
  or PowerShell's `SoundPlayer`. It is levelled to -26.9 LUFS, the same as the
  freedesktop `message-new-instant` notification sound. kitty's own audio bell is off so it
  doesn't beep twice.
- Phone push notifications over Remote Control (`inputNeededNotifEnabled`,
  `agentPushNotifEnabled`) stay on; they are separate from these.

Linux/macOS/WSL run `~/.claude/notify.sh` (`bash`, `jq`); Windows runs
`~/.claude/notify.ps1`. None of it adds tokens: the hooks print nothing into
Claude's context.

Codex cannot run a status line command. It uses Codex's native
`tui.status_line` configuration instead; this repo enables model and
reasoning, context remaining, five-hour and weekly limits, run/task state, and
approval mode.

---

## Linux desktop (Hyprland + Noctalia)

With `desktop = hyprland-noctalia`:

- **Hyprland** (Lua config under `~/.config/hypr/config/`), started through uwsm.
  `Super+A` opens the notification panel, `Super+N` jumps to the latest notification.
  Windows-style screenshot keys: `Win+Shift+S` region, `PrtSc` all screens,
  `Win+PrtSc` save to `~/Pictures/Screenshots`, `Alt+PrtSc` active window.
- **Noctalia** bar in a Mac-like layout: launcher and workspaces on the left,
  taskbar and media in the centre, tray, volume, clock and notifications on the
  right.
- **kitty**: tab bar on top, always visible. Windows Terminal shortcuts:
  `Ctrl+C` copies when there is a selection and interrupts otherwise, `Ctrl+V`
  pastes, `Ctrl+Shift+D` opens a new tab, `Ctrl+Shift+1…9` switches tabs,
  `Alt+Shift+±/D` splits, `Alt+arrows` moves between splits, right-click
  copies or pastes. Closing a window with a running command asks first.
- Dark GTK 3/4 and Qt (qt6ct) theme, btop, and `SSH_AUTH_SOCK` pointing at the
  systemd ssh-agent socket.

### Neovim

`~/.config/nvim` is a LazyVim setup (based on craftzdog's config) and is applied on every OS.

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
