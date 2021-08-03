#!/bin/sh
export EVENT_NOKQUEUE=1
export PATH=$PATH:~/.local/bin:/usr/local/bin
[ "$TMUX" == "" ] || exit 0
alias tmux-coloured="TERM=xterm-256color tmux"
tmux-coloured has-session -t _default || tmux-coloured new-session -s _default -d
PS3="Please choose your session: "
options=("NEW SESSION" "Zsh" $(tmux-coloured list-sessions -F "#S"))
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
case $opt in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            echo -ne "\033]0;$SESSION_NAME\007"
            tmux-coloured new -s "$SESSION_NAME"
            break
            ;;
        "Zsh")
            zsh --login
            break;;
        *)
            echo -ne "\033]0;$opt\007"
            tmux-coloured attach-session -t $opt
            break
            ;;
    esac
done
