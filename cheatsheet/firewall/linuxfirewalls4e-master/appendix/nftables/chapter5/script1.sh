#!/bin/sh

NFT="/usr/local/sbin/nft"            # Location of nft on your system
INTERNET=""                    # Internet-connected interface
LOOPBACK_INTERFACE="lo"              # however your system names it
IPADDR=""               # your IP address
MY_ISP=""        # ISP server & NOC address range
SUBNET_BASE=""      # Your subnet’s network address
SUBNET_BROADCAST=""   # Your subnet’s broadcast address
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

for i in `$NFT list tables | awk '{print $2}'`
do
	echo "Flushing ${i}"
	$NFT flush table ${i}	
	for j in `$NFT list table ${i} | grep chain | awk '{print $2}'`
	do
		echo "...Deleting chain ${j} from table ${i}"
		$NFT delete chain ${i} ${j}
	done
	echo "Deleting ${i}"
	$NFT delete table ${i}	
done

if [ "$1" = "stop" ]
then
echo "Firewall completely stopped!  WARNING: THIS HOST HAS NO FIREWALL RUNNING."
exit 0
fi

$NFT -f setup-tables

#loopback
$NFT add rule filter input iifname lo accept
$NFT add rule filter output oifname lo accept

#connection state
$NFT add rule filter input ct state established,related accept
$NFT add rule filter input ct state invalid log prefix \"INVALID input: \" limit rate 3/second drop
$NFT add rule filter output ct state established,related accept
$NFT add rule filter output ct state invalid log prefix \"INVALID output: \" limit rate 3/second drop

#source address spoofing
$NFT add rule filter input iif $INTERNET ip saddr $IPADDR

#invalid addresses
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_A drop
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_B drop
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_C drop
$NFT add rule filter input iif $INTERNET ip saddr $LOOPBACK drop

#broadcast src and dest
$NFT add rule filter input iif $INTERNET ip saddr $BROADCAST_DEST log limit rate 3/second drop
$NFT add rule filter input iif $INTERNET ip saddr $BROADCAST_SRC log limit rate 3/second drop

#directed broadcast
$NFT add rule filter input iif $INTERNET ip daddr $SUBNET_BASE drop
$NFT add rule filter input iif $INTERNET ip daddr $SUBNET_BROADCAST drop

#limited broadcast
$NFT add rule filter input iif $INTERNET ip daddr $BROADCAST_DEST drop

#multicast
$NFT add rule filter input iif $INTERNET ip saddr $CLASS_D_MULTICAST drop
$NFT add rule filter input iif $INTERNET ip daddr $CLASS_D_MULTICAST ip protocol != udp drop
$NFT add rule filter input iif $INTERNET ip daddr $CLASS_D_MULTICAST ip protocol udp accept

#class e
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

#log anything that made it this far
$NFT add rule filter input log
$NFT add rule filter output log

#default policy:
$NFT add rule filter input drop
$NFT add rule filter output reject
