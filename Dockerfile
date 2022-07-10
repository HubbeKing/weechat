FROM docker.io/library/debian:11

# set weechat version
ARG WEE_VERSION=3.6
# set locale variables
ENV LANG en_GB.UTF-8
ENV LANGUAGE $LANG
ENV LC_ALL $LANG
ENV TZ Europe/Helsinki
# set user variables
ENV PUID 1000
ENV PGID 1000

# add weechat gpg prereqs
RUN apt update && apt install -y dirmngr gnupg apt-transport-https ca-certificates

# create gnupg directory
RUN mkdir -p ~/.gnupg
RUN chmod 700 ~/.gnupg

# import GPG key used to sign weechat repo
RUN mkdir -p /usr/share/keyrings
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/weechat-archive-keyring.gpg --keyserver hkps://keys.openpgp.org --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E

# add weechat apt repo
RUN echo "deb [signed-by=/usr/share/keyrings/weechat-archive-keyring.gpg] https://weechat.org/debian bullseye main" | tee /etc/apt/sources.list.d/weechat.list
RUN echo "deb-src [signed-by=/usr/share/keyrings/weechat-archive-keyring.gpg] https://weechat.org/debian bullseye main" | tee -a /etc/apt/sources.list.d/weechat.list

# install tzdata and locales packages
RUN apt update && apt install -y locales tzdata

# generate locale data
RUN sed -i -e "s/# $LANG UTF-8/$LANG UTF-8/" /etc/locale.gen
RUN echo "LANG='$LANG'" > /etc/default/locale
RUN dpkg-reconfigure --frontend=noninteractive locales
RUN update-locale LANG=$LANG

# install weechat, tmux, and screen, along with whatever terminfo packages we can find
RUN apt update && apt install -y \
    foot-terminfo \
    kitty-terminfo \
    screen \
    terminfo \
    tmux \
    weechat-curses=$WEE_VERSION-1 \
    weechat-plugins=$WEE_VERSION-1 \
    weechat-python=$WEE_VERSION-1 \
    weechat-perl=$WEE_VERSION-1

# create user and group
RUN groupadd -g ${PGID} weechat
RUN useradd -g ${PGID} -u ${PUID} -m -s /bin/bash weechat

# set timezone
RUN ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime && echo "${TZ}" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# add scripts and ensure correct permissions
ADD start.sh /home/weechat/start.sh
RUN chown -R weechat:weechat /home/weechat
RUN chmod +x /home/weechat/start.sh

USER weechat
WORKDIR /home/weechat
CMD ./start.sh
