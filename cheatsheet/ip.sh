cat - <<'EOF'
[ip]
/sbin/cbq           #流量控制 
/sbin/ifcfg         #网络地址配置管理 
/sbin/ip            #网络配置命令 
/sbin/rtmon         #rtmon listens on netlink socket and monitors routing table changes. 
/sbin/tc            #进行流量控制的命令 
/usr/sbin/arpd      #收集arp信息保存到本地cache daemon 
/usr/sbin/lnstat    #网络统计信息                    /proc/net/stat/
/usr/sbin/nstat     #显示网络统计信息 
/usr/sbin/rtacct    #查看数据包流量状态 
/usr/sbin/ss        #类似netstat命令，显示活动连接
                                                                   man
链路层管理: ip link           MAC地址配置                          ip-link
MAC层管理 : ip neigh          MAC-IP缓存管理                       ip-neighbour
地址层管理: ip addr           IP-ROUTE配置管理                     ip-address    ip-addrlabel
路由层管理: ip route          ROUTE配置管理                        ip-route
策略层管理: ip rule           interface-route配置管理              ip-rule
连接层管理: ss, netstat -ltp  ip-port:ip-port连接管理              
连接层构建: socat             input:output连接构建                 
内核层监控: ip monitor        lnstat描述/proc/net/stat/* 缓存监控  
桥连接管理: brctrl            桥接口管理                           

-o, -oneline # 在单行上输出每条记录，用'\'字符代替换行。当你想用wc(1)来计算记录时，这很方便。或 grep(1) 的输出。
ip -o link show eth0 |  awk '{ print toupper(gensub(/.*link\/[^ ]* ([[:alnum:]:]*).*/,"\\1", 1)); }' # 获取MAC地址

@ 设计哲学: 修订IP地址和管理网络接口
EOF

ip_l_link(){ cat - <<'EOF'
http://linux-ip.net/html/index.html      # good
https://www.qingsword.com/sitemap.html   # net
https://github.com/mytliulei/boundless/blob/e2c756e80f838cdb49914a5967a2a9a30a04664f/%E7%BD%91%E7%BB%9C%E8%99%9A%E6%8B%9F%E5%8C%96/linux%E8%99%9A%E6%8B%9F%E8%AE%BE%E5%A4%87/iproute2.md
https://github.com/DamienRobert/Documentation/tree/726fceeee3afc4eaf34284cce53e39d2e6a877f8/logiciels/network

https://lartc.org/lartc.html#LARTC.QDISC
https://wiki.linuxfoundation.org/networking/iproute2 
https://tldp.org/HOWTO/NET3-4-HOWTO.html
https://www.netfilter.org/documentation/HOWTO/
EOF
}

ip_t_ifconfig_route_netstat_compact(){ cat - <<'EOF'
@ ip命令和ifconfig命令之间的兼容
1. 链路层管理 ip-link
ifconfig -a          ip link show

ifconfig eth1 up     ip link set down eth1
ifconfig eth1 down   ip link set up eth1

ifconfig eth1 hw ether 08:00:27:75:2a:66
ip link set dev eth1 address 08:00:27:75:2a:67

2. 地址层管理(ip命令能添加多个地址而ifconfig只能添加一个地址) ip-address    ip-addrlabel
ifconfig eth1       ip addr show dev eth1 
添加方式
ifconfig eth1 10.0.0.1/24
ip addr add 10.0.0.1/24 dev eth1 
ip addr add 10.0.0.1/24 broadcast 10.0.0.255 dev eth1

删除方式
ifconfig eth1 0     ip addr del 10.0.0.1/24 dev eth1    
                    ip addr flush dev eth1

ifconfig eth1       ip -6 addr show dev eth1

IPv6地址添加
ifconfig eth1 inet6 add 2002:0db5:0:f102::1/64
ifconfig eth1 inet6 add 2003:0db5:0:f102::1/64
ip -6 addr add 2002:0db5:0:f102::1/64 dev eth1
ip -6 addr add 2003:0db5:0:f102::1/64 dev eth1

IPv6地址删除
ifconfig eth1 inet6 del 2002:0db5:0:f102::1/64
ip -6 addr del 2002:0db5:0:f102::1/64 dev eth1

3. 路由层管理 ip-route
route -n
netstat -rn
ip route show

route add default gw 192.168.1.2 dev eth0             默认路由: 添加
route del default gw 192.168.1.1 dev eth0             默认路由: 删除
ip route add default via 192.168.1.2 dev eth0         默认路由: 添加
ip route replace default via 192.168.1.2 dev eth0     默认路由: 删除

route add -net 172.16.32.0/24 gw 192.168.1.1 dev eth0 网段路由: 添加
route del -net 172.16.32.0/24                         网段路由: 删除
ip route add 172.16.32.0/24 via 192.168.1.1 dev eth0  网段路由: 添加
ip route del 172.16.32.0/24                           网段路由: 删除

4. 网络连接展示
netstat           ss
netstat -l        ss -l

5. arp信息展示 cat /proc/net/arp
arp -an          ip neigh 

arp -s 192.168.1.100 00:0c:29:c0:5a:ef
arp -d 192.168.1.100
ip neigh add 192.168.1.100 lladdr 00:0c:29:c0:5a:ef dev eth0
ip neigh del 192.168.1.100 dev eth0

6. 组播组管理
ipmaddr add 33:44:00:00:00:01 dev eth0
ipmaddr del 33:44:00:00:00:01 dev eth0
ipmaddr show dev eth0
netstat -g

ip maddr add 33:44:00:00:00:01 dev eth0
ip maddr del 33:44:00:00:00:01 dev eth0
ip maddr list dev eth0
EOF
}


ip_i_ifconfig(){ cat - <<'EOF'
Usage:
  ifconfig [-a] [-v] [-s] <interface> [[<AF>] <address>]
  [add <address>[/<prefixlen>]]
  [del <address>[/<prefixlen>]]
  [[-]broadcast [<address>]]  [[-]pointopoint [<address>]]
  [netmask <address>]  [dstaddr <address>]  [tunnel <address>]
  [outfill <NN>] [keepalive <NN>]
  [hw <HW> <address>]  [metric <NN>]  [mtu <NN>]
  [[-]trailers]  [[-]arp]  [[-]allmulti]
  [multicast]  [[-]promisc]
  [mem_start <NN>]  [io_addr <NN>]  [irq <NN>]  [media <type>]
  [txqueuelen <NN>]
  [[-]dynamic]
  [up|down] ...

  <HW>=Hardware Type.
  List of possible hardware types:
    loop (Local Loopback) slip (Serial Line IP) cslip (VJ Serial Line IP)
    slip6 (6-bit Serial Line IP) cslip6 (VJ 6-bit Serial Line IP) adaptive (Adaptive Serial Line IP)
    strip (Metricom Starmode IP) ash (Ash) ether (Ethernet)
    tr (16/4 Mbps Token Ring) tr (16/4 Mbps Token Ring (New)) ax25 (AMPR AX.25)
    netrom (AMPR NET/ROM) rose (AMPR ROSE) tunnel (IPIP Tunnel)
    ppp (Point-to-Point Protocol) hdlc ((Cisco)-HDLC) lapb (LAPB)
    arcnet (ARCnet) dlci (Frame Relay DLCI) frad (Frame Relay Access Device)
    sit (IPv6-in-IPv4) fddi (Fiber Distributed Data Interface) hippi (HIPPI)
    irda (IrLAP) ec (Econet) x25 (generic X.25)
    infiniband (InfiniBand)
  <AF>=Address family. Default: inet
  List of possible address families:
    unix (UNIX Domain) inet (DARPA Internet) inet6 (IPv6)
    ax25 (AMPR AX.25) netrom (AMPR NET/ROM) rose (AMPR ROSE)
    ipx (Novell IPX) ddp (Appletalk DDP) ec (Econet)
    ash (Ash) x25 (CCITT X.25)

1. 显示
-a  显示全部接口信息。
-s  显示摘要信息（类似于 netstat -i）。
2. 地址
<interface> address             为网卡设置IPv4地址。
<interface> netmask <address>   设置网卡的子网掩码。掩码可以是有前缀0x的32位十六进制数，也可以是用点分开的4个十进制数。
<interface> add <address>       给指定网卡配置IPv6地址。
<interface> del <address>       删除指定网卡的IPv6地址。
3. 隧道和对端地址
<interface> dstaddr <address>   设定一个远端地址，建立点对点通信。
<interface> tunnel <address>    建立隧道。
4. hw mtu multicast -promisc -arp txqueuelen up|down
<interface> hw <address>    设置硬件地址。
<interface> mtu <NN>        设置最大传输单元。
<interface> [-]arp          设置指定网卡是否支持ARP协议。-表示不支持arp。
<interface> multicast       为网卡设置组播标志。
<interface> [-]promisc      设置是否支持网卡的promiscuous模式，如果选择此参数，网卡将接收网络中发给它所有的数据包。-表示关闭混杂模式。
<interface> txqueuelen <NN> 为网卡设置传输列队的长度。
<interface> up              启动指定网卡。
<interface> down            关闭指定网卡。该参数可以有效地阻止通过指定接口的IP信息流，如果想永久地关闭一个接口，我们还需要从核心路由表中将该接口的路由信息全部删除。
EOF
}

ip_t_ifconfig(){ cat - <<'EOF'
ifconfig interface {option}             # mtu netmask broadcast
ifconfig <dev> mtu 1500
ifconfig eth0 mtu 1400     ip link set dev eth0 mtu 1400

1. 显示网络设备信息
ifconfig [-a] interface [address]
ifconfig -a  # 显示所有的网卡信息
ifconfig -s  # 显示简要的网卡信息
2. 启动关闭指定网卡
ifconfig {interface} {up|down}
ifconfig eth0 down # 关闭网卡
ifconfig eth0 up   # 启动网卡
3. 配置和删除ip地址
ifconfig <dev> <ip> [netmask <mask> broadcast <ip>]
ifconfig eth0 192.168.1.100                                                # 配置ip地址
ifconfig eth0 192.168.1.100 netmask 255.255.255.0                          # 配置ip地址和子网掩码
ifconfig eth0 192.168.1.100 netmask 255.255.255.0 broadcast 192.168.1.255  # 配置ip地址、子网掩码和广播地址
ifconfig eth0:0 192.168.1.100 netmask 255.255.255.0 up  # 单网卡添加多个IP地址
ifconfig eth0:1 192.168.2.100 netmask 255.255.255.0 up  # 单网卡添加多个IP地址
ifconfig eth0 del 192.168.1.100                         # 删除IP地址

ifconfig <dev> add|del 33ffe:3240:800:1005::2/64
ifconfig eth0 add 3ffe:3240:800:1005::2/64        # 添加
ifconfig eth0 del 3ffe:3240:800:1005::2/64        # 删除

4. 修改MAC地址
ifconfig <dev> hw ether 00:AA:BB:CC:dd:EE
ifconfig eth0 hw ether 00:AA:BB:CC:DD:EE
ifconfig em1 hw ether 00:1c:bf:87:25:d5 # 硬件地址欺骗

5. 启用和关闭ARP协议 NOARP
ifconfig <dev> arp
ifconfig eth0 -arp
ifconfig eth0 arp   # 启用arp
ifconfig eth0 -arp  # 禁用arp

6. 设置最大传输单元
ifconfig eth0 mtu 1500

7. 设置网卡的promiscuous模式 PROMISC
ifconfig eth0 promisc   # 启用
ifconfig eth0 -promisc  # 禁用
ifconfig eth0 promisc      ip link set eth0 promisc on
ifconfig eth0 -promisc     ip link set eth0 promisc off

8. 设置网卡的多播模式 MULTICAST
ifconfig eth0 allmulti   # 启用
ifconfig eth0 -allmulti  # 禁用
EOF
}
ip_t_ifconfig_output(){ cat - <<'ip_t_ifconfig_output'
[root@localhost ~]# ifconfig eth0
 
// UP：表示“接口已启用”。
// BROADCAST ：表示“主机支持广播”。
// RUNNING：表示“接口在工作中”。
// MULTICAST：表示“主机支持多播”。
// MTU:1500（最大传输单元）：1500字节
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
 
 
// inet ：网卡的IP地址。
// netmask ：网络掩码。
// broadcast ：广播地址。
inet 192.168.1.135 netmask 255.255.255.0 broadcast 192.168.1.255
 
 
// 网卡的IPv6地址
inet6 fe80::2aa:bbff:fecc:ddee prefixlen 64 scopeid 0x20<link>
 
// 连接类型：Ethernet (以太网) HWaddr (硬件mac地址)
// txqueuelen (网卡设置的传送队列长度)
ether 00:aa:bb:cc:dd:ee txqueuelen 1000 (Ethernet)
 
 
// RX packets 接收时，正确的数据包数。
// RX bytes 接收的数据量。
// RX errors 接收时，产生错误的数据包数。
// RX dropped 接收时，丢弃的数据包数。
// RX overruns 接收时，由于速度过快而丢失的数据包数。
// RX frame 接收时，发生frame错误而丢失的数据包数。
RX packets 2825 bytes 218511 (213.3 KiB)
RX errors 0 dropped 0 overruns 0 frame 0
 
 
 
// TX packets 发送时，正确的数据包数。
// TX bytes 发送的数据量。
// TX errors 发送时，产生错误的数据包数。
// TX dropped 发送时，丢弃的数据包数。
// TX overruns 发送时，由于速度过快而丢失的数据包数。
// TX carrier 发送时，发生carrier错误而丢失的数据包数。
// collisions 冲突信息包的数目。
TX packets 1077 bytes 145236 (141.8 KiB)
TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
ip_t_ifconfig_output
}

ip_i_route_windows(){ cat - <<'ip_i_route_windows'
简单的的操作如下，
(1) 查看路由状态：
route print

(2) 只查看ipv4（ipv6）路由状态：
route print -4(-6)

(3) 添加路由：route add 目的网络 mask 子网掩码 网关——重启机器或网卡失效
route add 192.168.1.0 mask 255.255.255.0 192.168.1.1

(4) 添加永久：route -p add 目的网络 mask子网掩码网关
route -p add 192.168.1.0 mask 255.255.255.0 192.168.1.1

(5) 删除路由：route delete 目的网络 mask 子网掩码
route delete 192.168.1.0 mask 255.255.255.0
ip_i_route_windows
}


# https://blog.csdn.net/u011857683/article/details/83795435
ip_i_route_compact(){ cat - <<'ip_i_route_compact'
linux 默认只支持一条默认路由，当重新启动网口时，会把其他默认路由去掉，只剩下一条该网口生成的默认路由。
当然可以通过 route 命令手动添加多条默认路由，
如果多条路由一样，则选择最开始找到的路由(排在前面的路由)。
route [-CFvnee]

route [-v] [-A family] add [-net|-host] target [netmask Nm] [gw Gw] [metric N] 
      [mss M] [window W] [irtt I] [reject] [mod] [dyn] [reinstate] [[dev] If]
route [-v] [-A family] del [-net|-host] target [gw Gw] [netmask Nm] [metric N] [[dev] If]
route [-V] [--version] [-h] [--help]

-C  显示路由缓存。
-F  显示发送信息
-v  显示详细的处理信息。
-n  不解析名字。
-ee 使用更详细的资讯来显示
-V  显示版本信息。
-net    到一个网络的路由表。
-host   到一个主机的路由表。

add     增加路由记录。
del     删除路由记录。
target  目的网络或目的主机。
gw      设置默认网关。gateway 的简写，后续接的是 IP 的数值。
mss     设置TCP的最大区块长度（MSS），单位MB。
window  指定通过路由表的TCP连接的TCP窗口大小。
dev     如果只是要指定由那一块网路卡连线出去，则使用这个设定，后面接 eth0 等。
reject  设置到指定网络为不可达，避免在连接到这个网络的地址时程序过长时间的等待，直接就知道该网络不可达。

1. 添加和删除路由   route {add | del } [-net|-host] [网域或主机] netmask [mask] [gw|dev]
    增加 (add) 与删除 (del) 路由的相关参数：
    (a) -net ：表示后面接的路由为一个网域。
    (b) -host ：表示后面接的为连接到单部主机的路由。
    (c) netmask ：与网域有关，可以设定 netmask 决定网域的大小。
    (d) gw ：gateway 的简写，后续接的是 IP 的数值，与 dev 不同。
    (e) dev ：如果只是要指定由那一块网路卡连线出去，则使用这个设定，后面接 eth0 等。
2. 查询路由信息     route -nee
    (a) -n：不要使用通讯协定或主机名称，直接使用 IP 或 port number。
    (b) -ee：使用更详细的资讯来显示。
    
3. 添加/删除默认网关路由 route {add | del } default gw {IP-ADDRESS} {INTERFACE-NAME}
    (a) IP-ADDRESS：用于指定路由器（网关）的IP地址。
    (b) INTERFACE-NAME：用于指定接口名称，如eth0。
    例1：route add default gw 192.168.1.1 eth0
    例2：route del default gw 192.168.1.1 eth0
4. 添加/删除到指定网络的路由规则 route {add | del } -net {NETWORK-ADDRESS} netmask {NETMASK} dev {INTERFACE-NAME}
    (a) NETWORK-ADDRESS：用于指定网络地址。
    (b) NETMASK：用于指定子网掩码。
    (c) INTERFACE-NAME：用于指定接口名称，如eth0。
    例1：route add -net 192.168.1.0 netmask 255.255.255.0 dev eth0
    例2：route del -net 192.168.1.0 netmask 255.255.255.0 dev eth0
5. 添加/删除路由到指定网络为不可达
    设置到指定网络为不可达，避免在连接到这个网络的地址时程序过长时间的等待，直接就知道该网络不可达。
    route {add | del } -net {NETWORK-ADDRESS} netmask {NETMASK} reject
    (a) NETWORK-ADDRESS：用于指定网络地址。
    (b) NETMASK：用于指定子网掩码。
    例1：route add -net 10.0.0.0 netmask 255.0.0.0 reject
    例2：route del -net 10.0.0.0 netmask 255.0.0.0 reject
ip_i_route_compact
}
ip_t_route_compact(){ cat - <<'EOF'
@ 使用route命令进行路由层管理

添加到网络的路由 (本地链路 网段路由) 在eth0接口链路存在该网段主机
route add -net 192.168.0.0/24 netmask 255.255.255.0  dev eth0
或者简写# route add -net 192.168.0.0/24  dev eth0
route del -net 192.168.1.0/24netmask 255.255.255.0 dev eth0
或者简写# route add -net 192.168.1.0/24  dev eth0

添加到主机的路由 (本地链路 主机路由) 在eth0接口链路存在该指定主机
route add -host 192.168.1.1/32 dev eth0
route del  -host 192.168.1.1/32 dev eth0
或者
route add -host 192.168.0.188 dev eth0
route del -host 192.168.0.188 dev eth0

添加到默认路由  (远端链路 默认路由) 在eth0存在到默认地址下一跳(192.168.0.5) # 下一跳即下一个地址
route del default eth0
route add default gw 192.168.0.5 eth0
grep GATEWAY /etc/sysconfig/network
GATEWAY=192.168.0.5

添加到网络的路由 (远端链路 网段路由) 在eth0存在到指定地址段(172.16.32.0/24)的下一跳(192.168.1.1 )
route add -net 172.16.32.0/24 gw 192.168.1.1 dev eth0 网段路由
route del -net 172.16.32.0/24                         网段路由

路由信息:
route [-nNvee] [-FC] [<AF>] List kernel routing tables                 列出内核路由表信息
route -F  # -F, --fib   display Forwarding Information Base (default)  配置路由信息(config)
route -C  # -C, --cache display routing cache instead of FIB           习得路由信息(cache)
cat /proc/net/rt_cache                                                 习得路由信息(cache)

man route
route [-CFvnee]
route [-v] [-A  family] add [-net|-host] target [netmask Nm] [gw Gw] [metric N] [mss M] [window W] [irtt I] [reject] [mod] [dyn] [reinstate] [[dev]If]
route [-v] [-A family] del [-net|-host] target [gw Gw] [netmask Nm] [metric N] [[dev] If]

# 特别帮助信息
route --help -A inet     route --help --inet
route --help -A inet6    route --help --inet6
route add -net 10.0.0.0 netmask 255.0.0.0 reject
EOF
}

ip_t_route_unreachable(){ cat - <<'EOF'
@ 路由不可达测试用例

1. 网络不可到达
# ping 192.168.2.1
connect: Network is unreachable  这种信息表示没有到达指定网络的路由／／没有默认路由或者没有规则
2. 主机不可到达
# ping 192.168.1.5
PING 192.168.1.5 (192.168.1.5) 56(84) bytes of data.
From 192.168.1.254 icmp_seq=2 Destination Host Unreachable 这种信息味着有路由，但是目标主机可能不存在
U －－－up
UG－－－网关
UH－－－主机路由
EOF
}


ip_i_argument(){ cat - <<'EOF'
-V  --version 	            打印ip工具的版本并退出。
-h  -human, -human-readable 输出统计信息，其后跟人类可读的值。
-b  -batch <FILENAME>      从提供的文件或标准输入中读取命令并调用它们。第一次失败将导致ip工具终止。
    -force 	                不批处理模式下出错时不要终止IP工具。如果在执行命令期间出现任何错误，则应用程序返回码将为非零。
-s  -stats,-statistics      输出更多信息。如果该选项出现两次或更多次，则信息量会增加。通常，信息是统计信息或一些时间值。
-l  -loops <COUNT>          指定在放弃之前，"ip address flush"逻辑将尝试的最大循环次数。 默认值为10。零(0)表示循环，直到所有地址被删除。    
-4                          等于-family inet
-6                          等于-family inet6
-B                          等于-family bridge
-M                          等于-family mpls
-0                          等于-family link 
-o  -oneline    在单独的一行上输出每个记录，并用'\'字符替换换行符。当您想使用wc(1)对记录进行计数或对输出进行grep(1)时，这非常方便。
-r  -resolve    使用系统的域名解析来打印DNS域名而不是主机地址。
-a  -all        在所有对象上执行指定的命令，这取决于命令是否支持此选项。
-t  -timestamp  使用monitor选项时显示当前时间。
-ts -tshort     与-timestamp类似，但使用较短的格式。
-rc -rcvbuf<SIZE> 设置netlink套接字接收缓冲区的大小，默认为1MB。
-iec            以IEC单位打印人类可读的速率(例如1Ki = 1024)。
-br -brief 	    仅以表格格式打印基本信息，以提高可读性。当前仅ip addr show和ip link show命令支持此选项。
-j  -json       以JavaScript对象表示法(JSON)输出结果。
-p  -pretty     默认的JSON格式紧凑且解析效率更高，但大多数用户难以阅读。该标志添加缩进以提高可读性。
EOF
}

ip_i_object(){ cat - <<'EOF'
OBJECT 	                说明
address                 设备上的协议(IP或IPv6)地址 	
addrlabel               用于协议地址选择的标签配置 # 协议地址标签管理，协议地址选择的标签配置。
l2tp                    基于IP的隧道以太网(L2TPv3) 	
link                    网络设备
maddress                多播地址
monitor                 监视netlink消息
mroute                  多播路由缓存条目
mrule                   多播路由策略数据库中的规则
neighbour               管理ARP或NDISC缓存条目 	
netns                   管理网络名称空间
ntable                  管理邻居缓存的操作 	
route                   路由表条目
rule                    路由策略数据库中的规则 	
tcp_metrics/tcpmetrics 	管理TCP Metrics - 管理 TCP 指标。
token                   管理令牌化的接口标识符 	
tunnel                  基于IP的隧道
tuntap                  管理TUN / TAP设备   
xfrm                    管理IPSec策略

ip OBJECT help
ip OBJECT h
ip object help;

ip address help
ip a help
ip r help
EOF
}

# https://wiki.linuxfoundation.org/networking/bridge
ip_i_bridge(){ cat - <<'EOF'
link   - Bridge port.                      bridge    
fdb    - Forwarding Database entry.        bridge    
mdb    - Multicast group database entry.   bridge    
vlan   - VLAN filter list.                 bridge    
stp    - Spanning-Tree Protocol            brctl     
Ethernet bridge frame table administration ebtables  

ip link add DEVICE type bridge [ ageing_time AGEING_TIME ] 
                               [ group_fwd_mask MASK ] 
                               [ group_address ADDRESS ] 
                               [ forward_delay FORWARD_DELAY ] 
                               [ hello_time HELLO_TIME ] 
                               [ max_age MAX_AGE ] 
                               [ stp_state STP_STATE ] 
                               [ priority PRIORITY ] 
                               [ vlan_filtering VLAN_FILTERING ] 
                               [ vlan_protocol VLAN_PROTOCOL ] 
                               [ vlan_default_pvid VLAN_DEFAULT_PVID ] 
                               [ vlan_stats_enabled VLAN_STATS_ENABLED ] 
                               [ mcast_snooping MULTICAST_SNOOPING ] 
                               [ mcast_router MULTICAST_ROUTER ] 
                               [ mcast_query_use_ifaddr MCAST_QUERY_USE_IFADDR ] 
                               [ mcast_querier MULTICAST_QUERIER ] 
                               [ mcast_hash_elasticity HASH_ELASTICITY ] 
                               [ mcast_hash_max HASH_MAX ] 
                               [ mcast_last_member_count LAST_MEMBER_COUNT ] 
                               [ mcast_startup_query_count STARTUP_QUERY_COUNT ] 
                               [ mcast_last_member_interval LAST_MEMBER_INTERVAL ] 
                               [ mcast_membership_interval MEMBERSHIP_INTERVAL ] 
                               [ mcast_querier_interval QUERIER_INTERVAL ] 
                               [ mcast_query_interval QUERY_INTERVAL ] 
                               [ mcast_query_response_interval QUERY_RESPONSE_INTERVAL ] 
                               [ mcast_startup_query_interval STARTUP_QUERY_INTERVAL ] 
                               [ mcast_stats_enabled MCAST_STATS_ENABLED ] 
                               [ mcast_igmp_version IGMP_VERSION ] 
                               [ mcast_mld_version MLD_VERSION ] 
                               [ nf_call_iptables NF_CALL_IPTABLES ] 
                               [ nf_call_ip6tables NF_CALL_IP6TABLES ] 
                               [ nf_call_arptables NF_CALL_ARPTABLES ]



判断包的类别(广播/单点)，查找内部MAC端口映射表，定位目标端口号，将数据转发到目标端口或丢弃，自动更新内部MAC端口映射表以自我学习。

Bridge和现实世界中的二层交换机有一个区别，图中左侧画出了这种情况：
数据被直接发到Bridge上，而不是从一个端口接收。
这种情况可以看做Bridge自己有一个MAC可以主动发送报文，
或者说Bridge自带了一个隐藏端口和寄主Linux系统自动连接，Linux上的程序可以直接从这个端口向Bridge上的其他端口发数据。
所以当一个Bridge拥有一个网络设备时，如bridge0加入了eth0时，实际上bridge0拥有两个有效MAC地址，一个是bridge0的，一个是eth0的，他们之间可以通讯。
由此带来一个有意思的事情是，Bridge可以设置IP地址。通常来说IP地址是三层协议的内容，不应该出现在二层设备Bridge上。但是Linux里Bridge是通用网络设备抽象的一种，只要是网络设备就能够设定IP地址。
当一个bridge0拥有IP后，Linux便可以通过路由表或者IP表规则在三层定位bridge0，此时相当于Linux拥有了另外一个隐藏的虚拟网卡和Bridge的隐藏端口相连，这个网卡就是名为bridge0的通用网络设备，IP可以看成是这个网卡的。
当有符合此IP的数据到达bridge0时，内核协议栈认为收到了一包目标为本机的数据，此时应用程序可以通过Socket接收到它。

一个更好的对比例子是现实世界中的带路由的交换机设备，它也拥有一个隐藏的MAC地址，供设备中的三层协议处理程序和管理程序使用。
设备里的三层协议处理程序，对应名为bridge0的通用网络设备的三层协议处理程序，即寄主Linux系统内核协议栈程序。设备里的管理程序，对应bridge0寄主Linux系统里的应用程序。

Bridge的实现当前有一个限制：当一个设备被attach到Bridge上时，那个设备的IP会变的无效，Linux不再使用那个IP在三层接受数据。
举例如下：如果eth0本来的IP是192.168.1.2，此时如果收到一个目标地址是192.168.1.2的数据，Linux的应用程序能通过Socket操作接受到它。
而当eth0被attach到一个bridge0时，尽管eth0的IP还在，但应用程序是无法接受到上述数据的。此时应该把IP192.168.1.2赋予bridge0。
EOF
}

# https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking/
ip_i_link_brctl(){ cat - <<'EOF'
要允许系统对bridge设备的管理, 需要启动相关模块 modprobe br_netfilter
操作类型                        | brctl                  | ip
创建bridge设备 br0 	            | brctl addbr br0        | ip link add br0 type bridge
启动bridge设备 br0 	            | <无> 	                 | ip link set dev br0 up
删除设备 br0                    | brctl delbr br0        | ip link del dev br0
将veth设备端 veth0 连接到 br0   | brctl addif br0 veth0  | ip link set dev veth0 master br0
移除veth设备端在 br0上的连接    | brctl delif br0 veth0  | ip link set dev veth0 nomaster
查看本机上的bridge设备列表 	    | brctl show             | ip link show type bridge
查看bridge设备 br0 上连接的接口 | brctl show br0         | ip link show master br0 type bridge

在使用brctl delbr删除一个bridge设备前, 需要使用ip命令将该设备设置为down的状态, 否则会出错.
bridge br0 is still up; can not delete it

https://github.com/generals-space/note-devops/master/网络系统/虚拟网络/vlan/readme实验
bridge+vlan

对FDB(转发DB Forwarding Database)及STP(生成树协议 Spanning Tree Protocol)
# BRIDGE MANAGEMENT
creating bridge                     brctl addbr <bridge> 
deleting bridge                     brctl delbr <bridge> 
add interface (port) to bridge      brctl addif <bridge> <ifname> 
delete interface (port) on bridge   brctl delbr <bridge>

# FDB MANAGEMENT
Shows a list of MACs in FDB         brctl showmacs <bridge>             | bridge fdb show [dev 设备名]
Sets FDB entries ageing time        brctl setageingtime <bridge> <time> | 
Sets FDB garbage collector interval brctl setgcint <brname> <time>      |
Adds FDB entry                                                          | bridge fdb add dev <interface> [dst, vni, port, via]
Appends FDB entry                                                       | bridge fdb append (parameters same as for fdb add)
Deletes FDB entry                                                       | bridge fdb delete (parameters same as for fdb add)

# STP MANAGEMENT
Turning STP on/off                  brctl stp <bridge> <state> 
Setting bridge priority             brctl setbridgeprio <bridge> <priority> 
Setting bridge forward delay        brctl setfd <bridge> <time> 
Setting bridge 'hello' time         brctl sethello <bridge> <time> 
Setting bridge maximum message age  brctl setmaxage <bridge> <time> 
Setting cost of the port on bridge  brctl setpathcost <bridge> <port> <cost>        bridge link set dev <port> cost <cost>
Setting bridge port priority        brctl setportprio <bridge> <port> <priority>    bridge link set dev <port> priority <priority>
Should port proccess STP BDPUs                                      bridge link set dev <port > guard [on, off]
Should bridge might send traffic on the port it was received        bridge link set dev <port> hairpin [on,off]
Enabling/disabling fastleave options on port                        bridge link set dev <port> fastleave [on,off]
Setting STP port state                                              bridge link set dev <port> state <state>

ip link set dev br0 type bridge vlan_filtering 1
# VLAN MANAGEMENT
Creating new VLAN filter entry  bridge vlan add dev <dev> [vid, pvid, untagged, self, master]
Delete VLAN filter entry        bridge vlan delete dev <dev> (parameters same as for vlan add)
List VLAN configuration         bridge vlan show

https://github.com/generals-space/note-devops/master/网络系统/虚拟网络/bridge
vid VID
the VLAN ID that identifies the vlan.

pvid   the vlan specified is to be considered a PVID at ingress.  Any untagged frames will be assigned to this VLAN.

untagged
the vlan specified is to be treated as untagged on egress.

self   the vlan is configured on the specified physical device. Required if the device is the bridge device.

master the vlan is configured on the software bridge (default).

EOF
}
ip_i_vlan(){ cat - <<'EOF'
    VLAN的种类很多，按照协议原理一般分为：MACVLAN、802.1.q VLAN、802.1.qbg VLAN、802.1.qbh VLAN。
其中出现较早，应用广泛并且比较成熟的是 802.1.q VLAN，其基本原理是在二层协议里插入额外的 VLAN 协议数据
(称为 802.1.q VLAN Tag)，同时保持和传统二层设备的兼容性。

    Linux 里 802.1.q VLAN 设备是以母子关系成对出现的，母设备相当于现实世界中的交换机 TRUNK 口，用于连接上级网络，子设备相当于
普通接口用于连接下级网络。当数据在母子设备间传递时，内核将会根据 802.1.q VLAN Tag 进行对应操作。母子设备之间是一对多的关系，
一个母设备可以有多个子设备，一个子设备只有一个母设备。当一个子设备有一包数据需要发送时，数据将被加入 VLAN Tag 然后从母设备发送出去。

当母设备收到一包数据时，它将会分析其中的 VLAN Tag，如果有对应的子设备存在，则把数据转发到那个子设备上并根据设置移除 VLAN Tag，否则丢弃该数据。
在某些设置下，VLAN Tag 可以不被移除以满足某些监听程序的需要，如 DHCP 服务程序。

举例说明如下：eth0 作为母设备创建一个 ID 为 100 的子设备 eth0.100。此时如果有程序要求从 eth0.100 发送一包数据，
数据将被打上 VLAN 100 的 Tag 从 eth0 发送出去。
如果 eth0 收到一包数据，VLAN Tag 是 100，数据将被转发到 eth0.100 上，并根据设置决定是否移除 VLAN Tag。
如果 eth0 收到一包包含 VLAN Tag 101 的数据，其将被丢弃。

上述过程隐含以下事实：
对于寄主 Linux 系统来说，母设备只能用来收数据，子设备只能用来发送数据。和 Bridge 一样，母子设备的数据也是有方向的，
子设备收到的数据不会进入母设备，同样母设备上请求发送的数据不会被转到子设备上。可以把 VLAN 母子设备作为一个整体想象
为现实世界中的 802.1.q 交换机，下级接口通过子设备连接到寄主 Linux 系统网络里，上级接口同过主设备连接到上级网络，
当母设备是物理网卡时上级网络是外界真实网络，当母设备是另外一个 Linux 虚拟网络设备时上级网络仍然是寄主 Linux 系统网络。 
需要注意的是母子 VLAN 设备拥有相同的 MAC 地址，可以把它当成现实世界中 802.1.q 交换机的 MAC，因此多个 VLAN 设备会共享一个 MAC。
当一个母设备拥有多个 VLAN 子设备时，子设备之间是隔离的，不存在 Bridge 那样的交换转发关系，

原因如下：802.1.q VLAN 协议的主要目的是从逻辑上隔离子网。现实世界中的 802.1.q 交换机存在多个 VLAN，每个 VLAN 拥有多个端口，
同一 VLAN 端口之间可以交换转发，不同 VLAN 端口之间隔离，所以其包含两层功能：交换与隔离。Linux VLAN device 实现的是隔离功能，
没有交换功能。一个 VLAN 母设备不可能拥有两个相同 ID 的 VLAN 子设备，因此也就不可能出现数据交换情况。如果想让一个 VLAN 里接多个设备，
就需要交换功能。在 Linux 里 Bridge 专门实现交换功能，因此将 VLAN 子设备 attach 到一个 Bridge 上就能完成后续的交换功能。

总结起来，Bridge 加 VLAN device 能在功能层面完整模拟现实世界里的 802.1.q 交换机。
EOF
}

ip_i_link_vxlan(){ cat - <<'EOF'
ip link add DEVICE type vxlan id VNI [ dev PHYS_DEV ] 
                                     [ { group | remote } IPADDR ] 
                                     [ local { IPADDR | any } ] 
                                     [ ttl TTL ] 
                                     [ tos TOS ] 
                                     [ flowlabel FLOWLABEL ] 
                                     [ dstport PORT ] 
                                     [ srcport MIN MAX ] 
                                     [ [no]learning ] 
                                     [ [no]proxy ] 
                                     [ [no]rsc ] 
                                     [ [no]l2miss ] 
                                     [ [no]l3miss ] 
                                     [ [no]udpcsum ] 
                                     [ [no]udp6zerocsumtx ] 
                                     [ [no]udp6zerocsumrx ] 
                                     [ ageing SECONDS ] 
                                     [ maxaddress NUMBER ]
                                     [ [no]external ] 
                                     [ gbp ] 
                                     [ gpe ]
EOF
}

ip_i_link_vlan(){ cat - <<'EOF'
ip link add link DEVICE name NAME type vlan [ protocol VLAN_PROTO ] id VLANID  [ reorder_hdr { on | off } ] 
                                                                               [ gvrp { on | off } ] 
                                                                               [ mvrp { on | off } ] 
                                                                               [ loose_binding { on | off } ] 
                                                                               [ ingress-qos-map QOS-MAP ] 
                                                                               [ egress-qos-map QOS-MAP ]

ip link add link eth0 name eth0.100 type vlan id 100

eth0.100明显是用于本机虚拟环境使用的, 所有被路由到此接口上的数据包, 都会被转发到eth0上并携带上vlan tag, 
然后被eth0转发出去, 而转发出去的数据也需要对端设备可以接收vlan包才行, 否则这些数据包会被丢弃.

eth0是网卡接口, 不属于ip link中vlan, bridge, dummy等各类型中的任何一类.
另外, ip link add link创建vlan的目标不只可以是物理网卡eth0, 也可以是veth, bridge设备

一、相关定义
1. Trunk口   Trunk口上可以同时传送多个VLAN的包， 一般用于交换机之间的链接。
2. Hybrid口  Hybrid口上可以同时传送多个VLAN的包，一般用于交换机之间的链接或交换机于服务器的链接。
3. Access口  Access口只能属于1个VLAN，一般用于连接计算机的端口。
4. Tag和Untag  tag是指vlan的标签，即vlan的id，用于指名数据包属于那个vlan，untag指数据包不属于任何vlan，没有vlan标记。
5. pvid        即端口vlan id号，是非标记端口的vlan id 设定，当非标记数据包进入交换机，交换机将检查vlan设定并决定是否进行转发。
               一个ip包进入交换机端口的时候，如果没有带tag头，且该端口上配置了pvid，那么，该数据包就会被打上相应的tag头！
               如果进入的ip包已经带有tag头（vlan数据）的话，那么交换机一般不会再增加tag头，即使是端口上配置了pvid号；
               当非标记数据包进入交换机。

二、端口的Tag和Untag
   若某一端口在vlan设定中被指定为非标记端口untagged port, 所有从此端口转发出的数据包上都没有标记 (untagged)。若有标记的数据包进入交换机，则其经过非标记端口时，标记将被去除。因为目前众多设备并不支持标记数据包，其也无法识别标记数据包，因此，需要将与其连接的端口设定为非标记。
   若某一端口在vlan设定中被指定为标记端口tagged port, 所有从此端口转发出的数据包上都将有标记 (tagged)。若有非标记的数据包进入交换机，则其经过标记端口时，标记将被加上。此时，其将使用在ingress 端口上的pvid设定作为增加的标记中的vlan id号。
   
Trunk
@ 收报文
收到一个报文，判断是否有VLAN信息：如果没有则打上端口的PVID，并进行交换转发，
如果有判断该trunk端口是否允许该 VLAN的数据进入：如果可以则转发，否则丢弃
@ 发报文
比较端口的PVID和将要发送报文的VLAN信息，如果两者相等则剥离VLAN信息，再发送，
如果不相等则直接发送

Hybrid
@ 收报文
收到一个报文判断是否有VLAN信息：如果没有则打上端口的PVID，并进行交换转发，
如果有则判断该hybrid端口是否允许该VLAN的数据进入：如果可以则转发，否则丢弃
@ 发报文
判断该VLAN在本端口的属性（disp interface 即可看到该端口对哪些VLAN是untag，
哪些VLAN是tag）如果是untag则剥离VLAN信息，再发送，如果是tag则直接发送

Access
@ 收报文
判断是否有VLAN信息：如果没有则打上端口的PVID，并进行交换转发，如果有则直接
丢弃（缺省）
@ 发报文
将报文的VLAN信息剥离，直接发送出去
EOF
}

# https://cshihong.blog.csdn.net/article/details/80503588 20210529
ip_i_link_bridge_vlan(){ cat - <<'EOF'
有了 VLAN filter, Linux Bridge 就像一个真正的交换机，我们不再需要创建多个 VLAN 和网桥，直接在 Bridge 上打上/剥离 VLAN 标记。
bridge vlan add dev veth01 vid 100 pvid untagged master
bridge vlan add -- 增加一个VLAN过滤条目
    dev NAME    -- 与此VLAN相关的接口
    vid VID     -- 标识VLAN的VLAN ID
    tunnel_info TUNNEL_ID -- 映射到此vlan的隧道ID(没用过，不懂什么意思)
    pvid        -- 指定的VLAN在入口时将被视为PVID。任何未标记的帧都将分配给该VLAN
    untagged    -- 指定的VLAN在出口时将被视为未标记
    self        -- 在指定的物理设备上配置了VLAN。如果该设备是bridge，则必选
    master      -- 默认配置
    
VID解释
　　VID（VLAN ID）是VLAN的标识，在交换机里面用来划分端口。比如一个交换机有8个端口，现在将port1，port2，port5三个端口的VID设置成1111，
那么这三个端口就能接收vlantag=1111的数据包。

　  不论是否在这个VID上，是Untagged Port或者tagged Port，都可以接受来自交换机内部的标记
了这个TAG标记的tagged 数据帧。
　　只有在这个VID上是tagged Port，才可以接受来自交换机外部的标记了这个TAG标记的tagged 数据帧。

PVID解释
　　PVID英文解释为Port-base VLAN ID，是基于端口的VLAN ID，一个端口可以属于多个vlan，但是只能有一个PVID，收到一个不带tag头的数据包时，会打上PVID所表示的vlan号，视同该vlan的数据包处理。
　　一个物理端口只能拥有一个PVID，当一个物理端口拥有了一个PVID的时候，必定会拥有和PVID相等的VID，而且在这个VID上，这个物理端口必定是Untagged Port。
　　PVID的作用只是在交换机从外部接受到可以接受Untagged 数据帧的时候给数据帧添加TAG标记用的，在交换机内部转发数据的时候PVID不起任何作用。

untag port与tag port
　　所谓的untagged Port和tagged Port不是讲述物理端口的状态，而是将是物理端口所拥有的某一个VID的状态，所以一个物理端口可以在某一个VID上是untagged Port，在另一个VID上是tagged Port。
　　untag port和tag port是针对VID来说的，和PVID没有什么关系。比如有一个交换机的端口设置成untag port，但是从这个端口进入交换机的网络包如果没有vlan tag的话，就会被打上该端口的PVID，不要以为它是untag port就不会被打上vlan tag。
           tag数据帧   tag数据帧    untag数据帧                  untag数据帧
              IN          OUT          IN                            OUT
Tag端口    原样接收     原样发送    按照端口PVID打上TAG标识     按照端口PVID打上TAG标识(不存在这种情况)
Untag端口  丢弃         去掉tag发送 按照端口PVID打上TAG标识     按照端口PVID打上TAG标识(不存在这种情况)
EOF
}
# https://cshihong.blog.csdn.net/article/details/80404349 20210529
# https://www.qingsword.com/qing/636.html#CCNA-STP-1
ip_i_link_bridge_stp(){ cat - <<'ip_i_link_bridge_stp'
一、STP(Spanning-Tree Protocol：生成树协议) 出现背景 : 冗余链路 -> 引起流量环路 -> 动态的管理这些冗余链路
高可用场景带来的就是冗余链路，而冗余链路会带来几个问题。 如图所示 br0 和 br1 有两条线路，它们之间任何一条链路出现故障
另外一条线路可以马上顶替出现故障的那条链路，这样可以很好的解决单链路故障引起的网络中断，从而实现高可用，但在此之前有
下面三个需要考虑的问题。
1. 广播风暴:      交换机传送的二层数据不像三层数据一样有TTL，如果存在环路且数据不能被适当终止，它们就会在环路中永无止境地传输
2. MAC 地址不稳定:广播风暴除了会产生大量的流量外，还会造成MAC地址表的不稳定 # MAC地址缓存表也不断的被刷新，影响交换机的性能 
3. 重复帧拷贝 

关键点: 冗余拓扑中存在的问题、生成树协议、生成树收敛、利用生成树实现负载均衡
        BPDU(Bridge Protocol Data Unit), BID(Bridge ID，桥ID)，STA(Spanning Tree Algorithm，生成树算法)，根桥(Root Bridge)
        Root ID(Root Identifier)

STP算法 # 
    STP 通过交换 BPDU 报文，使用 STA(Spanning Tree Algorithm 生成树算法)来决定堵塞(禁用)交换机上的哪些端口来阻止环路
BPDU中包含BID(Bridge ID，桥ID)用来识别是哪台计算机发出的BPDU。在STP运行的情况下，虽然逻辑上没有了环路，但是物理线上还是存在环路的，
只是物理线路的一些端口被禁用以阻止环路的发生，如果正在使用的链路出现故障，STP重新计算，部分被禁用的端口重新启用来提供冗余。
    STP使用STA(Spanning Tree Algorithm，生成树算法)来决定交换机上的哪些端口被堵塞用来阻止环路的发生，STA选择一台交换机作为根交换机，
称作根桥(Root Bridge)，以该交换机作为参考点计算所有路径。

BID: BID由三部分组成——优先级、发送交换机的MAC地址、Extended System ID(扩展系统ID，可选项)
     BID一共8个字节，其中优先级2个字节，MAC地址6个字节。
     BID由优先级域和交换机的MAC地址组成，针对每个VLAN，交换机的MAC地址都不一样，交换机的优先级可以是0-65535
     在使用Extended System ID的情况下每个VLAN的MAC地址可以相同。

根桥选举 # BID 最小的被选作根交换机
    18-25 字节即为 BID ，优先级占2个字节，MAC 地址占6个字节。一个广播域所有交换机都参与选举根交换机，刚启动时，
所有交换机假设自己是根桥，每隔两秒发送 BPDU 帧，帧中的Root ID(Root Identifier)和本机的BID(Bridge Identifier)相同，
同时他们也接收别的交换机发来的 BPDU 报文并检查 Root ID 是否比自己的 Bridge ID 小，如果接收到的 Root ID 更小，
则将自己的 BPDU 报文的 Root ID 改为这个更小的 Root ID发出去，若还是自己的 Bridge ID 更小，则 Root ID 还是填自己的Bridge ID。
直到最后在同一个生成树实例中拥有一致的 Root ID，这个 Root ID 对应了这个广播域中某台交换机的 BID
(并且这个 BID 一定是这个广播域最小的)，这台交换机就被选作根交换机。

优先级可以通过bridge-utils管理工具中的brctl命令修改，优先级默认为32768(必须为4096的倍数)
[root@huangy ~]# brctl setbridgeprio br0 4096
[root@huangy ~]# brctl showstp br0
br0
 bridge id      1000.000000000000
 designated root    1000.000000000000
 root port         0            path cost          0
 max age          20.00         bridge max age        20.00
 hello time        2.00         bridge hello time      2.00
 forward delay        15.00         bridge forward delay      15.00
 ageing time         300.00
 hello timer           0.00         tcn timer          0.00
 topology change timer     0.00         gc timer           0.00
 flags                
根桥选举后只会由根桥每隔2秒发送一次BPDU包，其他的非根桥接收后转发


根端口选举(Root Port,RP)
本交换机各端口到达根交换机路径的开销—到达根桥的链路开销之和，找到一条开销最小的路径（RPC root path cost），
交换机的这个端口就是根端口；如果路径开销相同，则比较发送 BPDU 交换机的 Bridge ID ，选较小的；如果发送者 
Bridge ID 相同（即同一台交换），则比较发送者交换机的 port ID ，选较小的；如果发送者 Port ID 相同，
则比较接收者的 port ID ，选较小的。

Port ID -- 发送该BPDU的端口ID 由两部分组成=端口优先级(默认128，必须配置为16的整数倍) + 端口ID 端口优先级也可以通过 
brctl setportprio Root Path Cost ----本交换机认为的根路径开销 也可以通过 
brctl setpathcost 修改


选举指定端口(Designated Port,DP)
每个LAN选举指定端口(Designated Port,DP)，与选举根端口同时进行。每条链路上还要选举一个指定端口，即为连接网段并通往根桥的唯一端口，
负责发送和接收该网段和根桥之间的流量（每个LAN的通过该口连接到根交换机）。如果每个网段到达根桥只有一条通路,则无环路。 
默认情况下根桥的所有端口都是指定端口 

4. 将所有根端口和指定端口设为转发状态
5. 其他端口设为阻塞状态


STP端口角色
1）根端口(Root Port,RP)：        每个非根交换机上有且仅有一个根端口，稍后的生成树选举中会详细介绍根端口的选举过程。
2）指派端口(Designated Port,DP)：网络上除根端口外，所有允许转发流量的端口，每个网段都有一个指派端口，根交换机上的端口都是指派端口。
3）非指派端口：                  既不是根端口也不是指派端口，这种端口虽然是激活的但是会被堵塞(Blocking)用来阻止环路，根端口和指派端口都处于转发(Forwarding)状态。
4）禁用端口：                    被管理员使用"shutdown"命令关闭的端口称作禁用端口，禁用端口不参与生成树算法。

三、STP 端口状态
    Forwarding 只有根端口或指定端口才能进入 Forwarding 状态。Forwarding端口既转发用户流量也处理BPDU报文。
    learning 过渡状态，增加 Learning 状态防止临时环路。（15s）设备会根据收到的用户流量构建 MAC 地址表，但不转发用户流量。
    Listening 过渡状态。（15s）确定端口角色，将选举出根桥、根端口和指定端口。
    Blocking 阻塞端口的最终状态。端口仅接收并处理BPDU报文，不转发用户流量
    Disabled 端口状态为Down。端口既不处理BPDU报文，也不转发用户流量。

四、三种定时器
    Hello Time:Hello Timer定时器时间的大小控制配置BPDU发送间隔。
    Forward Delay Timer:Forward Delay Timer定时器时间的大小控制端口在Listening和Learning状态的持续时间。
    Max Age:Max Age定时器时间的大小控制存储配置BPDU的超时时间，超时认为根桥连接失败。
    
    
BPDU包含12个字段，部分字段解释如下：
    Flags：          标记域,包含TC(Topology Change，拓扑改变)比特位，TCA(Topology Change Acknowledgment,拓扑改变确认)比特位。
    Root ID：        包含了根交换机的BID。
    Cost of path：   到根交换机的路径花费。
    Bridge ID：      转发BPDU的交换机的BID。
    Port ID：        转发BPDU的交换机的PID，PID等于端口优先级(默认128)加端口号，后面会介绍到。
    Message age：    BPDU已经存在的时间。
    Max age：        BPDU最大存在时间。
    Hello time：     根交换机发送配置信息的间隔时间，默认2秒。
    Forward Delay：  转发延时，默认15秒。


ip_i_link_bridge_stp
}

ip_t_link_bridge_stp(){ cat - <<'ip_t_link_bridge_stp'
root@ubuntu:/sys/class/net# brctl showstp virbr0
virbr0
 bridge id              8000.000000000000
 designated root        8000.000000000000
 root port                 0                    path cost                  0
 max age                  20.00                 bridge max age            20.00
 hello time                2.00                 bridge hello time          2.00
 forward delay             2.00                 bridge forward delay       2.00
 ageing time             300.00
 hello timer               0.16                 tcn timer                  0.00
 topology change timer     0.00                 gc timer                 117.69
 flags
 
 root@ubuntu:/sys/class/net# brctl showstp br0
 br0
 bridge id              8000.000c292b346f
 designated root        6001.084ff9192480
 root port                 1                    path cost               20004
 max age                  20.00                 bridge max age            20.00
 hello time                2.00                 bridge hello time          2.00
 forward delay            15.00                 bridge forward delay      15.00
 ageing time             300.00
 hello timer               0.00                 tcn timer                  0.00
 topology change timer     0.00                 gc timer                   0.24
 flags


eth0 (1)
 port id                8001                    state                forwarding
 designated root        6001.084ff9192480       path cost                  4
 designated bridge      8000.084f0abb96d0       message age timer         18.66
 designated port        800b                    forward delay timer        0.00
 designated cost        20000                   hold timer                 0.00
 flags

vnet0 (2)
 port id                8002                    state                forwarding
 designated root        6001.084ff9192480       path cost                100
 designated bridge      8000.000c292b346f       message age timer          0.00
 designated port        8002                    forward delay timer        0.00
 designated cost        20004                   hold timer                 1.27
 flags

# @ https://www.techolac.com/linux/10-linux-brctl-command-examples-for-ethernet-network-bridge/
 # brctl showstp dev
dev
 bridge id              000a.000000000000
 designated root        000a.000000000000
 root port                 0       path cost                  0
 max age                  19.99    bridge max age            19.99
 hello time                1.99    bridge hello time          1.99
 forward delay            14.99    bridge forward delay      14.99
 ageing time             299.95
 hello timer               0.00    tcn timer                  0.00
 topology change timer     0.00    gc timer                   0.00
 hash elasticity           4       hash max                 512
 mc last member count      2       mc init query count        2
 mc router                 1       mc snooping                1
 mc last member timer      0.99    mc membership timer      259.96
 mc querier timer        254.96    mc query interval        124.98
 mc response interval      9.99    mc init query interval    31.24
 flags

brctl stp br0 on
brctl stp br0 yes
brctl setageing br0 100
|-------------------------------|-------------------------------------------|
|brctl command                  |Description                                |
|-------------------------------|-------------------------------------------|
|setageing bridge time          |Set ageing time                            |
|setbridgeprio bridge prio      |Set bridge priority (between 0 and 65535)  |
|setfd bridge time              |Set bridge forward delay                   |
|sethello bridge time           |Set hello time                             |
|setmaxage bridge time          |Set max message age                        |
|setgcint bridge time           |Set garbage collection interval in seconds |
|sethashel bridge int           |Set hash elasticity                        |
|sethashmax bridge int          |Set hash max                               |
|setmclmc bridge int            |Set multicast last member count            |
|setmcrouter bridge int         |Set multicast router                       |
|setmcsnoop bridge int          |Set multicast snooping                     |
|setmcsqc bridge int            |Set multicast startup query count          |
|setmclmi bridge time           |Set multicast last member interval         |
|setmcmi bridge time            |Set multicast membership interval          |
|setmcqpi bridge time           |Set multicast querier interval             |
|setmcqi bridge time            |Set multicast query interval               |
|setmcqri bridge time           |Set multicast query response interval      |
|setmcqri bridge time           |Set multicast startup query interval       |
|setpathcost bridge port cost   |Set path cost                              |
|setportprio bridge port prio   |Set port priority (between 0 and 255)      |
|setportmcrouter bridge port int|Set port multicast router                  |
|sethashel bridge int           |Set hash elasticity value                  |
|-------------------------------|-------------------------------------------|

ip_t_link_bridge_stp
}



# https://cshihong.blog.csdn.net/article/details/80475423
# https://cshihong.blog.csdn.net/article/details/80475475 20210529
# https://cshihong.blog.csdn.net/article/details/80475510 20210529
# https://cshihong.blog.csdn.net/article/details/80475579 20210529
# https://www.h3c.com/cn/d_202103/1390600_30005_0.htm
ip_i_link_bridge_IGMP_Snooping(){ cat - <<'ip_i_link_bridge_IGMP_Snooping'
------------------------------------------------------------------------------- IGMP Snooping 背景知识
1. IGMP Snooping运行在二层设备上，通过侦听三层设备与主机之间的IGMP报文来生成二层组播转发表，从而管理和控制组播数据报文的转发，实现组播数据报文在二层的按需分发。       # 按需(广播)
2. 运行IGMP Snooping的二层设备通过对收到的IGMP报文进行分析，为端口和MAC组播地址建立起映射关系，并根据这样的映射关系转发组播数据。                                      # 数据缓存
3. 当二层设备没有运行IGMP Snooping时，组播数据在二层网络中被广播；当二层设备运行了IGMP Snooping后，已知组播组的组播数据不会在二层网络中被广播，而被组播给指定的接收者。# 洪泛--> 特定端口

IGMP Snooping通过二层组播将信息只转发给有需要的接收者，可以带来以下好处：
1. 减少了二层网络中的广播报文，节约了网络带宽；
2. 增强了组播信息的安全性；
3. 为实现对每台主机的单独计费带来了方便。

1. 路由器端口 -> 路由器端口都是指二层设备上朝向三层组播设备的端口，而不是指路由器上的端口
在运行了IGMP Snooping的二层设备上，朝向上游三层组播设备的端口称为路由器端口。
根据来源不同，路由器端口可分为：
·   动态路由器端口：所有收到IGMP普遍组查询报文(源地址非0.0.0.0)的端口，都被维护为动态路由器端口。这些端口被记录在动态路由器端口列表中，每个端口都有一个老化定时器。
在老化定时器超时前，动态路由器端口如果收到了IGMP普遍组查询报文(源地址非0.0.0.0)，该定时器将被重置；否则，该端口将被从动态路由器端口列表中删除。
·   静态路由器端口：通过命令行手工配置的路由器端口称为静态路由器端口，这些端口被记录在静态路由器端口列表中。静态路由器端口只能通过命令行手工删除，不会被老化。

2. 成员端口
在运行了IGMP Snooping的二层设备上，朝向下游组播组成员的端口称为成员端口。
根据来源不同，成员端口也可分为：
·     动态成员端口：所有收到IGMP成员关系报告报文的端口，都被维护为动态成员端口。这些端口被记录在动态IGMP Snooping转发表中，每个端口都有一个老化定时器。
在老化定时器超时前，动态成员端口如果收到了IGMP成员关系报告报文，该定时器将被重置；否则，该端口将被从动态IGMP Snooping转发表中删除。
·     静态成员端口：通过命令行手工配置的成员端口称为静态成员端口，这些端口被记录在静态IGMP Snooping转发表中。静态路由器端口只能通过命令行手工删除，不会被老化。

------------------------------------------------------------------------------- IGMP Snooping工作机制
IGMP Snooping工作机制
1. 普遍组查询
IGMP查询器定期向本地网段内的所有主机与设备(224.0.0.1)发送IGMP普遍组查询报文，以查询该网段有哪些组播组的成员。
在收到IGMP普遍组查询报文时，二层设备将其通过VLAN内除接收端口以外的其它所有端口转发出去，并对该报文的接收端口做如下处理：
·     如果在动态路由器端口列表中已包含该动态路由器端口，则重置其老化定时器。
·     如果在动态路由器端口列表中尚未包含该动态路由器端口，则将其添加到动态路由器端口列表中，并启动其老化定时器。

2. 报告成员关系
以下情况，主机会向IGMP查询器发送IGMP成员关系报告报文：
·     当组播组的成员主机收到IGMP查询报文后，会回复IGMP成员关系报告报文。
·     如果主机要加入某个组播组，它会主动向IGMP查询器发送IGMP成员关系报告报文以声明加入该组播组。
在收到IGMP成员关系报告报文时，二层设备将其通过VLAN内的所有路由器端口转发出去，从该报文中解析出主机要加入的组播组地址，并对该报文的接收端口做如下处理：
·     如果不存在该组播组所对应的转发表项，则创建转发表项，将该端口作为动态成员端口添加到出端口列表中，并启动其老化定时器；
·     如果已存在该组播组所对应的转发表项，但其出端口列表中不包含该端口，则将该端口作为动态成员端口添加到出端口列表中，并启动其老化定时器；
·     如果已存在该组播组所对应的转发表项，且其出端口列表中已包含该动态成员端口，则重置其老化定时器。

注意: 二层设备不会将IGMP成员关系报告报文通过非路由器端口转发出去，因为根据主机上的IGMP成员关系报告抑制机制，如果非路由器端口下还有该组播组的成员主机，
则这些主机在收到该报告报文后便抑制了自身的报告，从而使二层设备无法获知这些端口下还有该组播组的成员主机。

3. 离开组播组
    运行IGMPv1的主机离开组播组时不会发送IGMP离开组报文，因此二层设备无法立即获知主机离开的信息。但是，由于主机离开组播组后不会再发送IGMP成员关系报告报文，
因此当其对应的动态成员端口的老化定时器超时后，二层设备就会将该端口从相应转发表项的出端口列表中删除。
    运行IGMPv2或IGMPv3的主机离开组播组时，会通过发送IGMP离开组报文，以通知三层组播设备自己离开了某个组播组。当二层设备从某动态成员端口上收到IGMP离开组报文时，
首先判断要离开的组播组所对应的转发表项是否存在，以及该组播组所对应转发表项的出端口列表中是否包含该接收端口：
    3.1 如果不存在该组播组对应的转发表项，或者该组播组对应转发表项的出端口列表中不包含该端口，二层设备不会向任何端口转发该报文，而将其直接丢弃；
    3.2 如果存在该组播组对应的转发表项，且该组播组对应转发表项的出端口列表中除该端口还有别的成员端口存在，二层设备不会向任何端口转发该报文，而将其直接丢弃。
同时，由于并不知道该接收端口下是否还有该组播组的其它成员，所以二层设备不会立刻把该端口从该组播组所对应转发表项的出端口列表中删除，而是向该端口发送IGMP特定组查询报文，
并根据IGMP特定组查询报文调整该端口的老化定时器(老化时间为2×IGMP特定组查询报文的发送间隔)；
    3.3 如果存在该组播组对应的转发表项，且该组播组对应转发表项的出端口列表中只有该端口，二层设备会将该报文通过VLAN内的所有路由器端口转发出去。
同时，由于并不知道该接收端口下是否还有该组播组的其它成员，所以二层设备不会立刻把该端口从该组播组所对应转发表项的出端口列表中删除，而是向该端口发送IGMP特定组查询报文，
并根据IGMP特定组查询报文调整该端口的老化定时器(老化时间为2×IGMP特定组查询报文的发送间隔)。
    
    当IGMP查询器收到IGMP离开组报文后，从中解析出主机要离开的组播组的地址，并通过接收端口向该组播组发送IGMP特定组查询报文。二层设备在收到IGMP特定组查询报文后，
将其通过VLAN内的所有路由器端口和该组播组的所有成员端口转发出去。对于IGMP离开组报文的接收端口（假定为动态成员端口），二层设备在其老化时间内：
·     如果从该端口收到了主机响应该特定组查询的IGMP成员关系报告报文，则表示该端口下还有该组播组的成员，于是重置其老化定时器；
·     如果没有从该端口收到主机响应特定组查询的IGMP成员关系报告报文，则表示该端口下已没有该组播组的成员。当该端口的老化定时器超时后，将其从该组播组所对应转发表项的出端口列表中删除。
RFC 4541
------------------------------------------------------------------------------- IGMP Snooping配置
bridge mdb { add | del } dev DEV port PORT grp GROUP [ permanent | temp ]
bridge mdb show [ dev DEV ]



ip_i_link_bridge_IGMP_Snooping
}

# http://hicu.be/bridge-vs-macvlan
ip_i_link_macvlan_intro(){ cat - <<'ip_i_link_macvlan_intro'
bridge 
网桥是一个第二层设备，将两个第二层（即以太网）网段连接起来。两个网段之间的帧是根据第二层地址（即MAC地址）转发的。 a bridge is effectively a switch??
  网桥根据MAC地址表做出转发决定。网桥通过查看通信主机的帧头来学习MAC地址。
  网桥可以是一个物理设备，也可以完全用软件实现。 Linux bridge|brctl
  桥接可以将虚拟以太网接口相互连接，也可以将虚拟以太网接口与物理以太网设备连接，将它们连接成一个单一的第二层设备。
# brctl show
bridge name  bridge id          STP enabled  interfaces
br0          8000.080006ad34d1  no           eth0
                                             veth0
br1          8000.080021d2a187  no           veth1
                                             veth2

macvlan
  macvlan 允许你在主机的一个网络接口上配置多个虚拟的网络接口，这些网络 interface 有自己独立的 MAC 地址，也可以配置上 IP 地址进行通信。
  Macvlan允许你配置一个父级的子接口(也称为从属设备)。
  物理以太网接口(也称为上层设备)，每个都有自己独特的(随机生成的)MAC地址，因此也有自己的IP地址。 --- Applications, VMs and containers 
mac0@eth0 ; mac1@eth0 ; mac2@eth0 ; mac3@eth0 :eth0如果down掉，则上面的接口也down掉。
private
VEPA(Virtual Ethernet Port Aggregator)
Bridge
Passthru

Macvlan vs Bridge
    The macvlan is a trivial bridge that doesn’t need to do learning as it knows every mac address it can receive, so it doesn’t need to implement learning or stp. 
Which makes it simple stupid and and fast.

Use Macvlan:
    When you only need to provide egress connection to the physical network to your VMs or containers.
    Because it uses less host CPU and provides slightly better throughput.

Use Bridge:
    When you need to connect VMs or containers on the same host.
    For complex topologies with multiple bridges and hybrid environments (hosts in the same Layer2 domain both on the same host and outside the host).
    You need to apply advanced flood control, FDB manipulation, etc.


ip_i_link_macvlan_intro
}

# https://cizixs.com/2017/02/14/network-virtualization-macvlan/
ip_i_link_macvlan(){ cat - <<'EOF'
    使用VLAN，您可以在一个接口上创建多个接口，并根据VLAN标签过滤包。使用MACVLAN，
可以在一个接口之上创建多个具有不同2层(即以太网MAC)地址的接口。

    在MACVLAN之前，如果你想从虚拟机或命名空间连接到物理网络，你需要创建TAP/VETH设备，并将一侧连接到网桥，
同时将物理接口连接到主机上的网桥。
    现在，有了MACVLAN，你可以直接将与MACVLAN相关联的物理接口绑定到命名空间，而不需要网桥。
MACVLAN有五种类型。
    Private： 过滤掉所有来自其他 macvlan 接口的报文，因此不同 macvlan 接口之间无法互相通信
    VEPA：    需要主接口连接的交换机支持 VEPA/802.1Qbg 特性。
              所有发送出去的报文都会经过交换机，交换机作为再发送到对应的目标地址(即使目标地址就是主机上的其他 macvlan 接口)，也就是 hairpin mode 模式，这个模式用在交互机上需要做过滤、统计等功能的场景。
    bridge：  所有端点通过物理接口直接用简单的桥接方式相互连接。
    Passthru：允许单个虚拟机直接连接到物理接口。
   
模式比较:
VEPA 和 passthru 模式下，两个 macvlan 接口之间的通信会经过主接口两次：第一次是发出的时候，第二次是返回的时候。这样会影响物理接口的宽带，也限制了不同 macvlan 接口之间通信的速度。如果多个 macvlan 接口之间通信比较频繁，对于性能的影响会比较明显。
private 模式下，所有的 macvlan 接口都不能互相通信，对性能影响最小。
bridge 模式下，数据报文是通过内存直接转发的，因此效率会高一些，但是会造成 CPU 额外的计算量。

    源：源模式用于根据允许的源MAC地址列表过滤流量，以创建基于MAC的VLAN关联。
ip link add macvlan1 link eth1 type macvlan mode bridge
ip link add macvlan2 link eth1 type macvlan mode bridge
ip netns add net1
ip netns add net2
ip link set macvlan1 netns net1
ip link set macvlan2 netns net2

ip netns exec net1 ip link
ip netns exec net2 ip link

http://hicu.be/bridge-vs-macvlan

ip link add name ${macvlan interface name} link ${parent interface} type macvlan
ip link add name peth0 link eth0 type macvlan
EOF
}

ip_t_link_macvlan(){ cat - <<'EOF'
macvlan与传统的在单网卡上配置多个ip不同，macvlan设备有自己的mac地址，这样可以在一个网卡上虚拟多个mac-ip对。
macvlan默认模式是verpa（另外还bridge，private，passthru），默认情况下，建立在同一网卡下的macvlan虚拟设备之间不能互相通信

$ modprobe macvlan
$ lsmod | grep macvlan

net namespace
将创建的macvlan设备划到单独的netnamespace，这样我们就可以不影响宿主机器的net环境。

    eth1为测试仪端口(实体环境下，为实际的物理网卡；虚拟环境下为veth)，我们在eth1下建立macvlan设备eth1.mv1，
并划到namespace test1下，配置地址10.1.1.10
ip netns add test1
ip link add eth1.mv1 link eth1 type macvlan
ip link set eth1.mv1 netns test1
ip netns exec test1 ip link set eth1.mv1 up
ip netns exec test1 ip addr add 10.1.1.10/24 dev eth1.mv1

1. 建立一对veth，为veth1，veth2，并将veth2划到test的netns下
ip netns add test
ip link add veth1 type veth peer name veth2
ip link set veth2 netns test
ip link set veth1 up
ip netns exec test ip link set veth2 up
ip netns exec test ip addr add 10.1.1.1/24 dev veth2 


2. 在veth1上建立mv1和mv2，并分别划到n1，n2的netns下，配置地址
ip netns add n1
ip netns add n2
ip link add veth1.mv1 link veth1 type macvlan
ip link add veth1.mv2 link veth1 type macvlan
ip link set veth1.mv1 netns n1
ip link set veth1.mv2 netns n2
ip netns exec n1 ip link set veth1.mv1 up
ip netns exec n2 ip link set veth1.mv2 up
ip netns exec n1 ip addr add 10.1.1.10/24 dev veth1.mv1
ip netns exec n2 ip addr add 10.1.1.11/24 dev veth1.mv2

4. veth1 ping mv1 mv2
ip netns exec test ping 10.1.1.10 -c 5
ip netns exec test ping 10.1.1.11 -c 5

5. 在veth2上show neigh
ip netns exec test  ip neigh show

=============================================================================== 验证dhcp client
1. 在eth1上建立macvlan设备,获取地址
root# ip netns add dn1
root# ip link add eth1.mv1 link eth1 type macvlan
root# ip link set eth1.mv1 netns dn1
root# ip netns exec dn1 ip link set eth1.mv1 up
root# ip netns exec dn1 ip link show
root# ip netns exec dn1 ip addr show
root# ip netns exec dn1 dhclient -4 eth1.mv1 
root# ip netns exec dn1 ip addr show

2. ping 网关 192.168.30.254
root# ip netns exec dn1 ping 192.168.30.254 -c 5
root# ip netns exec dn1 ip neigh show
EOF
}



ip_i_link_macvtap(){ cat - <<'EOF'
    MACVTAP/IPVTAP是一个新的设备驱动，旨在简化虚拟化桥接网络。当一个MACVTAP/IPVTAP实例创建在物理接口之上时，
内核也会创建一个字符设备/dev/tapX，就像TUN/TAP设备一样，可以直接被KVM/QEMU使用。

通过MACVTAP/IPVTAP，可以用一个模块代替TUN/TAP和网桥驱动的组合。
ip link add link eth0 name macvtap0 type macvtap
EOF
}

ip_i_link_veth(){ cat - <<'EOF'
ip link add DEVICE type { veth | vxcan } [ peer name NAME ]

VETH(虚拟以太网)设备是一个本地以太网隧道。设备是成对创建的
当命名空间需要与主主机命名空间或彼此之间进行通信时，请使用 VETH 配置。

ip netns add ns1                                       创建ns1网络命名空间
ip link add veth-ns1 type veth peer name veth-ns1-br   添加veth-pair veth-ns1 <-> veth-ns1-br
ip link set veth-ns1 netns ns1                         将veth-ns1添加到网络命名空间ns1

1. veth pair 无法单独存在，删除其中一个，另一个也会自动消失。
2. 创建 veth pair 的时候可以自己指定它们的名字，比如 ip link add vethfoo type veth peer name vethbar 创建出来的两个名字就是 vethfoo 和 vethbar 
3. 如果未指定名字,使用系统自动生成的名字
4. 如果 pair 的一端接口处于 DOWN 状态，另一端能自动检测到这个信息，并把自己的状态设置为 NO-CARRIER。

link-netnsid
当veth pair被分别放到两个不同的netns后, 就会出现link-netnsid字段, 而这个字段与对端的netns相关.


linux下使用ip命令修改mac地址
ip link add veth01 addr ee:ee:ee:ee:ee:ee type veth peer name veth10 addr ee:ee:ee:ee:ee:ff

ip netns add net1
ip netns add net2
ip link add veth1 netns net1 type veth peer name veth2 netns net2

[Bridge = virtual switch]
Exemple: connect eth0 with two taps and one veth device
ip link add br0 type bridge
ip link set eth0 master br0
ip link set tap1 master br0
ip link set tap2 master br0
ip link set veth1 master br0
EOF
}

ip_i_link_tun_tap(){ cat - <<'EOF'
[是什么?]
tap/tun 虚拟网卡完全由软件来实现，功能和硬件实现完全没有差别，它们都属于网络设备，都可以配置IP，都归 Linux 网络设备管理模块统一管理。

[依赖什么?]
作为网络设备，tap/tun 也需要配套相应的驱动程序才能工作。tap/tun 驱动程序包括两个部分，一个是字符设备驱动，一个是网卡驱动。
这两部分驱动程序分工不太一样，字符驱动负责数据包在内核空间和用户空间的传送，网卡驱动负责数据包在 TCP/IP 网络协议栈上的传输和处理。

[驱动设备]
tap：/dev/tap0
tun：/dev/net/tun
充当了用户空间和内核空间通信的接口。
tap 是一个二层设备(或者以太网设备)，只能处理二层的以太网帧；
tun 是一个点对点的三层设备(或网络层设备)，只能处理三层的 IP 数据包。

[应用场景]
tun 设备充当了一层隧道，所以，tap/tun 最常见的应用也就是用于隧道通信，
比如 VPN，包括 tunnel 和应用层的 IPsec 等，其中比较有名的两个开源项目是 openvpn 和 VTun。
EOF
}

ip_i_link_tuntap(){ cat - <<'EOF'
https://github.com/generals-space/note-devops/blob/master/网络系统/虚拟网络/tap%26tun.md
tap = layer 2 (eth), tun = layer 3 (ip)

[tunctl] -- 老版本工具
Synopsis
tunctl [ OPTIONS ] [ -u owner ] [-g group] [ -t device-name ]
    -u 参数指定用户名，表明这个接口只受该用户控制，这个接口发生的事不会影响到系统的接口。
    -g 指定一组用户
    -t 指定要创建的 tap/tun 设备名。

[OPTIONS] 部分：
    -b 简单打印创建的接口名字
    -n 创建 tun 设备
    -p 创建 tap 设备，默认创建该设备
    -f tun-clone-device 指定 tun 设备对应的文件名，默认是 /dev/net/tun，有些系统是 /dev/misc/net/tun。
    -d interfacename 删除指定接口

默认创建 tap 接口：
tunctl
以上等价于 tunctl -p

为用户 user 创建一个 tap 接口：
# tunctl -u user

创建 tun 接口：
tunctl -n

为接口配置 IP 并启用：
# ifconfig tap0 192.168.0.254 up

为接口添加路由：
# route add -host 192.168.0.1 dev tap0

删除接口：
# tunctl -d tap0

[ip tuntap] -- 新版本工具
ip tuntap help

创建 tap/tun 设备：
ip tuntap add dev tap0 mod tap # 创建 tap 
ip tuntap add dev tun0 mod tun # 创建 tun

删除 tap/tun 设备：
ip tuntap del dev tap0 mod tap # 删除 tap 
ip tuntap del dev tun0 mod tun # 删除 tun
EOF
}
ip_i_link(){ cat - <<'EOF'
TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |
           bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |
           gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |
           vti | nlmon | team_slave | bond_slave | bridge_slave |
           ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |
           xfrm }
           
# http://www.jinbuguo.com/systemd/systemd.netdev.html
bond        将多个网卡(slave)聚合为一个绑定网卡。详见 Linux Ethernet Bonding Driver HOWTO 文档。
bridge      网桥是一个软交换机，每个 slave 以及 bridge 自身都是交换机的一个端口，端口之间能够互相转发数据包。
dummy       哑网卡只会简单的直接丢弃所有发送给它的数据包。
gre         跑在IPv4上的3层GRE(Generic Routing Encapsulation)隧道。详见 RFC 2784、浅析GRE协议
gretap      跑在IPv4上的2层GRE(Generic Routing Encapsulation)隧道。
erspan      ERSPAN 镜像(复制)一个或多个源端口上的流量然后将其转发到另一台交换机上的一个或多个目标端口。[译者注]主要用于流量的旁路监视与分析。 因为使用 GRE(Generic Routing Encapsulation) 封装， 所以镜像流量可以通过3层网络在源交换机与目的交换机之间进行路由。
ip6gre      跑在IPv6上的3层GRE(Generic Routing Encapsulation)隧道。
ip6tnl      跑在IPv6上的IPv4或IPv6隧道
ip6gretap   跑在IPv6上的2层GRE(Generic Routing Encapsulation)隧道。
ipip        跑在IPv4上的IPv4隧道
ipvlan      基于IP地址过滤规则从底层设备接收数据包的栈设备
macvlan     基于MAC地址过滤规则从底层设备接收数据包的栈设备
macvtap     基于MAC地址过滤规则从底层设备接收数据包的栈设备
sit         跑在IPv4上的IPv6隧道
tap         在一个网卡与另一个设备节点之间的持久2层隧道
tun         在一个网卡与另一个设备节点之间的持久3层隧道
veth        在一对网卡之间的以太网隧道(虚拟以太网)
vlan        基于VLAN标签过滤规则从底层设备接收数据包的栈设备(为普通以太帧带上"VLAN ID"标记)。详见 IEEE 802.1Q [译者推荐]图文并茂VLAN详解
vti         跑在IPSec上的IPv4隧道(思科私有技术)
vti6        跑在IPSec上的IPv6隧道(思科私有技术)
vxlan       虚拟可扩展局域网(利用UDP帧传递VXLAN封装的以太帧[Ethernet over UDP])用于云计算部署。[译者推荐]VXLAN简介、最好的VXLAN介绍
geneve      通用网络虚拟化封装(GEneric NEtwork Virtualization Encapsulation)设备。[译者推荐]网络虚拟化协议GENEVE
vrf         虚拟路由与转发(VRF)接口用于创建独立的路由与转发域
vcan        虚拟控制器局域网。像普通的 loopback 设备一样， vcan 也能提供一个虚拟的本地 CAN(ControllerArea Network) 接口。
vxcan       虚拟控制器局域网隧道。类似于虚拟以太网(veth)，vxcan 也在两个虚拟CAN网络设备(vcan)之间实现了一个本地CAN隧道。创建一个 vxcan 设备实际上会同时创建两个 vxcan 设备组成的设备对。任意一端接收到的数据包都将同时出现在另一端。 vxcan 可以用于在两个不同的名字空间之间通信。
wireguard   WireGuard 安全网络隧道。用来替代 OpenVPN, IPSec 的下一代开源VPN协议。[译者推荐]挖掘WireGuard的潜在功能及实际应用
netdevsim   一个网络设备模拟器。用于测试各种网络 API ，目前主要用于测试硬件减负(hardware offloading)相关接口。
fou         Foo-over-UDP 隧道

ip link help can    # can总线配置
ip link help bond   # bond接口
ip link help vlan   # 虚拟局域网                       man vlan
ip link help veth   # veth - Virtual Ethernet Device   man veth

ip link基本上只提供各种设备最基础的, 通用的设置, 更多具体的, 或是独有的操作需要用专门的工具完成.
比如对bridge的操作, ip link并不能提供管理vlan的操作(精确到端口), 以及对tag的管理.

ip link help
ip link add type bridge help

ip link show type             # 类型名称
ip link help can              # 帮助信息

通过ip link add xxx type 类型名称创建的网络接口, 好像没有明显的命令可以查看.
ip link add xxx type 类型名称 # 类型名称
ip link show type 类型名称
ip link add type bridge help  # 帮助信息 can vlan vxcan ifb

ip link add br0 type bridge                   # bridge
ip link add veth11 type veth peer name veth21 # veth

EOF
}

ip_t_link_vlan(){ cat - <<'EOF'
https://linux-blog.anracom.com/2017/10/30/fun-with-veth-devices-in-unnamed-linux-network-namespaces-i/


EOF
}
ip_t_link_vxlan(){ cat - <<'EOF'
VXLAN是一种二层隧道协议，通常与KVM等虚拟化系统配合使用，将运行在不同hypervisor节点上的虚拟机相互连接，并与外界连接。
与GRE或L2TPv3的点对点不同，VXLAN通过使用IP组播来复制多接入交换网络的一些特性。同时它还通过在传输帧的同时传输网络标识符，支持虚拟网络分离。
缺点是你需要使用组播路由协议，通常是PIM-SM，才能让它在路由网络上工作。
VXLAN的底层封装协议是UDP。

# Create a VXLAN link
ip link add name ${interface name} type vxlan \ 
   id <0-16777215> \ 
   dev ${source interface} \ 
   group ${multicast address

# Example:
ip link add name vxlan0 type vxlan \ 
   id 42 dev eth0 group 239.0.0.1

之后你需要把链路连接起来，用其他接口桥接或者分配一个地址。
EOF
}


ip_t_link_systemctl(){ cat - <<'EOF'
例 1. /etc/systemd/network/25-bridge.netdev
[NetDev]
Name=bridge0
Kind=bridge


例 2. /etc/systemd/network/25-vlan1.netdev
[Match]
Virtualization=no

[NetDev]
Name=vlan1
Kind=vlan

[VLAN]
Id=1

例 3. /etc/systemd/network/25-ipip.netdev
[NetDev]
Name=ipip-tun
Kind=ipip
MTUBytes=1480

[Tunnel]
Local=192.168.223.238
Remote=192.169.224.239
TTL=64


例 4. /etc/systemd/network/1-fou-tunnel.netdev
[NetDev]
Name=fou-tun
Kind=fou

[FooOverUDP]
Port=5555
Protocol=4
      


例 5. /etc/systemd/network/25-fou-ipip.netdev
[NetDev]
Name=ipip-tun
Kind=ipip
[Tunnel]
Independent=yes
Local=10.65.208.212
Remote=10.65.208.211
FooOverUDP=yes
FOUDestinationPort=5555
    
例 6. /etc/systemd/network/25-tap.netdev
[NetDev]
Name=tap-test
Kind=tap

[Tap]
MultiQueue=yes
PacketInfo=yes

例 7. /etc/systemd/network/25-sit.netdev
[NetDev]
Name=sit-tun
Kind=sit
MTUBytes=1480
[Tunnel]
Local=10.65.223.238
Remote=10.65.223.239

例 8. /etc/systemd/network/25-6rd.netdev
[NetDev]
Name=6rd-tun
Kind=sit
MTUBytes=1480

[Tunnel]
Local=10.65.223.238
IPv6RapidDeploymentPrefix=2602::/24

例 9. /etc/systemd/network/25-gre.netdev
[NetDev]
Name=gre-tun
Kind=gre
MTUBytes=1480

[Tunnel]
Local=10.65.223.238
Remote=10.65.223.239


例 10. /etc/systemd/network/25-vti.netdev
[NetDev]
Name=vti-tun
Kind=vti
MTUBytes=1480

[Tunnel]
Local=10.65.223.238
Remote=10.65.223.239


例 11. /etc/systemd/network/25-veth.netdev
[NetDev]
Name=veth-test
Kind=veth

[Peer]
Name=veth-peer


例 12. /etc/systemd/network/25-bond.netdev
[NetDev]
Name=bond1
Kind=bond

[Bond]
Mode=802.3ad
TransmitHashPolicy=layer3+4
MIIMonitorSec=1s
LACPTransmitRate=fast


例 13. /etc/systemd/network/25-dummy.netdev
[NetDev]
Name=dummy-test
Kind=dummy
MACAddress=12:34:56:78:9a:bc


例 14. /etc/systemd/network/25-vrf.netdev
创建一个 Table=42 的 VRF 接口
[NetDev]
Name=vrf-test
Kind=vrf

[VRF]
Table=42

例 15. /etc/systemd/network/25-macvtap.netdev
创建一个 MacVTap 设备
[NetDev]
Name=macvtap-test
Kind=macvtap
    
例 16. /etc/systemd/network/25-wireguard.netdev
[NetDev]
Name=wg0
Kind=wireguard

[WireGuard]
PrivateKey=EEGlnEPYJV//kbvvIqxKkQwOiS+UENyPncC4bF46ong=
ListenPort=51820

[WireGuardPeer]
PublicKey=RDf+LSpeEre7YEIKaxg+wbpsNV7du+ktR99uBEtIiCA=
AllowedIPs=fd31:bf08:57cb::/48,192.168.26.0/24
Endpoint=wireguard.example.com:51820

EOF
}


ip_t_link_add(){ cat - <<'EOF'
通过ip link add xxx type 类型名称创建的网络接口, 好像没有明显的命令可以查看.

EOF
}

ip_c_address_netifd(){ cat - <<'ip_c_address_netifd'
struct device_route {
    struct vlist_node node;
    struct interface *iface;

    bool enabled;
    bool keep;
    bool failed;

    union if_addr nexthop;
    int mtu;
    unsigned int type;
    unsigned int proto;
    time_t valid_until;

    /* must be last */
    enum device_addr_flags flags;
    int metric;                 /* there can be multiple routes to the same target */
    unsigned int table;
    unsigned int mask;
    unsigned int sourcemask;
    union if_addr addr;
    union if_addr source;
};

union if_addr {
    struct in_addr in;
    struct in6_addr in6;
};

struct device_addr {
    struct vlist_node node;
    bool enabled;
    bool failed;
    unsigned int policy_table;

    struct device_route subnet;

    /* ipv4 only */
    uint32_t broadcast;
    uint32_t point_to_point;

    /* ipv6 only */
    time_t valid_until;
    time_t preferred_until;
    char *pclass;

    /* must be last */
    enum device_addr_flags flags;
    unsigned int mask;
    union if_addr addr;
};

@ /usr/include/linux/if_addr.h
struct ifaddrmsg {
    __u8        ifa_family;
    __u8        ifa_prefixlen;	/* The prefix length		*/
    __u8        ifa_flags;	/* Flags			*/
    __u8        ifa_scope;	/* Address scope		*/
    __u32       ifa_index;	/* Link index			*/
};


ip_c_address_netifd
}

ip_c_neighbor_netifd(){ cat - <<'ip_c_neighbor_netifd'
union if_addr {
    struct in_addr in;
    struct in6_addr in6;
};

struct device_neighbor {
    struct vlist_node node;

    bool failed;
    bool proxy;
    bool keep;
    bool enabled;
    bool router;

    uint8_t macaddr[6];
    enum device_addr_flags flags;
    union if_addr addr;
};

@ /usr/include/linux/neighbour.h
struct ndmsg {
	__u8		ndm_family;
	__u8		ndm_pad1;
	__u16		ndm_pad2;
	__s32		ndm_ifindex;
	__u16		ndm_state;
	__u8		ndm_flags;
	__u8		ndm_type;
};
ip_c_neighbor_netifd
}

ip_c_route_netifd(){ cat - <<'ip_c_route_netifd'
enum device_addr_flags {
    /* address family for routes and addresses */
    DEVADDR_INET4 = (0 << 0),
    DEVADDR_INET6 = (1 << 0),
    DEVADDR_FAMILY = DEVADDR_INET4 | DEVADDR_INET6,

    /* externally added address */
    DEVADDR_EXTERNAL = (1 << 2),

    /* route overrides the default interface metric */
    DEVROUTE_METRIC = (1 << 3),

    /* route overrides the default interface mtu */
    DEVROUTE_MTU = (1 << 4),

    /* route overrides the default proto type */
    DEVROUTE_PROTO = (1 << 5),

    /* address is off-link (no subnet-route) */
    DEVADDR_OFFLINK = (1 << 6),

    /* route resides in different table */
    DEVROUTE_TABLE = (1 << 7),

    /* route resides in default source-route table */
    DEVROUTE_SRCTABLE = (1 << 8),

    /* route is on-link */
    DEVROUTE_ONLINK = (1 << 9),

    /* route overrides the default route type */
    DEVROUTE_TYPE = (1 << 10),

    /* neighbor mac address */
    DEVNEIGH_MAC = (1 << 11),
};

union if_addr {
    struct in_addr in;
    struct in6_addr in6;
};

struct device_route {
    struct vlist_node node;
    struct interface *iface;

    bool enabled;
    bool keep;
    bool failed;

    union if_addr nexthop;
    int mtu;
    unsigned int type;
    unsigned int proto;
    time_t valid_until;

    /* must be last */
    enum device_addr_flags flags;
    int metric;                 /* there can be multiple routes to the same target */
    unsigned int table;
    unsigned int mask;
    unsigned int sourcemask;
    union if_addr addr;
    union if_addr source;
};

@ /usr/include/rtnetlink.h
struct rtmsg {
    unsigned char   rtm_family;
    unsigned char   rtm_dst_len;
    unsigned char   rtm_src_len;
    unsigned char   rtm_tos;
        
    unsigned char   rtm_table;	/* Routing table id */
    unsigned char   rtm_protocol;	/* Routing protocol; see below	*/
    unsigned char   rtm_scope;	/* See below */	
    unsigned char   rtm_type;	/* See below	*/
    
    unsigned        rtm_flags;
};
ip_c_route_netifd
}

ip_c_rule_netifd(){ cat - <<'ip_c_rule_netifd'
struct iprule {
    struct vlist_node node;
    unsigned int order;

    /* to receive interface events */
    struct interface_user in_iface_user;
    struct interface_user out_iface_user;

    /* device name */
    char in_dev[IFNAMSIZ + 1];
    char out_dev[IFNAMSIZ + 1];

    /* everything below is used as avl tree key */
    /* do not change the order                   */

    /* uci interface name */
    char *in_iface;
    char *out_iface;

    enum iprule_flags flags;

    bool invert;

    unsigned int src_mask;
    union if_addr src_addr;

    unsigned int dest_mask;
    union if_addr dest_addr;

    unsigned int priority;
    unsigned int tos;

    unsigned int fwmark;
    unsigned int fwmask;

    unsigned int lookup;
    unsigned int sup_prefixlen;
    unsigned int action;
    unsigned int gotoid;
};

@ /usr/include/fib_rules.h
struct rtmsg {
    unsigned char   rtm_family;
    unsigned char   rtm_dst_len;
    unsigned char   rtm_src_len;
    unsigned char   rtm_tos;
        
    unsigned char   rtm_table;	/* Routing table id */
    unsigned char   rtm_protocol;	/* Routing protocol; see below	*/
    unsigned char   rtm_scope;	/* See below */	
    unsigned char   rtm_type;	/* See below	*/
    
    unsigned        rtm_flags;

};

FRA_DST, ... ... 

ip_c_rule_netifd
}

# veth
# link 
# vlandev
# tunnel
# gre
# vti
# xfrm
# vlan
ip_c_macvlan_netifd(){ cat - <<'ip_c_macvlan_netifd'
enum macvlan_opt {
    MACVLAN_OPT_MACADDR = (1 << 0),
};

static const struct {
    const char *name;
    enum macvlan_mode val;
} modes[] = {
    { "private", MACVLAN_MODE_PRIVATE },
    { "vepa", MACVLAN_MODE_VEPA },
    { "bridge", MACVLAN_MODE_BRIDGE },
    { "passthru", MACVLAN_MODE_PASSTHRU },
};

struct macvlan_config {
    const char *mode;

    enum macvlan_opt flags;
    unsigned char macaddr[6];
};

struct ifinfomsg {
	unsigned char	ifi_family;
	unsigned char	__ifi_pad;
	unsigned short	ifi_type;		/* ARPHRD_* */
	int		ifi_index;		/* Link index	*/
	unsigned	ifi_flags;		/* IFF_* flags	*/
	unsigned	ifi_change;		/* IFF_* change mask */
};



ip_c_macvlan_netifd
}

ip_i_address_add(){ cat - <<'ip_i_address_add'
ip address { add | change | replace } IFADDR dev IFNAME [ LIFETIME ] [ CONFFLAG-LIST ]
@ IFADDR
IFADDR := PREFIX | ADDR peer PREFIX [ broadcast ADDR ] [ anycast ADDR ] [ label LABEL ] [ scope SCOPE-ID ]
SCOPE-ID := [ host | link | global | NUMBER ]

@ LIFETIME
LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]
LFT := [ forever | SECONDS ]

@ CONFFLAG-LIST
CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG
CONFFLAG := [ home | mngtmpaddr | nodad | noprefixroute | autojoin ]

dev IFNAME 	                要添加地址的设备的名称。
local ADDRESS (default)     接口的地址。地址的格式取决于协议。对于IP，它是一个点分十进制；对于IPv6，它是冒分十六进制。 
                            ADDRESS后面可以跟一个斜线和一个十进制数字，用于编码网络前缀长度。
peer ADDRESS                点对点接口的远程端点的地址。同样，ADDRESS后面可以跟一个斜杠和一个十进制数，以编码网络前缀长度。
                            如果指定了对等地址，则本地地址不能具有前缀长度。网络前缀与对等方而不是与本地地址相关联。
broadcast ADDRESS           接口上的广播地址。 可以使用特殊符号"+"和"-"代替广播地址。 
                            在这种情况下，广播地址是通过设置/重置接口前缀的主机位派生出的。
label LABEL                 每个地址都可以用标签字符串标记。 为了保持与Linux-2.0网络别名的兼容性，此字符串必须与设备名称一致，
                            或者必须在设备名称前加上冒号。 标签的最大总长度为15个字符。
scope SCOPE_VALUE           该地址有效的范围。可用范围在文件/etc/iproute2/rt_scopes中列出。预定义的范围值是：
                            global----地址是全局有效的
                            site----(仅IPv6，已弃用)该地址是站点本地地址，即在此站点内有效。
                            link----地址是本地链接，即仅在此设备上有效。
                            host----地址仅在该主机内部有效
metric NUMBER               与地址关联的前缀路由的优先级，#  metric 值越小，优先级越高
valid_lft LFT               该地址的有效期限；请参阅RFC 4862的5.5.4节。当它到期时，该地址将被内核删除。默认为永远。
preferred_lft LFT           该地址的首选生存时间；请参阅RFC 4862的5.5.4节。到期后，该地址将不再用于新的传出连接。默认为永远。
home                        "仅IPv6"将此地址指定为RFC 6275中定义的"home address"。
nodad                       "仅IPv6"添加此地址时，不执行重复地址检测(RFC 4862)。
noprefixroute               不要为添加的地址的网络前缀自动创建路由，并且不要在删除地址时搜索要删除的路由。
                            更改地址以添加此标志，将删除自动添加的前缀路由，更改地址以删除此标志将自动创建前缀路由。
ip_i_address_add
}

ip_i_address_show(){ cat - <<'EOF'
ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ to PREFIX ] [ FLAG-LIST ] [ label PATTERN ] [ master DEVICE ] [ type TYPE ] [ vrf NAME ] [ up ] ]

SCOPE-ID := [ host | link | global | NUMBER ]
FLAG-LIST := [ FLAG-LIST ] FLAG
FLAG := [ [-]permanent | [-]dynamic | [-]secondary | [-]primary | [-]tentative | [-]deprecated | [-]dadfailed | [-]temporary | CONFFLAG-LIST ]

TYPE := [ bridge | bridge_slave | bond | bond_slave | can | dummy | hsr | ifb | ipoib | macvlan | macvtap | vcan | veth | vlan | vxlan | ip6tnl | ipip | sit | gre | gretap |erspan | ip6gre | ip6gretap | ip6erspan | vti | vrf | nlmon | ipvlan | lowpan | geneve | macsec ]

dev IFNAME (default)    设备名称。
scope SCOPE_VAL     仅列出具有此范围的地址。
to PREFIX           仅列出与此前缀匹配的地址。
label PATTERN       仅列出标签与PATTERN匹配的地址。 PATTERN是通常的shell样式模式。
master DEVICE       仅列出从属与主设备的接口。
vrf NAME            仅列出从属此vrf的接口。
type TYPE           只列出给定类型的接口。 请注意，不会根据支持的类型列表检查type名称-而是将其原样发送到内核。以后，如果内核尚未过滤它，则通过将其与相关属性进行比较来过滤返回的接口列表。因此，可以接受任何字符串，但可能会导致输出为空。
up 	                仅列出正在运行的接口。
dynamic             "仅IPv6"仅列出由于无状态地址配置而安装的地址。
-dynamic            等于permanen
permanen            "仅IPv6"仅列出永久(非动态)地址。
-permanent          等于dynamic
tentative           "仅IPv6"仅列出尚未通过重复地址检测的地址。
-tentative          "仅IPv6"仅列出当前不在重复地址检测过程中的地址。
deprecated          "仅IPv6"仅列出弃用的地址。
-deprecated         "仅IPv6"仅列出未弃用的地址。
dadfailed           "仅IPv6"仅列出重复地址检测失败的地址。
-dadfailed 	        "仅IPv6"仅列出重复地址检测没有失败的地址。
temporary           仅列出临时IPv6。secondary的别名。Linux内核为此共享一个位，因此尽管它们的含义因地址系列而异，但它们实际上是彼此的别名。
-temporary          primary的别名。
secondary           仅列出辅助IPv4地址 temporary的别名。Linux内核为此共享一个位，因此尽管它们的含义因地址系列而异，但它们实际上是彼此的别名。
-secondary          primary的别名
primary             仅列出主要地址，在IPv6中不包括临时地址。此标志是temporary和 secondary相反符号。
-primary            temporary和secondary的别名
EOF
}

# https://blog.csdn.net/u011857683/article/details/83795279
ip_i_route_select(){ cat - <<'ip_i_route_select'
路由表中的路由分为表态路由和动态路由?  
    动态路由协议  rip  ospf  bgp.
内核路由判断的依据?
    规则1  子网掩码长度越长越优先
    规则2  子网掩码长度一样的情况下，条目越靠前越优先
策略路由;  不同用户用不同的路由表

ip route    routing table management. Configuration files are:
            /etc/iproute2/ematch_map
            /etc/iproute2/group
            /etc/iproute2/rt_dsfield
            /etc/iproute2/rt_protos
            /etc/iproute2/rt_realms
            /etc/iproute2/rt_scopes
            /etc/iproute2/rt_tables

table TABLEID          --- rt_tables -> ip route list table 0   # 路由表参数来自  /etc/iproute2/rt_tables 文件
table to add this route. TABLEID may be a number or a string from the file /etc/iproute2/rt_tables. If this parameter is omitted, ip assumes table main, with exception of local, broadcast and nat routes, which are put to table local by default.
realm REALMID          --- rt_realms -> ip route list realms 0  # realms参数来自 /etc/iproute2/rt_realms 文件
the realm which this route is assigned to. REALMID may be a number or a string from the file /etc/iproute2/rt_realms.
tos TOS or dsfield TOS --- rt_dsfield -> ip route list dsfield 0 # dsfield 参数来自 /etc/iproute2/rt_dsfield 文件
Type Of Service (TOS) key. This key has no mask associated and the longest match is understood as first, compare TOS of the route and of the packet, if they are not equal, then the packet still may match to a route with zero TOS. TOS is either 8bit hexadecimal number or an identifier from /etc/iproute2/rt_dsfield.
scope SCOPE_VAL        --- rt_scopes -> ip route list scope 0    # 范围参数来自 /etc/iproute2/rt_scopes 文件
scope of the destinations covered by the route prefix. SCOPE_VAL may be a number or a string from the file /etc/iproute2/rt_scopes. If this parameter is omitted, ip assumes scope global for all gatewayed unicast routes, scope link for direct unicast routes and broadcasts and scope host for local routes.
protocol RTPROTO       --- rt_protos -> ip route list proto boot # 协议参数来自 /etc/iproute2/rt_protos 文件
routing protocol identifier of this route. RTPROTO may be a number or a string from the file /etc/iproute2/rt_protos. If the routing protocol ID is not given ip assumes the protocol is boot. IE. This route has been added by someone who does not understand what they are doing. Several of these protocol values have a fixed interpretation.

[路由缓存表] -> [路由表](先查策略表，根据策略表遍历路由表)

[路由缓存表]
    一个是缓存路由（fib），是自动学习生成自动管理的，用户没必要去干预，但是内核还是提供了方法让用户可以去清空它。
    以前的路由查找，只是单纯的根据目的ip地址来进行lpm匹配查询，而现在的策略路由支持根据其他的域，比如源地址，tos，来的端口等来决定匹配的策略（这些叫做selector）。
当然，路由表还是单纯的目的地址匹配，支持多种匹配的是路由策略（rule）。
    
但是用户不能设置它的项，但是可以根据这个缓存更新的原理从外部影响他。
[路由表] -> ip_i_route_table_default_local_main(五元组和优先级确定如何查路由项) -> ip_i_rule_route(五元组和优先级确定如何查路由表)
    我们自己添加了一个0，254，255之外的路由表之后，这个路由表也是不会正常的工作的，路由表只是数据库，查不查询，怎么查询是由路由策略决定的。
    
自己添加了路由表之后要想让这个路由表被查询，需要添加一个对应的路由策略。默认的路由策略都是lookup，就是我们通常意义的查询行为

[路由类型]
l 单播。目的地址是某一个ip，一般是手动添加的。
l 网段。这个是最常见的，到达某个网段需要从哪里发送出去
l Nat。是的，nat也是路由的一种，他会修改掉ip的地址域为要到达的地址。之所以nat也是路由的一种是因为，nat也是一种形式的路由。这个nat和iptable的nat是同时存在的两种不同的机制。
l Unreachable：不可达类型的路由。我们经常看到不可达，通常是因为没有配置到目的地址的路由，或者是配置的不对。但是还可以单独的配置一个不可达类型的路由，即使他是可达的。
l Prohibit：禁止类型的路由。到某个地址的路由默认都是添加的如何到达，但是也可以添加如何禁止。同样是到某个网段或地址的路由，可以在某个网口上设置其禁止，这个与实际的到不了不再一个层次。这个是查路由的时候路由表告诉你的这个网段是被禁止的。
l Blackhole：到达目标网段的所有数据包都可以查到，但是都会直接被丢弃。也就是这是一个欺骗的路由条目。你以为你查到了，你以为你发出去了，其实都被悄悄地丢掉了。

[路由表功能]
路由表存储了本地计算机可以到达的网络目的地址范围和如何到达的路由信息。路由表是TCP/IP通信的基础，本地计算机上的任何TCP/IP通信都受到路由表的控制。

[路由确定过程]
当TCP/IP需要向某个IP地址发起通信时，它会对路由表进行评估，以确定如何发送数据包。评估过程如下：
(1) TCP/IP使用需要通信的目的IP地址和路由表中每一个路由项的网络掩码进行相与计算，如果相与后的结果匹配对应路由项的网络地址，则记录下此路由项。
(2) 当计算完路由表中所有的路由项后，
  (a) TCP/IP选择记录下的路由项中的最长匹配路由（网络掩码中具有最多“1”位的路由项）来和此目的IP地址进行通信。
  (b) 如果存在多个最长匹配路由，那么选择具有最低跃点数的路由项。
  (c) 如果存在多个具有最低跃点数的最长匹配路由，那么：均根据最长匹配路由所对应的网络接口在网络连接的高级设置中的绑定优先级来决定(一般有线(eth0) > 无线 (wlan0) > 移动信号(4G))。
  (d) 如果优先级一致，则选择最开始找到的最长匹配路由。

[网关和接口确定过程]
             [ 本地主机 ]
在确定使用的路由项后，网关和接口通过以下方式确定：                  |         [ 转发主机 ]
(1) 如果路由项中的网关地址为空(*)或者为0.0.0.0，那么在发送数据包时：| (2) 如果路由项中的网关地址并不属于本地计算机上的任何网络接口，那么在发送数据包时：
    (a) 通过路由项中对应的网络接口发送；                            |     (a) 通过路由项中对应的网络接口发送；
    (b) 源IP地址为此网络接口的IP地址；                              |     (b) 源IP地址为路由项中对应网络接口的IP地址；
    (c) 源MAC地址为此网络接口的MAC地址；                            |     (c) 源MAC地址路由项中对应网络接口的MAC地址；
    (d) 目的IP地址为接收此数据包的目的主机的IP地址；                |     (d) 目的IP地址为接收此数据包的目的主机的IP地址；
    (e) 目的MAC地址为接收此数据包的目的主机的MAC地址；              |     (e) 目的MAC地址为网关的MAC地址；
ip_i_route_select
}


ip_t_route_select_tracert (){ cat - <<'ip_t_route_select_tracert'
wangfuli@XA097D:/home$ tracert www.baidu.com

通过最多 30 个跃点跟踪
到 www.a.shifen.com [14.215.177.39] 的路由:

  1     9 ms     1 ms     1 ms  172.23.4.1 
  2    <1 毫秒    1 ms     1 ms  10.99.100.254 
  3     3 ms     1 ms     2 ms  222.90.31.1 
  4     2 ms     3 ms     2 ms  10.224.29.33 
  5     3 ms     4 ms     4 ms  117.36.240.229 
  6     *        *        *     请求超时。
  7     *        *        *     请求超时。
  8    32 ms    40 ms     *     90.96.135.219.broad.fs.gd.dynamic.163data.com.cn [219.135.96.90] 
  9    33 ms    33 ms    33 ms  14.215.32.94 
 10     *        *        *     请求超时。
 11    34 ms    31 ms    31 ms  14.215.177.39 
ip_t_route_select_tracert
}
ip_t_route_select_traceroute (){ cat - <<'ip_t_route_select_traceroute'
root@ubuntu:/mnt/mdm9607_qmi/sdk_ubus_dial# traceroute www.baidu.com
traceroute to www.baidu.com (14.215.177.39), 30 hops max, 60 byte packets
 1  * * *
 2  172.23.4.1 (172.23.4.1)  1.870 ms  2.067 ms  2.271 ms
 3  10.99.100.254 (10.99.100.254)  1.914 ms  1.837 ms  1.788 ms
 4  222.90.31.1 (222.90.31.1)  2.915 ms  2.858 ms  2.765 ms
 5  10.224.29.29 (10.224.29.29)  2.647 ms 10.224.29.33 (10.224.29.33)  2.595 ms 10.224.29.25 (10.224.29.25)  2.533 ms
 6  1.85.253.65 (1.85.253.65)  3.667 ms 117.36.240.189 (117.36.240.189)  3.559 ms 1.85.253.93 (1.85.253.93)  6.368 ms
 7  202.97.36.101 (202.97.36.101)  43.810 ms  43.735 ms  43.698 ms
 8  * * *
 9  * 219.135.96.86 (219.135.96.86)  32.556 ms *
10  14.215.32.90 (14.215.32.90)  42.160 ms 219.135.96.86 (219.135.96.86)  31.697 ms  40.573 ms
11  14.215.32.106 (14.215.32.106)  37.462 ms * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *
ip_t_route_select_traceroute
}

# https://www.cnblogs.com/EasonJim/p/8424731.html
ip_i_route_select_traceroute (){ cat - <<'ip_i_route_select_traceroute'
[traceroute 命令形式]
命令格式：traceroute [参数] [主机]
命令功能：traceroute 指令让你追踪网络数据包的路由途径，预设数据包大小是 40Bytes，用户可另行设置。

具体参数格式：traceroute [-dFlnrvx][-f<存活数值>][-g<网关>...][-i<网络界面>][-m<存活数值>][-p<通信端口>][-s<来源地址>][-t<服务类型>][-w<超时秒数>][主机名称或IP地址][数据包大小]
命令参数：
-d 使用Socket层级的排错功能，
-f 设置第一个检测数据包的存活数值TTL的大小，
-F 设置勿离断位，
-g 设置来源路由网关，最多可设置8个，
-i 使用指定的网络界面送出数据包，
-I 使用ICMP回应取代UDP资料信息，
-m 设置检测数据包的最大存活数值TTL的大小，
-n 直接使用IP地址而非主机名称。
-p 设置UDP传输协议的通信端口，
-r 忽略普通的Routing Table，直接将数据包送到远端主机上，
-s 设置本地主机送出数据包的IP地址，
-t 设置检测数据包的TOS数值。
-v 详细显示指令的执行过程，
-w 设置等待远端主机回报的时间，
-x 开启或关闭数据包的正确性检验。

[traceroute 命令实例]
[root@localhost ~]# traceroute www.baidu.com
traceroute to www.baidu.com (61.135.169.125), 30 hops max, 40 byte packets
1 192.168.74.2 (192.168.74.2)       2.606 ms 2.771 ms 2.950 ms                                   # 每跳表示一个网关，我们看到每行有三个时间，单位是 ms，其实就是 -q 的默认参数。
2 211.151.56.57 (211.151.56.57)     0.596 ms 0.598 ms 0.591 ms
3 211.151.227.206 (211.151.227.206) 0.546 ms 0.544 ms 0.538 ms
4 210.77.139.145 (210.77.139.145)   0.710 ms 0.748 ms 0.801 ms
5 202.106.42.101 (202.106.42.101)   6.759 ms 6.945 ms 7.107 ms
6 61.148.154.97 (61.148.154.97)     718.908 ms * bt-228-025.bta.net.cn (202.106.228.25) 5.177 ms
7 124.65.58.213 (124.65.58.213)     4.343 ms 4.336 ms 4.367 ms
8 202.106.35.190 (202.106.35.190)   1.795 ms 61.148.156.138 (61.148.156.138) 1.899 ms 1.951 ms
9 * * *                                                                                          # 防火墙封掉了ICMP 的返回信息，所以我们得不到什么相关的数据包返回数据。
30 * * *

[traceroute 实例输出说明]
1. 记录按序列号从1开始，每个纪录就是一跳 ，每跳表示一个网关，我们看到每行有三个时间，单位是 ms，其实就是 -q 的默认参数。
2. 探测数据包向每个网关发送三个数据包后，网关响应后返回的时间；如果您用 traceroute -q 4 www.58.com ，表示向每个网关发送4个数据包。
3. 有时我们 traceroute 一台主机时，会看到有一些行是以星号表示的。出现这样的情况，可能是防火墙封掉了ICMP 的返回信息，所以我们得不到什么相关的数据包返回数据。
4. 有时我们在某一网关处延时比较长，有可能是某台网关比较阻塞，也可能是物理设备本身的原因。
   当然如果某台 DNS 出现问题时，不能解析主机名、域名时，也会 有延时长的现象；
   您可以加-n 参数来避免DNS解析，以IP格式输出数据。
5. 如果在局域网中的不同网段之间，我们可以通过 traceroute 来排查问题所在，是主机的问题还是网关的问题。
   如果我们通过远程来访问某台服务器遇到问题时，我们用到traceroute 追踪数据包所经过的网关，提交IDC服务商，也有助于解决问题；
   但目前看来在国内解决这样的问题是比较困难的，就是我们发现问题所在，IDC服务商也不可能帮助我们解决。

[原理说明] UDP(TTL) 发出， 
Traceroute 程序的设计是利用 ICMP 及 IP header 的 TTL（Time To Live）栏位（field）。
    首先，traceroute 送出一个 TTL 是 1 的 IP datagram（其实，每次送出的为3个40字节的包，包括源地址，目的地址和包发出的时间标签）到目的地，
当路径上的第一个路由器（router）收到这个datagram 时，它将TTL减1。此时，TTL变为0了，所以该路由器会将此 datagram 丢掉，
并送回一个"ICMP time exceeded"消息（包括发IP包的源地址，IP包的所有内容及路由器的IP地址），traceroute 收到这个消息后，便知道这个路由器存在于这个路径上。
    接着，traceroute 再送出另一个TTL 是 2  的datagram，发现第2 个路由器...... 
    然后，traceroute  每次将送出的 datagram 的 TTL  加1来发现另一个路由器，这个重复的动作一直持续到某个datagram 抵达目的地。
当datagram到达目的地后，该主机并不会送回ICMP time exceeded消息，因为它已是目的地了，那么traceroute如何得知目的地到达了呢？

    Traceroute 在送出 UDP datagrams 到目的地时，它所选择送达的 port number 是一个一般应用程序都不会用的号码（30000 以上），所以当此 UDP datagram 到达目的地后该主机会送回一个"ICMP port unreachable"的消息，
而当traceroute 收到这个消息时，便知道目的地已经到达了。
ip_i_route_select_traceroute
}


# https://blog.csdn.net/u011857683/article/details/83795279
ip_i_route_output(){ cat - <<'ip_i_route_output'
Destination 目标网络或目标主机。Destination 为 default（0.0.0.0）时，表示这个是默认网关，所有数据都发到这个网关。
Gateway     网关地址，          0.0.0.0 表示当前记录对应的 Destination 跟本机在同一个网段，通信时不需要经过网关。如果没有就显示星号(*)。
Genmask     Destination 字段的网络掩码，Destination 是主机时需要设为 255.255.255.255，是默认路由时会设置为 0.0.0.0
Flags       标记
    ● U 该路由可以使用。
    ● H 该路由是到一个主机，也就是说，目的地址是一个完整的主机地址。如果没有设置该标志，说明该路由是到一个网络，而目的地址是一个网络地址：一个网络号，或者网络号与子网号的组合。
    ● G 该路由是到一个网关（路由器）。如果没有设置该标志，说明目的地 是直接相连的。
    ● R 恢复动态路由产生的表项。
    ● D 该路由是由改变路由（redirect）报文创建的。
    ● M 该路由已被改变路由报文修改。
    ● ! 这个路由将不会被接受。
Metric      路由距离，到达指定网络所需的中转数，是大型局域网和广域网设置所必需的。
Ref         路由项引用次数 。
Use         此路由项被路由软件查找的次数。
Iface       网卡名字，例如 eth0。

[Destination]
(1) 网络地址（Network Destination）、网络掩码（Netmask）
    网络地址和网络掩码相与的结果用于定义本地计算机可以到达的目的网络地址范围。通常情况下，目的网络地址范围包含以下四种：
    (a) 主机地址，某个特定主机的网络地址，网络掩码为255.255.255.255，如上表中的4。
    (b) 子网地址，某个特定子网的网络地址，如上表中的5。
    (c) 网络地址，某个特定网络的网络地址，如上表中的2，3。
    (d) 默认路由，所有未在路由表中指定的网络地址，如上表中的1。

主机路由：机路由是路由选择表中指向单个IP地址或主机名的路由记录。主机路由的Flags字段为H。
网络路由：网络路由是代表主机可以到达的网络。网络路由的Flags字段为N。
默认路由：当主机不能在路由表中查找到目标主机的IP地址或网络路由时，数据包就被发送到默认路由（默认网关）上。默认路由的Flags字段为G

[Gateway]
(2) 网关（Gateway，又称为下一跳服务器）
    在发送IP数据包时，网关定义了针对特定的网络目的地址，数据包发送到的下一跳服务器。
    如果是本地计算机直接连接到的网络，网关通常是0.0.0.0。
    如果是远程网络或默认路由，网关通常是本地计算机所连接到的网络上的某个服务器或路由器。

[Iface]
(3) 接口（Interface）
接口定义了针对特定的网络目的地址，本地计算机用于发送数据包的网络接口。

[Metric]
(4) 跃点数（Metric）
跃点数用于指出路由的成本，通常情况下代表到达目标地址所需要经过的跃点数量，一个跃点代表经过一个路由器。跃点数越低，代表路由成本越低；
跃点数越高，代表路由成本越高。当具有多条到达相同目的网络的路由项时，TCP/IP会选择具有更低跃点数的路由项。

Seq     Destination     Gateway     Genmask          Flags   Metric  Ref     Use     Iface
1       0.0.0.0         192.168.1.1 0.0.0.0          UG      0       0       0       eth0
2       169.254.0.0     0.0.0.0     255.255.0.0      U       1002    0       0       eth0
3       192.168.1.0     0.0.0.0     255.255.255.0    U       0       0       0       eth0
4       192.168.1.1     0.0.0.0     255.255.255.255  U       0       0       0       eth0
5       192.168.0.0     0.0.0.0     255.255.254.0    U       0       0       0       eth0
6       192.168.2.0     192.168.2.1 255.255.255.0    U       0       0       0       eth1


(1) 和单播IP地址 192.168.1.8 的通信
在进行相与计算时，1、3、5 项匹配，但是3项为最长匹配路由，因此选择3项。3项的网关地址为0.0.0.0，
因此发送数据包时，目的IP地址为 192.168.1.8、目的MAC地址为192.168.1.8的MAC地址（通过ARP解析获得）。

(2) 和单播IP地址 192.168.1.1 的通信
在进行相与计算时，1、3、4、5 项匹配，但是4项为最长匹配路由，因此选择4项。4项的网关地址为0.0.0.0，
因此发送数据包时，目的IP地址为 192.168.1.1、目的MAC地址为192.168.1.1的MAC地址（通过ARP解析获得）。

(3) 和单播IP地址 192.168.22.8 的通信
在进行相与计算时，只有 1 项匹配；在发送数据包时，目的IP地址为192.168.22.8、目的MAC地址为192.168.1.1的MAC地址（通过ARP解析获得）。
 
(4) 和子网广播地址 192.168.1.255 的通信
在进行相与计算时，1、3、5 项匹配，但是3项为最长匹配路由，因此选择3项。3项的网关地址为0.0.0.0，
因此在发送数据包时，目的IP地址为 192.168.1.255，目的MAC地址为以太网广播地址FF:FF:FF:FF:FF:FF。

ip_i_route_output
}

ip_i_tcp_metrics(){ cat - <<'ip_i_tcp_metrics'
用于操作Linux内核中保存IPv4和IPv6目的地TCP信息的条目。
当TCP套接字想要共享目的地的信息时，这些条目就会被创建，并存储在由目的地地址键入的缓存中。
保存的信息可能包括度量值（最初从路由中获得）、用于TIME-WAIT回收目的的最近TSVAL、快速打开功能的状态等。
出于性能的原因，缓存不能超过配置的限制，旧的条目会被新鲜的信息所取代，有时会被回收并用于新的目的地。内核永远不会删除条目，它们只能通过这个工具来刷新。
输入 ip tcp_metrics show 来显示缓存条目 
ip_i_tcp_metrics
}

ip_t_route_advance(){ cat - <<'EOF'
1. 什么是高级路由？ 是把信息从源穿过网络到达目的地的行为. 有两个动作：确定最佳路径，传输信息 
确定最佳路径：手工指定，自动学习。 
传输信息：隧道传输，流量整形 
高级路由(策略路由)是根据一定的需要定下一些策略为依据。 
rpdb(routing policy data base)通过一定的规则进行路由.

2.什么是多路由表及规则？
(1) 多路由表用来等待匹配，默认有四张路由表 
 255 是本地路由表 
 254 主路由表 没有指明表所属位置 都放在这里
 253 默认路由表 
 0 系统保留的表
(2)规则
 rpdb可以匹配数据包的源地址 目的地址 进入接口
 每一个路由
动作 选择下一跳地址， 产生通讯时被

3.ip
 ip link show 显示所有的网络设备
 ip address show 
 ip route show table 255 显示指定编号的表
 ip rule 定义规则
 ip rule add from 192.168.2.1／32 table 1 从192.168.2.1的包按照1的表进行匹配
 ip rule show 显示规则 
 ip rule add from 192.168.2.1／24 pref 1000 prohibit 从192.168.2.1的包返回不可达
 ip rule del pref 32764 删除规则
 ip route add 192.168.2.0／24 via 202.96.156.111 table 1 访问外网
例如 
 ip rule add 192.168.2.1 table 1 pref 1000
 ip rule add 192.168.2.2 table 1 pref 1005
 ip rule add 192.168.2.3 table 1 pref 1010
 ip rule add 192.168.2.0/24 table 2 pref 1015
 ip route add 192.168.2.0/24 via 2M table 1
 ip route add 192.168.2.0/24 via 1M table 2
 
 ip route add default via 192.168.1.1 table 2 proto statc 设置默认网关 
 ip route flush cache 刷新表1的缓存
 ip route flush table 1 清空表 
 负载均衡 1M 2M 
 ip route add default scope global nexthop via ip1 dev eth0 weight 1 nexthop via ip2 dev eth1 weight 1 #第一跳eth0 第二跳eth1 第三跳 eth0 。。。。。。。。 ip route add default scope global nexthop via ip1 dev eth0 weight 2 nexthop via ip2 dev eth1 weight 1 第一跳eth0分2／3 第二条eth1 1／3

 4.IP 隧道 (ip-ip)
 一层 ip－ip
 二层 GRE
 三层 ipsec ｛加密(ESP)，认证(AH)，协商(IKE)｝
 隧道模式 主机包头－－AH－－ESP－－数据
 传输模式 安全网关头部－－AH－－ESP－－主机头｜数据 (VPN) 
 NtoN 虚拟处于一个局域网中

EOF
}

ip_t_addresss(){ cat - <<'EOF'
详细说明请连接到下面链接： http://www.turbolinux.com.cn/turbo/wiki/doku.php?id=网络管理:traffic-control
@ man ip-addresss 进一步思考
    在本节中，${address}值应该是点阵十进制格式的主机地址，${mask}可以是点阵十进制子网掩码，也可以是前缀长度。
也就是说，192.0.2.10/24和192.0.2.10/255.255.255.0都同样可以接受。
如果你不确定某些东西是否是正确的主机地址，请使用 "ipcalc "或类似的程序来检查。

address 地址管理相关参数：
local ADDRESS           协议地址,如192.168.1.100/24。 
peer ADDRESS            使用点对点连接时对端的协议地址。 
broadcast ADDRESS       协议广播地址，可以简写成brd。 
label NAME              地址标志。 
scope SCOPE_VALUE           地址范围，可能的值有： 
    global：                说明该地址全局有效； 
    site：                  说明该地址只在本地站点内有效，该值只在ipv6中使用； 
    link：                  只在该网络设备上有效； 
    host：                  只在该主机上有效；

    ### Show all addresses
    ip address show
    # Show addresses for a single interface
    ip address show ${interface name} 
    ip address show eth0
    # Show addresses only for running interfaces
    ip address show up
    
    ### Show only static or dynamic IPv6 addresses
    ip address show [dev ${interface}] permanent
    ip address show [dev ${interface}] dynamic
    
    ### add
    ip address add ${address}/${mask} dev ${interface name}
    ip address add 192.0.2.10/27 dev eth0
    ip address add 2001:db8:1::/48 dev tun10
    
    ip a add 192.168.1.200/255.255.255.0 dev eth0
    ip a add 192.168.1.200/24 dev eth0
    
    ### Add an address with human-readable description
    ip address add ${address}/${mask} dev ${interface name} label ${interface name}:${description} 
    ip address add 192.0.2.1/24 dev eth0 label eth0:my_wan_address	
    
    
    ### Delete 
    ip address delete ${address}/${prefix} dev ${interface name}
    ip address delete 192.0.2.1/24 dev eth0
    ip address delete 2001:db8::1/64 dev tun1
    
    ### Remove all addresses from an interface
    ip address flush dev ${interface name}
    ip address flush dev eth0 scope global|host|link
    ip address flush dev eth1
    
    ip -4 addr flush label "ppp*"
    ip -4 addr flush label "eth*"
    
# Adding the broadcast address on the interface
ip addr add brd {ADDDRESS-HERE} dev {interface}
ip addr add broadcast {ADDDRESS-HERE} dev {interface}
ip addr add broadcast 172.20.10.255 dev dummy0

# 在本例中，将地址192.168.1.50，网罩255.255.255.0(/24)，标准广播，标签 "eth0Home "添加到接口eth0。
ip addr add 192.168.1.50/24 brd + dev eth0 label eth0Home

# You can set loopback address to the loopback device lo as follows:
ip addr add 127.0.0.1/8 dev lo brd + scope host
EOF
}

ip_t_route_config(){ cat - <<'EOF'
Keys used for hash table lookups during route selection
route cache	        RPDB	        route table
destination	        source	        destination
source	            destination	    ToS
ToS	                ToS	            scope
fwmark	            fwmark	        oif
iif	                iif

1. ip route show cache
2. ip rule show
3. ip route show  
3.1 ip route show table local
3.2 ip route show table main 
3.3 ip route show table default 
3.4 ip route show table all
3.5 ip route show table NUMBER
EOF
}

ip_i_route_desc(){ cat - <<'EOF'
1. 路由概念
路由：   跨越从源主机到目标主机的一个互联网络来转发数据包的过程
路由器：能够将数据包转发到正确的目的地，并在转发过程中选择最佳路径的设备
路由表：在路由器中维护的路由条目，路由器根据路由表做路径选择

直连路由：当在路由器上配置了接口的IP地址，并且接口状态为up的时候，路由表中就出现直连路由项
静态路由：是由管理员手工配置的，是单向的。
默认路由：当路由器在路由表中找不到目标网络的路由条目时，路由器把请求转发到默认路由接口

2. 静态路由和默认路由的特点
静态路由特点:
  路由表是手工设置的；除非网络管理员干预，否则静态路由不会发生变化；
  路由表的形成不需要占用网络资源；
  适用环境：一般用于网络规模很小、拓扑结构固定的网络中。
默认路由特点:
  在所有路由类型中，默认路由的优先级最低
  适用环境：一般应用在只有一个出口的末端网络中或作为其他路由的补充
浮动静态路由：
  路由表中存在相同目标网络的路由条目时，根据路由条目优先级的高低，将请求转发到相应端口；链路冗余的作用；
  
3 路由器转发数据包时的封装过程
  源IP和目标IP不发生变化，在网络的每一段传输时，源和目标MAC发生变化，进行重新封装，分别是每一段的源和目标地址
  
4. 要完成对数据包的路由，一个路由器必须至少了解以下内容：
  a) 目的地址
  b) 相连路由器，并可以从哪里获得远程网络的信息
  c) 到所有远程网络的可能路由
  d) 到达每个远程网络的最佳路由
  e) 如何维护并验证路由信息
5. 路由和交换的对比
  路由工作在网络层
    a)根据路由表转发数据
    b)路由选择
    c)路由转发
  交换工作在数据链路层
    d)根据MAC地址表转发数据
    e)硬件转发
6. 三种路由类型说明
a. 主机路由
主机路由是路由选择表中指向单个IP地址或主机名的路由记录。主机路由的Flags字段为H。例如，
在下面的示例中，本地主机通过IP地址192.168.1.1的路由器到达IP地址为10.0.0.10的主机。
Destination    Gateway       Genmask          Flags     Metric    Ref    Use    Iface
-----------    -------     -------            -----     ------    ---    ---    -----
10.0.0.10     192.168.1.1    255.255.255.255   UH          0       0      0    eth0

b. 网络路由
网络路由是代表主机可以到达的网络。网络路由的Flags字段为N。例如，在下面的示例中，本地主
机将发送到网络192.19.12的数据包转发到IP地址为192.168.1.1的路由器。
Destination    Gateway       Genmask         Flags    Metric    Ref     Use    Iface
-----------    -------       -------         -----    -----      ---     ---    -----
192.19.12     192.168.1.1    255.255.255.0    UN       0         0       0    eth0

c. 默认路由
当主机不能在路由表中查找到目标主机的IP地址或网络路由时，数据包就被发送到默认路由(默认
网关)上。默认路由的Flags字段为G。例如，在下面的示例中，默认路由是IP地址为192.168.1.1的
路由器。
Destination    Gateway       Genmask    Flags     Metric    Ref    Use    Iface
-----------    -------        -------   -----     ------    ---    ---    -----
  default     192.168.1.1     0.0.0.0    UG          0        0     0      eth0

7. 配置路由route的命令
route  [add|del] [-net|-host] target [netmask Nm] [gw Gw] [[dev] If]
参数解释：
add           添加一条路由规则
del           删除一条路由规则
-net          目的地址是一个网络
-host         目的地址是一个主机
target        目的网络或主机
netmask       目的地址的网络掩码
gw            路由数据包通过的网关
dev           为路由指定的网络接口

ip route show                # 路由规则表
ip route show cache          # 路由缓存表
ip route show table [local|main|default|main]  # 显示指定路由表规则
ip route get 192.168.0.0/16  # 指定IP或网段使用的路由规则

a. 添加主机路由
# route add -host 192.168.1.2 dev eth0:0
# route add -host 10.20.30.148 gw 10.20.30.40
ip route add 192.168.1.2 dev eth0:0
ip route add 10.20.30.148 via 10.20.30.40

b. 添加网络路由
# route add -net 10.20.30.40 netmask 255.255.255.248 eth0
# route add -net 10.20.30.48 netmask 255.255.255.248 gw 10.20.30.41
# route add -net 192.168.1.0/24 eth1
ip route add 10.20.30.40/30 dev eth0
ip route add 10.20.30.48/30 via 10.20.30.41
 
c. 添加默认路由
# route add default gw 192.168.1.1
ip route add default via 192.168.1.1

d. 配置linux系统
添加一条默认路由
# route add default gw 10.0.0.1      //默认只在内存中生效
开机自启动可以追加到/etc/rc.local文件里
# echo "route add default gw 10.0.0.1" >>/etc/rc.local
添加一条静态路由
# route add -net 192.168.2.0/24 gw 192.168.2.254
要永久生效的话要这样做：
# echo "any net 192.168.2.0/24 gw 192.168.2.254" >>/etc/sysconfig/static-routes
添加到一台主机的静态路由
# route add -host 192.168.2.2 gw 192.168.2.254
要永久生效的话要这样做：
# echo "any  host 192.168.2.2 gw 192.168.2.254 " >>/etc/sysconfig/static-routes
注：Linux 默认没有这个文件 ，得手动创建一个
EOF
}

ip_i_route_table_default_local_main(){ cat - <<'EOF'
http://linux-ip.net/html/routing-tables.html
路由表：一共有256个，在内核中是一个数组，可以配置让内核使用其中的一个或者多个。

#
# reserved values
#
255     local      1
254     main       2
253     default    3
0       unspec     4
#
# local
#
1      inr.ruhep   5


linux可以自定义从1－252个路由表，
linux系统维护了4个路由表：
0表 系统保留表
 
255  local 本地路由表，存有本地接口地址，广播地址，以及NAT地址。 local表由系统自动维护，管理员不能操作此表。
254  main 主路由表，传统路由表,ip route若没指定表即操作表254。注:平时用route查看的亦是此表设置的路由。
253  default  默认路由表一般存放默认路由。 注：rt_tables文件中表以数字来区分表，保留最多支持255张表。
     

分别是 local main default
优先级依次从高到低。
规则0: 优先级 0           选择器 = 匹配任何数据报, 动作＝察看本地路由表(routing table local)，ID为255。local表是保留路由表，
                          包含了到本地和广播地址的路由。规则0是特殊的规则，不可被删除或修改。
规则 32766: 优先级 32766  选择器 = 匹配所有数据报, 动作 = 察看主路由表(routing table main)， ID为254。 main路由表是默认
                          的标准路由表，其包含所有非策略路由，main表是存放旧的路由命令(route命令)创建的路由。而且任何由
                          ip route命令创建的没有明确指定路由表的路由都被加入到该路由表中。该规则不能被删除和被其他规则覆盖。
规则 32767: 优先级 32767  选择器 = 匹配所有数据报, 动作 = 察看默认路由表(routing table default)，ID为253。default路由表是空的，
                          为最后处理(post-processing)所预留，若前面的默认规则没有选择该数据报时保留用作最后的处理。该规则可以被删除。
进行路由时，正是根据路由规则来进行匹配，按优先级(pref后数值)从高到低匹配,直到找到合适的规则.所以在应用中配置默认路由是必要的。
EOF
}

ip_t_route_prefix_tos_preference(){ cat - <<'EOF'
linux中有0~255共256张路由表。其中0号表示unspec(未指定)，253，254，255分别表示default、main、local表。
除了以上4张表外的其他表都是留给用户指定的表。现在就说下以上5张系统表的作用。
    首先是0号表unspec。这张表可以理解成所有路由表的总和，也就是说所有路由表中的路由条目在这个表中都会
有一条相对应。这样如果想看看系统中所有路由表的路由条目就可以看这张表。当然对这张表中的路由条目操作也
等同于对其他表中对应的路由条目操作，因此可要小心千万别清空这个路由表，否则所有的路由条目就全都消失了。
    接着是main表。这个表就是最主要的路由表了，默认下系统添加路由都是添加到这个表里边。
    local表，这个存放所有的local范围的路由条目，也就是到达本地地址的路由了。
    
    If several routes match to the packet, the following pruning rules are used to select the best one:
1. The longest matching prefix is selected, all shorter ones are dropped.
2. If the TOS of some route with the longest prefix is equal to TOS of the packet then routes with different TOS are dropped.
3. If no exact TOS match was found and routes with TOS=0 exist, the rest of the routes are pruned. Otherwise the route lookup fails.
4. If several routes remain after steps 1-4 have been tried then routes with the best preference value are selected.
5. If we still have several routes then the first of them is selected.
Route attributes:
output device and next hop router
path MTU or the preferred source address
Route types:
unicast ---
unreachable --- ICMP Type 3 Code 1 | EHOSTUNREACH
blackhole ---   discarded          | EINVAL
prohibit ---    ICMP Type 3 Code 13 | EACCES
local ---       looped back and delivered locally
broadcast ---   the destinations are broadcast addresses, the packets are sent as link broadcasts
throw ---       ICMP Type 3 Code 0 | ENETUNREACH
nat ---         special NAT route.
anycast ---     (not implemented)
multicast ---   special type, used for multicast routing. It does not present in normal routing tables.

Route tables:
/etc/iproute2/rt_tables
EOF
}
ip_t_route(){ cat - <<'EOF'
    ${address}指的是点阵十进制格式的子网地址，${mask}指的是前缀长度或点阵十进制格式的子网掩码。也就是说，
192.0.2.0/24和192.0.2.0/255.255.255.0都同样可以接受。
    注意：按照下面的章节，如果你设置了一条静态路由，而它因为接口宕机而变得毫无用处，那么它就会被删除，再也无法自行恢复。
你可能没有注意到这种行为，因为在很多情况下，额外的软件(如NetworkManager或rp-pppoe)会负责恢复与接口相关的路由。
    如果你打算把你的Linux机器用作路由器，可以考虑安装一个路由协议栈套件，如Quagga或BIRD。它们作为路由控制平面，
保存配置好的路由，并在一般情况下在链路故障后正常恢复，还提供动态路由协议（如OSPF和BGP）功能。
    有些路由在系统中出现时没有明确的配置(违背你的意愿)。
Route管理相关参数：
to PREFIX           路由的目标前缀(prefix)
metric NUMBER       定义路由的优先值，NUMBER是任意32位数字  # metric 值越小，优先级越高
table TABLEID       路由要加入的表
dev NAME            输出设备的名字
via ADDRESS         指定下一跳路由器的地址
src ADDRESS         在向目的prefix发送数据包时选择的源地址
realm REALMID       指定路由分配的realm
mtu MTU             设置到达目的路径的最大传输单元(MTU)
window NUMBER       设置到目的地址TCP连接的最大窗口值，以字节为单位
rtt NUMBER          估算初始往返时间(Round Trip Time)
rttvar NUMBER       估算初始往返时间偏差(RTT variance) 
ssthresh NUMBER     估算慢启动阀值(slow start threshould) 
cwnd NUMBER         把拥挤窗口(congestion window)值锁定为NUMBER
advmss NUMBER       设置在建立TCP连接时，向目的地址声明的最大报文段大小,如果没有设置，Linux内核会使用计算第一跳的最大传输单元得到的数值。 
nexthop NEXTHOP     设置多路径路由的下一跳地址
via ADDRESS         表示下一跳路由器
scope SCOPE_VAL     路由前缀(prefix)覆盖的范围
protocol RTPROTO    本条路由得路由协议识别符

[查看]
  ### View all
  # 显示命令接受-4和-6选项，可以只查看IPv4或IPv6路由。如果没有给出选项，则显示IPv4路由。要查看IPv6路由。
  ip route
  ip route show
  ip -6 route

  ### View routes to a network and all its subnets‘ # 子网的路由
  # 查看网络及其所有子网的路由。
  ip route show to root ${address}/${mask}
  # 例如，如果你的网络中的一部分使用192.168.0.0/24子网，并且它被分解成192.168.0.0/25和192.168.0.128/25，
  ip route show to root 192.168.0.0/24
    
  ### View routes to a network and all supernets # 超级网络的路由
  # 查看到一个网络和所有超级网络的路由
  ip route show to match ${address}/${mask}
  ip route show to match 192.168.0.0/24
  # 由于路由器更倾向于选择更具体的路由，而不是更不具体的路由，因此，当发送到特定子网的流量因为缺少通往该子网的路由而发送错误，但存在通往更大子网的路由时，这对调试非常有用。
  
  ### View routes to exact subnet
  # 如果你想查看到192.168.0.0/24的路由，但不想查看到192.168.0.0/25和192.168.0.0/16的路由，你可以使用。
  ip route show to exact ${address}/${mask}
  If you want to see the routes to 192.168.0.0/24, but not to, say 192.168.0.0/25 and 192.168.0.0/16, you can use:
  ip route show to exact 192.168.0.0/24
    
  ### View only the route actually used by the kernel
  # 只查看内核实际使用的路由。
  ip route get ${address}/${mask}
  ip route get 192.168.0.0/24
# 请注意，在复杂的路由方案中，比如多路径路由，结果可能是 "正确但不完整"，因为它总是显示一条将首先使用的路由。
# 在大多数情况下，这不是问题，但千万不要忘了也看看对应的 "show "命令输出。
  
  ### View route cache (pre 3.6 kernels only)
  ip route show cached
# 在3.6版本之前，Linux使用路由缓存。在旧版内核中，这个命令可以显示路由缓存的内容。
# 它可以和上面描述的修饰符一起使用。在较新的内核中，它什么也不做。
[添加]
  ### Add a route via gateway
  ip route add ${address}/${mask} via ${next hop}
  ip route add 192.0.2.128/25 via 192.0.2.1
  ip route add 2001:db8:1::/48 via 2001:db8:1::1
  
  ###Add a route via interface
  ip route add ${address}/${mask} dev ${interface name}
  ip route add 192.0.2.0/25 dev ppp0
# 接口路由常用于PPP隧道等不需要下一跳地址的点对点接口。  

[修改|替换]  
  ### Change or replace a route
  ip route change 192.168.2.0/24 via 10.0.0.1
  ip route replace 192.0.2.1/27 dev tun0
# 您可以使用 "change "命令更改现有途径的参数。"替换 "命令可以用来添加新的路由，或者修改不存在的现有路由。

[删除]
  ### Delete a route
  ip route delete ${rest of the route statement}
  ip route delete 10.0.1.0/25 via 10.0.0.1
  ip route delete default dev ppp0
    
  ### Default route
  ip route add default via ${address}/${mask}
  ip route add default dev ${interface name}
  
  ip route add 0.0.0.0/0 ${address}/${mask}
  ip route add 0.0.0.0/0 dev ${interface name}
  ip -6 route add default via 2001:db8::1
  
  ip route flush cache

[Blackhole|unreachable|prohibit|throw]
  ### Blackhole routes
  ip route add blackhole ${address}/${mask}
  ip route add blackhole 192.0.2.1/32
  # 匹配黑洞路线的目的地的流量会被默默丢弃。
  # 黑洞路由有双重目的。第一个是直接的，丢弃发往不需要的目的地的流量，例如已知的恶意主机。
  # 第二种不那么明显，根据RFC1812使用 "最长匹配规则"。在某些情况下，你可能希望路由器认为它有一条通往较大子网的路由，
  # 而你并没有将其作为一个整体使用，例如通过动态路由协议对整个子网进行广告时。大的子网通常被分解成更小的部分，
  # 所以如果你的子网是192.0.2.0/24，而你给你的接口分配了192.0.2.1/25和192.0.2.129/25，你的系统创建了到/25的连接路由，
  # 但不是整个/24，路由守护进程可能不想宣传/24，因为你没有通往该确切子网的路由。
  
  # 解决办法是设置一条到192.0.2.0/24的黑洞路由。因为比起大的子网，小的子网的路由更受欢迎，所以不会影响实际的路由选择，但会让路由守护进程相信有一条路由是通往超网的。
  
  # 这些路由使系统丢弃数据包，并向发送方回复ICMP错误信息。
  ip route add unreachable ${address}/${mask}   # 发送ICMP "host unreachable"。
  ip route add prohibit ${address}/${mask}      # 发送ICMP "管理禁止"。
  ip route add throw ${address}/${mask}         # 发送 "网络无法接通"。
  # 与黑洞路由不同，这些路由不能被推荐用于阻止不需要的流量（例如DDoS），因为它们为每一个被丢弃的数据包生成一个回复数据包，
  # 从而产生更大的流量。它们可以很好地实施内部访问策略，但首先要考虑为此使用防火墙。

  # "丢弃 "路由可用于实施基于策略的路由，在非默认表中，它们会停止当前表的查找，但不会发送ICMP错误信息。

[backup route]
  ### Routes with different metric
  ip route add ${address}/${mask} via ${gateway} metric ${number}
  ip route add 192.168.2.0/24 via 10.0.1.1 metric 5  # metric 值越小，优先级越高
  ip route add 192.168.2.0 dev ppp0 metric 10        # metric 值越小，优先级越高
  # 如果有几条通往同一网络的路由具有不同的度量值，则会优先选择度量值最低的那条。
  # 这个概念的重要部分是，当一个接口发生故障时，那些会因为这个事件而变得无用的路由会从路由表中消失（见 "连接的路由 "部分），系统会回落到更高度量的路由。
  # 这个功能通常用于实现对重要目的地的备份连接。

[Multipath routing]
  ### Multipath routing
  ip route add ${addresss}/${mask} nexthop via ${gateway 1} weight ${number} nexthop via ${gateway 2} weight ${number}
  ip route add default nexthop via 192.168.1.1 weight 1 nexthop dev ppp0 weight 10
  # 多路径路由使系统根据权重在几条链路上平衡数据包（权重越高越好，所以权重为2的网关/接口的流量大概是权重为1的另一个的2倍）。
  # 你可以拥有任意数量的网关，并将网关和接口路由混合使用。

  # 警告：这种类型的平衡的缺点是不能保证数据包通过它们进来的同一条链路被发回。这就是所谓的 "非对称路由"。对于单纯转发数据包而不做任何本地流量处理（如NAT）的路由器来说，这通常是正常的，在某些情况下甚至是不可避免的。
  # 如果你的系统除了在接口之间转发数据包外，还做其他任何事情，这可能会导致传入连接出现问题，应采取一些措施加以防止。

[添加路由]
#使用ip route命令添加路由
ip route add 192.168.1.0/24 dev eth0                # ponit-to-point
ip route add 192.168.55.0/24 via 10.1.2.1           # ethernet
ip route add 192.168.55.0/24 via 10.1.2.1 dev eth0  # ethernet

[添加默认路由]
#使用ip route命令添加默认路由
ip route add default via 10.1.2.1 src 10.1.2.139 dev eth0  # source ip 
ip route add default via 10.1.2.1 dev eth0                 # source eth0
ip route add default via 10.1.2.1                          #  normal
ip route add via 10.1.2.1                                  # 
#metric相当于浮动值，10.1.2.1链路断掉后会自动启用10.1.3.1
ip route add via 10.1.3.1 metric 2048

#使用route命令实现上述效果[不建议使用]
route add -net 192.168.1.0/24  dev eth0
route add -net 192.168.54.0/24 gw 10.1.2.1
route add -net 192.168.54.0/24 gw 10.1.2.1 dev eth0
route add default gw 10.1.2.1 dev eth0
route add default gw 10.1.2.1
route add default gw 10.1.3.1 metric 2048

~]# ip route list table main 
~]# ip route show table local
EOF
}

ip_t_unicast_route(){  cat - <<'EOF'
A unicast route is the most common route in routing tables.
This is a typical route to a destination network address, which describes the path to the destination.
Even complex routes, such as nexthop routes are considered unicast routes.
If no route type is specified on the command line, the route is assumed to be a unicast route. 

ip route add unicast 192.168.0.0/24 via 192.168.100.5
ip route add default via 193.7.255.1
ip route add unicast default via 206.59.29.193
ip route add 10.40.0.0/16 via 10.72.75.254
EOF
}

ip_t_broadcast_route(){  cat - <<'EOF'
This route type is used for link layer devices (such as Ethernet cards) which support the notion of a broadcast address.
This route type is used only in the local routing table [26] and is typically handled by the kernel.

ip route add table local broadcast 10.10.20.255 dev eth0 proto kernel scope link src 10.10.20.67
ip route add table local broadcast 192.168.43.31 dev eth4 proto kernel scope link src 192.168.43.14
EOF
}

ip_t_local_route(){  cat - <<'EOF'
The kernel will add entries into the local routing table when IP addresses are added to an interface.
This means that the IPs are locally hosted IPs 

ip route add table local local 10.10.20.64 dev eth0 proto kernel scope host src 10.10.20.67
ip route add table local local 192.168.43.12 dev eth4 proto kernel scope host src 192.168.43.14
EOF
}

ip_t_nat_route(){ cat - <<'EOF'
This route entry is added by the kernel in the local routing table, when the user attempts to configure stateless NAT. 

ip route add nat 193.7.255.184 via 172.16.82.184
ip route add nat 10.40.0.0/16 via 172.40.0.0
EOF
}

ip_t_unreachable_route(){ cat - <<'EOF'
When a request for a routing decision returns a destination with an unreachable route type, an ICMP unreachable is generated and returned to the source address. 

ip route add unreachable 172.16.82.184
ip route add unreachable 192.168.14.0/26
ip route add unreachable 209.10.26.51
EOF
}

ip_t_prohibit_route(){  cat - <<'EOF'
When a request for a routing decision returns a destination with a prohibit route type, the kernel generates an ICMP prohibited to return to the source address. 

ip route add prohibit 10.21.82.157
ip route add prohibit 172.28.113.0/28
ip route add prohibit 209.10.26.51
EOF
}

ip_t_blackhole_route(){  cat - <<'EOF'
A packet matching a route with the route type blackhole is discarded. No ICMP is sent and no packet is forwarded. 

ip route add blackhole default
ip route add blackhole 202.143.170.0/24
ip route add blackhole 64.65.64.0/18
EOF
}

ip_t_throw_route(){ cat - <<'EOF'
The throw route type is a convenient route type which causes a route lookup in a routing table to fail, returning the routing selection process to the RPDB. 
This is useful when there are additional routing tables.
Note that there is an implicit throw if no default route exists in a routing table, so the route created by the first command in the example is superfluous, although legal. 

ip route add throw default
ip route add throw 10.79.0.0/16
ip route add throw 172.16.0.0/12
EOF
}

ip_t_unicast_rule(){  cat - <<'EOF'
A unicast rule entry is the most common rule type. This rule type simple causes the kernel to refer to the specified routing table in the search for a route.
If no rule type is specified on the command line, the rule is assumed to be a unicast rule. 

ip rule add unicast from 192.168.100.17 table 5
ip rule add unicast iif eth7 table 5
ip rule add unicast fwmark 4 table 4
EOF
}

ip_t_nat_rule(){  cat - <<'EOF'
The nat rule type is required for correct operation of stateless NAT. This rule is typically coupled with a corresponding nat route entry.
The RPDB nat entry causes the kernel to rewrite the source address of an outbound packet. 

ip rule add nat 193.7.255.184 from 172.16.82.184
ip rule add nat 10.40.0.0 from 172.40.0.0/16
EOF
}

ip_t_unreachable_rule(){  cat - <<'EOF'
Any route lookup matching a rule entry with an unreachable rule type will cause the kernel to generate an ICMP unreachable to the source address of the packet. 

ip rule add unreachable iif eth2 tos 0xc0
ip rule add unreachable iif wan0 fwmark 5
ip rule add unreachable from 192.168.7.0/25
EOF
}

ip_t_prohibit_rule(){  cat - <<'EOF'
Any route lookup matching a rule entry with a prohibit rule type will cause the kernel to generate an ICMP prohibited to the source address of the packet. 

ip rule add prohibit from 209.10.26.51
ip rule add prohibit to 64.65.64.0/18
ip rule add prohibit fwmark 7
EOF
}

ip_t_blackhole_rule(){  cat - <<'EOF'
While traversing the RPDB, any route lookup which matches a rule with the blackhole rule type will cause the packet to be dropped.
No ICMP will be sent and no packet will be forwarded. 

ip rule add blackhole from 209.10.26.51
ip rule add blackhole from 172.19.40.0/24
ip rule add blackhole to 10.182.17.64/28
EOF
}

# [路由策略行为]
# l Nat：        查询到的路由是用来做nat的。对应的路由表中一般是有很多nat类型的路由表
# l Unreachable：所有在对应的路由表中查到的路由条目都给出unreachable的答案
# l Prohibit：   所有在对应的路由表中查到的路由条目都给出prohibit的答案
# l Blackhole：  所有在对应的路由表中查到的路由条目都直接丢弃

# https://blog.csdn.net/u011857683/article/details/105785996
ip_i_rule_route(){ cat - <<'ip_i_rule_route'
[概述]
（1）路由表，存放具体的路由条目。用于决定数据包从哪个网口发出，其主要判断依据是目标IP地址。
（2）路由策略，根据策略绑定路由表。id越小，优先级越高。
（3）路由寻址过程中，按顺序走路由策略，匹配路由策略后，在路由策略对应的路由表中寻找匹配路由。
（4）添加路由策略时。我们使用ip route list 或 route -n 或 netstat -rn查看的路由记录，只是其中的一个路由表的内容。

注意：#  路由策略从第一个开始向后查询，进入查询每个策略对应的路由表，如果查到了，就采取对应的路由策略规定的行为。
路由寻找过程中，会根据路由策略的优先级来查找路由表。所以分析时，
第一，我们应该根据优先级遍历路由策略。匹配路由策略则跳到第二步，否则继续遍历路由策略。
第二，找路由策略绑定的路由表，从路由表中匹配路由。若匹配到路由则跳到第三，否则跳到第一，继续下一个优先级的路由策略。
第三，找到路由。

[linux系统中路由表table]
linux最多可以支持255张路由表，每张路由表有一个table id和table name。其中有4张表是linux系统内置的：

路由表             说明
table id = 0       系统保留。
table id = 253     称为默认路由表，表名为default。一般来说默认的路由都放在这张表。
table id = 254     称为主路由表，表名为main。如果没有指明路由所属的表，所有的路由都默认都放在这个表里。
                   一般来说，旧的路由工具(如route)所添加的路由都会加到这个表。main表中路由记录都是普通的路由记录。
                   而且，使用ip route配置路由时，如果不明确制定要操作的路由表，默认情况下也是主路由表（表254）进行操作。
          # 备注：我们使用ip route list 或 route -n 或 netstat -rn查看的路由记录，也都是main表中记录。

table id = 255     称为本地路由表，表名为local。像本地接口地址，广播地址，以及NAT地址都放在这个表。该路由表由系统自动维护，管理员不能直接修改。
备注：
(a) 系统管理员可以根据需要自己添加路由表，并向路由表中添加路由记录。
(b) 可以通过/etc/iproute2/rt_tables文件查看table id和table name的映射关系。
(c) 如果管理员新增了一张路由表，需要在/etc/iproute2/rt_tables文件中为新路由表添加table id和table name的映射。

[路由策略rule]
网络管理员不仅能够根据目的地址而且能够根据报文大小、应用或IP源地址等属性来选择转发路径。简单地来说，linux系统有多张路由表，而路由策略会根据一些条件，将路由请求转向不同的路由表。
在linux系统中，一条路由策略rule主要包含三个信息，即rule的优先级，条件，路由表。其中rule的优先级数字越小表示优先级越高，然后是满足什么条件下由指定的路由表来进行路由。
在linux系统启动时，内核会为路由策略数据库配置三条缺省的规则，即rule 0，rule 32766， rule 32767（数字是rule的优先级），具体含义如下：

路由策略    说明
rule 0      匹配任何条件的数据包，查询路由表local（table id = 255）。rule 0非常特殊，不能被删除或者覆盖。 
rule 32766  匹配任何条件的数据包，查询路由表main（table id = 254）。系统管理员可以删除或者使用另外的策略覆盖这条策略。
rule 32767  匹配任何条件的数据包，查询路由表default（table id = 253）(ID 253) 。对于前面的缺省策略没有匹配到的数据包，系统使用这个策略进行处理。这个规则也可以删除。

备注：在linux系统中是按照rule的优先级顺序依次匹配。假设系统中只有优先级为0，32766及32767这三条规则。那么系统首先会根据规则0在本地路由表里寻找路由，
如果目的地址是本网络，或是广播地址的话，在这里就可以找到匹配的路由；
如果没有找到路由，就会匹配下一个不空的规则，在这里只有32766规则，那么将会在主路由表里寻找路由；
如果没有找到匹配的路由，就会依据32767规则，即寻找默认路由表；
如果失败，路由将失败。

Usage: ip rule [ list | add | del ] SELECTOR ACTION （add 添加；del 删除； llist 列表）
SELECTOR :=
[ from IP 数据包源地址]
[ to IP 数据包目的地址]
[ tos NUMBER 服务类型]
[ dev STRING 物理接口]
[ pref NUMBER 优先级]
[fwmark NUMBER 防火墙标签]
ACTION :=
[ table TABLE_ID 指定所使用的路由表]
[ nat ADDRESS 网络地址转换]
[
prohibit 丢弃该包，并发送 COMM.ADM.PROHIITED的ICMP信息
| reject 单纯丢弃该包
| unreachable 丢弃该包， 并发送 NET UNREACHABLE的ICMP信息
]

[ flowid CLASSID ]
TABLE_ID := [ local | main | default | new | NUMBER ]

可以通过命令ip rule或ip rule list来查看系统中所有的路由策略rule。另外使用ip rule命令配置的路由策略rule只在内存中有效，机器重启后，就会失效。
可以将路由策略配置到文件/etc/sysconfig/network-scripts/rule-ethX中，这样机器重启后仍然有效。

# 增加一条规则，规则匹配的对象是所有的数据包，动作是选用路由表1的路由
# 这条规则的优先级是32800
ip rule add from 0/0 table 1 pref 32800

# 增加一条规则，规则匹配的对象是IP为192.168.3.112, tos等于0x10的包，
# 使用路由表2，这条规则的优先级是1500，动作是丢弃。
ip rule add from 192.168.2.222/32 tos 0x10 table 2 pref 1500 prohibit

注意: 
路由策略rule指定满足一定条件的数据包有指定的路由表来路由，多个策略rule可以指向同一张路由表。某些路由表可以没有策略指向它。值得注意的是，
如果系统管理员删除了指向某个路由表的所有策略rule，那么这个路由表是没有用的，但它在系统中仍然存在，直到路由表中的所有路由记录被删除，它才会消失。

(1) 查看指定路由表的内容
ip route list table table_id
ip route list table table_name
ip route show table table_id
ip route show table table_name
(2) 查看系统中所有的路由策略rule
ip rule
ip rule list
(3) 使用ip rule，ip route，route等命令进行网络配置，只在内存中有效，重启机器或网络服务就会失效。
因此，我们需要通常需要将网络相关的配置写入到配置文件中，这样重启机器或网络服务时，会从配置文件中加载网络相关的配置信息。

路由表和路由策略可以写入配置文件/etc/sysconfig/network-scripts/route-ethX和/etc/sysconfig/network-scripts/rule-ethX中，
这类配置文件是针对每个网卡单独配置的静态路由或路由策略。

route-ethX中如果不明确指定哪张路由表，缺省是添加到main路由表的，因此route-ethX中配置规则，不仅仅只有对应的网卡可以看到，其他的网卡也会看到哦。
rule-ethX中配置的路由策略rule是全局的，我们通过ip rule list可以查看所有rule-ethX中的路由策略，因此rule-ethX中的策略不仅仅只有相应的网卡才能看到，其他的网卡也会看到哦。
ip_i_rule_route
}


ip_t_rule_route(){ cat - <<'ip_t_rule_route'
##mangle模块只要有三个功能模块
mark target
    -j MARK 
    --set-mark value    给链接跟踪记录打标记
    --and-mark vlaue    数据包的nfmark值和value进行按位与运算
    --or-mark value     数据包的nfmark值和value进行按或运算
mark match
    -m mark ! -mark value 
connmark target
    -j CONNMARK
    --set-mark value            标记连接
    --save-mark                 保存包标记
    --restore-mark              恢复包标记
###CONNMARK和MARK的区别
    同样是打标记，单CONNMARK是针对链接的，MARK是针对单一数据包的，这两种机制一般都要和ip rule中的
    fwmark联用，实现对某一类条件的数据包的策略路由，对链接打标记并不代表标记了连接中的每一个数据包
    标记单个数据包，也不会对整条链接的标记有影响，二者相对独立
    
    路由判定(routing decision)是以单一数据包为单位的，ip命令只知道MARK上的标记转移到数据包上
####具体的三个模块的命令配置
    重新保存CONNMARK上的标记，实际上只是简单的将连接跟踪上记录的CONNMARK赋值给数据包MARK
    iptables -t mangle -A POSTROUTING -j CONNMARK --restore-mark
    如果数据包上已经有MARK，则接受该数据包，不需要匹配下面的规则
    iptables -t mangle -A POSTROUTING -m mark ! --mark 0 -j ACCEPT
    给协议tcp的21端口打上标记1
    iptables -t mangle -A POSTROUTING -m mark --mark 0 -p tcp --dport 21 -j MARK --set-mark 1
    给协议tcp的80端口打上标记2
    iptables -t mangle -A POSTROUTING -m mark --mark 0 -p tcp --dport 80 -j MARK --set-mark 2
    协议tcp其他端口打上标记3
    iptables -t mangle -A POSTROUTING -m mark --mark 0 -p tcp -j MARK --set-mark 3
    将数据包上的标记值保存到该数据包对应的链接跟踪上，以后属于该链的所有数据包都会使用该标记值随后属于该链接的数据包会经过第一条规则时，规则会将连接上记录的标记值重新保存到数据包上
	iptables -t mangle -A POSTROUTING -j CONNMARK --save-mark

#####应用场景
1.策略路由（linux两块网卡）
	案例一：eth0：chinanet 10.10.1.1 eth1：cernet 10.10.2.1  eth2：网关 192.168.10.1
	   要求：公司员工访问外面网站走chinanet，其它走cernet（这里列举dns走cernet）
	#打标记(即用到mark target)
	iptables -t mangle -A PREROUTING -i eth2 -p tcp --dport 80 -j MARK --set-mark 1
	iptables -t mangle -A PREROUTING -i eth2 -p tcp --dport 53 -j MARK --set-mark 2
	对协议和端口分别打上标志值1和2
	#建表
	ip rule add from all fwmark 1 table 10
	ip rule add from all fwmark 2 table 20
	标志是1的数据包使用路由表10进行路由，标志是2的数据包使用路由表20进行路由，下面定义10和20的网关
	#路由策略
	ip route add default via 10.10.1.1 dev eth1 table 10
	ip route add default via 10.10.2.1 dev eth2 table 20
	在路由表10和20上分别指定了10.10.1.1和10.10.2.1作为默认网关，分别位于chinanet和cernet线路上
	
	案例二：eth0：chinanet 10.10.1.1 eth1：cernet 10.10.2.1  eth2：网关 192.168.10.1
	   要求：公司内网192.168.10.1-100的ip使用chinanet上网，其它使用cernet上网
	#iptables网关配置
	ip route add default gw 10.10.2.1
	ip route add table 10 via 10.10.1.1 dev eth0  #设置路由表10为eth0网卡
	ip rule add fwmark 1 table 10	#fwmark 1 是标记 1 的数据包使用table 10路由表
	iptables -t mangle -A PREROUTING -i eth2 -m iprange --src-range 192.168.10.1-192.168.10.100 -j MARK --set-mark 10
ip_t_rule_route
}

# https://openwrt.org/docs/guide-user/network/routing
ip_t_rule_route_openwrt_vpn(){ cat - <<'ip_t_rule_route_openwrt_vpn'
/etc/iproute2/rt_tables
#
# reserved values
#
255  local
254  main
253  default
10   vpn
0    unspec
#
# local
#
#1   inr.ruhelp


ip rule add from 192.168.1.20 table vpn
ip rule add from 192.168.1.30 table vpn
ip route add 192.168.1.20 dev <pptp_iface_name> table vpn
ip route add 192.168.1.30 dev <pptp_iface_name> table vpn
ip route add default via <ip_of_the_far_end_of_your_tunnel> dev <pptp_iface_name> table vpn
ip route flush cache


ip rule add from 192.168.1.20 priority 10 table vpn
ip rule add from 192.168.1.30 priority 10 table vpn
ip_t_rule_route_openwrt_vpn
}


ip_t_rule(){ cat - <<'EOF'
ip rule
0:      from all lookup local 
32766:  from all lookup main 
32767:  from all lookup default 

ip route list table main
ip route show table local
#ip route命令默认显示的就是main表。default表为空。

第一段：冒号之前的数字，表示该路由表被匹配的优先顺序，数字越小，越早被匹配。这个优先级别范围是0~4亿多。
默认0、32766、32767三个优先级别已被占用。如果在添加规则时没有定义优先级别，那么默认的优先级别会从32766开始递减，
可以通过prio ID参数在设置路由表时添加优先级。
第二段：from关键字，这里显示的是匹配规则，当前表示的是从哪里来的数据包，除了from关键字外，还有to、tos、fwmark、dev等等。
第三段：loacl/main/default 这些都是路由表名称，表示数据包要从那个路由表送出去。
local表包含本机路由及广播信息，
main表就是我们route -n看到的内容，
default表，默认为空。

#根据源地址决定路由表
ip rule add from 192.168.10.0/24  table 100
ip rule add from 192.168.20.20    table 110

#根据目的地址决定路由表
ip rule add to   192.168.30.0/24  table 120
ip rule add to   192.168.40.0/24  table 130

#根据网卡设备决定路由表
ip rule add dev  eth0  table 140
ip rule add dev  eth1  table 150

#根据MARK值决定路由表
ip rule add fwmark 1 pref 20 table 200
ip rule add fwmark 2 pref 30 table 300
#此外还可以根据其他条件进行设置，例如tos等等。pref是优先级

#刷新路由缓存
ip route flush cache

上面的路由表都是用100、110、120、130等数字表示的，时间一久难免自己也会忘记该路由表的作用，
不过iproute提供了一个路由表和名称的对应表(/etc/iproute2/rt_tables)，可以手动修改该表。

[添加路由表]
~]# ip rule add from 192.168.0.0/24 table 100
~]# echo "100    unicom" >> /etc/iproute2/rt_tables
~]# ip rule |grep unicom
32765:	from 192.168.0.0/24 lookup unicom

使用ip命令来删除路由表

#根据明细条目删除
ip rule del from 192.168.0.0/24

#根据优先级删除
ip rule del prio 32765

#根据表名称来删除
ip rule del table unicom
EOF
}

ip_i_rule(){ cat - <<'EOF'
命令格式如下：
        Usage: ip rule [ list | add | del ] SELECTOR ACTION
        SELECTOR := [ from PREFIX ]             [ to PREFIX ]               [ tos TOS ]        [ dev STRING ]         [ pref NUMBER ]
        SELECTOR := [ from PREFIX 数据包源地址] [ to PREFIX 数据包目的地址] [ tos TOS 服务类型][ dev STRING 物理接口] [ pref NUMBER ] [fwmark MARK iptables 标签]
        ACTION := [ table TABLE_ID ]                   [ nat ADDRESS ]            [ prohibit         | reject         | unreachable ]
        ACTION := [ table TABLE_ID 指定所使用的路由表] [ nat ADDRESS 网络地址转换][ prohibit 丢弃该表| reject 拒绝该包| unreachable 丢弃该包]
                  [ flowid CLASSID ]
        TABLE_ID := [ local | main | default | new | NUMBER ]

    参数解析如下：
        From -- 源地址
        To --   目的地址(这里是选择规则时使用，查找路由表时也使用)
　　Tos -- IP包头的TOS(type of sevice)域Linux高级路由-
　　Dev -- 物理接口
　    Fwmark -- iptables标签
    采取的动作除了指定路由表外，还可以指定下面的动作：
        Table 指明所使用的表
  　   Nat 透明网关
　　 Prohibit 丢弃该包，并发送 COMM.ADM.PROHIITED的ICMP信息 
　　 Reject 单纯丢弃该包
　　 Unreachable丢弃该包， 并发送 NET UNREACHABLE的ICMP信息

ip rule add from 192.203.80/24 table inr.ruhep prio 220           # 通过路由表 inr.ruhep 路由来自源地址为192.203.80/24的数据包 
ip rule add from 193.233.7.83 nat 192.203.80.144 table 1 prio 320 # 把源地址为193.233.7.83的数据报的源地址转换为192.203.80.144，并通过表1进行路由 

在 Linux 系统启动时，内核会为路由策略数据库配置三条缺省的规则： 

0     匹配任何条件 查询路由表local(ID 255)   路由表local是一个特殊的路由表，包含对于本地和广播地址的高优先级控制路由。rule 0非常特殊，不能被删除或者覆盖。  
32766 匹配任何条件 查询路由表main(ID 254)    路由表main(ID 254)是一个通常的表，包含所有的无策略路由。                 系统管理员可以删除或者使用另外的规则覆盖这条规则。
32767 匹配任何条件 查询路由表default(ID 253) 路由表default(ID 253)是一个空表，它是为一些后续处理保留的。              对于前面的缺省策略没有匹配到的数据包，系统使用这个策略进行处理。这个规则也可以删除。
                                   # cat /etc/iproute2/rt_tables
ip route show table local          # 255     locale table 保存本地接口地址，广播地址、NAT地址 由系统维护，用户不得更改
ip route show table main           # 254    main table 没指明路由表的所有路由放在该表
ip route show table default        # 253    defulte table 没特别指定的默认路由都放在改表
ip route show table unspec         # 0      系统保留表
ip route list table table_name     # table_number

ip route add default via 192.168.1.1 table 1        # 在一号表中添加默认路由为192.168.1.1
ip route add 192.168.0.0/24 via 192.168.1.2 table 1 # 在一号表中添加一条到192.168.0.0网段的路由为192.168.1.2

ip route add 78.22.45.0/24 via 10.45.22.1 src 10.45.22.12  # 发到 78.22.45.0/24 网段的网络包，下一跳的路由器 IP 是 10.45.22.1，包的源IP地址设为10.45.22.12。

以一例子来说明：公司内网要求192.168.0.100 以内的使用 10.0.0.1 网关上网 （电信），其他IP使用 20.0.0.1 （网通）上网。
首先要在网关服务器上添加一个默认路由，当然这个指向是绝大多数的IP的出口网关：ip route add default gw 20.0.0.1
之后通过 ip route 添加一个路由表：ip route add table 3 via 10.0.0.1 dev ethX (ethx 是 10.0.0.1 所在的网卡, 3 是路由表的编号)
之后添加 ip rule 规则：ip rule add fwmark 3 table 3 （fwmark 3 是标记，table 3 是路由表3 上边。 意思就是凡事标记了 3 的数据使用 table3 路由表）
之后使用 iptables 给相应的数据打上标记：iptables -A PREROUTING -t mangle -i eth0 -s 192.168.0.1 - 192.168.0.100 -j MARK --set-mark 3
因为 mangle 的处理是优先于 nat 和 fiter 表的，所以在数据包到达之后先打上标记，之后再通过 ip rule 规则，对应的数据包使用相应的路由表进行路由，最后读取路由表信息，将数据包送出网关。
EOF
}

ip_t_route_rule_traffic(){ cat - <<'EOF'
Linux多网卡多路由设置
比如如果一个linux服务器有三个口接三个不同的网络，假设对应的网络信息是如此
eth0是电信，  ip地址为1.1.1.1/24，电信网关为1.1.1.254
eth1是网通，  ip地址为2.2.2.2/24，网通网关为2.2.2.254
eth2是教育网，ip地址为3.3.3.3/24，教育网网关为3.3.3.254

echo "101 ChinaNet" >> /etc/iproute2/rt_tables
echo "102 ChinaCnc" >> /etc/iproute2/rt_tables
echo "103 ChinaEdu" >> /etc/iproute2/rt_tables

ip route add default via 1.1.1.254 dev eth0 table ChinaNet
ip route add default via 2.2.2.254 dev eth1 table ChinaCnc
ip route add default via 3.3.3.254 dev eth2 table ChinaEdu

ip rule add from 1.1.1.1 table ChinaNet
ip rule add from 2.2.2.2 table ChinaCnc
ip rule add from 3.3.3.3 table ChinaEdu
EOF
}

ip_t_rule_route_centos(){ cat - <<'EOF'

# 服务器A和B为双网卡，操作系统为rhel_7.1_64
网卡显示名称 	IP地址 	        子网掩码 	    网关 	        备注
ens4f0 	        172.31.192.201 	255.255.255.0 	172.31.192.254 	服务器A
ens9f0 	        172.31.196.1    255.255.255.0 	172.31.196.254 	服务器A
ens4f0 	        172.31.192.202 	255.255.255.0 	172.31.192.254 	服务器B
ens9f0 	        172.31.196.2    255.255.255.0 	172.31.196.254 	服务器B
/               172.25.168.44   255.255.255.0 	172.25.168.254 	接入测试

# 网络配置，以服务器A为例，注意注释默认网关
cat /etc/sysconfig/network-scripts/ifcfg-ens4f0
DEVICE=ens4f0
ONBOOT=yes
BOOTPROTO=static
TYPE=Ethernet
IPADDR=172.31.192.201
NETMASK=255.255.255.0
#GATEWAY=172.31.192.254

cat /etc/sysconfig/network-scripts/ifcfg-ens9f0
DEVICE=ens9f0
ONBOOT=yes
BOOTPROTO=static
TYPE=Ethernet
IPADDR=172.31.196.1
NETMASK=255.255.255.0
#GATEWAY=172.31.196.254

# 策略路由配置 注意配置名称一定要吻合
#编辑rt_tables
echo "192 net_192 " >> /etc/iproute2/rt_tables
echo "196 net_196 " >> /etc/iproute2/rt_tables

#清空net_192路由表
ip route flush table net_192
# 添加一个路由规则到 net_192 表，这条规则是 net_192 这个路由表中数据包默认使用源 IP 172.31.192.201 通过 ens4f0 走网关 172.31.192.254
ip route add default via 172.31.192.254 dev ens4f0 src 172.31.192.201 table net_192
#来自 172.31.192.201 的数据包，使用 net_192 路由表的路由规则
ip rule add from 172.31.192.201 table net_192

#清空net_196路由表
ip route flush table net_196
#添加一个路由规则到 net_196 表，这条规则是 net_196 这个路由表中数据包默认使用源 IP 172.31.196.1 通过 ens9f0 走网关 172.31.196.254
ip route add default via 172.31.196.254 dev ens9f0 src 172.31.196.1 table net_196
#来自 172.31.196.1 的数据包，使用 net_196 路由表的路由规则
ip rule add from 172.31.196.1 table net_196

#添加默认网关
route add default gw 172.31.192.254

#如果需要自启动生效可以写进配置文件也可以加入rc.local
vi /etc/rc.local

ip route flush table net_192
ip route add default via 172.31.192.254 dev ens4f0 src 172.31.192.201 table net_192
ip rule add from 172.31.192.201 table net_192
ip route flush table net_196
ip route add default via 172.31.196.254 dev ens9f0 src 172.31.196.1 table net_196
ip rule add from 172.31.196.1 table net_196
route add default gw 172.31.192.254

#查看路由表
route -n

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
169.254.0.0     0.0.0.0         255.255.0.0     U     1006   0        0 ens9f0
169.254.0.0     0.0.0.0         255.255.0.0     U     1008   0        0 ens4f0
169.254.0.0     0.0.0.0         255.255.0.0     U     1014   0        0 br-ex
169.254.0.0     0.0.0.0         255.255.0.0     U     1015   0        0 br-int
172.31.192.0    0.0.0.0         255.255.255.0   U     0      0        0 ens4f0
172.31.196.0    0.0.0.0         255.255.255.0   U     0      0        0 ens9f0

#在接入测试服务器上验证连通性
ping 172.31.192.201
ping 172.31.196.1
EOF
}

ip_t_route_static_centos(){  cat - <<'EOF'
目前有如下的一个网络，主机有两个网卡，两个网段分别是是业务地址eth0和管理地址eth1。
业务地址段为：192.168.3.0/24段 
管理地址段：10.212.52.0/24段
防火墙段：10.211.6.0/24段
现在的需求是，默认路由走业务地址(192.168.3.0/24),防火墙段走10.211.6.0/24业务地址，
10.0.0.0/8的所有地址都走管理地址段。
二、redhat静态路由配置
在redhat环境下，有三种配置方法
方法一：在/etc/sysconfig/network配置文件中配置：
    default via 192.168.3.1 dev eth0    #192.168.3.1为eth0网卡的网关地址
    10.211.6.0/24 via 192.168.3.1 dev eth0
    10.0.0.0/8 via 10.212.52.1 dev eth1  #10.212.52.1为eth1网卡的网关地址

注：该种配置写法同样支持写到/etc/sysconfig/network-scripts/route-interferface 配置文件中。
具体可以参看redhat官方文档。

方法二：在/etc/sysconfig/network-scripts/route-interferface 配置文件配置
在这里支持两种配置格式的写法
A：方法1中提到的方法
    # cat /etc/sysconfig/network-scripts/route-eth0
    0.0.0.0/0 via 192.168.3.1 dev eth0
    10.211.6.0/24 via 192.168.3.1 dev eth0
    # cat /etc/sysconfig/network-scripts/route-eth1
    10.0.0.0/8 via 10.212.52.1 dev eth1

B：网络掩码法
    # cat /etc/sysconfig/network-scripts/route-eth0
    ADDRESS0=0.0.0.0
    NETMASK0=0.0.0.0
    GATEWAY0=192.168.3.1
    ADDRESS1=10.211.6.0
    NETMASK1=255.255.255.0
    GATEWAY1=192.168.3.1
其中网段地址和掩码全是0代表为所有网段，即默认路由。
    # cat /etc/sysconfig/network-scripts/route-eth1
    ADDRESS0=10.0.0.0
    NETMASK0=255.0.0.0
    GATEWAY0=10.212.52.1
网络掩码法也可以参看redhat官方文档。


方法三：/etc/sysconfig/static-routes配置
    # cat /etc/sysconfig/static-route
    any net any gw 192.168.3.1
    any net 10.211.6.0/24 gw 192.168.3.1
    any net 10.0.0.0 netmask 255.0.0.0 gw 10.212.52.1 
注：默认情况下主机中并没有该文件，之所以该方法也可以是因为/etc/init.d/network启动脚本会调用该文件，具体调用部分代码如下：
    # Add non interface-specific static-routes.
    if [ -f /etc/sysconfig/static-routes ]; then
       grep "^any" /etc/sysconfig/static-routes | while read ignore args ; do
          /sbin/route add -$args
       done
    fi
EOF
}

ip_t_link(){ cat - <<'EOF'
ip link show
ip link set
dev name                        指定要进行操作的网络设备名称 
up/down                         激活/禁用网络设备 
arp on / arp off                在该网络设备上使用arp协议/禁用arp协议 
multicast on / multicast off    打开/关闭多目传送 
dynamic on / dynamic off        打开/关闭动态标志 
name NAME                       更改网络设备名称(需停止设备) 
txqlen number                   设置传输队列长度 
mtu number                      设置最大传输单元 
address mac                     设置网络设备的MAC地址 
broadcast mac                   设置网络设备的硬件广播地址

    ## Show information about all links
    ip link show
    ip link list
    ip link show dev ${interface name}
    ip link show dev eth0
    ip link show dev tun10
    
    ### Bring a link up or down
    # eth0/iflink
    # eth0/operstate
    # VLANs and bridges 接口在创建之后处于down状态，需要手动设置其为up状态
    ip link set dev ${interface name} up
    ip link set dev ${interface name} down
    ip link set dev eth0 down
    ip link set dev br0 up
    
    ### Set human-readable link description
    # /sys/class/net/cloudbr0/ifalias
    ip link set dev ${interface name} alias "${description}"
    ip link set dev eth0 alias "LAN interface"
    
    ### Rename an interface
    # /sys/class/net/lan
    # /sys/class/net/lan/uevent
    # 不能修改一个active状态的接口，需要先down，然后再修改接口名
    ip link set dev ${old interface name} name ${new interface name}
    ip link set dev eth0 name lan
    
    ### Change link layer address (usually MAC address)
    ip link set dev ${interface name} address ${address}
    ip link set dev eth0 address 22:ce:e0:99:63:6f
    ip link set dev br-lan address 22:ce:e0:99:63:6f 
    
    ### Change link MTU
    ip link set dev ${interface name} mtu ${MTU value}
    ip link set dev tun0 mtu 1480  # tunnel
    ip link set dev eth0 mtu 9000  # jumbo frames
    
    ###　Delete a link
    # 只有虚拟接口vlan bridge bond类接口可以被delete
    ip link delete dev ${interface name}
    
    ### Enable or disable multicast on an interface
    ip link set ${interface name} multicast on
    ip link set ${interface name} multicast off
    
    #### Enable or disable ARP on an interface
    ip link set ${interface name} arp on
    ip link set ${interface name} arp off
    
    #### Create a VLAN interface
    # IEEE 802.1q VLAN
    # 一旦您创建了一个VLAN接口，所有在id选项中指定的带有${tag}标签的帧都会被${parent interface}收到，并由该VLAN接口处理。
    # VLAN也可以通过bridge、bond和其他能够处理以太网帧的接口来创建。
    ip link add name ${VLAN interface name} link ${parent interface name} type vlan id ${tag}
    ip link add name eth0.110 link eth0 type vlan id 110
    
    #### Create a QinQ interface (VLAN stacking)
    # VLAN堆栈（又名802.1ad QinQ）是一种在另一个VLAN上传输VLAN标记流量的方式。
    # 它的常见用例是这样的：假设你是一个服务提供商，你有一个客户，他们想使用你的网络基础设施来连接他们网络中的各个部分。
    # 他们在网络中使用多个VLAN，所以普通的租用VLAN是不行的。有了QinQ，您可以在客户流量进入您的网络时，给它添加第二个标签，
    # 并在它退出时删除该标签，这样就不会有冲突，您也不需要浪费VLAN号。
    # 服务标签是提供商用于在其网络中传输客户流量的VLAN标签。客户端标签是客户设置的标签。
    # 符合标准的QinQ从Linux 3.10开始提供。
    ip link add name ${service interface} link ${physical interface} type vlan proto 802.1ad id ${service tag}
    ip link add name ${client interface} link ${service interface} type vlan proto 802.1q id ${client tag}
    
    ip link add name eth0.100 link eth0 type vlan proto 802.1ad id 100        # Create service tag interface
    ip link add name eth0.100.200 link eth0.100 type vlan proto 802.1q id 200 # Create client tag interface
    
    ### Create pseudo-ethernet (aka macvlan) interface
    # 你可以把macvlan接口看作是在父接口上附加的虚拟MAC地址。从用户的角度来看，它们看起来就像普通的以太网接口，并处理所有由其父接口分配的MAC地址的流量。
    # 这通常用于测试，或者当只有一个物理接口可用时，使用MAC识别的服务的几个实例。
    # 它们也可以仅仅用于IP地址的分离，而不是将多个地址分配给同一个物理接口，特别是当一些服务不能在二级地址上正常运行时。
    ip link add name ${macvlan interface name} link ${parent interface} type macvlan
    ip link add name peth0 link eth0 type macvlan
        
    ### Create a dummy interface
    # 虚接口的工作原理和回环接口差不多，只是可以有多少个就有多少个。
    # 第二个目的是利用它们总是处于up状态的事实。
    # 这通常用于在有多个物理接口的路由器上为它们分配服务地址。只要分配给环回或虚接口的地址的流量被路由到拥有它的机器上，
    # 你就可以通过它的任何接口访问它。
    ip link add name ${dummy interface name} type dummy
    ip link add name dummy0 type dummy
    
    ### Create a bridge interface
    ip link add name ${bridge name} type bridge
    ip link add name br0 type bridge
    
    ### Add an interface to bridge
    ip link set dev ${interface name} master ${bridge name}
    ip link set dev eth0 master br0
    
    ###　Remove interface from bridge
    ip link set dev ${interface name} nomaster
    ip link set dev eth0 nomaster
    
    ### Create a bonding interface
    ip link add name ${name} type bond
    ip link add name bond1 type bond
    
    ### Create an intermediate functional block interface
    ip link add ${interface name} type ifb
    ip link add ifb10 type ifb
    
    ### Create a pair of virtual ethernet devices
    # 注：虚拟以太网设备是在UP状态下创建的，创建后无需手动提起。
    ip link add name ${first device name} type veth peer name ${second device name}
    ip link add name veth-host type veth peer name veth-guest
EOF
}

ip_t_link_group(){ cat - <<'EOF'
group类似于管理型switch中的端口范围。您可以将网络接口添加到一个numbered group中，并同时对该组中的所有接口进行操作。
没有分配到任何组的链接属于0 group，也就是 "默认"。

# 为一个组指定一个符号名称
# 组名存储在 /etc/iproute2/group 文件中。0组的符号名 "default "正是来自那里。您可以按照"${number} ${name}"的格式添加自己的名字，每行一个。您最多可以有255个命名的组。
# 一旦你配置了一个组名，编号和名称就可以在ip命令中互换使用。
    [创建组]
    ### Assign a symbolic name to a group
    echo "10    customer-vlans" >> /etc/iproute2/group
    ip link set dev eth0.100 group customer-vlans
    
    [给组添加接口]
    ### Add an interface to a group
    ip link set dev ${interface name} group ${group number}
    ip link set dev eth0 group 42
    ip link set dev eth1 group 42
    
    [从组删除接口]
    ### Remove an interface from a group
    ip link set dev ${interface name} group 0
    ip link set dev ${interface} group default
    ip link set dev tun10 group 0
    
    [对组进行配置]
    #### Perform an operation on a group
    ip link set group ${group number} ${operation and arguments}
    ip link set group 42 down
    ip link set group uplinks mtu 1200
    
    [对组进行查看]
    #### View information about links from specific group
    ip link list group 42
    ip address show group customers
EOF
}

ip_i_neighbor(){ cat - <<'EOF'
ip neigh help

ip neigh { add | del | change | replace }
         { ADDR [ lladdr LLADDR ] [ nud STATE ] | proxy ADDR } 
         [ dev DEV ]
         [ router ] 
         [ extern_learn ] 
         [ protocol PROTO ]

ADDR 指定协议地址，可以是ipv4或者ipv6的 
lladdr LLADDRESS 指定硬件地址 
nud NUD_STATE 指定neighbour的nud值，即邻居不可到达检测，可以是以下值： 
    permanent:说明该记录将永久有效，只能出于管理的目的将其删除。 
    noarp:说明该记录有效，但是在其生存时间到达以后可以被删除。 
    reachable:说明该记录有效，直到可到达超时溢出。
    stale:说明该记录有效，但是其有效性值得怀疑。
dev NAME 指定网络设备名称 

# Add or delete an ARP entry for the neighbour IP address to `eth0`:
sudo ip neighbour add|del ip_address lladdr mac_address dev eth0 nud reachable

# Change or replace an ARP entry for the neighbour IP address to `eth0`:
sudo ip neighbour change|replace ip_address lladdr new_mac_address dev eth0

ip neigh add 10.0.0.3 lladdr 000001 dev eth0 nud perm
# nud
permanent   --- the neighbour entry is valid forever and can be removed only administratively.
noarp       --- the neighbour entry is valid, no attempts to validate this entry will be made but it can be removed when its lifetime expires.
reachable   --- the neighbour entry is valid until reachability timeout expires.
stale       --- the neighbour entry is valid, but suspicious. This option to ip neighbour does not change the neighbour state if the entry was valid and the address has not been changed by this command.

none        --- state of the neighbour is void.
incomplete  --- the neighbour is in process of resolution.
reachable   --- the neighbour is valid and apparently reachable.
stale       --- the neighbour is valid, but probably it is already unreachable, so that kernel will try to check it at the first transmission.
delay       --- a packet has been sent to the stale neighbour, kernel waits for confirmation.
probe       --- delay timer expired, but no confirmation was received. Kernel has started to probe neighbour with ARP/NDISC messages.
failed      --- resolution has failed.
noarp       --- the neighbour is valid, no attempts to check the entry will be made.
permanent   --- it is noarp entry, but only administrator may remove the entry from neighbour table.

STALE - 邻居是有效的，但可能已经无法到达，所以内核将在第一次传输时尝试检查它。
DELAY - 一个数据包已经被发送到了过时的邻居，内核正在等待确认。
REACHABLE - 邻居是有效的，并且显然是可以到达的。
EOF
}

# https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
ip_t_arp_gc(){ cat - <<'ip_t_arp_gc'
ARP回收
    gc_stale_time 每次检查neighbour记录的有效性的周期。当neighbour记录失效时，将在给它发送数据前再解析一次。缺省值是60秒。
    gc_thresh1 存在于ARP高速缓存中的最少记录数，如果少于这个数，垃圾收集器将不会运行。缺省值是128。
    gc_thresh2 存在 ARP 高速缓存中的最多的记录软限制。垃圾收集器在开始收集前，允许记录数超过这个数字 5 秒。缺省值是 512。
    gc_thresh3 保存在 ARP 高速缓存中的最多记录的硬限制，一旦高速缓存中的数目高于此，垃圾收集器将马上运行。缺省值是1024。
比如可以增大为
net.ipv4.neigh.default.gc_thresh1=1024
net.ipv4.neigh.default.gc_thresh2=4096
net.ipv4.neigh.default.gc_thresh3=8192

ARP过滤
arp_filter - BOOLEAN
arp_announce - INTEGER
arp_ignore - INTEGER
arp_notify - BOOLEAN
arp_accept - BOOLEAN
ip_t_arp_gc
}



ip_t_neighbor(){ cat - <<'EOF'
ip neigh add 10.0.0.3 lladdr 000001 dev eth0 nud perm
ip neigh del 10.0.0.3 dev eth0

### View neighbor tables
ip neighbor show
ip neighbor show dev ${interface name}
ip neighbor show dev eth0

### Flush table for an interface
ip neighbor flush dev ${interface name}
ip neighbor flush dev eth1

### Add a neighbor table entry
ip neighbor add ${network address} lladdr ${link layer address} dev ${interface name}
ip neighbor add 192.0.2.1 lladdr 22:ce:e0:99:63:6f dev eth0

### Delete a neighbor table entry
ip neighbor delete ${network address} lladdr ${link layer address} dev ${interface name}
ip neighbor delete 192.0.2.1 lladdr 22:ce:e0:99:63:6f dev eth0
EOF
}

