#!/bin/sh

NFT="/usr/local/sbin/nft"            # Location of nft on your system
INTERNET=""                          # Internet-connected interface
LOOPBACK_INTERFACE="lo"              # however your system names it
IPADDR=""                            # your IP address
MY_ISP=""                            # ISP server & NOC address range
SUBNET_BASE=""                       # Your subnet’s network address
SUBNET_BROADCAST=""                  # Your subnet’s broadcast address
LOOPBACK="127.0.0.0/8"               # reserved loopback address range
CLASS_A="10.0.0.0/8"                 # class A private networks
CLASS_B="172.16.0.0/12"              # class B private networks
CLASS_C="192.168.0.0/16"             # class C private networks
CLASS_D_MULTICAST="224.0.0.0/4"      # class D multicast addresses
CLASS_E_RESERVED_NET="240.0.0.0/5"   # class E reserved addresses
BROADCAST_SRC="0.0.0.0"              # broadcast source address
BROADCAST_DEST="255.255.255.255"     # broadcast destination address
PRIVPORTS="0-1023"                   # well-known, privileged port range
UNPRIVPORTS="1024-65535"             # unprivileged port range


for i in `$NFT list tables | awk '{print $2}'` ; do
  # 清空表中规则链和规则
  echo "Flushing ${i}"
  $NFT flush table ${i}
  for j in `$NFT list table ${i} | grep chain | awk '{print $2}'` ; do
    # 删除规则链
    echo "...Deleting chain ${j} from table ${i}"
    $NFT delete chain ${i} ${j}
  done
  # 删除表
  echo "Deleting ${i}"
  $NFT delete table ${i}
done

if [ "$1" = "stop" ] ; then
  echo "Firewall completely stopped!  WARNING: THIS HOST HAS NO FIREWALL RUNNING."
  exit 0
fi

# 创建 filter 表的 input 和 output链
$NFT -f setup-tables

#loopback
# 启用回环接口
$NFT add rule filter input iifname lo accept
$NFT add rule filter output oifname lo accept

#connection state
# 利用连接状态绕过规则检查
$NFT add rule filter input ct state established,related accept
$NFT add rule filter input ct state invalid log prefix \"INVALID input: \" limit rate 3/second drop
$NFT add rule filter output ct state established,related accept
$NFT add rule filter output ct state invalid log prefix \"INVALID output: \" limit rate 3/second drop

#source address spoofing
$NFT add rule filter input iif $INTERNET ip saddr $IPADDR

#invalid addresses
# 源地址欺骗及其他不合法地址
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_A drop
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_B drop
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_C drop
$NFT add rule filter input iif $INTERNET ip saddr $LOOPBACK drop

#broadcast src and dest
# 默认策略拒绝一切。广播地址会被默认丢弃，如果想要他们的话，需要明确地启用它
# 记录并拒绝所有声称来自于 255.255.255.255的数据包
$NFT add rule filter input iif $INTERNET ip saddr $BROADCAST_DEST log limit rate 3/second drop
$NFT add rule filter input iif $INTERNET ip saddr $BROADCAST_SRC log limit rate 3/second drop

#directed broadcast
# 阻塞两种形式的直接广播
# SUBNET_BASE 是你的网络地址 192.168.1.0
# SUBNET_BROADCAST 是你网络的广播地址 192.168.1.255
$NFT add rule filter input iif $INTERNET ip daddr $SUBNET_BASE drop
$NFT add rule filter input iif $INTERNET ip daddr $SUBNET_BROADCAST drop

#limited broadcast
# 丢弃假冒的组播网络数据包
$NFT add rule filter input iif $INTERNET ip daddr $BROADCAST_DEST drop

#multicast
# 丢弃假源组播网络数据包
# 拒绝接受非UDP的数据包
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_D_MULTICAST drop
$NFT add rule filter input iif $INTERNET ip daddr $CLASS_D_MULTICAST ip protocol != udp drop
$NFT add rule filter input iif $INTERNET ip daddr $CLASS_D_MULTICAST ip protocol udp accept

#class e
# 拒绝接受E地址段的数据包
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_E_RESERVED_NET drop

#x windows
XWINDOW_PORTS="6000-6063"
$NFT add rule filter output oif $INTERNET ct state new tcp dport $XWINDOW_PORTS reject
$NFT add rule filter input iif $INTERNET ct state new tcp dport $XWINDOW_PORTS drop

NFS_PORT="2049"                       # (TCP) NFS
SOCKS_PORT="1080"                       # (TCP) socks
OPENWINDOWS_PORT="2000"                 # (TCP) OpenWindows
SQUID_PORT="3128"                       # (TCP) squid

$NFT add rule filter output oif $INTERNET tcp dport {$NFS_PORT,$SOCKS_PORT,$OPENWINDOWS_PORT,$SQUID_PORT} ct state new reject
$NFT add rule filter input iif $INTERNET tcp dport {$NFS_PORT,$SOCKS_PORT,$OPENWINDOWS_PORT,$SQUID_PORT} ct state new drop

