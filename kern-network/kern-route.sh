
Linux内核支持基于规则的路由，这里的规则包括选择器和动作两部分：选择器用于数据包的选择，包括源地址、目的地址\TOS等；
而动作为符合选择器条件的数据包定义了具体的处理方法。内核把规则的动作划分为UNICAST BLACKHOLE UNREACHABLE PROHIBIT NAT
5类。其中
UNICAST：表示从某路由表中查找路由项(对于自定义规则，这个路由表示自定义路由表)
BLACKHOLE 表示丢弃数据包
UNREACHABLE 表示报告目的地网络不可达
PROHIBIT 禁止访问
NAT 按地址转换协议处理
每一规则拥有自己的优先级、内核按优先级为数据包寻找匹配的规则。

另外内核创建了3条可以匹配所有数据包的规则：
local_rule本地规则
main_rule主规则
default_rule默认规则

ip rule add prio 1000 from 192.168.1/24 iif eth0 table 99
prio 1000定义优先级
from 192.168.1/24和iif eth0 定义了选择器
table 99 定义了动作


ip route add 192.168.1/24 dev eth0           #默认选择table main
ip route add 192.168.2/24 dev eth1           #默认选择table main
ip route add 192.168.3/24 via 192.168.2.2

内核创建3条可以匹配所有数据包的默认规则，其动作都是unicast，对应路由表标志为RT_TABLE_LOCAL
RT_TABLE_MAIN RT_TABLE_DEFAULT 

flowi()
{
利用flowi数据结构，就可以根据诸如输入网络设置和输出网络设子、三层和四层协议报头中的参数等字段的组合      
对流量进行分类。它通常被用作路由查找的搜索条件组合，IPsec策略的流量选择器以及其他高级用途。 

输出网络设备索引和输入网络设备索引。
    int    oif;   
    int    iif;   
    __u32    mark;
    
该联合对应三层，目前支持的协议为IPv4、IPv6和DECnet。这里应该说明一下RTO_ONLINK标志，该标志通过tos变量   
传递，但该变量与IP报头中的tos域无关。此处只使用tos  域的一个无用的比特位。当该位被设置时，表示目的      
地址位于本地子网，所以无须路由查找。                
nl_u

标识四层协议
    __u8    proto;
该变量只定义了一个标志，FLOWI_FLAG_MULTIPATHOLDROUTE，它最初用于多路径代码，但现在已废弃不再使用。              
__u8    flags;

该联合对应四层，目前支持的协议为TCP、UDP、ICMP、DECnet和IPsec 
uli_u;

}


ip_route_output_flow()
{
由本地生成的报文输出时都会调用ip_route_output_flow()或ip_route_output_key()              
进行路由查询。这两个函数的区别在于ip_route_output_flow()支持IPSec，而                    
ip_route_output_key()不支持IPSec，事实上ip_route_output_key()也是对ip_route_output_flow()
的简单封装，只是省略了相关IPSec的参数。参数说明如下:                                     
@rp:当查询成功时，返回查询得到的路由缓存项                                               
@flp:用于查询路由缓存项的条件组合                                                        
@sk，flags:支持IPSec策略处理。                                                           

}

__ip_route_output_key()
{
__ip_route_output_key()在路由缓存中根据查询条件搜索符合      
条件的缓存项。该函数通常被间接调用，由ip_route_output_flow() 
封装调用。参数说明如下:                                      
@rp:当函数返回成功时，*rp指向与搜索条件flp相匹配的缓存项     
@flp:用于搜索路由的条件组合                                  
@                                                            
}


