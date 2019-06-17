#!/bin/bash

# TODO use actual signal to exit rather than TERM?
# trap SIGTERM signal and cleanly exit weechat before exiting script
_term() {
  echo "*/quit" > /home/weechat/.weechat/weechat_fifo
  exit 0
}

trap _term SIGTERM

# start tmux daemonized weechat and then wait forever
tmux new -d -s weechat weechat &
wait
