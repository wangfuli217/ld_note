#! /bin/sh

|Internet|
|
|EXTERNAL_INTERFACE|
|GATEWAY(this host)|
|DMZ_INTERFACE	   |
|
|-|WEB_SERVER|
|
|-|MAIL_SERVER|
|
|-|...|
|
|choke firewall|
|
|
|Private LAN|


#################################################################
# FORWARD rules
$IPT -A FORWARD -i $EXTERNAL_INTERFACE -o $DMZ_INTERFACE \
        -d $DMZ_ADDRESSES \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $DMZ_INTERFACE -o $EXTERNAL_INTERFACE \
        -s $DMZ_ADDRESSES \
        -m state --state ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $DMZ_INTERFACE -o $EXTERNAL_INTERFACE \
        -s $LAN_ADDRESSES \
        -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

$IPT -A FORWARD -i $EXTERNAL_INTERFACE -o $DMZ_INTERFACE \
        -d $LAN_ADDRESSES \
        -m state --state ESTABLISHED,RELATED -j ACCEPT    
            
exit 0