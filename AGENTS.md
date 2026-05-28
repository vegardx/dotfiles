# bootstrap — machine provisioning

Ansible playbook for bootstrapping macOS machines. Must be fully idempotent —
running it twice should produce no changes on the second run.

## Idempotency rules

### Moving files or symlinks
When a symlink destination changes (e.g. `~/.gitconfig` → `~/.config/git/config`),
add a cleanup task that removes the old path **before** creating the new one.
Use `state: absent` — it's a no-op if the path doesn't exist:

```yaml
- name: Remove legacy symlinks
  ansible.builtin.file:
    path: "{{ ansible_facts.env.HOME }}/{{ item }}"
    state: absent
  loop:
    - .gitconfig
```

### Removing packages or tools
When removing a formula, cask, or tool, add a task with `state: absent` rather
than just deleting it from the install list. Otherwise existing machines keep
the package forever.

### Conditional creates
Use `creates:` or `when:` guards on shell tasks so they don't re-run. A shell
task without a guard is always `changed: true` and breaks idempotency.

### Directory permissions
When creating directories that hold secrets (gnupg, ssh), always set explicit
`mode:` — don't rely on umask.

## Variable naming
- Prefix role-specific variables with the role name (e.g. `macos_dock_tilesize`).
- Use snake_case for all variables.

## macOS defaults
- macOS stores many numeric preferences as floats internally. When in doubt,
  use `type: float` for numeric `osx_defaults` values to avoid type mismatch
  errors.

## Ansible conventions
- Use `ansible_facts.env.HOME`, never `ansible_env.HOME` (deprecated in 2.24).
- `inject_facts_as_vars = false` is set in `ansible.cfg`.
- Use FQCNs for all modules (e.g. `ansible.builtin.file`, not `file`).

## File layout
Dotfiles in `roles/dotfiles/files/` mirror the XDG target structure:
- `config/` → `~/.config/` (git, zsh, ghostty, gnupg, mise, gh, pi)
- `src/` → `~/src/` (AGENTS.md hierarchy)
- `ssh/` → `~/.ssh/`
- `zshenv-bootstrap` → `~/.zshenv` (the only file that stays in home)

## Running
- `make run` — full playbook run
- `make check` — dry run with diff
- `make lint` — ansible-lint
- `make bootstrap` — fresh machine setup (installs Ansible first)
