#! /bin/sh

# Enable ftp data channel connection-tracking
MODPROBE=`which modprobe`
$MODPROBE ip_conntrack_ftp

# Defining isConntrack variable
isConntrack=`lsmod | grep ^nf_conntrack_ipv4 | awk '{print $1}'`
if [ ${isConntrack} = "nf_conntrack_ipv4" ];then
	CONNECTION_TRACKING=1
else
 	CONNECTION_TRACKING=0
fi

# Service Providing/Enabled Parameters
ACCEPT_AUTH="0"
SSH_SERVER="1"
FTP_SERVER="0"
WEB_SERVER="0"
SSL_SERVER="0"
DHCP_CLIENT="0"
POP_SERVER="0"

# Client Role
POP_CLIENT="0" 
IMAP_CLIENT="0"
SSH_CLIENT="0"
SMTP_CLIENT="0"
HTTPFTP_CLIENT="0"

# Authenticated ICMP hosts
AUTH_HOSTS="some icmp initializing hosts"

# Location of iptables on your system
IPT=`which iptables`

# Common definitions
INTERNET="eth0"                         # Internet-connected interface
LAN_INTERFACE="eth1"                    # LAN-connected interface
EXTERNAL_INTERFACE="eth0"               # External interface
LAN_ADDRESSES="10.0.1.0/24"             # Private Network

LOOPBACK_INTERFACE="lo"					# Loopback interface name
IPADDR="my.ip.address"					# IP address of the internet-connnected interface
MY_ISP="my.isp.address.range"			# ISP server & NOC address range
SUBNET_BASE="my.subnet.network"			# Your subnet's network address
SUBNET_BROADCAST="my.subnet.bcast"		# Your subnet's broadcast address

# External server address
NAMESEVER_1="my.name.server1"			# (TCP/UDP) DNS
NAMESEVER_2="my.name.server2"			# (TCP/UDP) DNS
NAMESEVER_3="my.name.server3"			# (TCP/UDP) DNS
POP_SERVER="my.isp.pop.server" 			# External POP server
MAIL_SERVER="my.isp.mail.server"		# External mail server
JENKINS_SERVER="my.jenkins.server"		# External Jenkins server
TIME_SERVER="my.time.server"			# External time server
DHCP_SERVER="my.isp.dhcp.server"		# ISP's DHCP server
IMAP_SERVER="my.imap.server"			# External IMAP Server
TRUSTED_HOSTS="my.hosts"				# Trusted icmp request hosts
NEWS_SERVER="my.news.server"			# External NEWS server
SSH_CLIENTS="some clients"				# Authenticated SSH users

# Common network ranges
LOOPBACK="127.0.0.0/8"					# Reserved loopback address range
CLASS_A="10.0.0.0/8"					# Class A private networks
CLASS_B="172.16.0.0/12"					# Class B private networks
CLASS_C="192.168.0.0/16"				# Class C private networks
CLASS_D_MULTICAST="224.0.0.0/5"			# Class D multicast address
CLASS_E_RESERVED_NET="240.0.0.0/5"		# Class E reserved address
BROADCAST_SRC="0.0.0.0"					# Broadcast source address
BROADCAST_DEST="255.255.255.255"		# Broadcast destination address

PRIVPORTS="0:1023"						# Well-known, privileged port range
UNPRIVPORTS="1024:65535"				# Unprivileged port range

XWINDOW_PORTS="6000:6063"   			# (TCP) X Windows
NFS_PORT="2049"							# (TCP) NFS
LOCKD_PORT="4045"						# (TCP) RPC LOCKD for NFS
SOCKS_PORT="1080"						# (TCP) SOCKS
OPENWINDOWS_PORT="2000"					# (TCP) OpenWindows
SQUID_PORT="3128"						# (TCP) Squid
SSH_PORTS="1024:65535"					# RSA authentication
#SSH_PORTS="1020:65535"					# RHOST authentication

# Traceroute usually use -S 32769:65535 -D 33434:33523
TRACEROUTE_SRC_PORTS="32769:65535"
TRACEROUTE_DEST_PORTS="33434:33523"

