#!/usr/bin/env zsh 

# env var set in .zshrc
SESSION=home

tmux has-session -t $SESSION 2>/dev/null

if [ $? -eq 0 ]; then
  # if the session exists, reattach to it
  tmux attach-session -t $SESSION
else
  # if the session doesn't exist, start a new one
  tmux new-session -s $SESSION -d
  tmux attach-session -t $SESSION
fi
