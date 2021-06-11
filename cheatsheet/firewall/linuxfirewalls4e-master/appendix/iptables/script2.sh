#!/bin/sh

/sbin/modprobe ip_conntrack_ftp

CONNECTION_TRACKING="1"
ACCEPT_AUTH="0"
DHCP_CLIENT="0"
IPT="/sbin/iptables"                 # Location of iptables on your system
INTERNET="eth0"                      # Internet-connected interface
LOOPBACK_INTERFACE="lo"              # however your system names it
IPADDR=""               # your IP address
SUBNET_BASE=""        # ISP network segment base address
SUBNET_BROADCAST="" # network segment broadcast address
MY_ISP=""        # ISP server & NOC address range
 
NAMESERVER_1=""     # address of a remote name server
NAMESERVER_2=""     # address of a remote name server
NAMESERVER_3=""     # address of a remote name server
POP_SERVER=""          # address of a remote pop server
MAIL_SERVER=""        # address of a remote mail gateway
NEWS_SERVER=""        # address of a remote news server
TIME_SERVER=""      # address of a remote time server
DHCP_SERVER=""        # address of your ISP dhcp server
SSH_CLIENT=""

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

# traceroute usually uses -S 32769:65535 -D 33434:33523
TRACEROUTE_SRC_PORTS="32769:65535"
TRACEROUTE_DEST_PORTS="33434:33523"
 

USER_CHAINS="EXT-input                  EXT-output \
             tcp-state-flags            connection-tracking  \
             source-address-check       destination-address-check  \
             local-dns-server-query     remote-dns-server-response  \
             local-tcp-client-request   remote-tcp-server-response \
             remote-tcp-client-request  local-tcp-server-response \
             local-udp-client-request   remote-udp-server-response \
             local-dhcp-client-query    remote-dhcp-server-response \
             EXT-icmp-out               EXT-icmp-in \
             EXT-log-in                 EXT-log-out \
             log-tcp-state"
 
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
$IPT -t nat --policy PREROUTING  ACCEPT
$IPT -t nat --policy OUTPUT ACCEPT
$IPT -t nat --policy POSTROUTING ACCEPT
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
$IPT --policy INPUT DROP
$IPT --policy OUTPUT DROP
$IPT --policy FORWARD DROP

# Create the user-defined chains
for i in $USER_CHAINS; do
    $IPT -N $i
done

###############################################################
# DNS Caching Name Server (query to remote, primary server)

$IPT -A EXT-output -p udp --sport 53 --dport 53 \
         -j local-dns-server-query

$IPT -A EXT-input -p udp --sport 53 --dport 53 \
         -j remote-dns-server-response

# DNS Caching Name Server (query to remote server over TCP)

$IPT -A EXT-output -p tcp \
         --sport $UNPRIVPORTS --dport 53 \
         -j local-dns-server-query

$IPT -A EXT-input -p tcp ! --syn \
         --sport 53 --dport $UNPRIVPORTS \
         -j remote-dns-server-response

###############################################################
# DNS Forwarding Name Server or client requests

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-dns-server-query \
             -d $NAMESERVER_1 \
             -m state --state NEW -j ACCEPT

    $IPT -A local-dns-server-query \
             -d $NAMESERVER_2 \
             -m state --state NEW -j ACCEPT

    $IPT -A local-dns-server-query \
             -d $NAMESERVER_3 \
             -m state --state NEW -j ACCEPT
fi 

$IPT -A local-dns-server-query \
         -d $NAMESERVER_1 -j ACCEPT

$IPT -A local-dns-server-query \
         -d $NAMESERVER_2 -j ACCEPT

$IPT -A local-dns-server-query \
         -d $NAMESERVER_3 -j ACCEPT

# DNS server responses to local requests

$IPT -A remote-dns-server-response \
         -s $NAMESERVER_1 -j ACCEPT

$IPT -A remote-dns-server-response \
         -s $NAMESERVER_2 -j ACCEPT

$IPT -A remote-dns-server-response \
         -s $NAMESERVER_3 -j ACCEPT

###############################################################
# Local TCP client, remote server

