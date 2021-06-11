#!/bin/sh

/sbin/modprobe ip_conntrack_ftp

CONNECTION_TRACKING="1"
ACCEPT_AUTH="0"
SSH_SERVER="1"
FTP_SERVER="0"
WEB_SERVER="0"
SSL_SERVER="0"
DHCP_CLIENT="1"

IPT="/sbin/iptables"                 # Location of iptables on your system
INTERNET="eth0"                      # Internet-connected interface
LOOPBACK_INTERFACE="lo"              # however your system names it
IPADDR=""                            # your IP address
SUBNET_BASE=""                       # ISP network segment base address
SUBNET_BROADCAST=""                  # network segment broadcast address
MY_ISP=""                            # ISP server & NOC address range 

NAMESERVER=""                        # address of a remote name server
POP_SERVER=""                        # address of a remote pop server
MAIL_SERVER=""                       # address of a remote mail gateway
NEWS_SERVER=""                       # address of a remote news server
TIME_SERVER=""                       # address of a remote time server
DHCP_SERVER=""                       # address of your ISP dhcp server

LOOPBACK="127.0.0.0/8"               # reserved loopback address range
CLASS_A="10.0.0.0/8"                 # Class A private networks
CLASS_B="172.16.0.0/12"              # Class B private networks
CLASS_C="192.168.0.0/16"             # Class C private networks
CLASS_D_MULTICAST="224.0.0.0/4"      # Class D multicast addresses
CLASS_E_RESERVED_NET="240.0.0.0/5"   # Class E reserved addresses
BROADCAST_SRC="0.0.0.0"              # broadcast source address
BROADCAST_DEST="255.255.255.255"     # broadcast destination address

PRIVPORTS="0:1023"                   # well-known, privileged port range
UNPRIVPORTS="1024:65535"             # unprivileged port range

SSH_PORTS="1024:65535"

###############################################################

# Enable broadcast echo Protection
# 通知内核丢弃发送广播地址或组播地址的CIMP echo请求消息
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# icmp_echo_ignore_all 丢弃所有传入echo请求消息
# ISP通常使用ping来帮助诊断本地网络的问题，DHCP有时依赖于echo请求以避免地址冲突。

# Disable Source Routed Packets
# 丢弃所有源路由数据包
for f in /proc/sys/net/ipv4/conf/*/accept_source_route; do
    echo 0 > $f
done

# Enable TCP SYN Cookie Protection
# 快速检测SYN洪水攻击以及SYN洪水攻击恢复机制
echo 1 > /proc/sys/net/ipv4/tcp_syncookies

# Disable ICMP Redirect Acceptance
# 不接收ICMP重定向报文
for f in /proc/sys/net/ipv4/conf/*/accept_redirects; do
    echo 0 > $f
done

# Don’t send Redirect Messages
# 不发送ICMP重定向报文
for f in /proc/sys/net/ipv4/conf/*/send_redirects; do
    echo 0 > $f
done

# Drop Spoofed Packets coming in on an interface, which, if replied to,
# would result in the reply going out a different interface.
# 禁用源地址确认: 一个传入的数据包中带有一个源地址，如果主机的转发表指出，用该数据包中
# 的这个源地址作为目的地址转发另一个数据报却不能将其从传入的接口发出的话，该传入的数据报将被静默地丢弃。
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
    echo 1 > $f
done

# Log packets with impossible addresses.
# 记录来自不太可能的地址的数据报
for f in /proc/sys/net/ipv4/conf/*/log_martians; do
    echo 1 > $f
done

###############################################################

# Remove any existing rules from all chains
$IPT --flush                                # 移除所有预先存在的规则
$IPT -t nat --flush                         # 刷新指定表的规则
$IPT -t mangle --flush                      # 刷新指定表的规则

# 刷新规则链并不会影响当前起作用的默认策略状态，-X删除任何用户自定义的规则链
$IPT -X                                     # 删除任何用户自定义的规则链
$IPT -t nat -X                              # 删除指定表的规则链
$IPT -t mangle -X                           # 删除指定表的规则链

