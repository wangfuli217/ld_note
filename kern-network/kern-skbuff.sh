内核的套接字缓冲区被组织在一个双向链表中，并通过struct sk_buff_head类型来管理。
sk_buff_head()
{
 struct sk_buff *next;   后项指针
 struct sk_buff *prev;   前向指针
 __32           qlen;    链表长度
 spinlock_t     lock;    访问锁
 
}

sk_buff是套接字缓冲区类型，被用来管理网络数据包。该类型不仅为发送和接收网络数据提供存储区域，
而且为使用这些数据提供了操作方法。
sk_buff()
{
 struct sk_buff *next;   后项指针
 struct sk_buff *prev;   前向指针
 struct sk_buff_head *list; 指向管理套接字缓冲区链表的结构体
 
 SKB的宿主传输控制块；SKB的宿主传输控制块在网络数据报文由本地发出或由本地接收时才有效，
 使传输控制块与套接口及用户应用程序相关。当一个SKB仅在二层或三层被转发时，即源IPIP地址
 和目的IP地址都不是本机地址时，指针值为NULL。
 struct sock    *sk;    套接字缓冲区所属的套接字结构
 
 时间戳，表示这个skb的接收到的时间，一般是在包从驱动中往二层发送的接口函数中设置
 struct timeval stamp;   包到达的时间
 
 指定了处理分组的网络设备，dev在处理分组的过程中可能会被改变。网络设备指针。该字段的作用与该SKB
 是发送包还是接受包有关。在初始化网络设备驱动，分配接收缓存队列时，将该指针指向到数据包的网络设备。
 例如，在e100系列的以太网驱动中，初始化时会建立sk_buff缓存队列，调用__netdev_alloc_skb()分配缓存，如果分配成功
 则设置dev。
 发送数据包时，该指针指向输出数据包的网络设备，发送时设置该字段要比接收时的设置复杂得多。Linux支持多种形式的虚拟网络设备，并由
 一个虚拟网络设备驱动管理。当这个虚拟网络设备被使用时，dev指针指向该虚拟设备的net_device结构。在输出时，虚拟设备驱动
 会在一组设备中选择其中的某个合适的设备，并将dev指针修改为指向这个设备的net_device结构。
 而在输入时，当原始网络设备接收到报文后，根据某种算法选择某个合适的虚拟网络设备，并将dev指针修改为指向这个虚拟设备的net_device
 结构。因此，在某些情况下，指向传输设备的指针会在包处理过程中该变。
 struct net_device  *dev; 与数据包有关的设备；[指针会在包处理过程中该变。]
 
 收到包时，设备驱动会令dev指针指向接收设备；发送包时，指向发送设备。
 struct net_device *input_dev; 接收数据包的设备；如果是本地包，这个值为NULL
 
 
    sk_buff_data_t        transport_header;  
    指向第四层数据包的头部
    sk_buff_data_t        network_header;    指向第三层数据包的头部
    sk_buff_data_t        mac_header;        指向第二层数据包的头部
    
携带了与数据包发送和接收有关的信息。其中的neighbour和hh记录了邻居子系统信息，关系到数据包如何进入底层发送设备；
input和output定义数据包在网络层的接收和发送方式，比如，output指向ip_output函数标明数据包将通过该函数进入IP发送流程。
    
    struct dst_entry *dst;                   指向处理套接字缓冲区的路由缓存信息
    struct sec_path *sp;                     IPSec协议的传送跟踪信息
    
    SKB信息控制块，是每层协议的私有信息存储空间，由每一层协议自己维护并使用，并只在本层有效。
    在分配SKB时固定在SKB描述符中，其当前的大小是48B，已经足够为每一层协议存储必要的私有信息了。在每个协议中，访问该字段
    通常用宏实现以增强代码的可读性。例如，TCP用这个成员存储数据，操作时由tcp_skb_cb结构来映射，使用TCP_SKB_CB宏来访问。
    char            cb[40];                 控制信息字段，配合不同协议层的处理。
#define TCP_SKB_CB(__skb)   ((struct tcp_skb_cb*)&(__skb)->cb[0])    
    
    SKB中数据部分长度，包括线性缓冲区中数据长度(由data指向)，SG类型的聚合分散I/O的数据以及FRAGLIST类型的聚合分散I/O的数据长度。该
    字段值随着SKB从一个协议层向另一个协议层的传递而改变，向上传递时，下层首部就不再需要了，而向下传递时，需要添加本层首部.
    因此，len也包含了协议首部的长度
    
    它包括主缓冲中（即是sk_buff结构中指针data指向）的数据区的实际长度（data-tail）和分片中的数据长度。这个长度在
    数据包在各层间传输时会改变，因为分片数据长度不变，从L2到L4时，则len要减去帧头大小和网络头大小；从L4到L2则相反，
    要加上帧头和网络头大小。所以：len = (data - tail) + data_len；
    unsigned int    len,               数据长度(包括包头)
                    data_len,          数据长度(不包括包头)[ SG类型和FRAGLIST类型聚合分散I/O存储区中的数据长度]
                    mac_len,           MAC帧头部长度
    csum在校验状态为CHECKSUM_NONE时，用于存放所负载数据报的数据部分的校验和，为计算完成的传输层校验和做准备
                    csum;
    
    unsigned char  local_df,          表示此SKB在本地允许分片
    若fclone = SKB_FCLONE_UNAVAILABLE，则表明SKB未被克隆；
    若fclone = SKB_FCLONE_ORIG，则表明是从skbuff_fclone_cache缓存池（这个缓存池上分配内存时，每次都分配一对skb内存）中分配的父skb，可以被克隆；
    若fclone = SKB_FCLONE_CLONE，则表明是在skbuff_fclone_cache分配的子SKB，从父SKB克隆得到的；
                   cloned,            标记是否已克隆
                   
帧类型，分类是由二层目的地址来决定。对于以太网设备来说，该                             
字段由eth_type_trans初始化。                                                           
PACKET_HOST:      数据包的MAC目的地址与接收到它的网路设备的MAC地址                      [发给本地主机的数据包]                         
                  相等，也就是说这个报文是发给接收该数据包的主机的                            
PACKET_BROADCAST: 数据包的MAC目的地址是一个广播地址，而这个                             [广播的数据帧] 
                  广播地址也是接收这个包的网络设备的广播地址                            
PACKET_MULTICAST: 数据包的MAC目的地址是一个组播地址，而这个                             [多播的数据帧] 
                  组播地址也是接收到这个包的网络设备所注册                              
                  的组播地址。                                                          
PACKET_OTHERHOST: 数据包的MAC目的地址与接收到它的网路设备的地址                         [发给其他主机的数据帧] 
                  完全不同(不管是单播、组播还是广播)，因此，如果                        
                  本机没有启用转发功能，则丢弃这个包                                    
PACKET_OUTGOING:  这个数据包将被发出。用到这个标记的功能包括Decnet协议，                [将被发送出去的数据帧] 
                  或者是为每个网络tap都复制份发出包的函数                               
PACKET_LOOPBACK:  这个数据包发向loopback设备。由于有这个标记，在处理loopback            [发给loopback设备的数据帧] 
                  设备时，内核可以跳过一些真实设备才需要的操作                          
PACKET_FASTROUTE: 这个数据包由快速路由代码查找路由。快速路由功能在2.6内核中已经去掉     [采用快速路由的数据帧] 
                   pkt_type,
标记传输层校验和的状态，可能的值如下:                    
CHECKSUM_NONE: 表示硬件不支持，完全由软件来执行校验和    
CHECKSUM_UNNECESSARY: 表示没有必要执行校验和             
CHECKSUM_PARTIAL: 表示由硬件来执行校验和                 
CHECKSUM_COMPLETE: 表示已经完成执行校验和                                   
                   ip_summed;
                   
发送或转发数据包QOS类别。如果包是本地生成的，套接字层会设置该字段；
如果包是转发的，则rt_tos2priority会根据IP首部中TOS域来计算该字段值
 __u32 priority;   数据包处理的优先级
 
从二层设备角度看到的上层协议，即链路层承载的三层协议类型。
完整的列表在include/linux/if_ether.h中。ETH_P_IP:IPv4报文；ETH_P_ARP:地址解析协议报文
 unsigned short protocol; 协议字段
 unsigned short security; 数据包安全级别
 
SKB释放函数指针，在释放SKB时被调用，完成某些必要的工作。
如果SKB没有宿主传输控制块，则该函数指针通常为空，这种情况
主要发生在被转发时；否则通常分别在skb_set_owner_r和skb_set_owner_w 
中被初始化成sock_rfree或sock_wfree。
 void           (*destructor)(struct sk_buff *skb);

 
 CONFIG_NF_CONNTRACK(CONFIG_NETFILTER) 网络过滤器设置信息
 CONFIG_NETFILTER_DEBUG                网络过滤器调试信息
 CONFIG_BRIDGE_NETFILTER               网络过滤桥接信息
 CONFIG_NET_SCHED                      流量控制信息
 整个数据缓冲区的总长度，包括SKB描述符和数据缓存区部分(包括 线性存储区和聚合分散I/O缓冲区)。如果申请一个len字节的缓冲区，
 alloc_skb会将truesize初始化成len+sizeof(sk_buff)。
 
 这是缓冲区的总长度，包括sk_buff结构和数据部分。如果申请一个len字节的缓冲区，alloc_skb函数会把它初始化成len+sizeof(sk_buff)。
 当skb->len变化时，这个变量也会变化。
 所以：truesize = len + sizeof(sk_buff) = (data - tail) + data_len + sizeof(sk_buff)；
 unsigned int truesize;                套接字缓冲区尺寸
 
 其作用就是在销毁skb结构体时，先查看下users是否为零，若不为零，则调用函数递减下引用计数users即可；当某一次销毁时，
 users为零才真正释放内存空间。有两个操作函数：atomic_inc()引用计数增加1；atomic_dec()引用计数减去1；
 atomic_t users;                       用户计数
 unsigned char *head, *data, *tail, *end;

 }

