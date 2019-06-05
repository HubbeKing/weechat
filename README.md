# Weechat in Docker

Only really useful for me, because of the PGID/PUID/TZ env values. Feel free to tweak, though.
I couldn't get it to work right with an entrypoint script so I could have them passed as envs in docker-compose...

Uses linuxserver.io-style environment variables for timezone and user UID and GID. (See Dockerfile)