###############################################################
#   在iptables中，默认策略似乎是最先匹配规则为准的例外。默认策略命令不依赖于其位置。他们本身不是规则。一个规则链
# 的默认策略是指，一个数据报与规则链上的规则都做了比较未找到匹配之后所采取的策略。
#   在nftables中，最先匹配的规则总是胜出，而且不存在默认策略
# 在定义规则为DROP之前，必须先重置默认规则为ACCEPT
# 重置默认策略
$IPT --policy INPUT   ACCEPT                # 重置默认策略
$IPT --policy OUTPUT  ACCEPT                # 
$IPT --policy FORWARD ACCEPT                # 
$IPT -t nat --policy PREROUTING  ACCEPT
$IPT -t nat --policy OUTPUT      ACCEPT
$IPT -t nat --policy POSTROUTING ACCEPT
$IPT -t mangle --policy PREROUTING ACCEPT   # 
$IPT -t mangle --policy OUTPUT ACCEPT       # 
if [ "$1" = "stop" ]
then
  echo "Firewall completely stopped!  WARNING: THIS HOST HAS NO FIREWALL RUNNING."
  exit 0
fi

# Unlimited traffic on the loopback interface
# 启用回环接口
$IPT -A INPUT  -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

# Set the default policy to drop
# 定义默认策略
$IPT --policy INPUT   DROP
$IPT --policy OUTPUT  DROP
$IPT --policy FORWARD DROP

###############################################################
# Stealth Scans and TCP State Flags

# All of the bits are cleared
$IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
# SYN and FIN are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
# SYN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
# FIN and RST are both set
$IPT -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
# FIN is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
# PSH is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
# URG is the only bit set, without the expected accompanying ACK
$IPT -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP

###############################################################
# 同时包含iptables的静态规则和动态规则
#   在伸缩性和状态表超时方面的资源限制要求同时使用静态规则和动态规则。这种限制成为了大型商业防火墙的一个卖点。
#   可扩展性主要是因为，大型的防火墙往往需要同时处理50000-100000个连接，有大量的状态要处理。系统资源有时会被用尽，
# 这样就无法完成连接的跟踪。要么必须丢弃新的连接，要么必须将软件回退到无状态模式
#   还有一个问题就是超时。状态连接不能永远保持。一些慢速或静止态的连接会轻易地被清除掉，从而为更加活跃的连接留出空间。
# 当一个数据报又传来时，状态信息必须被重建。与此同时，当传输堆栈查找连接信息并且通知状态模块该数据报确实是已建立交换
# 的一部分时，数据包流回退到无状态模式。
# Using Connection State to By-pass Rule Checking
# 利用连接状态绕过规则检查
if [ "$CONNECTION_TRACKING" = "1" ]
then
  $IPT -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT
  $IPT -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
  $IPT -A INPUT -m state --state INVALID -j LOG \
           --log-prefix "INVALID input: "
  $IPT -A INPUT -m state --state INVALID -j DROP
 
  $IPT -A OUTPUT -m state --state INVALID -j LOG \
           --log-prefix "INVALID output: "
  $IPT -A OUTPUT -m state --state INVALID -j DROP
fi 

###############################################################
# Source Address Spoofing and Other Bad Addresses
# 源地址欺骗及其他不合法地址
# 防火墙日志
# -j LOG 目标为匹配规则的数据报启用日志。当数据报匹配此规则时，这个事件会被记录到/var/log/messages，
# 或记录到任何你特别指出的地方。

# Refuse spoofed packets pretending to be from
# the external interface’s IP address
$IPT -A INPUT  -i $INTERNET -s $IPADDR -j DROP

# 不允许A B C类私有网络地址为源地址的数据报传入。在一个公网中，不允许出现。
# Refuse packets claiming to be from a Class A private network
$IPT -A INPUT  -i $INTERNET -s $CLASS_A -j DROP

# Refuse packets claiming to be from a Class B private network
$IPT -A INPUT  -i $INTERNET -s $CLASS_B -j DROP

