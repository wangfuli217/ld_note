#! /bin/sh

|Internet|
|
|
|GATEWAY|
|
|-|WEB_SERVER|
|
|-|MAIL_SERVER|
|
|-|...|
|
|
|   	DMZ_INTERFACE			|
|choke firewall (this host)     |
|		LAN_INTERFACE			|	
|
|
|Private LAN|


#################################################################
# FORWARD rules

$IPT -A FORWARD -i $LAN_INTERFACE -o $DMZ_INTERFACE \
        -s $LAN_ADDRESSES \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $DMZ_INTERFACE -o $LAN_INTERFACE \
        -d $LAN_ADDRESSES \
        -m state --state ESTABLISHED,RELATED -j ACCEPT
            
exit 0