buffer(head, *data, *tail, *end)
{
head和end指向缓冲区的起始和结束位置，而data和tail指向实际数据内容的起始和结束位置；
headroom 表示数据存储区内head与data之间的区域
tailroom 表示数据存储区内tail与end 之间的区域


}

function(管理sk_buff函数)
{
struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask, int fclone, int node)
第一个参数 unsigned int size，数据区的大小；
第二个参数 gfp_t gfp_mask，这里的gfp_t gfp_mask应该是内核动态分配方式的一个掩码（就是各种申请方式的集合）；
第三个参数 int fclone，表示在哪块分配器上分配；
第四个参数 int node，用来表示用哪种区域去分配空间。

    skbuff_fclone_cache和skbuff_head_cache两个块内存缓存池是不一样的。我们一般是在skbuff_head_cache这块缓存池中来
申请内存的，但是如果你开始就知道这个skb将很有可能被克隆（至于克隆和复制将在下一篇bolg讲），那么你最好还是选择在
skbuff_fclone_cache缓存池中申请。因为在这块缓存池中申请的话，将会返回2个skb的内存空间，第二个skb则是用来作为克隆
时使用。（其实从函数名字就应该知道是为克隆准备的，fclone嘛）虽然是分配了两个sk_buff结构内存，但是数据区却是只有
一个的，所以是两个sk_buff结构中的指针都是指向这一个数据区的。也正因为如此，所以分配sk_buff结构时也顺便分配了个
引用计数器，就是来表示有多少个sk_buff结构在指向数据区（引用同一个数据区），这是为了防止还有sk_buff结构在指向数据区时，
而销毁掉这个数据区。有了这个引用计数，一般在销毁时，先查看这个引用计数是否为0，如果不是为0，就让引用计数将去1；
如果是0，才真正销毁掉这个数据区。