# Refuse packets claiming to be from a Class C private network
$IPT -A INPUT  -i $INTERNET -s $CLASS_C -j DROP
# Refuse packets claiming to be from the loopback interface
# 回环地址是内部的本地软件接口所分配的，任何声称来自于此地址的数据包都是故意伪造的。
$IPT -A INPUT  -i $INTERNET -s $LOOPBACK -j DROP

# Refuse malformed broadcast packets
# 默认策略拒绝一切。广播地址会被默认丢弃，如果想要他们的话，需要明确地启用它
# 记录并拒绝所有声称来自于 255.255.255.255的数据包
$IPT -A INPUT  -i $INTERNET -s $BROADCAST_DEST -j LOG
$IPT -A INPUT  -i $INTERNET -s $BROADCAST_DEST -j DROP

# 记录并拒绝任何发往目的地址0.0.0.0的数据包
$IPT -A INPUT  -i $INTERNET -d $BROADCAST_SRC  -j LOG
$IPT -A INPUT  -i $INTERNET -d $BROADCAST_SRC  -j DROP

# 阻塞两种形式的直接广播
# SUBNET_BASE 是你的网络地址 192.168.1.0
# SUBNET_BROADCAST 是你网络的广播地址 192.168.1.255
if [ "$DHCP_CLIENT" = "0" ]; then
  # Refuse directed broadcasts
  # Used to map networks and in Denial of Service attacks
  $IPT -A INPUT -i $INTERNET -d $SUBNET_BASE -j DROP
  $IPT -A INPUT -i $INTERNET -d $SUBNET_BROADCAST -j DROP
  
  # Refuse limited broadcasts
  $IPT -A INPUT -i $INTERNET -d $BROADCAST_DEST -j DROP
fi

# Refuse Class D multicast addresses
# illegal as a source address
# 丢弃假冒的组播网络数据包
$IPT -A INPUT -i $INTERNET -s $CLASS_D_MULTICAST -j DROP

# 拒绝接受非UDP的数据包
$IPT -A INPUT -i $INTERNET ! -p UDP -d $CLASS_D_MULTICAST -j DROP

# 允许传入的组播数据包
$IPT -A INPUT  -i $INTERNET -p udp -d $CLASS_D_MULTICAST -j ACCEPT

# 丢弃声称来自于E类保留网络的数据包
# Refuse Class E reserved IP addresses
$IPT -A INPUT  -i $INTERNET -s $CLASS_E_RESERVED_NET -j DROP

###############################################################
# 澄清IP地址0.0.0.0的意义
#   地址0.0.0.0被保留用于广播源地址，netfilter约定中指定的与任意地址(any/0,0.0.0.0/0, 0.0.0.0/0.0.0.0) 进行的匹配
# 不会匹配广播源地址。原因是广播数据报第二帧报文头中的比特指明了: 它是一个广播数据包并且发往网络中的所有接口，
# 而不是发往特定目的地址点对点单播。对广播数据包的处理与非广播数据包的处理不同。IP地址0.0.0.0不是合法的非广播地址。

if [ "$DHCP_CLIENT" = "1" ]; then
  $IPT -A INPUT  -i $INTERNET -p udp \
           -s $BROADCAST_SRC --sport 67 \
           -d $BROADCAST_DEST --dport 68 -j ACCEPT
fi

# refuse addresses defined as reserved by the IANA
# 0.*.*.*          - Can’t be blocked unilaterally with DHCP
# 169.254.0.0/16   - Link Local Networks
# 192.0.2.0/24     - TEST-NET

$IPT -A INPUT -i $INTERNET -s 0.0.0.0/8 -j DROP
$IPT -A INPUT -i $INTERNET -s 169.254.0.0/16 -j DROP
$IPT -A INPUT -i $INTERNET -s 192.0.2.0/24 -j DROP

###############################################################
# 阻止本地客户端向远程NFS服务器， Open Windows管理 Socks代理服务器和squid Web缓存服务器发起的连接请求
NFS_PORT="2049"            # (TCP) NFS
SOCKS_PORT="1080"          # (TCP) socks
OPENWINDOWS_PORT="2000"    # (TCP) OpenWindows
SQUID_PORT="3128"          # (TCP) squid

