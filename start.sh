#!/bin/bash

# trap SIGTERM signal, tell weechat to quit, and then exit
_term() {
  echo "*/quit" > /home/weechat/.weechat/weechat_fifo && exit 0
}

trap _term SIGTERM

# start screen daemonized weechat
# (using -D -m, when weechat exits, screen exits)
screen -T screen-256color -U -D -m weechat
