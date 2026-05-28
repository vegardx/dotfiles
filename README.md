# bootstrap

Ansible playbook to set up a fresh macOS machine.

## Quick start

```bash
# On a fresh Mac — installs Xcode CLI tools, Homebrew, Ansible, then runs the playbook
./bootstrap.sh

# Or if you already have Ansible
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
```

## Requirements

- macOS (Apple Silicon)
- Internet connection for initial setup
