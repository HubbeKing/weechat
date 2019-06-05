FROM alpine

RUN apk add --update bash shadow weechat

RUN useradd -m weechat

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color

ADD init.sh /init.sh

ENTRYPOINT [ "/init.sh" ]