# Defining user-defined chains
USER_CHAINS="EXT-input					EXT-output \
			 tcp-state-flags			connection-tracking \
			 source-address-check		destination-address-check \
			 local-dns-server-query 	remote-dns-server-response \
			 local-tcp-client-request   remote-tcp-server-response \
			 remote-tcp-client-request 	local-tcp-server-response \
			 local-udp-client-request 	remote-udp-server-response \
			 local-dhcp-client-query 	remote-dhcp-server-response \
			 EXT-icmp-out 				EXT-icmp-in \
			 EXT-log-in 				EXT-log-out \
			 log-tcp-state              LAN-input \
             LAN-output \
			"

#################################################################

# Enable broadcast echo protection
# ignore an echo request to a broadcast address thus preventing compromising all host
# at one time
echo "1" > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Disable Source Routed Packages
# source routing, also called path addressing,allows a sender
# of a packet to partially or completely specify the route the
# packet takes through the network
echo "0" > /proc/sys/net/ipv4/conf/all/accept_source_route

# Enable TCP SYN Cookie Protection
# Protect against SYN Flooding Attack
echo "1" > /proc/sys/net/ipv4/tcp_syncookies

# Disable ICMP Redirect Acceptance
echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects

# Do not send ICMP redirect messages
echo "0" > /proc/sys/net/ipv4/conf/all/send_redirects

# Drop Spoofed Packets coming in on an interface ,which , if
# replied to, would result in the reply going out a different
# interface
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
	echo "1" > f
done

# Log packets with impossible addresses (address 0.0.0.0,
# host 0 on any network ,any host on 127 network and Class
# E network)
echo "1" > /proc/sys/net/ipv4/conf/all/log_martians

#################################################################
# Removing all existing rules from all chains
$IPT --flush

# use -t to specify tables to flush
$IPT -t nat -F
$IPT -t mangle -F

# Deleting all user-defined chains
for tables in filter nat mangle
do
	$IPT -t ${tables} -X
done

# Resetting Default Policies
for table in filter nat mangle
do
	case ${table} in
		filter)
			for chain in INPUT OUTPUT FORWARD
			do
				$IPT -t ${table} -P ${chain} ACCEPT
			done
		;;

		nat)
			for chain in PREROUTING FORWARD POSTROUTING
			do
				$IPT -t ${table} -P ${chain} ACCEPT
			done
		;;

		mangle)
			for chain in PREROUTING OUTPUT
			do
				$IPT -t ${table} -P ${chain} ACCEPT
			done
		;;

		*)
			echo "Illegal Usage!"
			exit 1
		;;

	esac
done

# Unlimit traffic on the loopback interface
$IPT -A INPUT -i lo -j ACCEPT
$IPT -A OUTPUT -o lo -j ACCEPT

# Set the default policy to Drop
$IPT -P INPUT DROP
$IPT -P OUTPUT DROP
$IPT -P FORWARD DROP

# Create user-defined chains
for chain in "${USER_CHAINS}";do
	$IPT -N ${chain}
done

#################################################################
# DNS Caching Name Server (local server to primary server)
# Assuming using (s/d)port 53 for server-server exchange
# client 53 <=====> server 53
# query to primary,remote server
$IPT -A EXT-output -p udp --sport 53 --dport 53 \
		-j local-dns-server-query

$IPT -A EXT-input -p udp --sport 53 --dport 53 \
		-j remote-dns-server-response

# query to primary,remote server over TCP
$IPT -A EXT-output -p tcp --sport $UNPRIVPORTS --dport 53 \
		-j local-dns-server-query

$IPT -A EXT-input -p tcp --sport 53 --dport $UNPRIVPORTS \
		-j remote-dns-server-response

# DNS Forwarding Name Server or client requests

if [ "CONNECTION_TRACKING" = "1" ];then
	$IPT -A local-dns-server-query \
			-d $NAMESEVER_1 \
			-m state --state NEW -j ACCEPT

	$IPT -A local-dns-server-query \
			-d $NAMESEVER_2 \
			-m state --state NEW -j ACCEPT

	$IPT -A local-dns-server-query \
			-d $NAMESEVER_3 \
			-m state --state NEW -j ACCEPT