$IPT -A EXT-output -p tcp \
         --sport $UNPRIVPORTS \
         -j local-tcp-client-request

$IPT -A EXT-input -p tcp ! --syn \
         --dport $UNPRIVPORTS \
         -j remote-tcp-server-response

###############################################################
# Local TCP client output and remote server input chains

# SSH client

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-tcp-client-request -p tcp \
             -d <SELECTED_HOST> --dport 22 \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A local-tcp-client-request -p tcp \
         -d <SELECTED_HOST> --dport 22 \
         -j ACCEPT

$IPT -A remote-tcp-server-response -p tcp ! --syn \
         -s <SELECTED_HOST> --sport 22  \
         -j ACCEPT

#...............................................................
# Client rules for HTTP, HTTPS, AUTH, and FTP control requests

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-tcp-client-request -p tcp \
             -m multiport --destination-port 80,443,21 \
             --syn -m state --state NEW \
             -j ACCEPT
fi 

$IPT -A local-tcp-client-request -p tcp \
         -m multiport --destination-port 80,443,21 \
         -j ACCEPT

$IPT -A remote-tcp-server-response -p tcp \
         -m multiport --source-port 80,443,21  ! --syn \
         -j ACCEPT

#...............................................................
# POP client

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-tcp-client-request -p tcp \
             -d $POP_SERVER --dport 110 \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A local-tcp-client-request -p tcp \
         -d $POP_SERVER --dport 110 \
         -j ACCEPT

$IPT -A remote-tcp-server-response -p tcp ! --syn \
         -s $POP_SERVER --sport 110  \
         -j ACCEPT
#...............................................................
# SMTP mail client

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-tcp-client-request -p tcp \
             -d $MAIL_SERVER --dport 25 \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A local-tcp-client-request -p tcp \
         -d $MAIL_SERVER --dport 25 \
         -j ACCEPT

$IPT -A remote-tcp-server-response -p tcp ! --syn \
         -s $MAIL_SERVER --sport 25  \
         -j ACCEPT
 
#...............................................................
# Usenet news client

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-tcp-client-request -p tcp \
             -d $NEWS_SERVER --dport 119 \
             -m state --state NEW \
             -j ACCEPT
fi
$IPT -A local-tcp-client-request -p tcp \
         -d $NEWS_SERVER --dport 119 \
         -j ACCEPT

$IPT -A remote-tcp-server-response -p tcp ! --syn \
         -s $NEWS_SERVER --sport 119  \
         -j ACCEPT

#...............................................................
# FTP client - passive mode data channel connection

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-tcp-client-request -p tcp \
             --dport $UNPRIVPORTS \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A local-tcp-client-request -p tcp \
         --dport $UNPRIVPORTS -j ACCEPT

$IPT -A remote-tcp-server-response -p tcp  ! --syn \
         --sport $UNPRIVPORTS -j ACCEPT
###############################################################
# Local TCP server, remote client

$IPT -A EXT-input -p tcp \
         --sport $UNPRIVPORTS \
         -j remote-tcp-client-request

$IPT -A EXT-output -p tcp ! --syn \
         --dport $UNPRIVPORTS \
         -j local-tcp-server-response

# Kludge for incoming FTP data channel connections
# from remote servers using port mode.
# The state modules treat this connection as RELATED
# if the ip_conntrack_ftp module is loaded.
 
$IPT -A EXT-input -p tcp \
         --sport 20 --dport $UNPRIVPORTS \
         -j ACCEPT

$IPT -A EXT-output -p tcp ! --syn \
         --sport $UNPRIVPORTS --dport 20 \
         -j ACCEPT


###############################################################
# Remote TCP client input and local server output chains

# SSH server

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A remote-tcp-client-request -p tcp \
             -s <SELECTED_HOST> --destination-port 22 \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A remote-tcp-client-request -p tcp \
         -s <SELECTED_HOST> --destination-port 22 \
         -j ACCEPT

$IPT -A local-tcp-server-response -p tcp  ! --syn \
         --source-port 22 -d <SELECTED_HOST> \
         -j ACCEPT

#...............................................................
# AUTH identd server
 
