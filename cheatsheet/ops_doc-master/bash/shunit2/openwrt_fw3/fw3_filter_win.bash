oneTimeSetUp(){
ADB=$(which adb)
[ -z "$ADB" ] && { echo "error: adb tool is not found"; exit 1; }
adb shell true || { echo "error: no devices/emulators found"; exit 1; }

[ -z "$IPv4Addr" ]  && IPv4Addr=$(ipconfig /all | iconv -f GBK -t UTF-8 | grep IPv4 | grep 192 | awk -F : '{ print $2 }' | awk -F "(" '{ print $1 }')
[ -z "$IPv6Addr1" ] && IPv6Addr1=$(ipconfig /all | iconv -f GBK -t UTF-8 | grep IPv6 | grep 24 |sed 's/:/#/' | awk -F '#' '{ print $2 }' | awk -F "(" '{ print $1 }' | head -1)
[ -z "$IPv6Addr2" ] && IPv6Addr2=$(ipconfig /all | iconv -f GBK -t UTF-8 | grep IPv6 | grep 24 |sed 's/:/#/' | awk -F '#' '{ print $2 }' | awk -F "(" '{ print $1 }' | tail -1)
[ -z "$MAC" ]       && MAC=$(ipconfig /all | iconv -f GBK -t UTF-8 | grep 物理 | tail -1 | awk -F : '{ print $2 }' | awk -F "(" '{ print $1 }')


# tcp(ipv4) assert
{ wget -4 www.mi.com --bind-address="${IPv4Addr}" > /dev/null 2>&1 ; }|| { echo "error: tcp443(ipv4): wget -4 www.mi.com --bind-address=${IPv4Addr} failure"; }

# udp(ipv4) assert 
{ nslookup www.baidu.com 223.5.5.5 > /dev/null 2>&1 ; } || { echo "error: udp53(ipv4): nslookup www.baidu.com 223.5.5.5 failure"; }

# icmp(ipv4) assert
{ ping -4 www.mi.com -S=${IPv4Addr} > /dev/null 2>&1 ; }|| { echo "error: icmp-echo(ipv4): ping -4 www.mi.com failure"; }

# tcp(ipv6) assert
{ wget -6 www.mi.com > /dev/null 2>&1 ; }  || { echo "error: tcp443(ipv6): wget -6 www.mi.com failure"; }

# udp(ipv6) assert 
{ nslookup www.baidu.com 2400:3200::1 > /dev/null 2>&1 ; }|| { echo "error: udp53(ipv4): nslookup www.baidu.com 2400:3200::1 failure"; }

# icmp(ipv6) assert
{ ping -6 www.mi.com  > /dev/null 2>&1 ; } || { echo "error: icmp-echo(ipv6): ping -6 www.mi.com failure"; }

}


oneTimeTearDown(){
:
}

test_filter_adb(){
adb shell uci add firewall rule
adb shell uci set firewall.@rule[-1].src=wan
adb shell uci set firewall.@rule[-1].target=ACCEPT
adb shell uci set firewall.@rule[-1].proto=tcp
adb shell uci set firewall.@rule[-1].dest_port=22
adb shell uci commit firewall          > /dev/null
adb shell /etc/init.d/firewall restart > /dev/null

adb shell uci delete firewall.@rule[-1]
adb shell uci commit firewall
}

. shunit2






























