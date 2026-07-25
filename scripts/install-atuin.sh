#!/usr/bin/env bash
# Install and select Atuin as the Bash/Zsh history UI.

set -euo pipefail

ATUIN_BIN="${ATUIN_BIN:-$HOME/.atuin/bin/atuin}"
BACKEND_FILE="$HOME/.config/shell/history-backend"

if [ ! -x "$ATUIN_BIN" ]; then
    if ! command -v curl >/dev/null 2>&1; then
        echo "Need curl to install Atuin." >&2
        exit 1
    fi

    echo "==> Installing Atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf \
        https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh |
        sh -s -- --no-modify-path
else
    echo "==> Atuin already installed: $ATUIN_BIN"
fi

if [ ! -x "$ATUIN_BIN" ]; then
    echo "Atuin installation finished, but '$ATUIN_BIN' was not created." >&2
    exit 1
fi

# Atuin 18.17 and older use an external Bash preexec hook. Newer versions can
# also use this file, so keeping it makes the integration work across versions.
if [ ! -f "$HOME/.bash-preexec.sh" ]; then
    echo "==> Installing the Bash preexec hook..."
    curl --proto '=https' --tlsv1.2 -LsSf \
        https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh \
        -o "$HOME/.bash-preexec.sh"
fi

mkdir -p "$(dirname "$BACKEND_FILE")"
printf '%s\n' "atuin" > "$BACKEND_FILE"

echo ""
echo "==> Done. Atuin is selected on this machine: $("$ATUIN_BIN" --version)"
echo "==> Restart your shell. Ctrl-R and Up Arrow will open Atuin history search."
echo "==> Existing history can be imported later with: atuin import auto"
