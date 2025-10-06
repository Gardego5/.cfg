export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="~/.scripts/:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

export EDITOR=nvim

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
setopt PROMPT_SUBST
PROMPT="%F{08}[%F{blue}%n%F{08}%F{08}:%F{red}%U%25<...<%~%<<%u%F{08}]%f%(!.#.$) "
RPROMPT='$(function () {
  BRANCH=$(git branch --show 2> /dev/null)
  if [ $? -eq 0 ]; then
    DIRTY_MARK=$([ ! -z "$(git status --porcelain 2> /dev/null)" ] && echo "*")
    echo "%F{08}(%F{yellow}$BRANCH%F{red}$DIRTY_MARK%F{08})%f"
  fi
})'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

source <(fzf --zsh)
autoload -Uz compinit && compinit
