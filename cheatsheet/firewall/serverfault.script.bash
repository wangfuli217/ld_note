#!/bin/bash

# https://serverfault.com/questions/245711/iptables-tips-tricks?noredirect=1
# The following iptables/ip6tables configurations have
# been kindly shared with us from ArckWiki. There are
# a few additions apart from what has been defined.
#
#=================Flush current definitions==============
    iptables -F
    ip6tables -F
    iptables -X
    ip6tables -X

#
#=================Chains=================================
#
#----Define chains for opened ports
    iptables -N TCP
    ip6tables -N TCP
    iptables -N UDP
    ip6tables -N UDP

#
#----Setting up the filter table for NAT
#   iptables -N fw-interfaces
#   ip6tables -N fw-interfaces
#   iptables -N fw-open
#   ip6tables -N fw-open

#
#================Default Chain reactions=================
#
#----Default FORWARD reaction
    iptables -P FORWARD DROP
    ip6tables -P FORWARD DROP

#
#----Default OUTPUT reaction
    iptables -P OUTPUT ACCEPT
    ip6tables -P OUTPUT ACCEPT

#
#----Shellshock
    iptables -A INPUT -m string --algo bm --hex-string '|28 29 20 7B|' -j DROP
    ip6tables -A INPUT -m string --algo bm --hex-string '|28 29 20 7B|' -j DROP

#
#----Default INPUT reaction
    iptables -P INPUT DROP
    ip6tables -P INPUT DROP
#
#----Drop spoofing packets
    iptables -A INPUT -i eth0 -s 127.0.0.0/8 -j DROP
    iptables -A INPUT -i wlan0 -s 127.0.0.0/8 -j DROP
    iptables -A INPUT -i wlan1 -s 127.0.0.0/8 -j DROP
    iptables -A INPUT -s 10.0.0.0/8 -j DROP
    iptables -A INPUT -s 169.254.0.0/16 -j DROP
    iptables -A INPUT -s 172.16.0.0/12 -j DROP
    iptables -A INPUT -s 224.0.0.0/4 -j DROP
    iptables -A INPUT -d 224.0.0.0/4 -j DROP
    iptables -A INPUT -s 240.0.0.0/5 -j DROP
    iptables -A INPUT -d 240.0.0.0/5 -j DROP
    iptables -A INPUT -s 0.0.0.0/8 -j DROP
    iptables -A INPUT -d 0.0.0.0/8 -j DROP
    iptables -A INPUT -d 239.255.255.0/24 -j DROP
    iptables -A INPUT -d 255.255.255.255 -j DROP

#
#================Ping rate limiting globally=============
    iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 30/min --limit-burst 8 -j ACCEPT
    ip6tables -A INPUT -p icmpv6 --icmpv6-type 8 --match limit --limit-burst 8 -j ACCEPT
    iptables -A INPUT -p icmp --icmp-type 8 -j DROP
    ip6tables -A INPUT -p icmpv6 --icmpv6-type 8 -j DROP

#
#----flooding RST packets, smurf attack Rejection
    iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT
    ip6tables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

#
#----Bogus packet DROP
    iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
    ip6tables -A INPUT -p tcp -m tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
    iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
    ip6tables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP

#
#================RELATED,ESTABLISHED reaction============
    iptables -A INPUT --match conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    ip6tables -A INPUT --match conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#
#================unfetered loopback======================
    iptables -A INPUT -i lo -j ACCEPT
    ip6tables -A INPUT -i lo -j ACCEPT

#
#================INVALID catagory of packets=============
    iptables -A INPUT -p 41 -j ACCEPT
    iptables -A INPUT --match conntrack --ctstate INVALID -j DROP
    ip6tables -A INPUT --match conntrack --ctstate INVALID -j DROP

#
#================IPv6 reactions and definitions==========
    ip6tables -A INPUT -s fe80::/10 -p icmpv6 -j ACCEPT
    ip6tables -t raw -A PREROUTING -p icmpv6 -s fe80::/10 -j ACCEPT
    ip6tables -t raw -A PREROUTING --match rpfilter -j ACCEPT
    ip6tables -t raw -A PREROUTING -j DROP
#
#=======Acceptable INVALIDs and a curteous response======
    iptables -A INPUT -p udp --match conntrack --ctstate NEW -j UDP
    ip6tables -A INPUT -p udp --match conntrack --ctstate NEW -j UDP
    iptables -A INPUT -p tcp --syn --match conntrack --ctstate NEW -j TCP
    ip6tables -A INPUT -p tcp --syn --match conntrack --ctstate NEW -j TCP

#
#================Defining the TCP and UDP chains
#
#########################################################
#            Notes for port open definitions            #
# It is important to note that this should be config-   #
# ured differently if you're providing any routing      #
# activity for any purpose. it is up to you to actively #
# define what suites your needs to get the job done.    #
# In this example, I'm exempting IPv6 from being able   #
# to interact with SSH protocols for two reasons. The   #
# first is because it is generally easier and more com- #
# for internal networks to be deployed with IPv4. The   #
# second reason is, IPv6 can be deployed globally.      #
#########################################################
#
#----SSH configured for eth0
    iptables -A TCP -i eth0 -p tcp --dport ssh -j ACCEPT

#!---Blocking SSH interactions in IPv6
    ip6tables -A TCP -p tcp --dport ssh -j DROP

