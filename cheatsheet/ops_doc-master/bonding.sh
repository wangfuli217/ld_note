bond(bonding.conf)
{
vi /etc/modprobe.d/bonding.conf
alias bond0 bonding
options bond0 miimon=100（ms毫秒） mode=0（bonding工作模式）
miimon=100：系统每100ms监测一次链路状态。
alias bond1 bonding
options bond1 miimon=100 mode=0
alias bond2 bonding
options bond2 miimon=100 mode=1

# alias bond0 bonding
# options bond0 miimon=100 mode=1
# install bond1 /sbin/modprobe bonding -o bond1 miimon=200 mode=0

# miimon 监视网络链接的频度，单位是毫秒，我们设置的是200毫秒。
# max_bonds 配置的bond口个数
# mode bond模式，主要有以下几种，在一般的实际应用中，0和1用的比较多，
}

bond(bonding)
{
加载bonding模块
depmod
modprobe bonding
lsmod  | grep bonding
bonding               107911  0
}
 
bond(slave)
{
现在添加4块网卡，2块聚合bond0，2块聚合bond1，最后bond0和bond1聚合成bond2。
每个物理网卡都这样配
vi ifcfg-ethX
DEVICE="eth0"
BOOTPROTO="none"
MASTER=bond0
SLAVE="yes"
#BROADCAST="192.168.255.255"
#GATEWAY="192.168.1.1"
#HWADDR="7C:D3:0A:C9:AE:78"
#IPADDR="192.168.60.10"
#NETMASK="255.255.0.0"
#NM_CONTROLLED="yes"
ONBOOT="yes"
#TYPE="Ethernet"
#UUID="40513977-0b77-4374-a29e-d05e47b1deae"
}

bond(master)
{
ifcfg-bond0和ifcfg-bond1都按如下方式写
DEVICE="bond0"
BOOTPROTO="none"
BROADCAST="192.168.255.255"
GATEWAY="192.168.1.1"
IPADDR="192.168.60.10"
NETMASK="255.255.0.0"
NM_CONTROLLED="no"
ONBOOT="yes"
}

bond(rc.local)
{
[root@test ~]# vi /etc/rc.d/rc.local
#追加
ifenslave bond0 eth0 eth1
route add default gw 192.168.0.1
#如可上网就不用增加路由，0.1地址按环境修改.
}
bond(mode)
{
网卡绑定mode共有七种(0~6) bond0、bond1、bond2、bond3、bond4、bond5、bond6
    常用的有三种
mode=0：平衡负载模式，有自动备援，但需要"Switch"支援及设定。
mode=1：自动备援模式，其中一条线若断线，其他线路将会自动备援。
mode=6：平衡负载模式，有自动备援，不必"Switch"支援及设定。

需要说明的是如果想做成mode 0的负载均衡,仅仅设置这里options bond0 miimon=100 mode=0是不够的,与网卡相连的
交换机必须做特殊配置（这两个端口应该采取聚合方式），因为做bonding的这两块网卡是使用同一个MAC地址.从原理
分析一下（bond运行在mode 0下）：
mode 0下bond所绑定的网卡的IP都被修改成相同的mac地址，如果这些网卡都被接在同一个交换机，那么交换机的arp表
里这个mac地址对应的端口就有多 个，那么交换机接受到发往这个mac地址的包应该往哪个端口转发呢？正常情况下mac
地址是全球唯一的，一个mac地址对应多个端口肯定使交换机迷惑了。所以 mode0下的bond如果连接到交换机，交换机
这几个端口应该采取聚合方式（cisco称为 ethernetchannel，foundry称为portgroup），因为交换机做了聚合后，聚合
下的几个端口也被捆绑成一个mac地址.我们的解决办法是，两个网卡接入不同的交换机即可。
}