fib_rule结构中定义的是各协议族都需要用到的策略属性，用于构成具体协议族策略的数据结构
fib_rule(路由规则)
{

用来将一个协议族的所有fib_rule结构链接成一个双向循环链表，其表头是一个全局的list_head结构
    struct list_head    list;
引用计数。该引用计数的递增是在fib_lookup()(策略路由版的函数)中进行的，
这解释了为什么在每次路由查找成功后总是需要调用fib_res_put(递减该引用计数)
    atomic_t        refcnt;
ifname是策略应用的输入网络设备名称。ifindex是ifname对应网络设备实例的索引，用于标识跟哪个网络设备相关联。
当ifindex值为-1时表示禁止该策略。
    int            ifindex;
    char            ifname[IFNAMSIZ];

mark是数字标签，mark_mask是mark的掩码，在根据flowi进行策略的比较查找时使用。
    u32            mark;
    u32            mark_mask;

路由策略的优先级。当利用ip_rule添加一个策略时，可以使用关键字priority、preference和order来配置。如果
没有明确配置，内核为其分配一个优先级，该值比用户添加的最后一个规则的优先级小于1，而优先级0x7FFE和0x7FFF
是预留给由内核用来匹配RT_TABLE_MAIN和RT_TABLE_DEFAHLT路由表的。

    u32            pref;
标志。当前只使用FIB_RULE_PERMANENT，表示该策略是固定的，不能删除。
    u32            flags;

路由表标识，范围从0到255.当用户没有指定路由表标识时，IPROUTE2按照以下方法来选择路由表:当用户
命令是添加一条规则时使用RT_TABLE_MAIN，其他情况使用RT_TABLE_UNSPEC(例如删除一条规则)。
    u32            table;

根据策略查找对应的路由项时，确定策略被访问的动作。可能的取值为FR_ACT_UNSPEC、FR_ACT_TO_TBL等。
    u8            action; RTN_UNICAST RTN_BLACKHOLE RTN_UNREACHABLE RTN_PROHIBIT RTN_NAT
                          RTN_UNICAST 字段r_table标识供查询的路由表，
    u32            target;
    struct fib_rule *    ctarget;
    struct rcu_head        rcu;
    struct net *        fr_net;
    
选择器    r_dst_len 目的地址长度
选择器    r_src_len 源地址长度
选择器    r_src     源地址
选择器    r_srcmask  源地址掩码
选择器    r_dst      目的地址
选择器    r_dstmask  目的地址掩码
选择器    r_srcmap   静态地址转换时的源地址
选择器    r_flag  标志
选择器    r_tos TOS字段内容
选择器    r_fwmark  规则转发
选择器    r_ifinedx 网络接口索引
    r_tcclassid 队列规则中的类标识符
    r_dead 无效规则可删除
};


对每个路由表实例创建一个fib_table结构，这个结构主要由一个路由表标识和管理该路由表的一组函数指针组成。

fib_table() {

用来将各个路由表链接成一个双向链表

    struct hlist_node tb_hlist;

路由表标识。在支持策略路由的情况下，系统最多可以由256个路由表，枚举类型rt_class_t中定义了保留的路由表ID，如
RT_TABLE_MAIN、RT_TABLE_LOCAL，除此之外从1到(RT_TABLE_DEFAULT-1)都是可以由用户定义的。

    u32        tb_id; 路由表标志号
    int        tb_default; 未用字段
    指向查询路由表的函数，一般指向fib_lookup
    int        (*tb_lookup)(struct fib_table *tb, const struct flowi *flp, struct fib_result *res);
    指向插入路由条目的函数
    int        (*tb_insert)(struct fib_table *, struct fib_config *);
    指向删除路由条目的函数
    int        (*tb_delete)(struct fib_table *, struct fib_config *);
    指向路由输出函数，在RT netlink上输出条目
    int        (*tb_dump)(struct fib_table *table, struct sk_buff *skb,
                     struct netlink_callback *cb);
    指向删除多个路由条目的函数
    int        (*tb_flush)(struct fib_table *table);
    指向选择默认路由条目的函数
    void        (*tb_select_default)(struct fib_table *table,
                         const struct flowi *flp, struct fib_result *res);
    具体的路由表项管理结构
    unsigned char    tb_data[0];
tb_data实际上是一个指向struct fn_hash结构的指针。类型 struct fn_hash用来管理每个路由表的内容。
它的实现是一个哈希表，该表的元素是struct fn_zone指针，指向地址前缀相同的路由表项。
基于规则的路由表多大255个。通过一个struct fib_table 数组来管理。
   
};

一个fn_zone管理着具有相同前缀的路由表项。对于32位IPv4地址，一个路由表包括33个这种结构体，并通过fs_hash来管理。
fn_zone管理的路由表项内容存放在fz_hash字段中，而fz_hash也是一个hash表。
fn_zone() {
    struct fn_zone        *fz_next;    指向下一个struct fn_zone结构体
    struct hlist_head    *fz_hash;    指向管理其路由表项的哈希表
    int            fz_nent;    表项数目

    int            fz_divisor;    管理路由表项的哈希表大小
    u32            fz_hashmask;哈希表的位掩码fz_divisor-1
#define FZ_HASHMASK(fz)        ((fz)->fz_hashmask)

    int            fz_order;   固定前缀长度
    __be32            fz_mask;网络掩码
#define FZ_MASK(fz)        ((fz)->fz_mask)
};