fi

$IPT -A local-dns-server-query \
		-d $NAMESEVER_1 -j ACCEPT

$IPT -A local-dns-server-query \
		-d $NAMESEVER_2 -j ACCEPT

$IPT -A local-dns-server-query \
		-d $NAMESEVER_3 -j ACCEPT

# DNS server respond to local requests

$IPT -A remote-dns-server-response \
		-s $NAMESEVER_1 -j ACCEPT

$IPT -A remote-dns-server-response \
		-s $NAMESEVER_2 -j ACCEPT

$IPT -A remote-dns-server-response \
		-s $NAMESEVER_3 -j ACCEPT

#################################################################
# Local TCP client, remote server

$IPT -A EXT-output -p tcp \
		--sport $UNPRIVPORTS \
		-j local-tcp-client-request

$IPT -A EXT-input -p tcp \
		--dport $UNPRIVPORTS \
		-j remote-tcp-server-response

#################################################################
# Local TCP client output and remote server input chains

# SSH client
if [ "${SSH_CLIENT}" = "1" ];then
	if [ "CONNECTION_TRACKING" = "1" ];then
		$IPT -A local-tcp-client-request -p tcp \
				--dport 22 \
				-m state --state NEW -j ACCEPT
	fi

	$IPT -A local-tcp-client-request -p tcp \
			--dport 22 -j ACCEPT

	$IPT -A remote-tcp-server-response -p tcp \
			--sport 22 -j ACCEPT
fi

#...............................................................
# Client rules for HTTP, HTTPS, AUTH and FTP control requests
if [ "${HTTPFTP_CLIENT}" = "1" ];then
	if [ "CONNECTION_TRACKING" = "1" ];then
		$IPT -A local-tcp-client-request -p TCP \
				-m multiport --dports 80,443,21 \
				--syn -m state --state NEW -j ACCEPT
	fi

	$IPT -A local-tcp-client-request -p tcp \
			-m multiport --dports 80,443,21 \
			--syn -j ACCEPT


	# Using this rule is assuming you are not hosting an webservice nor a ftp server
	$IPT -A remote-tcp-server-response -p tcp ! --syn \
			-m multiport --sports 80,443,21 \
			-j ACCEPT
fi
#...............................................................
# POPs client
if [ "${POP_CLIENT}" = "1" ];then
	if [ "CONNECTION_TRACKING" = "1" ];then
		$IPT -A local-tcp-client-request -p tcp \
				--dport 995 \
				-m state --state NEW \
				-j ACCEPT
	fi

	$IPT -A local-tcp-client-request -p tcp \
			--dport 995 \
			-j ACCEPT

	$IPT -A remote-tcp-server-response -p tcp ! --syn \
			--sport 995 \
			-j ACCEPT
fi
#...............................................................
# SMTP mail client
if [ "$SMTP_CLIENT" = "1" ];then
	if [ "CONNECTION_TRACKING" = "1" ];then
		$IPT -A local-tcp-client-request -p tcp \
				<-s $SMTP_SERVER> --dport 25 \
				-m state --state NEW \
				-j ACCEPT
	fi

	$IPT -A local-tcp-client-request -p tcp \
			<-s $SMTP_SERVER> --dport 25 \
			-j ACCEPT

	$IPT -A remote-tcp-server-response -p tcp ! --syn \
			<-s $SMTP_SERVER> --sport 25 \
			-j ACCEPT
fi

#...............................................................
# FTP client - passive mode data channel connection
if [ "$FTP_CLIENT" = "1" ];then
	if [ "CONNECTION_TRACKING" = "1" ];then
		$IPT -A local-tcp-client-request -p tcp \
				--dport $UNPRIVPORTS \
				-m state --state NEW \
				-j ACCEPT
	fi

	$IPT -A local-tcp-client-request -p tcp \
			--dport $UNPRIVPORTS \
			-j ACCEPT

	$IPT -A remote-tcp-server-response -p tcp ! --syn \
			--sport $UNPRIVPORTS \
			-j ACCEPT
