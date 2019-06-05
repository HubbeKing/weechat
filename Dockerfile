FROM alpine

RUN apk add --update \
    bash \
    python \
    shadow \
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

RUN groupmod -o -g "${PGID}" weechat
RUN usermod -o -u "${PUID}" weechat
RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone
RUN chown -R weechat:weechat ${HOME}

VOLUME ${HOME}

USER weechat
CMD ["bash", "-c", "weechat --dir ${HOME}"]