alloc_skb: 分配套接字缓冲区，创建一个新的struct sk_buff结构并完成初始化；
alloc_skb_fclone: 分配克隆sk_buff结构的，因为这个分配函数会分配一个子skb用来后期克隆使用，所以如果能预见要克隆skb_buff结构，则使用这种方法会方便些。
dev_alloc_skb()：用GFP_ATOMIC的内存分配方式来申请的（一般我们用GFP_KERNEL），这是个原子操作，表示申请时不能被中断。
kfree_skb: 释放套接字缓冲区。

skb_clone()
struct sk_buff *pskb_copy(struct sk_buff *skb, gfp_t gfp_mask)

pskb_copy()函数申请内存时，其实是可以选择：alloc_skb_fclone()函数来申请的，可以让自己孩子成为某二代嘛
（因为skb_clone()函数这个二代用的空间就是从alloc_skb_fclone()函数申请时返回的子skb），当然了，这个得
自己去封装了。内核选择的还是低调做法，用alloc_skb()函数去申请，自给自足，不让自己孩子成为某二代。

skb_clone()函数克隆出来的skb结构不能修改其共享数据区的数据，而pskb_copy()函数也是一样的，克隆出来的skb
及数据区不能修改共享的分片结构数据区内容。所以如果想要修改分片结构数据区的内容，则必须要用skb_copy()
函数来克隆skb结构体。skb_copy()函数是对skb结构体真正的完全复制拷贝。不仅是sk_buff结构体还有data指针
指向的数据区（包括分片结构）以及分片结构中指针指向的数据区，都各自复制拷贝一份。

