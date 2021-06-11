网卡概述
(1) 网卡收包
网线上的物理帧首先被网卡芯片获取，网卡芯片会检查物理帧的CRC，保证完整性。
然后网卡芯片将物理帧头去掉，得到MAC包。
网卡芯片会检查MAC包内的目的MAC地址，如果和本网卡的MAC地址不一样则丢弃(混杂模式除外)。
之后网卡芯片将MAC帧拷贝到网卡内部的缓冲区，触发硬中断。
网卡的驱动程序通过硬中断处理函数，构建sk_buff，把它拷贝到内存中，接下来交给内核处理。
在这个过程中，网卡芯片对物理帧进行了MAC匹配过滤，以减小系统负荷。

 
(2) 网卡发包
网卡驱动程序将IP包添加14字节的MAC头，构成MAC包。
MAC包中含有发送端和接收端的MAC地址，由于是驱动程序创建MAC头，所以可以随便输入地址
进行主机伪装。
驱动程序将MAC包拷贝到网卡芯片内部的缓冲区，接下来由网卡芯片处理。
网卡芯片将MAC包再次封装为物理帧，添加头部同步信息和CRC校验，然后丢到网线上，就完成
一个IP报的发送了，所有接到网线上的网卡都可以看到该物理帧。


irq(牛)
{
软中断是一组静态定义的下半部接口，可以在所有处理器上同时执行，即使两个类型相同也可以。
但一个软中断不会抢占另一个软中断，唯一可以抢占软中断的是硬中断。

(1) 硬中断
由与系统相连的外设(比如网卡、硬盘)自动产生的。主要是用来通知操作系统系统外设状态的变化。比如当网卡收到数据包
的时候，就会发出一个中断。我们通常所说的中断指的是硬中断(hardirq)。

(2) 软中断
为了满足实时系统的要求，中断处理应该是越快越好。linux为了实现这个特点，当中断发生的时候，硬中断处理那些短时间
就可以完成的工作，而将那些处理事件比较长的工作，放到中断之后来完成，也就是软中断(softirq)来完成。

(3) 中断嵌套
Linux下硬中断是可以嵌套的，但是没有优先级的概念，也就是说任何一个新的中断都可以打断正在执行的中断，但同种中断
除外。软中断不能嵌套，但相同类型的软中断可以在不同CPU上并行执行。

(4) 软中断指令
int是软中断指令。
中断向量表是中断号和中断处理函数地址的对应表。
int n - 触发软中断n。相应的中断处理函数的地址为：中断向量表地址 + 4 * n。

(5)硬中断和软中断的区别
软中断是执行中断指令产生的，而硬中断是由外设引发的。
硬中断的中断号是由中断控制器提供的，软中断的中断号由指令直接指出，无需使用中断控制器。
硬中断是可屏蔽的，软中断不可屏蔽。
硬中断处理程序要确保它能快速地完成任务，这样程序执行时才不会等待较长时间，称为上半部。
软中断处理硬中断未完成的工作，是一种推后执行的机制，属于下半部。

开关
(1) 硬中断的开关
简单禁止和激活当前处理器上的本地中断：
local_irq_disable();
local_irq_enable();
保存本地中断系统状态下的禁止和激活：
unsigned long flags;
local_irq_save(flags);
local_irq_restore(flags);

对 local_irq_save的调用将把当前中断状态保存到flags中，然后禁用当前处理器上的中断发送。注意, flags 被直接传递, 而不是通过
指针来传递。 local_irq_disable不保存状态而关闭本地处理器上的中断发送; 只有我们知道中断并未在其他地方被禁用的情况下，才能
使用这个版本。

(2) 软中断的开关
禁止下半部，如softirq、tasklet和workqueue等：
local_bh_disable();
local_bh_enable();
需要注意的是，禁止下半部时仍然可以被硬中断抢占。

 
(3) 判断中断状态
#define in_interrupt() (irq_count()) // 是否处于中断状态(硬中断或软中断)
#define in_irq() (hardirq_count()) // 是否处于硬中断
#define in_softirq() (softirq_count()) // 是否处于软中断


(4) ksoftirqd内核线程
内核不会立即处理重新触发的软中断。
当大量软中断出现的时候，内核会唤醒一组内核线程来处理。
这些线程的优先级最低(nice值为19)，这能避免它们跟其它重要的任务抢夺资源。
但它们最终肯定会被执行，所以这个折中的方案能够保证在软中断很多时用户程序不会
因为得不到处理时间而处于饥饿状态，同时也保证过量的软中断最终会得到处理。
每个处理器都有一个这样的线程，名字为ksoftirqd/n，n为处理器的编号。
}