$IPT -A OUTPUT -o $INTERNET -p tcp -m multiport --destination-port \
    $NFS_PORT,$SOCKS_PORT,$OPENWINDOWS_PORT,$SQUID_PORT --syn -j REJECT

$IPT -A INPUT -i $INTERNET -p tcp -m multiport --destination-port \
    $NFS_PORT,$SOCKS_PORT,$OPENWINDOWS_PORT,$SQUID_PORT --syn -j DROP

###############################################################
# 分配在非特权端口上的常用本地UDP服务
NFS_PORT="2049"
LOCKD_PORT="4045"

$IPT -A OUTPUT -o $INTERNET -p udp
    -m multiport --destination-port $NFS_PORT,$LOCKD_PORT \
    -j REJECT
    
$IPT -A INTPUT -i $INTERNET -p udp
    -m multiport --destination-port $NFS_PORT,$LOCKD_PORT \
    -j REJECT
    
###############################################################
# 允许DNS(UDP/TCP 端口 53)
# DNS Name Server

# DNS Forwarding Name Server or client requests
# 允许作为客户端的DNS查询
## UDP 协议
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p udp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $NAMESERVER --dport 53 \
             -m state --state NEW -j ACCEPT
fi
 
$IPT -A OUTPUT -o $INTERNET -p udp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $NAMESERVER --dport 53 -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p udp \
         -s $NAMESERVER --sport 53 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

#...............................................................
# TCP is used for large responses
# 允许作为客户端的DNS查询
## TCP 协议
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $NAMESERVER --dport 53 \
             -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $NAMESERVER --dport 53 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         -s $NAMESERVER --sport 53 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

#...............................................................
# DNS Caching Name Server (local server to primary server)
# BIND 或 dnsmasq/
# 允许作为转发服务器的DNS查询
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p udp \
             -s $IPADDR --sport 53 \
             -d $NAMESERVER --dport 53 \
             -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p udp \
         -s $IPADDR --sport 53 \
         -d $NAMESERVER --dport 53 -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p udp \
         -s $NAMESERVER --sport 53 \
         -d $IPADDR --dport 53 -j ACCEPT

#...............................................................
# Incoming Remote Client Requests to Local Servers
# auth 认证服务

if [ "$ACCEPT_AUTH" = "1" ]; then
    if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport $UNPRIVPORTS \
             -d $IPADDR --dport 113 \
             -m state --state NEW -j ACCEPT
    fi

$IPT -A INPUT  -i $INTERNET -p tcp \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport 113 -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
         -s $IPADDR --sport 113 \
         --dport $UNPRIVPORTS -j ACCEPT
else
$IPT -A INPUT -i $INTERNET -p tcp \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport 113 -j REJECT --reject-with tcp-reset
fi

###############################################################
# 通过外部IS网管SMTP服务器传递传出邮件
SMTP_GATEWAY="my.isp.server" # External mail server or relay
if [ "$CONNECTION_TRACKING" = "1" ]; then
  $IPT -A output -o $INTERNET -p tcp \
    -s $IPADDR --sport $UNPRIVPORTS \
    -d $SMTP_GATEWAY --dport 25 -m state -state NEW -j ACCEPT
fi
$IPT -A OUTPUT -o $INTERNET -p tcp \
    -s $IPADDR --sport $UNPRIVPORTS \
    -d $SMTP_GATEWAY --dport 25 -j ACCEPT
$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
    -s $SMTP_GATEWAY --dport 25 \
    -d  $IPADDR --sport $UNPRIVPORTS -j ACCEPT

###############################################################
# Sending Mail to Any External Mail Server
# Use "-d $MAIL_SERVER" if an ISP mail gateway is used instead
# smtp 服务
# 发送邮件到任意的外部邮件服务器

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport 25 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport 25 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport 25 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

###############################################################
# 作为本地SMTP服务器接收邮件 (TCP 端口25)
if [ "$CONNECTION_TRACKING" = "1" ]; then
  $IPT -A INTPUT -i $INTERNET -p tcp \
    --sport $UNPRIVPORTS -d $IPADDR --dport 25 \
    -m state --state NEW -j ACCEPT
