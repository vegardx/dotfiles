#!/usr/bin/env bash
set -euo pipefail

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

echo "==> Installing Ansible..."
if ! command -v ansible-playbook &>/dev/null; then
  brew install ansible
fi

echo "==> Installing Ansible collections..."
ansible-galaxy collection install -r requirements.yml

echo "==> Running playbook..."
ansible-playbook site.yml

echo "==> Done! You may need to restart your shell or log out/in for all changes to take effect."