ip_i_tunnel(){  cat - <<'EOF'
IP隧道技术：是路由器把一种网络层协议封装到另一个协议中以跨过网络传送到另一个路由器的处理过程。
IP 隧道(IP tunneling)是将一个IP报文封装在另一个IP报文的技术，这可以使得目标为一个IP地址的数据报文能被封装和转发到另一个IP地址。
IP隧道技术亦称为IP封装技术(IP encapsulation)。
IP隧道主要用于移动主机和虚拟私有网络(Virtual Private Network)，在其中隧道都是静态建立的，隧道一端有一个IP地址，另一端也有唯一的IP地址。

ipip、gre、sit。这三种隧道技术都需要内核模块 tunnel4.ko 的支持。
移动IPv4主要有三种隧道技术, 它们分别是: IP in IP, 最小封装以及通用路由封装
    IP in IP:     即ipip : 需要内核模块 ipip.ko, 不能通过IP-in-IP隧道转发广播或者IPv6数据包。
    最小封装:     应该是sit, Simple Internet Transition :  sit 他的作用是连接 ipv4 与 ipv6 的网络
    通用路由封装: gre, Generic Routing Encapsulation:  ip_gre.ko -> 可以使用GRE隧道传输多播数据包和IPv6数据包。

Linux系统内核实现的IP隧道技术主要有三种(PPP、PPTP和L2TP等协议或软件不是基于内核模块的): ipip、gre、sit
modinfo sit 
modinfo ipip
modinfo ip_gre
三种ip tunnel 技术和VPN技术一样，多用于跨公网的网络中

ipip, gre是实现隧道的两种模式.
添加tunnel设备时需要按照一定的格式, 否则会出错. 以下列出了几种可能的格式.
    ip tunnel add tun_ipip0 mode ipip remote 8.210.37.47 local 172.16.156.195
    ip tunnel add tun_ipip0 mode ipip local 172.16.156.195
    ip tunnel add tun_ipip0 mode ipip local 0.0.0.0
    ip tunnel add tun_ipip0 mode ipip 
    
    隧道是一种 "网络虫洞"，看起来就像正常的接口，但通过隧道发送的数据包会被封装成另一种协议，并通过多台主机发送到隧道的另一边，
然后按通常的方式进行解封装和处理，所以你可以假装两台机器有直接的连接，而事实上它们没有。

    这通常用于虚拟专用网络(与IPsec等加密传输协议结合使用)，或者通过一个不使用某种协议的中间网络连接使用该协议的网络
(例如被IPv4-only段隔开的IPv6网络)。

注意：隧道本身的安全性为零。它们和它们的底层网络一样安全。因此，如果你需要安全，可以通过加密传输来使用它们，例如IPsec。

Linux 目前支持 IPIP(IPv4 中的 IPv4)、
               SIT (IPv6 中的 IPv4)、
               IP6IP6 (IPv6 中的 IPv6)、
               IPIP6 (IPv4 中的 IPv6)、
               GRE (几乎任何东西中的任何东西)，以及在最近的版本中，
               VTI (IPsec 中的 IPv4)。

注意，隧道是在DOWN状态下创建的，你需要把它们带起来。
在本节中，${local endpoint address}和${remote endpoint address}指的是分配给端点物理接口的地址。${address}指的是分配给隧道接口的地址。
EOF
}

ip_t_tunnel(){ cat - <<'EOL'
    ### Create an IPIP tunnel
    ip ip_i_neighbor add ${interface name} mode ipip local ${local endpoint address} remote ${remote endpoint address}
    ip tunnel add tun0 mode ipip local 192.0.2.1 remote 198.51.100.3
    ip link set dev tun0 up
    ip address add 10.0.0.1/30 dev tun0
    
    ### Create a SIT tunnel
    sudo ip tunnel add ${interface name} mode sit local ${local endpoint address} remote ${remote endpoint address}
    ip tunnel add tun9 mode sit local 192.0.2.1 remote 198.51.100.3
    ip link set dev tun9 up
    ip address add 2001:db8:1::1/64 dev tun9
    # 这种类型的隧道通常用于提供IPv4连接的网络与IPv6连接。有所谓的 "隧道经纪人 "为大家提供，如Hurricane Electric tunnelbroker.net。
    
    ##Create an IPIP6 tunnel
    ip -6 tunnel add ${interface name} mode ipip6 local ${local endpoint address} remote ${remote endpoint address}
    ip -6 tunnel add tun8 mode ipip6 local 2001:db8:1::1 remote 2001:db8:1::2
    # 当过境运营商逐步淘汰IPv4时（即不会很快），这种类型的隧道将被广泛使用。
    
    ###Create an IP6IP6 tunnel
    ip -6 tunnel add ${interface name} mode ip6ip6 local ${local endpoint address} remote ${remote endpoint address}
    ip -6 tunnel add tun3 mode ip6ip6 local 2001:db8:1::1 remote 2001:db8:1::2
    ip link set dev tun3 up
    ip address add 2001:db8:2:2::1/64 dev tun3
    # 就像IPIP6一样，这些都不会很快普遍有用。

    ### Create a gretap (ethernet over GRE) device # GRE以太网
    ip link add ${interface name} type gretap local ${local endpoint address} remote ${remote endpoint address}
    ip link add gretap0 type gretap local 192.0.2.1 remote 203.0.113.3
    # 这种类型的隧道将以太网帧封装成IPv4数据包。
    # 这可能应该放在 "链接管理 "部分，但由于涉及到封装，所以放在这里。这样创建的隧道接口看起来就像一条L2链路，它可以被添加到桥接组中。这是用来通过路由网络连接L2网段的。

    ### Create a GRE tunnel
    ip tunnel add ${interface name} mode gre local ${local endpoint address} remote ${remote endpoint address}
    ip tunnel add tun6 mode gre local 192.0.2.1 remote 203.0.113.3
    ip link set dev tun6 up
    ip address add 192.168.0.1/30 dev tun6
    ip address add 2001:db8:1::1/64 dev tun6
    # GRE可以同时封装IPv4和IPv6，但默认情况下，它使用IPv4进行传输，对于IPv6上的GRE，有单独的隧道模式 "ip6gre"。
    # 然而，默认情况下，它使用IPv4进行传输，对于IPv6上的GRE，有一个单独的隧道模式，"ip6gre"。
    
    ### Create multiple GRE tunnels to the same endpoint
    ip tunnel add ${interface name} mode gre local ${local endpoint address} remote ${remote endpoint address} key ${key value}
    ip tunnel add tun4 mode gre local 192.0.2.1 remote 203.0.113.6 key 123
    ip tunnel add tun5 mode gre local 192.0.2.1 remote 203.0.113.6 key 124
# 密钥化的隧道也可以同时用于非密钥化。密钥可以是类似IPv4的点阵十进制格式。
# 请注意，密钥不会给隧道增加任何安全性，它只是一个标识符，用来区分一个隧道和另一个隧道。它只是一个标识符，用来区分一个隧道和另一个隧道。
    
    ### Create a point-to-multipoint GRE tunnel
    ip tunnel add ${interface name} mode gre local ${local endpoint address} key ${key value}
    ip tunnel add tun8 mode gre local 192.0.2.1 key 1234
    ip link set dev tun8 up
    ip address add 10.0.0.1/27 dev tun8
    
注意没有${remote endpoint address}。这和Cisco IOS中所谓的 "mode gre multipoint "是一样的。
在没有远程端点地址的情况下，密钥是识别隧道流量的唯一方法，所以需要${key值}。
这种类型的隧道允许你使用同一个隧道接口与多个端点通信。它常用于复杂的VPN设置中，多个端点之间相互通信（用思科的术语来说，就是 "动态多点VPN"）。
由于没有明确的远程端点地址，显然只创建一个隧道是不够的。你的系统需要知道其他端点在哪里。
在现实生活中，NHRP(Next Hop Resolution Protocol)就是用来解决这个问题的。为了测试，你可以手动添加对等体（给定的远程端点在其物理接口上使用203.0.113.6地址，在隧道上使用10.0.0.2）。

ip neighbor add 10.0.0.2 lladdr 203.0.113.6 dev tun8
你必须在远程端点上也这样做，比如。
ip neighbor add 10.0.0.1 lladdr 192.0.2.1 dev tun8 等。
请注意，链路层地址和邻居地址都是IP地址，所以它们在同一个OSI层。这也是链接层地址概念变得有趣的案例之一。

    ### Create a GRE tunnel over IPv6
    ip -6 tunnel add name ${interface name} mode ip6gre local ${local endpoint} remote ${remote endpoint}
    
    ###Delete a tunnel
    ip tunnel del ${interface name}
    ip tunnel del gre1
    
    ### Modify a tunnel
    ip tunnel change ${interface name} ${options}
    ip tunnel change tun0 remote 203.0.113.89
    ip tunnel change tun10 key 23456
    
    
    ### View tunnel information
    ip tunnel show
    ip tunnel show ${interface name}
    ip tun show tun99 
    tun99: gre/ip  remote 10.46.1.20  local 10.91.19.110  ttl inherit
EOL
}

ip_i_L2TPv3_openwrt(){  cat - <<'ip_i_L2TPv3_openwrt'
建立静态（又称非托管）L2TPv3以太网隧道。
对于非托管隧道，没有L2TP控制协议，因此不需要用户空间守护进程--隧道是通过在本地系统和远程对等体上发布命令来手动创建的。
L2TPv3适用于第2层隧道。当隧道是固定的时，静态隧道对于建立跨IP网络的网络链路非常有用。L2TPv3隧道可以承载多个会话的数据。每个会话由一个session_id和它的父隧道的tunnel_id来标识。在隧道中创建会话之前，必须先创建一个隧道。
当创建L2TP隧道时，指定远程对等体的IP地址，它可以是IPv4或IPv6地址。还必须指定用于到达对等体的本地 IP 地址。这是本地系统监听和接受从对等体接收的 L2TP 数据包的地址。
L2TPv3定义了两种数据包封装格式。UDP或IP。UDP封装是最常见的。IP封装使用专用的IP协议值来传输L2TP数据，而没有UDP的开销。只有当网络路径中没有NAT设备或防火墙时才使用IP封装。
当创建L2TPv3以太网会话时，会为该会话创建一个虚拟网络接口，然后必须像其他网络接口一样，对其进行配置和提起。当数据通过该接口时，会通过L2TP隧道传送到对等体。通过配置系统的路由表或将接口加入网桥，L2TP接口就像一根虚拟的网线（伪网线）连接到对等体上。
建立一个非托管的L2TPv3以太网伪线需要在本地系统和对等体上手动创建L2TP上下文。每个站点使用的参数必须对应，否则将无法传递数据。由于没有使用控制协议来建立无人管理的L2TP隧道，因此不可能进行一致性检查。一旦给定L2TP会话的虚拟网络接口被配置和启用，即使对等体尚未配置，也可以传输数据。如果没有配置对等体，L2TP数据包将被对等体丢弃。
要建立一个非托管的L2TP隧道，请使用以下方法
ip l2tp add tunnel 和 l2tp add session 命令，然后根据需要配置并启用隧道的虚拟网络接口。然后根据需要配置并启用隧道的虚拟网络接口。
请注意，未管理的隧道只携带以太网帧。如果你需要传输PPP流量(L2TPv2)，或者你的对等体不支持非托管L2TPv3隧道，你将需要一个实现L2TP控制协议的L2TP服务器。L2TP控制协议允许建立动态的L2TP隧道和会话，并提供检测和处理网络故障的功能。

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation/networking/l2tp.txt
ip_i_L2TPv3_openwrt
}

ip_i_L2TPv3(){  cat - <<'EOF'
第二层转发协议: 基于L2F (Cisco的第二层转发协议)开发的PPTP的后续版本
PPTP和L2TP都使用PPP协议对数据进行封装，然后添加附加包头用于数据在互联网络上的传输。
差异1: 
PPTP只能在两端点间建立单一隧道。
L2TP支持在两端点间使用多隧道，用户可以针对不同的服务质量创建不同的隧道。
差异2: 
L2TP可以提供隧道验证，而PPTP则不支持隧道验证。
当L2TP 或PPTP与IPSEC共同使用时，可以由IPSEC提供隧道验证，不需要在第2层协议上验证隧道使用L2TP。
差异3: 
PPTP要求互联网络为IP网络。L2TP只要求隧道媒介提供面向数据包的点对点的连接，L2TP可以在IP(使用UDP)，桢中继永久虚拟电路 (PVCs),X.25虚拟电路(VCs)或ATM VCs网络上使用


L2TPv3是一种常用于第二层转发协议的隧道协议。
在许多发行版中，加载l2tp_netlink和l2tp_eth模块。如果你想通过IP而不是UDP使用L2TPv3，也要加载l2tp_ip。

与Linux中其他隧道协议的实现相比，L2TPv3的术语有些颠倒。你创建一个隧道，然后将会话绑定到它上面。
你可以用不同的标识符将多个会话绑定到同一个隧道。虚拟网络接口(默认命名为l2tpethX)与会话相关联。

注意：Linux 内核只实现了对数据帧的处理，所以你只能用 iproute2 创建未映射的隧道，并在两边手动配置所有设置。
如果你想用L2TP来做远程访问VPN或其他固定伪线以外的东西，你需要一个用户空间守护进程来处理它。这不在本文档范围内。

# Create an L2TPv3 tunnel over UDP
ip l2tp add tunnel \
tunnel_id ${local tunnel numeric identifier} \
peer_tunnel_id ${remote tunnel numeric identifier} \
udp_sport ${source port} \
udp_dport ${destination port} \
encap udp \
local ${local endpoint address} \
remote ${remote endpoint address}

# Examples:
ip l2tp add tunnel \
tunnel_id 1 \
peer_tunnel_id 1 \
udp_sport 5000 \
udp_dport 5000 \ 
encap udp \
local 192.0.2.1 \ 
remote 203.0.113.2
注意：两个端点上的隧道标识符和其他设置必须匹配。

# Create an L2TPv3 tunnel over IP
ip l2tp add tunnel \
tunnel_id ${local tunnel numeric identifier} \
peer_tunnel_id {remote tunnel numeric identifier } \
encap ip \
local 192.0.2.1 \
remote 203.0.113.2
# L2TPv3直接封装到IP中提供的开销较少，bug一般无法通过NAT。


# Create an L2TPv3 session
ip l2tp add session tunnel_id ${local tunnel identifier} \
session_id ${local session numeric identifier} \
peer_session_id ${remote session numeric identifier}

# Examples:
ip l2tp add session tunnel_id 1 \ 
session_id 10 \
peer_session_id 10

注意：tunnel_id值必须与之前创建的隧道值相匹配。两个端点的会话标识符必须匹配。
一旦你创建了一个隧道和一个会话，l2tpethX接口将出现，处于down状态。将状态改为up，然后用另一个接口进行桥接或分配一个地址。


# Delete an L2TPv3 session
ip l2tp del session tunnel_id ${tunnel identifier} session_id ${session identifier}

# Examples:
ip l2tp del session tunnel_id 1 session_id 1


# Delete an L2TPv3 tunnel
ip l2tp del tunnel tunnel_id ${tunnel identifier}

# Examples:
ip l2tp del tunnel tunnel_id 1
注意：在删除隧道之前，你需要删除与隧道相关联的所有会话。


# View L2TPv3 tunnel information
ip l2tp show tunnel
ip l2tp show tunnel tunnel_id ${tunnel identifier}

# Examples:
ip l2tp show tunnel tunnel_id 12


# View L2TPv3 session information
ip l2tp show session
ip l2tp show session session_id ${session identifier} tunnel_id ${tunnel identifier}

# Examples:
ip l2tp show session session_id 1 tunnel_id 12
EOF
}

ip_i_netns() {  cat - <<'EOF'
网络命名空间在逻辑上是网络栈的另一个副本。它们可以用于安全域分离，管理虚拟机之间的流量等。
有自己的路由、防火墙规则和网络设备， 你可以在命名空间内运行进程，并将命名空间与物理接口进行桥接。
默认情况下，一个进程会从它的父进程继承它的网络命名空间。最初，从初始化过程中，所有的进程都共享相同的默认网络命名空间。

配置文件: /etc/netns/myvpn/resolv.conf  然后 /etc/resolv.conf  -> ip netns exec

# Create a namespace
ip netns add ${namespace name}
ip netns add NAME	                创建一个新的命名网络空间
ip netns add foo

# List existing namespaces
  ip netns list	                    显示所有命名的网络命名空间

# Delete a namespace
  ip netns delete ${namespace name}
  ip [-all] netns delete [NAME]     删除网名名称空间
  ip netns delete foo
  
# Run a process inside a namespace
  ip netns exec ${namespace name} ${command}
  ip [-all] netns exec [NAME] cmd   在指定ns中执行命令
  ip netns exec foo /bin/sh
  
# 列出分配给命名空间的所有进程
  ip netns pids ${namespace name}
  ip netns pids NAME                报告进程的网络命名空间名称
  
# 确定进程的主要命名空间
  ip netns identify ${pid}
  ip netns identify [PID]           报告进程的网络命名空间名称
  ip netns identify 9000
  
# Assign network interface to a namespace
  ip link set dev ${interface name} netns ${namespace name}
  ip link set dev ${interface name} netns ${pid}
  ip netns set NAME NETNSID         为对等网络命名空间分配一个ID
  ip link set dev eth0.100 netns foo
# 注意：一旦你把一个接口分配给一个命名空间，它就会从默认的命名空间中消失，你必须通过 "ip netns exec ${netspace name}"对它进行所有的操作，
# 如 "ip netns exec ${netspace name} ip link set dev dummy0 down"。
# 此外，当你把一个接口移动到另一个命名空间时，它将失去所有现有的配置，如在其上配置的IP地址，并进入DOWN状态。你需要把它恢复过来，重新配置。

  ip netns attach NAME PID          创建一个新的命名网络空间; 将进程pid关联到NAME网络命名空间
  ip netns monitor                  监控对ns的操作

  cd /var/run/netns/
  
  ip netns add red
  ip netns exec red bash
  ip link set dev veth0 master br0
  
  # Connect one namespace to another
  ### Create a pair of veth devices:
    ip link add name veth1 type veth peer name veth2

  ### Move veth2 to namespace foo:
    ip link set dev veth2 netns foo

  ### Bring veth2 and add an address in "foo" namespace:
    ip netns exec foo ip link set dev veth2 up
    ip netns exec foo ip address add 10.1.1.1/24 dev veth2

  ### Add an address to veth1, which stays in the default namespace:
    ip address add 10.1.1.2/24 dev veth1
    
  # Monitor network namespace subsystem events
    ip netns monitor
EOF
}

ip_t_netns() {  cat - <<'EOF'
ip_netns_vlan_filter.txt  # ip_netns 和 veth vlan的关系
描述了veth点对点网络命名空间形式
      veth-bridge 桥连接方式
      veth-inner-route 内部路由方式
      veth-bridge-outer-route 桥连接外部路由方式 
      veth-outer-route-outer-route-veth 外部路由-外部路由方式

EOF
}

ip_i_maddress() {  cat - <<'EOF'
组播主要是由应用程序和路由守护进程来处理的，所以在这里你可以和应该手动做的事情并不多。与组播相关的ip命令主要用于调试。
# View multicast groups
ip maddress show
ip maddress show ${interface name}
ip maddress show dev lo

# Add a link-layer multicast address
你不能手动加入一个IP组播组，但你可以添加一个组播MAC地址（尽管很少需要）。
ip maddress add ${MAC address} dev ${interface name}
ip maddress add 01:00:5e:00:00:ab dev eth0

# View multicast routes
组播路由不能手动添加，所以这个命令只能显示路由守护程序安装的组播路由。它支持与单播路由查看命令（iif、table、from等）相同的修饰符。
ip mroute show
EOF
}

ip_t_policy_based_routing(){ cat - <<'EOF'
Linux中基于策略的路由(PBR)的设计方式如下：首先你创建自定义的路由表，然后你创建规则来告诉内核它应该使用这些表而不是默认的表来处理特定的流量。
有些table是预定义的
    local (table 255)   # ip route show table 255 | local
        Contains control routes local and broadcast addresses.
        包含控制路由本地和广播地址。
    main (table 254)    # ip route show table 254 | main
        Contains all non-PBR routes. If you do not specify the table when adding a route, it goes here.
        包含所有非 PBR 途径。如果在添加途径时没有指定表，则在这里。
    default (table 253) # ip route show table 253 | default
        Reserved for post processing, normally unused.
        保留给后期处理，一般不使用。
    
    ### Create a policy route 
    ip route add ${route options} table ${table id or name}
    ip route add 192.0.2.0/27 via 203.0.113.1 table 10
    ip route add 0.0.0.0/0 via 192.168.0.1 table ISP2
    ip route add 2001:db8::/48 dev eth1 table 100
# 注意事项 在策略路由中也可以使用 "路由管理 "一节中介绍的任何路由选项，唯一不同的是最后的 "表${表id/名称}"部分。
# 数值表标识符和名称可以互换使用。要创建自己的符号名，请编辑/etc/iproute2/rt_tables配置文件。
# "delete"、"change"、"replace "或其他路由操作也可以在任何表上使用。
# "ip route ... table main "或 "ip route ... table 254 "对没有表部分的命令有完全相同的效果。

    ### View policy routes
    ip route show table ${table id or name}
    ip route show table 100
    ip route show table test
    
    ### General rule syntax
# 匹配${选项}的流量 如果使用 "lookup "动作，将根据指定名称/id的表而不是 "main"/254表进行路由（如下所述）。
# "黑洞"、"禁止 "和 "不可达 "操作，它们以同样的方式路由相同名称的类型。在大多数的例子中，我们将使用 "lookup "动作作为最常见的动作。
    ip rule add ${options} <lookup ${table id or name}|blackhole|prohibit|unreachable>
    
    ###Create a rule to match a source network
    ip rule add from ${source network} ${action}
    ip rule add from 192.0.2.0/24 lookup 10
    ip -6 rule add from 2001:db8::/32 prohibit
    Notes: "all" can be used as shorthand to 0.0.0.0/0 or ::/0
    
    ### Create a rule to match a destination network
    ip rule add to ${destination network} ${action}
    ip rule add to 192.0.2.0/24 blackhole
    ip -6 rule add to 2001:db8::/32 lookup 100
    
    ### Create a rule to match a ToS field value
    ip rule add tos ${ToS value} ${action}
    ip rule add tos 0x10 lookup 110
    
    #### Create a rule to match a firewall mark value
    ip rule add fwmark ${mark} ${action}
    ip rule add fwmark 0x11 lookup 100
    
    ### Create a rule to match inbound interface
    ip rule add iif ${interface name} ${action}
    ip rule add iif eth0 lookup 10
    ip rule add iif lo lookup 20
    
    ### Create a rule to match outbound interface
    ip rule add oif ${interface name} ${action}
    ip rule add oif eth0 lookup 10
    
    ### Set rule priority
# 注意：由于规则是从最低优先级到最高优先级遍历的，并且在第一次匹配时就停止处理，所以需要把比较特殊的规则放在不太特殊的规则之前。
# 上面的例子演示了192.0.2.0/24及其子网192.0.2.0/25的规则。如果把优先级颠倒过来，把/25的规则放在/24的规则之后，就永远也达不到。
    ip rule add ${options} ${action} priority ${value}
    ip rule add from 192.0.2.0/25 lookup 10 priority 10
    ip rule add from 192.0.2.0/24 lookup 20 priority 20
    
    ### Show all rules
    ip rule show
    ip -6 rule show
    
    ### Delete a rule
    ip rule del ${options} ${action}
    ip rule del 192.0.2.0/24 lookup 10
    
    # 注意：此操作具有很强的破坏性。即使你没有配置任何规则，"from all lookup main "规则也是默认初始化的。
    Notes: You can copy/paste from the output of "ip rule show"/"ip -6 rule show".
    ### Delete all rules
    ip rule flush
    ip -6 rule flush
    
    # "from all lookup local "规则是特殊的，不能删除。而 "from all lookup main "则不是，可能有合理的理由不需要它，
    # 例如，如果你想只路由你创建的显式规则的流量。作为一个副作用，如果你进行 "ip rule flush"，这个规则将被删除，
    # 这将使系统停止路由任何流量，直到你恢复规则。
EOF
}

ip_t_ntable(){ cat - <<'ip_t_ntable'
inet arp_cache 
    dev eth0 
    refcnt 1 reachable 38836 base_reachable 30000 retrans 1000 
    gc_stale 60000 delay_probe 5000 queue 31 
    app_probes 0 ucast_probes 3 mcast_probes 3 
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000 
    
inet6 ndisc_cache 
    dev eth0 
    refcnt 1 reachable 28056 base_reachable 30000 retrans 1000 
    gc_stale 60000 delay_probe 5000 queue 31 
    app_probes 0 ucast_probes 3 mcast_probes 3 
    anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0 
ip_t_ntable
}

ip_t_netconf(){ cat - <<'EOF'
网络配置监控
该实用程序可以监控IPv4和IPv6参数(参见/proc/sys/net/ipv[4|6]/conf/[all|DEV]/)，如forwarding、rp_filter或mc_forwarding状态。
ipv4 dev lo forwarding on rp_filter strict mc_forwarding 0 


# View sysctl configuration for all interfaces
ip netconf show
ip netconf show dev ${interface}
ip netconf show dev eth0
EOF
}

ip_e_monitoring(){ cat - <<'EOF'
  ip monitor ${event type}
      Event type can be:
      link
          Link state: interfaces going up and down, virtual interfaces getting created or destroyed etc.
      address
          Link address changes.
      route
          Routing table changes.
      mroute
          Multicast routing changes.
      neigh
          Changes in neighbor (ARP and NDP) tables.
  
  When there are distinct IPv4 and IPv6 subsystems, the usual "-4" and "-6" options allow you to display events only for specified protocol. As in:
  ip -4 monitor route
  ip -6 monitor neigh
  ip -4 monitor address
  ip monitor all 
  
# iproute2中包含了一个名为 "rtmon "的程序，其作用基本相同，但会将事件写入二进制日志文件，而不是显示。
# "ip monitor "命令可以让你读取程序创建的文件"。
  ip monitor ${event type} file ${path to the log file}
  
# rtmon 语法与 "ip monitor "类似，但事件类型仅限于链接、地址、路由和所有；地址族在"-family "选项中指定。
  rtmon [-family <inet|inet6>] [<route|link|address|all>] file ${log file path}
EOF
}

ip_k_lnstat(){  cat - <<'EOF'
统一的linux网络统计
-c：指定显示网络状态的次数，每隔一定时间显示一次网络状态；
-d：显示可用的文件或关键字；
-i：指定两次显示网络状的间隔秒数；
-k：只显示给定的关键字；
-s：是否显示标题头；
-w：指定每个字段所占的宽度。

lnstat -k arp_cache:entries,rt_cache:in_hit,arp_cache:destroys
lnstat -c -l -i l -f rt_cache -k entries,in_hit,in_slow_tot

lnstat -d | grep proc
/proc/net/stat/arp_cache:
/proc/net/stat/rt_cache:
/proc/net/stat/ndisc_cache:
/proc/net/stat/nf_conntrack:

lnstat -d                       # 查看网络统计信息，得到支持的统计文件的列表
lnstat  -i 10                   # 指定间隔时间为10秒查看网络统计信息
lnstat -f /root/ip_conntrack    # 查看网络统计信息，指定使用的统计文件为/root/ip_conntrack
lnstat  -s 20                   # 查看网络统计信息，显示头每20行
lnstat -k arp_cache:entries,rt_cache:in_hit,arp_cache:destroys  # 查看网络统计信息，选择指定的文件和字段
lnstat -c -l -i l -f rt_cache -k entries,in_hit,in_slow_tot     # 查看网络统计信息，统计显示字段条目
EOF
}