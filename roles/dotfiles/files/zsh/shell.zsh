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
# Clone a repo into ~/src/<host>/<org>/<repo> and cd into it.
# Accepts git URLs, HTTPS URLs, or plain browser URLs.
function clone() {
  local url="$1"
  [[ -z "$url" ]] && { echo "usage: clone <git-url-or-browser-url>" >&2; return 1 }

  local host path
  _parse_git_url "$url" || return 1

  local target="${HOME}/src/${host}/${path}"

  if [[ -d "$target" ]]; then
    echo "Already exists: $target"
    cd "$target"
    return 0
  fi

  local clone_url
  _build_clone_url "$url"

  mkdir -p "$(dirname "$target")"
  git clone "$clone_url" "$target" && cd "$target"
}

# Fork a repo, clone to original org's path, set origin=fork upstream=original.
function fork() {
  local url="$1"
  [[ -z "$url" ]] && { echo "usage: fork <git-url-or-browser-url>" >&2; return 1 }

  command -v gh &>/dev/null || { echo "fork: gh CLI required" >&2; return 1 }

  local host path
  _parse_git_url "$url" || return 1

  local target="${HOME}/src/${host}/${path}"

  if [[ -d "$target" ]]; then
    echo "Already exists: $target"
    cd "$target"
    return 0
  fi

  # Fork on GitHub (idempotent — no-op if already forked)
  gh repo fork "${host}/${path}" --clone=false

  # Resolve URLs via gh (handles GHE SSH usernames correctly)
  local gh_user
  gh_user=$(gh api user --hostname "$host" --jq .login 2>/dev/null) || \
    gh_user=$(gh api user --jq .login)
  local fork_repo="${gh_user}/${path##*/}"
  local fork_url upstream_url
  fork_url=$(gh repo view "${fork_repo}" --hostname "$host" --json sshUrl --jq .sshUrl 2>/dev/null) || \
    fork_url="https://${host}/${fork_repo}.git"
  upstream_url=$(gh repo view "${host}/${path}" --json sshUrl --jq .sshUrl 2>/dev/null) || \
    upstream_url="https://${host}/${path}.git"

  mkdir -p "$(dirname "$target")"
  git clone "$fork_url" "$target" && cd "$target"

  # Set upstream to original repo
  git remote add upstream "$upstream_url"
  git remote set-url origin "$fork_url"

  echo "\nRemotes:"
  git remote -v
}

# Helper: parse a git URL into $host and $path (org/repo only)
function _parse_git_url() {
  local url="$1"

  case "$url" in
    git@*:*)       # git@github.com:org/repo.git
      host="${${url#git@}%%:*}"
      path="${url#*:}"
      ;;
    ssh://*)       # ssh://git@host/org/repo.git
      host="${${url#ssh://}%%/*}"
      host="${host#*@}"
      path="${url#ssh://*${host}/}"
      ;;
    https://*|http://*)  # https://github.com/org/repo[/tree/main/...]
      host="${${url#http*://}%%/*}"
      path="${url#http*://${host}/}"
      ;;
    *)
      echo "unrecognized URL format: $url" >&2
      return 1
      ;;
  esac

  # Strip .git suffix and trailing slash
  path="${path%.git}"
  path="${path%/}"

  # Keep only org/repo (first two path segments)
  local segments=(${(s:/:)path})
  if (( ${#segments[@]} < 2 )); then
    echo "can't determine org/repo from: $url" >&2
    return 1
  fi
  path="${segments[1]}/${segments[2]}"
}

# Helper: build a clone-friendly URL from the parsed host/path
function _build_clone_url() {
  local url="$1"
  case "$url" in
    https://*|http://*)
      clone_url="https://${host}/${path}.git"
      ;;
    *)
      clone_url="$url"
      ;;
  esac
}

# ── Ghostty integration ───────────────────────────────────────────────
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi
