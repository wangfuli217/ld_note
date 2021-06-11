ebtables
  ebtables 是 Linux网桥防火墙的一个以太网帧过滤工具。同时也包括了高级日志，MAC DNAT/SNAT 和brouter能力。
  ebtables只提供基础的IP过滤（完整功能的IP过滤由iptables实现）。
  
  bridge-nf的代码让iptables能够看见网桥过的IP数据包并实现透明的IP NAT。
  防火墙工具iptables和ebtables可以结合使用、互为补充。
  etables可以提供iptables不能提供的网桥过滤，实现非IP流量的过滤。
  
  能做什么
    以太网协议过滤
    MAC地址过滤
    简单的IP头过滤
    ARP头过滤
    802.1Q VLANgu哦旅
    进/出接口过滤（逻辑和物理设备）
    MAC地址nat
    日志
    帧计数
    可以添加，删除和插入规则；刷新过滤链路；计数器清零
    Brouter功能
    可以自动加载一个完整表，包含你创建的所有规则到内核
    支持用户定义过滤链
    支持标记帧和匹配标记的帧
  不能做什么
    全功能的IPv4/IPv6/ARP过滤（请使用iptables/ip6tables/arptables）
    过滤高于802.3以太网层的协议，过滤在802.3以太网帧内的ARP包。{Ip,Ip6,Arp}tables当前也不能过滤在802.3以太网帧的IPv4/IPv6/ARP流量

bridge-netfilter
  从Linux内核3.18-rc1开始，需要使用modprobe br_netfilter命令来激活bridge-netfilter
  >> bridge-nf使得netfilter可以对Linux网桥上的IPv4/ARP/IPv6包过滤。
  bridge-netfilter代码激活了以下功能
    {ip,ip6,arp}tables 可以过滤交换类型的IPv4/IPv6/ARP数据包，即使这些数据包是使用了 802.1Q VLAN 或PPPoE头包装的。
    可以通过使用相应的proc对象让{ip,ip6,arp}tables检查交换类型数据流。即proc文件系统的/proc/sys/net/bridge/目录下
      bridge-nf-call-arptables    # 是否在arptables的FORWARD中过滤网桥的ARP包
      bridge-nf-call-iptables     # 二层的网桥在转发包时也会被iptables的FORWARD规则所过滤
      bridge-nf-call-ip6tables    # 是否在ip6tables链中过滤IPv6包
      同样，让上述防火墙工具能够检查 802.1Q VLAN 和 PPPoE 包装的数据包也可以在相同目录下激活proc项.
      bridge-nf-filter-vlan-tagged    # 是否在iptables/arptables中过滤打了vlan标签的包
      bridge-nf-filter-pppoe-tagged
    当然，也可以通过/sys/devices/virtual/net/<bridge-name>/bridge/nf_call_iptables来设置，但要注意内核是取两者中大的生效。
    
    有时，可能只希望部分网桥禁止bridge-nf，而其他网桥都开启
      这时可以改用iptables的方法：
      iptables -t raw -I PREROUTING -i <bridge-name> -j NOTRACK

brouter即bridge router，
  同时作为网桥（交换机）和路由器的网络设备。brouter 为已知协议路由数据包，同时将其他所有非已知协议数据包类似网桥方式进行简单转发。
  决定哪个流量可以在两个接口间交换并决定相同的两个接口哪些流量可以路由。
  两个接口属于一个逻辑网桥设备，但是它们有自己的IP地址并且可以属于不同的子网。
