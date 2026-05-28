#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/vegardx/dotfiles.git"
REPO_DIR="${HOME}/src/github.com/vegardx/dotfiles"

echo "==> Installing Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "    Waiting for Xcode CLI tools to finish installing..."
  until xcode-select -p &>/dev/null; do sleep 5; done
fi

echo "==> Installing Homebrew..."
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Installing git and ansible..."
brew install git ansible

echo "==> Cloning dotfiles repo..."
if [[ ! -d "$REPO_DIR" ]]; then
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
else
  echo "    Already cloned at $REPO_DIR, pulling latest..."
  git -C "$REPO_DIR" pull
fi

echo "==> Installing Ansible collections..."
ansible-galaxy collection install -r "$REPO_DIR/requirements.yml"

echo "==> Running playbook..."
ansible-playbook "$REPO_DIR/site.yml"

echo "==> Done! You may need to restart your shell or log out/in for all changes to take effect."
