net_device(用来管理网络设备的数据结构)
{
net_device结构是网络驱动及接口层中最总要的结构，其中不但描述了接口方面的信息，还包括硬件信息，致使该结构很大很复杂。
将接口和驱动完全整合在一起也许是设计上的一个失误，因此可以看到这样的一行注释"Actually, this whole structure is a big mistake"。  
net_device结构的成员大致可以分为以下几类:                              
1)硬件信息成员变量:与网络设备相关的底层硬件信息，如果是虚拟网络设备驱动，则这部分信息无效。                          
2)接口信息成员变量:这些信息主要是为其他硬件类型的setup()而设置的，对以太网来说是ether_setup()，以太网络设备利用该函数设置大部分成员。                                    
3)设备操作接口变量:设备的接口主要提供操作数据或控制设备的一些功能，如发送数据包的接口、激活和                      
   关闭设备的接口等。在这些接口中，有些是必须的，而有些是可选的，这与设备提供的特性有关。                            
4)辅助成员变量。                                                       


1. 通用字段
网络设备名。如果在注册设备时，驱动程序名中含有%d格式化字符串，则使用一个从0开始分配的编号替换它，使之成为系统中唯一的名称。     
name字段；

用来管理设备的链表。连接多个struct net_device结构。系统中要安装多个网络设备时，需要把这些设备组织成链表，由全局变量
dev_base统一管理。
next字段：

指向由本网络设备创建的模块。
owner字段：

网络设备的索引值，也可用来标识网络设备。创建新设备后，dev_get_index为该设备分配一个索引值，以便快速定位网络设备
ifindex字段：

网络设备的状态信息
state字段：

时间字段： trans_start 最近的发包时间
           last_rx     最近的收包时间
           watchdog_timero 配合发送数据的定时器
           watchdog_tmer 定时器列表
           
priv字段：指向与网络设备特性有关的私有数据结构

设备队列规则字段： qdisc指向 struct Qdisc类型的结构体，描述了网络设备的排队规则， 
                   qdisc_ingress输入队列规则
                   qdisc_list队列规则链表

refcnt字段：代表网络设备的引用次数。

同步锁字段： ingress_lock 输入保护锁
             xmit_lock 函数指针 hard_start_xmit的同步锁
             xmit_lock_owner 拥有发送所xmit_lock的处理器编号
             queue_lock 队列保护锁             
2. 硬件配置字段
内存共享字段：地址mem_start和mem_end指定了发送包所在区域，
              地址rmem_start和rmem_end指定了接收包的区域。
base_addr: 驱动程序用来搜索设备IO基地址
irq：设备使用的中断号
dms：分配给设备的DMA通道号
if_port:多端口设备使用的不同端口，由网络介子类型确定，比如以太网设备需要区分BNC、双绞线、AUI端口。

              

3. 物理层数据字段
hard_header_length:表示第2层协议头部长度。比如以太网卡的hard_header_length字段取值为14.
mtu字段：最大传输单元，以太网1500字节。当网络层协议模块通过底层设备发送数据包时，必须根据该值进行合理分片，
         以避免发出过长的数据包。
tx_queue_len: 网络设备输出队列的最大长度。
type：接口的硬件类型。ARP模块处理中，用type来判断接口的硬件地址类型。对以太网接口该字段值应为ARPHRD_ETHER。                             
地址字段：broadcast广播地址；dev_addr 硬件地址 addr_len硬件地址长度；dev_mc_list 多播地址，mc_count是devx_mc_list中地址数目。
   

