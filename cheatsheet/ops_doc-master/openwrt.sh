
openwrt_t_cmake_addison(){
https://github.com/Akagi201/openwrt-extra 扩展openwrt
}


openwrt_i_github_learning(){
https://github.com/robbie-cao/kb-openwrt
https://github.com/robbie-cao/awesome-iot
https://github.com/susong/OpenWrtLearning
https://github.com/kinuswong/LearningOpenwrt
}

openwrt_i_www_learning(){
https://wiki.openwrt.org/doc/start                      # OpenWrt Wiki Documentations（英文）
https://softwaredownload.gitbooks.io/openwrt-fanqiang/content/ #
}

openwrt_i_ddns(){
https://blog.huzhifeng.com/2016/01/20/OpenWrt%E6%B7%BB%E5%8A%A0DDNS%E5%8A%9F%E8%83%BD/
source /home/DDNS.txt
}
openwrt(Keepalived的目的是模拟路由器的高可用，Heartbeat或Corosync的目的是实现Service的高可用){

keepalived主要有三个模块，分别是core、check和vrrp。
1. core模块为keepalived的核心，负责主进程的启动、维护以及全局配置文件的加载和解析。
2. check负责健康检查，包括常见的各种检查方式。
3. vrrp模块是来实现VRRP协议的。

keepalived只有一个配置文件keepalived.conf，里面主要包括以下几个配置区域，
分别是global_defs
static_ipaddress
static_routes
vrrp_script
vrrp_instance
virtual_server。

-------------------------------------------------------------------------------
http://freeloda.blog.51cto.com/2033581/1189137
http://freeloda.blog.51cto.com/2033581/1280962
    VRRP的目的就是为了解决静态路由单点故障问题，VRRP通过一竞选(election)协议来动态的将路由任务
交给LAN中虚拟路由器中的某台VRRP路由器。
    在一个VRRP虚拟路由器中，有多台物理的VRRP路由器，但是这多台的物理的机器并不能同时工作，而是
由一台称为MASTER的负责路由工作，其它的都是BACKUP，MASTER并非一成不变，VRRP让每个VRRP路由器参与竞选，
最终获胜的就是MASTER。MASTER拥有一些特权，比如，拥有虚拟路由器的IP地址，我们的主机就是用这个IP地址
作为静态路由的。拥有特权的MASTER要负责转发发送给网关地址的包和响应ARP请求。

    VRRP通过竞选协议来实现虚拟路由器的功能，所有的协议报文都是通过IP多播(multicast)包(多播地址224.0.0.18)
形式发送的。虚拟路由器由VRID(范围0-255)和一组IP地址组成，对外表现为一个周知的MAC地址。所以，在一个
虚拟路由器中，不管谁是MASTER，对外都是相同的MAC和IP(称之为VIP)。客户端主机并不需要因为MASTER的改变而
修改自己的路由配置，对客户端来说，这种主从的切换是透明的。

    在一个虚拟路由器中，只有作为MASTER的VRRP路由器会一直发送VRRP通告信息(VRRPAdvertisement message)，
BACKUP不会抢占MASTER，除非它的优先级(priority)更高。当MASTER不可用时(BACKUP收不到通告信息)，
多台BACKUP中优先级最高的这台会被抢占为MASTER。这种抢占是非常快速的(<1s)，以保证服务的连续性。
由于安全性考虑，VRRP包使用了加密协议进行加密。

1. VRRP 工作流程
1.1 .初始化：    
    路由器启动时，如果路由器的优先级是255(最高优先级，路由器拥有路由器地址)，要发送VRRP通告信息，
并发送广播ARP信息通告路由器IP地址对应的MAC地址为路由虚拟MAC，设置通告信息定时器准备定时发送VRRP通告信息，
转为MASTER状态；否则进入BACKUP状态，设置定时器检查定时检查是否收到MASTER的通告信息。

1.2 .Master
    设置定时通告定时器；
    用VRRP虚拟MAC地址响应路由器IP地址的ARP请求；
    转发目的MAC是VRRP虚拟MAC的数据包；
    如果是虚拟路由器IP的拥有者，将接受目的地址是虚拟路由器IP的数据包，否则丢弃；
    当收到shutdown的事件时删除定时通告定时器，发送优先权级为0的通告包，转初始化状态；
    如果定时通告定时器超时时，发送VRRP通告信息；
    收到VRRP通告信息时，if 如果优先权为0，发送VRRP通告信息；else 否则判断数据的优先级是否高于本机，
或相等而且实际IP地址大于本地实际IP，设置定时通告定时器，复位主机超时定时器，转BACKUP状态；
否则的话，丢弃该通告包；

1.3 .Backup
    设置主机超时定时器；
    不能响应针对虚拟路由器IP的ARP请求信息；
    丢弃所有目的MAC地址是虚拟路由器MAC地址的数据包；
    不接受目的是虚拟路由器IP的所有数据包；
    当收到shutdown的事件时删除主机超时定时器，转初始化状态；
    主机超时定时器超时的时候，发送VRRP通告信息，广播ARP地址信息，转MASTER状态；
    收到VRRP通告信息时，if 如果优先权为0，表示进入MASTER选举；else 否则判断数据的优先级是否高于本机，
如果高的话承认MASTER有效，复位主机超时定时器；否则的话，丢弃该通告包； 

2 .ARP查询处理
       当内部主机通过ARP查询虚拟路由器IP地址对应的MAC地址时，MASTER路由器回复的MAC地址为虚拟的
VRRP的MAC地址，而不是实际网卡的 MAC地址，这样在路由器切换时让内网机器觉察不到；而在路由器重新启动时，
不能主动发送本机网卡的实际MAC地址。如果虚拟路由器开启的ARP代理 (proxy_arp)功能，代理的ARP回应也回应
VRRP虚拟MAC地址；好了VRRP的简单讲解就到这里，我们下来讲解一下Keepalived的案例。
---------------------------------------
    1. 所以一般Keepalived是实现前端高可用，常用的前端高可用的组合有，就是我们常见的LVS+Keepalived、
Nginx+Keepalived、HAproxy+Keepalived。
    Keepalived针对多网络接口的转发和高可用网络。
    2. Heartbeat或Corosync是实现服务的高可用，常见的组合有Heartbeat v3(Corosync)+Pacemaker+NFS+Httpd 
实现Web服务器的高可用、Heartbeat v3(Corosync)+Pacemaker+NFS+MySQL 实现MySQL服务器的高可用。
    Heartbeat或Corosync针对单网络接口的多服务之间。
Keepalived中实现轻量级的高可用，一般用于前端高可用，且不需要共享存储，一般常用于两个节点的高可用。
而Heartbeat(或Corosync)一般用于服务的高可用，且需要共享存储，一般用于多节点的高可用。
---------------------------------------
    那heartbaet与corosync我们又应该选择哪个好啊，我想说我们一般用corosync，因为corosync的运行机制
更优于heartbeat，就连从heartbeat分离出来的pacemaker都说在以后的开发当中更倾向于corosync，所以现在
corosync+pacemaker是最佳组合。
}

keepalived(global_defs区域){

# global_defs {
#     notification_email {
#         a@abc.com
#         b@abc.com
#         ...
#     }
#     notification_email_from alert@abc.com
#     smtp_server smtp.abc.com
#     smtp_connect_timeout 30
#     enable_traps
#     router_id host163
# }
    notification_email 故障发生时给谁发邮件通知。
    notification_email_from 通知邮件从哪个地址发出。
    smpt_server 通知邮件的smtp地址。
    smtp_connect_timeout 连接smtp服务器的超时时间。
    enable_traps 开启SNMP陷阱（Simple Network Management Protocol）。
    router_id 标识本节点的字条串，通常为hostname，但不一定非得是hostname。故障发生时，邮件通知会用到。
}

keepalived(static_ipaddress和static_routes区域){
    static_ipaddress和static_routes区域配置的是是本节点的IP和路由信息。如果你的机器上已经配置了IP和路由，
那么这两个区域可以不用配置。其实，一般情况下你的机器都会有IP地址和路由信息的，因此没必要再在这两个区域配置。

# # static_ipaddress {
#     10.210.214.163/24 brd 10.210.214.255 dev eth0
#     ...
# }
# # static_routes {
#     10.0.0.0/8 via 10.210.214.1 dev eth0
#     ...
# }

以上分别表示启动/关闭keepalived时在本机执行的如下命令：
# /sbin/ip addr add 10.210.214.163/24 brd 10.210.214.255 dev eth0
# /sbin/ip route add 10.0.0.0/8 via 10.210.214.1 dev eth0
# /sbin/ip addr del 10.210.214.163/24 brd 10.210.214.255 dev eth0
# /sbin/ip route del 10.0.0.0/8 via 10.210.214.1 dev eth0

注意： 请忽略这两个区域，因为我坚信你的机器肯定已经配置了IP和路由。
}
keepalived(vrrp_script区域){

用来做健康检查的，当时检查失败时会将vrrp_instance的priority减少相应的值。
# vrrp_script chk_http_port {
#     script "</dev/tcp/127.0.0.1/80"
#     interval 1
#     weight -10
# }

以上意思是如果script中的指令执行失败，那么相应的vrrp_instance的优先级会减少10个点。
}
keepalived(vrrp_instance和vrrp_sync_group区域){
    vrrp_instance用来定义对外提供服务的VIP区域及其相关属性。
    vrrp_rsync_group用来定义vrrp_intance组，使得这个组内成员动作一致。举个例子来说明一下其功能：
    两个vrrp_instance同属于一个vrrp_rsync_group，那么其中一个vrrp_instance发生故障切换时，
另一个vrrp_instance也会跟着切换（即使这个instance没有发生故障）。

# vrrp_sync_group VG_1 {
#     group {
#         inside_network   # name of vrrp_instance (below)
#         outside_network  # One for each moveable IP.
#         ...
#     }
#     notify_master /path/to_master.sh
#     notify_backup /path/to_backup.sh
#     notify_fault "/path/fault.sh VG_1"
#     notify /path/notify.sh
#     smtp_alert
# }
# vrrp_instance VI_1 {
#     state MASTER
#     interface eth0
#     use_vmac <VMAC_INTERFACE>
#     dont_track_primary
#     track_interface {
#         eth0
#         eth1
#     }
#     mcast_src_ip <IPADDR>
#     lvs_sync_daemon_interface eth1
#     garp_master_delay 10
#     virtual_router_id 1
#     priority 100
#     advert_int 1
#     authentication {
#         auth_type PASS
#         auth_pass 12345678
#     }
#     virtual_ipaddress {
#         10.210.214.253/24 brd 10.210.214.255 dev eth0
#         192.168.1.11/24 brd 192.168.1.255 dev eth1
#     }
#     virtual_routes {
#         172.16.0.0/12 via 10.210.214.1
#         192.168.1.0/24 via 192.168.1.1 dev eth1
#         default via 202.102.152.1
#     }
#     track_script {
#         chk_http_port
#     }
#     nopreempt
#     preempt_delay 300
#     debug
#     notify_master <STRING>|<QUOTED-STRING>
#     notify_backup <STRING>|<QUOTED-STRING>
#     notify_fault <STRING>|<QUOTED-STRING>
#     notify <STRING>|<QUOTED-STRING>
#     smtp_alert
# }

    notify_master/backup/fault 分别表示切换为主/备/出错时所执行的脚本。
    notify 表示任何一状态切换时都会调用该脚本，并且该脚本在以上三个脚本执行完成之后进行调用，keepalived会自动传递三个参数（$1 = "GROUP"|"INSTANCE"，$2 = name of group or instance，$3 = target state of transition(MASTER/BACKUP/FAULT)）。
    smtp_alert 表示是否开启邮件通知（用全局区域的邮件设置来发通知）。
    state 可以是MASTER或BACKUP，不过当其他节点keepalived启动时会将priority比较大的节点选举为MASTER，因此该项其实没有实质用途。
    interface 节点固有IP（非VIP）的网卡，用来发VRRP包。
    use_vmac 是否使用VRRP的虚拟MAC地址。
    dont_track_primary 忽略VRRP网卡错误。（默认未设置）
    track_interface 监控以下网卡，如果任何一个不通就会切换到FALT状态。（可选项）
    mcast_src_ip 修改vrrp组播包的源地址，默认源地址为master的IP。（由于是组播，因此即使修改了源地址，该master还是能收到回应的）
    lvs_sync_daemon_interface 绑定lvs syncd的网卡。
    garp_master_delay 当切为主状态后多久更新ARP缓存，默认5秒。
    virtual_router_id 取值在0-255之间，用来区分多个instance的VRRP组播。

注意： 同一网段中virtual_router_id的值不能重复，否则会出错，相关错误信息如下。  
Keepalived_vrrp[27120]: ip address associated with VRID not present in received packet :
one or more VIP associated with VRID mismatch actual MASTER advert
bogus VRRP packet received on eth1 !!!
receive an invalid ip number count associated with VRID!
VRRP_Instance(xxx) ignoring received advertisment...


可以用这条命令来查看该网络中所存在的vrid：tcpdump -nn -i any net 224.0.0.0/8
    priority 用来选举master的，要成为master，那么这个选项的值最好高于其他机器50个点，该项取值范围是1-255（在此范围之外会被识别成默认值100）。
    advert_int 发VRRP包的时间间隔，即多久进行一次master选举（可以认为是健康查检时间间隔）。
    authentication 认证区域，认证类型有PASS和HA（IPSEC），推荐使用PASS（密码只识别前8位）。
    virtual_ipaddress vip，不解释了。
    virtual_routes 虚拟路由，当IP漂过来之后需要添加的路由信息。
    virtual_ipaddress_excluded 发送的VRRP包里不包含的IP地址，为减少回应VRRP包的个数。在网卡上绑定的IP地址比较多的时候用。
    nopreempt 允许一个priority比较低的节点作为master，即使有priority更高的节点启动。
首先nopreemt必须在state为BACKUP的节点上才生效（因为是BACKUP节点决定是否来成为MASTER的），其次要实现类似于关闭auto failback的功能需要将所有节点的state都设置为BACKUP，或者将master节点的priority设置的比BACKUP低。我个人推荐使用将所有节点的state都设置成BACKUP并且都加上nopreempt选项，这样就完成了关于autofailback功能，当想手动将某节点切换为MASTER时只需去掉该节点的nopreempt选项并且将priority改的比其他节点大，然后重新加载配置文件即可（等MASTER切过来之后再将配置文件改回去再reload一下）。
当使用track_script时可以不用加nopreempt，只需要加上preempt_delay 5，这里的间隔时间要大于vrrp_script中定义的时长。
    preempt_delay master启动多久之后进行接管资源（VIP/Route信息等），并提是没有nopreempt选项。
}
keepalived(virtual_server_group和virtual_server区域){
virtual_server_group一般在超大型的LVS中用到，一般LVS用不过这东西，因此不多说。

# virtual_server IP Port {
#     delay_loop <INT>
#     lb_algo rr|wrr|lc|wlc|lblc|sh|dh
#     lb_kind NAT|DR|TUN
#     persistence_timeout <INT>
#     persistence_granularity <NETMASK>
#     protocol TCP
#     ha_suspend
#     virtualhost <STRING>
#     alpha
#     omega
#     quorum <INT>
#     hysteresis <INT>
#     quorum_up <STRING>|<QUOTED-STRING>
#     quorum_down <STRING>|<QUOTED-STRING>
#     sorry_server <IPADDR> <PORT>
#     real_server <IPADDR> <PORT> {
#         weight <INT>
#         inhibit_on_failure
#         notify_up <STRING>|<QUOTED-STRING>
#         notify_down <STRING>|<QUOTED-STRING>
#         # HTTP_GET|SSL_GET|TCP_CHECK|SMTP_CHECK|MISC_CHECK
#         HTTP_GET|SSL_GET {
#             url {
#                 path <STRING>
#                 # Digest computed with genhash
#                 digest <STRING>
#                 status_code <INT>
#             }
#             connect_port <PORT>
#             connect_timeout <INT>
#             nb_get_retry <INT>
#             delay_before_retry <INT>
#         }
#     }
# }

    delay_loop 延迟轮询时间（单位秒）。
    lb_algo 后端调试算法（load balancing algorithm）。
    lb_kind LVS调度类型NAT/DR/TUN。
    virtualhost 用来给HTTP_GET和SSL_GET配置请求header的。
    sorry_server 当所有real server宕掉时，sorry server顶替。
    real_server 真正提供服务的服务器。
    weight 权重。
    notify_up/down 当real server宕掉或启动时执行的脚本。
    健康检查的方式，N多种方式。
    path 请求real serserver上的路径。
    digest/status_code 分别表示用genhash算出的结果和http状态码。
    connect_port 健康检查，如果端口通则认为服务器正常。
    connect_timeout,nb_get_retry,delay_before_retry分别表示超时时长、重试次数，下次重试的时间延迟。
其他选项暂时不作说明。
}

wifi(AP STA 中继的基本概念){
AP：发出wifi，供别人连接。
STA：连接其他wifi信号
中继：连接其他wifi,并放出wifi供其他人连。主要是为了提高距离。
}
snmp(){
http://www.cnblogs.com/LittleHann/p/3834860.html
}
dns(){
http://www.cnblogs.com/LittleHann/p/3828927.html
}
ospf(){
http://www.cnblogs.com/LittleHann/p/3823513.html
}
ssl(){
http://www.cnblogs.com/LittleHann/p/3733469.html
}
witi(maker开发板){
mkdir -pv $your_own_place/WiTi
cd  $your_own_place/WiTi
git clone https://github.com/mqmaker/witi-openwrt.git openwrt

./scripts/feeds update -a
./scripts/feeds install lvm2
./scripts/feeds install procps procps-top dstat sysstat
./scripts/feeds install openssh-server
./scripts/feeds install luci-app-samba

make V=s -j4
tree -L 1 bin/ramips/
}

openwrt(mqmaker开发板说明){

ref: https://github.com/mqmaker/openwrt
4.1.源码下载
OpenWrt的源代码管理默认用的是SVN下载：
svn co svn://svn.openwrt.org/openwrt/trunk/ .
还可以用Git下载：
git clone git://git.openwrt.org/openwrt.git
git clone git://git.openwrt.org/packages.git
sudo apt-get install subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc flex gcc-multilib
#　sudo apt-get install gcc, binutils, bzip2, flex, python, perl, make, find, grep, diff, unzip, gawk, getopt, subversion, libz-dev and libc headers

#　step
run make menuconfig and set "Target System", "Subtarget", "Target Profile";
run make defconfig;
run make menuconfig and modify set of package;
run scripts/diffconfig.sh >mydiffconfig (save your changes in the text file mydiffconfig);
run make V=s (build OpenWRT with console logging, you can see where build failed.).

list [选项]: 支持的库列表，包括他们的内容和修订版本
选项:
    -n : 列出库名称
    -s : 列出库名称和他们的URL
    -r <库名称>: 列出指定的库
    -d <分隔符>: 使用特定的分隔符来区分每一行(默认:空格)
install [选项] <软件名>: 安装一个软件包
选项:
    -a : 从所有的库中安装所有的软件包或者从指定的库中安装(-p选项).
    -p <库名>: 安装想要的库的软件包
    -d <y|m|n>: 设置新安装的软件默认状态.
    -f : 强制安装软件，如果存在则覆盖
search [选项] <字符串>: 搜索一个软件包
选项:
    -r <库名>: 仅搜索这个库

uninstall -a|<软件包>: 卸载一个软件包
选项:
    -a : 卸载所有的软件包

update -a|<库名>: 升级所有的软件包和所有的在feeds.conf中指定的库.
选项:
    -a : 升级feeds.conf中所有的库列表.否则升级指定的库
    -i : 重建索引文件，不会升级库
clean: 删除已经下载的和生成的文件
}

linux_kernel(mqmaker内核说明){
https://github.com/mqmaker/miqi-linux-kernel

gzip -cd ../patch-3.x.gz | patch -p1
bzip2 -dc ../patch-3.x.bz2 | patch -p1

make mrproper

# kernel source code: /usr/src/linux-3.X
# build directory:    /home/name/build/kernel
cd /usr/src/linux-3.X 
make O=/home/name/build/kernel menuconfig 
make O=/home/name/build/kernel 
sudo make O=/home/name/build/kernel modules_install install
     
make V=1 all

nm vmlinux | sort | less
}

./scripts/feeds update packages
./scripts/feeds install -a -p packages


openwrt(对版本构建过程的整合){
1、创建 Linux 交叉编译环境；然后编译host工具，在编译编译工具链。最后编译目标平台的各个软件包。
编译make进入各个模块进行编译时，首先下载代码压缩包，然后解压缩，并打补丁，再根据设置选项来生成Makefile，最后根据
生成的Makefile进行编译和安装。
2、建立 Bootloader；
3、移植 Linux 内核；
4、建立 Rootfs (根文件系统)；
5、安装驱动程序；
6、安装软件；
通过openwrt快速构建一个应用平台，openwrt从交叉编译器，到linux内核，再到文件系统甚至bootloader
都整合在了一起，形成了一个SDK环境。
-------------------------------------------------------------------------------
1.  下载交叉编译工具，比如内核头文件； 
2.  创建阶段性目录(staging_dir/）。交叉编译工具链将会被安装到这里(比如toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/)。
如果你要使用这个交叉编译工具链编译特定的程序，你可以在这个目录找到交叉编译工具。嵌入式根文件系统也会安装到
staging_dir/目录，比如target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips
3.  创建下载目录(默认为dl/)。所有源码包会被下载到这个目录； 
4.  创建编译目录(build_dir/)。所有用户空间工具会在这里编译； 
5.  创建目标根文件系统目录(比如build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips/)以及根文件系统框架。 
6.  安装用户空间软件包到根文件系统以及压缩整个文件系统为适当的格式。
}

openwrt(和官方仓库保持同步-OpenWRT 编译doc文件-增加设备支持){

笔记：https://github.com/wongsyrone/LinuxNotes/blob/master/06.md
# 和官方仓库保持同步
很多时候，我们在自己的某个Repository里面进行修改或者开发操作，所以要保证我们的代码与官方的代码保持同步。
官方仓库的地址是 git://git.openwrt.org/openwrt.git 或者 http://git.openwrt.org/openwrt.git。其他在GitHub上的仓库貌似都是镜像，比如openwrt-es以及openwrt-mirror。
如果还没进行过多少修改的代码，可以直接fork给出的repo，然后可以方便的使用github本身看我们的分支和官方的代码有多少的超前和滞后提交，可以作为一个提醒。
接下来，我们建立一个远程仓库名为upstream：

$ git remote -v   // 首先列出远程仓库，一般只有一个origin
$ git remote add upstream http://git.openwrt.org/openwrt.git
这样就建立好了，我们可以接着列出远程仓库看一下.如果需要变更或者删除远程仓库的话，请参考git remote的manpage.
有的人喜欢使用git pull，但是官方推荐的是使用fetch然后merge，这样有什么区别还有冲突都一目了然.

$ git fetch upstream master   // 从官方拉下来最新代码，一般只取得master就行了，其他分支根据需求选择
$ git checkout master   // 切换到主分支，或者是切换到你需要merge到的分支
$ git merge upstream/master // 自动merge进上面切换到的分支中，可以自动或者手动解决冲突
这种方法进行的是三方合并，每次都会产生一个合并的commit，看一下git log顿时瞎眼，对于强迫症而言怎么能忍？

另外一种单线git log的方式，适用于各种强迫症患者：

既然是单线方式，最有可能的也就是git-rebase了，基本思路是本地建立一个upstream分支，跟踪上游的变化，只使用git-fetch拉取上游，定期在本地master上进行rebase.
$ git fetch upstream master  // 继续拉取上游最新commit
$ git checkout -b upstream upstream/master  //以 upstream/master 为分界点取出一个名为upstream的分支
$ git checkout master // 切换到主分支
$ git rebase -i upstream // 将 upstream 分支rebase进本地的主分支
$ git branch -d upstream // 最后可以删除upstream分支，如果没有完全rebase进来的话是不会让你删除这个分支的
上面的方法有一个shortcut，前提设置好upstream作为远程跟踪，之后使用
$ git pull upstream master --rebase
如果使用 git pull --rebase 则是默认对 origin master 进行操作。
当然git-rebase我也用不好，如果发现方法不对或者有更好办法欢迎PR
这样，我们就能时刻和官方保持一致了.


# OpenWRT 编译 doc 文件
在 OpenWrt 的 trunk 分支中有一个文件夹名为 doc，在这个文件夹中包含一部分文档可供参考，是用 LaTeX 写的，我们需要编译之后才能阅读的更顺畅，编译之后默认生成 .pdf 和 .htm 文件。
在 Ubuntu 我们可以使用 apt-get 从网络上直接下载包来安装。
我们用到的三个比较重要的命令有 apt-cache search 、apt-cache show 和 sudo apt-get install

首先使用
$ apt-cache search latex
我们可以看到许多包被列出。选择安装texlive-latex-base, 它的描述是：Tex Live: Basic LaTex packages
sudo apt-get install texlive-latex-base
这样就安装好Latex了，可以直接使用。 但编译中文时，由于没有安装CJK中文环境，会提示找不到CJK包。
$ apt-cache search cjk
选择安装latex-cjk-all, 它的描述是：Installs all LaTex CJK packages.
sudo apt-get install latex-cjk-all 
这样就可以使用中文环境了。
有些.sty文件可能没有安装，例如：lastpage.sty. 这个时候不要到网络上去询问是因为什么， Latex的输出错误信息已经很明显了。 使用下面的命令来查找相应的包。 注意不要加.sty文件后缀
$ apt-cache search lastpage
可以看到需要下面的包，以及对这个包的描述：texlive-latex-extra - TeX Live: LaTeX supplementary packages 选择安装即可：
sudo apt-get install texlive-latex-extra
完成上面的这三步，就可以基本满足平时的应用需求了。如果以后需要使用新的包，可以使用上面的方法来查找相应的安装包，并选择安装即可。


# 增加设备支持
# 前提
如果是专业搞过嵌入式开发的，懂得架构以及其他必要知识的可以忽略这个前提，接下来就是我要说的了，找一款和你想要添加的设备很相近且官方已经有了支持的型号，至少要是相同的平台，比如ar71xx.这部分基本上围绕这个前提来展开。
# 所需

完整 OpenWrt 开发环境. 包括编辑器, 配置好的 quilt 工具.
假设之前已经编译过 bin, 有完整的 .config 和 toolchain.
目前看到的很多教程教人直接修改现有的 patch 文件或者是 tmp/ 文件夹下的文件，更甚者胡乱猜测，这样会导致一些问题。
比如源码更新的时候，许多 Patch 文件的偏移（offset）会发生变更，主要体现在 linux 内核版本升级的时候，这样直接修改现成的 Patch 就会增添许多烦恼，其实官方有一个很好的东东，那就是这个 quilt，它是用来管理代码树中的 patch 的嵌入式内核开发利器!
增加 Device-Specific 支持文件
这个部分的文件是单独的，与其他的文件比如各种 Patch 没有较大的关联，在重新编译之前只需要make clean就行。
我们以添加 TP-Link TL-WR2041N v1 版本为例子进行说明：
新手刚开始添加支持的时候最好在取出最新的 trunk 代码之后立即进行，防止其他文件干扰，如果之前做过类似的操作或者懂得目录结构、知道文件是做什么用的，可以忽略这个建议。
删除 tmp/ 目录，这个是大坑，因为这个文件夹内的内容全是生成的，没必要进行更改。
$ rm -rf tmp/
首先，如同前文所述，确定好相近的型号，方便添加支持。我这个型号的板子与国外的 WDR3500 相似，与国内的 TP-Link TL-WR941N v6 相同，我是通过 WDR3500 进行添加的。
搜索以下相关的文件，以确定需要修改什么文件，之后照猫画虎。
运行 grep wdr3500 trunk/* -r -l 得到的结果如下，我已经做好了分类：
// 这部分是Device-Specific的
trunk/target/linux/ar71xx/base-files/etc/diag.sh
trunk/target/linux/ar71xx/base-files/etc/uci-defaults/01_leds
trunk/target/linux/ar71xx/base-files/etc/uci-defaults/02_network
trunk/target/linux/ar71xx/base-files/lib/upgrade/platform.sh
trunk/target/linux/ar71xx/base-files/lib/ar71xx.sh
trunk/target/linux/ar71xx/files/arch/mips/ath79/mach-tl-wdr3500.c
// 这部分是制作镜像的相关文件
trunk/target/linux/ar71xx/image/Makefile
trunk/target/linux/ar71xx/generic/profiles/tp-link.mk
trunk/tools/firmware-utils/src/mktplinkfw.c
// 这部分是内核支持相关的文件
trunk/target/linux/ar71xx/config-3.10
trunk/target/linux/ar71xx/patches-3.10/610-MIPS-ath79-openwrt-machines.patch
得到的文件就是基本的支持文件了，我们一个一个说。


diag.sh # 初始化时闪烁的灯的配置，一般的路由启动的时候只闪烁 System 灯或者电源灯
uci-defaults/01_leds # 
    ucidef_set_led_netdev 多用于定义 WAN 口; 修改最后的 eth0 为你对应的设备名称； 
    ucidef_set_led_wlan 多用于定义 WLAN 口;最后的 phyxtpt目前见到的只有 x=0 和1两种情况，这个和设备初始出来的phy物理设备相关；
    ucidef_set_led_switch 用来定义交换机的配置，最后的 0x00 部分是端口掩码，
    
    比如2041n v1：
        tl-wr2041n-v1)
            ucidef_set_led_netdev "wan" "WAN" "tp-link:green:wan" "eth0"
            ucidef_set_led_switch "lan1" "LAN1" "tp-link:green:lan1" "switch0" "0x02"
            ucidef_set_led_switch "lan2" "LAN2" "tp-link:green:lan2" "switch0" "0x04"
            ucidef_set_led_switch "lan3" "LAN3" "tp-link:green:lan3" "switch0" "0x08"
            ucidef_set_led_switch "lan4" "LAN4" "tp-link:green:lan4" "switch0" "0x10"
            ucidef_set_led_netdev "wlan" "WLAN" "tp-link:green:wlan" "wlan0"
            ucidef_set_led_wlan "wlan" "WLAN" "tp-link:green:wlan" "phy1tpt"
            ;;
    
uci-defaults/02_network
    该文件定义初始化网络信息，主要是交换机和 vlan，
        tl-wr2041n-v1)
            ucidef_set_interfaces_lan_wan "eth0" "eth1"
            ucidef_add_switch "switch0" "1" "1"
            ucidef_add_switch_vlan "switch0" "1" "0 1 2 3 4"
            ;;
            
uci-defaults的说明
    tl-wr2041n-v1)
        ucidef_set_interfaces_lan_wan "eth0" "eth1"
        ucidef_add_switch "switch0" \
            "0@eth0" "1:lan:4" "2:lan:3" "3:lan:2" "4:lan:1"
        ;;
lib/upgrade/platform.sh
    比如 2041n v1：
        tl-wdr3500 | \
        tl-wr2041n-v1 | \
    添加到了wdr3500的下方。

lib/ar71xx.sh
第一个是硬件 magic number，可以用 WinHex 打开固件文件，查看对应的偏移即可找到，model 定义的是显示的设备名称，
下面的 *"TL-WR2041N v1" 要对应设备支持的 mach C语言设备文件中定义好的名称；同样的， name 定义的是内部传递的值，
最好与上面添加的行一致。简单来说，涉及到型号名称的最好都保持一致。
比如 2041n v1：
        "204100"*)
		model="TP-Link TL-WR2041N"
		;;
	*"TL-WR2041N v1")
		name="tl-wr2041n-v1"
		;;

files/arch/mips/ath79/mach-tl-wdr3500.c

镜像生成的相关文件
    trunk/target/linux/ar71xx/image/Makefile
    该文件主要修改如下两行，剩下的内容需要仔细学习 Makefile的写法才能看懂。
    $(eval $(call MultiProfile,TLWR2041,TLWR2041NV1))
    该行定义多Profile，一般是一个型号生成多个硬件版本支持的定义
    $(eval $(call SingleProfile,TPLINK-LZMA,64kraw,TLWR2041NV1,tl-wr2041n-v1,TL-WR2041N-v1,ttyS0,115200,0x20410001,1,4Mlzma))

}
https://github.com/bluecliff/wifi-cat/wiki/OpenWRT%E7%BC%96%E8%AF%91%E8%BF%9B%E9%98%B6

# 问题处理
https://openwrt.io/docs/build-firmware/

openwrt(MTK芯片说明){
https://wiki.openwrt.org/doc/hardware/soc/soc.mediatek  # mediatek

https://wiki.openwrt.org/doc/hardware/soc               # soc
https://wikidevi.com/wiki/MediaTek_MT7620               # MT7620产品
https://wikidevi.com/wiki/MediaTek_MT7621               # MT7620产品
https://wikidevi.com/wiki/MediaTek                      # MT产品
}

openwrt(git：长期支持版本){
10.03 branch (Backfire)
Main repository
git clone git://git.openwrt.org/10.03/openwrt.git backfire
Packages feed
git clone git://git.openwrt.org/10.03/packages.git

12.09 branch (Attitude Adjustment)
Main repository
git clone -b attitude_adjustment git://github.com/openwrt/openwrt.git
Packages feed
git clone git://git.openwrt.org/12.09/packages.git

14.07 branch (Barrier Breaker)
Main repository
git clone -b barrier_breaker git://github.com/openwrt/openwrt.git

15.05 branch (Chaos Calmer)
Main repository
git clone -b chaos_calmer git://github.com/openwrt/openwrt.git

Main repository
git clone git://github.com/openwrt/openwrt.git

git diff target/linux/
svn revert -R target/linux/
--------------------------------------- 迭代更新说明
Linksys -> openwrt
backfire:相对稳定的版本， Linux 2.6.32 Web(uhttpd) /etc/openwrt_release
Attitude Adjustment: Linux 3.3 支持并行编译，支持ramips和bcm2708(树莓派)，支持网桥防火墙
Barrier Breaker：Linux 3.10 支持IPv6， 增加配置更改按需触发服务器启动机制；支持动态防火墙规则，增加网桥的多播传输到单播传输的转换。
Chaos Calmer: Linux 3.18添加了多个3G/4G路由器支持，增加了自管理网络的支持，各种平台和驱动设备的支持。

#chaos_calmer
https://dev.openwrt.org/browser#branches/chaos_calmer
svn://svn.openwrt.org/openwrt/branches/chaos_calmer          svn代码地址
git://git.openwrt.org/15.05/openwrt.git                      git代码地址
svn://svn.openwrt.org/openwrt/branches/chaos_calmer-r46767   发布版本

#barrier_breaker
https://dev.openwrt.org/browser#branches/barrier_breaker
svn://svn.openwrt.org/openwrt/branches/barrier_breaker        svn代码地址
git://git.openwrt.org/14.07/openwrt.git                       git代码地址
svn://svn.openwrt.org/openwrt/branches/barrier_breaker-r42625 发布版本

#attitude_adjustment
https://dev.openwrt.org/browser#branches/attitude_adjustment
svn://svn.openwrt.org/openwrt/branches/attitude_adjustment    svn代码地址
git://git.openwrt.org/12.09/openwrt.git                       git代码地址
svn://svn.openwrt.org/openwrt/tags/barrier_breaker_12.09      发布版本

git clone git://git.openwrt.org/15.05/openwrt.git  cc # cc为存放代码的目录
}

http://blog.csdn.net/sinat_36184075/article/details/72231970 # 智能路由器笔记
openwrt(智能路由器-介绍){
1. 领导者          决定着社区的规则和技术方向
2. 基础设施        代码管理工具Git，邮件列表，自动构建工具buildbot，文档管理工具Wiki，Trac和技术论坛
3. 实现软件的技术  统一编译框架、统一配置接口、开发的软件包管理系统以及读写分区系统，系统总线ubus和进程管理模块procd.

2.1 代码管理工具Git：Who When Why What(谁做了修改，什么时间做了修改，为什么修改以及修改的内容是什么)
    svn list svn://svn.openwrt.org/openwrt/   # svn
    https://dev.openwrt.org/browser           # https
    http://git.openwrt.org/                   # git
    trunk 保存开发的主线，一般最新的功能均在trunk目录提交
    branch:目录存放分支，用于功能开发完成之后创建分支、修改BUG及发布版本使用
    tags目录保存标签的复制，一个标签是一个项目在某一时间点的"快照"，用来给发布版本的代码创建快照，以便
    大多数开发人员基于这个版本开发进行修改及测试使用，一般永远不再修改。
2.2 邮件列表是：代码审查以及代码提交集成的地方，开发人员将修改代码生成补丁发送给所有邮件订阅者。
    邮件列表和普通邮件的主要区别在于订阅机制和存档机制，每个人都可以自由订阅并查看历史邮件。
2.3 buildbot的核心是一个作业调度系统，他会将任务排队，当提供了任务所需要的资源时，执行任务并报告结果。
2.4 Wiki可以让任何参与人员非常方便地进行编辑、搜索和访问。
    Wiki使用简化的语法来代替复杂的HTML语言，降低了内容维护的门槛。
2.5 Trac是一个集成Wiki和问题跟踪管理系统的项目管理平台，可以帮助开发人员更好地管理软件开发过程，从而开发出高质量的软件。
    Trac：提交Bug和查询当前的进程。Trac:采用面向进度的项目管理模型，采用里程碑的方式来组织开发。
    
3.1 统一编译框架 自动化方式来生成固件：编译环境检查，生成交叉编译链，下载代码包，打补丁，编译及生成固件。
3.2 统一配置接口 /etc/config
3.3 开发的软件包管理系统以及读写分区系统
3.4 系统总线ubus                           每个进程均可以注册到系统总线上进行消息传递，并且提供命令行工具来访问系统总线
3.5 进程管理模块procd                      每一个进程提交给procd来启动，并在意外退出之后再次调用。

http://openwrt.bjbook.net/            智能路由器开发指南OpenWrt网站
http://openwrt.bjbook.net/download/   Index of OpenWrt15.05.1
http://openwrt.bjbook.net/source/     代码搜索引擎

1. 管理平面       LuCI/UPNP/TR069/SNMP
2. 控制平面       bash UCI lua [UCI config File] [ip dhcp dnsmasq iptables iw arp] -> netlink
3. 数据转发平面   Linux Kernel |netfilter|router|转发

Tomato DD-WRT openWrt CoolShell VyOS
https://brezular.com/2014/07/12/vyos-x64-installation-on-qemu/ 
}

feed(./scripts/feeds){
list [options]:
    -n :            显示feeds.conf或feeds.conf.default 内的子包名称
    -s :            显示feeds.conf或feeds.conf.default 内的子包名称 以及对应的URL地址
    -r <feedname>:  显示feeds.conf或feeds.conf.default 内的子包名称对应向各个模块名称
    -d <delimiter>: 列分隔符
    -f :            -s的兼容方式显示
install [options] 
 -a :           安装feeds源中的所有模块 or 或者-p指定的特定模块.
 -p <feedname>: 优先使用指定的packages
 -d <y|m|n>:    设置新安装模块的策略
 -f :           Install will be forced even if the package exists in core OpenWrt (override)
 search -r <feedname>
 uninstall -a|<package>
 update -a|<feedname(s)>:
 -a : 更细所有feeds.conf中列出的模块
 -i : 重新创建index
 clean: Remove downloaded/generated files.
}

feed(feeds.conf.default){
src-git packages https://github.com/openwrt/packages.git;for-15.05 # 由社区维护的构建脚本，选项和应用程序，库和模块的补丁
# ./scripts/feeds update packages         使能                     # 在buildroot的根目录上创建，feeds/packages目录结构基本与git目录一致
# ./scripts/feeds install -a -p packages  安装                     # 
1. admin -> {debootstrap  htop  ipmitool  monit  muninlite  netdata  openwisp-config  sudo  syslog-ng  zabbix}
2. devel -> {autoconf  automake  diffutils  gcc  libtool-bin  lpc21isp  lttng-modules  lttng-tools  m4  make  patch  pkg-config}
3. ipv6  -> {tayga}
4. kernel -> {exfat-nofuse  mtd-rw}
5. libs   -> {alsa-lib  glpk   libdouble-conversion  libjpeg   libsamplerate  libuv  poco ... ...}
6. mails  -> {alpine clamsmtp  emailrelay  greyfix  mailsend  msmtp-scripts  nail postfix ... ...}
7. multimedia -> {ffmpeg grilo gst1-plugins-bad   gst1-plugins-ugly  ices mjpg-streamer  tvheadend ... ...}
8. net -> {acme darkstat ifstat mosquitto openssh shadowsocks-libev  tinyproxy ... ...}
9. sound -> {alsa-utils  fdk-aac lame mocp  mpd opus-tools  portaudio   shairplay shine  squeezelite  upmpdcli ... ...}
10. utils -> {acl collectd gkermit lm-sensors    open2300 rtklib tcsh ... ...}
src-git luci https://github.com/openwrt/luci.git;for-15.05         

src-git routing https://github.com/openwrt-routing/packages.git;for-15.05 # 由社区维护的路由包
# ./scripts/feeds update routing
# ./scripts/feeds install -a -p routing
1. routing feed
src-git telephony https://github.com/openwrt/telephony.git;for-15.05
1.  libs、net
src-git management https://github.com/openwrt-management/packages.git;for-15.05
1. freecwmp、freenetconfd-plugin-examples、freenetconfd、 freesub、 libfreecwmp、libmicroxml、libnetconf、shflags、shtool
}

git(update){
cd feeds/[luci management packages routing telephony] && git pull
git log # 历史信息

 ./scripts/feeds update -a 
 ./scripts/feeds install <PACKAGENAME> # 使下载的软件包可以出现在make menuconfig配置菜单中
 ./scripts/feeds install –a            # 使下载的软件包可以出现在make menuconfig配置菜单中
}

root(当前版本已经去掉了){
vi include/prereq-build.mk 
define Require/non-root 
#      [ "$$(shell whoami)" != "root" ] 
endef
}
Buildroot(taojin@ccs.neu.edu){
Buildroot包括Makefiles,patches和scripts。
          用以生成交叉编译工具链，现在Linux内核，生成根文件系统和管理第三方代码包。
          Makefiles决定了下载Linux内核版本信息和下载第三方软件的版本信息。以及编译出来一个image
在Buildroot源代码树中，没有任何Linux内核和第三方开源代码。
https://dev.openwrt.org/wiki/GetSource

1. Check out Buildroot from SVN Server
svn co –r 30368 svn://svn.openwrt.org/openwrt/trunk/
svn co svn://svn.openwrt.org/openwrt/trunk/
https://dev.openwrt.org/wiki/GetSource
2. cd trunk
  git pull
3. ./scripts/feeds update
4. make package/symlinks 
   make menuconfig
   make defconfig
5. make menuconfig
   scripts/diffconfig.sh > mydiffconfig # 配置版本和defconfig之间的差异文件
6. make world

openwrt-ramips-mt7621-dir-860l-b1-squashfs-factory.bin      # factory预留原厂分区
# 对于一般路由器而言，factory.bin是用于从原厂固件刷为openwrt。
openwrt-ramips-mt7621-dir-860l-b1-squashfs-sysupgrade.bin   # sysupgrade只包含openwrt分区
# 而sysupgrade.bin用于从openwrt更新openwrt。
openwrt-ramips-mt7621-dir-860l-b1-squashfs-tftp.bin
factory与sysupgrade
    360的所谓factory固件，是一个根解密后的360原厂固件格式类似的固件。
    而sysupgrade固件，是一个从格式上更为精简，但功能不变的固件。
    具体来说，factory固件多一层文件头和md5验证。
  
  在原厂固件的基础上进行升级时，首先使用factory文件，然后需要再次使用 sysupgrade文件，选择不保留原来配置进行升级。

tftp:包括32字节的头。

arp -s 192.168.11.1 02:aa:bb:cc:dd:1a # u-boot在启动的时候使用固定的MAC地址，启动之后使用另一个MAC地址

$ tftp 192.168.11.1
> binary
> rexmt 1 
> timeout 60 
> trace 
> put openwrt-ramips-mt7621-dir-860l-b1-squashfs-tftp.bin


# openwrt没有集成bootloader，只有文件系统和内核
openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin # openwrt生成的内核和文件系统在一起的镜像
openwrt-ramips-rt305x-uImage.bin                     # openwrt生成的内核镜像
openwrt-ramips-rt305x-vmlinux.bin                    # openwrt生成的内核镜像
openwrt-ramips-rt305x-vmlinux.elf                    # openwrt生成的内核镜像
openwrt-ramips-rt305x-root.squashfs                  # openwrt生成的文件系统镜像

}

uboot(mtk){
按2为通过TFTP方式刷系统固件
按9为通过TFTP方式刷UBOOT
然后Y
确认路由IP 为192.168.1.1
确认电脑IP 为192.168.1.3
输入固件名openwrt-ramips-mt7628-mt7628-squashfs-sysupgrade.bin


}

compile_oolite_v8_openwrt(oolite_v8版本官方说明){

# 如何编译
http://oolite.cn/how-to-compile-oolite-v8-openwrt-15-05-firmware.html
# 如何升级
http://oolite.cn/oolite-v8-upgrade-instruction.html
1. Serial
2. Httpd
3. OpenWRT LuCI
4. Winscp + mtd  update firmware
http://oolite.cn/oolite-v8-0-specification.html
# 板载规格

http://oolite.cn/category/openwrt
    http://oolite.cn/how-to-disable-the-uart-console.html
    http://oolite.cn/openwrt-network-configuration.html  -> http://www.macfreek.nl/memory/OpenWRT_Network_Configuration
    http://oolite.cn/how-to-use-usb-storage.html
    http://oolite.cn/how-to-use-cpu-uartdebug-port.html
    http://oolite.cn/use-3g4g-modem.html
# mtk 论坛
https://zh.forum.labs.mediatek.com/

https://github.com/ooioe/OoliteV1trunk  # trunk
}

luci_theme_bootstrap(){
https://github.com/LuttyYang/luci-theme-material
http://nut-bolt.nl/2012/openwrt-bootstrap-theme-for-luci/

https://github.com/Aslin-Ameng/OpenWrt-luci-theme-material

https://github.com/openwrt/luci/wiki/ThemesHowTo

}
# git clone https://github.com/lede-project/source lede 

sudo apt-get install subversion build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc flex gcc-multilib
git clone git://git.openwrt.org/openwrt.git # 下载完 openwrt 的源码后，为了使 openwrt 支持更多的软件，需要更新和安装其他源上面的软件
./scripts/feeds update -a
./scripts/feeds install -a
    
openwrt(智能路由器-版本构建说明){
Target System(x86):目标平台，例如一般Windows系统均为X86系统架构，嵌入式路由器通常有ARM、MIPS系统和博通系统等。
                   # 目标硬件平台的芯片组架构
Target Profile     # 目标硬件的类型；一些依赖于硬件的配置文件。例如与网络相关的以太交换驱动。
Target Images     : 编译生成物控制，根据目标平台不同选项不同。例如根文件系统格式，内核空间大小和是否生成VirtualBox镜像文件。
                   # 大多数平台需要squashfs
Global Build settings： 全局编译设置，例如是否打开内核namespace等
Advanced configuration options： 针对开发人员的高级配置选项，包括设置下载文件目录，编译log和外部编译工具目录等。
Build the OpenWrt Image Builder：是否生成OpenWrt的软件开发包，这样就可以离开Openwrt整体环境而进行模块编译和增加功能。
Image configuration： 固件生成的软件包模块，即是否打开feed.conf中的各个模块
Base system： OpenWrt基本系统，包括Openwrt的基本文件系统base-files模块、实现DHCP和DNS代理的dnsmasq模块、软件包管理模块opkg、
              通用库ubox、系统总线ubus和防火墙firewall，等等
Development： 开发包，例如调试工具gdb；代码检查和调优工具valgrind等
Fireware：     各种硬件平台固件
Kernel Modules：内核模块，运行在操作系统内部。例如加密模块、各种USB驱动和netfilter扩展模块等
Language： 不是国际化中的多语言支持模块，而是软甲开发语言模块，现在可选的有perl和lua
libraries: 一些动态链接库，例如XML语言解析库libxml2,和内核进行通行的libnfnetlink库，压缩和解压缩算法zlib，微型数据库libsqlite3等
luCI： Openwrt管理UI模块,例如动态DNS管理模块luci-app-ddns,防火墙管理模块luci-app-firewall和Qos管理模块luci-app-qos等等
Mail： 邮件传输客户端模块，例如msmtp软件包
MultiMedia：多媒体模块，例如ffmpeg
network： 网络功能，OpenWrt具有特设的核心模块，如防火墙、路由、VPM和文件传输
Sound：音频模块
Utilies： 一些不常用的实用工具模块

make help # ubuntu编译环境安装，feed update和install命令说明，以及make menuconfig 和 make命令
          # scripts/flashing/flash.sh [tftp] ； make -C docs/
--------------------------------------- feeds
./scripts/feeds update -a  # feeds.conf / feeds.conf.default [the latest package definitions]
                           # 获得最新的安装包定义：数据包定义来源于 feeds.conf 或 feeds.conf.default
# 产生$(TOPDIR)/feeds目录，存放的就是执行feeds.conf.default文件后的结果：从指定svn|git中下载的文件
# -> ./scripts/feeds update luci-app-firewall
./scripts/feeds install -a # [install symlinks of all of them into package/feeds/]
                           # 创建链接文件：package/feeds/. 
# 在package目录中多了一个feeds目录，里面存放的子目录是到$(TOPDIR)/feeds目录的链接
# -> ./scripts/feeds update luci-app-firewall
./scripts/feeds update -a && ./scripts/feeds install -a == make package/symlinks # TOPDIR/Makefile {package/symlinks:}

# 注意：./scripts/feeds 这个脚本只是使软件包可以出现在make menuconfig配置菜单中，而并不是真正的安装或者编译软件。
# feeds命令将安装扩展代码包编译选项。如果不运行该命令，在menuconfig配置时将没有选择这些扩展包的机会。
--------------------------------------- make
make menuconfig            # 首先选择soc版本，再选择版本类型，最后make defconfig。使用默认配置保证硬件支持性。
                           # 其次，与硬件不相关的软件包可以在make defconfig之后进行安装包选择
                           # Advanced configuration options (for developers)
                           # ---- Binary folder                      可执行代码输出文件夹
                           # ---- Download folder                    下载源代码输入文件夹
                           # ---- Local mirror for source packages   本地下载源代码目录路径
                           # target/linux/ramips/mt7620/config-3.10
                           # package/kernel/linux/modules/
                           # package/utils/util-linux
# toplevel.mk中的"menuconfig:"
# 目标平台选择，linux内核版本选择（CONFIG_LINUX_2_6_32=y），一些default功能，目标文件系统（CONFIG_TARGET_ROOTFS_SQUASHFS=y），
# 基本编译方法（Gcc的版本，uClibc的版本，BINUTILS的版本，等等），其他基本都是针对TOPDIR/package目录中实际选择要编译的各个package
# 的选择定义了。可见，这个.config文件将用户态的东西都包括了，但是没有内核态的东西。内核态的config文件在哪里呢？
--------------------------------------- config [
1. 选择y设置为<*>，表示将软件包编译进固件image 文件；
2. 选择m设置为<M>，表示软件包会被编译，但不会编译进固件image 文件。Openwrt会把设置为M选项的软件包编译后再制作成
   一个以ipk 为后缀（.ipk）的文件，然后在设备上通过opkg来安装到设备上；
配置主要包括4个部分 
1. Target system        （目标系统）       Target(s)   # 见openwrt/toh/start内表格说明   1). 选择 CPU 型号
   Subtarget            （目标板载）       Platform(s) # 见openwrt/toh/start内表格说明   2). 选择 CPU 子型号
   Target Profile       （目标板载）       model(s)    # 见openwrt/toh/start内表格说明   3). 选择具体路由器型号
2. Package selection    （软件包选择） 
3. Build system settings（编译系统设置） 
4. Kernel modules       （内核模块配置）
http://wiki.openwrt.org/toh/start      
openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin
openwrt-ramips-[Target(s)]-[model(s)]-squashfs-sysupgrade.bin
# openwrt-ramips-mt7621-oolite-v8-32MB-15.05-squashfs-sysupgrade.bin 当前使用版本
--------------------------------------- config ]
make kernel_menuconfig CONFIG_TARGET=subtarget  # grep CONFIG_TARGET .config
make kernel_menuconfig     # make kernel_menuconfig CONFIG_TARGET=subtarget  [target, subtarget]
                           # openwrt源码中的linux补丁文件放在$<openwrt_dir>/target/linux/generic/文件下面，有对于不同版本的linux内核补丁。
                           # ./patches-3.18/921-use_preinit_as_init.patch
                           # 可以看到他修改linux中默认的启动项，可以看到它首先启动/etc/preinit.他是一个脚本，咱们就从脚本说起.
# toplevel.mk中的"kernel_menuconfig:"  -> build_dir/linux-brcm47xx/linux-2.6.32.27/.config中
make defconfig             # 在这里检查所需的编译工具是否齐备，并生成默认的编译配置文件.config
make prereq
make V=99                  # V=99表示输出详细的debug信息
make V=s                   # 可以输出遍历过程中每一步的之行动作，出错后显示详细的错误信息
make -j2                   # V=s：输出编译的详细信息，这样编译出错时，我们才知道错在哪里 
# -j：多进程编译，这样编译快些。-j 指定的参数一般为你的CPU核数+1，比如双核CPU就指定为3 
make                       # build your firmware
IGNORE_ERRORS=1 make <make options>  # Skipping failed packages
make V=s ; echo -e '\a'              # Getting beep notification
make V=s 2>&1 | tee build.log | grep -i error # Spotting build errors
                                              # /openwrt/trunk/build.log
ionice -c 3 nice -n 19 make -j2 # Building in the background

make download     # 下载所有已选择的软件代码压缩包
make clean        # 删除编译目录          ./bin和./build_dir
                  # rm -rf $(BUILD_DIR) $(STAGING_DIR) $(BIN_DIR) $(BUILD_LOG_DIR)
make dirclean     # 除了删除目录之外还删除编译工具目录 
                  # ./bin ./build_dir ./staging_dir ./toolchain和./logs
                  # rm -rf $(STAGING_DIR_HOST) $(TOOLCHAIN_DIR) $(BUILD_DIR_HOST) $(BUILD_DIR_TOOLCHAIN) $(TMP_DIR)
make distclean    # ./bin ./build_dir ./staging_dir ./toolchain和./logs, .config和dl目录下载的内容
make printdb      # 输出所有编译变量定义

scripts/flashing/flash.sh  # remotely updating your embedded system via tftp.

--------------------------------------- 软件包 https://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
make package/tcpdump/download   V=99    # 
make package/tcpdump/prepare    V=99    # 进行编译准备，包含下载软件代码包、并解压缩和打补丁
make package/tcpdump/configure  V=99    # 根据设置选项进行配置并生成Makefile
make package/tcpdump/compile    V=99    # 根据生成的Makefile进行编译
make package/tcpdump/clean      V=99    # 清除编译生成的文件，包含安装包及编译过程生成的临时文件
make package/tcpdump/install    V=99    # 生成安装包
make package/tcpdump/installdev V=99    # 生成安装包

make package/index V=s # 使用本地源构建一个opkg库索引

# 如何构建一个tmux包  tmux包的disable-nls选项不知道在何处被配置上，导致configure的时候不通过。
make menuconfig # 在菜单中选择后才能编译
./scripts/feeds install tmux # ./feeds/packages/utils/tmux 然后创建 ./dl/tmux-2.5.tar.gz指向前一个路径
make package/tmux/download          V=99 # ./dl/tmux-2.5.tar.gz 下载了此文件
make package/tmux/prepare           V=99 # ./build_dir/target-x86_64_glibc-2.22/tmux-2.5 为上文件的解压缩文件
make package/tmux/configure         V=99
make package/tmux/compile           V=99  # ./staging_dir/target-x86_64_glibc-2.22/pkginfo/tmux.default.install.flags
                                         # ./staging_dir/target-x86_64_glibc-2.22/pkginfo/tmux.default.install.clean
# 依赖包toolchain,ocf-crypto-headers,zlib,openssh,libevent2,ncurses 最后编译./build_dir/target-x86_64_glibc-2.22/tmux-2.5
# 在此阶段如何的configure参数
ls bin/ar71xx/packages/packages     V=s
                                   
make package/libs/hello/compile V=99
make package/libs/hello/clean
make package/skysoft_web_admin/{clean,prepare,compile} V=99
make package/pacakge_name/{clean,prepare,compile,install} V=99

make package/system/uci/compile V=s   编译 
make package/system/uci/clean V=s    清理
 
make target/linux/clean          # Clean linux objects. 
make target/linux/{clean,prepare} V=s QUILT=1
cd build_dir/linux-*/linux-3.*  # 对稳定版AA（Attitude Adjustment）来说，内核代码树
cd build_dir/target-*/linux-*/linux-3.*  # 对主干分支，现在是BB（Barrier Breaker），代码树
make target/linux/update package/index V=s # 我们将刚才操作好的patch移动到buildroot中通过下面的命令：

make package/base-files/clean    # Clean package base-files objects. 
make package/luci/clean          # Clean luci. 

    编译过toolchain或者是看toolchain目录的主Makefile可以发现gcc有三个编译阶段：initial, minimal和final，
如果要修改gcc的patch，需要使用minimal那个阶段。
准备工具链代码树:
make toolchain/gcc/minimal/{clean,prepare} V=99 QUILT=1
代码树路径取决于选择的库以及 gcc :
cd build_dir/toolchain-mips_r2_gcc-4.3.3+cs_uClibc-0.9.30.1/gcc-linaro-<version>
通过如下命令更新Patch:
make toolchain/gcc/minimal/update V=99
对于其余的binutils, gdb, glibc之类的由于没有细分阶段，所以直接按照软件包那样的格式套用就行了。比如 
make toolchain/(gdb|glibc|binutils)/{clean,prepare} V=99 QUILT=1
make toolchain/(gdb|glibc|binutils)/update V=99

加入install后会将编译结果打包安装到SDK目录下bin目录下相应位置。
make package/skysoft_web_admin/{clean,prepare,compile,install} V=99

# 指定路径
TOPDIR=$PWD  make -C package/network/services/dropbear compile V=99
TOPDIR=$PWD  make -C package/helloworld compile V=99
TOPDIR=$PWD  make -C package/utils/fuse DUMP=1 V=99
TOPDIR=$PWD  make -C package/network/services/dropbear DUMP=1

make -C package/kernel/linux compile                 V=s
make -C package/kernel/gpio-button-hotplug compile   V=s
make -C package/kernel/mac80211 compile              V=s
make -C package/kernel/mt76 compile                  V=s
}
openwrt(智能路由器-原始目录和生成目录){
---------------------------- 原始目录 ----------------------------------------------
feeds.conf.default # feeds下载的指导文件
rules.mk文件       # 定义了一系列在make时使用的规则
config     #  编译选项配置文件，包含全局编译设置、开发人员编译设置、目标文件格式设置和内核编译设置4部分
docs       #  文档目录
@include   #  包含准备环境脚本、下载补丁脚本、编译Makefile以及编译指令等。这些Makefile会被其它Makefile包含。
@package   #  各种功能的软件包，软件包仅包含Makefile和修改补丁及配置文件。其中Makefile包含源代码真正的地址及
           #  MD5值。OpenWrt社区的修改代码以补丁包形式管理，package只保存一些常用的软件包
@script    #  包含准备环境脚本、下载补丁脚本、编译Makefile以及编译指令等。一些用于Openwrt软件包管理的perl脚本。
@target    #  各个硬件平台在这里面定义了编译固件和内核的步骤、方法。
           #  用来指导如何编译firmware和内核，以及sdk的 -> firmware image; kernel building;
           #  compiles kernel和firmware image utilities。builds	firmware image, generate Image Generator。
   target/linux #目录下按照平台进行目录划分
   target/linux/<platform> #目录里面是各个平台(arch)的相关代码
   target/linux/<platform>/config-3.10 # 文件就是配置文件了
   -> 这部分是Device-Specific的
        target/linux/ramips/base-files
        target/linux/ramips/files
   -> 这部分是制作镜像的相关文件
        target/linux/ramips/image
        target/linux/ramips/mt7621
        tools/firmware-utils/src/mktplinkfw.c
   -> 这部分是内核支持相关的文件
        target/linux/ramips/mt7621/config-3.10 
        target/linux/ramips/patches-3.18/0304-w25q256_32MB_Flash_reset.patch
@toolchain  # 这些Makefile定义了如何获得kernel headers,C library, bin-utils, compiler itself和debugger 
            # 这些源码是用来制作交叉编译工具链的。如果你要添加一个全新的架构，你需要在这里添加一个C library配置。
@tools     # 编译固件需要一些命令，比如mkimage、lzma等，而这些Makefile则定义了如何获得这些命令的源码包，
           # 以及如何编译/安装这些命令。 -> image
tmp        # 操作make menuconfig后产生的临时目录
---------------------------- 编译过程中生成的目录 ---------------------------------------
build_dir                    # 所有软件包都解压到该目录，并在该目录下编译。
build_dir/host               # 临时目录，用来存储不依赖于目标平台的工具{openwrt需要本机支持的定制命令}
build_dir/toolchain-<arch*>  # 用来存储依赖于指定平台的编译工具链
                             # {cross-C compiler 和 C standard library} 被用来构建packages，
                             # {cross-C compiler} 被本机使用， {C standard library} 被嵌入式系统使用
build_dir/target-<arch*>     # 用来储存依赖于指定平台的软件包的编译文件, 其中包括linux内核, u-boot, packages, 只是编译文件存放目录无需修改.
                             # 所有packages和Linux kernel
                             
staging_dir # 最终安装目录，包括运行在主机的工具、交叉编译工具链、嵌入式根文件系统rootfs 
staging_dir/host # 最小的Linux root，只有 /bin 和 /lib 主机工具将被安装到此 PATH
staging_dir/target-<arch*>    # 是编译目标的最终安装位置, 其中包括rootfs, package
staging_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/root-ramips       # 根文件系统
staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/ # 最小的Linux root，只有/bin和/lib等
# 包含{cross C compiler}
# staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-uclibc-gcc

./build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/linux-ramips_mt7621 # 内核文件firewire文件
./build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/linux-ramips_mt7621/linux-3.18.36/.config # 内和配置文件
./build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/linux-ramips_mt7621/* # 内核补丁以及生成二进制文件
./build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/linux-ramips_mt7621/linux-3.18.36/arch/mips/ralink # ralink
./build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2/busybox-1.23.2/.config # busybox
./build_dir/host/u-boot-2014.10/.config                                     # boot
./build_dir/target-x86_64_glibc-2.22/gcc-5.4.0/ipkg-x86_64/gcc/usr/bin      # 可以在嵌入式系统中执行的编译器

./build_dir/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/uClibc-0.9.33.2/.config # uClibc
./build_dir/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/binutils-linaro-2.24.0-2014.09/ # binutils
./build_dir/toolchain-mipsel_1004kc+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/linux-3.18.36/  # 内核，未经过编译

build_dir VS staging_dir
    build_dir: 解压缩压缩包，然后对压缩包进行编译； -> 用户空间的工具在这里被编译。
    staging_dir: 安装所有的编译出来的代码，要么用于生成ipk包，要么用于生成firmware。 -> 交叉编译工具在这里被安装
    
    ~/.bashrc # PATH
        <buildroot dir>/staging_dir/toolchain-<platform>-<gcc_ver>-<libc_ver>/bin # 交叉编译工具链所在路径
        <buildroot dir>/staging_dir/host/bin # 定制化主机命令
    
---------------------------- 编译过程中生成的目录 ---------------------------------------
dl          # 下载软件代码临时命令。编译前，将原始的软甲代码包下载到该目录
dl/libev-4.22.tar.gz                                    #从网站下载的压缩包
feeds       # 扩展软件包目录。将一些不常用的软件包放在其他代码库中，通过feed机制可以自定义下载及配置
feeds/packages/libs/libev                               #处理压缩包的Makefile文件
bin         # 编译完成后的最终成果目录，例如安装镜像文件及ipk安装包
build_dir   # 编译中间文件目录，例如生成.o文件
build_dir/target-x86_64_glibc-2.22/libev-4.22/..        #压缩包解压缩，编译连接的位置
staging_dir # 编译安装目录。文件安装到这里，并由这里的文件生成最终的编译成果
log         # 如果开发了针对开发人员log选项，则将编译log保存在这个目录下，否则该命令并不会创建

---------------------------- 编译脚本-帮助脚本 ---------------------------------------
[编译脚本]
download.pl        # 下载编译软件包源代码
patch-kernel.sh    # 打补丁脚本，并且判断如果打补丁失败将退出编译过程
feeds              # 收集扩展软件包的工具，用于下载和安装编译扩展软件包工具
diffconfig.sh      # 收集和默认配置不同支持的工具
# Configure using config diff file
# 1. Creating diff file
./scripts/diffconfig.sh output       
# 2. Using diff file
cp diffconfig .config # write changes to .config 
make defconfig # expand to full config

cat diffconfig >> .config # append changes to bottom of .config 
make defconfig # apply changes

kconfig.pl         # 处理内核配置
deptest.sh         # 自动OpenWrt的软件包依赖项检查
metadata.pl        # 检查metadata
rstrp.sh           # 丢弃目标文件中的符号，这样就将执行文件和动态库变小
timestamp.pl       # 生成文件的时间戳
ipkg-make-index.sh # 生成软件包的ipkg索引，在使用opkg安装软件时使用
ext-toolchain.sh   # 工具链
strip-kmod.sh      # 删除内核模块的符号信息，使文件变小

./download.pl <target dir> <filename> <md5sum> [<mirror> ... ]
target dir； 为下载之后的保存位置，下载代码通常保存在dl目录下。
filename： 待下载的文件名
md5sum：   下载内容的MD5，用于校验下载文件是否正确
mirror：   可选的参数，是下载文件的镜像地址，可以有多个地址，优先第一个。

localmirrors:
http://192.168.1.106:8080/openwrt/
http://mirror.bjtu.edu.cn/gnu/

./patch-kernel.sh iproute2-3.3.0 ../package/iproute2/patches/
第一个参数为编译代码目录
第二个为补丁目录

[编译扩展机制feeds]
feeds是openwrt开发所需要的软件包套件的工具及更新地址集合，这些软件包通过一个统一的接口地址进行访问。
这样用户可以不用关心扩展包的存储位置，可以减少扩展软件包和核心代码部分的耦合。
1. 扩展包位置配置文件 feeds.conf.default
2. 脚本工具feeds
src-git luci https://github.com/openwrt/luci.git                      # Web浏览器图形用户接口
src-git routing https://github.com/openwrt-routing/packages.git       # 基础路由器特性软件，包括动态路由和Quagga等
src-git telephony https://github.com/openwrt/telephony.git            # 电话相关的软件包
src-git management https://github.com/openwrt-management/packages.git # TR069各种管理软件包

./scripts/feeds update -a
./scripts/feeds install -a
update     # 下载在feeds.conf或feeds.conf.default文件中的软件包列表并创建索引。
           # -a表示更新所有的软件包。只有更新后才能进行后面的操作
list       # 从创建的索引文件"feed.index"中读取列表并显示。只有进行更新之后才能查看列表
install    # 安装软件包以及他所以来的软件包，从feeds目录安装到package目录，即在"package/feeds"目录
           # 创建软件包的软连接，只有安装之后，在后面执行"make menuconfig"时，才可以对相关软件包是否编译进行选择
           # ./feeds install luci-app-firewall
search     # 按照给定的字符串来查找软件包，需要传入一个字符串参数
uninstall  # 卸载软件包，但它没有处理依赖关系，仅仅删除本软件包的软连接。
clean      # 删除update命令下载和生成的索引文件，但不会删除install创建的链接。
package/feeds/$feed_name/$package_name # 软链接到
package/$feed_name/$package_name       # 
}
openwrt(智能路由器-opkg){
opkg update
opkg install luci
/etc/init.d/uhttpd enable
/etc/init.d/uhttpd start
/etc/init.d/firewall stop
}

diffconfig(){
1. Creating diff file
    ./scripts/diffconfig.sh > diffconfig # write the changes to diffconfig
2. Using diff file
    cp diffconfig .config # write changes to .config
    make defconfig # expand to full config
3. Append
    cat diffconfig >> .config # append changes to bottom of .config 
    make defconfig # apply changes
}
base(Openwrt启动流程：procd){
    首先u-boot从Flash中读取Linux内核到内存，然后跳转到内存执行Linux内核。Linux内核进行一系列验证，注册相关
驱动，根据分区表（target/linux/ramips/dts/MPRA2.dts）创建分区。然后挂载根文件系统。然后启动第一个用户空间进
程。原生的Linux内核默认启动的第一个用户空间进程是/sbin/init,Openwrt将其修改为/etc/preinit。
参考内核代码linux-3.10.49/init/main.c
# 另见 openwrt_boot.sh

/etc/preinit就是一个shell脚本，其第一行内容如下： 
[ -z "$PREINIT" ] && exec /sbin/init 
    一开始$PREINIT为空，因此首先通过exec创建进程/sbin/init替换当前进程（/etc/preinit），
/sbin/init来自于Openwrt软件包package/system/procd中的init.c，
proc/init.c
proc/preinit.c
-> [init]
    /sbin/init程序主要做了一些初始化工作，如环境变量设置、文件系统挂载、内核模块加载等，之后会创建两个进程，
    分别执行/etc/preinit和/sbin/procd，执行/etc/preinit之前会设置变量PREINIT，/sbin/procd会带-h的参数，
    当procd退出后会调用exec执行/sbin/proc替换当前init进程（具体过程可参见procd程序包中的init和procd程序）。
    这就是系统启动完成后，ps命令显示的进程号为1的进程名最终为/sbin/procd的由来，中间是有几次变化的。

//创建子进程/etc/preinit,当子进程退出时调用函数spawn_procd， 
//该函数通过execvp执行/sbin/procd替换自己 
proc/proc.c
# spawn_procd则execp("procd")
# procd再去执行/etc/init.d/*文件。启动各个服务。

-------------------------------------------------------------------------------
[preinit]
/etc/preinit将/lib/preinit/目录下的这些列脚本分为如下5类。
preinit_essential 
preinit_main 
failsafe 
首先通过如下代码执行/lib/preinit目录下的所有脚本 
for pi_source_file in /lib/preinit/*; do 
  . $pi_source_file 
done 
上面实现的仅仅是注册每个脚本里面定义的一些函数或者环境变量。 
目前/lib/preinit/下的所有脚本只实现了preinit_main和failsafe这两类，如下所示：
preinit_main：  define_default_set_state（/lib/preinit/02_default_set_state） # 设置灯状态
                do_ramips（/lib/preinit/03_preinit_do_ramips.sh） # 获取板子名称和model
                do_checksumming_disable（04_handle_checksumming） # 对特定的板子进行分区有效性检测
                ramips_set_preinit_iface（/lib/preinit/07_set_preinit_iface_ramips）  # 设置pf_ifname为eth0或者eth0.1
                preinit_ip（/lib/preinit/10_indicate_preinit） # 配置IP地址，组播地址等
                pi_indicate_preinit（/lib/preinit/10_indicate_preinit） # 设置灯状态
                indicate_failsafe（/lib/preinit/10_indicate_failsafe）  # 设置灯状态
                failsafe_wait（/lib/preinit/30_failsafe_wait）         # FAILSAFE设置位置，failsafe_wait
 # FAILSAFE可以来源于/proc/cmdline中failsafe=参数，也可以来源于fs_wait_for_key函数判断。
 # fs_failsafe_wait_timeout 超时时间在 /etc/preinit脚本中声明，
 # 输入：f        true>/tmp/.keypress_true
 # 输入：1,2,3,4  >/tmp/debug_level
 # 在有按键输入情况下进入failsafe模式。
                run_failsafe_hook（/lib/preinit/40_run_failsafe_hook） # failsafe 入口点，进入条件为FAILSAFE环境变量为TRUE
                indicate_regular_preinit（/lib/preinit/50_indicate_regular_preinit） 
                initramfs_test（/lib/preinit/70_initramfs_test） # INITRAMFS设置位置，当前没有
                do_mount_root（/lib/preinit/80_mount_root）      # 如果sysupgrade.tgz存在，则将配置是放到/tmp下
                run_init（/lib/preinit/99_10_run_init） 
                -> 40_run_failsafe_hook       boot_run_hook failsafe
failsafe：      indicate_failsafe（/lib/preinit/10_indicate_failsafe） # 设置状态
                failsafe_netlogin（/lib/pre
                -> 80_mount_root      boot_init/99_10_failsafe_login） # 执行telnetd -l /bin/login.sh 此刻可以telnet登录
                failsafe_shell（/lib/preinit/99_10_failsafe_login）    # ash --login
                -> 70_initramfs_test         boot_run_hook initramfs
initramfsrun_hook preinit_mount_root # 直接运行，直接运行sysupgrade.tgz
preinit_mount_root
      
在/etc/preinit 中调用boot_run_hook preinit_essential 和boot_run_hook preinit_main 分别执行preinit_essential 和
preinit_main这两类函数。 
    1. define_default_set_state（/lib/preinit/02_default_set_state） 
加载/etc/diag.sh中的两个状态操作函数：get_status_led和set_state 
# 引入了/lib/function/leds.sh 和 /lib/ramips.sh
# get_status_led - swtich(zte-q7) zte；red:status
# set_state 1. preinit 2. failsafe 3. upgrade|preinit_reqular 4. done
    2. do_ramips do_ramips（/lib/preinit/03_preinit_do_ramips.sh） 
调用/lib/ramips.sh中的  ramips_board_detect函数探测板子名称，将其保存在 
/tmp/sysinfo/board_name和/tmp/sysinfo/model这2个文件中，我们可以通过cat查看 
    root@OpenWrt:/lib/preinit# cat /tmp/sysinfo/board_name  #  自定义名称
    mpr-a2 
    root@OpenWrt:/lib/preinit# cat /tmp/sysinfo/model       #  /pruc/cpuinfo 内machine字段对应名称
    HAME MPR-A2 
# 引入了/lib/ramips.sh
# ramips_board_detect
# grep machine /proc/cpuinfo -> Oolite-v8 32M
    3. ramips_set_preinit_iface（/lib/preinit/07_set_preinit_iface_ramips） 
初始化网络接口，设置switch。针对RT5350的设置，为了避免进入Failsafe模式TCP连接超时。
# swconfig dev rt305x set enable_vlan 1
# swconfig dev rt305x vlan 1 set ports "0 6"
# swconfig dev rt305x port 6 set untag 0
# swconfig dev rt305x set apply 1
# vconfig add eth0 1
# ifconfig eth0 up
# ifname=eth0.1
    4. preinit_ip（/lib/preinit/10_indicate_preinit） 
预初始化IP 地址 
# ip -4 address add $pi_ip/$pi_netmask broadcast $pi_broadcast dev $pi_ifname
    5. pi_indicate_preinit（/lib/preinit/10_indicate_preinit） 
设置LED，指示进入preinit过程 
# set_state preinit ; set_state为diag.sh文件内函数
    6. failsafe_wait（/lib/preinit/30_failsafe_wait） 
根据内核参数/proc/cmdline 或者用户是否按下相应按键，决定是否进入failsafe 模式（故障恢复模
式）。如果内核参数含有FAILSAFE=true，则表示直接进入failsafe 模式，否则调用fs_wait_for_key 等
待用户终端按键（默认为’F’+Enter），等待时间为fs_failsafe_wait_timeout（在/etc/preinit中设置，默
认为2s），如果在等待时间内用户按下指定的按键，则表示要进入failsafe 模式。接着再检测文件
/tmp/failsafe_button是否存在，如果存在则表示要进入failsafe 模式（该文件可通过设备上的实体按
键来创建）。如果要进入failsafe 模式，则设置全局变量FAILSAFE=true 
# /tmp/.keypress_wait & /tmp/.keypress_true & /tmp/.keypress_sec 三个临时文件
# 加装两个信号处理函数 trap "echo 'true' >$keypress_true; lock -u $keypress_wait ; rm -f $keypress_wait" INT
# 加装两个信号处理函数 trap "echo 'true' >$keypress_true; lock -u $keypress_wait ; rm -f $keypress_wait" USR1
# 输出 Press the [f] key and hit [enter] to enter failsafe mode
# "Press the [1], [2], [3] or [4] key and hit [enter] to select the debug level" & /tmp/debug_level 
# 
    7. run_failsafe_hook（/lib/preinit/40_run_failsafe_hook） 
如果全局变量FAILSAFE=true，则执行failsafe 这类函数。 
# boot_run_hook failsafe
    8. indicate_regular_preinit（/lib/preinit/50_indicate_regular_preinit） 
设置LED，指示进入正常模式 
#  见 10_indicate_preinit
    9. do_mount_root（/lib/preinit/80_mount_root） 
执行/sbin/mount_root挂载根文件系统，该命令来自于Openwrt软件包package/system/fstools。 
# [ -f /sysupgrade.tgz ] && cd /; tar xzf /sysupgrade.tgz }
    10. indicate_failsafe（/lib/preinit/10_indicate_failsafe） 
设置LED,指示进入failsafe模式 
# indicate_failsafe_led
    11. failsafe_netlogin（/lib/preinit/99_10_failsafe_login） 
启动Telnet服务器（telnetd） 
# telnetd -l /bin/login.sh <> /dev/null 2>&1 # 先执行
    12. failsafe_shell（/lib/preinit/99_10_failsafe_login） 
启动shell                                    #　后执行
# ash --login
}

base(Failsafe Mode){
sudo telnet 192.168.1.1
mount_root ## this remounts your partitions from read-only to read/write mode
firstboot  ## This will reset your router after reboot
reboot -f  ## And force reboot

-- 直接进入 failsafe 模式 f+Enter
special commands:
* firstboot          reset settings to factory defaults
* mount_root     mount root-partition with config files

after mount_root:
* passwd                         change root password
* /etc/config               directory with config files
}

base(Openwrt启动流程：/etc/rc.d/S* ){
在procd执行/etc/rc.d/S*时，其参数为"boot"（例如：/etc/rc.d/S00sysfixtime boot），这样就会执行
每个脚本里面的boot函数，也肯能是间接执行start函数。/etc/rc.d/下的所有脚本都是链接到/etc/init.d/下的脚本。下面
分析几个重要的脚本。

1. S10boot 
调用uci_apply_defaults执行第1次开机时的UCI配置初始化工作。该函数执行/etc/uci-defaults/下的
所有脚本，执行成功后就删除。因此该目录下的脚本只有第一次开机才会执行。 
如果不存在/proc/mounts，则执行/sbin/mount_root 
# 
[ -f /proc/mounts ] || /sbin/mount_root
[ -f /proc/jffs2_bbc ] && echo "S" > /proc/jffs2_bbc
[ -f /proc/net/vlan/config ] && vconfig set_name_type DEV_PLUS_VID_NO_PAD
mkdir -p /var/run   mkdir -p /var/log   mkdir -p /var/lock
mkdir -p /var/state mkdir -p /tmp/.uci  chmod 0700 /tmp/.uci
mkdir -p /tmp/.jail
touch /var/log/wtmp touch /var/log/lastlog  touch /tmp/resolv.conf.auto
ln -sf /tmp/resolv.conf.auto /tmp/resolv.conf
---------------------------------------
2. S10system 
根据UCI配置文件/etc/config/system配置系统，具体可参考该配置文件。 
date -k # apply timezone to kernel
3. S11sysctl 
根据/etc/sysctl.conf设置系统配置（[ -f /etc/sysctl.conf ] && sysctl -p -e >&-）。 
sysctl -p -e 
4. S19firewall 
启动防火墙fw3。该工具来自Openwrt软件包package/network/config/firewall 
fw3 -q start
5. S20network 
根据UCI配置文件/etc/config/network，使用守护进程/sbin/netifd来配置网络。 
echo '/tmp/%e.%p.%s.%t.core' > /proc/sys/kernel/core_pattern

6. S95done 
如果存在目录/tmp/root，则执行mount_root done 
如果存在/etc/rc.local，则执行sh /etc/rc.local。

1. rm -f /sysupgrade.tgz
2. sh /etc/rc.local
3. . /etc/diag.sh && set_state done
}

base(profile){
/lib/preinit/30_failsafe_wait
    /proc/cmdline # failsafe=                   启动参数进入，由boot引入
                  # read -t $timer do_keypress  手动进入
/etc/init.d/boot
    [ "$FAILSAFE" = "true" ] && touch /tmp/.failsafe

/etc/profile
[ -f /etc/banner ] && cat /etc/banner               # 登录显示信息
[ -e /tmp/.failsafe ] && cat /etc/banner.failsafe   # failsafe登录显示信息

}

uci_defaults(uci-defaults.sh){ 
leds.sh  network.sh  preinit.sh  procd.sh  service.sh  system.sh  uci-defaults-new.sh  uci-defaults.sh
其中uci-defaults.sh会生成默认的/etc/config下的文件，而其它文件是它的"库"。

/etc/uci-default 设定了板载Board网络、系统等配置信息，在/etc/init.d/boot中初始化，初始化成功以后即被删除。
}

base(Failsafe模式：故障恢复模式){ mount_root, passwd root, firstboot | rm /overlay/*
    当系统出现故障时，比如忘记密码，忘记IP 等，就可以通过进入Failsafe模式来修复系统。在failsafe 模式下，系统会
启动Telnet服务器，我们可以无需密码通过Telnet登录到路由器。在failsafe 模式下，系统一般会关闭VLAN，给eth0
设置默认IP 为192.168.1.1（在/etc/preinit中默认设置）。RT5350例外，该SOC有一个bug，需要打开VLAN才能使用
TCP协议。
# Press the [f] key and hit [enter] to enter failsafe mode 
# Press the [1], [2], [3] or [4] key and hit [enter] to select the debug level 
提示我们按下F键和Enter键进入failsafe 模式。
针对RT5350，系统启动时，首先打开VLAN，并设置VLAN 1的端口为0，如下所示： 
# /etc/preinit/07_set_preinit_iface_ramips 

注意:target/linux/ramips/base-files/lib/preinit/07_set_preinit_iface_ramips 
然后重新编译固件，更新固件，重启系统，在日志中出现"Press the [f] key and hit [enter] to enter failsafe mode"这样的提
示时，按下F和Enter键，就进入failsafe 模式了。
1. 现在需要将我们的电脑的IP设置为192.168.1.2，然后使用Telnet工具登录到我们的路由器。
2. 在进入failsafe 后，系统只挂载了只读的SquashFS分区，我们可以通过命令mount_root来挂载jffs2分区
   mount_root
3. 在failsafe 模式，我们可以修改密码。
   passwd root
4. 如果忘记IP，可以在这里查看IP
5. 可以执行firstboot 命令或者删除/overlay/*来恢复出厂设置。  

---------------------------------------
1. 手动进入Failsafe模式
    系统在启动过程中看到有Failsafe的提示时，按f键并回车就能进入Failsafe模式，出现Failsafe提示的时候，
系统状态灯会开始慢闪
2. 自动进入Failsafe模式
通过在启动参数中添加"failsafe="可以让系统启动后自动进入Failsafe模式
2.1 操作步骤
进入U-Boot，修改启动参数bootargs，在最后追加"failsafe=1"(注：其实追加"failsafe=0"或者
"failsafe="也都会自动进入Failsafe模式，脚本只检查关键字"failsafe=")，如下：

ath> set bootargs "$bootargs failsafe=1"
ath> save
或者
ath> set bootargs "$bootargs failsafe=0"
ath> save
或者
ath> set bootargs "$bootargs failsafe="
ath> save
重新启动系统自动进入Failsafe模式;
3. 进入Failsafe可以进行的操作
# firstboot          reset settings to factory defaults
# mount_root     mount root-partition with config files
after mount_root:
# passwd                         change root password
# /etc/config               directory with config files

4. Failsafe模式下的系统
在Failsafe模式下，启动脚本和配置均未加载，网络被设置为192.18.1.1，
在Failsafe模式下，状态灯不停的闪烁，表示当前系统处于非正常状态。

5. Failsafe模式下升级固件
如果想在Failsafe模式下升级，可以参考
[Flash new firmware in failsafe mode]
(https://wiki.openwrt.org/doc/howto/generic.failsafe#flash_new_firmware_in_failsafe_mode)

6. Failsafe源码分析
Failsafe相关的源文件如下：
huzhifeng@Ubuntu1404:~/git/openwrt_trunk$ find package/base-files/ -name "*failsafe*"
package/base-files/files/etc/rc.button/failsafe
package/base-files/files/etc/banner.failsafe
package/base-files/files/lib/preinit/10_indicate_failsafe
package/base-files/files/lib/preinit/40_run_failsafe_hook
package/base-files/files/lib/preinit/99_10_failsafe_login
package/base-files/files/lib/preinit/30_failsafe_wait
huzhifeng@Ubuntu1404:~/git/openwrt_trunk$

huzhifeng@Ubuntu1404:~/git/openwrt_trunk$ make menuconfig
	[*] Image configuration  --->
		[*]   Preinit configuration options  --->
			(2)   Failsafe wait timeout (NEW)
}

openwrt(基本静态配置){
package/base-files/files/etc/
make menuconfig
/Base System/base-files # 选项
}
base(openwrt启动服务){

# #!/bin/sh /etc/rc.common 
#  
# START=10 
# STOP=15 
#  
# start() { 
#   echo 'start example' 
# } 
#  
# stop() { 
#   echo 'stop example' 
# } 

脚本中的START= 和  STOP= 分别决定了该脚本会在系统启动过程和系统关机过程的哪个点执行，数字越小越先执行。
当我们以enable参数调用启动脚本时，系统会创建一个该脚本文件的符号链接（例如S10example、K15example），放在
/etc/rc.d/目录下，而当以disable参数调用脚本时，系统会删除该符号链接。 
    START=10：意味着该脚本文件会被/etc/rc.d/S10example链接。也就是说，该脚本会在START=10及之
下这样的脚本后面执行，而在START=11及之上这样的脚本前面执行。 
    STOP=15：意味着该脚本文件会被/etc/rc.d/K15example链接。也就是说，该脚本会在STOP=14及之
下这样的脚本后面执行，而在STOP=16及之上这样的脚本前面执行。

注意：这里的START和STOP的值只能是2位数，比如00、01、20、99，否则会出问题。具体参考/etc/rc.common中的
enable和disable函数，这两个函数在操作时只匹配了两位数。

[添加自己的命令]
# #!/bin/sh /etc/rc.common 
#  
# EXTRA_COMMANDS="custom" 
# EXTRA_HELP="custom  Help for the custom command" 
# custom() { 
#   echo 'custom command' 
# }

[通过安装实现自启动] Makefile
# define Package/$(PKG_NAME)/postinst 
#   #!/bin/sh 
#   # check if we are on real system 
#   if [ -z "$${IPKG_INSTROOT}" ]; then 
#     echo "Enabling rc.d symlink for helloworld" 
#     if [ -e /etc/rc.d/S??helloworld ];then 
#       rm /etc/rc.d/S??helloworld 
#     fi 
#     if [ -e /etc/rc.d/K??helloworld ];then 
#       rm /etc/rc.d/K??helloworld 
#     fi 
#     /etc/init.d/helloworld enable 
#   fi 
#   exit 0 
# endef 
#  
# define Package/$(PKG_NAME)/prerm 
#   #!/bin/sh 
#   # check if we are on real system 
#   if [ -z "$${IPKG_INSTROOT}" ]; then 
#     echo "Removing rc.d symlink for helloworld" 
#     /etc/init.d/helloworld disable 
#   fi 
#   exit 0 
# endef

[安装过程] Makefile
# define Package/$(PKG_NAME)/install 
#   $(INSTALL_DIR) $(1)/bin $(1)/etc/init.d/ 
#   $(INSTALL_BIN) $(PKG_BUILD_DIR)/helloworld $(1)/bin/ 
#   $(INSTALL_BIN) ./files/helloworld $(1)/etc/init.d/ 
# endef 
}

base(init script){
procd是Openwrt提供的一个进程管理工具。 
# #!/bin/sh /etc/rc.common 
#  
# START=50 
# USE_PROCD=1 
#  
# PROG=/bin/helloworld 
#  
# start_service() { 
#   procd_open_instance 
#   procd_set_param command $PROG 
#   procd_set_param respawn 
#   procd_close_instance 
# } 
这是一个最简单的procd形式的启动脚本。USE_PROCD=1指明使用procd。 
procd_set_param command $PROG 设置命令行参数 
procd_set_param respawn 设定自动重生（比如程序挂掉，自动启动），后面可以跟3个参数：重生闸值(在多少秒内程
序挂掉被认作是一次重生)、重生超时时间(当程序挂掉多少秒后重生程序)、最大重生次数
}

base(通过shell脚本操作UCI配置){

Openwrt提供了一些shell脚本函数，这些函数使得操作UCI配置文件变得非常的高效。要使用这些shell函数，首先需
要加载/lib/functions.sh，然后实现config_cb(), option_cb(), 和  list_cb()这些shell函数，当我们调用Openwrt提供的shell
函数config_load来解析配置文件时，程序就会回调我们自己定义的config_cb(), option_cb(), 和  list_cb()这些shell函数。

# #!/bin/sh 
# . /lib/functions.sh 
#  
# reset_cb 
#  
# config_cb() { 
#   local type="$1" 
#   local name="$2" 
#   # commands to be run for every section 
#   if [ -n "$type" ];then 
#       echo "$name=$type" 
#   fi 
# } 
#  
# option_cb() { 
#   local name="$1" 
#   local value="$2" 
#   # commands to be run for every option 
#   echo $name=$value 
# } 
#  
# list_cb() { 
#   local name="$1" 
#   local value="$2" 
#   # commands to be run for every list item 
#   echo $name=$value 
# } 
# config_load $1 

./test.sh dhcp
reset_cb 表示将xxx_cb这3个函数初始化为没有任何操作。config_load首先从绝对路径文件名加载配置，如果失败再
从/etc/config路径加载配置文件。xxx_cb那3个函数必须在包含/lib/functions.sh和调用config_load之间定义。

可以看到，当config_load解析配置文件时，解析到section时，就会回调config_cb，解析option时，就会回调option_cb，
解析list 时，就会回调list_cb
-------------------------------------------------------------------------------
# #!/bin/sh 
# . /lib/functions.sh 
#  
# reset_cb 
#  
# handle_interface() { 
#   local config="$1" 
#   local custom="$2" 
#   # run commands for every interface section 
#   if [ "$config" = "$custom" ];then 
#       echo $custom 
#   fi 
# } 
#  
# config_load $1 
# config_foreach handle_interface interface $2

./test.sh network wan
 
这里以参数network和wan调用test.sh，然后程序首先调用config_load加载配置文件network，然后config_foreach在
配置文件network中搜寻类型为interface 的section，一旦找到就以当前section的ID 和wan作为参数调用 
handle_interface，在handle_interface函数中，得到config=wan，custom=wan，最终打印出wan。

使用config_get读取配置选项的值，该函数需要至少3个参数： 
1. 一个存储返回值的变量 
2. 要读取的section的ID（如果是有名称的section就是其名称） 
3. 要读取的option的名称
config_set用来设置配置选项的值，它需要3个参数： 
1. section的ID（如果有名称就是其名称） 
2. option的名称 
3. 要设置的值 
# http://wiki.openwrt.org/doc/devel/config-scripting 

}

base(luci){
    在我们使用浏览器向路由器发起请求时，LuCI会从controller 目录下的index.lua 开始组织这些节点。
index.lua 中定义了根节点root，其他所有的节点都挂在这个根节点上。
    我们可以将controller目录下的这些.lua 文件叫做模块，这样的模块文件的第一行必须是如下格式：
    module("luci.controller.xx.xx.xx", package.seeall) 

上面的luci.controller.xx.xx.xx 表示该文件的路径，luci. controller表示/usr/lib/lua/luci/controller/，比如上面的index.lua 其
第一行为：module("luci.controller.admin.index", package.seeall)，表示其路径为：/usr/lib/lua/luci/controller/admin/index.lua

接着是定义一个index 方法，其主要工作是调用entry方法创建节点，可以多次调用创建多个节点。其调用方式如下： 
entry (path, target, title, order) 
1. path指定该节点的位置（例如node1.node2.node3） 
2. target指定当该节点被调度（即用户点击）时的行为，主要有三种：call、template 和cbi，后面有3个实例。 
3. title：标题，即我们在网页中看到的菜单 
4. order：同一级节点之间的顺序，越小越靠前，反之越靠后（可选）
---------------------------------------
LuCI默认开启了缓存机制，这样当我们修改了代码后，不会立即生效，除非删除缓存，操作如下： 
root@OpenWrt:/# rm /tmp/luci-* - 
为了便于调试，我们可以直接关闭缓存，修改配置文件/etc/config/luci，操作如下： 
root@OpenWrt:/# uci set luci.ccache.enable=0 
root@OpenWrt:/# uci commit 
--------------------------------------- call
--第一行声明模块路径 
module("luci.controller.example", package.seeall) 
function index()
--[[ 
    创建一级菜单example，firstchild()表示链接到其第一个子节点，即 
    当我们单击菜单Example时，LuCI将调度其第一个子节点。"Example"即 
    在网页中显示的菜单。60表示其顺序，LuCI自带的模块的顺序为： 
    Administration(10),Status(20),System(30),Network(50),Logout(90)。 
    call("first_action")表示当子节点被调度时将执行下面定义的方法first_action() 
  --]] 
  entry({"admin", "example"}, firstchild(), "Example", 60) 
  entry({"admin", "example", "first"}, call("first_action"), "First")
end
--------------------------------------- template
--第一行声明模块路径 
module("luci.controller.example", package.seeall) 
 
function index() 
  --[[ 
    创建一级菜单example，firstchild()表示链接到其第一个子节点，即 
    当我们单击菜单Example时，LuCI将调度其第一个子节点。"Example"即 
    在网页中显示的菜单。60表示其顺序，LuCI自带的模块的顺序为： 
    Administration(10),Status(20),System(30),Network(50),Logout(90) 
    template ("example/example")表示当子节点被调度时LuCI将使用我们指定的 
    html页面/usr/lib/lua/luci/view/example/example.htm来生成页面 
  --]] 
  entry({"admin", "example"}, firstchild(), "Example", 60) 
  entry({"admin", "example", "first"}, template("example/example"), "First") 
end
--------------------------------------- cbi
--第一行声明模块路径 
module("luci.controller.example", package.seeall) 
 
function index() 
  --[[ 
    创建一级菜单example，firstchild()表示链接到其第一个子节点，即 
    当我们单击菜单Example时，LuCI将调度其第一个子节点。"Example"即 
    在网页中显示的菜单。60表示其顺序，LuCI自带的模块的顺序为：
    Administration(10),Status(20),System(30),Network(50),Logout(90) 
    call("first_action")表示当子节点被调度时将执行下面定义的方法first_action() 
  --]] 
  entry({"admin", "example"}, firstchild(), "Example", 60) 
  entry({"admin", "example", "first"}, template("example/example"), "First", 1) 
   
  --[[ 
    如果配置文件/etc/config/example存在，则创建Example的子节点Second。 
    cbi("example/example")表示当节点Second被调度时，LuCI会将 
    /usr/lib/lua/luci/model/cbi/example/example.lua这个脚本转换成html页面 
    发给客户端。 
  --]] 
  if nixio.fs.access("/etc/config/example") then 
    entry({"admin", "example", "second"}, cbi("example/example"), "Second", 2) 
  end 
end

新建lua 脚本文件：/usr/lib/lua/luci/model/cbi/example/example.lua，内容如下： 
--[[ 
  有关Map相关的用法参考LuCI官方文档：http://luci.subsignal.org/trac/wiki/Documentation/CBI 
  Map (config, title, description) 
--]] 
m = Map("example", "Example for cbi", "This is very simple example for cbi") 
return m

没有出现Second这个节点，是因为还没创建配置文件/etc/config/example，下面使用touch命令创建这个文件： 
root@OpenWrt:/# touch /etc/config/example

---------------------------------------
一般情况下，一个配置文件与一个启动脚本对应，比如/etc/config/network和/etc/init.d/network，当我们在页面上单击
Save & Apply时，LuCI首先保存配置文件，然后就以reload 为参数调用配置文件对应的启动脚本。

另外，LuCI通过以配置文件名作为参数调用/sbin/luci-reload来使配置生效，而luci-reload会解析另一个配置文件 
/etc/config/ucitrack，我们需要将我们的example添加进去。用vi打开/etc/config/ucitrack，在最后添加如下内容：
config example                       
        option init example 
当我们单击网页中的  Save & Apply后，LuCI将会调用/sbin/luci-reload example，最终调用到/etc/rc.d/example中的reload
函数，因此还需要执行如下操作： 
root@OpenWrt:/# /etc/init.d/example enable 
 
现在单击网页中的  Save & Apply，可以看到开发板中输出了如下内容： 
reload example 
说明确实执行了/etc/init.d/example中的reload函数。

}

base(国际化){
--第一行声明模块路径 
module("luci.controller.example", package.seeall) 
 
require "luci.fs" 
 
function index() 
  --[[ 
    创建一级菜单example，firstchild()表示链接到其第一个子节点，即 
    当我们单击菜单Example时，LuCI将调度其第一个子节点。"Example"即 
    在网页中显示的菜单。60表示其顺序，LuCI自带的模块的顺序为： 
    Administration(10),Status(20),System(30),Network(50),Logout(90) 
    call("first_action")表示当子节点被调度时将执行下面定义的方法first_action() 
  --]] 
  entry({"admin", "example"}, firstchild(), _("Example"), 60) 
  entry({"admin", "example", "first"}, template("example/example"), _("First"), 1) 
   
  --[[ 
    如果配置文件/etc/config/example存在，则创建Example的子节点Second。 
    cbi("example/example")表示当节点Second被调度时，LuCI会将 
    /usr/lib/lua/luci/model/cbi/example/example.lua这个脚本转换成html页面 
    发给客户端。 
  --]] 
  if nixio.fs.access("/etc/config/example") then 
    entry({"admin", "example", "second"}, cbi("example/example"), _("Second"), 2) 
  end 
end

对于/usr/lib/lua/luci/model/cbi/下的lua 脚本，则使用translate()来翻译，修改 
/usr/lib/lua/luci/model/cbi/example/example.lua，修改后分内容如下：

--[[ 
  有关Map相关的用法参考LuCI官方文档：http://luci.subsignal.org/trac/wiki/Documentation/CBI 
  Map (config, title, description) 
--]]

m = Map("example", translate("Example for cbi"),   
  translate("This is very simple example for cbi")) 
 
--描述一个类型为example的section 
s = m:section(TypedSection, "example", translate("Example"), translate("The section of type is example")) 
 
--允许用户添加和删除这个section 
s.addremove = true 
 
--显示section的名称 
s.anonymous = false 
 
--该section的num选项 
e = s:option(Value, "num", translate("Number")) 
 
--当用户输入一个空值时，从配置文件中移除该选项 
e.rmempty = true 
 
return m
-------------------------------------------------------------------------------

在虚拟机Ubuntu中创建一个文件example.po，其内容如下：
msgid "Example" 
msgstr "例子" 
 
msgid "First" 
msgstr "第一" 
 
msgid "Second" 
msgstr "第二" 
 
msgid "Example for cbi" 
msgstr "有关cbi的例子" 
 
msgid "This is very simple example for cbi" 
msgstr "这是有关cbi的一个非常简单的例子" 
 
msgid "The section of type is example" 
msgstr "类型为example的section" 
 
msgid "Number" 
msgstr "数字" 
使用Luci提供的工具po2lmo将这个example.po转换成.lmo 格式，该工具所在路径为：feeds/luci/build/po2lmo,操作如
下所示： 
root@zjh-vm:/home/work/openwrt/barrier_breaker# ./feeds/luci/build/po2lmo example.po example.zh-cn.lmo 
 
将生成的example.zh-cn.lmo拷贝到开发板的/usr/lib/lua/luci/i18n/目录，现在刷新页面，效果如下：
}

base(主题){
与主题相关的代码存放在/usr/lib/lua/luci/view/themes/目录以及/www/luci-static/目录，一个主题占一个目录，比如 
bootstrap这个主题有/usr/lib/lua/luci/view/themes/bootstrap/和/www/luci-static/bootstrap/这两个目录。

/usr/lib/lua/luci/view/themes/bootstrap/目录下有两个html文件，分别是header.htm和footer.htm，分别用来控制网页
的顶部和底部的显示方式。

/www/luci-static/bootstrap/下包含一些css文件和js 文件，用来控制整体界面以及各个控件的显示样式。 
添加主题，需要对html、js、css这些知识非常熟悉。这些一般由专门的工程师做。

}
https://github.com/openwrt/luci/wiki/JsonRpcHowTo # JsonRpcHowTo
https://github.com/openwrt/luci/wiki/Templates # Templates

https://htmlpreview.github.io/?https://github.com/openwrt/luci/blob/master/documentation/api/index.html                    # luci
https://htmlpreview.github.io/?https://raw.githubusercontent.com/openwrt/luci/master/documentation/api/modules/nixio.html  # nixio
base(CBI参考手册){
http://luci.subsignal.org/trac/wiki/Documentation/CBI

https://github.com/openwrt/luci/wiki/CBI

Map
---------------------------------------
Map (config, title, description) 
映射一个配置文件，返回一个Map对象。其中description可以省略。 
m = Map("example", "Example for cbi", "This is very simple example for cbi") 

section
---------------------------------------
s = m:section(TypedSection, type, title, description)      根据section类型解析section 
s = m:section(NamedSection, name, type, title, description)  根据section类型和名称解析section 
其中m为Map返回的对象，s为Map类的成员函数section返回的section对象 
 
section对象有一些属性如下： 
template：html模板，默认为"cbi/tsection" 
addremove：是否可以增加和删除，默认为false 
anonymous：是否为匿名section，默认为false 

option
---------------------------------------
o = s:option(type, name, title, description) 
调用section对象的成员函数option，返回一个option对象。其中type有多个取值：Value、DynamicList、Flag、ListValue。 
option对象的一些属性如下： 
1. rmempty：如果为空值则删除该选项，默认为true 
2. default：默认值，如果为空值，则设置为该默认值 
3. datatype：限制输入类型。例如"and(uinteger,min(1))"限制输入无符号整形而且大于0，"ip4addr"限制
    输入IPv4 地址，"port"限制输入类型为端口，更多参考/usr/lib/lua/luci/cbi/datatypes.lua 
4. placeholder：占位符（html5才支持）

Tab
---------------------------------------
s:tab(tabname, title) 
调用section的tab 函数创建一个名称为tabname，标题为title的Tab标签
对应的option则使用taboption 
s:taboption(tabname, type, name, title) 
在指定的tabname下创建一个option。 
}


base(UCI处理脚本库 /lib/function.sh){ 文本编辑器|uci命令|shell|lua 来管理/etc/config下的文件
/lib/config/uci.sh
/lib/functions.sh
---------------------------------------
reset_cb： # 将config_cb，option_cb，list_cb函数设置成空函数；
config_load -> uci_load -> uci -S -n dhcp -> eval $data 则进行config option list的回调。
config  # config 调用config_cb  实现未被调用
option  # option 调用option_cb  实现未被调用
list    # list   调用list_cb    实现未被调用
--------------------------------------- config管理  https://wiki.openwrt.org/doc/uci
config_unset    # 未见调用处
config_get      # config_get <variable> <section> <option> [<default>]
                # config_get <section> <option>
config_get_bool # config_get_bool <variable> <section> <option> [<default>]
config_set      # 见于/lib/network/config.sh 文件的fixup_interface; 以及function.sh的list和config_unset
config_foreach  # config_foreach callback wan [callback 为回调函数，wan为config类型对应的值为条件回调]
config_list_foreach # 
流程 1. config_load     dhcp # 创建环境变量
     2. config_foreach  dnsmasq dnsmasq #  config_foreach  dhcp_host_add host
     3.     config_get_bool _loctmp "$section" "$option" 0   # bool值     append_bool
            config_get _loctmp "$section" "$option"          # 具体参数   append_parm
            config_list_foreach "$cfg" "server" append_server # list      config_list_foreach
            config_get DOMAIN "$cfg" domain                  # 具体参数
--------------------------------------- 安装包管理 /lib/functions.sh
default_prerm       # 删除包前处理函数
default_postinst    # 安装包后处理函数
insert_modules      # insert_modules <内核包名称>[<内核包名称>...]
--------------------------------------- 用户管理 /lib/functions.sh
add_group_and_user  # add_group_and_user <pkgname>
group_add           # group_add <组名> 
group_exists        # group_add_user <组id>
group_add_next      # group_add_user [组id] 可以指定也可以不指定
group_add_user      # group_add_user <用户名>
user_add            # user_add <用户名> <用户id> <组id> [用户描述] [用户根路径] [用户管理shell]
user_exists         # user_exists <用户名>
--------------------------------------- /lib/functions.sh
find_mtd_index      # find_mtd_index u-boot 根据名称返回序号
find_mtd_part       # find_mtd_part u-boot 根据名称返回块设备名称
------------------------------------------------------------------------------- 策略1
reset_cb     参数为空                                               # step1
config_cb    参数1：config字段类型名称：参数2：config字段类型的值   # callback1[step2]
option_cb    参数1：option字段类型名称：参数2：option字段类型的值   # callback2[step2]
list_cb      参数1：option字段类型名称：参数2：option字段类型的值   # callback3[step2]
config_load  参数1：/etc/config/下配置文件名                        # step2

config timeserver 'ntp'                      # config_cb 参数1: timeserver    参数2: 'ntp' 
        list server '0.openwrt.pool.ntp.org' # list_cb   参数1: server        参数2: '0.openwrt.pool.ntp.org' 
        list server '1.openwrt.pool.ntp.org' # list_cb   参数1: server        参数2: '1.openwrt.pool.ntp.org'
        list server '2.openwrt.pool.ntp.org' # list_cb   参数1: server        参数2: '2.openwrt.pool.ntp.org'
        list server '3.openwrt.pool.ntp.org' # list_cb   参数1: server        参数2: '3.openwrt.pool.ntp.org'
        option enabled '1'                   # option_cb 参数1: enabled       参数2: '1'  
        option enable_server '1'             # option_cb 参数1: enable_server 参数2: '1' 
-------------------------------------------------------------------------------  策略2
reset_cb                                     # 重置回调函数
handle_interface()                           # 回调函数
config_load $1                               # 加载数据
config_foreach handle_interface interface $2 # 调用回调函数
}

base(系统处理脚本库 /lib/function/system.sh){
find_mtd_chardev   # find_mtd_chardev u-boot 根据名称返回字符设备名称
mtd_get_mac_ascii  # mtd_get_mac_ascii mtdname key # strings /dev/mtdblock0 | sed -n 's/^'"$key"'=//p'
mtd_get_mac_binary # hexdump -v -n 6 -s $offset -e '5/1 "%02x:" 1/1 "%02x"' /dev/mtdblock0 2>/dev/null
mtd_get_mac_binary_ubi # hexdump -v -n 6 -s $offset -e '5/1 "%02x:" 1/1 "%02x"' /dev/$part 2>/dev/null
mtd_get_part_size      # mtd_get_part_size u-boot 根据名称获得大小

macaddr_add           # 50:4A:98:4C:D7:57 -> oui-50:4A:98 nic-4C:D7:57 通过修改nic生成一个新mac地址
macaddr_setbit_la     # B0:3B:A3:D3:FB:AE -> B2:3B:A3:D3:FB:AE
macaddr_2bin          # 字符串macaddr到binary形式
macaddr_canonicalize  # 以"52:54:00:01:0A:A1 "格式输出macaddr
}

base(系统处理脚本库 /lib/function/preinit.sh){
boot_hook_init          # 
boot_hook_add           # 
boot_run_hook           # 
                        
boot_hook_shift         # 
boot_hook_splice_start  # 
boot_hook_splice_finish # 

pivot_root              # 将PUT_OLD迁移到NEW_ROOT
pivot                   # 将PUT_OLD迁移到NEW_ROOT
fopivot                 # fopivot <rw_root> <work_dir> <ro_root> <dupe?>
ramoverlay              # ramoverlay
}
base(系统处理脚本库 /lib/function/preinit.sh){
uci_load         # 
uci_set_default  # uci -q show ; uci import; uci commit
uci_revert_state # revert
uci_set_state    # set
uci_toggle_state # uci_revert_state ; uci_set_state
uci_set          # set
uci_get_state    # get /var/state
uci_get          # get
uci_add          # add | set
uci_rename       # rename
uci_remove       # remove
uci_commit       # commit
}

base(Openwrt固件生成过程){
11.1 Openwrt固件生成过程（基于MPR-A2硬件平台） 
---------------------------------------
（1） 编译Linux内核生成vmlinux，并将其拷贝为vmlinux-mpr-a2 
build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_rt305x/vmlinux-mpr-a2  # 
（2） 使用内核自带的工具dtc将target/linux/ramips/dts/MPRA2.dts编译成dtb格式的MPRA2.dtb 
build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_rt305x/MPRA2.dtb 
（3） 使用Openwrt提供的工具patch-dtb将上面生成的MPRA2.dtb填充到vmlinux-mpr-a2 
（4） 使用lzma 压缩vmlinux-mpr-a2，生成vmlinux-mpr-a2.bin.lzma 
build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_rt305x/vmlinux-mpr-a2.bin.lzma 
（5） 使用u-boot提供的工具mkimage将vmlinux-mpr-a2.bin.lzma制作成vmlinux-mpr-a2.uImage 
build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_rt305x/vmlinux-mpr-a2.uImage 
（6） 使用mksquashfs4将根文件系统build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips/制作成root.squashfs。 
build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_rt305x/root.squashfs 
参数格式如下： 
-nopad -noappend -root-owned -comp xz -Xpreset 9 -Xe -Xlc 0 -Xlp 2 -Xpb 2 -b 256k -p '/dev d 755 0 0' -p '/dev/console c 600 0 0 5 1' -processors 1 
-nopad：表示不对文件系统补齐为4K的整数倍。对于挂载为loopback 的文件系统需要4K对齐。 
-noappend：表示不添加到已存在的文件系统。 
-root-owned：使所有文件都拥有root权限 
-comp xz：指定压缩方式为xz 
-b 256k：指定数据块大小为256k（该大小在menuconfig中配置，参考23章） 
（7） 使用cat命令读取vmlinux-mpr-a2.uImage和root.squashfs合并为一个文件 
cat vmlinux-mpr-a2.uImage root.squashfs > openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin 
（8） 对openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin执行staging_dir/host/bin/padjffs2操作 
padjffs2 openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin 4 8 16 64 128 256 
其中padjffs2源码为tools/padjffs2/src/padjffs2.c。 
padjffs2会在openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin的末尾添加标记：0xdeadc0de，
在系统启动到用户空间时调用mount_root挂载文件系统时会用到。 
（9） 判断固件大小是否超过Flash可用空间 
if [ $(stat -c%s "openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin") -gt 8060928 ]; then
    echo "openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin is too big" >&2;  
else  
 cp -fpR openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin;  
fi
}



base(烧写固件tftp){
[TFPT Server]
openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin

4. Enter boot command line interface # 串口选择功能
RT5350 # set ipaddr 192.168.0.100  设置设备IP 地址 
RT5350 # set serverip 192.168.0.104  设置tftp服务器IP地址，即与你的设备相连的电脑的IP 地址 
RT5350 # set bootfile openwrt-ramips-rt305x-mpr-a2-squashfs-sysupgrade.bin 设置要下载的固件名称 
RT5350 # save   将设置写入Flash 
执行reset重启设备，在倒计时时按2进入tftp烧写固件步骤
}

openwrt(智能路由器-opkg [files|info]){
http://downloads.openwrt.org/ # 顶层

opkg update     # 软件列表的更新
opkg install    # 安装软件包，需要第三个参数传递一个软件包的名称。如 opkg install file
opkg remove     # 卸载安装包，需要第三个参数传递一个软件包的名称。autoremove可以将不需要的安装包也删除。如 opkg remove file --autoremove
opkg upgrade    # 升级软件包，需要第三个参数传递一个软件包的名称。一般只用来升级应用(非内核软件)。
opkg list       # 列出所有可使用的软件包
opkg list-installed # 列出系统中已经安装的软件包
opkg list-changed-conffiles # 列出用户修改过的配置文件
opkg files <pkg> # 列出属于这个软件包中的所有文件
opkg search <file> # 列出提供file的软件包，需要传递文件的绝对路径
opkg find <regexp> # 列出软件包名称和regexp匹配的软件包
opkg info [pkg]  # 显示已安装pkg软件包的信息
opkg download <pkg> # 将软件包pkg下载到当前目录
opkg print-architecture # 列出安装包的架构
opkg whardepends [-A] [pkg] # 针对已安装的软件包，输出依赖这个软件包的软件包
opkg命令选项：
-A    查询所有软件包
-d <dest_name>  使用dest_name作为软件包安装的根目录
-f <conf_file>  使用conf_file作为opkg的配置文件
--nodeps  不按照依赖来安装，只安装软件包自己
--autoremove  卸载软件包时自动卸载不再使用的软件包
--force-reinstall  强制重新安装软件包

/etc/opkg.conf #文件保存了OPKG的全局配置信息，
Packages.gz 到 /var/opkg-list目录下

src/gz chaos_calmer_base http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/base
src/gz chaos_calmer_luci http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/luci
src/gz chaos_calmer_packages http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/packages
src/gz chaos_calmer_routing http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/routing
src/gz chaos_calmer_telephony http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/telephony
src/gz chaos_calmer_management http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/management

# 当前版本关联的ipkg包
src/gz chaos_calmer_base http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7621/packages/base
src/gz chaos_calmer_luci http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7621/packages/luci
src/gz chaos_calmer_packages http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7621/packages/packages
src/gz chaos_calmer_routing http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7621/packages/routing
src/gz chaos_calmer_telephony   http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7621/packages/telephony
src/gz chaos_calmer_management  http://downloads.openwrt.org/chaos_calmer/15.05/ramips/mt7621/packages/packages/management

# 根据源安装
opkg install luci
opkg install softwall.ipk

# 本地安装
首先下载软件：
cd /root
wget http://downloads.openwrt.org/backfire/10.03.1/x86_generic/packages/openssh-sftp-server_5.8p2-2_x86.ipk
opkg install openssh-sftp-server_5.8p2-2_x86.ipk


# 网络直接安装
opkg install http://downloads.openwrt.org/backfire/10.03.1/x86_generic/packages/openssh-sftp-server_5.8p2-2_x86.ipk

/usr/lib/opkg下面

OPKG命令执行会读取已下部分的信息：配置文件、已安装软件包信息和软件仓库的软件包信息
1. 配置文件默认位置为/etc/opkg.conf
2. 已安装软件包状态信息保存在/usr/lib/opkg目录下
3. 软件仓库的软件包信息保存在/var/opkg-lists目录下

Package Manipulation:
        update                  Update list of available packages           # 更新可以安装的软件包列表
        upgrade <pkgs>          Upgrade packages                            # 升级软件包
        install <pkgs>          Install package(s)                          # 用于安装软件包
        configure <pkgs>        Configure unpacked package(s)               # 
        remove <pkgs|regexp>    Remove package(s)                           # 卸载软件包
        flag <flag> <pkgs>      Flag package(s)                             # 
         <flag>=hold|noprune|user|ok|installed|unpacked (one per invocation)# 

Informational Commands:
        list                    List available packages                     # 可用软件包
        list-installed          List installed packages                     # 已安装软件包
        list-upgradable         List installed and upgradable packages      # 可以升级软件包
        list-changed-conffiles  List user modified configuration files      # 列出用户修改过的配置文件
        files <pkg>             List files belonging to <pkg>               # 软件包的所有文件
        search <file|regexp>    List package providing <file>               # 用于列出提供<file>的软件包
        find <regexp>           List packages whose name or description matches <regexp> # 用于查找<regexp>匹配的软件包
        info [pkg|regexp]       Display all info for <pkg>                  # 
        status [pkg|regexp]     Display all status for <pkg>                # 
        download <pkg>          Download <pkg> to current directory         # 下载到当前目录
        compare-versions <v1> <op> <v2>
                            compare versions using <= < > >= = << >>
        print-architecture      List installable package architectures      # 软件包架构
        depends [-A] [pkgname|pat]+
        whatdepends [-A] [pkgname|pat]+
        whatdependsrec [-A] [pkgname|pat]+
        whatrecommends[-A] [pkgname|pat]+
        whatsuggests[-A] [pkgname|pat]+
        whatprovides [-A] [pkgname|pat]+
        whatconflicts [-A] [pkgname|pat]+
        whatreplaces [-A] [pkgname|pat]+
        
opkg list | grep pattern
opkg list | awk '/pattern/ {print $0}'
opkg info kmod-ipt-* | awk '/length/ {print $0}'
opkg list-installed | awk '{print $1}' | sed ':M;N;$!bM;s#\n# #g'
var="packagename1 packagename2 packagename2"; for i in $var; do opkg info $i; done;
opkg depends dropbear does not work either.

}

openwrt(智能路由器-opkg.conf){
opkg.conf 
dest root /
dest ram /tmp
lists_dir ext /var/opkg-lists
option overlay_root /overlay
src/gz chaos_calmer_base http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/base
src/gz chaos_calmer_luci http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/luci
src/gz chaos_calmer_packages http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/packages
src/gz chaos_calmer_routing http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/routing
src/gz chaos_calmer_telephony http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/telephony
src/gz chaos_calmer_management http://downloads.openwrt.org/chaos_calmer/15.05/x86/64/packages/management
option check_signature 1

# Local Repositories
src/gz local file:///path/to/packagesDirectory
}

openwrt(智能路由器-UCI){
MVC：模型层负责数据的持久化操作。OpenWrt的模型层采用统一配置接口。
UCI的目的在于集中OpenWrt系统的配置。

config 节点 以关键字 config 开始的一行用来代表当前节点
            section-type 节点类型
            section 节点名称
option 选项 表示节点中的一个元素
            key 键
            value 值
list 列表选项 表示列表形式的一组参数。
           list_key 列表键
           list_value 列表值
[文件语法]
配置文件由配置节(section)组成，配置节由多个"name/value"选项对组成。每一个配置节都需要有一个类型标识符，但不一定需要名称。
每一个选项对都有名称和值，写在其所属于的配置节中。
config <type> ["<name>"]  # section
  option <name> "<value>" # option

config system                                   # system为配置类型 -> 匿名配置节
        option hostname 'OpenWrt'               # 
        option zonename 'UTC'                   # 
        option timezone 'GMT0'                  # 
        option conloglevel '8'                  # 
        option cronloglevel '8'                 # 
                                                # 
config timeserver 'ntp'                         # timeserver为配置类型,ntp为名称
        list server '0.openwrt.pool.ntp.org'    # 在开始带有list关键字的选项，表示有多个值被定义，
        list server '1.openwrt.pool.ntp.org'    # 所有的语法有同一个选项名称server。
        list server '2.openwrt.pool.ntp.org'    # 
        list server '3.openwrt.pool.ntp.org'    # 
        option enabled '1'                      # list和option用来提高配置文件的可读性。
        option enable_server '1'                # 并且在语法上也要求使用关键字来表示配置选项的开始。
        
1. 如果一个选项是不存在的并且是必需的，那应用程序通常会触发一个异常或者记录一个异常的日志，然后程序退出。
2. UCI标识符和配置文件的名称只能包含字母a-z，0-9和_
3. 启动时由UCI配置文件转换为软件包的原始配置文件。这是在运行初始化脚本/etc/init.d中执行的。
   /var/etc/dnsmasq.conf是从UCI配置文件/etc/config/dhcp生成并覆盖的，是运行/etc/init.d/dnsmasq脚本进行配置文件转换的。
   /var/state
4. openwrt的大多数配置都基于UCI文件，如果你想在软件原始的配置文件调整设置，可以通过禁用UCI方法来实现。 ... 

dhcp       # dnsmasq软件包配置，包括DHCP和DNS设置
dropbear   # SSH服务器配置选项
firewall   # 防火墙配置，包括网络地址转换，包过滤和端口转发等
network    # 网络配置，包含桥接、接口和路由配置
system     # 系统配置，包括主机名称，网络时间同步等
timeserver # rdate的时间服务列表
luci       # 基本LuCI配置
wireless   # 无线设置和Wi-Fi网络定义
uhttpd     # Web服务器选项配置
upnpd      # miniupnpd UPnP服务器配置
qos        # 网络服务质量的配置文件定义

uci [<options>]  <command> [<arguments>]
add        # 增加指定配置文件的类型为section-type的匿名字段
           # uci add_list <config>.<section>.<option>=<value>  增加一个值到列表中
           # uci add <config> <section-type>                   增加一个匿名节点到文件
           # uci set <config>.<section>=<section-type>         增加一个节点到文件中
           # uci set <config>.<section>.<option>=<value>       增加一个选项和值到节点中
add_list   # 对已存在的list选项增加字符串
commit     # 对给定的配置文件写入修改，如果没有指定参数则将所有的配置文件写入文件系统那个。所有的"uci set" "uci add"
           # "uci rename" "uci delete"命令将配置写入一个临时文件，在运行"uci commit"时写入实际的存储位置。
           # commit     [<config>] -> 生效修改(任何写入类的语法,最终都要执行生效修改,否则所做修改只在缓存中,切记!)
export     # 导出一个配置文件的内容，如果不指定配置文件则表示导出所有配置文件的内容。 
           # 导出一个机器可读格式的配置。
           # package和文件名
import     # 以UCI语法导入配置文件
changes    # 列出配置文件分阶段修改的内容，即未使用"uci commit"提交的修改
           # uci changes <config>                  显示尚未生效的修改记录
show       # 显示指定的选项、配置节或配置文件。以精简的方式输出
           # 显示一个配置文件的配置信息，若未指定配置文件，则表示显示所有配置文件的配置信息
           # uci show                              显示全部 UCI 配置
           # uci show <config>                     显示指定文件配置
           # uci show <config>.<section>           显示指定节点名字配置
           # uci show <config>.<section>.<option>  显示指定选项配置
           # uci show -X <config>.<section>.<option> 匿名节点显示(如果所显示内容有匿名节点,使用-X 参数可以显示出匿名节点的 ID)
get        # 获取指定区段选项的值
           # uci get <config>.<section>             取得节点类型
           # uci get <config>.<section>.<option>    取得一个值
set        # 设置指定配置节选项的值，或者是增加一个配置节，类型设置为指定的值
           # 添加或修改一个option
           # uci set <config>.<section>.<option>=<value>  修改一个选项的值
           # uci set <config>.<section>=<section-type>    修改一个节点的类型
delete     # 删除指定的配置节或选项
           # uci delete <config>.<section>.<list>   删除列表
           # uci delete <config>.<section>.<option> 删除指定选项
           # uci delete <config>.<section>          删除指定名字的节点
del_list   # 删除列表中一个值 
           # uci del_list <config>.<section>.<option>=<string>
rename     # 对指定的选项或配置重命名为指定的名字
revert     # 恢复指定的选项，配置节或配置文件

uci set network.lan.ipaddr="192.168.56.11"
uci commit network
/etc/init.d/network restart

# 注意：当使用set、add、rename、delete命令操作后，再使用show命令查看的是修改后的未写入文件的配置信息，只
# 有通过commit命令写入文件后，show命令查看配置信息才与文件一致。

# 没有名称的section都是以config.@section-type[index]这样的格式表示的具有相同类型的匿名section，按照index 从0开始编号。 

#  有些运行中的状态值没有保存在/etc/config目录下，而是保存在/var/state下，这时可以使用-P参数来查询当前状态值。
uci -P/var/state show network.wan

uci add_list system.ntp.server='ntp.bjbook.net'
uci del_list system.ntp.server='ntp.ntp.org'
uci delete system.ntp.server

[配置脚本]
/lib/config/uci.sh

----- uci.sh 常用函数含义
uci_laod       # 从UCI文件中加载配置并设置到环境变量中，可以通过evn命令来查看。该命令需要和function.sh中的定义共同使用
uci_get        # 从配置文件中获取值。至少需要一个参数，指明要获取的配置文件。
uci_get_state  # 指定从/var/state中获取状态值

----- functions.sh 常用函数含义
config          # 供uci.sh调用, 将配置节设置到环境变量中
option          # 供uci.sh调用, 将配置节中的选项设置到环境变量中
list            # 供uci.sh调用, 将配置节中的链表配置设置到环境变量中
config_load     # 调用uci_load函数来从配置文件中读取配置选项，并设置到环境变量中
config_get      # 从当前设置环境变量中获取配置值
config_get_bool # 从当前设置的环境变量中获取布尔值，并将它进行格式转换
config_set      # 将变量设置到环境变量中以便后续读取
config_foreach  # 对未命名的配置进行遍历调用函数。第一参数为调用函数，第二个参数为配置节类型，

启动代码中有示例。

----- libubox C 语言函数接口
CMake -D工程选项
/usr/local/include
/usr/local/lib/libuci.so
/usr/local/bin/uci

uci_alloc_context
uci_free_context
uci_load
uci_unload
uci_lookup_ptr
uci_set
uci_delete
uci_save
uci_commit
uci_set_confdir
}

openwrt(智能路由器 - sysctl.conf){
# comment
; comment
token = value
sysctl -a
sysctl -n kernel.hostname
sysclt -w kernel.hostname='zhang'
sysctl -p /etc/sysctl.conf

cat /proc/sys/net/ipv4/ip_forward # 查询是否打开路由转发
echo "1" > /proc/sys/net/ipv4/ip_forward # 打开路由转发设置
}

openwrt(智能路由器 - 系统配置){
[/etc/rc.local] # /etc/rc.d/S95done调用/etc/rc.local

[/etc/profile]  # 为系统的每个登录用户设置环境变量， 
/etc/banner

[/etc/shells]
/bin/ash

[/etc/fstab]
关于文件系统的静态信息，

[/etc/services]
[/etc/protocols]
}

openwrt(智能路由器-软件开发){
./package/network/services/dnsmasq
dnsmasq/Makefile  #
dnsmasq/files     # 一般用于保存默认配置文件和初始化启动脚本
dnsmasq/patches   # 补丁目录是可选的： 也可以是一个src目录

[Makefile] -> rules.mk 集成过来
INCLUDE_DIR    # 源代码目录下的include目录
BUILD_DIR      # 代码编译的根目录，通常为"build_dir/target-*"
CONFIGURE_ARGS # configure的选项
    CONFIGURE_ARGS += \ 
        --disable-native-affinity \ 
        --disable-unicode \ 
        --enable-hwloc
CONFIGURE_VARS # configure的设置
    CONFIGURE_VARS += \
        ac_cv_file__proc_stat=yes \
        ac_cv_file__proc_meminfo=yes \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes
        
TARGET_CFLAGS  # 执行目标平台的C语言编译选项
TARGET_LDFLAGS # 指定目标平台的编译链接选项
MAKE_FLAGS     # make 编译选项
INSTALL_DIR    # 创建目录，并设置目录权限
INSTALL_DATA   # 安装数据文件，即复制并设置权限位0644
INSTALL_CONF   # 安装配置文件，即复制并设置权限位0600
INSTALL_BIN    # 安装可执行文件，即复制并增加执行权限，设置权限表示为0777

PKG_NAME
PKG_VERSION
PKG_RELEASE
PKG_SOURCE
PKG_SOURCE_URL      # http://www.lua.org/ftp/  https://github.com/kaloz/mwlwifi  git://git.code.sf.net/p/acx100/acx-mac80211
PKG_MD5SUM          # 
PKG_LICENSE         # 版权许可证 BZIP2  ISC  GPL-2.0  LGPLv2.1 GPLv2  BSD-2-Clause BSD-3-Clause
PKG_LICENSE_FILES   # 版权许可证文件 LICENSE  COPYRIGHT Licenses/README  COPYING.BSD-3
PKG_BUILD_DIR       # 构建路径
PKG_INSTALL         # 
PKG_BUILD_PARALLEL  # 并行编译
PKG_CONFIG_DEPENDS  # 可以指定的影响构建过程的配置选项，当配置发生变化的时候会Build/Configure这个模块
PKG_INSTALL_DIR     # 安装路径
PKG_SOURCE_PROTO    # bzr cvs darcs git hg svn 下载方式
PKG_SOURCE_SUBDIR   # 用于下载文件时的子路径
PKG_SOURCE_VERSION  # git的version
PKG_MAINTAINER
PKG_BUILD_DEPENDS
PKG_BASE_NAME:=my_module  # 包名称，在build_dir下面创建PKG_BASE_NAME-PKG_VERSION目录，用于存放源代码
}

openwrt(智能路由器－用户层模块开发方法){
例如添加模块名字加hello，其目录树如下：
hello
├── files     ———————–文件夹：存放文件如：服务配置文件/启动脚本等
├── Makefile ————————文件：打包相关的Makefile
└── src      ———————–文件夹：存放模块源码文件
├── hello.c ———————文件：源代码
└── Makefile ——————文件：源码编译用的Makefile

模块程序源代码
#include<stdio.h>
int main ()
{
    printf("hello world!\n");
    return 0;
}

源码编译Makefile
hello:hello.o
    $(CC) -o $@ $^
hello.o:hello.c
    $(CC) -c $<
clean:
    rm -rf *.o hello

ipK包制作规则Makefile
#
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_NAME:=hello
PKG_VERSION:=1.0
PKG_RELEASE:=1.0
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)
include $(INCLUDE_DIR)/package.mk
define Package/hello
SECTION:=libs
CATEGORY:=Libraries
TITLE:=hello
endef
define Build/Prepare
mkdir -p $(PKG_BUILD_DIR)
$(CP) ./src/* $(PKG_BUILD_DIR)/
endef
define Package/hello/description
the hello is the base utils of the skysoft’s smartrouter
endef
define Package/hello/install
$(INSTALL_DIR)  $(1)/usr/lib/
$(CP) $(PKG_BUILD_DIR)/hello.so* $(1)/usr/lib/
endef
$(eval $(call BuildPackage,hello))


编译模块
make package/libs/hello/compile V=99
make package/libs/hello/clean
make package/skysoft_web_admin/{clean,prepare,compile} V=99

ipk包制作
加入install后会将编译结果打包安装到SDK目录下bin目录下相应位置。
make package/skysoft_web_admin/{clean,prepare,compile,install} V=99

}

openwrt(智能路由器－内核模块开发方法){
http://www.liwangmeng.com/openwrt%E5%9F%BA%E6%9C%AC%E7%9F%A5%E8%AF%86%E5%BD%92%E7%BA%B3/#_Toc426631143
}



openwrt(智能路由器－路由器基础软件模块){
libubox: 主要提供
1. 多种基础通用功能接口，包括链表、平衡二叉树、二进制块处理、key-value链表、MD5和base64等等。
2. 提供多种sock接口封装
3. 提供一套基于事件驱动的机制及任务队列管理功能。
   目的是以动态链接库方式来提供可重用的通用功能，给其他模块提供便利和避免再造轮子。
[libs]
libubox          # 引用者：ubusd netifd freecwmp procd
jshn             # hshn是封转JSON对象的转换库，用于脚本语言生成JSON对象和将JSON对象数据取出。
jshn.sh          # 利用jshn工具对JSON的操作进行的更为便利的封装。
libblobmsg-json  # 

[exe]
ubus             # 精灵程序，接口库和实用工具； 提供各种后台进程与应用程序之间的通信机制。
netif            # 管理网络接口和路由功能的后台进程
freecwmp         #

---- ubus 命令 提供系统级的进程间通信功能
[ubus]
ubusd       # 精灵程序
libubus.so  # 其他进程可以通过该动态链接库来简化对ubus总线的访问
ubus        # 提供命令行的接口调用工具。可以基于该工具进行脚本编程，也可以使用ubus来诊断问题。
Usage: ubus [<options>] <command> [arguments...]
Options:
 -s <socket>:           Set the unix domain socket to connect to
 -t <timeout>:          Set the timeout (in seconds) for a command to complete
 -S:                    Use simplified output (for scripts)
 -v:                    More verbose output

Commands:
 - list [<path>]                        List objects
 - call <path> <method> [<message>]     Call an object method
 - listen [<path>...]                   Listen for events
 - send <type> [<message>]              Send an event
 - wait_for <object> [<object>...]      Wait for multiple objects to appear on ubus
 
1. list     # 输出所有注册到ubus RPC服务器的对象
ubus list   # 缺省列出所有通过RPC服务器注册的命名空间:
ubus list dhcp -v                  
ubus -v list network.interface.lan #如果调用时包含参数-v,将会显示指定命名空间更多方法参数等信息:
2. call     # 在指定对象里调用指定的方法并传递消息参数
# 调用指定命名空间中指定的方法，并且通过消息传递给它:
ubus call network.interface.wan status
ubus call network.device status '{"name":"eth0"}' #消息参数必须是有效的JSON字符串，并且携带函数所要求的键及值:
ubus call network.interface.wan down
ubus call network.interface.wan up
ubus call system info
{
        "uptime": 15902,
        "localtime": 1514092135,
        "load": [
                96,
                0,
                0
        ],
        "memory": {
                "total": 527233024,
                "free": 478474240,
                "shared": 65536,
                "buffered": 2940928
        },
        "swap": {
                "total": 0,
                "free": 0
        }
}
ubus call system board
{
        "kernel": "3.18.36",
        "hostname": "OpenWrt",
        "system": "MediaTek MT7621 ver:1 eco:3",
        "model": "Oolite-v8 32MB",
        "release": {
                "distribution": "OpenWrt",
                "version": "Chaos Calmer",
                "revision": "unknown",
                "codename": "chaos_calmer",
                "target": "ramips\/mt7621",
                "description": "OpenWrt Chaos Calmer 15.05.1"
        }
}
ubus call system watchdog
{
        "status": "running",
        "timeout": 30,
        "frequency": 5
}


3. listen   # 监听套接字来接受服务器发出的消息
ubus listen  # 设置一个监听socket并观察进入的事件:
ubus listen log
4. send     # 发出一个通知事件，这个事件可以使用listen命令监听到
ubus send hello '{"book":"openwrt"}'   # 发送一个事件提醒:
5. wait_for # 用于等待多个对象注册到ubus中，当等待的对象注册成功后即退出。

-------------------------------------------------------------------------------
通过HTTP访问ubus
    这里有个叫做uhttpd-mod-ubus的uhttpd插件允许通过HTTP协议来调用ubus，请求必须通过POST方法发送/ubus
(除非有修改)URL请求。这个接口使用了jsonrpc v2.0这里有几个步骤需要你去了解。
-------------------------------------------------------------------------------
1. ubus提供了一个socket server：ubusd。因此开发者不需要自己实现server端。
2. ubus提供了创建socket client端的接口，并且提供了三种现成的客户端供用户直接使用：
    1) 为shell脚本提供的client端。
    2) 为lua脚本提供的client接口。
    3) 为C语言提供的client接口。
可见ubus对shell和lua增加了支持，后面会介绍这些客户端的用法。
3. ubus对client和server之间通信的消息格式进行了定义：client和server都必须将消息封装成json消息格式。
4. ubus对client端的消息处理抽象出“对象（object）”和“方法（method）”的概念。一个对象中包含多个方法，
   client需要向server注册收到特定json消息时的处理方法。对象和方法都有自己的名字，发送请求方只需在
   消息中指定要调用的对象和方法的名字即可。
-------------------------------------------------------------------------------
使用ubus时需要引用一些动态库，主要包括：
 libubus.so：ubus向外部提供的编程接口，例如创建socket，进行监听和连接，发送消息等接口函数。
 libubox.so：ubus向外部提供的编程接口，例如等待和读取消息。
 libblobmsg.so，libjson.so：提供了封装和解析json数据的接口，编程时不需要直接使用libjson.so，
 而是使用libblobmsg.so提供的更灵活的接口函数。
}

openwrt(智能路由器－netifd){
device_type           父类
  simple_device_type  子类 # 简单设备
  bridge_device_type  子类 # 网桥设备，网桥设备可以包含多个简单设备
  tunnel_device_type  子类 # 隧道设备，例如在以太网上封装GRE报文
  macvlan_device_type 子类 # 一个物理网卡上创建另一个MAC地址的网络，即在真实的物理网卡上再虚拟出来一个网卡
  vlandev_device_type 子类 # 一个网卡通过VLAN ID划分为多个网卡
  
claim_device   启动设备
release_device 释放设备

[event]
DEV_EVENT_ADD       # 系统中增加了设备，当设备用户增加到一个存在的设备上时，这个事件立即产生
DEV_EVENT_REMOVE    # 设备不再可用，或者是移除了设备或者是不可见了。所有的设备用于应当立即移除引用并且清除这个设备的状态
DEV_EVENT_SETUP     # 设备将要启动，这允许设备用户去应用一些必要的低级别的配置参数
                    # 这个事件并不是在所有情况下均被触发
DEV_EVENT_UP        # 设备已经启动成功
DEV_EVENT_TEARDOWN  # 设备准备关闭
DEV_EVENT_DOWN      # 设备已关闭

[status]
IFS_SETUP         # 协议处理函数正在配置当前接口
IFS_UP            # 接口完全配置完成
IFS_TEARDOWN      # 接口完全配置完成接口正在关闭中
IFS_DOWN          # 接口已经关闭

每个接口均有一个协议处理函数。协议处理函数(例如PPP协议)可以设置一个辅助协议处理函数(例如PPPoE或PPTP)。协议
处理函数是在状态改变时提供的回调函数。
interface_proto_state
PROTO_CMD_SETUP     # IFPEV_UP
PROTO_CMD_TEARDOWN  # IFPEV_DOWN

PROTO_FLAG_IMMEDIATE # 标志

[ubus]
network
network.device
network.interface

[ubus] network
方法                函数                       #含义
restart             netifd_handle_restart      # 整个进程管理后重新启动
reload              netifd_handle_reload       # 重新读取配置来初始化网络设备
add_host_route      netifd_add_host_route      # 增加静态主机路由，是根据当前的路由增加一个更为具体的路由表选项，
                                               # 目的地址而不是IP网段。例如：
                                               # ubus call network add_host_route '{"target":"192.168.1.20","v6":"false"}'
                                               # 将增加一个静态的主机的接口路由
get_proto_handlers  netifd_get_proto_handlers  # 获取系统所支持的协议处理函数，函数不需要参数

[ubus] network.device  二层
方法        函数                     # 含义
status      netifd_dev_status        # 获取物理网卡设备的状态，包括统计信息
                                     # ubus call network.device status '{"name":"eth0"}'
set_alias   netifd_handle_alias      # 设置alias
set_state   netifd_handle_set_state  # 设置状态

[ubus] network.interface  三层
方法           函数                          # 含义
up             netifd_handle_up              # 启动接口
down           netifd_handle_down            # 关闭接口
status         netifd_handle_status          # 查看接口状态，如果为启动，则包含启动时间、IP地址等
add_device     netifd_iface_handle_device    # 增加设备
remove_device  netifd_iface_handle_device    # 删除设备
notify_proto   netifd_iface_handle_proto     # 调用原型函数，在netifd-proto.sh中会使用到
remove         netifd_iface_handle_remove    # 删除接口
set_data       netifd_handle_set_data        # 设置额外存储数据，可以通过status方法来查看

ubus call network.interface status '{"interface":"lan"}'
ubus call network.interface status '{"interface":"wan"}'
ubus call network.interface.lan status
ubus call network.interface.wan status

netifd注册的shell命令 [netifd-proto.sh]
编号 shell命令              # 含义
0    proto_init_update      # 初始化设备及配置
1    proto_run_command      # 运行获取IP地址命令，例如启动dhcp客户端或者启动ppp拨号
2    proto_kill_command     # 杀掉协助处理进程，例如杀掉udhcpc进程
3    proto_notify_error     # 通知发生错误
4    proto_block_restart    # 设置自动启动标识变量autostart为false
5    proto_set_available    # 设置接口的available状态
6    proto_host_dependency  # 增加对端IP地址的路由
7    proto_setup_failed     # 失败后设置状态

编号为在netifd进程和shell脚本之间的预先定义好的处理动作ID。在netifd-proto.sh中设置，通过ubus消息总线传递到netifd进程
中，根据功能编号来进入到相应的处理函数。
shell脚本导出的命令供各种协议处理函数调用。
<udhcpc>
proto_init_update  # 初始化设备
proto_run_command  # 启动udhcpc进程获取IP地址等信息。
静态IP配置不需要shell脚本就可以进行IP地址配置，其他的设置如DHCP或PPPoE就需要一系列的Shell脚本来进行设置。
每一种的协议处理脚本都存放在/lib/netifd/proto,文件名通常和网络配置文件network中的协议选项关联起来。

<dhcp>
proto_dhcp_init_config() 这个函数负责协议配置的初始化，主要目的是让netifd知道这个协议所拥有的参数。
proto_dhcp_setup()       这个函数负责协议设置，主要目的是实现了DHCP协议配置和接口启动。
proto_dhcp_teardown()    这个函数负责接口关闭动作，如果协议需要特别的关闭处理。

<command>
ifup         # 启动接口
ifdown       # 关闭接口
devstatus    # 获取网卡设备状态
ifstatus     # 获取接口的状态
-------------------------------------------------------------------------------
ubus
Path                    Procedure       Signature                               Description
network                 restart         { }                                     Restart the network, reconfigures all interfaces
network                 reload          { }                                     Reload the network, reconfigure as needed
network.device          status          { "name": "ifname" }                    Dump status of given network device ifname
network.device          set_state       { "name": "ifname", "defer": deferred } Defer or ready the given network device ifname, depending on the boolean value deferred
network.interface.name  up              { }                                     Bring interface name up
network.interface.name  down            { }                                     Bring interface name down
network.interface.name  status          { }                                     Dump status of interface name
network.interface.name  prepare         { }                                     Prepare setup of interface name
network.interface.name  add_device      { "name": "ifname" }                    Add network device ifname to interface name (e.g. for bridges: brctl addif br-name ifname)
network.interface.name  remove_device   { "name": "ifname" }                    Remove network device ifname from interface name (e.g. for bridges: brctl delif br-name ifname)
network.interface.name  remove          { }                                     Remove interface name (?)

}

rpcd(https://wiki.openwrt.org/zh-cn/doc/techref/ubus){
-------------------------------------------------------------------------------
Path    Procedure   Signature   Description
file    read        ?           ?
file    write       ?           ?
file    list        ?           ?
file    stat        ?           ?
file    exec        ?           ?

-------------------------------------------------------------------------------
Path    Procedure   Signature   Description
iwinfo  info        ?           ?
iwinfo  scan        ?           ?
iwinfo  assoclist   ?           ?
iwinfo  freqlist    ?           ?
iwinfo  txpowerlist ?           ?
iwinfo  countrylist ?           ?

-------------------------------------------------------------------------------
Path        Procedure	Signature	Description
session     list	{ "session": "sid" }	Dump session specified by sid, if no ID is given, dump all sessions
session     create	{ "timeout": timeout }	Create a new session and return its ID, set the session timeout to timeout
session     grant	{ "session": "sid",
                "objects": [ [ "path", "func" ], … ] }	Within the session identified by sid grant access to all specified procedures func in the namespace path listed in the objects array
session	revoke	{ "session": "sid",
                "objects": [ [ "path", "func" ], … ] }	Within the session identified by sid revoke access to all specified procedures func in the namespace path listed in the objects array. If objects is unset, revoke all access
session	access	?	?
session	set	{ "session": "sid",
                        "values": { "key": value, … } }	Within the session identified by sid store the given arbitrary values under their corresponding keys specified in the values object
session	get	{ "session": "sid",
                          "keys": [ "key", … ] }	Within the session identified by sid retrieve all values associated with the given keys listed in the keys array. If the key array is unset, dump all key/value pairs
session	unset	{ "session": "sid",
                            "keys": [ "key", … ] }	Within the session identified by sid unset all keys listed in the keys array. If the key list is unset, clear all keys
session	destroy	{ "session": "sid" }	Terminate the session identified by the given ID sid
session	login	?	?

}

openwrt(智能路由器－网络配置 netifd){
/etc/config/network

interface 静态配置选项   # 根据接口类型不同，生成不同类型的虚拟网络名称
名称         类型        # 含义
ifname        字符串     # ifname 指明了Linux 网络接口名称。
# 如果想桥接一个或多个接口，可以将ifname 设置成一个list，并且添加一个option type 'bridge'
type          字符串     # 网络类型，bridge
proto         字符串     # 设置为static，表示静态配置
ipaddr        字符串     # IP地址
netmask       字符串     # 网络掩码
dns           字符串     # 域名服务器地址
mtu           数字       # 设置接口的mtu地址

interface DHCP常见配置选项
名称         类型        # 含义
ifname        字符串     # 物理网卡接口名称，例如etho
proto         字符串     # 设置为DHCP
hostname      字符串     # DHCP请求中的主机名，可以不用设置
verdorid      字符串     # DHCP请求中的厂商ID，可以不用设置
ipaddr        字符串     # 建议的IP地址，可以不用设置

interface PPPoE常见配置选项
ifname        字符串     # 物理网卡接口名称，例如etho
proto         字符串     # 设置为PPPoE
username      字符串     # PAP或CHAP认证用户名
password      字符串     # PAP或CHAP认证密码
demand        数字       # 指定空闲时间之后将连接关闭，在以时间为单位计费的环境下经常使用

--------------------------------------- lan 口纯交换机模式
config
    option name 'rt305x'
    option reset '1'
    option enable_vlan '0'    # 交换芯片启用vlan
    把无关的配置全部删除了，只留下环回接口、lan 和switch。option enable_vlan '0'表示禁止VLAN。
并不是所有的SOC都支持可编程的switch

--------------------------------------- lan 口路由器模式
config switch 
    option name 'rt305x'
    option reset '1'
    option enable_vlan '1'    # 交换芯片启用vlan
config switch_vlan
    option device 'rt305x'
    option vlan '1'
    option ports '0 2 3 4 6t' # 0 2 3 4 为vlan1，将0 2 3 4带有vlan1的数据包交给6接口
    # 从端口0，2，3，4离开的帧将被解除VLAN标签，而从端口6离开的帧将被打上VLAN标签。
    # 端口6是SOC内部的端口（查看RT5350的芯片手册得知RT5350总共有7个端口P0~P6）。
    # VLAN1, 和上面的option ifname "eth0.1"相匹配，所以是配置LAN口
config switch_vlan
    option device 'rt305x'
    option vlan '2'
    option ports '1 6t'       # 1为vlan2，将1带有vlan2的数据包交给6接口
    # VLAN2, 和上面的option ifname "eth0.2"相匹配，所以是配置WAN口
# http://wiki.openwrt.org/doc/uci/network/switch 交换芯片说明文档

--------------------------------------- /lib/functions/network.sh
这些函数可以方便的查询给定逻辑接口的相关信息。 
其中核心命令为 jsonfilter 同时包括IPv4|IPv6
network_get_ipaddr ip     <lan|wan>       # 查询逻辑interfere 的第一个IPv4地址：
network_get_device ifname <lan|wan>       # 查询逻辑interfere 所对应的L3层Linux网络设备
network_get_subnet subnet <lan|wan>       # 查询逻辑接口的第一个IPv4子网：
network_get_gateway gateway <lan|wan>     # 查询逻辑接口（interfere）的IPv4网关：
network_get_dnsserver dnsserver <lan|wan> # 查询逻辑interfere 的DNS服务器：
network_get_protocol proto <lan|wan>      # 查询逻辑interfere 所使用的协议
network_is_up <lan|wan>                   # 查询逻辑interfere 的状态（UP/DOWN）
}

openwrt(智能路由器－ubox){
1. 内核模块管理                kmodloader(rmmod insmod lsmod modinfo modprobe)
2. 日志管理                    日志管理提供了ubus日志服务，可以通过ubus纵向来获取和写入日志，logread读取日志，logd来对日志进行管理。
3. UCI配置文件数据类型验证     validate_data
验证常用关键字及其含义
关键字
bool
cidr
cidr4
file
host
ip4addr
list
netmask4
or
portrange
port
range
string
uinteger

}

openwrt(智能路由器－procd){
它通过init脚本来讲进程信息加入到procd的数据库中来管理进程启动，这是通过ubus总线调用来实现的，可以防止进程的重复启动调用。
1. reload_config # 检查配置文件是否发生变化，如果有变化则通知procd进程
2. procd守护进程 # 守护进程，接收使用者的请求，增加或删除所管理的进程，并监控进程的状态，如果发现进程退出，则再次启动进程
3. procd.sh      # 提供函数封装procd提供系统总线方法，调用者可以非常方便的使用procd提供的方法

reload_config: /var/run/config.md5(当前配置文件的md5值)
               /var/run/config.check(临时配置目录)
               md5sum -c 
当在命令行执行reload_config时，会对系统中的所有配置文件生成MD5值，并且和应用程序使用的配置文件MD5值进行比较，
如果不同就通过ubus总线通知procd配置文件发生变化，如果应用程序在启动时，向procd注册了配置触发服务，那就将调用
reload函数重新读取配置文件，通常是进程退出再启动。如果配置文件没有发生变化就不会调用，这将节省系统CPU资源。
1. 空行和注释会被md5命令注释调用。

procd进程：
procd进程向ubus总线注册了service和system对象。
ubus list service -v
ubus list system -v

进程管理、文件触发器和配置验证服务。

------ service 对象
这些都是通过set方法增加到procd保存的内存数据库中。数据库以服务名称作为其主键。
set方法共需要5个参数，
第一个数为被管理的服务进程名称；                                  # 必须
第二个参数为启动脚本绝对路径                                      # 必须
第三个参数为进程实例信息：例如可执行程序路径和进程的启动参数等等  # 必须
第四个参数为触发器                                                # 可选
第五个参数为配置验证项                                            # 可选
ubus call service add '{"name":"hello", "script":"/etc/init.d/hello", 
"instance":{"instance1":{"command":["/bin/hello", "-f", "-c", "bjboojk.net"], "respawn":[]}},
"triggers": [["config.change", ["if", ["eq", "package", "hello"], ["run_script", "/etc/init.dhello", reload]]]]}'

delete 只需要两个参数
第一个参数为服务名称        # 必须
第二个参数为进程实例名称    # 可选
ubus call service delete '{"name":"hello"}'

list 只需要两个参数
第一个参数为服务名称        # 必须
第二个参数为bool值          # 可选 详细否
ubus call service list '{"name":"hello", "verbose":true}'

ubus call service event '{"type":"config.change", "data":{"package":"hello"}}'

service 对象常用方法
方法      # 含义
set       # 进程如果存在，则修改已经注册的进程信息，如果不存在则增加，最后启动注册的进程。
add       # 增加注册的进程
list      # 如果不带参数，则列出所有注册的进程和其信息
delete    # 删除指定服务进程，在结束进程时调用，ubus call service delete '{"name":"firewall"}'
event     # 发出事件，，例如reload_conf就使用该方法来通知配置发生改变
validate  # 查看所有验证服务


------ system 对象
方法         # 含义
board        # 系统软硬件版本信息，包含4个部分，内核版本，主机名称、系统CPU类型信息和版本信息，版本信息从/etc/openwrt_release文件读出
info         # 当系统信息，分别为系统启动时间，系统当前时间，系统负载情况，内核和交换分区占用情况
upgrade      # 设置service_update为1
watchdog     # 设置watchdog信息，还存在问题，例如如果本为0的情况
signal       # 向指定pid的进行发信号，是通过kill函数来实现的
nandupgrade  # 执行升级

procd.sh
使用ubus方法来进行管理时，其传递参数复杂并且容易出错，procd.sh将这些参数拼接组织功能封装为函数，
每一个需求被procd管理的进程都使用它提供的函数进行注册。
procd_open_trigger
procd_close_trigger
procd_open_instance
procd_set_param
  command
  respawn
  env
  file
  netdev
  limits
procd_close_instance
procd_add_reload_trigger
procd_open_validate
procd_close_validate
procd_open_service
procd_close_service
procd_kill
uci_validate_section

rc.common
procd预定义的函数
start_service     # 向procd注册并启动服务，是将在services所管理对象里面增加一项
stop_service      # 让procd解除注册，并关闭服务，是将在services中的管理对象删除
service_triggers  # 配置文件或网络接口改变之后触发服务器重启读取配置
service_running   # 查询服务状态
reload_service    # 重复服务，如果定义了该函数，在relaod时将调用该函数，否则再次调用start函数
service_started   # 用于判断进程是否启动成功

}

openwrt(CWMP：CPE WAN Managment Protocol [tr069]){
ACS:自动配置服务器(Auto Configuration Server)   网络中的管理服务器  服务器
CPE:客户端设备    (Customer premises equipment) 网络中被管理设备    客户端
CWMP是一个双向的SOAP/HTTP的协议。控制配置数据的流动是客户端设备的职责。

freecwmp
opkg install freecwmp-curl

}

openwrt(智能路由器－dropbear){
SSH V2
}

openwrt(智能路由器－QoS){
1. 尽力而为服务模型
2. 综合服务模型
3. 区分服务模型
OpenWrt采用区分服务模型.
流量分类
流量整形
调度

/etc/config/qos
1. 优先处理小包，例如TCP-ACKs和DNS等
2. 优先处理用户交互的报文。例如SSH等报文

qoc-script: package/network/config/qos-scripts
sqm-scripts和wshaper

iptables和tc来实现。
}

openwrt(智能路由器－uHTTPd){
uhttpd-mod-tls模块，Lua
opkg update
opkg install uhhtpd

/etc/config/uhttpd
/etc/init.d/uhttpd

}

openwrt(智能路由器－NTP){
/etc/config/system


/etc/init.d/sysntpd restart

uci set system.ntp.enable=1
uci commit system
}

openwrt(智能路由器－PPPoE){
/etc/ppp/chap-secrets
/etc/ppp/options
/etc/config/network

}

openwrt(智能路由器－iwconfig){
服务集标识符SSID (Service Set Identifier)
有线等效保密WEP  (Wired Equivalent Privacy)
无线保护接入WPA  (Wi-Fi Protected Access)

iwconfig
/etc/config/wireless
wifi-device # 无线网络物理设备名称
macaddr     # 无线网络物理设备MAC地址
txpower     # 设备发射功率，和iwconfig看到的接口发送功率对应
country     # 国家编码
hwmode      # 设备工作模式，11g代表2.4G, 11ac代表5G。和iwconfig看到的接口工作模式对应
channel     # 设备工作信道，自动或者1-14(2.4G)
device      # 三层接口还为物理接口绑定设置
network     # 网络层工作方式，例如lan
mode        # 接口工作模式：station ap
ssid        # 无线网络标识符
key         # 无线网络密码
encryption  # 无线加密方式，例如：psk2 wpa-psk

uci set wireless.wifi0.channel='auto'
uci commit
}

openwrt(智能路由器－路由){
接口路由，静态路由，动态路由
网络路由， 主机路由
策略路由，普通的目的地址路由

route -n

ip route add default via <gw ip> dev eth0
route add default gw  <gw ip> dev eth0

ip route get 8.8.8.8

静态路由配置含义
选项         类型          # 含义
interface    字符串        # 三层网络接口名称，例如wan
target       字符串        # 目的主机IP或者网络地址
netmask      字符串        # 如果target为网络地址，在这里需要填写网络掩码，例如255.255.255.0
gateway      字符串        # 网关地址，即IP报文的下一条地址
metric       整形数字      # 路由的优先级
mtu          整形数字      # 该路由的IP报文最大传输单元
table        整形数字      # 路由表，默认为main表，通常不用设置，如果开启策略路由则需要设置


本地路由表local,     路由表编号255,本地路由表负责本机IP地址和广播地址的路由，内核将自动维护这个路由表，
                     如果没有改路由表，则任何网络不能访问
主路由表  main       路由表编号254，通常的单播路由均保存在主路由表中。
默认路由表default    路由表编号253，默认路由表通常没有任何路由表项。

Linux系统可以处理1-2的31次方个路由表，路由表名称和编号之间的对应关系有/etc/iproute2/rt_tables来指定。
默认情况下所有的路由均插入到主路由表中，除了内置的3个路由表外，其他的路由表来源于策略路由。
ip route add增加路由：
tables TABLEDID # 这条路由所在的表，TABLEID可以是数字或者是配置文件/etc/iproute2/rt_tables的字符串。默认main表中
dev    NAME     # 报文输出网卡设备名称
via    ADDRESS  # 报文的网关地址，即下一条地址。
src    ADDRESS  # 发送这个路由报文所使用的源地址
ip route del
ip route list
ip route get #   这个命令用于传递一个IP地址，里ecu该目标地址的内核路由，这个路由就是内核时间转发该目标地址报文的路由。

ip rule
0:      from all lookup local 
32766:  from all lookup main 
32767:  from all lookup default
匹配策略表默认有3条规则，编号越小，优先级越高。
标号0的匹配规则是优先级最高的规则，所有的报文都要进入本地路由表(local)中进行处理，如果删除，则不能访问任何网络。
标号32766匹配所有的报文，使用主表进行路由。这个主表就是普通的单播路由表。
标号32767匹配所有的报文，使用默认表进行路由。通常这个默认表都是空的。

ip rule [list | add | del | flush] SELECTOR ACTION
SELECTOR:
from         # 根据源地址匹配
to           # 根据目的地址匹配
iif          # 选择报文的源接设备接口，如果接口是回环接口，则规则进匹配本机产生的报文。
oif          # 选择报文发送设备去匹配。发送接口仅仅针对本机产生的报文，这些报文通过绑定本机socket来发送报文。
tos          # 报文的服务类型
fwmark       # 选择防火墙值fwmark去匹配。这个值通常由iptables来设置。
ACTION:      
tables       # 用于匹配之后结束策略路由跳转到对应的路由表，通过table关键字来指定
prohibit     # 
reject       # 
unreachable  # 

/etc/config/network OpenWrt15.05中已经支持UCI方式进行自定义路由表的配置，但还不支持策略路由配置。

# table vip
echo "200 vip" >> /etc/iproute2/rt_tables
ip route add default via 172.16.100.1 table vip
ip route add 172.16.100.0/24 dev eth1 table vip
ip rule add from 192.168.6.100/32 table vip
# table main
ip route add default via 10.0.0.2 dev eth0
}

openwrt(智能路由器－组播路由){
    组播方式：源主机只需要发送一份报文到组播地址。加上路由器的组播路由支持，就可以到达每个需要接收的主机上。
    组播数据在传输层封装为UDP报文进行传输。在IP层，组播吧224.0.0.0~239.255.255.255的D类地址作为组播目的地址。
    为了使主机能收到组播报文，接口需要在组播地址进行监听，因为主机需要指定组播的MAC地址，在IP地址到链路地址
转换过程中，组播使用专用的MAC地址范围，MAC组播地址是由IP组播地址转换过来的。 01-00-5E # 点对点协议没有MAC地址
1. 为了让网络中的多个客户端可以同时接收到相同的报文。
2. 路由器根据组播路由由协议来对组成员和组关系进行维护和生成组播路由。
3. 组播：224.0.0.0~239.255.255.255
4. 为了使主机能收到组播报文，接口需要在组表地址进行监听，因此主机需要指定组播的MAC地址，
    在IP地址到链路地址转换过程中，组播使用专用的MAC地址范围，MAC组播地址是由IP组播地址转换过来的。
5. 组播MAC地址开始六字节是01-00-5E，例如组播MAC地址为236.0.0.1，转换为二进制取最右边23位，即组播地址为01-00-5E-00-00-01
6. IP组播地址使用28位来表示，而以太网组播地址使用23位地址，因此32个IP组播地址映射到同一个MAC地址，组播MAC地址范围如下：
   01-00-5E-00-00-00  01-00-5E-7E-FF-FF

组播路由的创建方式：
1. 静态组播路由
2. PIM协议
3. IGMP代理   
1. PIM和IGMP代理实现了对组员和组之间关系的维护机制，可以明确知道在网络是否有主机对这类组播报文感兴趣，如果
没有就不会把报文进行转发，并会通知上游路由器不要再转发这类报文到下游路由器上。静态组播路由需要进行手动设置，
不会进行动态维护，只能由管理员设置。
2. 组播路由：源接口，源IP，目的地址及目的接口 === 四元组
# ip mroute
(10.0.1.1, 236.0.0.1) Iif: eth0 Oifs: br-lan
    源地址是报文的发起者，目标地址为组播地址，是目的主机所要接收的组播报文地址。
    Iif为报文进入接口，只有从该接口进入的报文才会被转发，
    Oifs为报文转发出口地址，组播报文从这里转发给目标主机。


常见永久组播地址及含义
224.0.0.0~224.0.0.255      # 本地网络控制组播组地址。其TTL值应当为1，但路由器不论TTL值为多少，都不应当转发这些报文
239.0.0.0~239.255.255.255  # 管理用途的组播地址。这些地址被分配给每个组织内部使用，组织内的路由器不能将这些地址的
                           # 组播报文发送到组织外。不向外在的地址提供路由。RFC2365
224.0.0.1                  # 所有主机(包括路由器)均在该地址监听
224.0.0.2                  # 所有的路由器均在该地址监听
239.255.255.250            # UPNP组播地址

常见IGMP组播消息
消息类型          目的地址                  # 含义
组播查询消息      244.0.0.1                 # 所有主机均在该地址监听，组播路由器向该地址发出查询，是否还有组播客户端
离开组播组消息    244.0.0.2                 # 所有的路由器均在该地址监听，主机发出的目的地址为244.0.0.2报文，告诉组播路由器主机离离开了组播组
组成员查询消息    正在查询的组播地址        # 向组播地址查询是否有组播成员，如没有组播成员将删除组播路由
组成员报告消息    要加入或已加入的组播地址  # 报告组播组还有组成员存在

igmpproxy软件 /etc/config/igmpproxy
              var/tmp/igmpproxy.conf
              
配置了IGMP代理功能的设备不再是一个路由设备，而仅是一台主机。
上行接口：代理接口，指IGMP代理设备上运行IGMP代理功能的接口，即朝向组播分发树树根方向的接口。
          该接口在上行路由器看来是执行IGMP协议的主机行为。
下行接口：指IGMP代理设备上除上行接口外其他运行IGMP协议的接口，即背向组播分发树树根方向的接口。
          该接口在家庭内网主机看来是执行IGMP协议的路由器行为。
ip mroute   


Multicast over TCP/IP HOWTO
http://www.tldp.org/HOWTO/Multicast-HOWTO.html
}

openwrt(智能路由器－dns){
1. 没有/etc/resolv.conf配置文件 127.0.0.1 -> dnsmasq
2. 配置多个域名服务器地址 /etc/resolv.con
3. 配置有domain           /etc/hosts

dnsmasq # https://wiki.openwrt.org/doc/howto/dhcp.dnsmasq
/etc/config/dhcp
[全局配置]
domainneeded         domain-needed         不会转发针对不带点的的普通文本的A或AAAA查询请求到上行域名服务器。
                                            如果在/etc/hosts和DHCP中没有该名称将直接返回"not found"
cachesize            cache-size            指定缓存的大小，默认是150
boguspriv            bogus-priv            所有私有查询如果在/etc/hosts没有找到，将不转发到上行DNS服务器
filterwin2k          filterwin2k           不转发公共域名不能应答的请求
localise_queries     localise-queries      如果多个借口，则返回从查询接口来的接口网络的主机IP地址。在同一个主机有
                                           多个IP地址时非常有用，返回查询网段的IP地址，这样源主机和目标主机通信是将不会跨越路由器
rebind_protection    stop-dns-rebind       上有域名服务器带有私有IP地址范围的响应报文将被丢弃
rebind_localhost     rebind-localhost-ok   允许上有域名服务器的127.0.0.0/8响应,这是采用DNS黑名单时所需的服务，这在绑定保护启用时使用
expandhosts          expand-hosts          在/etc/hosts中的名称增加本地域名部分
nonegcache           no-negcache           在通常情况下"no such domain"也会缓存，下次查询是不再转发到上游服务器而直接应答，这个选项将禁用
                                           "no sunh domain"返回的缓冲
authoritative        dhcp-authoritative    我们是局域网的唯一的DHCP服务器，当收到请求后会立即响应，而不会等待，如果拒绝的话会被很快拒绝
readethers           read-ethers           从/etc/ethers文件中读取静态分配的表项。格式为硬件地址和主机名或IP地址，当收到SIGHUP信号时会重新读取
resolvfile           resolv-file           指定一个DNS配置文件来读取上有域名服务器的地址，默认是从/etc/resolv.conf文件读取。

[DHCP地址池配置]
config dhcp lan
  option interface lan    # 
  option start     100    # start用来指定租给客户的最小地址。
  option limit     150    # limit 指定租给客户的最大IP 个数，这里指定limit 为150，表示最多可以租给客户150个IP 地址。 
  option leasetime 12h    # leasetime 表示租期时间。
  
ignore # dnsmasq将忽略从该接口来的请求。

[域名配置]
config domain
  option name 'zhang'
  option ip '192.168.6.10'
config domain
  option name 'bjbook.net'
  option ip '192.168.6.20'
  
[主机设置]
config host      # MAC——IP绑定：指定给一个主机分配一个固定的IP。 
  option ip     '192.168.6.120'
  option mac    '08:00:27:9d:89:e7'
  option name   'buildserver'
  
[DHCP客户端信息] /tmp/dhcp.lease

ipconfig.exe /release # Windows dhcp release
ipconfig.exe /renew   # Windows dhcp renew
# http://wiki.openwrt.org/doc/uci/dhcp 
}

openwrt(智能路由器－ddns：port 3495){
动态域名系统(Dynamic Domain Name System)用来动态更新DNS服务器上域名和主机IP地址之间的对一个关系，
从而保证通过域名解析到正确的主机IP地址。

DDNS客户端 DDNS服务器端
opkg update
opkg install ez-ipupdate
DDNS详细配置
enabled     布尔值  # 是否启动DDNS客户端
interface   接口名  # 设置该DDNS所绑定的接口，DDNS更新的域名所对应的IP为该接口的主IP地址
service     字符串  # 服务类型，支持很多种DDNS更新协议，我们使用gnudip
username    字符串  # 设置DDNS服务器的认证用户名
password    字符串  # 设置DDNS服务器地认证密码
hostname    字符串  # 绑定的域名后缀，一般为服务提供商域名

}

openwrt(智能路由器－nslookup dig ping){
nslookup openwrt.org            # 查询域名
nslookup openwrt.org 8.8.8.8    # 指定服务器
nslookup 8.8.8.8                # 反向解析

dig @server baidu.com            # @server为DNS服务器地址
dig -b 192.168.1.100 baidu.com   # 绑定192.168.1.100
dig @8.8.8.8 baidu.com 
}

openwrt(智能路由器-防火墙|firewall){
  防火墙的核心是防火墙规则，所有的规则在一起就是规则集。
  规则允许或者拒绝某些主机访问另一个网络的主机。‘
  规则：报文过滤、网络地址转换、报文修改。
  
  
  链式处理过滤器：第一个规则如果没有匹配，则继续下一个规则匹配，直到数据报文命中ACCEPT、DROP或REJECT之一。
                  最后一个仍未匹配，默认规则最后生效，具体的规则首先起作用。
                  
1. 路由器的最小防火墙配置通常有一个缺省default部分、至少两个安全域(局域网和广域网)和一个转发
                                                  --允许数据从局域网到广域网。
2. UCI配置来管理防火墙规则，便于用户使用命令或Web接口来管理。
   UCI配置层可以分离路由器控制和转发层
   UCI的API提供了一种对iptables进行配置的简单模型。
   
iptables-save
iptables-restore

Zone:
  1. 安全域是一个相同规则的区域。一个安全域可以包含一个或多个接口，并最终映射到多个物理接口设备。
    Zones是用来描述一个给定接口的默认规则，以及接口之间的转发规则，可实现：网络地址转换、端口转发规则和重定向等等。
    wan-连接互联网  Zones域
    lan-连接局域网  Zones域
  2. 在配置文件（/etc/config/firewall）中，默认规则放在最开始位置，但却是最后起作用。
  3. Zones也可以用来配置伪装，也即是我们所熟知的NAT（网络地址转换），以及端口转发，也就是常说的重定向。 
  4. UCI防火墙配置包括的section：defaults、zone、forwarding、rule、redirect和include。 
  5. Zone不适合配置子网和安装iptables规则来操作物理设备接口。

---------------------------------------
default配置节选项定义     # 声明一些全局的防火墙设置，它不属于任何zone。 
input         字符串    REJECT # 过滤表.INPUT
output        字符串    REJECT # 过滤表.OUTPUT
forward       字符串    REJECT # 过滤表.FORWARD
drop_invalid  布尔值    0      # 抛弃无效的packet(没有匹配任何有效的连接)
syn_flood     布尔值    # 启动SYN洪水攻击保护，默认不启用
disable_ipv6  布尔值    # 关闭IPv6防火墙，默认打开
---------------------------------------
1. 一个zone组织一个或多个接口，以及作为源或目的来为forwarding、rule和redirect服务。
    1.1 对一个zone的INPUT rule描述了尝试到达路由器自己的流量将发生什么； 
  1.2 对一个zone的OUTPUT rule描述了来源于路由器自己要出去的流量将发生什么； 
  1.3 对一个zone 的FORWARD rule描述了从一个zone到另一个zone的流量将发生什么。
zone配置节选项含义
name      字符串   # 定义安全域的名称
network   链表     # 安全域的接口列表
input     字符串   #
forward   字符串   #
output    字符串   #
masq      布尔值   #
mtu_fix   布尔值   # 对于所有的外出流量固定其最大分片大小值
---------------------------------------
forwading配置节     # 用于控制游走于zone之间的流量。
src       安全域名称
dest      安全域名称
family    字符串        ipv4 ipv6
---------------------------------------
redirect配置节选项   # 用于控制DNAT。
src       安全域名称     # 指定流量的源安全域。必须指向已经定义的区域，典型的端口转发通常是wan
src_ip    IP地址         # 匹配从指定源IP地址的报文
src_dip   IP地址         # 对于DNAT来说，匹配指定目的地址的报文；对于SNAT来说重写源地址为指定的地址
src_mac   MAC地址        # 对于流入报文，匹配指定的MAC地址
src_port  端口号         # 匹配指定源端口或范围的流入报文
src_dport 端口号         # 报文的原始目标端口
proto     协议名称或数字 # 匹配指定的协议
dest      安全域名称     # 指出流量的目的安全域，必须是一个定义的安全域的名称，对已DNAT这个必须为lan域
dest_ip   IP地址         # 对于DNAT，将重定向到指定的内部主机，对于SNAT匹配给定地址的流量
dest_port 端口号或范围   # 对于DNAT来说，重定向匹配的报文到内部主机的指定端口。对于SNAT来说，匹配的报文将直接重定向到指定端口
---------------------------------------
rule配置            # 定义基本的的接受或拒绝来允许或限制某个指定的端口或主机。
name        | config rule # MAC地址过滤                  | config redirect    # 端口转发
src         |         option src      'lan'              |         option src      'wan' 
src_ip      |         option dest     'wan'              |         option dest     'lan' 
src_mac     |         option src_mac  '44:8A:5B:EC:49:27'|         option src_dport 8080  
src_port    |         option proto    'all'              |         option proto    'tcp' 
proto       |         option target   'REJECT'           |         option dest_ip  '192.168.10.104'
dest        |                                            |         option dest_port 80 
dest_ip     |                                            | 
target      |                                            | 
weekdays    |                                            | 
---------------------------------------
include配置节     # 包含一个自定义的防火墙脚本，该脚本使用iptables命令定义规则。
path          /etc/firewall.user
enabled
type
family
reload

/lib/firewall 
/sbin/fw <command> <family> <table> <chain> <targe> {<rule>}

# fw 调试FW_TRACE
FW_TRACE=1 fw reload 2>/tmp/iptables.log
FW_TRACE=1 fw reload

# fw3 调试-d
fw3 -d reload 2>/tmp/iptables.log

# 规则生成过程
fw3 -4 print > /tmp/ipv4.rules 
fw3 -6 print > /tmp/ipv6.rules

iptables -L -t raw --line-numbers
iptables -t raw -D OUTPUT 3
}

openwrt(system){
config system
        option hostname 'OpenWrt'  # admin/system/system-配置 和 admin/status/overview-显示 ping 
                                   # /etc/config/dhcp -> option domain 'lan' [ 一起组成了Openwrt.lan服务器域名]
                                   # vi /etc/hosts 
        option ttylogin '0'
        option log_proto 'udp'
        option cronloglevel '8'
        option zonename 'Asia/Shanghai'
        option timezone 'CST-8'
        option conloglevel '7'

config timeserver 'ntp'
        list server '0.openwrt.pool.ntp.org'
        list server '1.openwrt.pool.ntp.org'
        list server '2.openwrt.pool.ntp.org'
        list server '3.openwrt.pool.ntp.org'
        option enabled '1'
        option enable_server '1'
}

openwrt(sysupgrade命令行刷机升级){
Usage: /sbin/sysupgrade [<upgrade-option>...] <image file or URL>
       /sbin/sysupgrade [-q] [-i] <backup-command> <file>
升级选项： 
    -d 重启前等待 delay 秒
    -f 从 .tar.gz (文件或链接) 中恢复配置文件
    -i 交互模式
    -c 保留 /etc 中所有修改过的文件
    -n 重刷固件时不保留配置文件
    -T | --test 校验固件 config .tar.gz，但不真正烧写
    -F | --force 即使固件校验失败也强制烧写
    -q 较少的输出信息
    -v 详细的输出信息
    -h 显示帮助信息
备份选项：
    -b | --create-backup
    把sysupgrade.conf 里描述的文件打包成.tar.gz 作为备份，不做烧写动作
    -r | --restore-backup
    从-b 命令创建的 .tar.gz 文件里恢复配置，不做烧写动作
    -l | --list-backup
    列出 -b 命令将备份的文件列表，但不创建备份文件

sysupgrade openwrt.bin   # 更新openwrt.bin固件
sysupgrade -F openwrt.bin #  强制更新openwrt.bin固件
# sysupgrade会检查支持板子的固件头信息，如果一个model没有在sysupgrade的支持列表里，使用-F来忽略检查失败，强制烧写。 
sysupgrade -n openwrt.bin # 更新后不保存之前的配置
# sysupgrade烧写时默认会备份配置文件，在烧写后把配置文件覆盖到新系统中。-n参数指定不做这个动作。
sysupgrade -v http://192.168.10.47:/openwrt-ramips-mt7621-oolite-v8-32MB-15.05-squashfs-sysupgrade.bin
-v 详细的输出信息; -n 重刷固件时不保留配置文件
# http://www.onlinedown.net/soft/47720.htm https服务器软件
 --------------------------------
dev: size erasesize name
mtd0: 00050000 00010000 "u-boot"
mtd1: 00020000 00010000 "u-boot-env"
mtd2: 00f80000 00010000 "firmware"
mtd3: 00107440 00010000 "kernel"
mtd4: 00e78bc0 00010000 "rootfs"
mtd5: 00810000 00010000 "rootfs_data"
mtd6: 00010000 00010000 "art"
其中，mtd2就是固件分区（firmware）
    sysupgrade -l
    sysupgrade -r sysupgrade.tgz # 恢复路由器配置
    sysupgrade -b sysupgrade.tgz # 仅备份路由器配置:
    
    dd if=/dev/mtd2 of=/tmp/firmware_backup.bin # 备份固件firmware
    mtd -r write /tmp/firmware_backup.bin firmware # 恢复固件firmware
    dd if=/dev/mtd5 of=/tmp/overlay.bin # 备份自定义路由器信息，包括新安装软件:
    mtd -r write /tmp/overlay.bin rootfs_data # 恢复备份设置并重启
    
    rm -rvf /overlay/* && reboot # 删除/overlay分区所有文件，重启即恢复默认设置
    mtd -r erase rootfs_data     # 使用mtd清除/overlay分区信息后重启即恢复默认设置
    
    mtd -r write /tmp/xxx.bin firmware # 使用mtd刷新
    sysupgrade /tmp/xxx.bin            # 使用sysupgrade更新
    
--------------------------------
固件：sysupgrade.bin
sysupgrade -v openwrt-ar71xx-generic-xxxsquashfs-sysupgrade.bin
如果直接从 u-boot 更新固件，会把之前的配置都重置，openwrt 提供了一个更新固件的工具 sysupgrade。

sysupgrade -v http://192.168.0.102/openwrt-ar71xx-generic-xxxsquashfs-sysupgrade.bin
    sysupgrade会从指定的URL地址去下载固件，然后将其烧写到Flash，并且保留所有配置。-v表示输出详细信息。
如果不想保留配置可以添加-n选项。


查看当前系统分区信息：
    cat /proc/mtd
    dev:    size   erasesize  name
    mtd0: 00020000 00020000 "CFE"
    mtd1: 000dff00 00020000 "kernel"
    mtd2: 00ee0000 00020000 "rootfs"
    mtd3: 00840000 00020000 "rootfs_data"
    mtd4: 00020000 00020000 "nvram"
    mtd5: 00fc0000 00020000 "linux"
备份系统CFE：
    dd if=/dev/mtd0 of=/mnt/cfe.bin
备份恢复Openwrt系统配置：
    dd if=/dev/mtd3 of=/mnt/overlay.bin #备份自定义系统信息，包括新安装软件
    mtd -r write /mnt/overlay.bin rootfs_data #恢复备份设置
    sysupgrade -b /mnt/back.tar.gz #仅备份系统配置
    sysupgrade -r /mnt/back.tar.gz #恢复系统配置
恢复Openwrt系统默认设置：
    rm -rf /overlay/* && reboot #删除/overlay分区所有文件，重启即恢复默认设置
    mtd -r erase rootfs_data #使用mtd清除/overlay分区信息后重启即恢复默认设置

刷新系统：
    mtd -r write openwrt.bin linux #使用mtd更新系统
    sysupgrade openwrt.bin #使用sysupgrade更新系统，推荐。
---------------------------------------
# 需要额外备份的文件
在 /etc/sysupgrade.conf 中加入要额外备份的文件
    /usr/lib/ddns/services
    /etc/init.d/ss-redir
    /etc/init.d/ss-local
    /etc/dnsmasq.d/

backup
    sysupgrade --create-backup /tmp/backup-`cat /proc/sys/kernel/hostname`-`date +%F`.tar.gz
    ls /tmp/backup*

restore
    tar xzvf -C / /path/to/your/backup-xxx.tar.gz

}

openwrt(关于最新openwrt CC trunk 更改c库问题 musl-ftd){
应最近不少童鞋提问  说一下修改方法   其实最好的还是自己一点点修改报错问题去兼容musllibc
由于openwrt trunk 默认的C库从uclibc换成musl libc
所以一般情况下好多软件都会报错  特别是mod类的程序
修改方法是
make menuconfig 中的 advanced configuration options (or developers) > Toolchain Options > c library 下面更改
}

x86(){
[musllibc -> glibc]
make menuconfig 中的 advanced configuration options (or developers) > Toolchain Options > c library 下面更改
[ata|sata]
make menuconfig 中的 kernel module -> block drivers
[luci]
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig 中的 kernel module -> LUCI

-------------------------------------------------------------------------------
首先配置Openwrt
Target System (x86)  ---> 
Subtarget (Generic)  ---> 
Target Profile (Generic)  ---> 
Target Images  ---> 
  [*] ext4 (NEW)  ---> 
  [*] Build GRUB images (Linux x86 or x86_64 host only) (NEW) 
  [*] Build VMware image files (VMDK) 
LuCI  ---> 
  1. Collections  ---> 
    <*> luci
保存配置并编译。最终生成了固件：bin/x86/openwrt-x86-generic-combined-ext4.vmdk
}

GPIO(){
在SOC配置文件target/linux/ramips/dts/rt5350.dtsi中配置了GPIO。 
gpio0: gpio@600 { 
  compatible = "ralink,rt5350-gpio", "ralink,rt2880-gpio"; 
  reg = <0x600 0x34>; 
 
  resets = <&rstctrl 13>; 
  reset-names = "pio"; 
 
  interrupt-parent = <&intc>; 
  interrupts = <6>; 
 
  gpio-controller; 
  #gpio-cells = <2>; 
 
  ralink,gpio-base = <0>; 
  ralink,num-gpios = <22>; 
  ralink,register-map = [ 00 04 08 0c 
        20 24 28 2c 
        30 34 ]; 
}; 
 
gpio1: gpio@660 { 
  compatible = "ralink,rt5350-gpio", "ralink,rt2880-gpio"; 
  reg = <0x660 0x24>; 
 
  interrupt-parent = <&intc>; 
  interrupts = <6>; 
 
  gpio-controller; 
  #gpio-cells = <2>; 
 
  ralink,gpio-base = <22>;
  ralink,num-gpios = <6>; 
  ralink,register-map = [ 00 04 08 0c 
        10 14 18 1c 
        20 24 ]; 
 
  status = "disabled"; 
};
总共配置了两组GPIO，第0组GPIO地址偏移为0x600，第1组GPIO地址偏移为0x660。第0组GPIO为gpio0~gpio21，
总共22个，第1组GPIO为gpio22~gpio27，具体参考RT5350芯片手册3.9节  Programmable I/O。
-------------------------------------------------------------------------------

两组GPIO 使能了第0组，禁用了第1组，在开发板上查看相关目录 
root@OpenWrt:/sys/class# cd / 
root@OpenWrt:/# ls sys/class/gpio/ 
export     gpiochip0  root_hub   unexport   usb 
 
目录gpiochip0表示第0组GPIO，里面的base、ngpio分别对应rt5350.dtsi中的ralink,gpio-base、ralink,num-gpios。 
root@OpenWrt:/# ls /sys/class/gpio/gpiochip0/ 
base       device     label      ngpio      subsystem  uevent 
root@OpenWrt:/# cat /sys/class/gpio/gpiochip0/base  
0 
root@OpenWrt:/# cat /sys/class/gpio/gpiochip0/label  
10000600.gpio 
root@OpenWrt:/# cat /sys/class/gpio/gpiochip0/ngpio  
22
-------------------------------------------------------------------------------

}
openwrt(error: ext4_allocate_best_fit_partial: failed to allocate 1 blocks, out of space?){
error: ext4_allocate_best_fit_partial: failed to allocate 13 blocks, out of space?
make[5]: *** [mkfs-ext4] Error 1
解决办法：
make menuconfig
找到菜单项"Target Images","Root filesystem partition size (in MB)"
把值改大即可
出现这种情况通常都是修改编译菜单，加了很多东西后，导致编译出来的镜像比较大，如果运行在raspberry，
cubieboard一些开发板上，改大无所谓
}

openwrt(openwrt Makefile框架分析){
1. openwrt目录结构
    http://www.ccs.neu.edu/home/noubir/Courses/CS6710/S12/material/OpenWrt_Dev_Tutorial.pdf
2. 主Makefile的解析过程，各子目录的目标生成
3. kernel编译过程
4. firmware的生成过程
5. 软件包的编译过程

http://www.liwangmeng.com/openwrt%E5%9F%BA%E6%9C%AC%E7%9F%A5%E8%AF%86%E5%BD%92%E7%BA%B3/#_Toc426631143
}

openwrt(MTK 官方 openwrt SDK 使用){
来源
1、https://github.com/unigent/openwrt-3.10.14 上面有个

问题：SDK 缺少 linux-3.10.14-p112871.tar.xz 在 https://github.com/mqmaker/linux/releases 下载，注意要下载那个没打补丁的文件 3.10.14-p112871.tar.gz ，下载后需转换为 tar.xz 文件，并放入 dl 目录。否则需要修改 include/kernel.mk 里的 LINUX_SOURCE 为 gz，并修改 include/kernel-defaults.mk 中的内核解压方式。
注意：网上有些错误的 linux-3.10.14-p112871.tar.xz 下载，这个文件是在 windows 上重新压缩的，因为文件系统不分大小写，最终会导致下面的的文件丢失：
include/uapi/linux/netfilter_ipv6、netfilter_ipv4、netfilter 目录下的 xt_MARK.h 和 xt_mark.h 等
MTK SDK 不使用 OpenWRT 官方的 dts 定义 ROM 布局，网卡布局。
网卡：修改内核 config 的（比如 target/linux/ramips/mt7620/config-3.10 ）CONFIG_WAN_AT_P4=y 或者 CONFIG_WAN_AT_P0=y
ROM 布局：修改内核的 spi 驱动文件
内核启用 ipt-nathelper-extra、ipt-filter (注意：15.05 netfiler 模块前缀从 ipt 变为 nf 了) 时候会依赖 textsearch 模块，但这个模块的3个子模块默认并没有编译，需要修改内核 package/kernel/linux/modules/lib.mk 中标红部分：
define KernelPackage/lib-textsearch
SUBMENU:=$(LIB_MENU)
TITLE:=Textsearch support
KCONFIG:= \
CONFIG_TEXTSEARCH=y \
CONFIG_TEXTSEARCH_KMP=m \
CONFIG_TEXTSEARCH_BM=m \
CONFIG_TEXTSEARCH_FSM=m
FILES:= \
$(LINUX_DIR)/lib/ts_kmp.ko \
$(LINUX_DIR)/lib/ts_bm.ko \
$(LINUX_DIR)/lib/ts_fsm.ko
AUTOLOAD:=$(call AutoProbe,ts_kmp ts_bm ts_fsm)
endef
或者修改内核 config 文件（比如 target/linux/ramips/mt7620/config-3.10 ）的
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
2、mqmaker 上传了为它自己 mt7621 开发板适配过的 SDK
教程见：https://mqmaker.com/doc/make-your-own-image/

}

openwrt(OpenWRT下Dnsmasq本地域名泛解析和禁止DNS劫持)
{
操作系统下都有hosts文件可自定单个域名指向IP，要将特定域名下所有子域名都指向特定IP就需要转发DNS服务器来解决了，Dnsmasq就是比较轻量级的一个，很多第三方路由固件都自带Dnsmasq。
Dnsmasq域名泛解析配置：

address=/.www.haiyun.me/8.8.8.8
address=/.google.com/203.208.46.200
#这样所有www.haiyun.me子域名都解析到8.8.8.8

Dnsmasq禁止域名被劫持：

bogus-nxdomain=8.8.8.8
#8.8.8.8为劫持IP地址
}

openwrt(ipset for dnsmasq){
http://blog.sxx1314.com/openwrt/186.html
https://github.com/aa65535/openwrt-dnsmasq

ipset rule for dnsmasq
http://blog.sxx1314.com/openwrt/184.html
}

openwrt(openwrt修改默认中文){
/home/sxx/openwrt/build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/luci/modules/base/dist/etc/config/luci

config core main
option lang zh_cn
option mediaurlbase /luci-static/openwrt.org
option resourcebase /luci-static/resources

config extern flash_keep
option uci "/etc/config/"
option dropbear "/etc/dropbear/"
option openvpn "/etc/openvpn/"
option passwd "/etc/passwd"
option opkg "/etc/opkg.conf"
option firewall "/etc/firewall.user"
option uploads "/lib/uci/upload/"

config internal languages
option zh_cn 'chinese'
option en 'English'

config internal sauth
option sessionpath "/tmp/luci-sessions"
option sessiontime 3600

config internal ccache
option enable 1

config internal themes

}

openwrt(openwrt luci界面修改){
src/gz pandora http://www.qzxx.com/pogoplug   小熊源  做个标记
/usr/lib/lua/luci/view/admin_status/index.htm
}

openwrt(openwrt UBIFS文件系统){
    OpenWrt使用的文件系统主要是squashfs和jffs2，以及"连接"他们的mini_fo。
    squashfs是一种只读的压缩文件系统，它的压缩率基本和gzip差不多。另外，也有使用LZMA作为压缩程序的
squashfs项目，压缩率会更大一点。
    jffs2是一种日志类型的文件系统，专为NorFlash设计。日志的意思是，新的写入信息总是现在现有内容的后面。
这样带来两个显而易见的好处，一是做到了负载平衡（在整片Flash上循环的写入和擦除），二是做到了掉电保持
（写入新的数据不需要擦除原来数据，而只是维护一个表来保持系统可以找到新写入的数据）。
    mini_fo是一个很有意思的特殊文件系统，它由ELDK开发，也就是U-boot的开发小组。mini_fo的有意思之处
就是使squashfs文件系统可写!其实，就是将修改后的文件保存在jffs2的分区上，维护一个表使系统可以找到
最新的修改。
    OpenWrt这样做的目的就是，得到一个体积很小的文件系统（需要压缩），然后它必须可写。
}
openwrt(vrrp keepalived){
# Openwrt 下实现主备路由自动切换 – keepalived

目前，一个项目中用到了H3C的设备，组网中使用了VRRP功能，实现主备路由的自动切换。经过查阅资料，
发现openwrt中也支持类似的功能 — keepalived。

1. keepalived是什么
keepalived是集群管理中保证集群高可用的一个服务软件，其功能类似于heartbeat，用来防止单点故障。

2. keepalived工作原理
    keepalived是以VRRP协议为实现基础的，VRRP全称Virtual Router Redundancy Protocol，即虚拟路由冗余协议。
    虚拟路由冗余协议，可以认为是实现路由器高可用的协议，即将N台提供相同功能的路由器组成一个路由器组，
这个组里面有一个master和多个backup，master上面有一个对外提供服务的vip（该路由器所在局域网内其他
机器的默认路由为该vip），master会发组播，当backup收不到vrrp包时就认为master宕掉了，这时就需要根据
VRRP的优先级来选举一个backup当master。这样的话就可以保证路由器的高可用了。
    keepalived主要有三个模块，分别是core、check和vrrp。core模块为keepalived的核心，负责主进程的启动、
维护以及全局配置文件的加载和解析。check负责健康检查，包括常见的各种检查方式。vrrp模块是来实现VRRP协议的。

3. keepalived的配置文件
https://wiki.openwrt.org/doc/recipes/high-availability

参考链接： 
1）https://my.oschina.net/qiangzigege/blog/506647 
2）https://my.oschina.net/wrs/blog/833355
}

openwrt(目录)
{
/etc目录
配置目录，在这里可以修改http和luci的配置等；

/tmp目录
luci程序的缓存就放在这个目录下，修改luci代码后，如果没有做特别配置，那么需要每次手动清除这个缓存后， 才可以看到变化；

/usr/lib/lua/luci
开发目录，我们的lua代码基本都是放在这个目录下，里面有controller、view等目录；

/usr/lib/lua/luci/controller
这个目录中的文件的作用是注册entry，并给entry绑定行为，这里的entry就相当于任何后台web语言配置的router。

/usr/lib/lua/luci/view
htm文件都放在这里，如果没有使用angular，那么所有页面都放在这个目录下；


相对于基本目录外，在/usr/lib/lua目录下，小米对自己的util和service进行了封装， 放在了xiaoqiang和sysapi等目录下，这些文件供entry的行为使用；

}

openwrt(test){
# A set of scripts for maintaining and testing OpenWrt
https://github.com/richb-hanover/OpenWrtScripts
# Automatisiertes testen von OpenWRT Firmware auf Freifunk-Routern
https://github.com/PumucklOnTheAir/TestFramework
# automate testing of OpenWrt routers and other devices.
https://github.com/qca/boardfarm

# dhcp
https://github.com/nean-and-i/dhcping
https://github.com/ragnarlonn/dhcptool
https://github.com/ragnarlonn/dhcptool

# gre
https://github.com/amarao/gre-tun-probe
https://github.com/hk220/greether-script
https://github.com/ankursam/GRE-Tunnel
}

make(软件包编译总体){
 make[1] world
 make[2] target/compile
 make[3] -C target/linux compile
 make[2] package/cleanup
 make[2] package/compile
 make[3] -C package/libs/toolchain compile
 make[3] -C package/libs/libnl-tiny compile
 make[3] -C package/libs/libjson-c compile
 make[3] -C package/utils/lua compile
 make[3] -C package/libs/libubox compile
 make[3] -C package/system/ubus compile
 make[3] -C package/system/uci compile
 make[3] -C package/network/config/netifd compile
 make[3] -C package/system/opkg host-compile
 make[3] -C package/system/ubox compile
 make[3] -C package/libs/lzo compile
 make[3] -C package/libs/zlib compile
 make[3] -C package/libs/ncurses host-compile
 make[3] -C package/libs/ncurses compile
 make[3] -C package/utils/util-linux compile
 make[3] -C package/utils/ubi-utils compile
 make[3] -C package/system/procd compile
 make[3] -C package/system/usign host-compile
 make[3] -C package/utils/jsonfilter compile
 make[3] -C package/system/usign compile
 make[3] -C package/base-files compile
 make[3] -C feeds/luci/modules/luci-base host-compile
 make[3] -C package/firmware/linux-firmware compile
 make[3] -C package/kernel/linux compile
 make[3] -C package/network/utils/iptables compile
 make[3] -C package/network/config/firewall compile
 make[3] -C package/utils/lua host-compile
 make[3] -C feeds/luci/applications/luci-app-firewall compile
 make[3] -C feeds/luci/libs/luci-lib-ip compile
 make[3] -C feeds/luci/libs/luci-lib-nixio compile
 make[3] -C package/network/utils/iwinfo compile
 make[3] -C package/system/rpcd compile
 make[3] -C feeds/luci/modules/luci-base compile
 make[3] -C feeds/luci/modules/luci-mod-admin-full compile
 make[3] -C feeds/luci/protocols/luci-proto-ipv6 compile
 make[3] -C feeds/luci/protocols/luci-proto-ppp compile
 make[3] -C feeds/luci/themes/luci-theme-bootstrap compile
 make[3] -C package/kernel/gpio-button-hotplug compile
 make[3] -C package/firmware/ath10k-firmware compile
 make[3] -C package/firmware/b43legacy-firmware compile
 make[3] -C package/libs/ocf-crypto-headers compile
 make[3] -C package/libs/openssl compile
 make[3] -C package/network/services/hostapd compile
 make[3] -C package/network/utils/iw compile
 make[3] -C package/kernel/mac80211 compile
 make[3] -C package/kernel/mt76 compile
 make[3] -C package/network/config/swconfig compile
 make[3] -C package/network/ipv6/odhcp6c compile
 make[3] -C package/network/services/dnsmasq compile
 make[3] -C package/network/services/dropbear compile
 make[3] -C package/network/services/odhcpd compile
 make[3] -C package/libs/libpcap compile
 make[3] -C package/network/utils/linux-atm compile
 make[3] -C package/network/utils/resolveip compile
 make[3] -C package/network/services/ppp compile
 make[3] -C package/libs/polarssl compile
 make[3] -C package/libs/ustream-ssl compile
 make[3] -C package/network/services/uhttpd compile
 make[3] -C package/system/fstools compile
 make[3] -C package/system/mtd compile
 make[3] -C package/system/opkg compile
 make[3] -C package/utils/busybox compile
 make[2] package/install
 make[3] package/preconfig
 make[2] target/install
 make[3] -C target/linux install
}

# Makefile语法可参考官网：http://wiki.openwrt.org/doc/devel/packages
base(新添应用程序生成方式1){

# 下面用<BUILDROOT> 表示 Openwrt 源码树顶层目录。Openwrt 所有的软件包都都保存在<BUILDROOT>/package 目录下，
# 一个软件包占一个子目录。一个典型的 Openwrt 用户空间软件包，例如 helloworld，如下所示
<BUILDROOT>/package/helloworld/Makefile
<BUILDROOT>/package/helloworld/files/
<BUILDROOT>/package/helloworld/patches/
# 其中 files 目录是可选的，一般存放配置文件和启动脚本。patches 目录也是可选的，一般存放 bug 修复或者程序
# 优化的补丁。

# 其中 Makefile 是必须的也是最重要的，它具有和我们所熟悉的 GNU Makefile 完全不同的语法，它定义了如何构建
# 一个Openwrt 软件包，包括从哪里下载源码，怎样编译和安装。
---------------------------------------
首先需要包含几个文件进来，它们定义了一些变量、规则、函数
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel.mk   # 定义内核模块时才需要
include $(INCLUDE_DIR)/cmake.mk    # 使用 cmake 构建软件时才需要
一个典型的 Openwrt 软件包目录下没有源码目录，构建 Openwrt 软件包的第一步是从指定的 URL 下载指定的源码包，
这个 URL 在 Makefile 中定义，如下所示：
PKG_SOURCE:=helloworld.tar.gz                # 下载的 helloworld.tar.gz 一般存放在<BUILDROOT>/dl/目录，
                                             # 然后解压到<BUILDROOT>/build_dir/target-xxx/$(PKG_BUILD_DIR)
PKG_SOURCE_URL:=http://www.example.com/      # 是从 http://www.example.com/helloworld.tar.gz 下载源码包
PKG_MD5SUM:=e06c222e186f7cc013fd272d023710cb # PKG_MD5SUM 用于验证下载的软件包的完整性。
                                             # md5sum helloworld.tar.gz 生成md5码
                                             
<BUILDROOT>/dl/                                   # 下载存放路径
<BUILDROOT>/build_dir/target-xxx/$(PKG_BUILD_DIR) # 编译存放路径
}


base(kmod){
https://blog.huzhifeng.com/2015/02/03/OpenWrt-Add-New-kmod-package/
}

base(新添应用程序生成方式1){
另一种构建 Openwrt 软件包的方式是从自己写的代码构建，这种方式需要在<BUILDROOT>/package/helloworld/目录下创
建一个子目录 src，用来保存自己写的源码文件，如下所示：
<BUILDROOT>/helloworld/Makefile
<BUILDROOT>/package/helloworld/files/
<BUILDROOT>/helloworld/patches/
<BUILDROOT>/helloworld/src/
<BUILDROOT>/helloworld/src/helloworld.c
<BUILDROOT>/helloworld/src/Makefile
很显然，这种方式没有任何源码包需要从 Web 下载，这里的<BUILDROOT>/helloworld/src/Makefile 和通常的 GNU Makefile
语法一样。
---------------------------------------
OpenWRT BuildPackage Makefile（例如上面的<BUILDROOT>/helloworld/Makefile）定义了一些用于指示OpenWRT Buildroot
或者SDK编译软件包的变量。 
staging_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips/ # 嵌入式根文件系统

PKG_*定义了和软件包相关的一些信息，如下所示： 
  PKG_NAME           # 软件包的名称 
  PKG_VERSION        # 下载的或者自己写的软件包的版本（必须） 
  PKG_RELEASE        # 当前的编译版本，可能根据不同需求，编译方式不同。 
  PKG_BUILD_DIR      # 在哪个目录下编译该软件包，默认为$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION) 
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_NAME)-$(PKG_VERSION)
    # 在哪个目录下编译该软件包，默认为$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION) 
    # BUILD_DIR=/build_dir/target-mipsel_1004kc+dsp_uClibc-0.9.33.2  -> 通常为"build_dir/target-*"
    # PKG_NAME=dnsmasq
    # BUILD_VARIANT=nodhcpv6
    # PKG_VERSION=2.73  
  PKG_SOURCE         # 要从网上下载的的源码包的文件名 
  PKG_SOURCE_URL     # 从哪里下载源码包 
  PKG_MD5SUM         # 用于验证下载的源码包的完整性 
  PKG_CAT            # 怎样解压源码包  (zcat,  bzcat,  unzip) 
  PKG_BUILD_DEPENDS  # 定义需要在该软件包之前编译的软件包或者一些版本的依赖。和下面的
DEPENDS语法相同。
---------------------------------------
Package/xxx描述软件包在menuconfig和ipkg 中的条目（其中的xxx即出现在menuconfig中的标签以及.config中的 
CONFIG_PACKAGE_xxx=y） # 用于设置menuconfig的选项
  SECTION    -  # base boot devel net sys firmware kernel lang utils libs 
  CATEGORY -  该软件包出现在menuconfig中的哪个菜单下，如果是第一次使用，则menuconfig中会新创建一个菜单 
                  # Base system; Boot Loaders; Development; Firmware;Kernel;Kernel modules;Languages;Libraries;Network;Utilities
  SUBMENU - menuconfig中软件包所属的二级目录，如dial-in/up
                  # Filesystem SSL Libraries
    TITLE    -  对该软件包的一个简短描述 
    DESCRIPTION - 软件包的详细说明(废弃) Package/description
  URL     -  在哪里可以找到该软件包的源码包 
    USERID  -  用户ID
  MAINTAINER  -定义该软件包的维护者的联系方式 
  DEPENDS    -  定义需要在该软件包之前编译/安装的软件包，或者其他一些依赖条件，比如版本依赖等，多个依赖之间使用空格分隔，下面列出其具体语法： 
1. DEPENDS:=+foo 当前软件包和foo都会出现在menuconfig中，当前软件包被选中时，其依赖的软件
包foo 也被自动选中；如果依赖额软件包foo 先前没有选中而当前软件包取消选中时，其依赖分软
件包foo也会被取消选中。 
2. DEPENDS:=foo 只有当其依赖的软件包foo被选中时，当前软件包才会出现在menuconfig中。 
3. DEPENDS:=@FOO 软件包依赖符号CONFIG_FOO，只有当符号CONFIG_FOO被设置时，该软件包才会
出现在menuconfig中。通常用于依赖于某个特定的Linux版本或目标（比如CONFIG_LINUX_3_10、
CONFIG_TARGET_ramips）。 
4. DEPENDS:=+@FOO 软件包依赖符号CONFIG_FOO，当该软件包选中后，CONFIG_FOO也被选中。 
5. DEPENDS:=+FOO:bar  当前软件包和软件包bar都会出现在menuconfig中。如果符号CONFIG_FOO被
设置，则当前软件包依赖于软件包bar，否则不依赖 
6. DEPENDS:=@FOO:bar  如果符号CONFIG_FOO被设置，则当前软件包依赖于软件包bar，否则不依赖，
并且只有其依赖包bar被选中时，当前软件包才会出现在menuconfig中。

DEPENDS:=+libncurses +libevent2 +libpthread +librt
DEPENDS:=@IPV6
DEPENDS:=+PACKAGE_dnsmasq_full_dnssec:libnettle \
	+PACKAGE_dnsmasq_full_ipset:kmod-ipt-ipset \
	+PACKAGE_dnsmasq_full_conntrack:libnetfilter-conntrack
    
---------------------------------------
KernelPackage/xxx 描述内核模块在menuconfig和ipk 中的条目（在menuconfig中看到的标签为kmod-xxx） 
  SUBMENU –  该模块出现在menuconfig中的Kernel modules菜单下的哪个子菜单 
  TITLE –  对该模块的一个简短描述 
  FILES –  模块名称（全路径），多个模块文件之间用空格分开，例如： 
FILES:= \ 
  $(PKG_BUILD_DIR)/Embedded/src/1588/timesync.ko \ 
    $(PKG_BUILD_DIR)/Embedded/src/CAN/can.ko 
  AUTOLOAD –  自动加载，例如：AUTOLOAD:=$(call AutoLoad,40,timesync can)表示自动加载timesync.ko
和can.ko，其加载的优先级为40 

#   从单个源代码构建多个软件包。OpenWrt工作在一个Makefile对应一个源代码的假设之上，但是你可以把编译
# 生成的程序分割成任意多个软件包。因为编译只要一次，所以使用全局的"Build"定义是最合适的。然后你可以
# 增加很多"Package/"定义，为各软件包分别指定安装方法。建议你去看看dropbear包，这是一个很好的示范。
Package/install  # 安装时
Package/preinst  # 安装前  # 软件安装之前被执行的脚本，别忘了在第一句加上#!/bin/sh。如果脚本执行完毕要取消安装过程，直接让它返回false即可。
Package/postinst # 安装后  # 软件安装之后被执行的脚本，别忘了在第一句加上#!/bin/sh。
Package/prerm    # 卸载前  # 软件删除之前被执行的脚本，别忘了在第一句加上#!/bin/sh。如果脚本执行完毕要取消删除过程，直接让它返回false即可。
Package/postrm   # 卸载后  # 软件删除之后被执行的脚本，别忘了在第一句加上#!/bin/sh。
cd package && find -name Makefile | xargs grep Package | grep Prepare

Build/Prepare (optional)        # 一组解包源代码和打补丁的命令，一般不需要。
    对于从自己写的代码构建软件包，一般按如下方式定义： 
    define Build/Prepare 
    mkdir -p $(PKG_BUILD_DIR) 
    $(CP) ./src/* $(PKG_BUILD_DIR)/ 
    endef
Build/Configure (optional)      # 如果源代码编译前需要configure且指定一些参数，就把这些参数放在这儿。否则可以不定义。
                                # 可参考package/libs/openssl/Makefile
Build/Compile (optional)        # 编译源代码命令。
                                # package/libs/openssl/Makefile
define Build/Compile            # Linux 内核模块
  $(MAKE) -C "$(LINUX_DIR)" \ 
    ARCH="$(LINUX_KARCH)" \ 
    CROSS_COMPILE="$(TARGET_CROSS)" \ 
    SUBDIRS="$(PKG_BUILD_DIR)" \ 
    EXTRA_CFLAGS="$(EXTRA_CFLAGS)" \ 
    $(EXTRA_KCONFIG) \ 
    modules 
endef
                                
Build/Install (optional)        # 软件安装命令，主要是把相关文件拷贝到指定目录，如配置文件。
    define Package/ helloworld /install 
    $(INSTALL_DIR) $(1)/bin 
    $(INSTALL_BIN) $(PKG_BUILD_DIR)/helloworld $(1)/bin/ 
    endef 
    这里的$(1)表示嵌入式根文件系统rootfs 的根目录，比如staging_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips/

Build/InstallDev (optional)
Build/Clean (optional)
cd package && find -name Makefile | xargs grep Build | grep Prepare

Package/conffiles (optional)    # 软件包需要复制的配置文件列表，一个文件占一行
Package/description
find -name Makefile | xargs grep Package | grep conffiles

PKG_FIXUP:=autoreconf 
PKG_FIXUP:=patch-libtool 
PKG_FIXUP:=gettext-version
}

base(OpenWrt交叉编译hello){
1. 将toolchain加到PATH里面
OpenWrt的交叉编译工具位于staging_dir下toolchain-xxx目录下，如：
staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/
#export STAGING_DIR=/home/huzhifeng/git/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2
#export PATH=$PATH:/home/huzhifeng/git/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin

2. 找到编译用的gcc程序
find staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/ -name *-gcc
staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-uclibc-gcc
staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-gcc
staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/initial/bin/mips-openwrt-linux-uclibc-gcc
这里，其实mips-openwrt-linux-gcc只是mips-openwrt-linux-uclibc-gcc的一个软链接

3. 编译hello.c
mips-openwrt-linux-uclibc-gcc hello.c -o hello

4. 查看编译后的程序
file hello
hello: ELF 32-bit MSB executable, MIPS, MIPS32 rel2 version 1, dynamically linked (uses shared libs), 
with unknown capability 0x41000000 = 0xf676e75, with unknown capability 0x10000 = 0x70403, not stripped

5. 下载到板子里测试
./hello
Hello, OpenWrt!
argv[0]=./hello

注： # https://blog.huzhifeng.com/2014/12/19/OpenWrt%E4%BA%A4%E5%8F%89%E7%BC%96%E8%AF%91hello/
}
Makefile(环境变量){
OpenWRT BuildPackage Makefile（例如上面的<BUILDROOT>/helloworld/Makefile）定义了一些用于指示OpenWRT Buildroot
或者 SDK 编译软件包的变量。

1. tools - 编译时需要一些工具， tools里包含了获取和编译这些工具的命令。里面是一些Makefile，有的可能还有
patch。每个Makefile里都有一句 $(eval $(call HostBuild))，表示编译这个工具是为了在主机上使用的。

2. openwrt根目录下的Makefile是执行make命令时的入口。从这里开始分析。
world:
ifndef ($(OPENWRT_BUILD),1)
  # 第一个逻辑
   ...
else
  # 第二个逻辑
   ...
endif
上面这段是主Makefile的结构，可以得知：
    执行make时，若无任何目标指定，则默认目标是world
    执行make时，无参数指定，则会进入第一个逻辑。如果执行命令make OPENWRT_BUILD=1，则直接进入第二个逻辑。
编译时一般直接使用make V=s -j5这样的命令，不会指定OPENWRT_BUILD变量

3. 第一个逻辑
  override OPENWRT_BUILD=1
  export OPENWRT_BUILD
更改了OPENWRT_BUILD变量的值。这里起到的作用是下次执行make时，会进入到第二逻辑中。
toplevel.mk中的 %:: 解释world目标的规则。
执行 make V=s 时，上面这段规则简化为：

prereq:: prepare-tmpinfo .config
    @make -r -s tmp/.prereq-build
    @make V=ss -r -s prereq

%::
    @make V=s -r -s prereq
    @make -w -r world

可见其中最终又执行了prereq和world目标，这两个目标都会进入到第二逻辑中。

4. 第二逻辑
首先就引入了target, package, tools, toolchain这四个关键目录里的Makefile文件
  include target/Makefile
  include package/Makefile
  include tools/Makefile
  include toolchain/Makefile
这些子目录里的Makefile使用include/subdir.mk里定义的两个函数来动态生成规则，这两个函数是subdir和stampfile

KERNEL_BUILD_DIR  # build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/linux-3.14.18
LINUX_DIR         # build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a/linux-3.14.18
KDIR　　　　　    # build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/linux-ramips_mt7620a
BIN_DIR           # bin/ramips
                  # Makefile中包含了rules.mk, target.mk等.mk文件，这些文件中定义了许多变量，有些是路径相关的，
                  # 有些是软件相关的。这些变量在整个Makefile工程中经常被用到，
TARGET_ROOTFS_DIR # build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2
BUILD_DIR         # build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2
STAGING_DIR_HOST  # staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2
TARGET_DIR        # build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/root-ramips

---------------------------------------
1. tools – automake, autoconf, sed, cmake
2. toolchain/binutils – as, ld, …
3. toolchain/gcc – gcc, g++, cpp, …
4. target/linux – kernel modules
5. package – core and feed packages
6. target/linux – kernel image
7. target/linux/image – firmware image file generation
}

libpthread(){
make menuconfig 中Bases中选择libpthread-db和pthread
emctrl : Makefile 中 DEPENDS;=+libpthread
emctrl/src/Makefile 中 -pthread 

}

devel(openwrt增加串口登录需要密码){
https://wiki.openwrt.org/doc/howto/serial.console.password
Openwrt 串口默认是没有密码的。Openwrt启动后，一个默认的密码将被启用去保护ssh登录和页面（http）登录，而串口登录密码却是空缺的。
将串口登录加入密码方法如下：
步骤一：配置busybox的登录，可以在.config文件中添加如下
CONFIG_BUSYBOX_CONFIG_LOGIN=y
添加后，需要重新编译busybox。
步骤二：修改/etc/inittab文件
将::askconsole:/bin/ash --login 用
::askconsole:/bin/login 替换。
}
devel(多用户包){
src-git luci https://github.com/Hostle/openwrt-luci-multi-user.git
}
devel(实现ubuntu免密码登入openwrt){
listome-bao@listomebao-computer:~$ ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (/home/listome-bao/.ssh/id_rsa):
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again:
    Your identification has been saved in /home/listome-bao/.ssh/id_rsa.
    Your public key has been saved in /home/listome-bao/.ssh/id_rsa.pub.
    The key fingerprint is:
    生成了id_rsa.pub 将其传到openwrt 的 /etc/dropbear/ 下改成authorized_keys  
        即可
之前如果建立 ssh 连接，只要將公钥复制到 ~/.ssh/authorized_keys 就可以利用公钥登入，而不需要建立密码。

现在的 ssh 使用同样的方法会出現错误信息：
Agent admitted failure to sign using the key

解決方法：

使用 ssh-add 指令將私钥加进来（根据个人的密匙命名不同更改 id_rsa）
# ssh-add   ~/.ssh/id_rsa
}
devel(编译一个可以运行在openwrt上的c程序){
export STAGING_DIR=/path/to/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin export PATH=$STAGING_DIR/:$PATH
编译hello.c
mips-openwrt-linux-gcc hello.c -o hello -static

shmiluyu@:~/openwrt/src$ qemu-mips hello
    hello openwrt 
如果要编译MIPS64架构,只需要编译的时候加个参数
 mips-openwrt-linux-gcc hello.c -o hello-mips64 -static -mips64r2 
使用file命令可以看下可执行文件的信息
 shmiluyu@:~/openwrt/src$ file hello
    hello: ELF 32-bit MSB  executable, MIPS, MIPS32 rel2 version 1, statically linked, not stripped 
使用SCP上传到路由器,运行即可.
}
devel(如何定义luci的页面而不需要认证){
方法一：直接定义不经过admin这个顶层，如：
    --文件位置：/luci/controller/myapp/
    module("luci.controller.myapp.mymodule", package.seeall)

    function index()
        entry({"listome", "up"}, call("action_tryme"), "Click here", 10).dependent=false
        end

         function action_tryme()
         local h=require "luci.http"
         local username=h.formvalue("username")
             luci.http.prepare_content("text/plain")
                 luci.http.write("Haha, nihao ...")
                 h.write("my name is "..username)
                     --luci.sys.reboot()
                     end


方法二：手动设置无需认证
    x = entry({"admin","system","test"}, template("myApp/overview"), "Some Page", 65)
    x.dependant = false
    x.sysauth = false
    x.sysauth_authenticator = "htmlauth"
}

openwrt(OPENWRT 镜像生成器ImageBuilder使用方法及说明){
k1. make info


1. 用ImageBuilder编译，用于灵活选择package。毕竟压缩的只读文件系统squashfs比可写的JFFS能省不少地方，可以用来把玩更多的package。
2. 用SDK编译，用于编译package仓库中没有的软件包，另外其中有配套的内核源码及头文件，编译缺失的内核模块也很方便。
3. 从源码编译，因为要重新编译cross-compile toolchians，下载最内核和软件包的源码编译，导致这个过程比较耗时，用于上述两种情况搞不定的情况。

1. 官网下载ImageBuilder包，比如OpenWrt-ImageBuilder-brcm47xx-for-Linux-i686.tar.bz2，解压。
2. 列出当前系统所有已安装包，用于准备后续make image的 packages参数。 
     echo  $(opkg list-installed | awk '{ print $1}')
3. 检查输出结果看这些包是否自己所需，也可以在此新加入package, 务必注意package依赖，将依赖的package都加上。
4. 在根目录直接make image PACKAGES即可，参数填写参考如下格式。 
        make image PROFILE="<profilename>" # override the default target profile 
        make image PACKAGES="<pkg1> [<pkg2> [<pkg3> ...]]" # 将步骤2生成的package列表填入该参数。 
        make image FILES="<path>" # include extra files from <path>  指定个人的配置文件目录，用来固化缺省配置，比如网络配置参数。 
        make image BIN_DIR="<path>" # alternative output directory for the images
5. 在bin/target目录中生成一个trx和多个bin格式的image文件。
6. 将trx文件copy到目标设备，最好copy到使用RAM文件系统的tmp目录。
scp bin/brcm47xx/openwrt-brcm47xx-squashfs.trx root@192.168.1.1:/tmp/
7. 在刷新系统之前，最好将/overlay 目录打包压缩，用于后续恢复配置，按照openwrt的设计，只有修改过的文件才会放到/overlay目录，具体原理参考union文件系统。
8. 刷新固件到linux分区，具体分区情况和bootrom有关，bcm的芯片参考 cat /proc/mtd 。
mtd -r write /tmp/openwrt-brcm47xx-squashfs.trx linux
9. 自动重启后，除非通过FILES修改过配置文件，否则ip 地址为192.168.1.1 ，telnet直接登陆后用passwd修改密码，然后用ssh安全登陆。
10. 按照自身需求从步骤7保存的文件中copy 相关文件，恢复配置。
}

devel(uhttp 源码修改和调试集锦, 自测成功){
http://blog.chinaunix.net/uid-27194309-id-3437939.html
http://blog.chinaunix.net/uid-27194309-id-3437791.html
}
devel(luasocket之udp, 在openwrt下自测成功){
http://blog.chinaunix.net/uid-27194309-id-3499261.html
}
devel(公网控制全攻略, 网络高手是这样炼成的){
http://blog.chinaunix.net/uid-27194309-id-3773990.html
}


http://blog.chinaunix.net/uid-27194309-id-3407425.html # 回头看看

devel(继续学习){
http://blog.chinaunix.net/uid-28396016-id-3590867.html coovachilli无线认证

http://code.commotionwireless.net/projects/commotion/wiki/Virtual-Box 制作vdi

http://www.voidcn.com/cata/251660 一个关于openwrt的 BLOG

http://www.voidcn.com/article/p-wgbjqiix-kq.html 如何将openwrt移植到intel Galileo

http://wiki.openwrt.org/doc/techref/procd procd进程管理

http://wiki.openwrt.org/inbox/procd-init-scripts procd脚本编写 （结尾还有示例)

http://wiki.openwrt.org/doc/techref/hotplug 热插介绍

https://forum.openwrt.org/viewtopic.php?id=49599 openwrt-systemd

https://github.com/aport/openwrt-systemd openwrt-systemd github

https://forum.openwrt.org/viewtopic.php?id=44363 New qos-scripts package (drop in replacement)

http://downloads.openwrt.org/docs/eclipse.pdf eclipse下调试openWRT的应用程序，在此目录下还有其他文档

http://wiki.openwrt.org/doc/start 官方文档首页

http://downloads.openwrt.org/kamikaze/docs/openwrt.html 官方文档

http://wiki.openwrt.org/doc/devel/gdb 调试

http://wiki.openwrt.org/doc/devel/add.new.device 添加新设备

http://wiki.openwrt.org/doc/devel/add.new.platform 添加新平台

http://wiki.openwrt.org/doc/howto/build 官方buildroot文档


http://www.voidcn.com/article/p-qscvtkqj-ze.html 通过openpctv简单学习opkg安装与生成包的一些过程

http://wiki.openwrt.org/doc/devel/crosscompile 交叉编译

http://wiki.openwrt.org/doc/techref/opkg 包管理器 

http://wiki.openwrt.org/zh-cn/doc/recipes/3gdongle 3G配置

http://www.51nb.com/forum/viewthread.php?tid=1034040&pid=15625649&page=1&extra=page%3D1 3G合并带宽

http://www.voidcn.com/article/p-aqutmfde-vw.html [置顶] [OpenWrt] openwrt的一些琐事

http://www.voidcn.com/article/p-pwkligpl-bkk.html  编译OpenWrt - 索引

http://blog.163.com/gl_jiang@126/blog/static/761009722013210918644/ 创建包

http://blog.csdn.net/openme_openwrt/article/category/1123712 openwrt CSDN文章


http://www.voidcn.com/article/p-wxgurzgq-bkk.html 介绍 OpenWrt中的FEATURES:=broken jffs2


Wiki导航：http://wiki.openwrt.org/doc/start
编译OpenWRT
0早期的openwrt编译文档：http://downloads.openwrt.org/docs/buildroot-documentation.html#about
1工具链：http://wiki.openwrt.org/about/toolchain
2编译准备：http://wiki.openwrt.org/doc/howto/buildroot.exigence
3编译：http://wiki.openwrt.org/doc/howto/build
4添加feeds：http://wiki.openwrt.org/doc/devel/feeds
5Image Builder：http://wiki.openwrt.org/doc/howto/obtain.firmware.generate
6 SDK：http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
7 Rootfs on External Storage (extroot)：
    http://wiki.openwrt.org/doc/howtobuild/extroot.howtobuild
    http://wiki.openwrt.org/doc/howto/extroot
8 wireless router which is connected to either a wired, a wireless or a 3G wireless connection：

    http://wiki.openwrt.org/doc/howtobuild/wireless-router-with-a-3g-dongle

9 How to Build a Single Package
    http://wiki.openwrt.org/doc/howtobuild/single.package
Developing开发
1 Cross Compile：http://wiki.openwrt.org/doc/devel/crosscompile
            外部编译器设置
                 https://forum.openwrt.org/viewtopic.php?id=32330
                 https://forum.openwrt.org/viewtopic.php?id=29804
                 https://forum.openwrt.org/viewtopic.php?id=12436
           内部编译器设置
2 Creating packages：http://wiki.openwrt.org/doc/devel/packages
3 Feeds：http://wiki.openwrt.org/doc/devel/feeds
4 Using Dependencies：http://wiki.openwrt.org/doc/devel/dependencies
5 How To Submit Patches to OpenWrt：
    https://dev.openwrt.org/wiki/SubmittingPatches
6 External Toolchain - Use OpenWrt as External Toolchain
    http://wiki.openwrt.org/doc/howto/external_toolchain
    https://lists.openwrt.org/pipermail/openwrt-devel/2009-February/003774.html
http://www.voidcn.com/article/p-egiomnlf-bkk.html  OpenWrt取消strip或者重新设置strip参数的方法
http://andelf.diandian.com/post/2013-05-22/40050677370 添加新设备
http://wiki.openwrt.org/doc/devel/packages  制作包参考文档
4、OpenWrt取消strip的方法
make package/foo/{clean,compile} V=99 STRIP=/bin/true
}