bond(mode=0 平衡抡循环策略)
{
第一种模式：mod=0 ，即：(balance-rr) Round-robin policy（平衡抡循环策略）

特点：传输数据包顺序是依次传输（即：第1个包走eth0，下一个包就走eth1….一直循环下去，直到最后一个传输完毕），
此模式提供负载平衡和容错能力；但是我们知道如果一个连接或者会话的数据包从不同的接口发出的话，中途再经过不同
的链路，在客户端很有可能会出现数据包无序到达的问题，而无序到达的数据包需要重新要求被发送，这样网络的吞吐量
就会下降
}
bond(mode=1 主-备份策略)
{
第二种模式：mod=1，即： (active-backup) Active-backup policy（主-备份策略）

特点：只有一个设备处于活动状态，当一个宕掉另一个马上由备份转换为主设备。mac地址是外部可见得，从外面看来，
bond的MAC地址是唯一的，以避免switch(交换机)发生混乱。此模式只提供了容错能力；由此可见此算法的优点是可以
提供高网络连接的可用性，但是它的资源利用率较低，只有一个接口处于工作状态，在有N个网络接口的情况下，资源
利用率为1/N
}
bond(mode=2 XOR policy平衡策略)
{
第三种模式：mod=2，即：(balance-xor) XOR policy（平衡策略）

特点：基于指定的传输HASH策略传输数据包。缺省的策略是：(源MAC地址 XOR 目标MAC地址) % slave数量。其他的
传输策略可以通过xmit_hash_policy选项指定，此模式提供负载平衡和容错能力
}
bond(mode=3 broadcast广播策略)
{
第四种模式：mod=3，即：broadcast（广播策略）

特点：在每个slave接口上传输每个数据包，此模式提供了容错能力
}
bond(mode=4 IEEE 802.3ad 动态链接聚合)
{
第五种模式：mod=4，即：(802.3ad) IEEE 802.3ad Dynamic link aggregation（IEEE 802.3ad 动态链接聚合）

特点：创建一个聚合组，它们共享同样的速率和双工设定。根据802.3ad规范将多个slave工作在同一个激活的聚合体下。
外出流量的slave选举是基于传输hash策略，该策略可以通过xmit_hash_policy选项从缺省的XOR策略改变到其他策略。
需要注意的是，并不是所有的传输策略都是802.3ad适应的，尤其考虑到在802.3ad标准43.2.4章节提及的包乱序问题。
不同的实现可能会有不同的适应性。

必要条件：
条件1：ethtool支持获取每个slave的速率和双工设定
条件2：switch(交换机)支持IEEE 802.3ad Dynamic link aggregation
条件3：大多数switch(交换机)需要经过特定配置才能支持802.3ad模式
}
bond(mode=5 适配器传输负载均衡)
{
第六种模式：mod=5，即：(balance-tlb) Adaptive transmit load balancing（适配器传输负载均衡）

特点：不需要任何特别的switch(交换机)支持的通道bonding。在每个slave上根据当前的负载（根据速度计算）分配外出流量。
如果正在接受数据的slave出故障了，另一个slave接管失败的slave的MAC地址。

该模式的必要条件：ethtool支持获取每个slave的速率.
}
bond(mode=6 适配器适应性负载均衡)
{
第七种模式：mod=6，即：(balance-alb) Adaptive load balancing（适配器适应性负载均衡）

特点：该模式包含了balance-tlb模式，同时加上针对IPV4流量的接收负载均衡(receive load balance, rlb)，而且不需要任何
switch(交换机)的支持。接收负载均衡是通过ARP协商实现的。bonding驱动截获本机发送的ARP应答，并把源硬件地址改写为bond
中某个slave的唯一硬件地址，从而使得不同的对端使用不同的硬件地址进行通信。

来自服务器端的接收流量也会被均衡。当本机发送ARP请求时，bonding驱动把对端的IP信息从ARP包中复制并保存下来。当ARP应答
从对端到达 时，bonding驱动把它的硬件地址提取出来，并发起一个ARP应答给bond中的某个slave。使用ARP协商进行负载均衡的
一个问题是：每次广播 ARP请求时都会使用bond的硬件地址，因此对端学习到这个硬件地址后，接收流量将会全部流向当前的slave。
这个问题可以通过给所有的对端发送更新 （ARP应答）来解决，应答中包含他们独一无二的硬件地址，从而导致流量重新分布。
当新的slave加入到bond中时，或者某个未激活的slave重新 激活时，接收流量也要重新分布。接收的负载被顺序地分布
（round robin）在bond中最高速的slave上

当某个链路被重新接上，或者一个新的slave加入到bond中，接收流量在所有当前激活的slave中全部重新分配，通过使用指定的
MAC地址给每个 client发起ARP应答。下面介绍的updelay参数必须被设置为某个大于等于switch(交换机)转发延时的值，从而保证
发往对端的ARP应答 不会被switch(交换机)阻截。

必要条件：
条件1：ethtool支持获取每个slave的速率；
条件2：底层驱动支持设置某个设备的硬件地址，从而使得总是有个slave(curr_active_slave)使用bond的硬件地址，同时保证每个 bond 中的slave都有一个唯一的硬件地址。如果curr_active_slave出故障，它的硬件地址将会被新选出来的 curr_active_slave接管
其实mod=6与mod=0的区别：mod=6，先把eth0流量占满，再占eth1，….ethX；而mod=0的话，会发现2个口的流量都很稳定，基本一样的带宽。而mod=6，会发现第一个口流量很高，第2个口只占了小部分流量
}




