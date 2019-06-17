# Weechat in Docker ![Build Status](https://img.shields.io/docker/cloud/build/hubbeking/weechat.svg)

Only really useful for me, because of the PGID/PUID/TZ env values. Feel free to tweak, though.
I couldn't get it to work right with an entrypoint script so I could have them passed as envs in docker-compose...

Uses linuxserver.io-style environment variables for timezone and user UID and GID. (See Dockerfile)

If you really want to use it:
  - docker run -d --name weechat hubbeking/weechat
  - docker exec -it $(docker ps -q -f 'name=weechat') tmux attach

Or with compose:
  - docker-compose up -d
  - docker-compose exec weechat tmux attach
