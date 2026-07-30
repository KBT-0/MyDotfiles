#!/usr/bin/env bash
# Install the platform-appropriate CodexBar integration on macOS or Waybar Linux.

set -euo pipefail

CODEXBAR_WAYBAR_REF="${CODEXBAR_WAYBAR_REF:-620281e66e2aa2e4ab72706e674e3797b4e84d94}"
CODEXBAR_WAYBAR_ARCHIVE="https://github.com/Marouan-chak/codexbar-waybar/archive/${CODEXBAR_WAYBAR_REF}.tar.gz"
CODEXBAR_RELEASE_API="https://api.github.com/repos/steipete/CodexBar/releases/latest"
LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-$HOME/.local/bin}"
CODEXBAR_TEMP_DIR=""

cleanup() {
    if [ -n "$CODEXBAR_TEMP_DIR" ] && [ -d "$CODEXBAR_TEMP_DIR" ]; then
        rm -rf "$CODEXBAR_TEMP_DIR"
    fi
}

trap cleanup EXIT

run_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Need sudo or root privileges to install CodexBar dependencies." >&2
        exit 1
    fi
}

install_macos() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew is required. Run scripts/bootstrap-macos.sh first." >&2
        exit 1
    fi

    if brew list --cask codexbar >/dev/null 2>&1; then
        echo "==> CodexBar is already installed."
        return
    fi

    echo "==> Installing CodexBar for macOS..."
    brew install --cask codexbar
}

install_linux_dependencies() {
    echo "==> Installing codexbar-waybar dependencies..."

    if command -v apt-get >/dev/null 2>&1; then
        run_root apt-get update
        run_root apt-get install -y jq python3-gi gir1.2-gtk-4.0 gir1.2-gtk4layershell-1.0 gcc
    elif command -v dnf >/dev/null 2>&1; then
        run_root dnf install -y jq python3-gobject gtk4 gtk4-layer-shell libadwaita gcc
    elif command -v pacman >/dev/null 2>&1; then
        run_root pacman -S --needed --noconfirm jq python-gobject gtk4 gtk4-layer-shell libadwaita gcc libxml2-legacy
    else
        echo "Unsupported package manager. Install jq, PyGObject, GTK4, gtk4-layer-shell, and a C compiler, then re-run." >&2
        exit 1
    fi
}

codexbar_arch() {
    case "$(uname -m)" in
        x86_64|amd64) echo "x86_64" ;;
        aarch64|arm64) echo "aarch64" ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            return 1
            ;;
    esac
}

install_codexbar_cli() {
    local release_json tag arch asset_name asset_url checksum_url
    local archive checksum

    if command -v codexbar >/dev/null 2>&1; then
        echo "==> CodexBar CLI is already installed: $(command -v codexbar)"
        return
    fi

    echo "==> Resolving the latest CodexBar CLI release..."
    release_json="$(curl -fsSL "$CODEXBAR_RELEASE_API")"
    tag="$(printf '%s' "$release_json" | jq -er '.tag_name')"
    arch="$(codexbar_arch)"
    asset_name="CodexBarCLI-${tag}-linux-${arch}.tar.gz"
    asset_url="$(printf '%s' "$release_json" | jq -er --arg name "$asset_name" \
        '.assets[] | select(.name == $name) | .browser_download_url')"
    checksum_url="$(printf '%s' "$release_json" | jq -er --arg name "${asset_name}.sha256" \
        '.assets[] | select(.name == $name) | .browser_download_url')"

    CODEXBAR_TEMP_DIR="$(mktemp -d)"
    archive="$CODEXBAR_TEMP_DIR/$asset_name"
    checksum="$archive.sha256"

    echo "==> Downloading CodexBar CLI $tag..."
    curl -fL "$asset_url" -o "$archive"
    curl -fL "$checksum_url" -o "$checksum"
    (
        cd "$CODEXBAR_TEMP_DIR"
        sha256sum -c "${asset_name}.sha256"
    )
    tar -xzf "$archive" -C "$CODEXBAR_TEMP_DIR"

    mkdir -p "$LOCAL_BIN_DIR"
    install -m 0755 "$CODEXBAR_TEMP_DIR/CodexBarCLI" "$LOCAL_BIN_DIR/codexbar"
    export PATH="$LOCAL_BIN_DIR:$PATH"
    echo "==> Installed CodexBar CLI: $LOCAL_BIN_DIR/codexbar"

    cleanup
    CODEXBAR_TEMP_DIR=""
}

install_waybar_module() {
    local archive source_dir

    CODEXBAR_TEMP_DIR="$(mktemp -d)"
    archive="$CODEXBAR_TEMP_DIR/codexbar-waybar.tar.gz"
    source_dir="$CODEXBAR_TEMP_DIR/source"

    echo "==> Downloading codexbar-waybar ($CODEXBAR_WAYBAR_REF)..."
    curl -fL "$CODEXBAR_WAYBAR_ARCHIVE" -o "$archive"
    mkdir -p "$source_dir"
    tar -xzf "$archive" -C "$source_dir" --strip-components=1

    PATH="$LOCAL_BIN_DIR:$PATH" bash "$source_dir/install.sh"

    cleanup
    CODEXBAR_TEMP_DIR=""
}

install_linux() {
    if ! command -v waybar >/dev/null 2>&1; then
        echo "Waybar is not installed; codexbar-waybar was not installed." >&2
        exit 1
    fi

    install_linux_dependencies
    install_codexbar_cli
    install_waybar_module

    echo "==> codexbar-waybar installed."
    echo "==> Add \"custom/codexbar\" to your Waybar modules and reload Waybar."
}

case "$(uname -s)" in
    Darwin) install_macos ;;
    Linux) install_linux ;;
    *)
        echo "Unsupported platform. On Windows use scripts/install-codexbar.ps1." >&2
        exit 1
        ;;
esac
