#!/usr/bin/env bash
# Bootstrap macOS with this dotfiles setup.

set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/KBT-0/MyDotfiles.git}"
RAW_BASE_URL="${DOTFILES_RAW_BASE_URL:-https://raw.githubusercontent.com/KBT-0/MyDotfiles/main}"
CHEZMOI_SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-$HOME/.local/share/chezmoi}"

load_brew() {
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

install_homebrew() {
    load_brew

    if command -v brew >/dev/null 2>&1; then
        echo "==> Homebrew already installed: $(command -v brew)"
        return
    fi

    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_brew

    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew installed, but brew is not on PATH. Restart the terminal and re-run this script." >&2
        exit 1
    fi
}

install_base_packages() {
    echo "==> Installing base packages..."
    brew update
    brew install chezmoi git zsh oh-my-posh lf jq
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

should_install_codexbar() {
    local choice="${DOTFILES_INSTALL_CODEXBAR:-}"

    case "$choice" in
        1|true|TRUE|yes|YES|y|Y) return 0 ;;
        0|false|FALSE|no|NO|n|N) return 1 ;;
        "")
            if [ ! -r /dev/tty ]; then
                echo "==> Non-interactive shell: skipping optional CodexBar install."
                return 1
            fi

            printf "==> Install optional CodexBar menu-bar app? [y/N] " > /dev/tty
            IFS= read -r choice < /dev/tty || return 1
            case "$choice" in
                y|Y|yes|YES) return 0 ;;
                *) return 1 ;;
            esac
            ;;
        *)
            echo "Invalid DOTFILES_INSTALL_CODEXBAR value: $choice (use 1 or 0)." >&2
            return 1
            ;;
    esac
}

install_optional_codexbar() {
    if should_install_codexbar; then
        run_repo_script install-codexbar.sh
    else
        echo "==> Optional CodexBar install skipped."
    fi
}

install_jetbrains_font() {
    echo "==> Installing JetBrainsMono Nerd Font..."
    if command -v oh-my-posh >/dev/null 2>&1; then
        oh-my-posh font install JetBrainsMono || true
    fi
}

main() {
    if [ "$(uname -s)" != "Darwin" ]; then
        echo "This script is for macOS only." >&2
        exit 1
    fi

    install_homebrew
    install_base_packages
    apply_dotfiles

    run_repo_script install-ohmyposh.sh
    run_repo_script install-lf.sh
    run_repo_script install-zsh-plugins.sh
    run_repo_script install-atuin.sh
    install_optional_codexbar
    install_jetbrains_font

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
