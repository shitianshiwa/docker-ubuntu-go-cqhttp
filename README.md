# docker-wine-coolq-dotnet48-autoins

docker-wine-coolq 可以使你通过 Wine 在 Docker 容器中运行 酷Q Air 或 酷Q Pro。本项目仅对 x86_64 平台提供支持，**暂不支持**树莓派、路由器等 Arm 架构硬件。

即使该 dockerfile 仓库使用 GPL 发布，其中下载的软件仍然遵循其最终用户使用许可协议，请确认同意协议后再进行下载使用。

随着版本更新，wine 的 酷Q 并不保证总是可用。若你遇到不可用问题，在严格按照下述步骤执行后仍可复现，请在 [社区](https://cqp.cc/b/issue) 反馈。

## 下载使用

如果你在服务器上使用 `docker` 或者和 docker 兼容的服务，只需执行：

```bash
docker pull coolq/wine-coolq
mkdir coolq && cd coolq
docker run --rm -p 9000:9000 -v `pwd`:/home/user/coolq coolq/wine-coolq
```

即可运行一个 wine-coolq 实例。运行后，访问 `http://你的IP:9000` 可以打开一个 VNC 页面，输入 `MAX8char` 作为密码后即可看到一个 酷Q Air 已经启动。

酷Q 和其数据文件会保存在容器内的 `/home/user/coolq` 文件夹下，映射到主机上则为上述命令第二步创建的文件夹。调整 `-v` 的参数可以改变主机映射的路径。

## 常用示例

### 使用酷Q Pro

```bash
# 请先自行删除老的 coolq 目录
mkdir coolq
docker run --name=coolq -d -p 9000:9000 -v `pwd`/coolq:/home/user/coolq -e COOLQ_URL=http://dlsec.cqp.me/cqp-full coolq/wine-coolq
```

### 设置 VNC 密码

```bash
docker run --name=coolq -d -p 9000:9000 -v `pwd`/coolq:/home/user/coolq -e VNC_PASSWD=12345678 coolq/wine-coolq
```

## 环境变量

在创建 docker 容器时，使用以下环境变量，可以调整容器行为。

* **`VNC_PASSWD`** 设置 VNC 密码。注意该密码不能超过 8 个字符。
* **`COOLQ_ACCOUNT`** 设置要登录 酷Q 的帐号。在第一次手动登录后，你可以勾选“快速登录”功能以启用自动登录，此后， docker 容器启动或 酷Q 异常退出时，便会自动为你登录该帐号。
* **`COOLQ_URL`** 设置下载 酷Q 的地址，默认为 `http://dlsec.cqp.me/cqa-tuling`，即 酷Q Air 图灵版。请确保下载后的文件能解压出 `酷Q Air/CQA.exe` 或 `酷Q Pro/CQP.exe`

## 提示1
* windows系统版本为必须为windows vista才能正常运行net应用
* 可以打开wine配置程序，修改windows系统版本为windows vista以正常运行net应用
* 修复了winetricks打不开窗口的bug
* 增加火狐浏览器,python2、3的pip工具，nodejs
* fcitx是输入法(默认有安装，试一试ctrl+空格？ctrl要用vnc控制台提供的按键)
* im-config(im-switch) 是设置输入法 
* 增加酷Q意外退出会自动清理其相关的进程，以防泄露到外部
* 增加vim，nano，meidainfo，ffmpeg，graphicsmagick，iftop模块 

### 输入法我不知道怎样才能保证可以正常启动。。！9成以上概率启动不了
#### 删除现有的
* apt purge fcitx fcitx-ui-classic fcitx-table-wbpy fcitx-pinyin fcitx-sunpinyin fcitx-googlepinyin fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt4 fcitx-table* -y
* apt autoremove -y
#### 再安装
* sudo apt-get install im-config libapt-pkg-perl -y
* sudo apt-get install --no-install-recommends fcitx fcitx-table-wbpy fcitx-ui-classic fcitx-pinyin fcitx-sunpinyin fcitx-googlepinyin fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt4 fcitx-table* -y
* sudo apt-get install fcitx-m17n -y
* im-config -s fcitx-pinyin
* fcitx restart
* ctrl+5 重载配置
ctrl+alt+b 开启/关闭虚拟键盘
* https://blog.csdn.net/a145127/article/details/82903749
* Linux安装fcitx输入法（命令安装）


## 提示2-可能冻结QQ号的操作
* 异地登录后立刻修改昵称头像（可以先修改再异地登录）
* 新注册的号在机房ip登录（ip真人鉴别有很多，比如这个）
* 机器人大量地发长消息（尤其是抽卡，条件允许可以改用图片抽卡）
* 机器人24小时不停发消息（如果真的有需求可以让两个账号轮班）
* 账号在短时间内加了大量的群（可以慢慢加，最好不超过10个群）
* 大量高危账号在同一个ip登录（可以慢慢加，一台服务器最好不超过5个账号）

## 使用Dockerfile生成的docker镜像
### 安装docker 
* https://docs.docker.com/get-docker/
* https://yeasy.gitbook.io/docker_practice/install
* sudo apt  install docker.io  //按照docker

- 然后检查docker版本：
* sudo docker version

### 生成容器运行
* cd Dockerfile文件所在路径     //跳转到指定路径
* docker build -t coolq-dotnet47:v1.0 .      //生成镜像，可能需要sstap那样的全局tizi才能顺利生成镜像
* mkdir coolq-data-dotnet47  //创建名coolq-data-dotnet47的文件夹
* docker run --name=coolq_dotnet47 -d -p 8080:9000 -v /root/coolq-data-dotnet47:/home/user/coolq -e COOLQ_URL=http://dlsec.cqp.me/cqp-full -e VNC_PASSWD=密码 -e COOLQ_ACCOUNT=QQ号 coolq-dotnet47:v1.0
//运行docker镜像

## 镜像保存重装 
* docker commit -p 容器ID  coolq_dotnet47-backup //备份容器生成镜像备份
* docker save -o ~/coolq_dotnet47-backup.tar coolq_dotnet47-backup //生成本地镜像备份文件
* docker load -i ~/coolq_dotnet47-backup.tar //读取路径中的镜像备份文件

## 常用使用命令
* docker start coolq_dotnet47 //开启
* docker stop coolq_dotnet47 //关闭
* docker restart coolq_dotnet47 //重启
* docker logs coolq_dotnet47 //日志

* docker container ls -a //列出所有容器
* docker container ls //列出运行中的容器
* docker images //列出镜像列表

* sudo docker exec -ti -u root 容器ID   bash //控制台转入容器内部

* docker rm 容器ID //删掉指定容器，需要先停止容器
* docker rmi 镜像ID  //删掉指定镜像，需要先删除所生成的容器
* docker stop $(docker ps -a -q) //停止所有的container
* docker rm $(docker ps -a -q) //删除所有container
* docker rmi $(docker images | grep "^<none>" | awk "{print $3}")//想要删除untagged images，也就是那些id为<None>的image的话可以用。我也不知道是什么。。！
* docker rmi $(docker images -q)//要删除全部image的话

### 让外界ip无法访问VNC控制台,仅服务器自己的ip可以访问。重启的docker容器后会重置为外界可以访问
* iptables -t nat -L -n
* iptables -t nat  -D DOCKER  2
* iptables -t nat -L -n

### 更新
* sudo apt update
* sudo apt-get upgrade -y

### python
- 安装方法可以看Dockerfile
* python2 -m pip install --upgrade pip
* python3 -m pip install --upgrade pip
* python3 -m pip install numpy     # 使用了python3的pip下载了numpy模块
//python2 -m pip install numpy     # 使用Python2的pip下载了numpy
#### python版本
* python --version 
* python3 --version
* python2 -m pip --version 
* sudo pip3 --version

### nodejs
- 安装方法可以看Dockerfile
* sudo npm install -g n
* sudo n lts //长期支持
* sudo n stable //稳定版
* sudo n latest //最新版
* sudo n 8.4.0 //直接指定版本下载
* sudo npm i -g npm
#### 查看node版本
* node -v
* npm -v/npx -v

### 看浏览器的版本
- 安装方法可以看Dockerfile
* phantomjs --version
* firefox --version

### 测网速 
* pip install speedtest-cli
* speedtest //测网速

### 限制全局网速
* git clone  https://github.com/magnific0/wondershaper.git //下载
* cd wondershaper //跳转
* sudo make install //安装
* sudo nano /etc/conf.d/wondershaper.conf //编辑配置文件 ctrl+字母选择功能
* sudo wondershaper -c -a eth0 //解除限速，网卡
* sudo wondershaper -a eth0 -d 12440 -u 12440 //设置限速 网卡，下载，上传

### 包清理
* apt-get autoremove -y
* apt-get clean

## 特殊
### 启动linux任务管理器
* top //可以按1，显示更多

### Linux流量监控工具
* apt-get install iftop //安装

#### iftop界面相关说明
- 界面上面显示的是类似刻度尺的刻度范围，为显示流量图形的长条作标尺用的。
- 中间的<= =>这两个左右箭头，表示的是流量的方向。
- TX：发送流量
- RX：接收流量
- TOTAL：总流量
- Cumm：运行iftop到目前时间的总流量
- peak：流量峰值
- rates：分别表示过去 2s 10s 40s 的平均流量

#### 相关参数
- -i 设定监测的网卡，如：# iftop -i eth1
- -B 以bytes为单位显示流量(默认是bits)，如：# iftop -B
- -n 使host信息默认直接都显示IP，如：# iftop -n
- -N 使端口信息默认直接都显示端口号，如: # iftop -N
- -F 显示特定网段的进出流量，如# iftop -F 10.10.1.0/24或# iftop -F 10.10.1.0/255.255.255.0
- -h（display this message），帮助，显示参数信息
- -p 使用这个参数后，中间的列表显示的本地主机信息，出现了本机以外的IP信息;
- -b 使流量图形条默认就显示;
- -f 这个暂时还不太会用，过滤计算包用的;
- -P 使host信息及端口信息默认就都显示;
- -m 设置界面最上边的刻度的最大值，刻度分五个大段显示，例：# iftop -m 100M

- Linux流量监控工具 - iftop (最全面的iftop教程) - VPS侦探
- https://www.vpser.net/manage/iftop.html

#### 其它
Ubuntu下查看实时网络流量的几种方法_运维_李谦的博客-CSDN博客
https://blog.csdn.net/weixin_39198406/article/details/79267687

#### Permission denied
- 权限不足，可以通过对其进行授权的方式解决：
* sudo chmod -R 777 usr
- R 是指级联应用到目录里的所有子目录和文件
- 777 是所有用户都拥有最高权限

### 防火墙
- ubuntu 默认防火墙安装、启用、查看状态 - VincentZhu - 博客园
- https://www.cnblogs.com/OnlyDreams/p/7210914.html

。。。
