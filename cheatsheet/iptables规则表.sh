centos()
{
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
#######################
:INPUT ACCEPT [0:0]
# 该规则表示INPUT表默认策略是ACCEPT
 
:FORWARD ACCEPT [0:0]
# 该规则表示FORWARD表默认策略是ACCEPT
 
:OUTPUT ACCEPT [0:0]
# 该规则表示OUTPUT表默认策略是ACCEPT
 
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# 意思是允许进入的数据包只能是刚刚我发出去的数据包的回应，ESTABLISHED：已建立的链接状态。RELATED：该数据包与本机发出的数据包有关。
 
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
# 这两条的意思是在INPUT表和FORWARD表中拒绝所有其他不符合上述任何一条规则的数据包。并且发送一条host prohibited的消息给被拒绝的主机。
 
-A INPUT -i lo -j ACCEPT
-i 参数是指定接口，这里的接口是lo ，lo就是Loopback（本地环回接口），意思就允许本地环回接口在INPUT表的所有数据通信。
 
这个是iptables的默认策略，你也可以删除这些，另外建立符合自己需求的策略。
}


bash()
{

#!/bin/bash
### Clear Old Rules
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
### * filter
# Default DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
# INPUT Chain
iptables -A INPUT -p gre -j ACCEPT
iptables -A INPUT -i lo -p all -j ACCEPT
iptables -A INPUT -p tcp -m tcp –dport 21 -j ACCEPT
iptables -A INPUT -p tcp -m tcp –dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m tcp –dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp –dport 1723 -j ACCEPT
iptables -A INPUT -p icmp -m icmp –icmp-type any -j ACCEPT
iptables -A INPUT -m state –state RELATED,ESTABLISHED -j ACCEPT
# OUTPUT Chain
iptables -A OUTPUT -m state –state NEW,RELATED,ESTABLISHED -j ACCEPT
# FORWARD Chain
iptables -A FORWARD -s 192.168.0.0/24 -o eth0 -j ACCEPT
iptables -A FORWARD -d 192.168.0.0/24 -i eth0 -j ACCEPT
### * nat
# POSTROUTING Chain
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
}
