gre(ipsec){
IPSec目前只能对单播报文进行加密保护，不能对组播报文进行加密保护。而GRE可以将组播报文封装成单播报文，
但不能对报文进行加密保护。

GRE的最大作用是对路由协议、语音、视频等组播报文或IPv6报文进行封装。
}

gre(校园网中GRE隧道技术的应用){
http://mccltd.net/blog/?p=502
}
ip tunnel add netb mode gre remote 192.168.47.198 local 192.168.47.190 ttl 255
sudo ip link set netb up
sudo ip addr add 172.16.2.1/24 peer 172.16.2.2/24 dev netb
sudo ip route add 172.16.2.1/24 dev netb

ip tunnel add netb1 mode gre remote 192.168.47.199 local 192.168.47.190 ttl 255
sudo ip link set netb1 up
sudo ip addr add 172.16.1.1/24 peer 172.16.1.2/24 dev netb1
sudo ip route add 172.16.1.1/24 dev netb1


http://lartc.org/howto/lartc.tunnel.gre.html
http://www.tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.tunnel.gre.html

http://www.ttlsa.com/linux/create-a-gre-tunnel-linux/
https://clavinli.github.io/2014/04/17/linux-create-gre-tunnel/

gre(openwrt){
gre.sh      /lib/netifd/proto/
*.lua       /usr/lib/lua/luci/model/network
netifd      如何管理gre.sh 以及 *.lua如何通知netifd
config.sh   /lib/network/config.sh
}
# dhcp.sh 与 netifd之间调用关系说明
http://blog.csdn.net/liangdsing/article/details/62423221
https://dev.openwrt.org/browser/trunk/package/network/config/netifd/files/lib/network/config.sh

ubus call network get_proto_handlers
"gre": {
        "validate": {
                "mtu": "uinteger",
                "ttl": "uinteger",
                "tos": "string",
                "tunlink": "string",
                "zone": "string",
                "ikey": "uinteger",
                "okey": "uinteger",
                "icsum": "bool",
                "ocsum": "bool",
                "iseqno": "bool",
                "oseqno": "bool",
                "multicast": "bool",
                "ipaddr": "string",
                "peeraddr": "string",
                "df": "bool"
        },
        "no_device": true
},
#https://wiki.openwrt.org/doc/uci/network#common_options_for_gre_protocols

gre(需求){
序号  开启 隧道名称 隧道目的IP   LTE 　接口虚拟IP  　对端内网网段
 1    Yes  g0       20.70.20.210 LTE 　173.16.1.11 　192.168.2.0/24

添加          添加一条隧道       点击添加，可增加一条隧道，最多添加20条
开启          显示开启/关闭项    开启或关闭GRE隧道，点击选择
                                 # 选择开启条目生效，选择关闭条目实效
隧道名称      显示隧道名称       输入隧道名称 # 根据情况输入，隧道名称如gre0
隧道目的IP    显示IP地址输入项   输入隧道目的IP地址 # 如124.42.16.26
隧道虚拟IP    显示IP地址输入项   输入隧道本地IP地址，需要加掩码 # 10.0.1.5/24 需要添加掩码
对端内网网段  显示IP地址输入项   输入对端内网网段，需要加掩码   # 10.0.2.0/24 需要添加掩码
}

gre(实例){
V:\openwrt\linux GRE的加载与配置实例 .txt
}

sudo ip tunnel add tunnel1 mode gre remote 192.168.47.198 local 192.168.47.190 ttl 255
ip link set tunnel1 up mtu 1400
sudo ip link set tunnel0 up mtu 1400
sudo ip addr add 172.16.2.1/24 peer 172.16.2.2/24 dev tunnel1
ip link
sudo ip addr del 172.16.1.1/30  dev tunnel0
sudo ip addr add 172.16.1.1/30 peer 172.16.1.2/30 dev tunnel0
 