NAPI(牛)
{
NAPI是linux新的网卡数据处理API，据说是由于找不到更好的名字，所以就叫NAPI(New API)，在2.5之后引入。
简单来说，NAPI是综合中断方式与轮询方式的技术。
中断的好处是响应及时，如果数据量较小，则不会占用太多的CPU事件；缺点是数据量大时，会产生过多中断，
而每个中断都要消耗不少的CPU时间，从而导致效率反而不如轮询高。轮询方式与中断方式相反，它更适合处理
大量数据，因为每次轮询不需要消耗过多的CPU时间；缺点是即使只接收很少数据或不接收数据时，也要占用CPU
时间。

NAPI是两者的结合，数据量低时采用中断，数据量高时采用轮询。平时是中断方式，当有数据到达时，会触发中断
处理函数执行，中断处理函数关闭中断开始处理。如果此时有数据到达，则没必要再触发中断了，因为中断处理函
数中会轮询处理数据，直到没有新数据时才打开中断。
很明显，数据量很低与很高时，NAPI可以发挥中断与轮询方式的优点，性能较好。如果数据量不稳定，且说高不高
说低不低，则NAPI则会在两种方式切换上消耗不少时间，效率反而较低一些。


来看下NAPI和非NAPI的区别：
(1) 支持NAPI的网卡驱动必须提供轮询方法poll()。
(2) 非NAPI的内核接口为netif_rx()，NAPI的内核接口为napi_schedule()。
(3) 非NAPI使用共享的CPU队列softnet_data->input_pkt_queue，NAPI使用设备内存(或者设备驱动程序的接收环)。

 
}

above_half(上半部的流程)
{
上半部的实现

接收数据包的上半部处理流程为：
el_interrupt() // 网卡驱动
    |--> el_receive() // 网卡驱动
                |--> netif_rx() // 内核接口
                           |--> enqueue_to_backlog() // 内核接口
}
                           
enqueue_to_backlog()
{
netif_rx()调用enqueue_to_backlog()来处理。
首先获取当前cpu的softnet_data实例sd，然后：
1. 如果接收队列sd->input_pkt_queue不为空，说明已经有软中断在处理数据包了，
    则不需要再次触发软中断，直接将数据包添加到接收队列尾部即可。
2. 如果接收队列sd->input_pkt_queue为空，说明当前没有软中断在处理数据包，
    则把虚拟设备backlog添加到sd->poll_list中以便进行轮询，最后设置NET_RX_SOFTIRQ
    标志触发软中断。
3. 如果接收队列sd->input_pkt_queue满了，则直接丢弃数据包。
}

softnet_data(每个cpu都有一个softnet_data实例，用于收发数据包)
{
    struct Qdisc *output_queue; /* 输出包队列 */  
    struct Qdisc **output_queue_tailp;  
   
     /* 其中设备是处于轮询状态的，即入口队列有新的帧等待处理 */  
    struct list_head poll_list;  
  
    struct sk_buff *completion_queue; /* 成功传输的数据包队列 */  
      
    /* 处理队列，把input_pkt_queue接入 */  
    struct sk_buff_head process_queue;  
  
    /* stats */  
    unsigned int processed; /* 处理过的数据包个数 */  
    unsigned int time_squeeze; /* poll受限于允许的时间或数据包个数 */  
    unsigned int cpu_collision;  
    unsigned int received_rps;
    unsigned dropped; /* 因输入队列满而丢包的个数 */  
  
    /* 输入队列，保存接收到的数据包。 
     * 非NAPI使用，支持NAPI的网卡驱动有自己的私有队列。 
     */  
    struct sk_buff_head input_pkt_queue;  
    struct napi_struct backlog; /* 虚拟设备，非NAPI设备共用 */
}

belove_half(下半部的流程)
{
net_rx_action // 软中断
    |--> process_backlog() // 默认poll
               |--> __netif_receive_skb() // L2处理函数
                            |--> ip_rcv() // L3入口
}
                            
net_rx_action()
{
软中断(NET_RX_SOFTIRQ)的处理函数net_rx_action()主要做了：
遍历sd->poll_list，对于每个处于轮询状态的设备，调用它的poll()函数来处理数据包。
如果设备NAPI被禁止了，则把设备从sd->poll_list上删除，否则把设备移动到sd->poll_list的队尾。
每次软中断最多允许处理netdev_budget(300)个数据包，最长运行时间为2jiffies(2ms)。
每个设备一次最多允许处理weight_p(64)个数据包(非NAPI)。
如果在这次软中断中没处理玩，则再次设置NET_RX_SOFTIRQ标志触发软中断。

}    

