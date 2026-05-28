# ~/.zsh/plugins.zsh — third-party tool integrations
# vim: ft=zsh
# Order matters: fzf before atuin (both bind Ctrl-R; atuin must win).

# fzf — keybinds (Ctrl-R / Ctrl-T / Alt-C) + completion.
source <(fzf --zsh) 2>/dev/null

# zsh-autosuggestions — greyed-out ghost completions from history
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# mise — polyglot version manager (node, go, terraform, uv)
eval "$(mise activate zsh)"

# gpg-agent TTY + SSH-agent integration
export GPG_TTY=$TTY
autoload -U add-zsh-hook
function _gpg-agent_update-tty_preexec { gpg-connect-agent updatestartuptty /bye &>/dev/null }
add-zsh-hook preexec _gpg-agent_update-tty_preexec
if [[ $(gpgconf --list-options gpg-agent 2>/dev/null | awk -F: '$1=="enable-ssh-support" {print $10}') = 1 ]]; then
  unset SSH_AGENT_PID
  if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  fi
fi
