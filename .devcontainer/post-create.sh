#!/bin/bash
# post-create.sh
# Runs during GitHub Codespaces creation to install CLI tools.

set -e

echo "=== 🚀 Installing agy CLI ==="
curl -fsSL https://antigravity.google/cli/install.sh | bash

echo "=== 🍺 Installing Homebrew (Non-Interactive) ==="
# NONINTERACTIVE=1 is required for the Homebrew install script in unattended environments
export NONINTERACTIVE=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Setup Homebrew path in current session environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Persist Homebrew configuration for bash and zsh shells
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"

echo "=== 📦 Installing engram CLI ==="
brew install gentleman-programming/tap/engram

echo "=== 📥 Downloading Go Modules ==="
go mod download

echo "=== 🎉 Setup Completed Successfully! ==="
