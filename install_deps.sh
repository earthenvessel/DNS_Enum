#!/usr/bin/env bash
set -e

echo "[+] Installing dependencies (Kali Linux environment assumed). Requires sudo."

# Update package lists
sudo apt update

# Install required packages
# This includes amass, jq, firefox-esr, git, python3-venv, golang, massdns, seclists, eyewitness
sudo apt install -y amass jq firefox-esr git python3-venv golang massdns seclists eyewitness

# Set up GOPATH if not already set
if [ -z "$GOPATH" ]; then
    export GOPATH=~/go
fi
mkdir -p "$GOPATH/bin"

# Ensure $GOPATH/bin is in PATH for this script
export PATH="$GOPATH/bin:$PATH"

echo "[+] Installing waybackurls..."
go install github.com/tomnomnom/waybackurls@latest

echo "[+] Installing zdns..."
go install github.com/zmap/zdns@latest

# Move waybackurls and zdns to /usr/local/bin for global access if they exist
if [ -f "$GOPATH/bin/waybackurls" ]; then
    sudo mv "$GOPATH/bin/waybackurls" /usr/local/bin/
fi
if [ -f "$GOPATH/bin/zdns" ]; then
    sudo mv "$GOPATH/bin/zdns" /usr/local/bin/
fi

# Attempt to symlink cert.sh and brute_subs.sh if they exist in the same directory as this script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
if [ -f "$SCRIPT_DIR/cert.sh" ]; then
    sudo ln -sf "$SCRIPT_DIR/cert.sh" /usr/local/bin/cert.sh
    sudo chmod +x /usr/local/bin/cert.sh
fi
if [ -f "$SCRIPT_DIR/brute_subs.sh" ]; then
    sudo ln -sf "$SCRIPT_DIR/brute_subs.sh" /usr/local/bin/brute_subs.sh
    sudo chmod +x /usr/local/bin/brute_subs.sh
fi

echo "[+] All dependencies installed and configured!"
echo "You can now run: ./dns_enum.py --domain example.com"
