#!/bin/bash

#set -x

SESSION_NAME="frantz"
#logfile="~/.tmux/log/setup-tmux-`date +%Y-%m-%d`.log"
#touch $logfile
#exec >> $logfile 2>&1

# Don't spin up a new session if one exists.
tmux list-sessions | grep $SESSION_NAME | grep attached > /dev/null
if [ $? -eq 0 ]; then
    echo "Existing session '$SESSION_NAME' detected with attached client. Nothing to do here."
    exit 1
fi
# Start a new session but don't attach just yet.
tmux new-session -s $SESSION_NAME -d 

# TODO: Get smart and look for windows with the same index/name pair.
# Open a few windows. My ~/.tmux.conf starts indices at 1.
# There may already be a 1st window. If not, create it; if so, roll widdit.
tmux list-window | grep ^1 > /dev/null
if [ $? != 0 ]; then
    tmux new-window -t $SESSION_NAME:1 -n main
fi
tmux rename-window -t $SESSION_NAME:1 main
tmux new-window -t $SESSION_NAME:2 -n jumphost 'mosh jumphost.example.com'
tmux rename-window -t $SESSION_NAME:2 jumphost
#tmux new-window -t $SESSION_NAME:3 -n 'frantzipan' 'weechat'

# Start on the second window.
tmux select-window -t $SESSION_NAME:2

# Attach to our session.
tmux attach-session -t $SESSION_NAME