if [ "$ACCEPT_AUTH" = "0" ]; then
    $IPT -A remote-tcp-client-request -p tcp \
         --destination-port 113 \
         -j REJECT --reject-with tcp-reset
else
    $IPT -A remote-tcp-client-request -p tcp \
             --destination-port 113 \
             -j ACCEPT

    $IPT -A local-tcp-server-response -p tcp  ! --syn \
             --source-port 113 \
             -j ACCEPT
fi

###############################################################
# Local UDP client, remote server

$IPT -A EXT-output -p udp \
         --sport $UNPRIVPORTS \
         -j local-udp-client-request

$IPT -A EXT-input -p udp \
         --dport $UNPRIVPORTS \
         -j remote-udp-server-response

###############################################################
# NTP time client

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A local-udp-client-request -p udp \
             -d $TIME_SERVER --dport 123 \
             -m state --state NEW \
             -j ACCEPT
fi
$IPT -A local-udp-client-request -p udp \
         -d $TIME_SERVER --dport 123 \
         -j ACCEPT

$IPT -A remote-udp-server-response -p udp \
         -s $TIME_SERVER --sport 123 \
         -j ACCEPT

###############################################################
# ICMP

$IPT -A EXT-input -p icmp -j EXT-icmp-in

$IPT -A EXT-output -p icmp -j EXT-icmp-out

###############################################################
# ICMP traffic
 
# Log and drop initial ICMP fragments
$IPT -A EXT-icmp-in --fragment -j LOG \
         --log-prefix "Fragmented incoming ICMP: "

$IPT -A EXT-icmp-in --fragment -j DROP

$IPT -A EXT-icmp-out --fragment -j LOG \
         --log-prefix "Fragmented outgoing ICMP: "

$IPT -A EXT-icmp-out --fragment -j DROP

# Outgoing ping

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A EXT-icmp-out -p icmp \
             --icmp-type echo-request \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A EXT-icmp-out -p icmp \
         --icmp-type echo-request -j ACCEPT

$IPT -A EXT-icmp-in -p icmp \
         --icmp-type echo-reply -j ACCEPT

# Incoming ping

if [ "$CONNECTION_TRACKING" = "1" ]; then
    $IPT -A EXT-icmp-in -p icmp \
             -s $MY_ISP  \
             --icmp-type echo-request \
             -m state --state NEW \
             -j ACCEPT
fi

$IPT -A EXT-icmp-in -p icmp \
         --icmp-type echo-request \
         -s $MY_ISP -j ACCEPT

$IPT -A EXT-icmp-out -p icmp \
         --icmp-type echo-reply \
         -d $MY_ISP -j ACCEPT

# Destination Unreachable Type 3
$IPT -A EXT-icmp-out -p icmp \
         --icmp-type fragmentation-needed -j ACCEPT

$IPT -A EXT-icmp-in -p icmp \
         --icmp-type destination-unreachable -j ACCEPT

# Parameter Problem
$IPT -A EXT-icmp-out -p icmp \
         --icmp-type parameter-problem -j ACCEPT

$IPT -A EXT-icmp-in -p icmp \
         --icmp-type parameter-problem -j ACCEPT

# Time Exceeded
$IPT -A EXT-icmp-in -p icmp \
         --icmp-type time-exceeded -j ACCEPT

# Source Quench 
$IPT -A EXT-icmp-out -p icmp \
         --icmp-type source-quench -j ACCEPT

###############################################################
# TCP State Flags

# All of the bits are cleared
$IPT -A tcp-state-flags -p tcp --tcp-flags ALL NONE -j log-tcp-state

# SYN and FIN are both set
$IPT -A tcp-state-flags -p tcp --tcp-flags SYN,FIN SYN,FIN -j log-tcp-state

# SYN and RST are both set
$IPT -A tcp-state-flags -p tcp --tcp-flags SYN,RST SYN,RST -j log-tcp-state

# FIN and RST are both set
$IPT -A tcp-state-flags -p tcp --tcp-flags FIN,RST FIN,RST -j log-tcp-state

