# Git branch + dirty-state info in the prompt.
# Uses zsh's built-in vcs_info — no external deps.
autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr   '+'
zstyle ':vcs_info:git:*' formats       ' %F{220}(%b%u%c)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{220}(%b|%a%u%c)%f'

setopt PROMPT_SUBST
export PS1='%F{39}%n%F{45}:%F{195}%~${vcs_info_msg_0_} %F{208}λ%f '
