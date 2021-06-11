
main.c中的start_kernel中，sock_init主要完成与套接字有关的初始化； [sk_init, skb_init init_inodecache register_filesystem]
                          do_initcall 完成协议初始化；
                          inet_inet负责与INET套接字有关的初始化；


socket(简要说明)
{
套接字代表一条通信链路的一端，存储了该端所有与通信有关的信息。
这些信息包括:使用的协议、套接字状态、源和目的地址、到达的连接 
队列、数据缓存和可选标志等。                                  


SOCK_STREAM     基于连接的套接字            
SOCK_DGRAM      基于数据包的套接字          
SOCK_RAW        原始套接字                  
SOCK_RDM        可靠传送报文套接字          提供可靠的数据包服务，打不保证报文到达顺序
SOCK_SEQPACKET  顺序分组套接字              提供双向连接服务，保证顺序、可靠以及数据包取最大长度，每次接收数据时必须读入一个完整的报文。
SOCK_DCCP       数据包拥塞控制协议套接字    
SOCK_PACKET     混杂模式套接字              支持直接从网络设备直接获取数据包
                                            
构建
socket sys_socket sock_create inet_create 
                              unix_create
发送
send sys_send inet_sendmsg
              unix_stream_sendmsg
             
}

socket(字段)
{
socket_state state;
SS_FREE           该套接字尚未分配，未使用  
SS_UNCONNECTED    该套接字未连接任何一个对端的套接字
SS_CONNECTING     正在连接过程中
SS_CONNECTED      已连接一个套接字
SS_DISCONNECTING  正在断开连接的过程中。

flags 标志
struct proto_ops *ops
struct fasync_struct *fasync_list;
struct file
struct sock
wait_queue_head_t wait
short type;
SOCK_STREAM     基于连接的套接字        
SOCK_DGRAM      基于数据包的套接字      
SOCK_RAW        原始套接字              
SOCK_RDM        可靠传送报文套接字      
SOCK_SEQPACKET  顺序分组套接字          
SOCK_DCCP       数据包拥塞控制协议套接字
SOCK_PACKET     混杂模式套接字          
passcred;
}

