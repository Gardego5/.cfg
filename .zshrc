export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="~/.scripts/:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)

export EDITOR=nvim

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

source <(fzf --zsh)
autoload -Uz compinit && compinit
