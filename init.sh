#!/bin/bash

PUID=${PUID:-911}
PGID=${PGID:-911}
TZ=${TZ:Europe/London}

groupmod -o -g "$PGID" weechat
usermod -o -u "$PUID" weechat
ln -snf /usr/share/zoneinfo/"$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

chown weechat:weechat ~weechat

su - weechat -c "tmux -2 new-session -d -s weechat weechat"
