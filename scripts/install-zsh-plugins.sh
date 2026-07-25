#!/usr/bin/env bash
# Install or update the shared Zsh suggestion and highlighting plugins.

set -euo pipefail

PLUGIN_ROOT="${ZSH_PLUGIN_ROOT:-$HOME/.local/share/zsh/plugins}"

clone_or_update() {
    local repo_url="$1"
    local target_dir="$2"

    if [ -d "$target_dir/.git" ]; then
        echo "==> Updating $(basename "$target_dir")..."
        git -C "$target_dir" pull --ff-only
    elif [ -e "$target_dir" ]; then
        echo "Cannot install into existing non-git path: $target_dir" >&2
        exit 1
    else
        echo "==> Installing $(basename "$target_dir")..."
        git clone --depth 1 "$repo_url" "$target_dir"
    fi
}

if ! command -v git >/dev/null 2>&1; then
    echo "Need git to install Zsh plugins." >&2
    exit 1
fi

mkdir -p "$PLUGIN_ROOT"
clone_or_update \
    https://github.com/zsh-users/zsh-autosuggestions.git \
    "$PLUGIN_ROOT/zsh-autosuggestions"
clone_or_update \
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$PLUGIN_ROOT/zsh-syntax-highlighting"

echo ""
echo "==> Done. Zsh autosuggestions and syntax highlighting are installed."
