http://wiki.ubuntu.org.cn/UbuntuSkills#.E5.AF.BC.E5.85.A5ppa.E6.BA.90.E7.9A.84key.E5.80.BC
http://wiki.ubuntu.org.cn/Qref/Apps#.E6.95.99.E8.82.B2.E7.A7.91.E5.AD.A6

dpkg – Debian 包安装工具 
apt-get – APT 的命令行前端 
aptitude – APT 的高级的字符和命令行前端 
synaptic – 图形界面的 APT 前端 
dselect – 使用菜单界面的包管理工具 
tasksel – Task 安装工具

dpkg-reconfigure - 重新配置已安装的软件包 （如果它是使用 debconf 进行配置的） 
dpkg-source - 管理源码包 
dpkg-buildpackage - 自动生成包文件 
apt-cache - 在本地缓冲区检查包文件

developer(Ubuntu 基本开发环境搭建){
一. 安装C／C＋＋程序的开发环境
1. sudo apt-get install build-essential //安装主要编译工具 包括gcc, g++, make 
2. sudo apt-get install autoconf automake //安装时apt-get 推荐用 automake 代替 automake1.9
3. sudo apt-get install flex bison //flex 经常和自由软件 Bison 语法分析器生成器一起使用
4. sudo apt-get install manpages-dev //安装C语言函数man文档 
5. sudo apt-get install binutils-doc cpp-doc gcc-doc glibc-doc stl-manual //安装相关文档

二. 安装Gnome桌面程序的开发环境
1. sudo apt-get install gnome-core-devel //安装核心文件 
2. sudo apt-get install pkg-config 
3. sudo apt-get install devhelp //安装GTK文档查看程序 
4. sudo apt-get install libglib2.0-doc libgtk2.0-doc //安装 API参考手册及其它帮助文档 
5. sudo apt-get instal glade libglade2-dev //安装GTK界面构造程序 

三. 安装JAVA开发环境
1. sudo apt-get install sun-java6-jdk sun-java6-doc sun-java6-source //安装核心开发用具，相关文档 
2. sudo update-alternatives --config java //通常给出两个或多个JRE选择路径 选择：/usr/lib/jvm/java-1.5.0-sun/jre/bin/java作为你的JAVA运行环境 
3. sudo vim /etc/environment //配置环境变量，添加如下两行： 
CLASSPATH=/usr/lib/jvm/java-6-sun/lib 
JAVA_HOME=/usr/lib/jvm/java-6-sun 
4. sudo apt-get install eclipse //安装eclipse 
5. sudo update-java-alternatives -s java-6-sun //SUN版本的JAVA 设置为系统默认 JDK 
6. sudo vim /etc/jvm //编辑 JVM 配置文件， 将文件中的/usr/lib/jvm/java-6-sun放到配 置文件的顶部 
7. sudo vim /etc/eclipse/java_home //操作如上

四. 从源码编译的一般方法
autoscan 产生 configure.in
aclocal
autoconf
(可选)autoheader
automake --add-missing
./configure --help 可显示帮助，调整compile switch
make 可添加 -j CORE_NUMBER 来加快速度
make check 检测编译结果是否符合要求，有的 Makefile 可能不存在这个功能
sudo make install 如果要安装到全局 就添加超级权限，安装到本用户可以加 --prefix=/path/you/want/to/install
一般安装不需要全部步骤，首先参考 INSTALL 或者 README 这类的文件，一般都有安装提示，或者去直接查看 Makefile 寻找一些开关。或者找一下网络上的教程。

}


archives(查看安装软件时下载包的临时存放目录){
ls /var/cache/apt/archives
如果你有一些自己的deb包需要安装，可以把它们复制到/var/cache/apt/archives目录下，然后就可以使用apt-get install 包名 安装。
使用apt-get install命令比dpkg -i 命令更好，因为apt-get install命令会自动安装依赖的软件包。
pkg -i 命令安装时，则可能会遇到软件包依赖不满足而无法安装的错误。
}

deinstall(备份当前系统安装的所有包的列表){
dpkg --get-selections | grep -v deinstall > ~/somefile
从上面备份的安装包的列表文件恢复所有包
dpkg --set-selections < ~/somefile sudo dselect 或者 sudo apt-get dselect-upgrade
}
yes(安装debian包时自动回答yes){
sudo apt-get install/dselect-upgrade 等命令后，可以加上-y 表示自动回答yes。
但在遇到安装一个未验证的deb包，或者删除一个本质的deb包时，安装过程会终止。
如果再加上
--force-yes
那么不论什么样的情况，apt-get都会执行安装。 但使用这个选项可能会造成系统问题。
}

command(Linux命令执行的几种方式)
{
command &
command在子shell的background运行。后台任务让多成程序能够运行在一个shell里面。
管理这些后台任务的请求需要shell内建的： jobs，fg, bg,和kill。请查看 bash(1)这一小节中的"SIGNALS"，"JOB CONTROL","SHELL BUILTIN COMMANDS".的相关内容。

command1 | command2
command1的标准输出被直接输入到 command2 的标准输入。 两个命令都可能并行地运行。这个被称作pipeline。

command1 ; command2
command1command2被有序的执行。

command1 && command2
command1如果执行成功的话那么再执行command2。只有当command1并且command2都运行成功的话上面的命令序列才会成功返回。

command1 || command2
command1被执行以后，如果不成功的话，command2也会被执行。当command1 或者command2有一个执行成功的话，上面的序列就会返回真值。

command > foo
把command的标准输出重定向到文件foo。（覆盖内容）

command >> foo
把command的标准输出重定向到文件foo。（追加）

command > foo 2>&1
同时把command的标准输出和标准出错信息重定向到文件foo。

command < foo
把command的标准输入重定向到一个文件foo。
}


apt-cache(显示系统安装包的统计信息){apt-cache stats}

apt-cache(显示系统全部可用包的名称){apt-cache pkgnames}

apt-cache(显示包的信息){apt-cache show k3b}

dpkg(查找文件属于哪个包){
dpkg -S|--search ifconfig
dpkg -S ifconfig

或者
sudo wget http://mirrors.163.com/ubuntu/dists/artful/Contents-amd64.gz
sudo zgrep -e ifconfig Contents-amd64.gz

或者
或是用专门的软件包命令：
# aptitude install dlocate  
# 和 slocate 冲突 （locate 的安全版本）
$ dlocate filename         # dpkg -L 和 dpkg -S 的高效代替品
...
# aptitude install auto-apt # 请求式软件包安装工具
# auto-apt update          # 为 auto-apt 建立 db 文件
$ auto-apt search pattern  
# 在所有软件包中搜索 pattern，不论安装与否
}

