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
IPADDR=""               # your IP address
SUBNET_BASE=""        # ISP network segment base address
SUBNET_BROADCAST="" # network segment broadcast address
MY_ISP=""        # ISP server & NOC address range 

NAMESERVER=""       # address of a remote name server
POP_SERVER=""          # address of a remote pop server
MAIL_SERVER=""        # address of a remote mail gateway
NEWS_SERVER=""        # address of a remote news server
TIME_SERVER=""      # address of a remote time server
DHCP_SERVER=""        # address of your ISP dhcp server

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
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Disable Source Routed Packets
for f in /proc/sys/net/ipv4/conf/*/accept_source_route; do
    echo 0 > $f
done

# Enable TCP SYN Cookie Protection
echo 1 > /proc/sys/net/ipv4/tcp_syncookies

# Disable ICMP Redirect Acceptance
for f in /proc/sys/net/ipv4/conf/*/accept_redirects; do
    echo 0 > $f
done

# Don’t send Redirect Messages
for f in /proc/sys/net/ipv4/conf/*/send_redirects; do
    echo 0 > $f
done

# Drop Spoofed Packets coming in on an interface, which, if replied to,
# would result in the reply going out a different interface.
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
    echo 1 > $f
done

# Log packets with impossible addresses.
for f in /proc/sys/net/ipv4/conf/*/log_martians; do
    echo 1 > $f
done

###############################################################

# Remove any existing rules from all chains
$IPT --flush
$IPT -t nat --flush
$IPT -t mangle --flush
$IPT -X
$IPT -t nat -X
$IPT -t mangle -X
$IPT --policy INPUT   ACCEPT
$IPT --policy OUTPUT  ACCEPT
$IPT --policy FORWARD ACCEPT
$IPT -t mangle --policy PREROUTING ACCEPT
$IPT -t mangle --policy OUTPUT ACCEPT
if [ "$1" = "stop" ]
then
	echo "Firewall completely stopped!  WARNING: THIS HOST HAS NO FIREWALL RUNNING."
	exit 0
fi

# Unlimited traffic on the loopback interface
$IPT -A INPUT  -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

# Set the default policy to drop
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
# Using Connection State to By-pass Rule Checking
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

# Refuse spoofed packets pretending to be from
# the external interface’s IP address
$IPT -A INPUT  -i $INTERNET -s $IPADDR -j DROP

# Refuse packets claiming to be from a Class A private network
$IPT -A INPUT  -i $INTERNET -s $CLASS_A -j DROP

# Refuse packets claiming to be from a Class B private network
$IPT -A INPUT  -i $INTERNET -s $CLASS_B -j DROP

# Refuse packets claiming to be from a Class C private network
$IPT -A INPUT  -i $INTERNET -s $CLASS_C -j DROP
# Refuse packets claiming to be from the loopback interface
$IPT -A INPUT  -i $INTERNET -s $LOOPBACK -j DROP

# Refuse malformed broadcast packets
$IPT -A INPUT  -i $INTERNET -s $BROADCAST_DEST -j LOG
$IPT -A INPUT  -i $INTERNET -s $BROADCAST_DEST -j DROP

$IPT -A INPUT  -i $INTERNET -d $BROADCAST_SRC  -j LOG
$IPT -A INPUT  -i $INTERNET -d $BROADCAST_SRC  -j DROP

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
$IPT -A INPUT -i $INTERNET -s $CLASS_D_MULTICAST -j DROP

$IPT -A INPUT -i $INTERNET ! -p UDP -d $CLASS_D_MULTICAST -j DROP

$IPT -A INPUT  -i $INTERNET -p udp -d $CLASS_D_MULTICAST -j ACCEPT

# Refuse Class E reserved IP addresses
$IPT -A INPUT  -i $INTERNET -s $CLASS_E_RESERVED_NET -j DROP

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
# DNS Name Server

# DNS Forwarding Name Server or client requests

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
# Sending Mail to Any External Mail Server
# Use "-d $MAIL_SERVER" if an ISP mail gateway is used instead

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
# Retrieving Mail as a POP Client (TCP Port 110)

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
 
###############################################################
# ssh (TCP Port 22)

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
# ftp (TCP Ports 21, 20)

# Outgoing Local Client Requests to Remote Servers
 
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
 
if [ "$FTP_SERVER" = "1" ]; then

    # Incoming Control Connection to Port 21
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

# Don’t log dropped incoming echo-requests
$IPT -A INPUT -i $INTERNET -p icmp \
        ! --icmp-type 8 -d $IPADDR -j LOG

$IPT -A INPUT -i $INTERNET -p tcp \
         -d $IPADDR -j LOG

$IPT -A OUTPUT -o $INTERNET -j LOG

exit 0