fi

#...............................................................
# Local TCP server ,remote client

$IPT -A EXT-input -p tcp \
		--sport $UNPRIVPORTS \
		-j remote-tcp-client-request

$IPT -A EXT-output -p tcp ! --syn \
		--dport $UNPRIVPORTS \
		-j local-tcp-server-response

# Kludge for incoming FTP data channel connections
# from remote servers using port mode
# The state modules treat this connection as RELATED
# if the ip_conntrack_ftp module is loaded

$IPT -A EXT-input -p tcp \
		--sport 20 \
		--dport $UNPRIVPORTS \
		-j ACCEPT

$IPT -A EXT-output -p tcp ! --syn \
		--sport $UNPRIVPORTS \
		--dport 20 \
		-j ACCEPT

#...............................................................
# Remote TCP client input and local server output chains

# SSH server

if [ "CONNECTION_TRACKING" = "1" ];then
	$IPT -A remote-tcp-client-request -p tcp \
			<-s $SSH_CLIENTS> --dport 22 \
			-m state --state NEW \
			-j ACCEPT
fi

$IPT -A remote-tcp-client-request -p tcp \
		--dport 22 \
		-j ACCEPT

$IPT -A local-tcp-server-response -p tcp ! --syn \
		--sport 22 \
		-j ACCEPT

#...............................................................
# AUTH identd server

if [ "$ACCEPT_AUTH" = "0" ];then
	$IPT -A remote-tcp-client-request -p tcp \
			--dport 113 \
			-m state --state NEW \
			-j ACCEPT
fi

$IPT -A remote-tcp-client-request -p tcp \
		--dport 113 \
		-j ACCEPT

$IPT -A local-tcp-server-response -p tcp ! --syn \
		--sport 113 \
		-j ACCEPT


################################################################
# Local UDP client, remote server

$IPT -A EXT-output -p udp \
		--sport $UNPRIVPORTS \
		-j local-udp-client-request

$IPT -A EXT-input -p udp \
		--dport $UNPRIVPORTS \
		-j remote-udp-server-response

#...............................................................
# NTP time client

if [ "CONNECTION_TRACKING" = "1" ];then
	$IPT -A local-udp-client-request -p udp \
			-d $TIME_SERVER --dport 123 \
			-m state --state NEW \
			-j ACCEPT
fi

$IPT -A local-udp-client-request -p udp \
		-d $TIME_SERVER --dport 123 \
		-j ACCEPT

$IPT -A remote-tcp-server-response -p udp \
		-s $TIME_SERVER --sport 123 \
		-j ACCEPT

################################################################
# ICMP traffic

# Log and drop initial ICMP fragment
$IPT -A EXT-icmp-in --fragment -j LOG --log-prefix "Fragmented incoming ICMP: "

$IPT -A EXT-icmp-in --fragment -j DROP

$IPT -A EXT-icmp-out --fragment -j LOG --log-prefix "Fragmented outgoing ICMP: "

$IPT -A EXT-icmp-out --fragment -j DROP

# Outgoing ping
if [ "CONNECTION_TRACKING" = "1" ];then
	$IPT -A EXT-icmp-out -p icmp \
			--icmp-type echo-request \
			-m state --state NEW \
			-j ACCEPT
fi

$IPT -A EXT-icmp-out -p icmp \
		--icmp-type echo-request -j ACCEPT

# Incoming echo-reply
$IPT -A EXT-icmp-in -p icmp \
		--icmp-type echo-reply -j ACCEPT

# Incoming ping
if [ "CONNECTION_TRACKING" = "1" ];then
	$IPT -A EXT-icmp-in -p icmp \
			-s $AUTH_HOSTS
			--icmp-type echo-request \
			-m state --state NEW \
			-j ACCEPT
fi

$IPT -A EXT-icmp-in -p icmp \
		-s $AUTH_HOSTS --icmp-type echo-request -j ACCEPT


$IPT -A EXT-icmp-out -p icmp \
		-d $AUTH_HOSTS --icmp-type echo-reply -j ACCEPT

