FROM alpine:edge

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
ENV TERM screen-256color
ENV PUID 1000
ENV PGID 1000
ENV TZ Europe/Helsinki

RUN groupadd -g ${PGID} weechat
RUN useradd -g ${PGID} -u ${PUID} -m -s /bin/bash weechat

RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone
ADD start.sh /home/weechat/start.sh
ADD tmux.conf /home/weechat/.tmux.conf
RUN chown -R weechat:weechat /home/weechat
RUN chmod +x /home/weechat/start.sh

HEALTHCHECK CMD tmux has-session -t weechat

USER weechat
WORKDIR /home/weechat
CMD ./start.sh