# FIN is the only bit set, without the expected accompanying ACK
$IPT -A tcp-state-flags -p tcp --tcp-flags ACK,FIN FIN -j log-tcp-state

# PSH is the only bit set, without the expected accompanying ACK
$IPT -A tcp-state-flags -p tcp --tcp-flags ACK,PSH PSH -j log-tcp-state

# URG is the only bit set, without the expected accompanying ACK
$IPT -A tcp-state-flags -p tcp --tcp-flags ACK,URG URG -j log-tcp-state

###############################################################
# Log and drop TCP packets with bad state combinations
 
$IPT -A log-tcp-state -p tcp -j LOG \
         --log-prefix "Illegal TCP state: " \
         --log-ip-options --log-tcp-options

$IPT -A log-tcp-state -j DROP

###############################################################
# By-pass rule checking for ESTABLISHED exchanges

if [ "$CONNECTION_TRACKING" = "1" ]; then
    # By-pass the firewall filters for established exchanges
    $IPT -A connection-tracking -m state \
             --state ESTABLISHED,RELATED \
             -j ACCEPT

    $IPT -A connection-tracking -m state --state INVALID \
             -j LOG --log-prefix "INVALID packet: "
    $IPT -A connection-tracking -m state --state INVALID -j DROP
fi

###############################################################
# DHCP traffic

# Some broadcast packets are explicitly ignored by the firewall.
# Others are dropped by the default policy.
# DHCP tests must precede broadcast-related rules, as DHCP relies
# on broadcast traffic initially.

if [ "$DHCP_CLIENT" = "1" ]; then

    # Initialization or rebinding: No lease or Lease time expired.

    $IPT -A local-dhcp-client-query \
             -s $BROADCAST_SRC \
             -d $BROADCAST_DEST -j ACCEPT

    # Incoming DHCPOFFER from available DHCP servers

    $IPT -A remote-dhcp-server-response \
             -s $BROADCAST_SRC \
             -d $BROADCAST_DEST -j ACCEPT

    # Fall back to initialization
    # The client knows its server, but has either lost its lease,
    # or else needs to reconfirm the IP address after rebooting.

    $IPT -A local-dhcp-client-query \
                 -s $BROADCAST_SRC \
                 -d $DHCP_SERVER -j ACCEPT

    $IPT -A remote-dhcp-server-response \
             -s $DHCP_SERVER \
             -d $BROADCAST_DEST -j ACCEPT

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

    $IPT -A remote-dhcp-server-response \
             -s $DHCP_SERVER -j ACCEPT

    # Lease renewal

    $IPT -A local-dhcp-client-query \
             -s $IPADDR \
             -d $DHCP_SERVER -j ACCEPT
fi
###############################################################
# Source Address Spoof Checks

# Drop packets pretending to be originating from the receiving interface
$IPT -A source-address-check -s $IPADDR -j DROP

# Refuse packets claiming to be from private networks

$IPT -A source-address-check -s $CLASS_A -j DROP
$IPT -A source-address-check -s $CLASS_B -j DROP
$IPT -A source-address-check -s $CLASS_C -j DROP
$IPT -A source-address-check -s $CLASS_D_MULTICAST -j DROP
$IPT -A source-address-check -s $CLASS_E_RESERVED_NET -j DROP
$IPT -A source-address-check -s $LOOPBACK  -j DROP

$IPT -A source-address-check -s 0.0.0.0/8 -j DROP
$IPT -A source-address-check -s 169.254.0.0/16 -j DROP
$IPT -A source-address-check -s 192.0.2.0/24 -j DROP

###############################################################
# Bad Destination Address and Port Checks
 
# Block directed broadcasts from the Internet

$IPT -A destination-address-check -d $BROADCAST_DEST -j DROP
$IPT -A destination-address-check -d $SUBNET_BASE -j DROP
$IPT -A destination-address-check -d $SUBNET_BROADCAST -j DROP
$IPT -A destination-address-check ! -p udp \
         -d $CLASS_D_MULTICAST -j DROP

###############################################################
# Logging Rules Prior to Dropping by the Default Policy

# ICMP rules

$IPT -A EXT-log-in -p icmp \
         ! --icmp-type echo-request -m limit -j LOG