# Destination Unreachable Type 3
$IPT -A EXT-icmp-out -p icmp \
		--icmp-type fragmentation-needed -j ACCEPT

$IPT -A EXT-icmp-in -p icmp \
		--icmp-type destination-unreachable -j ACCEPT

# Parameter-problem
$IPT -A EXT-icmp-out -p icmp \
		--icmp-type parameter-problem -j ACCEPT

$IPT -a EXT-icmp-in -p icmp \
		--icmp-type parameter-problem -j ACCEPT

# Time Exceeded
$IPT -A EXT-icmp-in -p icmp \
		--icmp-type time-exceeded -j ACCEPT

# Source Quench
$IPT -A EXT-icmp-out -p icmp \
		--icmp-type source-quench -j ACCEPT

#################################################################
# Stealth Scans and TCP State Flags

# All of the bits are cleared
$IPT -A tcp-state-flags -p tcp --tcp-flags ALL none -j DROP

# SYN and FIN are both Set
$IPT -A tcp-state-flags -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP

# SYN and RST are both Set
$IPT -A tcp-state-flags -p tcp --tcp-flags SYN,RST SYN,RST -j DROP

# FIN and RST are both Set
$IPT -A tcp-state-flags -p tcp --tcp-flags FIN,RST FIN,RST -j DROP

# FIN is the only bit set ,but not with the expected accompanying ACK set
$IPT -A tcp-state-flags -p tcp --tcp-flags FIN,ACK FIN -j DROP

# PSH is the only bit set ,but not with the expected accompanying ACK set
$IPT -A tcp-state-flags -p tcp --tcp-flags PSH,ACK PSH -j DROP

# URG is the only bit set ,but not with the expected accompanying ACK set
$IPT -A tcp-state-flags -p tcp --tcp-flags URG,ACK URG -j DROP

#################################################################
# Log and drop TCP packets with bad state combinations

$IPT -A log-tcp-state -p tcp -j LOG \
		--log-prefix "Illegal TCP state: " \
		--log-ip-options --log-tcp-options

$IPT -A log-tcp-state -j DROP

#################################################################
# Bypass rule checking for ESTABLISHED exchanges

if [ $CONNECTION_TRACKING = "1" ];then
	$IPT -A connection-tracking -m state --state ESTABLISHED,RELATED -j ACCEPT

	$IPT -A EXT-input -m state --state INVALID -j LOG \
			--log-prefix "INVALID packet: "
	$IPT -A connection-tracking -m state --state INVALID -j DROP
fi

#################################################################
# DHCP traffic

# Some broadcast packets are explicitly ignored ny firewall
# Others are dropped by default policy
# DHCP tests must precede broadcast-related rules, as DHCP relies
# on broadcasts traffic initially

if [ $DHCP_CLIENT = "1" ];then
	# Initialization or rebinding :No lease or lease time expired
	$IPT -A local-dhcp-client-query -p udp \
		-s $BROADCAST_SRC --sport 68 \
		-d $BROADCAST_DEST --dport 67 -j ACCEPT

	# Incoming DHCPOFFER from available DHCP servers
	$IPT -A remote-dhcp-server-response -p udp \
		-s $BROADCAST_SRC --sport 67 \
		-d $BROADCAST_DEST --dport 68 -j ACCEPT

	# Fall back to Initialization
	# The client knows its server, to perform a renew or confirm after reboot
	$IPT -A local-dhcp-client-query -p udp \
		-s $BROADCAST_SRC --sport 68 \
		-d $DHCP_SERVER --dport 67 -j ACCEPT

	# Incoming DHCPOFFER as a unicast to our server
	$IPT -A remote-dhcp-server-response -p udp \
		-s $DHCP_SERVER --sport 67 \
		-d $BROADCAST_DEST --dport 68 -j ACCEPT

	# As a result of the above ,we're supposed to change our ip address
	# with this message <-s $DHCP -d 255.255.255.255>
	# Depending on the server implementation,the destination address
	# can be the new address,subnet address, or the limited broadcast address

	# If the network subnet address is used as the destination,
	# the next rule must allow incoming packets detined to the subnet address,
	# and the rule must precede any general rules that block such incoming
	# broadcast packets

	# Incoming DHCPOFFER from available DHCP server
	$IPT -A remote-dhcp-server-response -p udp \
		-s $DHCP_SERVER --sport 67 \
		--dport 68 -j ACCEPT
	# Lease renewal
	$IPT -A local-dhcp-client-query \
			-s $IPADDR --sport 68 \
			-d $DHCP_SERVER --dport 67 -j ACCEPT
