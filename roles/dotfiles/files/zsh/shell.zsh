# ~/.zsh/shell.zsh — interactive shell behavior
# vim: ft=zsh

# ── Options ───────────────────────────────────────────────────────────
setopt MULTIOS AUTO_PUSHD AUTO_NAME_DIRS GLOB_COMPLETE PUSHD_MINUS \
       NUMERIC_GLOB_SORT NO_CASE_GLOB EXTENDED_GLOB
setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY \
       HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS \
       HIST_IGNORE_SPACE HIST_NO_STORE EXTENDED_HISTORY \
       HIST_SAVE_NO_DUPS HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS

# ── Completion ────────────────────────────────────────────────────────
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

autoload -U promptinit zcalc zsh-mime-setup
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
promptinit
zsh-mime-setup

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' list-separator 'fREW'

# ── Keybindings ───────────────────────────────────────────────────────
bindkey -v
bindkey '^e' end-of-line
bindkey '^a' beginning-of-line
bindkey '^r' history-incremental-search-backward

# ── Aliases ───────────────────────────────────────────────────────────
alias .='pwd'
alias ..='cd ..'
alias ofd='open $PWD'
alias grep='grep --color=auto'
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true  && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# ── Ghostty integration ───────────────────────────────────────────────
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi
