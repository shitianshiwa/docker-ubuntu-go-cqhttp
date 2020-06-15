#!/bin/bash
# Set them to empty is NOT SECURE but avoid them display in random logs.
export VNC_PASSWD=''
export USER_PASSWD=''

export TERM=linux
export LC_CTYPE=zh_CN.UTF-8
export WINEDEBUG=-all
export XMODIFIERS=@im=fcitx

cqexe=$(basename $(find ~/coolq -maxdepth 1 -type f -name '*.exe' | head -n 1))

while true; do
    echo "[CQDaemon] Starting CoolQ ...."
    wine ~/coolq/$cqexe /account $COOLQ_ACCOUNT &
    echo "[CQDaemon] Started CoolQ ."
    wait
    echo "[CQDaemon] CoolQ exited, maybe updated."
    echo "[CQDaemon] Searching for the new process ..."
    sleep 3
    cqpid=$(ps x | grep -v grep | grep /$cqexe | head -n 1 | awk '{print $1}')
    if [ "$cqpid" == "" ]; then
        echo "[CQDaemon] No CoolQ process found, start new process ..."
    else
        echo "[CQDaemon] Found CoolQ process, it's okay."
        tail -f /dev/null --pid=$cqpid
    fi
    # 酷Q 退出后直接重启 wine，然后重开。
    # 因为酷Q 更新之类的会自己开回来，所以把整个 wine 干掉重启，比较靠谱
    echo "[CQDaemon] CoolQ exited. Killing wine ..."
    wine wineboot --kill
    wineserver -k9
    echo "[CQDaemon] Killing winedevice plugplay explorer services CQP.exe..."
    ps -ef | grep winedevice.exe | grep -v grep | cut -c 9-15| xargs kill -s 9
    ps -ef | grep plugplay.exe | grep -v grep | cut -c 9-15 | xargs kill -s 9
    ps -ef | grep explorer.exe | grep -v grep | cut -c 9-15 | xargs kill -s 9
    ps -ef | grep services.exe | grep -v grep | cut -c 9-15 | xargs kill -s 9
    ps -ef | grep CQP.exe | grep -v grep | cut -c 9-15 | xargs kill -s 9
    echo "[CQDaemon] CoolQ will start after 3 seconds ..."
    sleep 3
done
