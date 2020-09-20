FROM oott123/novnc:v0.3.0

COPY ./docker-root /

# RUN sed -i 's#/archive.ubuntu.com/#/mirrors.ustc.edu.cn/#g' /etc/apt/sources.list

RUN chown root:root /tmp && \
    chmod 1777 /tmp && \
    apt-get update && \
    apt-get install -y wget software-properties-common apt-transport-https apt-utils && \
    wget -O- -nc https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    apt-add-repository -y 'https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    add-apt-repository -y ppa:cybermax-dexter/sdl2-backport && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        cabextract unzip python-numpy \
        language-pack-zh-hans tzdata fontconfig && \
    apt-get install -y --install-recommends winehq-stable && \
    wget -O /usr/local/bin/winetricks https://github.com/Winetricks/winetricks/raw/master/src/winetricks && \
    chmod 755 /usr/local/bin/winetricks && \
    wget -O /tmp/gecko.tar.gz http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.tar.bz2 && \
    mkdir -p /usr/share/wine/gecko && \
    tar xf /tmp/gecko.tar.gz -C /usr/share/wine/gecko && \
    apt-get update && \
    apt-get install winetricks -y --fix-missing && \
    apt-get install zenity -y && \
    apt-get install ubuntu-restricted-extras -y &&\
    apt-get install firefox -y && \
    apt-get install python python3 python3.8 python-pip python3-pip -y && \
    python2 -m pip install --upgrade pip && \
    python3 -m pip install --upgrade pip && \
    python3.8 -m pip install --upgrade pip && \
    python3 -m pip install numpy BeautifulSoup4 requests lxml selenium html5lib apscheduler && \
    python3.8 -m pip install numpy BeautifulSoup4 lxml selenium html5lib \
    emoji==0.5.4 httpx==0.12.1 feedparser==5.2.1 nonebot==1.5.0 requests==2.21.0 googletrans==2.4.0 apscheduler==3.6.3 pyquery==1.4.1 && \
    apt-get install iftop && \
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
    sudo apt-get install p7zip-full -y && \
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
    sudo cp ./bin/* /usr/local/bin/ && \
    sudo mkdir -p /var/lib/mongo && \
    sudo mkdir -p /var/log/mongodb && \
    sudo chown 777 /var/lib/mongo && \
    sudo chown 777 /var/log/mongodb && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN chsh -s /bin/bash user && \
    su user -c 'WINEARCH=win32 /usr/bin/wine wineboot' && \
    su user -c '/usr/bin/wine regedit.exe /s /tmp/coolq.reg' && \
    su user -c 'wineboot' && \
    echo 'quiet=on' > /etc/wgetrc && \
    su user -c '/usr/local/bin/winetricks -q win7' && \
    su user -c '/usr/local/bin/winetricks -q /tmp/winhttp_2ksp4.verb' && \
    su user -c '/usr/local/bin/winetricks -q msscript' && \
    su user -c '/usr/local/bin/winetricks -q fontsmooth=rgb' && \
    mkdir -p /home/user/.wine/drive_c/windows/Fonts && \
    unzip /tmp/simsun.zip -d /home/user/.wine/drive_c/windows/Fonts && \
    mkdir -p /home/user/.fonts/ && \
    ln -s /home/user/.wine/drive_c/windows/Fonts/simsun.ttc /home/user/.fonts/ && \
    chown -R user:user /home/user && \
    su user -c 'fc-cache -v' && \
    mkdir /home/user/coolq && \
    rm -rf /home/user/.cache/winetricks /tmp/* /etc/wgetrc

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    COOLQ_URL=""

VOLUME ["/home/user/coolq"]