skb_clone()函数仅仅是克隆个sk_buff结构体，其他数据都是共享；
pskb_copy()函数克隆复制了sk_buff和其数据区(包括分片结构体)，其他数据共享；
skb_copy()函数则是完全的复制拷贝函数了，把sk_buff结构体和其数据区（包括分片结构体）、分片结构的数据区都复制拷贝了一份。

以data和tail之间数据为对象进行管理：
skb_put:   在数据区末端添加某协议的尾部。
skb_push： 在数据区前端添加某协议的头部。
skb_pull:  去掉数据包的协议头部。
skb_trim:  去掉数据包的协议尾部
skb_reseve:在数据区创建协议头部的空间。也可以用于调整数据区大小，保持长度一致。

pskb_may_pull   检测SKB中的数据是否有指定的长度

skb_headroom    返回数据起始处空闲空间的长度
skb_tailroom    返回数据末端空闲空间的长度

struct sk_buff *skb_clone(struct sk_buff *skb, int gfp_mask)
从控制结构skb中 clone出一个新的控制结构，它们都指向同一个网络报文。clone成功之后，将新的控制结构和原来的控制结构的 is_clone，cloned两个标记都置位。同时还增加网络报文的引用计数（这个引用计数存放在存储空间的结束地址的内存中，由函数atomic_t *skb_datarefp(struct sk_buff *skb)访问，引用计数记录了这个存储空间有多少个控制结构）。由于存在多个控制结构指向同一个存储空间的情况，所以在修改存储空间里面的内容时，先要确定这个存储空间的引用计数为1，或者用下面的拷贝函数复制一个新的存储空间，然后才可以修改它里面的内容。

struct sk_buff *skb_copy(struct sk_buff *skb, int gfp_mask)
复制控制结构skb和它所指的存储空间的内容。复制成功之后，新的控制结构和存储空间与原来的控制结构和存储空间相对独立。所以新的控制结构里的is_clone，cloned两个标记都是0，而且新的存储空间的引用计数是1。

int skb_cloned(struct sk_buff *skb)
判断skb是否是一个 clone的控制结构。如果是clone的，它的cloned标记是1，而且它指向的存储空间的引用计数大于1。

队列：初始化，头尾添加、头尾删除。中间插入。
skb_queue_head_init:用来初始化sk_buff_head结构。必须在链表操作之前调用该函数
skb_queue_head:在套接字缓冲区链表头添加一个缓冲区。
skb_queue_tail:在套接字缓冲区链表的尾部添加一个缓冲区。
skb_dequeue: 把排在头部的缓冲区从套接字缓冲区链表中移走。
skb_dequeue_tail: 从套接字缓冲区链表尾部移走一个缓冲区。
skb_queue_purge:清空套接字缓冲区链表。
skb_appemd 在指定套接字缓冲区上附加一个缓冲区。
skb_insert 向套接字缓冲区链表插入一个缓冲区。
skb_unlink 将skb从它所在的链表上取下。

