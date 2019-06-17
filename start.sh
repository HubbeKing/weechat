#!/bin/bash

# trap SIGTERM signal, tell weechat to quit, and then wait for tmux to die
# tmux should die when weechat has quit, and then the waits exit in sequence... I think.
_term() {
  echo "*/quit" > /home/weechat/.weechat/weechat_fifo &
  wait
}

trap _term SIGTERM

# start tmux daemonized weechat and then wait forever
tmux new -d -s weechat weechat &
wait