fi
$IPT -A INTPUT -i $INTERNET -p tcp \
    --sport $UNPRIVPORTS -d $IPADDR --dport 25 -j ACCEPT
    
$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
    -s $IPADDR --sport 25 --dport $UNPRIVPORTS -j ACCEPT



###############################################################
# Retrieving Mail as a POP Client (TCP Port 110)
# pop服务 / POP运行在110 POP/s 995 -> /etc/service

# 普通 110 端口
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $POP_SERVER --dport 110 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $POP_SERVER --dport 110 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         -s $POP_SERVER --sport 110 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

# SSL 995 端口
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $POP_SERVER --dport 995 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $POP_SERVER --dport 995 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         -s $POP_SERVER --sport 995 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

###############################################################
# Retrieving Mail as a IMAP Client (TCP Port 143)
# IMAP服务 / IMAP运行在143 POP/s 993 -> /etc/service

# 普通 143 端口
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $POP_SERVER --dport 143 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $POP_SERVER --dport 143 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         -s $POP_SERVER --sport 143 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

# SSL 993 端口
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $POP_SERVER --dport 993 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $POP_SERVER --dport 993 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         -s $POP_SERVER --sport 993 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

###############################################################
# 为远程客户端托管一个POP服务器
#   在小型系统中托管一个公共的POP或IMAP服务不太常见。你这样做可能你是因为你在为一些朋友提供远程邮件服务。
# 例如，如果他们的ISP邮件服务暂时不可用，在任何情况下，限制你的系统接收从客户端发起的连接十分重要，
# 不论在数据报过滤层还是在服务区配置层
if [ "$CONNECTION_TRACKING" = "1" ]; then
  $IPT -A INPUT -i $INTERNET -p tcp \
    -s <my.pop.clients> --sport $UNPRIVPORTS \
    -d $IPADDR --dport 110 \
    -m state --state NEW -j ACCEPT
fi
$IPT -A INPUT -i $INTERNET -p tcp \
    -s <my.pop.clients> --sport $UNPRIVPORTS \
    -d $IPADDR --dport 110 -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp \
    -d <my.pop.clients> --dport $UNPRIVPORTS \
    -s $IPADDR --sport 110 -j ACCEPT

###############################################################
# 为远程客户端托管一个IMAP服务器
if [ "$CONNECTION_TRACKING" = "1" ]; then
  $IPT -A INPUT -i $INTERNET -p tcp \
    -s <my.pop.clients> --sport $UNPRIVPORTS \
    -d $IPADDR --dport 143 \
    -m state --state NEW -j ACCEPT
fi
$IPT -A INPUT -i $INTERNET -p tcp \
    -s <my.pop.clients> --sport $UNPRIVPORTS \
    -d $IPADDR --dport 143 -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp \
    -d <my.pop.clients> --dport $UNPRIVPORTS \
    -s $IPADDR --sport 143 -j ACCEPT
    

###############################################################
# ssh (TCP Port 22)
# ssh 服务 -- 允许客户端访问远程SSH服务
# Outgoing Local Client Requests to Remote Servers

if [ "$CONNECTION_TRACKING" = "1" ]; then
  $IPT -A OUTPUT -o $INTERNET -p tcp \
           -s $IPADDR --sport $SSH_PORTS \
           --dport 22 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $SSH_PORTS \
         --dport 22 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport 22 \
         -d $IPADDR --dport $SSH_PORTS -j ACCEPT

#...............................................................
# Incoming Remote Client Requests to Local Servers
# 允许远程客户端访问你的本地SSH服务
if [ "$SSH_SERVER" = "1" ]; then
  if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport $SSH_PORTS \
             -d $IPADDR --dport 22 \
             -m state --state NEW -j ACCEPT
  fi
  
  $IPT -A INPUT  -i $INTERNET -p tcp \
           --sport $SSH_PORTS \
           -d $IPADDR --dport 22 -j ACCEPT

  $IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
           -s $IPADDR --sport 22 \
           --dport $SSH_PORTS -j ACCEPT