#define skb_queue_walk(queue, skb) \
		for (skb = (queue)->next;					\
		     prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
		     skb = skb->next)
// 上面的遍历是从queue头结点开始遍历，直到遍历循环回到queue结束。
// 也就是遍历整个队列操作，但该宏不能做删除skb操作,一旦删除了skb后，skb->next就是非法的(因为此时skb不存在)。

#define skb_queue_walk_safe(queue, skb, tmp)					\
		for (skb = (queue)->next, tmp = skb->next;			\
		     skb != (struct sk_buff *)(queue);				\
		     skb = tmp, tmp = skb->next)
// 这个宏也是从queue头结点开始遍历整个队列操作，唯一不同的是这个宏用了一个临时变量，就是防止遍历时要删除掉skb变量，
// 因为删除掉了skb后，也可以从skb=tmp中再次获得，然后依次tmp = skb->next;(此时skb是存在的)所以遍历时，可以做删除操作。

#define skb_queue_walk_from(queue, skb)						\
		for (; prefetch(skb->next), (skb != (struct sk_buff *)(queue));	\
		     skb = skb->next)
// 这个宏是从skb元素处开始遍历直到遇到头结点queue结束，该宏只能做查看操作，不能做删除skb操作，分析如第一个宏

#define skb_queue_walk_from_safe(queue, skb, tmp)				\
		for (tmp = skb->next;						\
		     skb != (struct sk_buff *)(queue);				\
		     skb = tmp, tmp = skb->next)
// 这个宏也是从skb元素开始遍历直到遇到queue元素结束，但该宏可以做删除skb元素操作，具体分析如第一个宏

#define skb_queue_reverse_walk(queue, skb) \
		for (skb = (queue)->prev;					\
		     prefetch(skb->prev), (skb != (struct sk_buff *)(queue));	\
		     skb = skb->prev)
// 这是个逆反遍历宏，就是从queue头结点的尾部开始（或者说从前驱元素开始）直到遇到queue元素节点。
// 也即是从头结点尾部开始遍历了整个队列，此宏和第一、第三个宏一样，不能做删除操作。

}

tcp_skb_cb(TCP层私有数据)
{
    TCP层在SKB区中的私有信息控制块，即skb_buff结构的cb成员，TCP利用这个字段存储了一个tcp_skb_cb结构。
在TCP层，用宏TCP_SKB_CB实现访问该信息控制块，已增强代码的可读性。对这个私有信息控制块的赋值一般在
本层接收到段或发送段之前进行.

    seq为当前段开始序号，而end_seq为当前段开始序号加上当前段数据长度，如果标志域中存在SYN或FIN标志，则还需要加1，
因为SYN和FIN标志都会消耗一个序号。利用end_seq、seq和标志，很容易得到数据长度。
__u32        seq;        /* Starting sequence number    */      
__u32        end_seq;    /* SEQ + FIN + SYN + datalen    */  
                            
段发送时间及段发送时记录的当前jiffies值。必要时，此值也用来计算RTT。                                                        
该值通常在向外发送SKB时使用tcp_time_stamp设置，例如tcp_write_xmit()。
    __u32        when;        /* used to compute rtts    */
    记录原始TCP首部标志。发送过程中，tcp_transmit_skb()在发送TCP段之前会根据此标志来填充发送段的TCP首部的标志域；
接收过程中，会提取接收段的TCP首部标志到该字段中。
    __u8        flags;


}

udp_skb_cb(UDP层私有数据)
{
    inet_skb_parm
	__u16		cscov;
	__u8		partial_cov;
}

    分片结构体和sk_buff结构的数据区是一体的，所以在各种操作时都把他们两个结构看做是一个来操作。
