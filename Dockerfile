FROM ubuntu:20.04

# set weechat version
ARG WEE_VERSION=3.2

# add weechat gpg prereqs
RUN apt-get update && apt-get install -y dirmngr gnupg apt-transport-https ca-certificates

# add weechat signing key
RUN apt-key adv --keyserver hkps://keys.openpgp.org --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E

# add weechat apt repo
RUN echo "deb https://weechat.org/ubuntu focal main" | tee /etc/apt/sources.list.d/weechat.list
RUN echo "deb-src https://weechat.org/ubuntu focal main" | tee -a /etc/apt/sources.list.d/weechat.list

# set locale variables
ENV LANG en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8
ENV TERM screen-256color
ENV TZ Europe/Helsinki

# install tzdata and locales packages, then generate locales
RUN apt-get update && apt-get install -y locales tzdata && locale-gen ${LANG} ${LC_ALL}

# install weechat and tmux
RUN apt-get update && apt-get install -y \
    tmux \
    weechat-curses=$WEE_VERSION-1 \
    weechat-plugins=$WEE_VERSION-1 \
    weechat-python=$WEE_VERSION-1 \
    weechat-perl=$WEE_VERSION-1

# set user variables
ENV PUID 1000
ENV PGID 1000

# create user and group
RUN groupadd -g ${PGID} weechat
RUN useradd -g ${PGID} -u ${PUID} -m -s /bin/bash weechat

# set timezone
RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# add scripts and ensure correct permissions
ADD start.sh /home/weechat/start.sh
ADD tmux.conf /home/weechat/.tmux.conf
RUN chown -R weechat:weechat /home/weechat
RUN chmod +x /home/weechat/start.sh

USER weechat
WORKDIR /home/weechat
CMD ./start.sh