在路由表中，每一条路由表项通过一个fib_node结构体来管理。fn_key和fn_tos是路由表项的重要键值，
具体的路由表项由finb_info 结构体来管理。
fib_node() {
    struct hlist_node    fn_hash;
    struct list_head    fn_alias;
    __be32            fn_key; 路由表项键值，包括目的网络地址
    struct fib_alias        fn_embedded_alias;
};

包括下一条、引用计数等路由条目信息，其内容可以被其他路由表项共享，通过双向链表连接起来
fib_info(路由表项信息结构) {
    struct hlist_node    fib_hash;
    struct hlist_node    fib_lhash;
    struct net        *fib_net;
    int            fib_treeref; 路由表项书的引用
    atomic_t        fib_clntref; 引用计数增量
    int            fib_dead; 无效条目标志
    unsigned        fib_flags; 标志字段
    int            fib_protocol;协议
    __be32            fib_prefsrc;源地址信息
    u32            fib_priority;优先级
    u32            fib_metrics[RTAX_MAX];参数
#define fib_mtu fib_metrics[RTAX_MTU-1]
#define fib_window fib_metrics[RTAX_WINDOW-1]
#define fib_rtt fib_metrics[RTAX_RTT-1]
#define fib_advmss fib_metrics[RTAX_ADVMSS-1]
    int            fib_nhs;下一条标志
#ifdef CONFIG_IP_ROUTE_MULTIPATH
    int            fib_power;条目指数
#endif
    struct fib_nh        fib_nh[0];去往目的地的下一条信息
#define fib_dev        fib_nh[0].nh_dev
};

fib_nh(下一条) {
    struct net_device    *nh_dev; 设备
    struct hlist_node    nh_hash; 
    struct fib_info        *nh_parent;
    unsigned        nh_flags;   标志
    unsigned char        nh_scope;  范围
#ifdef CONFIG_IP_ROUTE_MULTIPATH
    int            nh_weight;路由的权重字段
    int            nh_power; 路由的指数字段
#endif
#ifdef CONFIG_NET_CLS_ROUTE
    __u32            nh_tclassid;分类标志
#endif
    int            nh_oif;去往下一条的出口
    __be32            nh_gw;下一条地址
};

rt_hash_bucket(路由表缓存类型) {
    struct rtable    *chain; 管理路由表项的链表
};


IPv4使用rtable结构来存储缓存内的路由表项。可以通过查看/proc/net/rt_table文件，或者通过ip route list cache和
route -C命令来列出路由缓存的内容。
rtable()
{
    union
    {
        struct dst_entry    dst;
    } u; 下一个路由缓存表项或dst_entry结构
    
用于缓存查找的搜索的条件组合。
    struct flowi        fl;


指向输出网络设备的IPv4协议族中的IP配置块。注意:对送往本地的输入报文的路由，输出网络设备的设置为回环设备。
    struct in_device    *idev;
    int            rt_genid;

用于标识路由表项的一些特性和标志。可选的值有RTCF_NOTIFY、RTCF_REDIRECTED等。

    unsigned        rt_flags;

路由表项的类型，它间接定义了当路由查找匹配时应采取的动作。可选的值为RTN_UNSPEC、RTN_LOCAL等。
    __u16            rt_type;


目的IP地址和源IP地址。
    __be32            rt_dst;    
    __be32            rt_src;    
输入网络设置标识，从输入网络设备的net_device数据结构中得到。对本地生成的流量(因此不是从
任何接口上接收到的)，该字段被设置为出设备的ifindex字段。对本地生成的报文，fl中的iif字段被设置为0。
    int            rt_iif;

当目的主机为直连时，即在同一链路上，rt_gateway表示目的地址。当需要通过一个网关到达目的地时，rt_gateway被设置为
路由项中的下一跳的网关。
    __be32            rt_gateway;


首选源地址。
添加到路由缓存内的路由缓存项是单向的。但是在一些情况下，接收到报文可能触发一个动作，要求
本地主机选择一个源IP地址，以便在向发送方回送报文时使用。这个地址，即首选源IP地址，必须与
路由该输入报文的路由缓存项保存在一起。首选源IP地址被保存在rt_spec_dst字段内，下面是使用该地址
的两种情况:
  1) 当一个主机接收到一个ICMP回显请求信息时(常用的
ping命令)，如果主机没有明确配置为不作出回应，则该
主机返回一个ICMP回显应答消息。对该输入ICMP回显请求
消息选择路由，路由项的rt_spec_dst被用作路由ICMP回显
请求信息而进行路由查找的源地址。参见icmp_reply()和
ip_send_reply()。
  2) 记录路由IP选项和时间戳IP选项要求途径主机的IP地址