# TCP rules

$IPT -A EXT-log-in -p tcp \
         --dport 0:19 -j LOG

# skip ftp, telnet, ssh
$IPT -A EXT-log-in -p tcp \
         --dport 24 -j LOG

# skip smtp
$IPT -A EXT-log-in -p tcp \
         --dport 26:78 -j LOG

# skip finger, www
$IPT -A EXT-log-in -p tcp \
         --dport 81:109 -j LOG

# skip pop-3, sunrpc
$IPT -A EXT-log-in -p tcp \
         --dport 112:136 -j LOG

# skip NetBIOS
$IPT -A EXT-log-in -p tcp \
         --dport 140:142 -j LOG

# skip imap
$IPT -A EXT-log-in -p tcp \
         --dport 144:442 -j LOG

# skip secure_web/SSL
$IPT -A EXT-log-in -p tcp \
         --dport 444:65535 -j LOG

#UDP rules

$IPT -A EXT-log-in -p udp \
         --dport 0:110 -j LOG

# skip sunrpc
$IPT -A EXT-log-in -p udp \
         --dport 112:160 -j LOG

# skip snmp
$IPT -A EXT-log-in -p udp \
         --dport 163:634 -j LOG
 
# skip NFS mountd
$IPT -A EXT-log-in -p udp \
         --dport 636:5631 -j LOG

# skip pcAnywhere
$IPT -A EXT-log-in -p udp \
         --dport 5633:31336 -j LOG

# skip traceroute’s default ports
$IPT -A EXT-log-in -p udp \
         --sport $TRACEROUTE_SRC_PORTS \
         --dport $TRACEROUTE_DEST_PORTS -j LOG

# skip the rest
$IPT -A EXT-log-in -p udp \
         --dport 33434:65535 -j LOG

# Outgoing Packets

# Don’t log rejected outgoing ICMP destination-unreachable packets
$IPT -A EXT-log-out -p icmp \
         --icmp-type destination-unreachable -j DROP

$IPT -A EXT-log-out -j LOG

###############################################################
# Install the User-defined Chains on the built-in
# INPUT and OUTPUT chains

# If TCP: Check for common stealth scan TCP state patterns
$IPT -A INPUT  -p tcp -j tcp-state-flags
$IPT -A OUTPUT -p tcp -j tcp-state-flags

if [ "$CONNECTION_TRACKING" = "1" ]; then
    # By-pass the firewall filters for established exchanges
    $IPT -A INPUT  -j connection-tracking
    $IPT -A OUTPUT -j connection-tracking
fi

if [ "$DHCP_CLIENT" = "1" ]; then
    $IPT -A INPUT  -i $INTERNET -p udp \
             --sport 67 --dport 68 -j remote-dhcp-server-response
    $IPT -A OUTPUT -o $INTERNET -p udp \
             --sport 68 --dport 67 -j local-dhcp-client-query
fi

# Test for illegal source and destination addresses in incoming packets
$IPT -A INPUT  ! -p tcp -j source-address-check
$IPT -A INPUT  -p tcp --syn -j source-address-check
$IPT -A INPUT  -j destination-address-check

# Test for illegal destination addresses in outgoing packets
$IPT -A OUTPUT -j destination-address-check

# Begin standard firewall tests for packets addressed to this host
$IPT -A INPUT -i $INTERNET -d $IPADDR -j EXT-input

# Multicast traffic
$IPT -A INPUT  -i $INTERNET -p udp -d $CLASS_D_MULTICAST -j ACCEPT 
$IPT -A OUTPUT -o $INTERNET -p udp -s $IPADDR -d $CLASS_D_MULTICAST \
-j ACCEPT 

# Begin standard firewall tests for packets sent from this host
# Source address spoofing by this host is not allowed due to the
# test on source address in this rule.
$IPT -A OUTPUT -o $INTERNET -s $IPADDR -j EXT-output

# Log anything of interest that fell through,
# before the default policy drops the packet.
$IPT -A INPUT  -j EXT-log-in
$IPT -A OUTPUT -j EXT-log-out
 
exit 0

