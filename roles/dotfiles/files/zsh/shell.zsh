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

# ── Functions ─────────────────────────────────────────────────────────
# Clone a repo into ~/src/<host>/<org>/<repo> and cd into it
function clone() {
  local url="$1"
  [[ -z "$url" ]] && { echo "usage: clone <git-url>" >&2; return 1 }

  local host path

  case "$url" in
    git@*:*)       # git@github.com:org/repo.git
      host="${${url#git@}%%:*}"
      path="${url#*:}"
      ;;
    ssh://*)       # ssh://git@host/org/repo.git
      host="${${url#ssh://*/}%%/*}"
      host="${${url#ssh://}%%/*}"
      host="${host#*@}"
      path="${url#ssh://*${host}/}"
      ;;
    https://*|http://*)  # https://github.com/org/repo.git
      host="${${url#http*://}%%/*}"
      path="${url#http*://${host}/}"
      ;;
    *)
      echo "clone: unrecognized URL format: $url" >&2
      return 1
      ;;
  esac

  # Strip .git suffix
  path="${path%.git}"

  local target="${HOME}/src/${host}/${path}"

  if [[ -d "$target" ]]; then
    echo "Already exists: $target"
    cd "$target"
    return 0
  fi

  mkdir -p "$(dirname "$target")"
  git clone "$url" "$target" && cd "$target"
}

# ── Ghostty integration ───────────────────────────────────────────────
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi
