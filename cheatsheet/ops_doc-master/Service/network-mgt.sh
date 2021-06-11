arp(管理ARP表)
{
arp -n #显示不包含名称解析的ARP表
arp -s 192.168.2.10 00:e0:4c:11:22:33
}

arping(发送ARP请求的工具)
{
arping -D #重复地址检测
}

arptables(基于LinuxARP规则防火墙配置规则的用户空间工具)
{
ebtables.sourceforge.net
}

arpwatch(用于监视ARP流量的用户空间工具)
{
ee.lbl.gov
}

ab(ApacheBench)
{
测量HTTP Web服务器的性能
apache2-utls
ab -n 100 http://www.google.com/
}

brctl(以太网网桥的命令行工具)
{
brctl addbr mybr
brctl delbr mybr
brctl addif mybr eth1
brctl delif mybr eth1
brctl show

}

conntrack-tools(管理netfilter连接跟踪的用户空间工具)
{
包括用户空间守护程序conntrackd和命令行工具conntrack
}

crtools(进程检查点/恢复工具)
{

}

ebtables(基于Linux的网桥防火墙配置规则的用户空间工具)
{

}

ether-wake(用于发送局域网唤醒Magic数据包的工具)
{

}

ethtool(查询和控制网络驱动程序和硬件配置、获取统计信息、获取诊断信息等等)
{
ethtool eth0
ethtool -k eth1 #获取减负参数
ethtool -K eth1 offLoadParamater #设置减负参数
ethtool -i eth1 #查询网络设备的驱动程序信息
ethtool -S eth1 #统计信息
ethtool -P eth0 #显示MAC地址
}

git()
{

}

hciconfig(配置蓝牙设备的命令行工具)
{
hciconfig
}

hcidump(用于将来自和前往蓝牙设备的原始HCI数据进行转存的命令工具)
{

}

hcitool(用于配置蓝牙连接以及向蓝牙发送特殊命令的命令行工具)
{

}

ifconfig()
{
ifconfig eth0 mtu 1300
ifconfig eth0 txqueuelen 1100
ifconfig eth0 -arp
net-tools-sourceforge.net
}

ifenslave(用于将从网络设备与捆绑设备进行关联和接触关联的工具)
{
捆绑指的是将多个以太网络设备加入一个逻辑设备中，通常被称为链路聚合、中继或链路捆绑。
documentation/networking/ifenslave.c。
ifenslave bond0 eth0 #将eth0加入到捆绑设备bond0中
iptuls
www.skbuff.net/iptuls
}

iperf(测量TCP性能工具)
{

}

iproute2(高版本支持的内容多)
{
[man ip-address]
ip addr add 192.168.0.10/24 dev eth0
ip addr show

[man ip-link]
ip link add mybr type bridge       #创建一个名为mybr的网桥
ip link add name myteam type team  #创建一个名为myteam的组合设备
ip link set eth1 mtu 1450

[man ip-neigh]
ip neigh show 
ip -6 neigh show
ip neigh flush dev eth0
ip neigh add 192.168.2.20 dev eth2 lladdr 00:11:22:33:44:55 nud permanent
ip neigh change 192.168.2.20 dev eth2 lladdr 55:44:33:22:11:00 nud permanent

[man ip-ntable]
管理邻居表参数
ip ntable show
ip ntable change name arp_cache locktime 1200 dev eth0 #在IPv4邻居表中修改eth0的locktime参数

[man ip-netns]
管理网络命名空间
ip netns add myNamespace
ip netns del myNamespace
ip netns list
ip netns monitor

[man ip-maddr]
ip maddr show
ip maddr add 00:01:02:03:04:05 dev eth1 

ip monitor route

ip route show
ip route flush dev eth1
ip route add defalut via 192.168.2.1 
ip route get 192.168.2.10

ip rule add tos 0x02 table 200
ip rule del tos 0x02 table 200
ip rule show

ip tuntap add tun1 mode tun
ip tuntap del tun1 mode tun
ip tuntap add tap1 mode tap
ip tuntap del tap1 mode tap

ip xfrm policy show
ip xfrm state show

ss -t -a #用于显示所有TCP套接字

bridge 显示和操作网桥地址和设备
genl   获取已注册的通用netlink族的信息
genl ctrl list 
lnstat 显示Linux网络统计信息
rtmon 监视rtnetlink套接字
tc    显示和操作流量控制设置
tc qdisc show #显示添加了那些排队原则(qdisc)条目
tc -s qdisc show dev eth1 #显示与eth1相关联的qdisc的统计信息

}

iptables()
{

}

iptables6()
{
iptables -A INPUT -p tcp --dport=80 -j LOG --log-level 1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
}

ipvsadm(管理Linux虚拟服务器的工具)
{

}

iw(显示操作无线设备及其配置)
{
iw包基于Netlink套接字
iw dev wlan0 scan #扫描附近的无线设备
iw wlan0 station dump #显示无线客户端的统计信息
iw list #获取无线设备的信息，如频段信息和802.11n信息
iw dev wlan0 get power_save #获取省电模式
iw dev wlan0 set type ibss #设置无线接口的模式改为ibss(Ad_hoc)
iw dev wlan0 set type mesh #设置无线接口的模式改为网状模式
iw dev wlan0 set type monitor #设置无线接口的模式为监视模式
iw dev wlan0 set type managed #设置无线接口的模式为托管模式
}

iwconfig(较旧的无线设备管理工具)
{
基于IOCTL，
wireless-tools包中。
}

libreswan(IPSec软件解决方案)
{
libreswan.org
}

l2ping(通过蓝牙设备发送L2CAP回应请求和接收应答的命令行工具)
{
www.bluez.org
}

lowpan-tools(管理Linux LoWPAN)
{
sourceforge.net/projects/linux-zigbee/files/linux-zigbee-sources/0.3/
}

lshw(显示机器硬件配置)
{
ezix.org/project/wiki/HardwareLiSter
}

lscpu(显示系统CPU信息的工具)
{
util-linux
}

lspci(显示系统PCI总线以及所连接设备的信息的工具)
{
pciutils
}

mrouted(组播路由选择守护程序)
{
troglobit.com/mrouted.html
}

nc(通过网络读写数据的命令行工具)
{
包含在nmap-ncat包中
}

ngrep()
{
它能够让你指定用于匹配数据包有效载荷的扩展表达式，并识别穿越以网络、PPP、SLIP、FDDI和空接口的TCP、UDP和ICMP数据报文
ngrep.sourceforge.net
}

netperf(网络基准建立工具)
{
www.netperf.org/netperf
}

netsniff-ng(网络工具包)
{
帮助分析网络流量、执行压力测试、以极高的速度生成数据包等等。
它使用PF_PACKET零拷贝RING(在传输和接收路径上)，提供的工具包括以下几种
另拷贝快速分析器pcap是一个捕获和重放工具。这个netsniff-ng工具是Linux专用的，不想本附录接收的众多其他工具那样支持其操作系统。
例如：netsniff-ng --in eth1 --out dump.pcap -s -b 0 #创建一个供wireshark或tcpdump读取的pcap文件。
标志-s表示沉默方式，-b 0表示绑定CPU 0
trafgen是一个零拷贝的高性能网络数据生成包
ifpps是一个小型工具，像top那样定期地提供来自内核的网络和系统统计信息。
ifpps会直接从procfs文件中收集这些信息。
bpfc是一个小型的伯克利数据包过滤器
netsniff-ng.org
}

netstat(显示组播组成员信息、路由选择表、网络连接、接口统计信息、头戒子状态等等)
{
net-tools
netstat -s #显示每种协议的统计信息摘要
netstat -g #显示IPv4和IPv6组播组成员信息
netstat -r #显示内核IP路由选择表
netstat -nl #显示正在侦听的套接字
netstat -aw #显示所有的原始套接字
netstat -ax #显示所有的Unix套接字
netstat -at #显示所有TCP套接字
netstat -au #显示所有UDP套接字
 net-tools.sourceforge.net
}

nmap(开源安全项目，提供网络探索和探测的工具以及一个安全/端口扫描器)
{
端口扫描，OS检查、MAC地址检查等
nmap www.google.com
nping 用于生成原始数据包，以及发起ARP投毒和拒绝服务器攻击，以及像ping那样进行连接性检查
nping #nmap.org/book/nping-man-ip-options.html
nmap.org
}

openswan(基于IPSec的VPN解决方案)
{
在FreeS/Wan项目的基础上开发的。
www.openswan.org/projects/openswan
}

OpenVPN(基于SSL/TLS的VPN解决方案)
{
www.openvpn.net
}

packeth(基于以太网的数据包生成器)
{
http://packeth.sourceforge.net/packeth/Home.html
}

ping(iputils www.skbuff.net.iputils)
{
-Q tos 设置ICMP数据包的服务质量位。
-R   设置记录路由IP选项
-T   设置时间戳IP选项
-f   洪泛ping
}

pimd(轻量级PIM-SM)
{
协议无关组播-稀疏模式v2守护进程
troglobit.com/pimd.html
github.com.troglobit/pimd
}

poptop(Linux PPTP服务器)
{
poptop.sourceforge.net/dox
}

ppp(PPP守护进程)
{
git://ozlabs.org/~paulus/ppp.git
ppp.samba.org/download.html
}

pktgen()
{
net/core/pktgen.c
能够以极高的速度生成数据包。
监视和控制时通过写入/proc/net/pktgen条目实现的

documentation/networking/pktgen.txt
}

radvd(IPv6路由器通告守护进程)
{
用于进行IPv6无状态自动配置和重新编址。
www.litech.org/radvd
github.com/reubenhwk/radvd
}

route(用于管理路由选择表的命令行工具)
{
net-tools；基于IOCTL
route -n #显示路由选择表，但不进行名字解析
route add default gateway 192.168.1.1 #将192.168.1.1指定为默认网关
route -C #显示路由选择缓存
man route
}

RP-PPPoE(开源以太网PPPoE客户端)
{
www.roaringpenguin.com/products/pppoe
}

sar(用于收集并报告系统活动统计信息的命令行工具)
{
它是一个用于收集并报告系统活动统计信息的命令行工具，包含在sysstat包中。
sar 1 4 #显示4个时点的CPU统计信息
sebastien.godard.pagesperso-orange.fr
}

smcroute(用于操纵组播路由选择的命令行工具)
{
www.cschill.de/smcroute
}

snort(网络入侵检测系统和网络入侵防范系统)
{
www.snort.org
}

suricata()
{

}

strongSwan(实现了用于Linux、Android和其他操作系统的IPSec解决方案)
{
www.strongSwan.org

}

sysctl(显示运行阶段的内核参数和设置内核参数)
{
sysctl -a  #显示内核参数。工具sysctl包含在procps-ng包中。

}

taskset(设置或获取进程的CPU亲和性的命令行工具)
{
util-linux
}

tcpdump(开源的命令行协议分析器)
{
开源的命令行协议分析器,基于c/c++网络流量捕获库libpcap.
与wireshark一样，它也能够将结果写入文件以及从文件读取结果，并支持过滤。
与wireshark不一样，它没有前端GUI。
它的输出文件可供wireshark读取。
tcpdump -i eth1
www.tcpdump.org
}

top(系统实时视图以及系统摘要)
{
procps-ng
gitorious.org/procps
}

tracepath(跟踪目标地址的路径)
{
跟踪目标地址的路径,并发现该路径的MTU。
IPv6：tracepath6
iputils
www.skbuff.net/iputils
}

traceroute(显示前往指定目的地的路径)
{
他利用IP协议的存活时间TTL字段让路径中的主机发送ICMP TIME EXCEEDED消息。
工具traceroute在介绍ICMP协议的
traceroute.sourceforge.net
}