比如：为sk_buff结构的数据区申请和释放空间时，分片结构也会跟着该数据区一起分配和释放。
而克隆时，sk_buff的数据区和分片结构都由分片结构中的 dataref 成员字段来标识是否被引用。
skb_shared_info(分片信息)
{
#define skb_shinfo(SKB) ((struct skb_shared_info *)((SKB)->end))

引用计数器。当一个数据缓冲区被多个SKB的描述符引用时，就会设置              
相应的计数。比如克隆一个SKB。这个计数器，指的是数据区的引用次数,在克隆的时候会加1.                  
atomic_t    dataref;

当前使用聚合分散I/O分片的数量, 即为frags数组中使用的数量，不超过MAX_SKB_FRAGS              
unsigned short  nr_frags;

生成GSO段时的MSS，因为GSO段的长度是与发送该段的套接字中合适MSS的整数倍。            
unsigned short  gso_size;

GSO段的长度是gso_size的倍数，即用gso_size来分隔大段时产生的段数。                                     
unsigned short  gso_segs;

frag_list有以下几种使用方法:                  
1)用于在接收分片组后链接多个分片，组成一个完整的IP数据包                     
2)在UDP数据包的输出中，将待分片的SKB链接到第一个SKB中，然后在输出过程中能够快速地分片。                         
3)用于存放FRAGLIST类型的聚合分散I/O的数据包，如果输出网络设备支持FRAGLIST类型的聚合分散I/O(目前只有回环设备支持)，则可以直接输出。
struct sk_buff  *frag_list;      //分片的套接字缓冲区列表
skb_frag_t  frags[MAX_SKB_FRAGS];


}

skb_frag_struct(分片管理:分片结构体的数据区)
{
    指向文件系统缓存页的指针:               指向分片数据区的指针，类似于sk_buff中的data指针
    struct page *page;    
    数据起始地址在文件系统缓存页中的偏移:   偏移量，表示从page指针指向的地方，偏移page_offset
    __u32 page_offset;
    数据在文件系统缓存页面中使用的长度:     数据区的长度，即：sk_buff结构中的data_len
    __u32 size;

}

IP的私有信息控制块
update:
IP层在SKB中有个信息控制块inet_skb_parm结构，存储
在skb_buff结构的cb成员中。IP层用宏IPCB访问该结构
以增强代码的可读性。这个私有的信息控制块主要存储
IP选项，以及在IP处理过程中需要设置的标志。在IP层，
无论是输入还是输出都需要处理IP选项。例如，在
输入时，ip_rcv_options()会解析IP首部中的选项保存
到inet_skb_parm结构的opt成员中；在输出时，ip_options_build()
会根据inet_skb_parm结构的opt将其组织后在IP首部中
生成选项，而在转发时，ip_forward_options()会根据选项
作适当的处理。相关标志会在处理过程中根据处理的状况
进行设置，例如IPSKB_FORWARDED标志会在组播数据包转发后
设置，而IPSKB_FRAG_COMPLETE标志则会在IP分片完成后
对每个分片进行设置。
inet_skb_parm()
{
	/*
	 * IP选项，接收IP数据包时解析IP
	 * 首部中的选项到该字段，而发送
	 * IP数据包时根据该字段在IP首部中
	 * 生成选项
	 */
	struct ip_options	opt;		/* Compiled IP options		*/
	/*
	 * 处理IP数据包时的一些标志,可取的值有IPSKB_FORWARDED等。
	 */
	unsigned char		flags;

/*
 * 组播包已经转发过
 */
#define IPSKB_FORWARDED		1
/*
 * IPSEC中，按安全路由链表的安全
 * 路由处理数据时会检测IP数据包
 * 的尺寸，并设置IPSKB_XFRM_TUNNEL_SIZE
 * 标志，以后不会再对其进行检测
 */
#define IPSKB_XFRM_TUNNEL_SIZE	2
/*
 * IPSEC中，按安全路由链表的安全
 * 路由处理数据后设置IPSKB_XFRM_TRANSFORMED
 * 标志，之后有该标志的数据包，在
 * NAT操作后将不会对存在该标志的数据包
 * 再进行特殊检查
 */
#define IPSKB_XFRM_TRANSFORMED	4
/*
 * 完成分片
 */
#define IPSKB_FRAG_COMPLETE	8
/*
 * IPSEC中，每执行一次IPSEC封装处理
 * 过程，封装结束后的数据包会设
 * 置IPSKB_REROUTED标志。标识IPSKB_REROUTED
 * 的数据包不能再进行转发
 */
#define IPSKB_REROUTED		16
}