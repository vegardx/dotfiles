# dotfiles

Ansible playbook to set up a fresh macOS machine.

## Quick start

```bash
# On a fresh Mac — one command to rule them all
bash -c "$(curl -fsSL https://raw.githubusercontent.com/vegardx/dotfiles/main/bootstrap.sh)"
```

This installs Xcode CLI tools, Homebrew, git, and Ansible, clones this repo to `~/src/github.com/vegardx/dotfiles/`, then runs the full playbook.

## Updating

```bash
cd ~/src/github.com/vegardx/dotfiles
git pull
make run
```

## Usage

```bash
make run       # Run the full playbook
make check     # Dry-run with diff output
make lint      # Run ansible-lint
```

Run a specific role:

```bash
ansible-playbook site.yml --tags homebrew
ansible-playbook site.yml --tags dotfiles
ansible-playbook site.yml --tags macos
ansible-playbook site.yml --tags runtimes
```

## Roles

| Role | What it does |
|------|-------------|
| `homebrew` | Installs formulae and casks |
| `dotfiles` | Symlinks shell, git, terminal, and GPG configs |
| `macos` | Applies macOS system preferences, dock, login items |
| `runtimes` | Sets up mise global tools, directory structure, gh extensions |

## Secrets

No secrets are stored in this repo. Sensitive values live in macOS Keychain and are accessed at runtime via mise's `[env]` backtick commands.

After running the playbook, add Keychain entries:

```bash
security add-generic-password -a $LOGNAME -s exa-api-key -w "<value>"
security add-generic-password -a $LOGNAME -s context7-api-key -w "<value>"  # optional, for higher rate limits
```

## Post-setup

Manual steps after the playbook completes:

1. `gh auth login` — authenticate GitHub CLI
2. `gpg --card-status` — set up GPG with YubiKey
3. `colima start` — start Docker runtime
4. `atuin login` — sync shell history (optional)
5. Log out and back in for login items to take effect

## Requirements

- macOS (Apple Silicon)
- Internet connection for initial setup