tshark(命令行数据分析器)
{
    工具tshark提供了一个命令行数据包分析器，它是wireshark包的一部分，有很多命令行选项。例如：可使用选项-w将输出写入文件。
使用tshark可设置各种过滤器对数据包进行过滤，其中一些还很复杂。
tshark -R icmp #设置一个过滤器，以便只捕获ICMPv4数据包
tshark -R "ip.dsfield==0x2" #针对IPv4报头字段的过滤器
ping -Q 0x2 destinationAddress 发送ip.dsfield==0x2的IPv4数据包
tshark ether src host 00:e0:4c:11:22:33 #根据源MAC地址进行过滤
tshark -R udp portrange 6000-8000  #过滤端口号为6000-8000的UDP数据包
tshark -i eth1 -f "src host 192.168.2.200 and port 80" #捕获源IP地址为192.168.2.200 且 端口为 80

    
}

tunctl(用于创建tun/tap设备)
{
tunctl是一个较旧的工具，用于创建tun/tap设备，可从http://tunctl.sourceforge.net下载

注意：要创建或删除TUN/TAP工具。也可以使用ip命令或openvpn工具包中的命令行工具
openvpn --mktun --dev tun1
openvpn --rmtun --dev tun1
}

udevadm(获悉网络设备的类型)
{
要获悉网络设备的类型，可使用udevadm并指定设备sysfs条目。例如，如果设备的sysfs条目为/sys/devices/virtual/net/eth1.100,
你将发现其设备类型为VLAN

udevadm info -q all -p /sys/devices/virtual/net/eth1.100

www.kernel.org/pub/linux/utils/kernel/hotplug/udev/html
}

unshare(创建命名空间)
{
工具unshare能够让你创建命名空间，并在其中运行其父命名空间未共享的程序。
unshare包含在util-linux包中。 
man unshare

unshare -u /bin/bash #创建一个UTS的命名空间
unshare --net /bin/bash #创建一个网络命名空间，并在其中启动一个bash进程
http://git.kernel.org/cgit/utils/util-linux/util-linux.git

}

vconfig(用于配置VLAN接口)
{
vconfig add eth2 100  #添加一个VLAN接口。这将创建一个VLAN接口 ---- eth2.100
vconfig rem eth2.100  #将VLAN接口eth2.100删除
注意要添加和删除VLAN接口，也可以使用如下ip命令
ip link add link eth0 name eth0.100 type vlan id 100
ip link delete dev eth0.100

vconfig set_egress_map eth2.100 0 4 # 将SKB优先级0映射到VLAN优先级4.这样将使用VLAN优先级4对SKB优先级为0的出栈数据包进行标识。
                                    # VLAN优先级默认为0.
vconfig set_ingress_map eth2.100 1 5 # 将SKB优先级5映射到SKB优先级11.这样，对于VLAN优先级为5的入站数据包，将根据SKB优先级1进行排队
                                     # SKB优先级默认为0.
man vconfig
请注意，如果支持VLAN的代码被编译成内核模块，则在添加VLAN接口前，必须使用modprobe 8021q 加载VLAN内核模块
www.candelatech.com/~greear/vlan.html
                                     
}

wpa_supplicant(无线恳求端，支持WPA和WPA2)
{
http://hostap.epitest.fi/wpa_supplicant
}


wireshark(协议分析器和嗅探器)
{
前端GUI和后端tshark
1. 支持定义各种针对端口、目标或源地址、协议标识符、报头字节等的过滤器。
2. 支持根据各种参数协议类型、时间等对结果进行排序
3. 可将嗅探器输出保存到文件，还可以读取文件中的嗅探器输出
4. 可读写的捕获其文件格式众多，如tcpdump(libpcap) Pcap NG等
5. 支持捕获过滤器和显示过滤器

man wireshark 和 man tshark

http://wiki.wireshark.org/SampleCaptures  嗅探实例
http://www.wireshark.org/
http://wiki.wireshark.org/
}

XORP(可扩展的开放路由器平台, 各种路由选择协议)
{
eXtensible Open Router Platform : 可扩展的开放路由器平台 开源项目
www.xorp.org
}