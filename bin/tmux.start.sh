#!/bin/sh
export PATH=$PATH:~/.local/bin:/usr/local/bin
[ "$TMUX" == "" ] || exit 0
tmux has-session -t _default || tmux new-session -s _default -d
PS3="Please choose your session: "
options=("NEW SESSION" "BASH" $(tmux list-sessions -F "#S"))
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
case $opt in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            tmux new -s "$SESSION_NAME"
            break
            ;;
        "BASH")
            bash --login
            break;;
        *)
            tmux attach-session -t $opt
            break
            ;;
    esac
done