NFS_PORT="2049"                         # NFS
LOCKD_PORT="4045"                       # RPC lockd for NFS
$NFT add rule filter output oif $INTERNET udp dport {$NFS_PORT,$LOCKD_PORT} reject
$NFT add rule filter input iif $INTERNET udp dport {$NFS_PORT,$LOCKD_PORT} drop

#DNS
NAMESERVER=""
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR udp sport $UNPRIVPORTS ip daddr $NAMESERVER udp dport 53 ct state new accept
$NFT add rule filter input iif $INTERNET ip daddr $IPADDR udp dport $UNPRIVPORTS ip saddr $NAMESERVER udp sport 53 accept

#tcp dns
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport $UNPRIVPORTS ip daddr $NAMESERVER tcp dport 53 ct state new accept
$NFT add rule filter input iif $INTERNET ip daddr $IPADDR tcp dport $UNPRIVPORTS ip saddr $NAMESERVER tcp sport 53 tcp flags != syn accept

SMTP_GATEWAY="50.31.0.2"
$NFT add rule filter output oif $INTERNET ip daddr $SMTP_GATEWAY tcp dport 25 ip saddr $IPADDR tcp sport $UNPRIVPORTS accept
$NFT add rule filter input iif $INTERNET ip saddr $SMTP_GATEWAY tcp sport 25 ip daddr $IPADDR tcp dport $UNPRIVPORTS tcp flags != syn accept

$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport $UNPRIVPORTS tcp dport 25 accept
$NFT add rule filter input iif $INTERNET ip daddr $IPADDR tcp sport 25 tcp dport $UNPRIVPORTS tcp flags != syn accept
$NFT add rule filter input iif $INTERNET tcp sport $UNPRIVPORTS ip daddr $IPADDR tcp dport 25 accept
$NFT add rule filter output oif $INTERNET tcp sport 25 ip saddr $IPADDR tcp dport $UNPRIVPORTS tcp flags != syn accept

POP_SERVER="50.31.0.2"
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR ip daddr $POP_SERVER tcp sport $UNPRIVPORTS tcp dport 110 accept
$NFT add rule filter input iif $INTERNET ip saddr $POP_SERVER tcp sport 110 ip daddr $IPADDR tcp dport $UNPRIVPORTS tcp flags != syn accept

IMAP_SERVER="50.31.0.2"
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport $UNPRIVPORTS ip daddr $IMAP_SERVER tcp dport 995 accept
$NFT add rule filter input iif $INTERNET ip saddr $IMAP_SERVER tcp sport 995 ip daddr $IPADDR tcp dport $UNPRIVPORTS tcp flags != syn accept

#allowing clients to connect to your POPs server
$NFT add rule filter input iif $INTERNET ip saddr 0/0 tcp sport $UNPRIVPORTS ip daddr $IPADDR tcp dport 995 accept
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport 995 ip daddr 0/0 tcp dport $UNPRIVPORTS tcp flags != syn accept

#ssh
SSH_PORTS="1020-65535"
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport $SSH_PORTS tcp dport 22 accept
$NFT add rule filter input iif $INTERNET tcp sport 22 ip daddr $IPADDR tcp dport $SSH_PORTS tcp flags != syn accept
$NFT add rule filter input iif $INTERNET tcp sport $SSH_PORTS ip daddr $IPADDR tcp dport 22 accept
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport 22 tcp dport $SSH_PORTS tcp flags != syn accept

#ftp
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR tcp sport $UNPRIVPORTS tcp dport 21 accept
$NFT add rule filter input iif $INTERNET ip daddr $IPADDR tcp sport 21 tcp dport $UNPRIVPORTS accept
#assume use of ct state module for ftp

#dhcp (this machine does dhcp on two interfaces, so need more rules)
$NFT add rule filter output oif $INTERNET ip saddr $BROADCAST_SRC udp sport 67-68 ip daddr $BROADCAST_DEST udp dport 67-68 accept
$NFT add rule filter input iif $INTERNET udp sport 67-68 udp dport 67-68 accept
$NFT add rule filter output udp sport 67-68 udp dport 67-68 accept
$NFT add rule filter input udp sport 67-68 udp dport 67-68 accept

TIME_SERVER="time.nist.gov"
#ntp
$NFT add rule filter output oif $INTERNET ip saddr $IPADDR udp sport $UNPRIVPORTS ip daddr $TIME_SERVER udp dport 123 accept
$NFT add rule filter input iif $INTERNET ip saddr $TIME_SERVER udp sport 123 ip daddr $IPADDR udp dport $UNPRIVPORTS accept

# 记录某种侦探或者扫面 -> 记录所有丢弃的数据包不久就会导致系统日志溢出， 
# 记录被防火墙阻塞时传出数据流，对于调试防火墙规则来说是必要的，并且可以在本地软件出现问题时候得到报警
#log anything that made it this far
# 记录被毒气的传入 和 传出 数据包
$NFT add rule filter input log
$NFT add rule filter output log

#default policy:
$NFT add rule filter input drop
$NFT add rule filter output reject
