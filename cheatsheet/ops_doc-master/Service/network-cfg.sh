NSS(主机名解析)
{
主机名解析，目前也是由 NSS (名字服务转换 Name Service Switch) 机制来支持。这个解析的流程如下。

1. "/etc/nsswitch.conf" 文件里的 "hosts: files dns" 这段规定主机名解析顺序。(代替"/etc/host.conf"文件里的"order" 这段原有的功能。)
2. files方式首先被调用。如果主机名在"/etc/hosts"文件里面发现，则返回所有有效地址并退出。("/etc/host.conf" 文件包含 "multi on".)
3. dns方式被调用。如果主机名通过查询"/etc/resolv.conf"文件里面写的 互联网域名系统 Domain Name System (DNS) 来找到，则返回所有有效地址并退出。

对于典型 adhoc 局域网环境下的 PC 工作站，除了基本的 files 和 dns 方式之外，主机名还能够通过组播 DNS (mDNS, 零配置网络 Zeroconf)进行解析。
    Avahi 提供 Debian 下的组播 DNS 发现框架。
    它和 Apple Bonjour / Apple Rendezvous 相当.
    libnss-mdns 插件包提供 mDNS 的主机名解析，GNU C 库 (glibc)的 GNU 名字服务转换 Name Service Switch (NSS) 功能支持 mDNS。
    "/etc/nsswitch.conf" 文件应当有像 "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" 这样的一段.
    ".local"结尾的主机名，使用 pseudo-top-level domain (TLD) 来解析.
    mDNS IPv4 本地连接组播地址 "224.0.0.251" 或它相应的 IPv6 地址 "FF02::FB" 被用来作为 ".local" 结尾名字的 DNS 查询。

}

network(网络接口名称)
{
    网络接口名称，比如说 eth0, 是在 Linux 内核里分配给每一个硬件的，当这个硬件被内核发现的时候，通过用户层的配置机制udev 
(参见 第 3.3 节 “udev 系统”)来分配.网卡接口名称也就是 ifup(8) 和 interfaces(5)里的 physical interface。
    为了保证每个网络接口名称在每次重启后一致，会用到 MAC 地址 等,有一个规则文件"/etc/udev/rules.d/70-persistent-net.rules".
这个文件是由"/lib/udev/write_net_rules" 程序自动生成，是由 "persistent-net-generator.rules" 规则文件来运行. 你可以修改该文
件来改变命名规则。
}


network(网络连接方式和连接路径列表)
{
PC                  连接方式          连接路径
串口 (ppp0)         PPP               <->modem<->POTS<->拨号接入点<->ISP
以太网口 (eth0)     PPPoE/DHCP/Static <->宽带-modem<->宽带链路<->宽带接入点<->ISP
以太网口 (eth0)     DHCP/Static       <->LAN<->网络地址转换 (NAT) 的宽带路由器 (⇔ 宽带-modem …)
}

network(网络连接配置列表)
{
连接方式        配置                                  后端包
PPP             pppconfig  创建固定的 chat            pppconfig, ppp
PPP (选用)      wvdialconf 创建启发式的 chat          ppp, wvdial
PPPoE           pppoeconf  创建固定的 chat            pppoeconf, ppp
DHCP            在 "/etc/dhcp/dhclient.conf" 里描述   isc-dhcp-client
静态 IP (IPv4)  在 "/etc/network/interfaces" 里描述   iproute 或 net-tools (旧)
静态 IP (IPv6)  在 "/etc/network/interfaces" 里描述   iproute


}