4. 网络层数据字段
atalk_ptr：AppleTalk相关指针，AppleTalk为可路由协议组
ip_ptr：IPV4相关数据,存储的类型为in_device结构
dn_ptr：DECnet相关数据，DECnet 是由数字设备公司(Digital Equipment Corporation) 推出并支持的一组协议集合                                               
ip6_ptr：IPV6相关数据
ec_ptr：Econet相关数据
ax25_ptr：AX.25协议信息
family：网络设备采用的协议地址族；
pa_alen:协议地址长度。 pa_adr表示网络设备地址；pa_baddr 广播地址 pa_mask网络掩码 pa_dstaddr 点对点连接
对于TCP-IP协议族：family值取AF_INET，而pa_alen字段是4字段。
flag字段：
IFF_UP：标识接口已激活并可以开始传输数据包。
IFF_BROADCAST：标识该接口允许广播。 
IFF_DEBUG:标识调试模式。该标志可用来控制用于调试目的的大量printk调用。用户程序可通过ioctl设置或清除该标志。                            
IFF_LOOPBACK:该标志只能对回环设备进行设置。内核检查IFF_LOOPBACK标志以判断接口是否为回环设备，而不是将lo作为特殊的接口名称进行判断。           

该标志表明接口连接到点对点链路。这个标志由驱动程序设置，有时也由ifconfig设置。例如PPP驱动程序将设置该标志。              
IFF_POINTOPOINT:接口为点对点连接
IFF_NOTRAILERS: 避免试验trailer
IFF_RUNNING:    资源已分配
IFF_NOARP：该标志表明接口不支持ARP。例如，点对点接口不需要运行ARP，因为如果运行了ARP，不但不恩能够获得有用的信息，而且增加了网络传输量。   
IFF_PROMISC：设置该标志将激活混杂模式。默认情况下，以太网接口使用一个硬件过滤器来确保它只接收广播数据包，以及直接
发送到接口硬件地址的数据包。像tcpdump这样的数据包侦听器会在接口上设置混杂模式，以使检索到通过传输介质的所有数据包。                                                           
IFF_ALLMULTI：该标志告诉接口接收所有的组播数据包。仅仅在IFF_MULTICAST被设置的情况下，内核在主机执行组播路由时设置
             该标志。IFF_ALLMULTI对接口来讲是只读的。   
IFF_MASTER：主负载均衡群(bundle)。
IFF_SLAVE：该标志由负载均衡代码使用，接口驱动程序无需了解该标志。 
IFF_MULTICAST：该标志由驱动程序设置，标识该接口能够进行组播发送。ether_setup 默认设置IFF_MULTICAST，因此如果驱动
               程序不支持组播，就必须在初始化时清除该标志。                                          
IFF_PORTSEL：可以通过ifmap选择介质类型。 
IFF_DYNAMIC：该标志由驱动程序设置，表示接口地址可改变。这标志没有被使用。接口关闭时丢弃地址。                                                                     

5. 设备驱动程序中的函数
int (*init)(struct netdevice *dev);设备初始化函数，当注册网络设备时被调用，用来初始化管理网络设备的struct net_devide结构体，
但是，该指针可以被设置为NULL。
int (*uninit)(struct netdevice *dev); 注销设备的函数，当删除网络设备时被调用
int (*destructor)(struct netdevice *dev); 清理设备信息的函数。当设备的最后一个引用计数被删除后，内核调用该函数。
int (*open)(struct netdevice *dev); 打开设备的函数，当设备的最后一个引用计数被删除后，内核调用该函数
int (*stop)(struct netdevice *dev); 停止设备的函数

int (*hard_start_xmit)(struct sk_buff *skb, struct netdevice *dev);驱动中发送数据包的函数，把参数skb所管理的数据发送出去
int (*hard_header)(struct sk_buff *skb, struct netdevice *dev， unsigned short type, void *daddr, void *saddr, unsigned len);
构建硬件头部的函数。根据参数中的源主机和目的主机硬件地址来建立设备硬件头部。

