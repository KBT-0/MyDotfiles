#!/usr/bin/env bash
# Install or refresh the ble.sh Bash line editor from its official nightly build.

set -euo pipefail

BLESH_FILE="${BLESH_FILE:-$HOME/.local/share/blesh/ble.sh}"
BLESH_RELEASE_URL="${BLESH_RELEASE_URL:-https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz}"

if ! command -v curl >/dev/null 2>&1; then
    echo "Need curl to install ble.sh." >&2
    exit 1
fi

if ! command -v tar >/dev/null 2>&1 || ! command -v xz >/dev/null 2>&1; then
    echo "Need tar and xz to install ble.sh." >&2
    exit 1
fi

temp_dir="$(mktemp -d "${TMPDIR:-/tmp}/mydotfiles-blesh.XXXXXXXX")"
trap 'rm -rf "$temp_dir"' EXIT

echo "==> Installing/updating ble.sh..."
curl --proto '=https' --tlsv1.2 -LsSf "$BLESH_RELEASE_URL" \
    -o "$temp_dir/ble-nightly.tar.xz"
tar -xJf "$temp_dir/ble-nightly.tar.xz" -C "$temp_dir"
bash "$temp_dir/ble-nightly/ble.sh" --install "$HOME/.local/share"

if [ ! -r "$BLESH_FILE" ]; then
    echo "ble.sh installation finished, but '$BLESH_FILE' was not created." >&2
    exit 1
fi

echo ""
echo "==> Done. ble.sh is installed at $BLESH_FILE"
echo "==> Restart Bash; Atuin will automatically use the ble.sh preexec backend."