apt-get(软件包信息){
软件包信息

搜索并显示包文件的信息。编辑 /etc/apt/sources.list，让 APT 指向正确的包文件。
如果想了解 dapper/edgy 中的相应软件包与当前系统安装的软件包有何差别，使用 apt-cache policy — 更好。

# apt-get   check           # 更新缓冲区并检查损坏的软件包
$ apt-cache search  pattern # 按文本描述搜索软件包
$ apt-cache policy  package # 软件包的 priority/dists 信息
$ apt-cache show -a package # 显示所有 dists 中软件包描述信息
$ apt-cache showsrc package # 显示相应源码包的信息
$ apt-cache showpkg package # 软件包调试信息
# dpkg  --audit|-C          # 搜索未完成安装的软件包
$ dpkg {-s|--status} package ... # 已安装软件包描述
$ dpkg -l package ...       # 已安装软件包的状态（每个占一行）rpm -ql package
$ dpkg -L package ...       # 列出软件包安装的文件的名称      rpm -qa package

你也这可这样查看软件包信息（我用 mc 浏览）：

/var/lib/apt/lists/*
/var/lib/dpkg/available

比较下面的文件可以确切了解最近的安装过程对系统造成了那些改变。

/var/lib/dpkg/status
/var/backups/dpkg.status*
}

dpkg(重新配置已安装的软件包){

使用下列方法重新配置已安装的软件包。
# dpkg-reconfigure --priority=medium package [...]
# dpkg-reconfigure --all   # 重新配置所有的软件包
# dpkg-reconfigure locales # 生成额外的 locales
# dpkg-reconfigure --p=low xserver-xfree86 # 重新配置 X 服务器

如果你想永久改变 debconf 对话框模式，可这么做。
某些程序用于生成特殊的配置脚本。
}


d(某些程序用于生成特殊的配置脚本){

apt-setup     - 创建 /etc/apt/sources.list
install-mbr   - 安装主引导（Master Boot Record）管理器
tzconfig      - 设定本地时间
gpmconfig     - 设置 gpm 鼠标 daemon
sambaconfig   - 在 Potato 中配置 Samba（ Woody 使用 debconf 来配置）
eximconfig    - 配置 Exim (MTA)
texconfig     - 配置 teTeX
apacheconfig  - 配置 Apache (httpd)
cvsconfig     - 配置 CVS
sndconfig     - 配置声音系统
...
update-alternatives - 设定默认启动命令，例如设定 vi 启动 vim
update-rc.d         - System-V init 脚本管理工具
update-menus        - Debian 菜单系统

}
dpkg(查看已经安装了哪些包)
{
dpkg -l
也可用
dpkg -l | less
翻页查看
}

apt-cache(查询软件xxx依赖哪些包)
{apt-cache depends xxx}


apt-cache(查询软件xxx被哪些包依赖)
{apt-cache rdepends xxx}

apt-cdrom(增加一个光盘源)
{sudo apt-cdrom add}


apt-get(系统更新)
{
sudo apt-get update (这一步更新包列表)
sudo apt-get dist-upgrade (这一步安装所有可用更新)
或者
sudo apt-get upgrade (这一步安装应用程序更新，不安装新内核等)
}

dpkg(清除所有已删除包的残馀配置文件)
{
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P 
如果报如下错误，证明你的系统中没有残留配置文件了，无须担心。
dpkg: --purge needs at least one package name argument

Type dpkg --help for help about installing and deinstalling packages [*];
Use `dselect' or `aptitude' for user-friendly package management;
Type dpkg -Dhelp for a list of dpkg debug flag values;
Type dpkg --force-help for a list of forcing options;
Type dpkg-deb --help for help about manipulating *.deb files;
Type dpkg --license for copyright license and lack of warranty (GNU GPL) [*].

Options marked [*] produce a lot of output - pipe it through `less' or `more' !
}


auto-apt(编译时缺少h文件的自动处理)
{
sudo auto-apt run ./configure
查看安装软件时下载包的临时存放目录
ls /var/cache/apt/archives
}

dpkg(备份当前系统安装的所有包的列表)
{
dpkg --get-selections | grep -v deinstall > ~/somefile
从上面备份的安装包的列表文件恢复所有包
dpkg --set-selections < ~/somefile
sudo dselect
}

apt-get(清理旧版本的软件缓存)
{sudo apt-get autoclean}

apt-get(清理所有软件缓存)
{sudo apt-get clean}

apt-get(删除系统不再使用的孤立软件)
{
sudo apt-get autoremove
如果使用
sudo apt-get autoremove --purge
的话会把这些孤立软件的残留配置文件也一并移除
查看包在服务器上面的地址

apt-get -qq --print-uris download 软件包名称 | cut -d\' -f2
}

apt-get(彻底删除Gnome)
{sudo apt-get --purge remove liborbit2}

apt-get(彻底删除KDE)
{sudo apt-get --purge remove libqt3-mt libqtcore4}

彻底删除Gnome # apt-get --purge remove liborbit2
彻底删除KDE   # apt-get --purge remove libqt3-mt libqtcore4

tasksel(一键安装 LAMP 服务)
{
sudo tasksel install lamp-server
}

aptitude(删除旧内核)
{sudo aptitude purge ~ilinux-image-.*\(\!\(`uname -r`\|generic-.*\)\)}

aptitude(dpkg删除和清除软件包){
删除软件包但保留其配置文件：

# aptitude remove package ...
# dpkg   --remove package ...

删除软件包并清除配置文件：

# aptitude purge  package ...
# dpkg   --purge  package ...
}

ppa(导入ppa源的key值)
{
#W: GPG签名验证错误： http://ppa.launchpad.net jaunty Release: 由于没有公钥，下列签名无法进行验证： NO_PUBKEY 5126890CDCC7AFE0
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 5126890CDCC7AFE0 #5126890CDCC7AFE0替换为你需要导入的Key值
}

add-apt-repository(增加 add-apt-repository 命令)
{sudo apt-get install software-properties-common}


ppa(增加一个ppa源)
{sudo add-apt-repository ppa:user/ppa-name  
#使用 ppa 的地址替换 ppa:user/ppa-name}

163(添加163镜像源)
{
sudo add-apt-repository "deb http://mirrors.163.com/ubuntu/ `lsb_release -cs` main restricted universe multiverse"
sudo add-apt-repository "deb http://mirrors.163.com/ubuntu/ `lsb_release -cs`-updates main restricted universe multiverse"
sudo add-apt-repository "deb http://mirrors.163.com/ubuntu/ `lsb_release -cs`-security main restricted universe multiverse"
}


apt-get(系统升级)
{
    这里指的是版本间的升级，例如 9.04=>10.04。
    使用该升级方式通常需要使用 backports 源。
sudo apt-get update
sudo apt-get install update-manager-core
sudo do-release-upgrade
}

uname(查看内核)
{uname -a}

getconf(查看系统是32位还是64位)
{
#查看long的位数，返回32或64
getconf LONG_BIT
#查看文件信息，包含32-bit就是32位，包含64-bit就是64位
file /sbin/init
或者使用
uname -m
}

lsb_release(查看Ubuntu版本)
{lsb_release -a
或 cat /etc/lsb-release}

lsmod(查看内核加载的模块){lsmod}
lspci(查看PCI设备){lspci}
lsusb(查看USB设备){lsusb
#加参数 -v 可以显示USB设备的描述表（descriptors）
lsusb -v
}

ethtool(查看网卡状态){sudo apt-get install ethtool }
sudo ethtool eth0}


wakeonlan(激活网卡的 Wake-on-LAN){
sudo apt-get install wakeonlan
或 sudo ethtool -s eth0 wol g
}

cpuinfo(查看CPU信息)
{cat /proc/cpuinfo}

lshw(显示当前硬件信息){sudo lshw}

dmidecode(查看内存型号){sudo dmidecode -t memory}
dmidecode(获取CPU序列号或者主板序列号)
{
#CPU ID
sudo dmidecode -t 4 | grep ID
#Serial Number
sudo dmidecode  | grep  Serial
#CPU
sudo dmidecode -t 4
#BIOS
sudo dmidecode -t 0
#主板：
sudo dmidecode -t 2
#OEM:
sudo dmidecode -t 11
}

free(显示当前内存大小){free -m |grep "Mem" | awk '{print $2}'}
hddtemp(查看硬盘温度){
sudo apt-get install hddtemp
sudo hddtemp /dev/sda
}

uptime(显示系统运行时间){
uptime}

ulimit(查看系统限制)
{ulimit -a}

ipcs(查看内核限制){ipcs -l}

xrandr(查看当前屏幕分辨率){xrandr}

lsblk(查看块设备){lsblk}
fdisk(查看硬盘的分区){sudo fdisk -l}
fdisk(硬盘分区){
#危险！小心操作。
sudo fdisk /dev/sda
}
mkfs.ext3(硬盘格式化)
{
#危险！将第一个分区格式化为 ext3 分区, mkfs.reiserfs mkfs.xfs mkfs.vfat
sudo mkfs.ext3 /dev/sda1
}

fsck(硬盘检查){
#危险！检查第一个分区，请不要检查已经挂载的分区，否则容易丢失和损坏数据
sudo fsck /dev/sda1}

badblocks(硬盘坏道检测){
sudo badblocks -s  -v -c 32 /dev/sdb
#得到坏的块后，使用分区工具隔离坏道。}

mount(分区挂载)
{
sudo mount -t 文件系统类型 设备路经 访问路经 
#常用文件类型如下： iso9660 光驱文件系统, vfat fat/fat32分区, ntfs ntfs分区, smbfs windows网络共享目录, reiserfs、ext3、xfs Linux分区
#如果中文名无法显示尝试在最後增加 -o nls=utf8 或 -o iocharset=utf8 
#如果需要挂载後，普通用户也可以使用，在 -o 的参数後面增加 ,umask=022 如：-o nls=utf8,umask=022
}

umount(分区卸载)
{sudo umount 目录名或设备名}

mount(只读挂载ntfs分区)
{sudo mount -t ntfs -o nls=utf8,umask=0 /dev/sdb1 /mnt/c}

mount(可写挂载ntfs分区)
{sudo mount -t ntfs-3g -o locale=zh_CN.utf8,umask=0 /dev/sdb1 /mnt/c}

fat32(挂载fat32分区)
{sudo mount -t vfat -o iocharset=utf8,umask=0 /dev/sda1 /mnt/c}

mount(挂载共享文件)
{sudo mount -t smbfs -o  username=xxx,password=xxx,iocharset=utf8 //192.168.1.1/share /mnt/share}

mount(挂载ISO文件)
{sudo mount -t iso9660 -o loop,utf8 xxx.iso /mnt/iso}
hdparm(查看IDE硬盘信息){sudo hdparm -i /dev/sda}

mdstat(查看软raid阵列信息)
{cat /proc/mdstat}

scsi(){
参看硬raid阵列信息
dmesg |grep -i raid
cat /proc/scsi/scsi
}

hdparm(查看SATA硬盘信息){
sudo hdparm -I /dev/sda
或
sudo apt-get install blktool
sudo blktool /dev/sda id
}

df(查看硬盘剩余空间){
df
df --help 显示帮助
}

du(查看目录占用空间){
du -hs 目录名
}
sync(闪盘没法卸载){
sync
fuser -km /media/闪盘卷标
}

swapon(使用文件来增加交换空间)
{
#创建一个512M的交换文件 /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1M count=512 
sudo mkswap /swapfile
sudo swapon /swapfile
#sudo vim /etc/fstab #加到fstab文件中让系统引导时自动启动
/swapfile swap swap defaults 0 0
}

iostat(查看硬盘当前读写情况)
{

# 首先安装 sysstat 包
sudo apt-get install sysstat
#每2秒刷新一次
sudo iostat -x 2
}

dd(测试硬盘的实际写入速度)
{
dd if=/dev/zero of=test bs=64k count=512 oflag=dsync
}

free(查看当前的内存使用情况){free}
watch(连续监视内存使用情况)
{
watch  -d free
# 使用 Ctrl + c 退出
}

top(动态显示进程执行情况)
{
top
top指令运行时输入H或？打开帮助窗口，输入Q退出指令。
}

ps(查看当前有哪些进程)
{
ps -AFL
}

ps(查看进程的启动时间)
{
ps -A -opid,stime,etime,args
}

w(查看目前登入用户运行的程序) {w}

ps(查看当前用户程序实际内存占用，并排序){ps -u $USER -o pid,rss,cmd --sort -rss}

ps(统计程序的内存耗用)
{
ps -eo fname,rss|awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}'|sort -k2 -nr
}

ps(按内存从大到小排列进程)
{
ps -eo "%C  : %p : %z : %a"|sort -k5 -nr
}

ps(列出前十个最耗内存的进程)
{
ps aux | sort -nk +4 | tail
}

ps(按cpu利用率从大到小排列进程)
{
ps -eo "%C  : %p : %z : %a"|sort  -nr
ps aux --sort -pcpu |head -n 20
}
pstree(查看当前进程树){pstree}


kill(中止一个进程)
{
kill 进程号(就是ps -A中的第一列的数字)
或者 killall 进程名
}

kill(强制中止一个进程)
{
强制中止一个进程(在上面进程中止不成功的时候使用)
kill -9 进程号
或者 killall -9 进程名
}

xkill(图形方式中止一个程序){
xkill 出现骷髅标志的鼠标，点击需要中止的程序即可}

lsof(查看进程打开的文件){
lsof -p 进程的pid
}

lsof(统计进程打开的文件数并排序)
{
lsof -n|awk '{print $2}'|sort|uniq -c |sort -nr
}

lsof(显示开启文件abc.txt的进程){lsof abc.txt }
lsof(显示22端口现在运行什么程序){lsof -i :22 }
lsof(显示nsd进程现在打开的文件){lsof -c nsd}

nohup(在後台运行程序，退出登录後，并不结束程序)
{
nohup 程序 &
#查看中间运行情况　tail nohup
在后台运行交互式程序，退出登录后，并不结束程序
}

screen()
{
sudo apt-get install screen
screen vim a.txt
#直接退出后使用 
screen -ls   # 1656.pts-0.ubuntu   (Detached)
screen -r 1656  #恢复
#热键，同时按下Ctrl和a键结束后，再按下功能键
C-a ?         #显示所有键绑定信息
C-a w         #显示所有窗口列表
C-a C-a         #切换到之前显示的窗口
C-a c         #创建一个新的运行shell的窗口并切换到该窗口
C-a n         #切换到下一个窗口
C-a p         #切换到前一个窗口(与C-a n相对)
C-a 0..9         #切换到窗口0..9
C-a a         #发送 C-a到当前窗口
C-a d         #暂时断开screen会话
C-a k         #杀掉当前窗口
}

tmux()
{
在后台运行交互式程序，退出登录后，并不结束程序

tmux 进入后再运行其它命令
tmux attach #恢复
#热键，同时按下Ctrl和b键结束后，再按下功能键
C-b c         #创建一个新的运行shell的窗口并切换到该窗口
C-b n         #切换到下一个窗口
C-b p         #切换到前一个窗口(与C-a n相对)
C-b 0..9         #切换到窗口0..9
C-b d       #暂时断开会话
C-b &         #杀掉当前窗口
}

strace(详细显示程序的运行信息){strace -f -F -o outfile <cmd>}

limits.conf(增加系统最大打开文件个数)
{
#ulimit -SHn
sudo vim /etc/security/limits.conf
文件尾追加 
* hard nofile 4096
* soft nofile 4096

sudo vim /etc/pam.d/su
将 pam_limits.so 这一行注释去掉 
重起系统
}

ps(清除僵尸进程)
{
ps -eal | awk '{ if ($2 == "Z") {print $4}}' | xargs sudo kill -9

}
ps(将大于120M内存的php-cgi都杀掉)
{
ps -eo pid,fname,rss|grep php-cgi|grep -v grep|awk '{if($3>=120000) print $1}' | xargs sudo kill -9
}

renice(Linux系统中如何限制用户进程CPU占用率)
{renice +10 `ps aux | awk '{ if ($3 > 0.8 && id -u $1 > 500) print $2}'` 
#或直接编辑/etc/security/limits.conf文件。
}

ADSL()
{
ADSL
配置 ADSL
sudo pppoeconf
ADSL手工拨号
sudo pon dsl-provider
激活 ADSL
sudo /etc/ppp/pppoe_on_boot
断开 ADSL
sudo poff
查看拨号日志
sudo plog
如何设置动态域名

#首先去 http://www.3322.org 申请一个动态域名
#然後修改 /etc/ppp/ip-up 增加拨号时更新域名指令
sudo vim /etc/ppp/ip-up
#在最後增加如下行
w3m -no-cookie -dump 'http://username:password@members.3322.org/dyndns/update?system=dyndns&hostname=yourdns.3322.org'

}

arping(根据IP查网卡地址)
{
arping IP地址
}

nmblookup(根据IP查电脑名)
{
nmblookup -A IP地址
}

ifconfig(查看当前IP地址)
{
ifconfig eth0 |awk '/inet/ {split($2,x,":");print x[2]}'
}

w3m()
{
查看当前外网的IP地址

w3m -no-cookie -dump www.ip138.com/ip2city.asp|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
w3m -no-cookie -dump ip.loveroot.com|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
curl ifconfig.me
}

lsof(查看当前监听80端口的程序)
{
lsof -i :80
}

ifconfig(查看当前网卡的物理地址)
{
ifconfig eth0 | head -1 | awk '{print $5}'
或者
cat /sys/class/net/eth0/address
}

ifconfig(同一个网卡增加第二个IP地址)
{
#在网卡eth0上增加一个1.2.3.4的IP：
sudo ifconfig eth0:0 1.2.3.4 netmask 255.255.255.0
#删除增加的IP：
sudo ifconfig eth0:0 down
}

iptables(立即让网络支持nat)
{
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo iptables -t nat -I POSTROUTING -j MASQUERADE
}

netstat(查看路由信息)
{
netstat -rn
sudo route -n
}

route(手工增加一条路由)
{
sudo route add -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
}

route(手工删除一条路由)
{
sudo route del -net 192.168.0.0 netmask 255.255.255.0 gw 172.16.0.1
}

ifconfig(修改网卡MAC地址的方法)
{
sudo ifconfig eth0 down #关闭网卡
sudo ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE #然后改地址
sudo ifconfig eth0 up #然后启动网卡
}

pre-up(永久改地址方法)
{
sudo gedit /etc/network/interfaces
在 iface eth0 inet static 后面添加一行：
pre-up ifconfig eth0 hw ether 01:01:01:01:01:01

配置文件应该像如下

iface eth0 inet static
pre-up ifconfig eth0 hw ether 01:01:01:01:01:01
address 192.168.1.10
netmask 255.255.255.0
gateway 192.168.1.1

最后是 logout 或者reboot

}

netstat(统计当前IP连接的个数)
{
netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -r -n
netstat -na|grep SYN|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -r -n
netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
}

netstat(统计当前所有IP包的状态)
{
netstat -nat|awk '{print awk $NF}'|sort|uniq -c|sort -n
}

tcpdump(统计当前20000个IP包中大于100个IP包的IP地址)
{
tcpdump -tnn -c 20000 -i eth0 | awk -F "." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr | awk ' $1 > 100 '
}

modprobe(屏蔽IPV6)
{
echo "blacklist ipv6" | sudo tee /etc/modprobe.d/blacklist-ipv6
}

netstat(察看当前网络连接状况以及程序)
{
sudo netstat -atnp
}

netstat(查看网络连接状态)
{
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
}

nc(查看当前系统所有的监听端口)
{
nc -zv localhost 1-65535
}

ethstatus(查看网络的当前流量)
{
#安装 ethstatus 软件
sudo apt-get install ethstatus
#查看 ADSL 的速度
sudo ethstatus -i ppp0
#查看 网卡 的速度
sudo ethstatus -i eth0
#或安装 bwm-ng 
sudo apt-get install bwm-ng
#查看当前网络流量
bwm-ng
}

whois(查看域名的注册备案情况)
{
whois baidu.cn
}

tracepath(查看到某一个域名的路由情况)
{
tracepath baidu.cn
}

dhclient(重新从服务器获得IP地址)
{
sudo dhclient
从当前页面开始镜像整个网站到本地
}

wget()
{
wget -r -p -np -k http://www.21cn.com
· -r：在本机建立服务器端目录结构；
· -p: 下载显示HTML文件的所有图片；
· -np：只下载目标站点指定目录及其子目录的内容；
· -k: 转换非相对链接为相对链接。
}

axel(如何多线程下载)
{
sudo apt-get install axel
axel -n 5 http://xxx.xxx.xxx.xxx/xxx.zip
或者
lftp -c "pget -n 5 http://xxx.xxx.xxx.xxx/xxx.zip"
}

w3m(如何查看HTTP头)
{
w3m -dump_head http://www.example.com
或 curl --head http://www.example.com
}

python(快速使用http方式共享目录)
{
#进入需要共享的目录后运行: 
python -m SimpleHTTPServer
#其它电脑使用http://ip:8000 来访问
#自定义端口为8080: 
python -m SimpleHTTPServer 8080
}

ssh(远程端口转发)
{
SSH 远程端口转发
ssh -v -CNgD 7070 username@sshhostipaddress
}

snort(监控网络所有的tcp数据)
{
sudo apt-get install snort #安装snort入侵检测程序
sudo snort -vde
}

iftop(监控TCP/UDP连接的流量)
{
sudo apt-get install iftop 
sudo iftop
#或
sudo apt-get install iptraf
sudo iptraf
}

nc(扫描某个IP的端口)
{
nc -v -w 1 192.168.1.1 -z 1-1000
}

iptables(防止外网用内网IP欺骗)
{
#eth0 为外网网卡
sudo iptables -t nat -A PREROUTING -i eth0 -s 10.0.0.0/8 -j DROP
sudo iptables -t nat -A PREROUTING -i eth0 -s 172.16.0.0/12 -j DROP
sudo iptables -t nat -A PREROUTING -i eth0 -s 192.168.0.0/16 -j DROP 

查看nat规则
sudo iptables -t nat -L

查看filter规则
sudo iptables -L -n

取消nat规则
sudo iptables -t nat -F

取消filter规则
sudo iptables -F

阻止一个IP连接本机
#规则位于最后
sudo iptables -t filter -A INPUT -s 192.168.1.125 -i eth0 -j DROP 

关闭 1234 端口
sudo iptables -A OUTPUT -p tcp --dport 1234 -j DROP

开启 80 端口
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

限制访问80端口的外部IP最大只有50个并发
sudo iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 50 --connlimit-mask 32 -j DROP

禁止一个IP或者一个IP段访问服务器端口服务
#80端口 ，规则插入到前面
sudo iptables -t filter -I INPUT -s 192.168.2.0/24 -p tcp --dport http -j DROP
#21端口，规则插入到前面
sudo iptables -t filter -I INPUT -s 192.168.1.23 -p tcp --dport ftp -j DROP
}

rkhunter(检查本地是否存在安全隐患)
{
sudo apt-get install rkhunter
sudo rkhunter --checkall
}

clamscan(如何安装杀毒软件)
{
sudo apt-get install clamav
clamscan -r ~/

Linux下可以使用的商业杀毒软件

卡巴斯基(deb)： http://www.kaspersky.com/productupdates?chapter=146274389
avast!(免费/deb)： http://www.avast.com/eng/download-avast-for-linux-edition.html
小红伞(gz)： http://www.avira.com/en/downloads/avira_antivir_professional.html
BitDefender（比特梵德/run）：http://download.bitdefender.com/SMB/Workstation_Security_and_Management/BitDefender_Antivirus_Scanner_for_Unices/Unix/Current/EN_FR_BR_RO/Linux/

申请比特梵德的KEY：http://www.bitdefender.com/site/Products/ScannerLicense/
}

denyhosts(防止服务器被暴力破解ssh密码)
{
sudo apt-get install denyhosts
}

last(查看系统的登录情况){last}

lastlog(查看所有帐号的登录情况){lastlog}

service(查看全部服务状态){service --status-all}

update-rc.d(服务管理)
{
添加一个服务
sudo update-rc.d 服务名 defaults 99

删除一个服务
sudo update-rc.d 服务名 remove

临时重启一个服务
service 服务名 restart

临时关闭一个服务
service 服务名 stop

临时启动一个服务
service 服务名 start
}

增加用户
sudo adduser 用户名

删除用户
sudo deluser 用户名

修改当前用户的密码　
passwd

修改用户密码　
sudo passwd 用户名

修改用户资料
sudo chfn userid

usermod(如何禁用/启用某个帐户)
{
sudo usermod -L 用户名 #锁定用户
sudo usermod -U 用户名 #解锁
或
sudo passwd -l 用户名 #锁定用户
sudo passwd -u 用户名 #解锁
}

usermod(增加用户到admin组，让其有sudo权限){sudo usermod -G admin -a 用户名}

如何切换到其他帐号(需要该用户的密码)
su 用户名

如何切换到root帐号
sudo -s
sudo -i
sudo su

java(配置默认Java环境)
{
sudo update-alternatives --config java
}

http_proxy(设置系统http代理)
{
export http_proxy=http://xx.xx.xx.xx:xxx
}

https_proxy(设置系统https代理)
{
export https_proxy=http://xx.xx.xx.xx:xxx
}

motd(修改系统登录信息){sudo vim /etc/motd}

java(使用eclipse等其他自带java编译器的软件，换回sun的编译器方法)
{
对于Java JDK6 (就是1.6，sun缩短Java的版本名字了):
sudo update-java-alternatives -s java-6-sun
对于Java JDK1.5
sudo update-java-alternatives -s java-1.5.0-sun
}

im-switch(切换输入法引擎){
im-switch -c}

enca(察看文件编码){
enca 文件名
file 文件名}

convmv(转换文件名由GBK为UTF8)
{
sudo apt-get install convmv
convmv -r -f cp936 -t utf8 --notest --nosmart *
}

iconv(批量转换src目录下的所有文件内容由GBK到UTF8)
{
find src -type d -exec mkdir -p utf8/{} \;
find src -type f -exec iconv -f GBK -t UTF-8 {} -o utf8/{} \;
mv utf8/* src
rm -fr utf8
}

iconv(转换文件内容由GBK到UTF8)
{
iconv -f gbk -t utf8 $i > newfile
}

iconv(批量转换文件内容由GBK到UTF8)
{
for i in `find . *`; do if [ -f "$i" ]; then iconv -f gb2312 -t utf8 $i > "./converted/$i" fi ; done
}

mid3iconv(转换 mp3 标签编码)
{
sudo apt-get install python-mutagen
find . -iname '*.mp3' -execdir mid3iconv -e GBK {} \;
或者使用图形界面工具“小K”，具体请参考解决文件名mp3标签和文本文件内容的乱码问题
}

zhcon(控制台下显示中文)
{
sudo apt-get install zhcon
使用时，输入zhcon即可
更具体的输入：zhcon --utf8 --drv=vga
如果在/etc/zhcon.conf中指定了分辨率，可以去掉--drv=vga以指定的分辨率启动。
zhcon是个外挂的控制平台,也就是像US-DOS那样是额外安装的软件,装完后是需要驱动才能进去的，不然有可能死机; 当然驱动什么的在你sudo apt-get install zhcon的时候就已经安装了; 你所需要的是在进zhcon时要申明你所用的驱动,而zhcon在安装时,就装了3种驱动:vga,framebuffer,libggi,而我们一般都是用的第一种驱动,因为比较方便简单,而那2钟驱动.很麻烦,我也就没改过.好了说了这么多该告诉各位怎么进入zhcon了； 运行时需输入：zhcon --utf8 --drv=vga
lftp 登录远程Windows中文FTP　

lftp :~>set ftp:charset GBK
lftp :~>set file:charset UTF-8
}

java6(java6 的安装和中文设置)
{
#下面是ubuntu安装标准的sun-java，安装过程中需要使用tab键切换同意其授权协议
sudo add-apt-repository "deb http://archive.canonical.com/ `lsb_release -c | awk '{print $2}'` partner"
sudo apt-get update
sudo apt-get install sun-java6-jdk sun-java6-plugin ttf-wqy-microhei
sudo apt-get remove ttf-kochi-gothic ttf-kochi-mincho ttf-unfonts ttf-unfonts-core
sudo mkdir -p /usr/lib/jvm/java-6-sun/jre/lib/fonts/fallback
sudo ln -s /usr/share/fonts/truetype/arphic/wqy-microhei.ttc /usr/lib/jvm/java-6-sun/jre/lib/fonts/fallback

}

openjdk6(openjdk6 的安装和中文设置)
{
sudo apt-get install openjdk-6-jdk ttf-wqy-microhei
#有两种解决办法，第一种关闭Java的AA
echo "export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'" >> ~/.profile
#第二种直接修改Java字体配置
echo "allfonts.umingcn=WenQuanYi Microhei Hei" | sudo tee -a /usr/lib/jvm/java-6-openjdk/jre/lib/fontconfig.properties
echo "allfonts.uminghk=WenQuanYi Microhei Hei" | sudo tee -a /usr/lib/jvm/java-6-openjdk/jre/lib/fontconfig.properties
echo "allfonts.umingtw=WenQuanYi Microhei Hei" | sudo tee -a /usr/lib/jvm/java-6-openjdk/jre/lib/fontconfig.properties
echo "allfonts.wqy-zenhei=WenQuanYi Microhei Hei" | sudo tee -a /usr/lib/jvm/java-6-openjdk/jre/lib/fontconfig.properties
echo "allfonts.shanheisun=WenQuanYi Microhei Hei" | sudo tee -a /usr/lib/jvm/java-6-openjdk/jre/lib/fontconfig.properties
echo "filename.WenQuanYi_Microhei_Hei=/usr/share/fonts/truetype/wqy/wqy-microhei.ttc" | sudo tee -a /usr/lib/jvm/java-6-openjdk/jre/lib/fontconfig.properties

}

remove(程序显示有些字大，有些小)
{
sudo apt-get remove ttf-kochi-gothic ttf-kochi-mincho ttf-unfonts ttf-unfonts-core
}

poppler-data(PDF 文件乱码)
{
sudo apt-get install poppler-data
}

lunar-applet(增加农历)
{
sudo apt-get install lunar-applet
鼠标点击面板右键 -> 添加到面板 -> 农历日期
}

unzip(中文文件名乱码)
{
unzip 中文文件名乱码
sudo apt-get install p7zip-full
export LANG=zh_CN.GBK  #临时在控制台修改环境为zh_CN.GBK，然后解压缩即可
7za e docs.zip
}


ibus跟随

安装ibus-gtk即可,最好另外安装：ibus-qt4


monospace(查看具体字体名称)
{
fc-match monospace
wqy-zenhei.ttc: "WenQuanYi Zen Hei Mono" "Regular"
}


创建一个空文件
> file.txt
touch file.txt

一屏查看文件内容
cat 文件名

不显示以#开头的行
cat /etc/vsftpd.conf |grep -v ^#

分页查看文件内容
more 文件名

可控分页查看文件内容
less 文件名

带行号显示文件的内容
nl 文件名
cat -n 文件名

去除文件中的行号
cut -c 5- a.py

删除文件中的重复行
cat file.txt |sort -u

根据字符串匹配来查看文件部分内容
grep 字符串 文件名

显示包含或者不包含字符串的文件名
grep -l -r 字符串 路径　#显示内容包含字符串的文件名
grep -L -r 字符串 路径　#显示内容不包含字符串的文件名
find . -path './cache' -prune -o -name "*.php" -exec grep -l "date_cache[$format]['lang']" {} \; #显示当前目录下不包含cache目录的所有含有“date_cache[$format]['lang']”字符串的php文件。
find . -type f -name \*.php -exec grep -l "info" {} \;

whereis(快速查找某个文件)
{
whereis filename
find 目录 -name 文件名
locate 文件名 # 注意，为了得到更好的效果，运行前可以更新下数据库，运行 sudo updatedb 即可，但这个命令每隔一段时间会自动运行，所以不用太在意
}

创建两个空文件
touch file1 file2

递归式创建一些嵌套目录
mkdir -pv /tmp/xxs/dsd/efd

递归式删除嵌套目录
rm -fr /tmp/xxs

回当前用户的宿主目录
cd ~ # 这个是波浪线，在 Tab 键的上面
# 或者更简单的
cd

回到上一次的目录
cd -  # 这个是连字符，在退格键的左边两个

查看当前所在目录的绝对路经
pwd

sed(获得文件的后缀名)
{
echo xxx.xxx.rmvb |sed 's/.*\(\..*$\)/\1/'
}

sed(去除文件的后缀名)
{
echo xxx.xxx.rmvb |sed 's/\(.*\)\..*$/\1/'
}


列出当前目录下的所有文件,包括以.开头的隐含文件的具体参数
ls -al
或（在 Ubuntu 中）
ll

移动路径下的文件并改名
mv 路径/文件  /新路径/新文件名

复制文件或者目录
cp -av 原文件或原目录 新文件或新目录

查看文件类型
file filename

查看文件的时间
stat filename

对比两个文件之间的差异　
diff file1 file2

一边比较一边编辑还是彩色的：（需要安装 Vim）
vimdiff file1 file2

显示xxx文件倒数6行的内容
tail -6 xxx

让tail不停地读取最新的内容
tail -10f /var/log/apache2/access.log
或者
tailf /var/log/apache2/access.log

查看文件中间的第五行（含）到第10行（含）的内容
sed -n '5,10p' /var/log/apache2/access.log


查找关于xxx的命令
apropos xxx
man -k xxx

通过ssh传输文件

scp -rp /path/filename username@remoteIP:/path #将本地文件拷贝到服务器上
scp -rp username@remoteIP:/path/filename /path #将远程文件从服务器下载到本地

tar cvzf - /path/ | ssh username@remoteip "cd /some/path/; cat -> path.tar.gz" #压缩传输
tar cvzf - /path/ | ssh username@remoteip "cd /some/path/; tar xvzf -" #压缩传输一个目录并解压

rsync -avh /path/to/file/or/dir user@host:/path/to/dir/or/file
rsync -avh user@host:/path/to/file/or/dir /path/to/file/or/dir

rename(把所有文件的后缀由rm改为rmvb)
{rename 's/.rm$/.rmvb/' *}

rename(把所有文件名中的大写改为小写){rename 'tr/A-Z/a-z/' *}

删除特殊文件名的文件，如文件名：--help.txt
rm -- --help.txt 或者 rm ./--help.txt

查看当前目录的子目录
ls -d */ 或 echo */

将当前目录下最近30天访问过的文件移动到上级back目录
find . -type f -atime -30 -exec mv {} ../back \;

查找当前目录下最近30天访问过的文件打包备份
find . -type f -atime -30 | xargs tar zrvpf backup.tar.gz
find . -type f -atime -30 -print -exec tar rvpf backup.tar {} \;

显示系统服务器一小时以内的包含 xxxx 的所有邮件
find /home/ -path "*Maildir*" -type f -mmin -60|xargs -i  grep -l xxxx '{}'

将当前目录下最近2小时到8小时之内的文件显示出来
find . -mmin +120 -mmin -480 -exec more {} \;

删除修改时间在30天之前的所有文件
find . -type f -mtime +30 -exec rm -v {} \;

删除访问时间在30天之前的所有文件
find . -type f -atime +30 -exec rm -v {} \;

查找guest用户的以avi或者rm结尾的文件并删除掉
find . -name '*.avi' -o -name '*.rm' -user 'guest' -exec rm {} \;

查找不以java和xml结尾,并7天没有使用的文件删除掉
find . ! -name *.java ! -name ‘*.xml’ -atime +7 -exec rm {} \;

查找目录下所有有包含abcd文字的文本文件，并替换为xyz
grep -rIl "abcd" ./* --color=never | xargs sed -i "s/abcd/xyz/g" #注意grep的一个参数是大写的i，一个参数是小写的L

删除当前目录里面所有的 .svn 目录
find . -name .svn -type d -exec rm -fr {} \;

删除当前目录所有以“~”结尾的临时文件
find . -name "*~" -exec rm {} \;

删除包含 aaa 字符串的所有文件
grep -rl "aaa" * |xargs rm -fv

统计当前文件个数
echo $(($(ll|wc -l)-3));

统计当前目录下所有jpg文件的尺寸
find . -name *.jpg -exec wc -c {} \;|awk '{print $1}'|awk '{a+=$1}END{print a}'

统计当前目录个数
ls -l /usr/bin|grep ^d|wc -l

du_sort_head(统计当前目录下占空间最大的前10名文件或目录)
{
du -sm * | sort -nr | head -10
}


显示当前目录下2006-01-01的文件名
ls -l |grep 2006-01-01 |awk '{print $8}'

rsync(备份当前系统到另外一个硬盘)
{
sudo rsync -Pa / /media/disk1 --exclude=/media/* --exclude=/home/* --exclude=/sys/* --exclude=/tmp/* --exclude=/proc/* --exclude=/mnt/*
}

rsync(使用ssh方式同步远程数据到本地目录)
{
rsync -Pa -I --size-only --delete --timeout=300 Remote_IP:/home/ubuntu/back /backup
}

lftp(使用ftp方式同步远程数据到本地目录)
{
lftp -c "open Remote_IP;user UserName Password;set cache:enable false;set ftp:passive-mode false;set net:timeout 15;mirror -e -c /back /backup;"
}
cat_tr(去掉文件中的^M)
{
#注意不要使用同样的文件名，会清空掉原文件
cat -A filename| tr -d "^M$" > newfile
或者
cat -A word|sed -e 's/\^M\$//g' > newfile
}

ex(直接修改文件)
{
ex "+:%s/[Ctrl+V][Enter]//g" "+:wq"  filename 
或者
dos2unix filename
}



dos2unix(转换Dos文本文件到Unix文本文件)
{
tr -d '\15\32' < dosfile.txt > unixfile.txt                         #dos = > unix
awk '{ sub("\r$", ""); print }' dosfile.txt > unixfile.txt   #dos = > unix
awk 'sub("$", "\r")' unixfile.txt > dosfile.txt                  #unix = > dos
}

bchunk(转换bin/cue到iso文件)
{
#sudo apt-get install bchunk
bchunk image.bin image.cue image
}

mkisofs(转换目录到iso文件)
{
mkisofs -o isofile.iso  dirname
}

dd(转换CD到iso文件)
{
dd if=/dev/cdrom of=isofile.iso
}

mail(将一个文件作为附件发到邮箱)
{
#sudo apt-get install mailutils sharutils
uuencode xxx.tar.gz xxx.tar.gz | mail xxx@xxx.com
(echo "hello, please see attached file"; uuencode xxx.tar.gz xxx.tar.gz)| mail xxx@xxx.com
}

gs(合并多个pdf文件到一个pdf文件)
{
#apt-get install gs pdftk
gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=output.pdf -dBATCH input1.pdf input2.pdf
}

比较两个目录里面的文件是否有相同
diff -r dir1 dir2

ssh_diff(比较一个远程文件和一个本地文件)
{
ssh user@host cat /path/to/remotefile | diff /path/to/localfile -
}
tail_sed(当file.log里出现Finished: SUCCESS时候就退出tail)
{
tail -f /path/to/file.log | sed '/^Finished: SUCCESS$/ q'
}

find(统计py代码行数，不包括空行)
{
find . -name "*.py" | xargs grep '^.' | wc -l
find . \( -path '*migrations*' -prune -o -name '*.py' \) -type f | xargs grep '^.' | wc -l
}

find(统计java代码行数，不包括空行和公共目录)
{
find . -path './src/java/com/xxx/common' -prune -o -name '*.java' -print  | xargs grep '^.' | wc -l

}

nl(给文件增加行号)
{nl HelloWorld.java > HelloWorldCode.java}


swfmill(播放swf文件)
{
安装swf解码器
sudo apt-get install swfmill
}

mplayer(如何保存串流视频)
{
如何保存串流视频(mms/rtsp)
mplayer -dumpfile dump.rm -dumpstream rstp://....
}

mencoder(批量将rmvb转为avi)
{
#ipod touch可用
for i in *.rmvb; do mencoder -vf harddup -oac mp3lame -lameopts vbr=3 -ovc xvid -xvidencopts fixed_quant=4 -of avi $i -o `echo $i | sed -e 's/rmvb$/avi/'`; done
批量将DVD转为avi
for i in *.VOB; do mencoder -oac mp3lame -lameopts aq=7:vbr=2:q=6 -srate 44100 -ovc xvid -xvidencopts fixed_quant=4 -of avi $i -o `echo $i | sed -e 's/VOB$/avi/'`; done

}

ffmpeg2theora(批量将任何格式的电影转为ogv)
{
#sudo apt-get install ffmpeg2theora   
#firefox3.5或chrome直接支持播放，无需安装任何解码器，注意不支持rmvb，rmvb会出现a/v不同步问题
for i in *; do ffmpeg2theora --optimize --deinterlace $i; done
}
mencoder(批量将rmvb格式的电影转为ogv)
{
#!/bin/bash
for i in *; do
   mkfifo "/tmp/$i"
   mencoder -quiet -vf harddup -ovc raw -oac pcm -o "/tmp/$i" "$i" &
   ffmpeg2theora --optimize --deinterlace "/tmp/$i" -o "`echo $i | sed 's/\(.*\)\..*$/\1/'`.ogv"
   rm "/tmp/$i"
done
}

oggmux(利用gst来转换任意电影为ogv)
{
#!/bin/bash
for i in *; do
   gst-launch-0.10 filesrc location="$i" ! decodebin name=demux \
   { oggmux name=mux ! filesink location="`echo $i | sed 's/\(.*\)\..*$/\1/'`.ogv" } \
   { demux. ! queue ! audioconvert ! vorbisenc ! queue ! mux. } \
   { demux. ! queue ! ffmpegcolorspace ! videorate ! theoraenc ! mux. } 
done
}

mencoder(批量转换任意文件为ipod touch使用的mp4)
{
#!/bin/bash
#ubuntu10.04自带的mencoder由于版权问题，不支持h264编码，需要重新编译；也可以直接参考下面的压缩方法。
#sudo apt-get install mencoder mplayer
find . -name '*.avi' -o -name '*.rm' -o -name '*.rmvb' -o -name '*.wmv' -o \
      -name '*.vob' -o -name '*.asf' -o -name '*.mpg' -o -name '*.ts' -o \
      -name '*.flv' -o -name '*.mpeg' -o -name '*.ogv' -o -name '*.mov' -o \
      -name '*.mkv' -o -name '*.dat' | while read i; do
  basename=`echo $i | sed 's/\(.*\)\..*$/\1/'`
  font="WenQuanYi Zen Hei"

  if [ -f "${basename}.srt" ] ; then
     cp "${basename}.srt" $$.srt
     m0="-vf scale=480:-10,harddup -sub $$.srt -unicode -subcp GB18030 -subfont-text-scale 3"; 
  else
     m0="-vf scale=480:-10,harddup"; 
  fi
 
  x0="-lavfopts format=mp4 -faacopts mpeg=4:object=2:raw:br=160 -oac faac -ovc x264 -sws 9 -x264encopts nocabac:level_idc=30:bframes=0:global_header:threads=auto:subq=5:frameref=6:partitions=all:trellis=1:chroma_me:me=umh:bitrate=500 -of lavf -ofps 24000/1001";
  mencoder $m0 -fontconfig -font "${font}" $x0 -o "$$.mp4" "$i"
  mv "$$.mp4" "${basename}.mp4"
  if [ -f "${basename}.mp4" ] ; then
     rm "$i"
  fi
done
}


H264(转换任意格式的视频到H264)
{
#!/bin/bash
#sudo apt-get install faac x264 gpac mplayer mencoder
basename=`echo $1 | sed 's/\(.*\)\..*$/\1/'`
#获得视频的长宽和帧数
mplayer -vo null -ao null -identify -frames 0 "$1" 2>/dev/null > video.info
FPS=`cat video.info | grep ID_VIDEO_FPS | cut -d = -f 2`
#FPS=23.976
W=`cat video.info | grep ID_VIDEO_WIDTH | cut -d = -f 2`
H=`cat video.info | grep ID_VIDEO_HEIGHT | cut -d = -f 2`
WIDTH=480
HEIGHT=`expr $WIDTH \* $H \/ $W`
echo $1 FPS=$FPS WIDTH=$WIDTH HEIGHT=$HEIGHT
mkfifo audio.wav video.yuv
faac -o audio.aac audio.wav &
mplayer -ao pcm:file=audio.wav:fast -vc null -vo null "$1" 
x264 --profile baseline --fps $FPS -o video.264 video.yuv ${WIDTH}x${HEIGHT} &
mencoder -vf scale=$WIDTH:$HEIGHT,harddup,pp=fd,format=i420 -nosound -ovc raw -of rawvideo -ofps $FPS -o video.yuv "$1"
MP4Box -new -add video.264 -add audio.aac -fps $FPS "$basename.mp4"
rm video.info audio.aac video.264 audio.wav video.yuv
#使用方法将上面的脚本保存为 x264.sh , x264.sh xxx.avi 来进行转化。
}

H264(压制DVD到H264，支持ipod)
{
#sudo apt-get install faac x264 gpac mplayer
FPS=29.970
mkfifo audio.wav
cat VTS_01_1.VOB VTS_02_1.VOB VTS_02_2.VOB VTS_03_1.VOB VTS_04_1.VOB | mplayer -nocorrect-pts -vo null -vc null -ao pcm:file=audio.wav:fast - &
faac audio.wav -o audio.aac
mkfifo video.y4m
cat VTS_01_1.VOB VTS_02_1.VOB VTS_02_2.VOB VTS_03_1.VOB VTS_04_1.VOB | mplayer -vo yuv4mpeg:file=video.y4m -vf scale=480:-3,harddup,pp=fd -nosound - &
x264 --profile baseline --muxer mp4 --demuxer y4m video.y4m -o video.mp4
MP4Box -add video.mp4 -add audio.aac -fps $FPS video.mp4
}




图形界面为ipod touch转mp4的方法
先确保有zenity和memcoder
wget http://linuxfire.com.cn/~lily/toIpod -O ~/.gnome2/nautilus-scripts/toIpod && chmod +x ~/.gnome2/nautilus-scripts/toIpod
在nautilus里对视频文件点右键，选择"脚本"-"toIpod".

ffmpeg(转换flv到MP4)
{
#sudo apt-get install ffmpeg
ffmpeg -i 矜持.flv -ar 22050 矜持.mp4
mencoder/mplayer 反拉丝参数
-vf lavcdeint
}

mencoder(合并多个 rm 文件为一个 avi 文件)
{
mencoder -ovc lavc 1.rm -oac mp3lame -o 1.avi
mencoder -ovc lavc 2.rm -oac mp3lame -o 2.avi
mencoder -idx 1.avi -ovc copy -oac copy -o o1.avi
mencoder -idx 2.avi -ovc copy -oac copy -o o2.avi
cat o1.avi o2.avi | mencoder -noidx -ovc copy -oac copy -o output.avi -
}

mencoder(合并视频到一个文件)
{
mencoder -ovc copy -oac copy -idx  -o 目标文件名 文件名1 文件名2
}

CD 抓轨为 mp3 (有损)
#sudo apt-get install abcde
abcde -o mp3 -b

CD 抓轨为 Flac (无损)
#sudo apt-get install abcde
abcde -o flac -b

ape 转换为 flac
#sudo apt-get install flac shntool iconv mac
#iconv -f GB2312 -t UTF-8 example.cue -o example_UTF-8.cue
#shntool split -t "%n.%p-%t" -f example_UTF-8.cue -o flac example.ape -d flacOutputDir

#sudo apt-get install libav-tools
ffmpeg -i example.ape example.flac

ape/flac 转换为 mp3

#sudo apt-get install shntool iconv libav-tools
ffmpeg -i CDImage.ape CDImage.flac
iconv -f gbk -t utf-8 CDImage.cue | shntool split -t "%n.%p-%t" -o 'cust ext=mp3 lame --quiet - %f' CDImage.flac

批量将 ape 转为 flac

find . -name "*.ape" -exec bash -c 'avconv -i "$0" "${0/%ape/flac}"' {} \;
#此命令将当前目录（包括子目录）的所有ape文件转换为flac

批量将 ape 转为 mp3
for f in *.ape; do gst-launch-0.10 filesrc location="$f" ! decodebin ! audioconvert ! lame vbr=0 bitrate=320 ! id3mux ! filesink location="${f%.ape}.mp3"; done
#需要安装 shntool
for i in *.ape; do shnconv -i ape -o "cust ext=mp3 lame -b 320 - %f" "$i" -d mp3OutputDir; done

批量将 ape 转为 m4a
for f in *.ape; do ffmpeg -i  "$f" -acodec alac "${f%.ape}.m4a"; done

批量将 ape 转为 aac
for f in *.ape; do ffmpeg -i  "$f" -acodec aac -strict experimental -ab 256k "${f%.ape}.aac"; done

批量将 flac 转为 mp3
for i in *.flac; do shnconv -i flac -o "cust ext=mp3 lame -b 320 - %f" "$i" -d mp3OutputDir; done

批量将svg转为png
for i in *.svg; do inkscape $i --export-png=`echo $i | sed -e 's/svg$/png/'`; done

批量转换格式到mp3
#sudo apt-get install lame mplayer
for i in *; do base=${i%.*}; mplayer -quiet -vo null -vc dummy -af volume=0,resample=44100:0:1 -ao pcm:waveheader:file="$i.wav" "$i" ; lame -V0 -h -b 192 -vbr-new "$i.wav" "$base.mp3"; rm -f "$i.wav" ; done

批量缩小图片到30%
for i in *.jpg; do convert -resize 30%x30% "$i" "sm-$i"; done

批量转换jpg到png
for i in *.jpg; do convert $i `echo $i | sed -e 's/jpg$/png/'`; done

将文字转为图片
convert -size 200x30 xc:transparent -font /usr/share/fonts/truetype/wqy/wqy-microhei.ttc -fill red -pointsize 16 -draw "text 5,15 '测试中文转为图片'" test.png

如何压缩png图片
#sudo apt-get install optipng
optipng -o7 old.png new.png
#或 sudo apt-get install pngcrush
#pngcrush -brute old.png new.png

将多张图片合并到一个PDF文件
convert *.jpg out.pdf

poppler(批量把pdf转换为txt并格式化)
{
sudo apt-get install poppler-utils poppler-data
#find ./ -name '*.txt' | while read i; do cat $i | awk '{if ($0 ~ "^space:”) {printf “\n”$0} else {printf $0}}’ | sed ‘/^space:*digit:*$/d’ | sed ’s/^space:\+/    /’ | sed ’s/＂/”/g’ > “../txt/$i‘; done

}

转换 pdf 到 png
#sudo apt-get install imagemagick
convert -density 196 FILENAME.pdf  FILENAME.png

获取jpg的扩展信息(Exif)
identify -verbose xxx.jpg

获取视频文件 xxx.avi 的信息
mplayer -vo null -ao null -frames 0 -identify "xxx.avi" 2>/dev/null | sed -ne '/^ID_/ { s/[]()|&;<>`'"'"'\\!$" []/\\&/g;p }'

查看MKV视频文件 xxx.mkv 的信息
#sudo apt-get install mkvtoolnix
mkvinfo -v xxx.mkv


抓取桌面操作的视频
ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq /tmp/out.mpg

命令行读出文本
espeak -vzh "从前有座山"

scrot(命令行抓屏)
{
scrot -s screenshot.png
}

增加 7Z 压缩软件
#支持 7Z,ZIP,Zip64,CAB,RAR,ARJ,GZIP,BZIP2,TAR,CPIO,RPM,ISO,DEB 压缩文件格式
sudo apt-get install p7zip p7zip-full p7zip-rar
#将所有已txt结尾的文件都加入到files.7z
7z a -t7z files.7z *.txt
#解压缩files.zip
7z x files.zip
#删除 files.zip中所有已bak结尾的文件
7z d -r files.zip *.bak 
#列出file.7z中所有的文件信息
7z l files.7z
#测试files.zip中所有doc结尾文件的正确性
7z t -r files.zip *.doc 
#更新files.zip中的所有doc结尾的文件（不是所有的压缩格式都支持更新这一选项）
7z u files.zip *.doc

增加 rar 格式解压和压缩支持

#解压
sudo apt-get install unrar
#压缩
#源里的rar包有文件名乱码问题，不建议使用。
#如果确实需要rar压缩功能，请到以下网址直接下载RAR for Linux
#http://www.rarlab.com/download.htm

增加 zip 格式解压和压缩支持
#解压
sudo apt-get install unzip
#压缩
sudo apt-get install zip

解压缩 xxx.tar.gz
tar -xf xxx.tar.gz

解压缩 xxx.tar.bz2
tar -xf xxx.tar.bz2

解压缩 xxx.tar.xz
tar -Jxf xxx.tar.xz

压缩aaa bbb目录为xxx.tar.gz
tar -zcvf xxx.tar.gz aaa bbb

压缩aaa bbb目录为xxx.tar.bz2
tar -jcvf xxx.tar.bz2 aaa bbb

压缩aaa bbb目录为xxx.tar.xz
tar -Jcvf xxx.tar.xz aaa bbb

增加 lha 支持
sudo apt-get install lha

增加解 cab 文件支持
sudo apt-get install cabextract

Nautilus
显示隐藏文件

Ctrl+h
显示地址栏

Ctrl+l
URL(特殊 URI 地址)
{
* computer:/// - 全部挂载的设备和网络
* network:/// - 浏览可用的网络
* burn:/// - 一个刻录 CDs/DVDs 的数据虚拟目录
* smb:/// - 可用的 windows/samba 网络资源
* x-nautilus-desktop:/// - 桌面项目和图标
* file:/// - 本地文件
* trash:/// - 本地回收站目录
* ftp:// - FTP 文件夹
* ssh:// - SSH 文件夹
* fonts:/// - 字体文件夹，可将字体文件拖到此处以完成安装
* themes:/// - 系统主题文件夹
}

fc-list(查看已安装字体)
{
fc-list |grep 文
}

获取安装的中文字体信息

文件管理器（比如nautilus）的地址栏里输入 ~/.fonts ，就可以查看当前用户拥有的fonts——而系统通用字体位于 /usr/share/fonts
日期和时间
显示日历
cal # 显示当月日历
cal 2 2007 # 显示2007年2月的日历

显示农历
#sudo apt-get install lunar
date '+%Y %m %d %H' |xargs lunar --utf8

设置日期
date -s mm/dd/yy

设置时间
date -s HH:MM

将时间写入CMOS
hwclock --systohc

查看CMOS时间
hwclock --show

读取CMOS时间
hwclock --hctosys

从服务器上同步时间
sudo ntpdate ntp.ubuntu.com
sudo ntpdate time.nist.gov

tzdata(设置电脑的时区为上海)
{
sudo dpkg-reconfigure tzdata

然后根据提示选择 Asia/Shanghai。这样在升级了 tzdata 包之后时区也是对的。
XP 和 Ubuntu 相差了 8 小时的时差

#关闭UTC，将当前时间写入CMOS。
sudo sed -ie 's/UTC=yes/UTC=no/g' /etc/default/rcS
sudo hwclock --systohc
}


将时间截转为时间
date -d@1234567890

workspace(工作区)
{
不同工作区间切换

Ctrl + ALT + ←
Ctrl + ALT + →
或者，将滚轮鼠标放在工作区图标上滚动
}


console(控制台)
{
指定控制台切换
Ctrl + ALT + Fn(n:1~7)
}


控制台下滚屏
SHIFT + pageUp/pageDown

setterm(控制台抓图)
{
setterm -dump n(n:1~7)
只是支持tty1-7。没中文。没颜色代码序列。
}


回到上一次的目录
cd –

以root的身份执行上一条命令
sudo !!

数据库
mysql的数据库存放路径
/var/lib/mysql


mysql(从mysql中导出和导入数据)
{
mysqldump 数据库名 > 文件名 #导出数据库
mysqladmin create 数据库名 #建立数据库
mysql 数据库名 < 文件名 #导入数据库
}

mysql(忘了mysql的root口令怎么办)
{
sudo /etc/init.d/mysql stop
sudo mysqld_safe --skip-grant-tables &
sudo mysqladmin -u user password newpassword
sudo mysqladmin flush-privileges
}

mysqladmin(修改mysql的root口令)
{
sudo mysqladmin -u root -p password '你的新密码'
}

如何优化mysql
wget  http://www.day32.com/MySQL/tuning-primer.sh
chmod +x tuning-primer.sh
./tuning-primer.sh


mysql(mysql命令行中文显示?号)
{
mysql> set names utf8;
}

mysql(常用mysql管理语句)
{
show table status;  #查询表状态
show full processlist;  #查询mysql进程
alter table site_stats engine=MyISAM;   #转换表为MyISAM类型，转表锁为行锁。
show variables;  #查看mysql 变量
}

mysql(mysql的自动备份)
{
#备份 forum myweb 数据库到 /backup/mysql 目录，并删除7天之前的备份记录
mysqldump --opt --skip-lock-tables -u root forum | gzip -9 > /backup/mysql/forum.`date +%Y%m%d`.sql.gz
mysqldump --opt --skip-lock-tables -u root myweb | gzip -9 > /backup/mysql/myweb.`date +%Y%m%d`.sql.gz
find /backup/mysql/ -type f -ctime +7 -exec rm {} \;
}


xset(如何使用命令关闭显示器)
{
xset dpms force off
}

cpufrequtils(设置CPU的频率)
{
sudo apt-get install cpufrequtils 
#查看cpu当前频率信息
sudo cpufreq-info 
设置模式,对应于{最省电（最低频率），用户控制，最高或最低，正常，最大性能} 
cpufreq-set -g {powersave, userspace, ondemand, conservative, performance}
}

命令关机
sudo halt
sudo shutdown -h now              #现在关机

定时关机
sudo shutdown -h 23:00           #晚上11点自动关机
sudo shutdown -h +60          #60分钟后关机

命令重启电脑
sudo reboot
sudo shutdown -r now

如何修改ssh登录提示
sudo gedit  /etc/motd

如何关闭ssh登录提示
sudo gedit  /etc/ssh/sshd_config 修改这一行为： PrintLastLog no


synclient(如何使用命令关闭笔记本的触摸板)
{
synclient touchpadoff=1
那么开启触摸板就是：
synclient touchpadoff=0
}

notify-send(从命令行通知桌面消息)
{
#sudo apt-get install libnotify-bin
notify-send "hello world"
}

awk(统计最常用的10条命令)
{
history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n10 

}

awk(统计每个单词的出现频率，并排序)
{
awk '{arr[$1]+=1 }END{for(i in arr){print arr[i]"\t"i}}' FILE_NAME | sort -rn
}

awk(统计80端口的连接个数并按照从大到小排列)
{
netstat -na|grep :80|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -r -n
}

vim(编辑器)
{
vim中删除技巧

:%s/[Ctrl-v][Enter]//g         删除DOS方式的回车^M
:%s= *$==                      删除行尾空白
:%!sort -u                     删除重复行
:%s/^.{-}pdf/new.pdf/          只是删除第一个pdf
:%s///                         删除多行注释
:g/^$/d                        删除所有空行 
:g!/^dd/d                      删除不含字符串'dd'的行
:v/^dd/d                       删除不含字符串'dd'的行
:g/str1/,/str2/d               删除所有第一个含str1到第一个含str2之间的行
:v/./.,/./-1join               压缩空行
:g/^$/,/./-j                   压缩空行
ndw 或 ndW                     删除光标处开始及其后的 n-1 个字符。
d0                             删至行首。
d$                             删至行尾。
ndd                            删除当前行及其后 n-1 行。
x 或 X                         删除一个字符。
Ctrl+u                         删除输入方式下所输入的文本。
D                              删除到行尾
x,y                            删除与复制包含高亮区
dl                             删除当前字符（与x命令功能相同）
d0                             删除到某一行的开始位置
d^                             删除到某一行的第一个字符位置（不包括空格或TAB字符）
dw                             删除到某个单词的结尾位置
d3w                            删除到第三个单词的结尾位置
db                             删除到某个单词的开始位置
dW                             删除到某个以空格作为分隔符的单词的结尾位置
dB                             删除到某个以空格作为分隔符的单词的开始位置
d7B                            删除到前面7个以空格作为分隔符的单词的开始位置
d)                             删除到某个语句的结尾位置
d4)                            删除到第四个语句的结尾位置
d(                             删除到某个语句的开始位置
d)                             删除到某个段落的结尾位置
d{                             删除到某个段落的开始位置
d7{                            删除到当前段落起始位置之前的第7个段落位置
dd                             删除当前行
d/text                         删除从文本中出现“text”中所指定字样的位置，一直向前直到下一个该字样所出现的位置（但不包括该字样）之间的内容
dfc                            删除从文本中出现字符“c”的位置，一直向前直到下一个该字符所出现的位置（包括该字符）之间的内容
dtc                            删除当前行直到下一个字符“c”所出现位置之间的内容
D                              删除到某一行的结尾
d$                             删除到某一行的结尾
5dd                            删除从当前行所开始的5行内容
dL                             删除直到屏幕上最后一行的内容
dH                             删除直到屏幕上第一行的内容
dG                             删除直到工作缓存区结尾的内容
d1G                            删除直到工作缓存区开始的内容
ci{                            删除修改光标所在的{}中的所有内容,change in { 的简写
ca{                            删除修改光标所在的{}中的所有内容,包括{}
ci"                            删除修改光标所在的""中的所有内容,change in " 的简写
ca"                            删除修改光标所在的""中的所有内容,包括{}"
ci(                            删除修改光标所在的()中的所有内容,change in ( 的简写
ca(                            删除修改光标所在的()中的所有内容,包括{}

vim一个远程文件

vim scp://username@host//path/to/somefile
}


Emacs(如何配置Emacs)
{
打开新立得或者命令行，查找emacs， 选择你想要的版本，比如emacs22或者emacs21.
之后的配置参考Emacs 常见问题及其解决方法
}

vim_config()
{
vim 如何显示彩色字符

sudo cp /usr/share/vim/vimcurrent/vimrc_example.vim /usr/share/vim/vimrc
让 vim 直接支持编辑 .gz 文件

sudo apt-get install vim-full
vim 如何显示行号，在~/.vimrc中加入
set number

如果没有~/.vimrc文件，则可以在/etc/vim/vimrc中加入
set number

vim配色方案 (~/.vimrc)

colorscheme scheme
可用的 scheme 在 /usr/share/vim/vim71/colors/ 

解决vim中文编码问题，在~/.vimrc中加入

let &termencoding=&encoding
set fileencodings=utf-8,gbk,ucs-bom,cp936

#再提供一个实践中觉得不错的配置：

set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
}

gedit(gedit中文乱码的解决)
{
gsettings set org.gnome.gedit.preferences.encodings auto-detected "['GB18030', 'UTF-8', 'CURRENT', 'ISO-8859-15', 'UTF-16']"
}


编译和打包
安装通用编译环境

sudo apt-get install build-essential

通用的编译安装步骤

./configure && make && sudo make install

如何编译安装软件 kate

sudo apt-get install apt-build
sudo apt-build install kate

获得源代码包

sudo apt-get source mysql-server

解压缩还原源代码包

dpkg-source -x mysql-dfsg-5.1_5.1.30-1.dsc

安装编译打包环境

sudo apt-get build-dep mysql-server

重新编译并打包Debian化的源码

dpkg-buildpackage -rfakeroot

获得源码并重新打包

apt-get source php5-cgi  
#或手工下载源码后使用 dpkg-source -x  php5_5.2.6.dfsg.1-3ubuntu4.1.dsc 解开源码
sudo apt-get build-dep php5-cgi
cd php5-5.2.6.dfsg.1
dpkg-buildpackage -rfakeroot -uc -b

给源代码打补丁

patch -p0 < mysql.patch

安装 gtk+ 编译环境

sudo apt-get install build-essential libgtk2.0-dev

其它
把终端加到右键菜单

sudo apt-get install nautilus-open-terminal 

如何删除Totem电影播放机的播放历史记录

rm ~/.recently-used

清除桌面挂载硬盘图标

gconftool-2 --set /apps/nautilus/desktop/volumes_visible 0 --type bool

恢复：

gconftool-2 --set /apps/nautilus/desktop/volumes_visible 1 --type bool

如何更换gnome程序的快捷键

点击菜单，鼠标停留在某条菜单上，键盘输入任意你所需要的键，可以是组合键，会立即生效；
如果要清除该快捷键，请使用backspace

man 如何显示彩色字符

vim ~/.bashrc
#增加下面的内容：
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
#生效文件
#source .bashrc

如何在命令行删除在会话设置的启动程序

cd ~/.config/autostart
rm 需要删除启动程序

如何提高wine的反应速度

sudo sed -ie '/GBK/,/^}/d' /usr/share/X11/locale/zh_CN.UTF-8/XLC_LOCALE


cdrecord(如何命令行刻录)
{
mkisofs -o test.iso -Jrv -V test_disk /home/carla/
cdrecord -scanbus
scsibus1:
 1,1,0 101) 'HL-DT-ST' 'CD-RW GCE-8481B ' '1.04' Removable CD-ROM
cdrecord -v -eject speed=8 dev=1,1,0 test.iso
}

gnome-screenshot(延迟抓图)
{
http://www.ibm.com/developerworks/cn/linux/l-cdburn/index.html
延迟抓图

gnome-screenshot -d 10 #延迟10秒抓图
gnome-screenshot -w -d 5 #延迟5秒抓当前激活窗口
}



Trash(回收站在哪里)
{~/.local/share/Trash/}


Trash(强制清空回收站)
{
sudo rm -fr $HOME/.local/share/Trash/files/
}



defaults(默认打开方式的配置文件在哪里)
{
#全局
/etc/gnome/defaults.list 
#个人
~/.local/share/applications/mimeapps.list
}

Firefox(的缓存目录在哪里)
{
ls ~/.mozilla/firefox/*.default/Cache/
}


samba()
{
查看samba的用户
sudo pdbedit -L

增加一个用户到samba
sudo pdbedit -a username

从samba账户中删除一个用户
sudo pdbedit -x username

显示samba账户信息
sudo pdbedit -r username

测试samba账户是否正常
smbclient -L 192.168.1.1 -U username -d 3

samba的数据库存在哪里
/var/lib/samba/passdb.tdb

samba用户Windows下无法登录
在Windows的运行输入 cmd ，进入终端，输入 net use 命令，将显示已经连接的帐号如 \\192.168.1.1\username
再输入 net use  \\192.168.1.1\username /delete 删除现有的共享连接，再尝试进入另外一个目录就可以正常登录了。

}

Pidgin 的聊天记录在哪里

~/.purple/logs/

安装PDF打印机

sudo apt-get install cups-pdf
#打印生成的pdf文件在 ~/PDF 文件夹里面

nvidia快速重设显示设置及配置多显示器

sudo dpkg-reconfigure xserver-xorg
sudo nvidia-xconfig
#nvidia-settings 用于设置分辨率和多显示器
sudo nvidia-settings

kacpid进程大量占用CPU

硬件驱动中不要激活无线网卡驱动即可
替换上一条命令中的一个短语

^foo^bar^
!!:s/foo/bar/

AMD64位系统安装免费的杀毒软件 avast!

wget http://files.avast.com/files/linux/avast4workstation_1.3.0-2_i386.deb
sudo dpkg --force-architecture -i avast4workstation_1.3.0-2_i386.deb
sudo apt-get install ia32-libs
#然后打开 http://www.avast.com/registration-free-antivirus.php 去申请免费一年的许可证号

应用合适的字体显示尺寸

获取信息
xdpyinfo | grep -B1 dot

例如
 dimensions:    1440x900 pixels (333x212 millimeters)
 resolution:    110x108 dots per inch

Xserver()获取X server信息
{
grep DPI /var/log/Xorg.0.log
例如
[    19.244] (--) NVIDIA(0): DPI set to (110, 108); computed from "UseEdidDpi" X config

这里设置的X DPI会被桌面的顶替，找到你自己的替换，如上的DPI从默认的96改为109。
重新配置键盘类型
}




sudo dpkg-reconfigure keyboard-configuration
重新载入声卡驱动模块

有时候折腾系统突软声卡无法发声了，又不想重启系统，直接重启声卡驱动模块：
pulseaudio -k && sudo alsa force-reload
或者
sudo service pulseaudio restart