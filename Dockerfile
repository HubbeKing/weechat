FROM alpine

RUN apk add --update \
    bash \
    python \
    shadow \
    tmux \
    tzdata \
    weechat \
    weechat-aspell \
    weechat-ruby \
    weechat-lua \
    weechat-perl \
    weechat-python

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color
ENV HOME /weechat
ENV PUID 1000
ENV PGID 1000
ENV TZ Europe/Helsinki

RUN addgroup weechat && \
    adduser -h ${HOME} -D -s /bin/bash -G weechat weechat

ADD tmux.conf ${HOME}/.tmux.conf

RUN groupmod -o -g "${PGID}" weechat
RUN usermod -o -u "${PUID}" weechat
RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone
RUN chown -R weechat:weechat ${HOME}

VOLUME ${HOME}

USER weechat
# TODO find a better way to keep docker from killing the container just because tmux is detached, because holy crap is this hacky
CMD ["bash", "-c", "tmux new -d -s weechat weechat --dir ${HOME} && tail -f /dev/null"]