process_backlog()
{
如果网卡驱动不支持NAPI，则默认的napi_struct->poll()函数为process_backlog()。
process_backlog()的主要工作：
1. 处理sd->process_queue中的数据包
    分别取出每个skb，从队列中删除。
    开本地中断，调用__netif_rx_skb()把skb从L2传递到L3，然后关本地中断。
    这说明在处理skb时，是允许网卡中断把数据包添加到接收队列(sd->input_pkt_queue)中的。
2. 如果处理完sd->process_queue中的数据包了，quota还没用完
     把接收队列添加到sd->process_queue处理队列的尾部后，初始化接收队列。
     接下来会继续处理sd->process_queue中的数据包。
3. 如果本次能处理完sd->process_queue和sd->input_pkt_queue中的所有数据包
    把napi_struct从sd->poll_list队列中删除掉，清除NAPI_STATE_SCHED标志。
}

__netif_receive_skb()
{
__netif_receive_skb()的主要工作为：
处理NETPOLL、网卡绑定、入口流量控制、桥接、VLAN。
遍历嗅探器(ETH_P_ALL)链表ptype_all。对于每个注册的sniffer，调用它的处理函数
packet_type->func()，例如tcpdump。
赋值skb->network_header，根据skb->protocol从三层协议哈希表ptype_base中找到对应的
三层协议。如果三层协议是ETH_P_IP，相应的packet_type为ip_packet_type， 协议处理函数为ip_rcv()。
}

ip_rcv()
{
ip_rcv()是IP层的入口，主要做了：
丢弃L2目的地址不是本机的数据包（这说明网卡处于混杂模式，嗅探器会处理这些包）。
检查skb的引用计数，如果大于1，说明其它地方也在使用此skb，则克隆一个skb返回；否则直接返回原来的skb。
数据包合法性检查：
    data room必须大于IP报头长度。
    IP报头长度至少是20，类型为IPv4。
    data room至少能容纳IP报头(包括IP选项)。
    检查IP报头校验和是否正确。
    数据包没被截断(skb->len >= 报总长)，报总长不小于20。
如果L2有进行填充（以太网帧最小长度为64），则把IP包裁剪成原大小，去除填充。此时如果接收的NIC
已计算出校验和，则让其失效，让L4自己重新计算。
最后，调用netfilter的NF_INET_PRE_ROUTING的钩子函数，如果此数据包被钩子函数放行，则调用
ip_rcv_finish()继续处理。
}

ip_rcv_finish()
{
ip_rcv_finish()主要做了：
查找路由，决定要把数据包发送到哪，赋值skb_dst()->input()，发往本地为ip_local_deliver，转发为ip_forward()。
更新Traffic Control (Qos)层的统计数据。
处理IP选项，检查选项是否正确，然后将选项存储在IPCB(skb)->opt中。
最后执行skb_dst()->input()，要么发往四层，要么进行转发，取决于IP的目的地址。
}

ip_local_deliver()
{
在ip_local_deliver()中，如果发现数据报有被分片，则进行组装。
然后调用NF_INET_LOCAL_IN处的钩子函数，如果数据包被钩子函数放行，
则调用ip_local_deliver_finish()继续处理。
}

ip_local_deliver_finish()
{
处理RAW IP，如果有配置安全策略，则进行IPsec安全检查。
根据IP报头的protocol字段，找到对应的L4协议(net_protocol)，调用该协议的接收函数net_protocol->handler()。
对于TCP协议，net_protocol实例为tcp_protocol，协议处理函数为tcp_v4_rcv()。
接下来就进入四层协议的处理流程了，TCP协议的入口函数为tcp_v4_rcv()。
}

dma_alloc_coherent(获取物理页，并将该物理页的总线地址保存于dma_handle，返回该物理页的虚拟地址)    
{
在项目驱动过程中会经常用到dma传输数据，而dma需要的内存有自己的特点，一般认为需要物理地址连续，并且内存是不可cache的，
在linux内核中提供一个供dma所需内存的申请函数dma_alloc_coherent. 如下所述：
dma_alloc_coherent()

dma_alloc_coherent() -- 获取物理页，并将该物理页的总线地址保存于dma_handle，返回该物理页的虚拟地址
    DMA映射建立了一个新的结构类型---------dma_addr_t来表示总线地址。dma_addr_t类型的变量对驱动程序是不透明的；
唯一允许的操作是将它们传递给DMA支持例程以及设备本身。作为一个总线地址，如果CPU直接使用了dma_addr_t，将会
导致发生不可预期的后果！

    一致性DMA映射存在与驱动程序的生命周期中，它的缓冲区必须可同时被CPU和外围设备访问！因此一致性映射必须保存
在一致性缓存中。建立和使用一致性映射的开销是很大的！
}   