fi

###############################################################
# 通用TCP服务 (作为客户端访问外部服务)
# if [ "$CONNECTION_TRACKING" = "1" ]; then
#   $IPT -A OUTPUT -o $INTERNET -p tcp \
#            -s $IPADDR --sport $UNPRIVPORTS \
#            --dport <YOUR PORT HERE> -m state --state NEW -j ACCEPT
# fi
# 
# $IPT -A OUTPUT -o $INTERNET -p tcp \
#          -s $IPADDR --sport $UNPRIVPORTS \
#          --dport  <YOUR PORT HERE> -j ACCEPT
# 
# $IPT -A INPUT -i $INTERNET -p tcp ! --syn \
#          --sport  <YOUR PORT HERE> \
#          -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

###############################################################
# 对于给定的服务，下面的规则适用于允许任何传入到该服务必要端口的TCP连接
# 作为服务器向外提供服务
# if [ "$CONNECTION_TRACKING" = "1" ]; then
#   $IPT -A INPUT -i $INTERNET -p tcp \
#            --sport $UNPRIVPORTS \
#            -d $IPADDR --dport <YOUR PORT HERE>
#            -m state --state NEW -j ACCEPT
# fi
# 
# $IPT -A INPUT -i $INTERNET -p tcp \
#          --sport  $UNPRIVPORTS \
#          -d $IPADDR --dport <YOUR PORT HERE> -j ACCEPT
# $IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
#          -s $IPADDR \
#          --dport  $UNPRIVPORTS -j ACCEPT
# 
###############################################################
# ftp (TCP Ports 21, 20)
# ftp 服务
# Outgoing Local Client Requests to Remote Servers
# 主动模式 port mode    原始的默认的机制。客户端告诉服务器它会监听的次要的，非特权的端口。服务器则从端口20向客户端指定的
#   非特权端口发起数据连接。
# 被动模式 passive mode 服务器的数据连接并不会绑定到端口20，而是由服务器告诉客户端连接请求应该发到哪一个高位的、非特权端口

# Outgoing Control Connection to Port 21
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport 21 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport 21 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport 21 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

### Incoming Port Mode
# 连接时服务器通过回调建立服务器20端口到客户指定的非特权端口的连接; 服务器作为发起方
# Incoming Port Mode Data Channel Connection from Port 20
if [ "$CONNECTION_TRACKING" = "1" ]; then
    # This rule is not necessary if the ip_conntrack_ftp
    # module is used.
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport 20 \
             -d $IPADDR --dport $UNPRIVPORTS \
             -m state --state NEW -j ACCEPT
fi

$IPT -A INPUT  -i $INTERNET -p tcp \
         --sport 20 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport 20 -j ACCEPT

### Outgoing Passive Mode
# Outgoing Passive Mode Data Channel Connection Between Unprivileged Ports
if [ "$CONNECTION_TRACKING" = "1" ]; then
    # This rule is not necessary if the ip_conntrack_ftp
    # module is used.
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport $UNPRIVPORTS -m state --state NEW -j ACCEPT
fi

    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport $UNPRIVPORTS -j ACCEPT

    $IPT -A INPUT -i $INTERNET -p tcp ! --syn \
             --sport $UNPRIVPORTS \
             -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

#...............................................................
# Incoming Remote Client Requests to Local Servers
# FTP(TCP端口20 ，21)

if [ "$FTP_SERVER" = "1" ]; then
    # Incoming Control Connection to Port 21
    # 从控制通路发出FTP请求
    if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport $UNPRIVPORTS \
             -d $IPADDR --dport 21 \
             -m state --state NEW -j ACCEPT
    fi

$IPT -A INPUT  -i $INTERNET -p tcp \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport 21 -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
         -s $IPADDR --sport 21 \
         --dport $UNPRIVPORTS -j ACCEPT

    # Outgoing Port Mode Data Channel Connection to Port 20
    # FTP主动模式的数据通路
    if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport 20 \
             --dport $UNPRIVPORTS -m state --state NEW -j ACCEPT
    fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport 20 \
         --dport $UNPRIVPORTS -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport 20 -j ACCEPT

    # Incoming Passive Mode Data Channel Connection Between Unprivileged Ports
    # 通用的TCP服务
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport $UNPRIVPORTS \
             -d $IPADDR --dport $UNPRIVPORTS \
             -m state --state NEW -j ACCEPT
    fi

