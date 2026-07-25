#!/usr/bin/env bash
# Bootstrap a WSL/Linux shell with this dotfiles setup.

set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/KBT-0/MyDotfiles.git}"
RAW_BASE_URL="${DOTFILES_RAW_BASE_URL:-https://raw.githubusercontent.com/KBT-0/MyDotfiles/main}"
CHEZMOI_BIN_DIR="${CHEZMOI_BIN_DIR:-$HOME/.local/bin}"
CHEZMOI_SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-$HOME/.local/share/chezmoi}"

export PATH="$CHEZMOI_BIN_DIR:$HOME/.local/bin:$HOME/bin:$PATH"

run_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Need sudo or root privileges to install packages." >&2
        exit 1
    fi
}

install_base_packages() {
    echo "==> Installing base packages..."

    if command -v dnf >/dev/null 2>&1; then
        run_root dnf update -y
        run_root dnf install -y curl git zsh tar gzip unzip findutils gawk
    elif command -v apt-get >/dev/null 2>&1; then
        run_root apt-get update
        run_root apt-get install -y ca-certificates curl git zsh tar gzip unzip findutils gawk
    elif command -v pacman >/dev/null 2>&1; then
        run_root pacman -Syu --noconfirm
        run_root pacman -S --needed --noconfirm curl git zsh tar gzip unzip findutils gawk
    elif command -v zypper >/dev/null 2>&1; then
        run_root zypper refresh
        run_root zypper install -y curl git zsh tar gzip unzip findutils gawk
    else
        echo "No supported package manager found. Need curl, git, zsh, tar, gzip, unzip, findutils, gawk." >&2
        exit 1
    fi
}

install_chezmoi() {
    if command -v chezmoi >/dev/null 2>&1; then
        echo "==> chezmoi already installed: $(command -v chezmoi)"
        return
    fi

    echo "==> Installing chezmoi..."
    mkdir -p "$CHEZMOI_BIN_DIR"
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$CHEZMOI_BIN_DIR"
}

apply_dotfiles() {
    echo "==> Applying dotfiles from $REPO_URL..."

    if [ -d "$CHEZMOI_SOURCE_DIR/.git" ]; then
        chezmoi update
    else
        chezmoi init --apply "$REPO_URL"
    fi
}

run_repo_script() {
    local script_name="$1"
    local local_script="$CHEZMOI_SOURCE_DIR/scripts/$script_name"
    local remote_script="$RAW_BASE_URL/scripts/$script_name"

    echo "==> Running $script_name..."

    if [ -r "$local_script" ]; then
        bash "$local_script"
    else
        curl -fsSL "$remote_script" | bash
    fi
}

set_default_shell() {
    local zsh_bin current_shell

    zsh_bin="$(command -v zsh)"
    current_shell="$(getent passwd "$(id -un)" | cut -d: -f7)"

    if [ "$current_shell" = "$zsh_bin" ]; then
        echo "==> zsh is already the default shell."
        return
    fi

    echo "==> Setting the default shell to $zsh_bin..."
    run_root chsh -s "$zsh_bin" "$(id -un)"
}

main() {
    install_base_packages
    install_chezmoi
    apply_dotfiles

    run_repo_script install-ohmyposh.sh
    run_repo_script install-lf.sh
    run_repo_script install-zsh-plugins.sh
    run_repo_script install-atuin.sh
    set_default_shell

    echo "==> Re-applying dotfiles after tool installation..."
    chezmoi apply

    echo ""
    echo "==> Done. Restart the terminal or run: exec zsh"
    echo "==> Quick checks:"
    echo "    oh-my-posh --version"
    echo "    lf -version"
    echo "    type lfcd"
    echo "    test -r ~/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
    echo "    test -r ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    echo "    atuin --version"
    echo "    chezmoi status"
}

main "$@"
