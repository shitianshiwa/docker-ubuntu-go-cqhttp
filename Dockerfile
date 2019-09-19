FROM oott123/novnc:v0.2.2

COPY ./docker-root /

RUN wget -O - -nc https://dl.winehq.org/wine-builds/Release.key | apt-key add - && \
    apt-add-repository -y https://dl.winehq.org/wine-builds/ubuntu && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
        software-properties-common apt-transport-https \
        cabextract unzip python-numpy \
        language-pack-zh-hans tzdata ttf-wqy-microhei && \
    apt-get install -y --allow-unauthenticated --install-recommends winehq-devel && \
    wget -O /usr/local/bin/winetricks https://github.com/Winetricks/winetricks/raw/master/src/winetricks && \
    chmod 755 /usr/local/bin/winetricks && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN sudo -Hu user WINEARCH=win32 /usr/bin/wine wineboot && \
    sudo -Hu user mkdir -p /home/user/.wine/drive_c/windows/Resources/Themes/luna/ && \
    sudo -Hu user cp /tmp/luna.msstyles /home/user/.wine/drive_c/windows/Resources/Themes/luna/luna.msstyles && \
    sudo -Hu user /usr/bin/wine regedit.exe /s /tmp/coolq.reg && \
    sudo -Hu user wineboot && \
    echo 'quiet=on' > /etc/wgetrc && \
    sudo -Hu user /usr/local/bin/winetricks -q dotnet45 && \
    sudo -Hu user /usr/local/bin/winetricks -q win7 && \
    sudo -Hu user /usr/local/bin/winetricks -q /tmp/winhttp_2ksp4.verb && \
    sudo -Hu user /usr/local/bin/winetricks -q msscript && \
    sudo -Hu user /usr/local/bin/winetricks -q fontsmooth=rgb && \
    wget https://dlsec.cqp.me/docker-simsun -O /tmp/simsun.zip && \
    mkdir -p /home/user/.wine/drive_c/windows/Fonts && \
    unzip /tmp/simsun.zip -d /home/user/.wine/drive_c/windows/Fonts && \
    mkdir /home/user/coolq && \
    chsh -s /bin/bash user && \
    rm -rf /home/user/.cache /tmp/* /etc/wgetrc

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    COOLQ_URL=http://dlsec.cqp.me/cqa-tuling

VOLUME ["/home/user/coolq"]