fi


#################################################################
# Source Address Checking
# Refuse spoofed packets pretending to be from IPADDR of server's
# ethernet adaptor
$IPT -A source-address-check -s $IPADDR -j DROP

# There is no need to block outgoing packet's destined for yourself
# as it will be sent to lo interface anyway,this is to say,the packet
# sent from your machine and to your machine never reaches external
# interface

# Refuse packets claiming to be from CLASS_A,CLASS_B and CLASS_C
# private network
$IPT -A source-address-check -s $CLASS_A -j DROP
$IPT -A source-address-check -s $CLASS_B -j DROP
$IPT -A source-address-check -s $CLASS_C -j DROP

# Refuse CLASS_D multicast address
# Illegal as soure address
$IPT -A source-address-check -s $CLASS_D_MULTICAST -j DROP
# Refuse packets from CLASS_E address
$IPT -A source-address-check -s $CLASS_E_RESERVED_NET -j DROP

# Refuse packages claiming from loopback interfaces
$IPT -A source-address-check -s $LOOPBACK -j DROP

# refuse address defined as reserved by the IANA
# 0.*.*.*      					-Can not be block due to DHCP
# 169.254.0.0/16 				- Link local networks
# 192.0.2.0/24					-TEST-NET
$IPT -A source-address-check -s 0.0.0.0/8 -j DROP
$IPT -A source-address-check -s 169.254.0.0/16 -j DROP
$IPT -A source-address-check -s 192.0.2.0/24 -j DROP

# Refuse malformed broadcast packets
$IPT -A source-address-check -s $BROADCAST_DEST -j LOG
$IPT -A source-address-check -s $BROADCAST_DEST -j DROP

#################################################################
# Destination Address Checking

# Block directed broadcasts from the Internet
$IPT -A destination-address-check -d

# Drop malformed broadcast packets
$IPT -A destination-address-check -d $BROADCAST_DEST -j DROP
$IPT -A destination-address-check -d $SUBNET_BASE -j DROP
$IPT -A destination-address-check -d $SUBNET_BROADCAST -j DROP

# Legitimate multicast packets are always UDP packets
# Refuse any not-udp packets to CLASS_D_MULTICAST address
$IPT -A destination-address-check ! -p udp -d $CLASS_D_MULTICAST -j DROP
# Accept incoming multicast packets
$IPT -A destination-address-check -p udp -d $CLASS_D_MULTICAST -j ACCEP

#################################################################
# Logging rules prior to default dropping policy

# ICMP rules default limit ==> 5 packets per second
$IPT -A EXT-log-in -p icmp \
		! --icmp-type echo-request -m limit -j LOG

# TCP rules
$IPT -A EXT-log-in -p tcp \
		--dport 0:19 -j LOG

# Skip ftp, telnet, ssh
$IPT -A EXT-log-in -p tcp \
		--dport 24 -j LOG

# Skip SMTP
$IPT -A EXT-log-in -p tcp \
		--dport 26:78 -j LOG

# Skip finger, www
$IPT -A EXT-log-in -p tcp \
		--dport 81:109 -j LOG

# Skip pop-3, sunrpc
$IPT -A EXT-log-in -p tcp \
		--dport 112:136 -j LOG

# Skip NetBIOS
$IPT -A EXT-log-in -p tcp \
		--dport 140:142 -j LOG

# Skip imap
$IPT -A EXT-log-in -p tcp \
		--dport 144:442 -j LOG

