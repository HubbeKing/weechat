FROM alpine

RUN useradd -m weechat

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color

RUN apk add --update weechat

ADD init.sh /init.sh

ENTRYPOINT [ "/init.sh" ]