$IPT -A INPUT  -i $INTERNET -p tcp \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport $UNPRIVPORTS -j ACCEPT
fi
###############################################################
# HTTP Web Traffic (TCP Port 80)

# Outgoing Local Client Requests to Remote Servers
 
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport 80 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport 80 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport 80 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

#...............................................................
# Incoming Remote Client Requests to Local Servers

if [ "$WEB_SERVER" = "1" ]; then
    if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport $UNPRIVPORTS \
             -d $IPADDR --dport 80 \
             -m state --state NEW -j ACCEPT
fi

$IPT -A INPUT  -i $INTERNET -p tcp \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport 80 -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
         -s $IPADDR --sport 80 \
         --dport $UNPRIVPORTS -j ACCEPT
fi

###############################################################
# SSL Web Traffic (TCP Port 443)

# Outgoing Local Client Requests to Remote Servers

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport 443 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport 443 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport 443 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT
 
#...............................................................
# Incoming Remote Client Requests to Local Servers

if [ "$SSL_SERVER" = "1" ]; then
    if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p tcp \
             --sport $UNPRIVPORTS \
             -d $IPADDR --dport 443 \
             -m state --state NEW -j ACCEPT
fi

$IPT -A INPUT  -i $INTERNET -p tcp \
         --sport $UNPRIVPORTS \
         -d $IPADDR --dport 443 -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p tcp ! --syn \
         -s $IPADDR --sport 443 \
         --dport $UNPRIVPORTS -j ACCEPT
fi

###############################################################
# whois (TCP Port 43)

# Outgoing Local Client Requests to Remote Servers

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p tcp \
             -s $IPADDR --sport $UNPRIVPORTS \
             --dport 43 -m state --state NEW -j ACCEPT
fi

$IPT -A OUTPUT -o $INTERNET -p tcp \
         -s $IPADDR --sport $UNPRIVPORTS \
         --dport 43 -j ACCEPT

$IPT -A INPUT -i $INTERNET -p tcp ! --syn \
         --sport 43 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT


###############################################################
# Accessing Remote Network Time Servers (UDP 123)
# Note: Some client and servers use source port 123
# when querying a remote server on destination port 123.

# 访问远程网络时间服务器(UDP端口123)
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p udp \
             -s $IPADDR --sport $UNPRIVPORTS \
             -d $TIME_SERVER --dport 123 \
             -m state --state NEW -j ACCEPT
fi
 
$IPT -A OUTPUT -o $INTERNET -p udp \
         -s $IPADDR --sport $UNPRIVPORTS \
         -d $TIME_SERVER --dport 123 -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p udp \
         -s $TIME_SERVER --sport 123 \
         -d $IPADDR --dport $UNPRIVPORTS -j ACCEPT

###############################################################
# Accessing Your ISP’s DHCP Server (UDP Ports 67, 68)

# Some broadcast packets are explicitly ignored by the firewall.
# Others are dropped by the default policy.
# DHCP tests must precede broadcast-related rules, as DHCP relies
# on broadcast traffic initially.

# 访问你ISP的DHCP服务器(UDP 端口67，68)

if [ "$DHCP_CLIENT" = "1" ]; then
    # Initialization or rebinding: No lease or Lease time expired.

$IPT -A OUTPUT -o $INTERNET -p udp \
         -s $BROADCAST_SRC --sport 68 \
         -d $BROADCAST_DEST --dport 67 -j ACCEPT

    # Incoming DHCPOFFER from available DHCP servers

$IPT -A INPUT  -i $INTERNET -p udp \
         -s $BROADCAST_SRC --sport 67 \
         -d $BROADCAST_DEST --dport 68 -j ACCEPT

    # Fall back to initialization
    # The client knows its server, but has either lost its lease,
    # or else needs to reconfirm the IP address after rebooting.