#!---Leave commented for end service device
#   iptables -A TCP -p tcp --dport 80 -j ACCEPT
#   ip6tables -A TCP -p tcp --dport 80 -j ACCEPT
#   iptables -A TCP -p tcp --dport 443 -j ACCEPT
#   ip6tables -A TCP -p tcp --dport 443 -j ACCEPT
#
#!---Uncomment for remote service to this device
#   iptables -A TCP -p tcp --dport 22 -j ACCEPT
#   ip6tables -A TCP -p tcp --dport 22 -j ACCEPT
#
#!---Uncomment if you're providing routing services
#   iptables -A UDP -p udp 53 -j ACCEPT
#   ip6tables -A UDP -p udp 53 -j ACCEPT
#
#=================Tricking port scanners=================
#
#----SYN scans
    iptables -I TCP -p tcp --match recent --update --seconds 60 --name TCP-PORTSCAN -j DROP
    ip6tables -I TCP -p tcp --match recent --update --seconds 60 --name TCP-PORTSCAN -j DROP
    iptables -A INPUT -p tcp --match recent --set --name TCP-PORTSCAN -j DROP
    ip6tables -A INPUT -p tcp --match recent --set --name TCP-PORTSCAN -j DROP

#
#----UDP scans
    iptables -I UDP -p udp --match recent --update --seconds 60 --name UDP-PORTSCAN -j DROP
    ip6tables -I UDP -p udp --match recent --update --seconds 60 --name UDP-PORTSCAN -j DROP
    iptables -A INPUT -p udp --match recent --set --name UDP-PORTSCAN -j DROP
    ip6tables -A INPUT -p udp --match recent --set --name UDP-PORTSCAN -j DROP

#
#----For SMURF attack protection
    iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
    iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
    iptables -A INPUT -p icmp -m limit --limit 2/second --limit-burst 2 -j ACCEPT
    ip6tables -A INPUT -p icmpv6 -m limit --limit 2/second --limit-burst 2 -j ACCEPT

#
#----Ending all other undefined connections
    iptables -A INPUT -j DROP
    ip6tables -A INPUT -j DROP

#
#=======Defining the IN_SSH chain for bruteforce of SSH==
#
#!---I've elected to keep IPv6 out of this realm for
#!---ease of use
    iptables -N IN_SSH
    iptables -A INPUT -p tcp --dport ssh --match conntrack --ctstate NEW -j IN_SSH
    iptables -A IN_SSH --match recent --name sshbf --rttl --rcheck --hitcount 3 --seconds 10 -j DROP
    iptables -A IN_SSH --match recent --name sshbf --rttl --rcheck --hitcount 4 --seconds 1800 -j DROP
    iptables -A IN_SSH --match recent --name sshbf --set -j ACCEPT
    iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -j IN_SSH

#
#==================Setting up a NAT gateway==============
#
#########################################################
#                                                       #
# I commented this half out because it's not something  #
# that will apply to all setups. Make note of all par-  #
# tinate interfaces and what exactly is going on.       #
#                                                       #
#########################################################
#
#----Setting up the FORWARD chain
#   iptables -A FORWARD --match conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#   ip6tables -A FORWARD --match conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#
#
#----Defining the fw-interfaces/open chains for FORWARD
#   iptables -A FORWARD -j fw-interfaces
#   ip6tables -A FORWARD -j fw-interfaces
#   iptables -A FORWARD -j fw-open
#   ip6tables -A FORWARD -j fw-open
#   iptables -A FORWARD -j DROP # Should be REJECT. But, fuck them
#   ip6tables -A FORWARD -j DROP
#   iptables -P FORWARD DROP
#   ip6tables -P FORWARD DROP
#
#
#----Setting up the nat table
#   iptables -A fw-interfaces -i ### -j ACCEPT
#   ip6tables -A fw-interfaces -i ### -j ACCEPT
#   iptables -t nat -A POSTROUTING -s w.x.y.z/S -o ppp0 -j MASQUERADE
#   ip6tables -t nat -A POSTROUTING -s fe::/10 -o ppp0 -j MASQUERADE
#----The above lines should be repeated specifically for EACH interface
#
#----Setting up the PREROUTING chain
#
#######################################################
#                             #
# The PREROUTING chain will redirect either port      #
# targets to be redirected. This can also redirect    #
# traffic inbound to your network from the gateway    #
# to this machine. This can be useful if you're using #
# a honeypot or have any service within your network  #
# that you want to be pointed to a specific device.   #
#                             #
#######################################################
#
#----SSH honeypot server
#   iptables -A fw-open -d HONEYPOT_IP -p tcp --dport 22 -j ACCEPT
#   ip6tables -A fw-open -d HONEYPOT_IP -p tcp --dport 22 -j ACCEPT
#----With intuition, you can configure the above to also direct specific
#----requests to other devices providing those services. The bellow will
#----be for a squid server
#   iptables -A fw-open -d SQUID_IP -p tcp --dport 80 -j ACCEPT
#   ip6tables -A fw-open -d SQUID_IP -p tcp --dport 80 -j ACCEPT
#   iptables -t nat -A PREROUTING -i ppp0 -p tcp --dport 8000 -j DNAT --to SQUID_IP
#   ip6tables -t nat -A PREROUTING -i ppp0 -p tcp --dport 8000 -j DNAT --to SQUID_IP
#
#===============Declare configurations=================
    iptables -nvL
    ip6tables -nvL