gre(gre.config.log){}
netifd_ubus_init(1150): connected as c2b4a72b
proto_shell_add_handler(913): Add handler for script ./3g.sh: 3g
proto_shell_add_handler(913): Add handler for script ./dhcp.sh: dhcp
proto_shell_add_handler(913): Add handler for script ./dhcpv6.sh: dhcpv6
proto_shell_add_handler(913): Add handler for script ./gre.sh: gre
proto_shell_add_handler(913): Add handler for script ./gre.sh: gretap
proto_shell_add_handler(913): Add handler for script ./gre.sh: grev6
proto_shell_add_handler(913): Add handler for script ./gre.sh: grev6tap
proto_shell_add_handler(913): Add handler for script ./ncm.sh: ncm
proto_shell_add_handler(913): Add handler for script ./openconnect.sh: openconnect
proto_shell_add_handler(913): Add handler for script ./ppp.sh: ppp
proto_shell_add_handler(913): Add handler for script ./ppp.sh: pppoe
proto_shell_add_handler(913): Add handler for script ./qmi.sh: qmi
proto_shell_add_handler(913): Add handler for script ./vpnc.sh: vpnc
proto_shell_add_handler(913): Add handler for script ./wireguard.sh: wireguard
proto_shell_add_handler(913): Add handler for script ./wwan.sh: 3g
proto_shell_add_handler(913): Add handler for script ./wwan.sh: wwan
interface_update(1233): Create interface 'loopback'
device_create_default(441): Create simple device 'lo'
device_init_virtual(404): Initialize device 'lo'
cb_clear_event(759): Remove an address from device lo
device_set_present(536): Network device 'lo' is now present
__device_add_user(588): Add user for device 'lo', refcount=1
interface_set_available(424): Interface 'loopback', available=1
__device_add_user(588): Add user for device 'lo', refcount=2

device_create(852): Create new device 'br-lan' (Bridge)
device_init_virtual(404): Initialize device 'br-lan'
system_if_clear_state(851): Delete existing bridge named 'br-lan'
interface_update(1233): Create interface 'lan'
__device_add_user(588): Add user for device 'br-lan', refcount=1
__device_add_user(588): Add user for device 'br-lan', refcount=2
interface_add_dns_server(1123): Add IPv4 DNS server: 192.168.1.1

interface_update(1233): Create interface 'wan'
device_create_default(441): Create simple device 'eth1'
device_init_virtual(404): Initialize device 'eth1'
cb_clear_event(759): Remove an address from device eth1
device_set_present(536): Network device 'eth1' is now present
__device_add_user(588): Add user for device 'eth1', refcount=1
interface_set_available(424): Interface 'wan', available=1
__device_add_user(588): Add user for device 'eth1', refcount=2

interface_update(1233): Create interface 'gre'
interface_set_available(424): Interface 'gre', available=1

interface_update(1233): Create interface 'gre_addr'
device_init_virtual(404): Initialize device ''
__device_add_user(588): Add user for device '', refcount=1
__device_add_user(588): Add user for device '', refcount=2

cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
cb_clear_event(755): Remove a rule
config_init_wireless(357): No wireless configuration found
device_create_default(441): Create simple device 'eth0'
device_init_virtual(404): Initialize device 'eth0'
cb_clear_event(759): Remove an address from device eth0
cb_clear_event(759): Remove an address from device eth0
cb_clear_event(759): Remove an address from device eth0
device_set_present(536): Network device 'eth0' is now present
__device_add_user(588): Add user for device 'eth0', refcount=1
device_set_present(536): Bridge 'br-lan' is now present
interface_set_available(424): Interface 'lan', available=1
device_claim(340): Claim Bridge br-lan, new active count: 1
device_claim(340): Claim Network device eth0, new active count: 1
interface_queue_event(114): Queue hotplug handler for interface 'lan', event 'ifup'
call_hotplug(90): Call hotplug handler for interface 'lan', event 'ifup' (br-lan)
proto_shell_handler(236): run setup for interface 'gre'
device_claim(340): Claim Network device lo, new active count: 1
interface_queue_event(114): Queue hotplug handler for interface 'loopback', event 'ifup'
device_claim(340): Claim Network device eth1, new active count: 1
[180665.212023] 8021q: adding VLAN 0 to HW filter on device eth1
interface_queue_event(114): Queue hotplug handler for interface 'wan', event 'ifup'
device_create(852): Create new device 'gre-gre' (IP tunnel)
device_init_virtual(404): Initialize device 'gre-gre'
cb_clear_event(759): Remove an address from device gre-gre
device_set_present(536): IP tunnel 'gre-gre' is now present
device_apply_config(722): Device 'gre-gre': config applied
device_set_present(536): IP tunnel 'gre-gre' is no longer present
device_set_present(536): IP tunnel 'gre-gre' is now present
__device_add_user(588): Add user for device 'gre-gre', refcount=1
device_claim(340): Claim IP tunnel gre-gre, new active count: 1
interface_queue_event(114): Queue hotplug handler for interface 'gre', event 'ifup'
__device_add_user(588): Add user for device 'gre-gre', refcount=2
device_set_present(536): Network alias 'gre-gre' is now present
interface_set_available(424): Interface 'gre_addr', available=1
device_claim(340): Claim Network alias gre-gre, new active count: 1
device_claim(340): Claim IP tunnel gre-gre, new active count: 2
interface_queue_event(114): Queue hotplug handler for interface 'gre_addr', event 'ifup'
Warning: Section @zone[1] (wan) cannot resolve device of network 'wan6'
Warning: Section @zone[2] (cjdns) cannot resolve device of network 'cjdns'
Warning: Section @zone[2] (cjdns) has no device, network, subnet or extra options
 * Clearing IPv4 filter table
 * Clearing IPv4 nat table
 * Clearing IPv4 mangle table
 * Clearing IPv4 raw table
 * Populating IPv4 filter table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'tunnel'
   * Rule 'Allow-DHCP-Renew'
   * Rule 'Allow-Ping'
   * Rule 'Allow-IGMP'
   * Rule #7
   * Rule #8
   * Forward 'lan' -> 'wan'
 * Populating IPv4 nat table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'tunnel'
 * Populating IPv4 mangle table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'tunnel'
 * Populating IPv4 raw table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'tunnel'
 * Clearing IPv6 filter table
 * Clearing IPv6 mangle table
 * Clearing IPv6 raw table
 * Populating IPv6 filter table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'cjdns'
   * Zone 'tunnel'
   * Rule 'Allow-DHCPv6'
   * Rule 'Allow-MLD'
   * Rule 'Allow-ICMPv6-Input'
   * Rule 'Allow-ICMPv6-Forward'
   * Rule #7
   * Rule #8
   * Rule 'Allow-ICMPv6-cjdns'
   * Forward 'lan' -> 'wan'
 * Populating IPv6 mangle table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'cjdns'
   * Zone 'tunnel'
 * Populating IPv6 raw table
   * Zone 'lan'
   * Zone 'wan'
   * Zone 'cjdns'
   * Zone 'tunnel'
 * Set tcp_ecn to off
 * Set tcp_syncookies to on
 * Set tcp_window_scaling to on
 * Running script '/usr/lib/bcp38/run.sh'
device_apply_config(740): Device 'gre-gre': no configuration change
interface_queue_event(114): Queue hotplug handler for interface 'gre', event 'ifupdate'

gre(Makefile:config){
https://dev.openwrt.org/browser/trunk/package/network/config/gre/Makefile?rev=41897

 gre: Generic Routing Encapsulation package support

The package supports Generic Routing Encapsulation support by registering following protocol kinds:

    -gre
    -gretap
    -grev6
    -grev6tap

Following options are valid for gre and gretap kinds:

    -ipaddr
    -peeraddr
    -df
    -mtu
    -ttl
    -tunlink
    -zone
    -ikey
    -okey
    -icsum
    -ocsum
    -iseqno
    -oseqno

The gretap kind supports additionally the network option

Following options are valid for grev6 and grev6tap kinds:

    -ip6addr
    -peer6addr
    -weakif
    -mtu
    -ttl
    -tunlink
    -zone
    -ikey
    -okey
    -icsum
    -ocsum
    -iseqno
    -oseqno

The grev6tap kind supports additionally the network option

Typical network config for a GREv4 tunnel :

config interface 'gre'

    option peeraddr '172.16.18.240'
    option mtu '1400'
    option proto 'gre'
    option tunlink 'wan'
    option zone 'tunnel'

Typical network config for a GREv4 tap tunnel :

config interface 'gretap'

    option peeraddr '195.207.5.79'
    option mtu '1400'
    option proto 'gretap'
    option zone 'tunnel'
    option tunlink 'wan'
    option network 'wlan_ap'
    
}