$IPT -A OUTPUT -o $INTERNET -p udp \
         -s $BROADCAST_SRC --sport 68 \
         -d $DHCP_SERVER --dport 67 -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p udp \
         -s $DHCP_SERVER --sport 67 \
         -d $BROADCAST_DEST --dport 68 -j ACCEPT


    # As a result of the above, we’re supposed to change our IP
    # address with this message, which is addressed to our new
    # address before the dhcp client has received the update.
    # Depending on the server implementation, the destination address
    # can be the new IP address, the subnet address, or the limited
    # broadcast address.

    # If the network subnet address is used as the destination,
    # the next rule must allow incoming packets destined to the
    # subnet address, and the rule must precede any general rules
    # that block such incoming broadcast packets.
 
$IPT -A INPUT  -i $INTERNET -p udp \
         -s $DHCP_SERVER --sport 67 \
         --dport 68 -j ACCEPT

    # Lease renewal

$IPT -A OUTPUT -o $INTERNET -p udp \
         -s $IPADDR --sport 68 \
         -d $DHCP_SERVER --dport 67 -j ACCEPT
$IPT -A INPUT  -i $INTERNET -p udp \
         -s $DHCP_SERVER --sport 67 \
         -d $IPADDR --dport 68 -j ACCEPT

    # Refuse directed broadcasts
    # Used to map networks and in Denial of Service attacks
    iptables -A INPUT -i $INTERNET -d $SUBNET_BASE -j DROP
    iptables -A INPUT -i $INTERNET -d $SUBNET_BROADCAST -j DROP

    # Refuse limited broadcasts
    iptables -A INPUT -i $INTERNET -d $BROADCAST_DEST -j DROP

fi
###############################################################
# ICMP Control and Status Messages

# Log and drop initial ICMP fragments
$IPT -A INPUT  -i $INTERNET --fragment -p icmp -j LOG \
         --log-prefix "Fragmented ICMP: "

$IPT -A INPUT  -i $INTERNET --fragment -p icmp -j DROP

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type source-quench -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type source-quench -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type parameter-problem -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type parameter-problem -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type destination-unreachable -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type fragmentation-needed -j ACCEPT

# Don’t log dropped outgoing ICMP error messages
$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type destination-unreachable -j DROP

# Intermediate traceroute responses
$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type time-exceeded -d $IPADDR -j ACCEPT

# allow outgoing pings to anywhere
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A OUTPUT -o $INTERNET -p icmp \
             -s $IPADDR --icmp-type echo-request \
             -m state --state NEW -j ACCEPT
fi
 
$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type echo-request -j ACCEPT

$IPT -A INPUT  -i $INTERNET -p icmp \
         --icmp-type echo-reply -d $IPADDR -j ACCEPT

# allow incoming pings from trusted hosts
if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p icmp \
             -s $MY_ISP --icmp-type echo-request -d $IPADDR \
             -m state --state NEW -j ACCEPT
fi

$IPT -A INPUT  -i $INTERNET -p icmp \
         -s $MY_ISP --icmp-type echo-request -d $IPADDR -j ACCEPT

$IPT -A OUTPUT -o $INTERNET -p icmp \
         -s $IPADDR --icmp-type echo-reply -d $MY_ISP -j ACCEPT

###############################################################
# Logging Dropped Packets
# 记录某种侦探或者扫面 -> 记录所有丢弃的数据包不久就会导致系统日志溢出， 
# 记录被防火墙阻塞时传出数据流，对于调试防火墙规则来说是必要的，并且可以在本地软件出现问题时候得到报警

# Don’t log dropped incoming echo-requests
# 记录被丢弃的传入 数据包
$IPT -A INPUT -i $INTERNET -p icmp \
        ! --icmp-type 8 -d $IPADDR -j LOG

$IPT -A INPUT -i $INTERNET -p tcp \
         -d $IPADDR -j LOG

# 记录被丢弃的传出数据包
$IPT -A OUTPUT -o $INTERNET -j LOG

exit 0