net_proto_family(协议族管理)
{
Linux目前最多支持32种协议族，每个协议族用一个net_proto_family结构  
实例来表示，在系统初始化时，以各协议族对应的协议族常量为下标，调用 
sock_register()将结构注册到全局数组net_families[NPROTO]中(NPROTO为 
32）。此外，还有一个地址族的概念，地址族用地址族常量来标识，到目前 
为止，协议族常量和地址族常量是一一对应的，且值相同。               
对于不同的协议族，其传输层的结构和实现有着巨大的差异，因此其各自的 
套接字创建函数也会有很大区别，而net_proto_family结构屏蔽了这些     
区别，使得各协议族在初始化时，可以统一用sock_register()注册到      
net_families数组中。因此实际上net_proto_family结构提供了一个       
协议族到套接字创建之间的接口。                                     
Internet协议族对应的实例为inet_family_ops，套接字创建函数为        
inet_create()。                                                    

协议族对应的协议族常数，Internet协议族是PF_INET。
family

协议族的套接字创建函数指针，每个协议族都有一个不同的实现     
(*create)(struct net *net, struct socket *sock, int protocol);



}

协议族套接字的操作函数可能不同，但Linux通过struct proto_ops定义的统一接口来管理这些函数。
内核为INET协议族的TCP和UDP协议分别提供了inet_stream_ops和inet_dgram_ops两个变量。
proto_ops(协议族操作集)
{

inet_stream_ops inet_dgram_ops inet_raw_ops

family; 协议族
owner ; 所属模块
release 释放套接字
bind    给套接字绑定地址
connect 发送连接请求
socketpair 设置对端套接字
accept 接收连接请求
getname 获取符号名
poll 以poll方式查询
ioctl 执行ioctl操作
listen 监听套接字端口
shutdown 关闭套接字
setsockopt 设置套接字选项
getsockopt 获取套接字选项
sendmsg 发送数据
recvmsg 接收数据
sendpages 发送页面数据
}

proto(传输层操作集)
{
raw_prot udp_prot tcp_prot

close 关闭套接字
connect 请求连接
disconnect 中断连接
accept 接收连接
ioctl IO控制
init 初始化套接字
destroy 清除套接字
shutdown 以how定义的方式关闭套接字
setsockopt 设置套接字选项
getsockopt 获取套接字选项
sendmsg 发送数据
recvmsg 接收数据
sendpage 发送页面数据
bind 绑定地址和套接字
backlog_rcv 从队列接收
hash 通过hash表查找套接字
unhash 套接字的反hash处理
get_port 获取端口
entry_memory_pressure 压缩内存
memory_allocated 分配的内存数
sockets_allocated 分配的套接字节数
memory_pressure 与memory_allocated内存控制有关
sysctl_mem  内存访问限制指针
sysctl_rmem 写内存访问限制指针
sysctl_wmem 读内存访问限制指针
max_header 最大头部
name[32] 名字描述


}

struct sock类型是套接字在传输层的表示结构，所有的套接字最后通过该接口来使用网络协议栈的服务。
先确定sk_family PF_INET; 在确定 sk_type SOCK_STREAM SOCK_DGRAM SOCK_RAW.
传输层的方法用sk_prot表示，它指向
sock(传输控制协议)
{
sock结构是构成传输控制块的基础，跟具体的协议族无关，         
包含各种协议族传输层协议的公共信息，因此不能直接作为         
传输层的控制块来使用，不同协议族的传输层在使用sock结构       
时都会对其进行扩展，使其适合各自的传输特性。例如，inet_sock  
结构就是由sock结构和其他一些特性组成的，是IPv4协议族传输     
控制块的基础                                                 

指向网络接口层的指针,如果是TCP套接字，为tcp_prot   如果是UDP套接字为udp_prot。                                                                    
#define sk_prot     __sk_common.skc_prot              
sk_zapped IPX中的连接标志

关闭套接口的标志，下列值之一:                     
RCV_SHUTDOWN: 接收通道关闭，不允许继续接收数据    
SEND_SHUTDOWN: 发送通道关闭，不允许继续发送数据   
SHUTDOWN_MASK: 表示完全关闭                       
sk_shutdown 

sk_use_write_queue 为1表示传输层协议使用了

标识传输层的一些状态，下列值之一:                             
SOCK_SNDBUF_LOCK: 用户通过套接口选项设置了发送缓冲区大小      
* SOCK_RCVBUF_LOCK: 用户通过套接口选项设置了接收缓冲区大小    
* SOCK_BINDADDR_LOCK: 已经绑定了本地地址                      
* SOCK_BINDPORT_LOCK: 已经绑定了本地端口                      
sk_userlocks                                                  用户锁

同步锁，其中包括了两种锁:一是用于用户进程读取数据   
和网络层向传输层传递数据之间的同步锁；二是控制Linux 
下半部访问本传输控制块的同步锁，以免多个下半部同    
时访问本传输控制块                                  
sk_lock;                                                      套接字锁

接收缓冲区大小的上限，默认值是sysctl_rmem_default，即32767
sk_rcvbuf                                                     接收缓冲区长度

进程等待队列。进程等待连接、等待输出缓冲区、等待           
读数据时，都会将进程暂存到此队列中。这个成员最初           
是在sk_clone()中初始化为NULL，该成员实际存储的socket结构   
中的wait成员，这个操作在sock_init_data()中完成。           
sk_sleep                                                     等待队列首部

目的路由项缓存，一般都是在创建传输控制块发送  
数据报文时，发现未设置该字段才从路由表或路由  
缓存中查询到相应的路由项来设置新字段，这样可以
加速数据的输出，后续数据的输出不必再查询目的  
路由。某些情况下会刷新此目的路由缓存，比如断开
连接、重新进行了连接、TCP重传、重新绑定端口   
等操作                                        
sk_dst_cache                                                路由缓存指针

操作目的路由缓存的读写锁
sk_dst_lock                                               目的表项缓存锁

与IPSee相关的传输策略
sk_policy

接收队列sk_receive_queue中所有报文数据的总长度 .该成员在skb_set_owner_r()函数中会更新
sk_rmem_alloc                                              接收缓冲队列分配计数

接收队列，等待用户进程读取。TCP比较特别，  
当接收到的数据不能直接复制到用户空间时才会 
缓存在此                                   
sk_receive_queue                                          套接字缓冲区接收队列

所在传输控制块中，为发送而分配的所有SKB数据区的总长度。这个成员和            
sk_wmem_queued不同，所有因为发送而分配的SKB数据区的内存都会统计到            
sk_wmem_alloc成员中。例如，在tcp_transmit_skb()中会克隆发送队列中的          
SKB，克隆出来的SKB所占的内存会统计到sk_wmem_alloc，而不是sk_wmem_queued中。                                                                         
释放sock结构时，会先将sk_wmem_alloc成员减1，如果为0，说明没有待              
发送的数据，才会真正释放。所以这里要先将其初始化为1   ,参见                  
sk_alloc()。该成员在skb_set_owner_w()中会更新。                                          
sk_wmem_alloc                                             发送缓冲区分配计数

发送队列，在TCP中，此队列同时也是重传队列，
在sk_send_head之前为重传队列，之后为发送   
队列，参见sk_send_head                                    
sk_write_queue                                            套接字缓冲区发送队列

分配辅助缓冲区的上限，辅助数据包括进行设置选项、
设置过滤时分配到的内存和组播设置等                       
sk_omem_alloc                                             其他缓冲区队列分配计数

预分配缓存长度，这只是一个标识，目前 只用于TCP。                        
当分配的缓存小于该值时，分配必然成功，否则需要                          
重新确认分配的缓存是否有效。参见__sk_mem_schedule().                    
在sk_clone()中，sk_forward_alloc被初始化为0.                            
                                                                        
update:sk_forward_alloc表示预分配长度。当我们第一次要为                 
发送缓冲队列分配一个struct sk_buff时，我们并不是直接                    
分配需要的内存大小，而是会以内存页为单位进行                            
预分配(此时并不是真的分配内存)。当把这个新分配                          
成功的struct sk_buff放入缓冲队列sk_write_queue后，从sk_forward_alloc    
中减去该sk_buff的truesize值。第二次分配struct sk_buff时，只要再         
从sk_forward_alloc中减去新的sk_buff的truesize即可，如果sk_forward_alloc 
已经小于当前的truesize，则将其再加上一个页的整数倍值，                  
并累加如tcp_memory_allocated。                                          
  也就是说，通过sk_forward_alloc使全局变量tcp_memory_allocated保存      
当前tcp协议总的缓冲区分配内存的大小，并且该大小是                       
页边界对齐的。                                                      
sk_forward_alloc                                         提前分配的空间

内存分配方式，参见include\linux\gfp.h。值为__GFP_DMA等 
sk_allocation                                            分配模式

发送缓冲区长度的上限，发送队列中报文数据总长度不能 
超过该值.默认值是sysctl_wmem_default，即32767      
sk_sndbuf                                               发送缓冲区长度

标志位，可能的取值参见枚举类型sock_flags.
判断某个标志是否设置调用sock_flag函数来  
判断，而不是直接使用位操作。             
sk_flags                                                 标志

标识是否对RAW和UDP进行校验和，下列值之一:  
UDP_CSUM_NOXMIT: 不执行校验和              
UDP_CSUM_NORCV: 只用于SunRPC               
UDP_CSUM_DEFAULT: 默认执行校验和           
sk_no_check

sk_debug                  SO_DEBUG
sk_rcvtstamp              SO_TIMESTAMP
sk_no_largesend           对大叔举得发送支持

目的路由网络设备的特性，在sk_setup_caps()中根据  
net_device结构的features成员设置                 
sk_route_caps           网络驱动特征标志

关闭套接字前发送剩余数据的时间
sk_lingertime        SO_LINGER设置
sk_hashent           hash表项
sk_pair               

后备接收队列，目前只用于TCP.传输控制块被上锁后(如应用层
读取数据时),当有新的报文传递到传输控制块时，只能把报文 
放到后备接受队列中，之后有用户进程读取TCP数据时，再从  
该队列中取出复制到用户空间中.                          
一旦用户进程解锁传输控制块，就会立即处理               
后备队列，将TCP段处理之后添加到接收队列中。             sk_buff结构的backlog队列
sk_backlog

确保传输控制块中一些成员同步访问的锁。因为有些成员在软 
中断中被访问，存在异步访问的问题                        用于回调函数的锁
sk_callback_lock

错误链表，存放详细的出错信息。应用程序通过setsockopt        
系统调用设置IP_RECVERR选项，即需获取详细出错信息。当        
有错误发生时，可通过recvmsg()，参数flags为MSG_ERRQUEUE      
来获取详细的出错信息                                        
update:                                                     
sk_error_queue用于保存错误消息，当ICMP接收到差错消息或者    
UDP套接字和RAW套接字输出报文出错时，会产生描述错误信息的    
SKB添加到该队列上。应用程序为能通过系统调用获取详细的       
错误消息，需要设置IP_RECVERR套接字选项，之后可通过参数      
flags为MSG_ERRQUEUE的recvmsg系统调用来获取详细的出错        
信息。                                                      
UDP套接字和RAW套接字在调用recvmsg接收数据时，可以设置       
MSG_ERRQUEUE标志，只从套接字的错误队列上接收错误而不        
接收其他数据。实现这个功能是通过ip_recv_error()来完成的。   
在基于连接的套接字上，IP_RECVERR意义则会有所不同。并不      
保存错误信息到错误队列中，而是立即传递所有收到的错误信息    
给用户进程。这对于基于短连接的TCP应用是很有用的，因为       
TCP要求快速的错误处理。需要注意的是，TCP没有错误队列，      
MSG_ERRQUEUE对于基于连接的套接字是无效的。                  
错误信息传递给用户进程时，并不将错误信息作为报文的内容传递  
给用户进程，而是以错误信息块的形式保存在SKB控制块中，       
通常通过SKB_EXT_ERR来访问SKB控制块中的错误信息块。          
参见sock_exterr_skb结构。                                    出错的sk_buff队列
sk_error_queue

sk_prot                                                      套接字的传输层协议操作集
记录当前传输层中发生的最后一次致命错误的错误码，但  
应用层读取后会自动恢复为初始正常状态.               
错误码的设置是由tcp_v4_err()函数完成的。            
sk_err                                                       错误记录
sk_err_soft

sk_ack_backlog                                              当前已建立的连接数

连接队列长度的上限 ，其值是用户指定的连接                        
队列长度与/proc/sys/net/core/somaxconn(默认值是128)之间的较小值。
sk_max_ack_backlog

用于设置由此套接字输出数据包的QoS类别
sk_priority

所属的套接字类型，如SOCK_STREAM 
sk_type

当前域中套接字所属的协议 
sk_protocol

sk_localroute
使用本地路由表还是策略路由表

返回连接至该套接字的外部进程的身份验证，目前主要用于PF_UNIX协议族
sk_peercred

套接字层接收超时，初始值为MAX_SCHEDULE_TIMEOUT。   
可以通过套接字选项SO_RCVTIMEO来设置接收的超时时间。
sk_rectimeo

套接字层发送超时,初始值为MAX_SCHEDULE_TIMEOUT。     
可以通过套接字选项SO_SNDTIMEO来设置发送的超时时间。 
sk_sndtimeo

套接字过滤器。在传输层对输入的数据包通过BPF过滤代码进行过滤， 
只对设置了套接字过滤器的进程有效。                            
sk_filter

传输控制块存放私有数据的指针  
sk_protinfo


用于分配传输控制块的slab高速缓存，在注册对应传输层协议时建立
sk_slab

通过TCP的不同状态，来实现连接定时器、FIN_WAIT_2定时器以及    
TCP保活定时器，在tcp_keepalive_timer中实现                   
定时器处理函数为tcp_keepalive_timer(),参见tcp_v4_init_sock() 
和tcp_init_xmit_timers()。                                   
sk_timer

在未启用SOCK_RCVTSTAMP套接字选项时，记录报文接收数据到  
应用层的时间戳。在启用SOCK_RCVTSTAMP套接字选项时，接收  
数据到应用层的时间戳记录在SKB的tstamp中                 
sk_stamp

指向对应套接字的指针
sk_socket

RPC层存放私有数据的指针 ，IPv4中未使用
sk_user_data

指向为本传输控制块最近一次分配的页面，通常                      
是当前套接字发送队列中最后一个SKB的分片数据的                   
最后一页，但在某种特殊的状态下也有可能不是(                     
比如，在tcp_sendmsg中成功分配了页面，但复制数据失败了)。        
同时还用于区分系统的页面和主动分配的页面，如果是系统            
的页面，是不能在页面中做修改的，而如果是在发送过程              
中主动分配的页面，则可以对页面中的数据进行修改或添加，          
参见tcp_sendmsg.                                                
                                                                
sk_sndmsg_page和sk_sndmsg_off主要起缓存的作用，可以直接找到     
最后一个页面，然后尝试把数据追加到该页中，如果不行，则分配      
新页面，然后向新页复制数据，并更新sk_sndmsg_page和sk_sndmsg_off 
的值                                                            
sk_sndmsg_page

表示数据尾端在最后一页分片内的页内偏移， 
新的数据可以直接从这个位置复制到该分片中 
sk_sndmsg_off

指向sk_write_queue队列中第一个未发送的结点，如果sk_send_head  
为空则表示发送队列是空的，发送队列上的报文已全部发送。        
sk_send_head;

标识有数据即将写入套接口， 
也就是有写数据的请求*/     
sk_write_pending


指向sk_security_struct结构，安全模块使用
sk_security

发送队列的缓存区最近是否缩小过
sk_queue_shrunk

当传输控制块的状态发生变化时，唤醒哪些等待本套接字的进程。 
在创建套接字时初始化，IPv4中为sock_def_wakeup()            
    void            (*sk_state_change)(struct sock *sk);

当有数据到达接收处理时，唤醒或发送信号通知准备读本套接字的        
进程。在创建套接字时被初始化，IPv4中为sock_def_readable()。如果   
是netlink套接字，则为netlink_data_ready()。                       
    void            (*sk_data_ready)(struct sock *sk, int bytes);

在发送缓存大小发生变化或套接字被释放时，唤醒因等待本套接字而     
处于睡眠状态的进程，包括sk_sleep队列以及fasync_list队列上的      
进程。创建套接字时初始化，IPv4中默认为sock_def_write_space(),    
TCP中为sk_stream_write_space().                                  
void            (*sk_write_space)(struct sock *sk);
  
    
报告错误的回调函数，如果等待该传输控制块的进程正在睡眠， 
则将其唤醒(例如MSG_ERRQUEUE).在创建套接字时被初始化，    
IPv4中为sock_def_error_report().                         
    void        (*sk_error_report)(struct sock *sk);

用于TCP和PPPoE中。在TCP中，用于接收预备队列和后备队列中的      
TCP段，TCP的sk_backlog_rcv接口为tcp_v4_do_rcv()。如果预备      
队列中还存在TCP段，则调用tcp_prequeue_process()预处理，在      
该函数中会回调sk_backlog_rcv()。如果后备队列中还存在TCP段，    
则调用release_sock()处理，也会回调sk_backlog_rcv()。该函数     
指针在创建套接字的传输控制块时由传输层backlog_rcv接口初始化    
      int        (*sk_backlog_rcv)(struct sock *sk,struct sk_buff *skb);             
    
进行传输控制块的销毁，在释放传输控制块前释放一些其他资源，在   
sk_free()释放传输控制块时调用。当传输控制块的引用计数器为0时， 
才真正释放。IPv4中为inet_sock_destruct().                      
    void                    (*sk_destruct)(struct sock *sk);
  
}

inet_protosw是一个比较重要的结构，每次创建套接字时会用到，此结构也只在套接字层起作用。                                    
TCP对应的处理在inetsw_array中。                               

inet_protosw()
{
用于初始化时在散列表中将type值相同的inet_protosw结构实例连接成链表                                                       
list 链表头

标识套接字的类型，对于Internet协议族共有三种类型SOCK_DGRAM、SOCK_STREAM和SOCK_RAW，与应用程序层创建 
套接字函数socket（）的第二个参数type取值恰好对应。  
type INET套接字类型

标识协议族中四层协议号，Internet协议族中的值包括IPPROTO_TCP、IPPROTO_UDP等。                                                                     
protocl 第四层协议

套接字网络层接口。TCP为tcp_prot，UDP为udp_prot，原始套接字为 raw_prot。                                                   
prot   传输层协议操作集

套接字传输层接口。TCP为inet_stream_ops，UDP为inet_dgram_ops，原始套接字为inet_sockraw_ops。                                                        
ops    协议族套接字操作集

当大于0时，需要检验当前创建套接字的进程是否有这种能力。TCP和UDP均为-1,表示无需进行能力的检验，只有原始套接字为CAP_NET_RAW。                     
capability 匹配字段

    标识是否需要创建执行校验和，对于TCP来说，进行校验和是必须的，因此值是唯一
为0。注意此处0为要校验。而RAW和UDP的no_check值可取的为UDP_CSUM_NOXMIT等。
no_check 校验字段

辅助标志，用于初始化传输控制块的is_icsk成员。可取的值为INET_PROTOSW_REUSE等。                              
flags   标志字段
}

                                                                     
标识端口是否能重用                                                                                                                         
#define INET_PROTOSW_REUSE 0x01                                                                  
标识此协议不能被卸载或替换                                                                                                                 
#define INET_PROTOSW_PERMANENT 0x02                                                                       
标识是不是连接类型的套接字                                                                                                                    
#define INET_PROTOSW_ICSK      0x04 



net_protocol()
{
                               tcp_protocol   udp_protocol icmp_protocol
handler 指向接收数据包函数     tcp_v4_rcv    udp_rcv     icmp_rcv
err_handle 错误处理的函数      tcp_v4_err    udp_err     NULL
no_policy                      1             1           0
}


msghdr()
{
msg_name        数据中的地址指针，它可指向结构体struct sockaddr
msg_namelen     msg_name的长度
msg_iov          指向结构体struct iovec的指针，记录数据内容
msg_iovlen       msg_iov的长度
msg_control      用于发送的控制信息
msg_controllen   msg_control的长度
msg_flag         标志字段
}     


inet_sock()
{
inet_sock结构式比较通用的IPv4协议族描述块，包含IPv4协议族基础     
传输层，即UDP、TCP以及原始传输控制块共有的信息(外部和本地IP地址、 
外部和本地端口号、IP首部原型、该端节点使用的IP选项等).            

sock结构是通用的网络层描述块，构成传输控制块的基础
struct sock        sk;

如果支持IPv6特性，pinet6是指向IPv6控制块的指针 
struct ipv6_pinfo    *pinet6;                              

目的IP地址
__be32            daddr;

已绑定的本地IP地址。接收数据时，作为条件的一部分查找数据所属的传输控制块                                 
__be32            rcv_saddr;
也标识本地IP地址，但在发送时使用。rcv_saddr和saddr都描述本地IP地址，但用途不同                       
__be32            saddr;


目的端口号
__be16            dport;
主机字节序存储的本地端口
__u16            num;
由num转换成的网络字节序的源端口，也就是本地端口
__be16            sport;


单播报文的TTL,默认值为-1，表示使用默认的TTL值在输出IP数据包时，TTL值首先从这里获取，若没有
设置，则从路由缓存的metric中获取。参见IP_TTL套接字选项                                   
__s16            uc_ttl;

存放一些IPPROTO_IP级别的选项值，可能的取值为IP_CMSG_PKTINFO等 
__u16            cmsg_flags;
指向IP数据包选项的指针
struct ip_options    *opt;

一个单调递增的值，用来赋给IP首部中的id域
__u16            id;


用于设置IP数据包首部的TOS域，参见IP_TOS套接字选项
__u8            tos;

用于设置多播数据包的TTL
__u8            mc_ttl;

标识套接字是否启用路径MTU发现功能，初始值根据系统控制参数ip_no_pmtu_disc来确定，参见IP_MTU_DISCOVER 
套接字选项。可能的取值有IP_PMTUDISC_DO等           
__u8            pmtudisc;

标识是否允许接收扩展的可靠错误信息。参见IP_RECVERR套接字选项            
__u8            recverr:1,

标识是否为基于连接的传输控制块，即是否为基于inet_connection_sock结构的传输控制块，如TCP的传输控制块  
is_icsk:1,

标识是否允许绑定非主机地址，参见IP_FREEBIND套接字选项
freebind:1,

标识IP首部是否由用户数据构建。该标识只用于RAW套接字，一旦设置后，IP选项中的IP_TTL和IP_TOS都将被忽略       
hdrincl:1,

标识组播是否发向回路
mc_loop:1,     
transparent:1, 
mc_all:1;      

发送组播报文的网络设备索引号。如果为0，则表示可以从任何网络设备发送                       
int            mc_index;

发送组播报文的源地址          
__be32            mc_addr;                   
所在套接字加入的组播地址列表  
struct ip_mc_socklist    *mc_list;        

UDP或原始IP在每次发送时缓存的一些临时信息。如UDP数据包或原始IP数据包分片的大小                           
cork; 
}
           