int (*rebuild_header)(struct sk_buff *skb) 重建硬件头部的函数。当ARP地址解析万地址后，为发送数据包重建硬件头部
void (*tx_timeout)(struct net_device *dev);处理发送超时的函数。当数据包没有在规定时间发送出去时，内核将通过
该函数处理发送问题，并恢复发送过程。
struct net_device_stat *(*get_stats)(struct net_device *dev)：设备统计信息
int (*set_config)(struct net_device *dev， struct ifmap *map)：指向配置接口信息的函数。在设备运行时，可调用该函数来修改设备IO
地址和中断号等配置信息
int (*poll)(struct net_device *dev, int quota) 查询函数。适合NAPI驱动的设备方法，调用该函数以查询方式接收数据
int (*do_ioctl)(struct net_device *dev, struct ifreq *ifr, int cmd)：ioctl函数，可以对设备IO端口进行操作
void (*set_multicast_list)(struct net_device *dev)：设置组播列表的函数，调用该函数可以改变设备的组播列表和标志
int (*set_mac_address)(struct net_device *dev, void *addr)设置硬件地址的函数。如果设备接口支持修改硬件地址，可调用该函数
int (*change_mtu)(struct net_device *dev, int net_mtu)修改接口MTU的函数。

}

1. 把网络设备驱动模块编译进内核，系统启动时自动注册该设备；
2. 把网络设备驱动程序编译乘客动态加载模块，加载设备时注册该设备。
function()
{
ndev = alloc_etherdev(sizeof(struct board_info));
        alloc_netdev_mq
        网络设备由net_device结构定义,每个net_device结构实例代表一个网络设备,该         
        结构的实例由alloc_netdev()分配空间,参数说明如下:                               
        @sizeof_priv:指定用于存储驱动程序参数的私有数据块大小,参见alloc_etherdrv()函数.
        @name:设备名,通常是个前缀,相同前缀的设备会进行统一编号,以确保设备名唯一.       
        @setup:配置函数,用于初始化net_device结构实例的部分域,参见ether_setup()函数.    

int register_netdev(struct net_device *dev)
当待注册的网络设备名确定之后，便调用register_netdevice()注册网络设备，并将      
网络设备描述符注册到系统中。完成注册后，会发送NETDEV_REGISTER消息到netdev_chain 
通知链中，使得所有对设备注册感兴趣的模块都能接收消息。                          

1. 如果网络设备名中有"%"符号，则分配一个接口号
2. 如果网络设备名字的长度为0或者网络设备名字的第一个字符是空格，则将网络设备名设置为"eth"，并为其分配一个接口号。

int register_netdevice(struct net_device *dev)
在调用该函数前必须调用rtnl_lock()来获取rtnl互斥锁    



alloc_etherdev    以太网
alloc_fddidev     光纤分布式接口FDDI
alloc_hippi_dev   高性能并行接口HPPI
alloc_trdev       令牌环网
alloc_fcdev       光纤通道
alloc_irdadev     红外数据接口

alloc_netdev和ether_setup位于文件 driver/net/eth.c include/linux/netdevice.h
register_netdev和unregister_netdev 位于文件 net/core/dev.c


}

dev_open()
{
int dev_open(struct net_device *dev)
    设备一旦注册后即可使用，但必须在用户或用户空间应用程序使能后才可以收发数据                
因为注册到系统中的网络设备，其初始状态是关闭的，此时是不能传输数据的，必须              
激活后，网络设备才能进行数据的传输。在应用层，可以通过ifconfig up命令(最终是通过ioctl       
的SIOCSIFFLAGS)来激活网络设备。而SIOCIFFLAGS命令是通过dev_change_flags()调用dev_open()来激活网络设备。
dev_open()将网络设备从关闭状态转到激活状态，并发送一个NETDEV_UP消息到网络设备状态改变             
通知链上。                                            


打开设备由以下几部组成：
(1)如果 dev->open 被定义则调用它。并非所有的驱动程序都初始化这个函数。
(2)设置 dev->state 的__LINK_STATE_START 标志位，标记设备打开并在运行。
(3)设置 dev->flags 的 IFF_UP 标志位标记设备启动。
(4)调用dev_activate所指函数初始化流量控制用的排队规则，并启动监视定时器。如
果用户没有配置流量控制，则指定缺省的先进先出(FIFO)队列。
(5)发送 NETDEV_UP 通知给 netdev_chain 通知链以通知对设备使能有兴趣的内核组件。
}