记录到选项中。

    __be32            rt_spec_dst; 

指向与目的地址相关的对端信息块。

    struct inet_peer    *peer; 
};



dst_entry结构被用于存储缓存路由项中独立于协议的信息。三层协议在另外的结构中存储
本协议中更多的私有信息(例如，IPv4使用rtable结构)。

dst_entry()
{

互斥处理
    struct rcu_head        rcu_head;

与IPsec相关
    struct dst_entry    *child;

输出网络设备(即将报文送达目的地的发送设备)。
    struct net_device       *dev;

当fib_lookup()查找失败时，错误码值会被保存在这个字段中，在之后ip_error()中使用该值
来决定如何处理本次路由查找失败，即决定生成哪一类ICMP消息。
    short            error;

用于标识本dst_entry实例的可用状态，可选值:
0(默认值): 表示所在结构实例有效并且可以
                       被使用
2: 表示所在结构实例将被删除因而不能被使用
-1: 被IPsec和IPv6使用但不被IPv4使用
    short            obsolete;
标志集合，可选的值为DST_HOST等。
    int            flags;

表示主机路由，既不是到网络或到一个广播/组播地址的路由。

#define DST_HOST        1
下面三个只用于IPsec。
#define DST_NOXFRM        2
#define DST_NOPOLICY        4
#define DST_NOHASH        8

表示该表项将过期的时间戳

    unsigned long        expires;


与IPsec相关
    unsigned short        header_len;    /* more space at head required */
与IPsec相关
    unsigned short        trailer_len;    /* space to reserve at tail */


这两个字段被用于对这两种类型的ICMP消息限速。
rate_last为上一个ICMP重定向消息送出的时间戳。rate_tokens是已经向与该dst_entry实例
相关的目的地发送ICMP重定向消息的次数，因此，(rate_tokens - 1)也就是连续被目的地忽略
的ICMP重定向消息的数目。

    unsigned int        rate_tokens;
    unsigned long        rate_last;    /* rate limiting for ICMP */

与IPsec相关
    struct dst_entry    *path;

 neighbour是包含下一跳三层地址到二层地址映射的结构，hh是缓存的二层首部。
struct neighbour    *neighbour;
struct hh_cache        *hh;
#ifdef CONFIG_XFRM
与IPsec相关
    struct xfrm_state    *xfrm;
#else
    void            *__pad1;
#endif

对需要交付到本地的分组，input设置为ip_local_deliver,而output设置为ip_rt_bug(该函数只向内核日志输出一个
错误信息,因为在内核代码中对本地分组调用output是一种错误,不应该发生)
对需要转发的分组，input设置为ip_forward,而output设置为ip_output函数
       /* 处理进入的分组*/
    int            (*input)(struct sk_buff*);
       /* 处理外出的分组*/
    int            (*output)(struct sk_buff*);


用于处理dst_entry结构的虚函数表结构,设置的是ipv4_dst_ops，参见dst_alloc()函数
    struct  dst_ops            *ops;
多种度量值，TCP中多处使用。
    u32            metrics[RTAX_MAX];

#ifdef CONFIG_NET_CLS_ROUTE
基于路由表的classifier的标签。
    __u32            tclassid;
#else
    __u32            __pad2;
#endif


    /*
     * Align __refcnt to a 64 bytes alignment
     * (L1_CACHE_SIZE would be too much)
     */
#ifdef CONFIG_64BIT
    long            __pad_to_align_refcnt[2];
#else
    long            __pad_to_align_refcnt[1];
#endif
    /*
     * __refcnt wants to be on a different cache line from
     * input/output/ops or performance tanks badly
     */
    /*
     * 引用计数
     */
    atomic_t        __refcnt;    /* client references    */
    /*
     * 该表项已经被使用的次数(即缓存
     * 查找返回该表项的次数)。
     * 注意:不要这个值与rt_cache_stat[smp_processor_id()].in_hit混淆，
     * 后者表示针对某个CPU的全局缓存命中次数。
     */
    int            __use;
    /*
     * 记录该表项最后一次被使用的时间戳。当
     * 缓存查找成功时更新该时间戳，垃圾回收
     * 程序使用该时间戳来决定最应该被释放
     * 表项。
     */
    unsigned long        lastuse;
    union {
    /*
     * next成员用于将分布在同一个散列表
     * 桶内的dst_entry实例链接在一起。
     */
        struct dst_entry *next;
        struct rtable    *rt_next;
        struct rt6_info   *rt6_next;
        struct dn_route  *dn_next;
    };
};