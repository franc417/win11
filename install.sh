#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#  win11 installer
#  Usage: curl -fsSL https://raw.githubusercontent.com/franc417/win11/main/install.sh | bash
# ══════════════════════════════════════════════════════════════════

set -euo pipefail

REPO="https://raw.githubusercontent.com/franc417/win11/main/win11"
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="win11"

R=$'\033[0;31m'
G=$'\033[0;32m'
Y=$'\033[0;33m'
W=$'\033[1;37m'
D=$'\033[2;37m'
N=$'\033[0m'

echo ""
echo "  Installing ${W}win11${N} ISO downloader..."
echo ""

# Check for curl or wget
if command -v curl &>/dev/null; then
    DL="curl -fsSL"
elif command -v wget &>/dev/null; then
    DL="wget -qO-"
else
    echo "  ${R}✗ Neither curl nor wget found. Install one first.${N}"
    exit 1
fi

# Download
TMP=$(mktemp)
$DL "$REPO" > "$TMP"
chmod +x "$TMP"

# Install to /usr/local/bin (needs sudo) or ~/.local/bin (no sudo)
if [[ -w "$INSTALL_DIR" ]] || sudo -n true 2>/dev/null; then
    sudo mv "$TMP" "${INSTALL_DIR}/${SCRIPT_NAME}"
    INSTALLED_PATH="${INSTALL_DIR}/${SCRIPT_NAME}"
else
    mkdir -p "$HOME/.local/bin"
    mv "$TMP" "$HOME/.local/bin/${SCRIPT_NAME}"
    INSTALLED_PATH="$HOME/.local/bin/${SCRIPT_NAME}"
    # Make sure ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo ""
        echo "  ${Y}⚠ Add this to your shell config (.bashrc / .zshrc):${N}"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
    fi
fi

echo "  ${G}✔ Installed to:${N} ${W}${INSTALLED_PATH}${N}"
echo ""
echo "  Run ${W}win11${N} to start"
echo ""