# Skip secure_web/HTTP over SSL
$IPT -A EXT-log-in -p tcp \
		--dport 444:1023 -j LOG

# UDP rules

$IPT -A EXT-log-in -p udp \
		--dport 0:110 -j LOG

# Skip sunrpc
$IPT -A EXT-log-in -p udp \
		--dport 112:160 -j LOG

# Skip snmp
$IPT -A EXT-log-in -p udp \
		--dport 163:634 -j LOG

# Skip NFS mountd (could be different from port 635, improvise if needed)
$IPT -A EXT-log-in -p udp \
		--dport 636:5531 -j LOG

# Skip pcAnywhere
$IPT -A EXT-log-in -p udp \
		--dport 5633:31336 -j LOG

# Skip traceroute regular ports
$IPT -A EXT-log-in -p udp \
		--sport $TRACEROUTE_SRC_PORTS \
		--dport $TRACEROUTE_DEST_PORTS -j LOG

# Skip other ports
$IPT -A EXT-log-in -p udp \
		--dport 33434:65535 -j LOG

# Outgoing Packets

# Do not log rejected outgoing ICMP destination-unreachable packets
$IPT -A EXT-log-out -p icmp \
		-icmp-type destination-unreachable -j DROP

$IPT -A EXT-log-out -j LOG

#################################################################
# Install the User-defined Chaines on the built-in
# INPUT and OUTPUT chains

# If TCP: Check for common stealth scan TCP state patterns
$IPT -A INPUT -p tcp -j tcp-state-flags
$IPT -A OUTPUT -p tcp -j tcp-state-flags

if [ "$CONNECTION_TRACKING" = "1" ];then
	# Bypassing firewall rules for already established traffic
	$IPT -A INPUT -j connection-tracking
	$IPT -A OUTPUT -j connection-tracking
fi

if [ "$DHCP_CLIENT" = "1" ];then
	$IPT -A INPUT -i $INTERNET -p udp \
			--sport 67 --dport 68 -j remote-tcp-server-response

	$IPT -A OUTPUT -o $INTERNET -p udp \
			--sport 68 --dport 67 -j local-dhcp-client-query

# Test for illegal source and definition address in incoming packets
$IPT -A INPUT ! -p tcp -j source-address-check
$IPT -A INPUT -p tcp --syn -j source-address-check
$IPT -A INPUT -j destination-address-check

# Test for illegal destination addresses in outgoing packets
$IPT -A OUTPUT -j destination-address-check

# Standard input filtering for all incoming packets to this host
$IPT -A INPUT -i $INTERNET -d $IPADDR -j EXT-input
$IPT -A INPUT -i $LAN_INTERFACE -j LAN-input

# Multicast traffic
#### CHOOSE WHETHER TO DROP OR ACCEPT!
$IPT -A INPUT -i $INTERNET -p udp -d $CLASS_D_MULTICAST -j [ DROP | ACCEPT ]
$IPT -A OUTPUT -o -p udp -s $IPADDR -d $CLASS_D_MULTICAST -j [ DROP | ACCEPT ]

# Standard output filtering for all outgoing packets from this host
$IPT -A OUTPUT -o $INTERNET -s $IPADDR -j EXT-output
$IPT -A OUTPUT -o $LAN_INTERFACE -j LAN-output

# Log everything failed to come through before default policy
$IPT -A INPUT -j EXT-log-in
$IPT -A OUTPUT -j EXT-log-out

#################################################################
# FORWARD rules
$IPT -A FORWARD -i $LAN_INTERFACE -o $EXTERNAL_INTERFACE \
        -p tcp -s $LAN_ADDRESSES --sport $UNPRIVPORTS \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $EXTERNAL_INTERFACE -o $LAN_INTERFACE \
        -p tcp -d $LAN_ADDRESSES --dport $UNPRIVPORTS \
        -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPT -A LAN-input -p tcp -s $LAN_ADDRESSES --sport $UNPRIVPORTS \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A LAN-output -p tcp -d $LAN_ADDRESSES --dport $UNPRIVPORTS \
        -m state --state ESTABLISHED,RELATED -j ACCEPT

exit 0
