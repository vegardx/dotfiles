# $ZDOTDIR/.zshenv — sourced by EVERY zsh invocation (interactive, non-interactive, script, ssh).
# Keep this file env-only: no aliases, no prompt, no ZLE config, no compinit.
# vim: ft=zsh

typeset -U path PATH fpath FPATH

# Ensure system paths are always present
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Core env
export EDITOR=nano
export PAGER=less
export LESS='-R -M -i -J --mouse'

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export TZ=Europe/Oslo

# PATH — brew shellenv is handled in .zprofile
[[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]] && \
  PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
[[ -d "$HOME/bin" ]]  && PATH="$PATH:$HOME/bin"
[[ -d "$HOME/sbin" ]] && PATH="$PATH:$HOME/sbin"

export PATH

[[ -d /opt/homebrew/opt/coreutils/libexec/gnuman ]] && \
  MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
export MANPATH

# History (XDG-compliant)
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
export HISTSIZE=150000
export SAVEHIST=150000

# Grep colors (alias lives in shell.zsh)
export GREP_COLORS="38;5;230:sl=38;5;240:cs=38;5;100:mt=38;5;161:fn=38;5;197:ln=38;5;212:bn=38;5;44:se=38;5;166"

# fzf → fd
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
