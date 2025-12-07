#!/bin/bash
export EVENT_NOKQUEUE=1
export PATH=$PATH:~/.local/bin:/usr/local/bin:/opt/homebrew/bin
export TERM=xterm-256color

# Exit if already in tmux or zellij
if [ -n "$TMUX" ] || [ -n "$ZELLIJ" ]; then
    echo "Already in a terminal multiplexer session. Exiting."
    exit 0
fi

tmux has-session -t _default || tmux new-session -s _default -d
COLUMNS=1
PS3="Please choose your session: "
options=("NEW SESSION" "Zsh" $(tmux list-sessions -F "#S"))
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
case $opt in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            printf "\033]0;%s\007" "$SESSION_NAME"
            exec tmux new -s "$SESSION_NAME"
            break
            ;;
        "Zsh")
            exec zsh --login
            break;;
        *)
            printf "\033]0;%s\007" "$opt"
            exec tmux attach-session -t $opt
            break
            ;;
    esac
done
