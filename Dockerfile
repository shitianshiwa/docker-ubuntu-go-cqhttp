# ./hooks/build latest
# ./hooks/test latest
# ./hooks/build dev
# ./hooks/test dev

### Build and test 'dev' tag locally like
### ./hooks/build dev
### ./hooks/test dev
### or with additional arguments
### ./hooks/build dev 
### ./hooks/test dev --no-cache
### or using the utility
### ./utils/util-hdx.sh Dockerfile 3
### ./utils/util-hdx.sh Dockerfile 4
### The last output line should be '+ exit 0'
### If '+ exit 1' then adjust the version sticker
### variables in script './hooks/env'

ARG BASETAG=latest

FROM accetto/ubuntu-vnc-xfce:${BASETAG} as stage-install

### Be sure to use root user
USER 0

### 'apt-get clean' runs automatically
RUN apt-get update && apt-get install -y \
        firefox \
    && rm -rf /var/lib/apt/lists/*

### Mitigating issue #3 (Firefox 77.0.1 scrambles pages) - rollback to version 76.0.1
### Alternatively install an explicit Firefox version
### http://releases.mozilla.org/pub/firefox/releases/67.0.4/linux-x86_64/en-US/firefox-67.0.4.tar.bz2
# ENV \
#     FIREFOX_VERSION=76.0.1 \
#     FIREFOX_DISTRO=linux-x86_64 \
#     FIREFOX_PATH=/usr/lib/firefox
# RUN mkdir -p ${FIREFOX_PATH} \
#     && wget -qO- http://releases.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/${FIREFOX_DISTRO}/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 \
#         | tar xvj -C /usr/lib/ \
#     && ln -s ${FIREFOX_PATH}/firefox /usr/bin/firefox

### Alternatively install an explicit Firefox version
### http://releases.mozilla.org/pub/firefox/releases/67.0.4/linux-x86_64/en-US/firefox-67.0.4.tar.bz2
# ENV \
#     FIREFOX_VERSION=67.0.4 \
#     FIREFOX_DISTRO=linux-x86_64 \
#     FIREFOX_PATH=/usr/lib/firefox
# RUN mkdir -p ${FIREFOX_PATH} \
#     && wget -qO- http://releases.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/${FIREFOX_DISTRO}/en-US/firefox-${FIREFOX_VERSION}.tar.bz2 \
#         | tar xvj -C /usr/lib/ \
#     && ln -s ${FIREFOX_PATH}/firefox /usr/bin/firefox

FROM stage-install as stage-config

### Arguments can be provided during build
ARG ARG_VNC_USER

ENV VNC_USER=${ARG_VNC_USER:-headless:headless}

WORKDIR ${HOME}
SHELL ["/bin/bash", "-c"]

COPY [ "./src/create_user_and_fix_permissions.sh", "./" ]

COPY ["./src/tmp", "./"]

# RUN sed -i 's#/archive.ubuntu.com/#/mirrors.ustc.edu.cn/#g' /etc/apt/sources.list

RUN chown root:root /tmp && \
    chmod 1777 /tmp && \
    apt-get update && \
    apt-get install -y \
        cabextract unzip python-numpy \
        language-pack-zh-hans tzdata fontconfig && \
    apt-get install python python3 python3.8 python-pip python3-pip -y && \
    python2 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade pip && \
    python3.8 -m pip install --upgrade pip && \
    python3 -m pip install numpy BeautifulSoup4 requests lxml selenium html5lib apscheduler && \
    python3.8 -m pip install numpy BeautifulSoup4 lxml selenium html5lib \
    emoji==0.5.4 httpx==0.12.1 feedparser==5.2.1 nonebot==1.5.0 requests==2.21.0 googletrans==2.4.0 apscheduler==3.6.3 pyquery==1.4.1 ujson==3.2.0 msgpack==1.0.0 && \
    apt-get install iftop -y && \
    apt-get install build-essential chrpath libssl-dev libxft-dev libfreetype6-dev libfreetype6 libfontconfig1-dev libfontconfig1 -y && \
    wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2 -C /usr/local/share/ && \
    ln -s /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/ && \
    apt-get install nodejs npm -y && \
    npm install -g n && \
    n stable && \
    npm i -g npm n && \
    apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev \
    libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
    libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev && \
    apt-get install -y yasm libx264-dev cmake mercurial libfdk-aac-dev libmp3lame-dev nasm libopus-dev libvpx-dev && \
    apt-get install git automake autoconf pkg-config make g++ libtool zlib1g-dev libmms0 libwxbase3.0-0v5 libwxgtk3.0-0v5 -y && \
    wget http://www.penguin.cz/~utx/ftp/amr/amrnb-11.0.0.0.tar.bz2 && \
    tar xvjf amrnb-11.0.0.0.tar.bz2 && \
    cd amrnb-11.0.0.0 && \
    ./configure && \
    make -j4 && make install && cd ../ && \
    wget http://www.penguin.cz/~utx/ftp/amr/amrwb-11.0.0.0.tar.bz2 && \
    tar xvjf amrwb-11.0.0.0.tar.bz2 && \
    cd amrwb-11.0.0.0 && \
    ./configure && \
    make -j4 && make install && cd ../ && \
    wget https://jaist.dl.sourceforge.net/project/opencore-amr/vo-amrwbenc/vo-amrwbenc-0.1.3.tar.gz && \
    tar -xzvf vo-amrwbenc-0.1.3.tar.gz && \
    cd vo-amrwbenc-0.1.3 && \
    ./configure && \
    make -j4 && make install && cd ../ && \
    wget https://jaist.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz && \
    chmod 755 opencore-amr-0.1.5.tar.gz && \
    tar -xzvf opencore-amr-0.1.5.tar.gz && \
    cd opencore-amr-0.1.5 && \
    ./configure && \
    make -j4 && make install && cd ../ && \
    wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/ffmpeg/7:4.2.4-1ubuntu0.1/ffmpeg_4.2.4.orig.tar.xz && \
    chmod 755 ffmpeg_4.2.4.orig.tar.xz && \
    xz -d ffmpeg_4.2.4.orig.tar.xz && \
    tar -xvf ffmpeg_4.2.4.orig.tar && \
    cd ffmpeg-4.2.4 && \
    ./configure \
        --prefix="$HOME/ffmpeg_build" \
        --pkg-config-flags="--static" \
        --extra-cflags="-I$HOME/ffmpeg_build/include" \
        --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
        --bindir="/usr/local/bin/" \
        --enable-gpl \
        --enable-libass \
        --enable-libfdk-aac \
        --enable-libfreetype \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-nonfree \
        --enable-version3 \
        --disable-ffplay \
        --disable-ffprobe \
        --enable-openssl \
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb && \
    make -j4 && make install && cd ../ && \
    apt-get install graphicsmagick -y && \
    npm install gify && \
    wget https://mediaarea.net/download/binary/libzen0/0.4.38/libzen0v5_0.4.38-1_amd64.xUbuntu_18.04.deb && \
    dpkg -i libzen0v5_0.4.38-1_amd64.xUbuntu_18.04.deb && \
    wget https://mediaarea.net/download/binary/libmediainfo0/20.03/libmediainfo0v5_20.03-1_amd64.xUbuntu_18.04.deb && \
    dpkg -i libmediainfo0v5_20.03-1_amd64.xUbuntu_18.04.deb && \
    wget https://mediaarea.net/download/binary/mediainfo/20.03/mediainfo_20.03-1_amd64.xUbuntu_18.04.deb && \
    dpkg -i mediainfo_20.03-1_amd64.xUbuntu_18.04.deb && \
    wget https://mediaarea.net/download/binary/mediainfo-gui/20.03/mediainfo-gui_20.03-1_amd64.xUbuntu_18.04.deb && \
    dpkg -i mediainfo-gui_20.03-1_amd64.xUbuntu_18.04.deb && \
    apt --fix-broken install -y && \
    apt-get install vim nano -y && \
    apt-get install p7zip-full -y && \
    apt-get install whiptail im-config libapt-pkg-perl -y && \
    apt-get install fcitx -y && \
    apt-get install dbus -y && \
    apt-get install fcitx-table-wbpy -y && \
    apt-get install fcitx-ui-classic -y && \
    apt-get install fcitx-pinyin -y && \
    apt-get install fcitx-sunpinyin -y && \
    apt-get install fcitx-googlepinyin -y && \
    apt-get install fcitx-frontend-gtk2 -y && \
    apt-get install fcitx-frontend-gtk3 -y && \
    apt-get install fcitx-frontend-qt4 -y && \
    apt-get install fcitx-table* -y && \
    apt-get install fcitx-m17n -y && \
    im-config -s fcitx && \
    fcitx restart && \
    wget -O mongodb-linux-x86_64-ubuntu1804-4.2.9.tar https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1804-4.2.9.tgz && \
    tar -zxvf mongodb-linux-x86_64-ubuntu1804-4.2.9.tar && \
    cd mongodb-linux-x86_64-ubuntu1804-4.2.9 && \
    cp ./bin/* /usr/local/bin/ && \
    mkdir -p /var/lib/mongo && \
    mkdir -p /var/log/mongodb && \
    chown 777 /var/lib/mongo && \
    chown 777 /var/log/mongodb && \
    chmod 777 /home/headless/.dbshell && \
    chmod 777 /home/headless/.mongorc.js && \
    mkdir /usr/share/fonts/truetype/myfonts && \
    mv /tmp/* /usr/share/fonts/truetype/myfonts/ && \
    mkfontscale && \
    mkfontdir && \
    fc-cache -fv && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists /tmp/* /etc/wgetrc    

### 'sync' mitigates automated build failures
RUN chmod +x \
        ./create_user_and_fix_permissions.sh \
    && sync \
    && ./create_user_and_fix_permissions.sh $STARTUPDIR $HOME \
    && rm ./create_user_and_fix_permissions.sh

FROM stage-config as stage-final

### Arguments can be provided during build
ARG ARG_REFRESHED_AT
ARG ARG_VCS_REF
ARG ARG_VERSION_STICKER
ARG ARG_VNC_BLACKLIST_THRESHOLD
ARG ARG_VNC_BLACKLIST_TIMEOUT
ARG ARG_VNC_RESOLUTION

LABEL \
    any.accetto.description="Headless Ubuntu VNC/noVNC container with Xfce desktop and Firefox" \
    any.accetto.display-name="Headless Ubuntu/Xfce VNC/noVNC container with Firefox" \
    any.accetto.tags="ubuntu, xfce, vnc, novnc, firefox" \
    version-sticker="${ARG_VERSION_STICKER}" \
    org.label-schema.vcs-ref="${ARG_VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/accetto/ubuntu-vnc-xfce-firefox"

ENV \
  REFRESHED_AT=${ARG_REFRESHED_AT} \
  VERSION_STICKER=${ARG_VERSION_STICKER} \
  VNC_BLACKLIST_THRESHOLD=${ARG_VNC_BLACKLIST_THRESHOLD:-20} \
  VNC_BLACKLIST_TIMEOUT=${ARG_VNC_BLACKLIST_TIMEOUT:-0} \
  VNC_RESOLUTION=${ARG_VNC_RESOLUTION:-1360x768}

### Preconfigure Xfce
COPY [ "./src/home/Desktop", "./Desktop/" ]
COPY [ "./src/home/config/xfce4/panel", "./.config/xfce4/panel/" ]
COPY [ "./src/home/config/xfce4/xfconf/xfce-perchannel-xml", "./.config/xfce4/xfconf/xfce-perchannel-xml/" ]
COPY [ "./src/startup/version_sticker.sh", "${STARTUPDIR}/" ]

### Fix permissions
RUN \
    chmod a+wx "${STARTUPDIR}"/version_sticker.sh \
    && "${STARTUPDIR}"/set_user_permissions.sh "${STARTUPDIR}" "${HOME}"

### Switch to non-root user
USER ${VNC_USER}

### Issue #7 (base): Mitigating problems with foreground mode
WORKDIR ${STARTUPDIR}
