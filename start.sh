#!/bin/bash

# trap SIGTERM signal, tell weechat to quit, and then exit
_term() {
  echo "*/quit" > /home/weechat/.weechat/weechat_fifo && exit 0
}

trap _term SIGTERM

# start tmux daemonized weechat
tmux new -d -s weechat weechat

# every 15 seconds, check if tmux session still exists
# (if weechat dies, tmux session should also die)
# exit container if tmux session is gone
while sleep 15; do
    tmux has-session -t weechat
    TMUX_STATUS=$?
    if [ $TMUX_STATUS -ne 0 ]; then
        echo "tmux weechat session has exited."
        exit 1
    fi
done