dev_close()
{
int dev_close(struct net_device *dev)
    网络设备一旦关闭后就不能传输数据了。网络设备能被用户命令明确地活被其他事件隐含地             
禁止。在应用层，可以通过ifconfig down命令(最终是通过ioctl()的SIOCSIFFLAGS)来关闭网络设备，或者     
在网络设备注销时被禁止。SIOCSIFFLAGS命令通过dev_change_flags()，根据网络设备 
当前的状态来确定调用dev_close()关闭网络设备。dev_close()将网络设备从激活状态转换到关闭状态，      
并发送NETDEV_GOING_DOWN和NETDEV_DOWN消息到网络设备状态改变通知链上。                               

它由以下几步组成：
(1)发送 NETDEV_GOING_DOWN 通知到 netdev_chain 通知链以通知对设备禁止有兴趣的内核组件。
(2)调用 dev_deactivate 函数禁止出口队列规则，这样确保设备不再用于传输，并停止
不再需要的监控定时器。
(3)清除 dev->state 标志的__LINK_STATE_START 标志位，标记设备卸载。
(4)如果轮询动作被调度在读设备入队列数据包，则等待此动作完成。这是由于__LINK_STATE_START 标志位被清除，不再接受其它轮询在设备上调度，但在标志被清除前已有一个轮询正被调度。
(5)如果 dev->stop 指针不空则调用它，并非所有的设备驱动都初始化此函数指针。
(6)清除 dev->flags 的 IFF_UP 标志位标识设备关闭。
(7)发送 NETDEV_DOWN 通知给 netdev_chain 通知链，通知对设备禁止感兴趣的内核组件。
}

3c39x(chip driver)
{
传输数据与接收数据
传输数据
网络子系统中，数据最后由链路层协议调用dev_queue_xmit()，位于net/core/dev.c，完成传输，而dev_queue_xmit又会调用具体网络适配器的驱动程序方法dev->hard_start_xmit()，从而驱动网络适配器最终完成数据传输，参见vortex_start_xmit()。

接收数据
当网络适配器接收一个数据帧时，就会触发一个中断，在中断处理程序（位于设备驱动）中，会分配sk_buff数据结构保存数据帧，最后会调用netif_rx()，将套接字缓冲区放入网络设备的输入队列。对于3c39x.c，其过程如下：
vortex_interrupt( )---> vortex_rx( )--->netif_rx( )。

}
notifier()
{
当启用一个网络设备时，必须将与该设备上所有IP地址相关          
的路由表项添加到ip_fib_local_table路由表中。这是通过对该设备  
上配置的每一个IP地址，都调用fib_add_ifaddr()来完成的。        
NETDEV_UP 设备已打开

当关闭网络设备时，调用fib_disable_ip()从路由表及路由缓存 
中删除所有该设备的路由项。                               
NETDEV_DOWN 设备已关闭
NETDEV_REBOOT 设备重启

当某个网络设备的配置发生变化时，比如MTU或PROMISCUITY状态，
会刷新路由缓存                                            
NETDEV_CHANGE   设备信息修改
NETDEV_REGISTER 设备已经注册

当一个网络设备注销时，从路由表及路由器缓存中删除     
所有使用该设备的路由项。对于多路径路由项来说，只要   
下一跳中有一个使用该设备，该路由项就将被删除。       
NETDEV_UNREGISTER 设备未注册

当某个网络设备的配置发生变化时，比如MTU或PROMISCUITY状态， 
会刷新路由缓存                                             
NETDEV_CHANGEMTU   修改MTU
NETDEV_CHANGEADDR  修改MAC地址
NETDEV_GOING_DOWN 设备正关闭
NETDEV_CHANGENAME  设备名改变


}