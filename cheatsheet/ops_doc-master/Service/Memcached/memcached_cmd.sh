名称
       memcached - 高性能内存对象缓存系统
语法
       memcached [options]
描述
       memcached 是一个灵活的内存对象缓存守护进程。它通过将对象缓存在内存中，从而降低WEB应用对数据库的压力。
       它基于 libevent 库，可以伸缩到任意大小，并永远使用非阻塞的网络I/O。
       因此在使用 memcached 的机器上应避免使用虚拟内存(swap)。

选项
       这个守护进程不使用任何配置文件，只使用下面的命令行选项控制其行为。
       -s file
              指定在那个文件上监听 Unix socket (不使用TCP/IP网络)
              # 该选项的参数赋值给settings.socketpath
       -a perms
              指定"-s"选项创建的 Unix socket 文件的权限(八进制)
              # 该选项的参数赋值给settings.access
       -l ip_addr
              在指定的 ip_addr 上监听，默认是所有可用地址(INADDR_ANY)。
              这是一个重要的选项，因为没有其它更多的访问控制方法。
              出于安全考虑，建议绑定到内网接口或者有防火墙保护的网络接口。
              该选项的参数可以由多个ip组成，ip之间用逗号分隔。
              # 选项参数将赋值给settings.inter
       -d     以守护进程的方式运行(后台运行)
       -u username
              指定以 username 用户的身份运行，该选项仅在以root用户启动时有效。
       -m num
              使用 num MB 大小的内存作为缓冲区，默认值是 64MB
              # 该参数赋值给settings.maxbytes
       -c num
              最大允许 num 个并发连接，默认值是 1024
              # 默认值为1024个。该选项参数赋值给settings.maxconns。
       -R num
              这是一个为了防止某些客户端被饿死而设置的选项。num 的默认值是"20"。
              参数 num 表示服务器在同一个连接内最多连续处理 num 个请求。
              一旦某连接连续处理的请求数超过了 num 的限制，服务器将会转而去处理其他连接的请求，
              直到其他连接的请求全部处理完毕(或者也达到了上限)之后，才会回过头来继续处理此连接上剩余的请求。
              # 该选项的参数赋值给settings.reqs_per_event
       -k     锁定所有分页内存(paged memory)。这个选项在缓冲区比较大的时候使用可能会有些危险。
       -p num
              在TCP端口 num 上监听，默认值是 11211
              #  该选项的参数赋值给settings.port
       -U num
              在UDP端口 num 上监听，默认值是 11211 ，0 表示关闭
              # 该选项的参数赋值给settings.udpport
       -M     禁止在缓冲区不够用的时候自动移除缓存对象。这样将会导致缓冲区满时无法添加新对象。
              # 该选项将settings.evict_to_free赋值为0。
       -r     将核心文件尺寸限制加大到最大值
       -f factor
              将 factor 用作计算每个缓存项所占内存块大小的乘数(multiplier)。默认值是"1.25"。
              也许较小的乘数会减少内存的浪费，但实际效果取决于可用内存总量以及不同缓存项大小的分布状况。
              # 该选项参数将赋值给settings.factor
       -n size
              最少为每个缓存对象的"key, value, flags"分配 size 字节。默认值为 48 。
              如果你有大量的小"key,value"对，减小此值将会大大提高内存的利用效率。
              另一方面，如果你使用"-f"选项指定了较大的块膨胀系数(chunk growth factor)，
              那么你应当增加此值以让更高比例的缓存项更适合稠密的压缩内存块。
              # 该选项参数赋值给settings.chunk_size
       -C     禁止使用CAS(可以为每个缓存项节约8个字节的空间)
              # 本选项会将settings.use_cas赋值为false
       -h     显示版本号和选项列表后退出
       -v     提示信息(在事件循环中打印错误/警告信息。)
       -vv    详细信息(还打印客户端命令/响应)
       -vvv   超详细信息(还打印内部状态的变化)
               # 该选项会增加settings.verbose的值
       -i     打印 memcached 和 libevent 的许可证
       -P filename
              将进程号(PID)保存在 filename 中，仅在使用了"-d"选项后才有意义。
       -t threads
              使用 threads 个线程来处理接入请求。将此值设置为超过总的CPU核心数只会弄巧成拙。默认值是 4 。
              # settings.num_threads
       -D char
              使用 char 作为key前缀和ID之间的分隔符，这将用于每一个前缀状态报告。默认值是冒号(:)。
              明确指定此选项后状态收集器将被自动打开，否则可以通过向服务器发送"stats detail on"命令来开启。
              分隔符为冒号":"。
              # 该选项参数会赋值为settings.prefix_delimiter，并将settings.detail_enabled赋值为1
       -L     尽量使用大内存页(如果可用)。使用大内存页可以增大TLB缓存命中概率，从而提升内存性能。
              此选项仅在内核支持大内存页(CONFIG_TRANSPARENT_HUGEPAGE,CONFIG_HUGETLBFS)的系统上有意义。
       -B proto
              指定要使用的绑定协议。默认值"auto"表示由服务器与客户端进行协商。
              而"ascii"和"binary"则明确表示仅允许使用确定的协议。
              # 将参数将赋值给settings.binding_protocol
       -I size
              指定每个slab/slub页的默认大小。默认值是"1m"。允许的最小值是"1k"，允许的最大值是"128m"。
              改变此项同时也改变了每个缓存项的尺寸上限。
              增大此项的同时也增大了slab/slub页的数量(可以使用 -v 查看)，以及 memcached 的内存总使用量。
              # 本选项参数会赋值给settings.item_size_max
       -F     禁用"flush_all"命令。
              cmd_flush 计数器仍然会增加，但是客户端将会收到"刷新动作未被执行"的错误消息。
              # 该选项将settings.flush_enabled赋值为false
       -o options
              逗号分隔的扩展或实验性选项的列表。参见 -h 或 wiki 以获取这些选项。
                maxconns_fast:   如果连接数超过了最大同时在线数(由-c选项指定)，立即关闭新连接上的客户端。
              该选项将settings.maxconns_fast赋值为true
                hashpower:   哈希表的长度是2^n。可以通过选项hashpower设置指数n的初始值。如果不设置将取默认值16。
              该选项必须有参数，参数取值范围只能为[12, 64]。本选项参数值赋值给settings.hashpower_init
                slab_reassign:   该选项没有参数。用于调节不同类型的item所占的内存。不同类型是指大小不同。
              某一类item已经很少使用了，但仍占用着内存。可以通过开启slab_reassign调度内存，减少这一类item的内存。
              如果使用了本选项，settings.slab_reassign赋值为true
                slab_automove:   依赖于slab_reassign。用于主动检测是否需要进行内存调度。该选项的参数是可选的。
              参数的取值范围只能为0、1、2。参数2是不建议的。本选项参数赋值给settings.slab_automove。
              如果本选项没有参数，那么settings.slab_automove赋值为1
                hash_algorithm:   用于指定哈希算法。该选项必须带有参数。并且参数只能是字符串jenkins或者murmur3
                tail_repair_time:   用于检测是否有item被已死线程所引用。一般不会出现这种情况，所以默认不开启这种检测。
              如果需要开启这种检测，那么需要使用本选项。本选项需要一个参数，参数值必须不小于10。
              该参数赋值给settings.tail_repair_time
                lru_crawler:   本选项用于启动LRU爬虫线程。该选项不需要参数。
              本选项会导致settings.lru_crawler赋值为true
                lru_crawler_sleep:  LRU爬虫线程工作时的休眠间隔。本选项需要一个参数作为休眠时间，
              单位为微秒，取值范围是[0, 1000000]。该参数赋值给settings.lru_crawler_sleep
                lru_crawler_tocrawl:   LRU爬虫检查每条LRU队列中的多少个item。该选项带有一个参数。
              参数会赋值给settings.lru_crawler_tocrawl
       -A    是否运行客户端使用shutdown命令。默认是不允许的。该选项将允许。
             客户端的shutdown命令会将memcached进程杀死。
             # 该选项会将settings.shutdown_command赋值为true
       -b    listen函数的第二个参数。
             # 该选项的参数赋值给settings.backlog。如果不设置该选项，那么默认为1024
       -S      打开sasl安全协议。会将settings.sasl赋值为true
             
MEMCACHED-1.4.17(1)                                                                MEMCACHED-1.4.17(1)
# https://blog.csdn.net/luotuo44/article/details/42672913

setting_init(){
    //开启CAS业务，如果开启了那么在item里面就会多一个用于CAS的字段。可以在启动memcached的时候通过-C选项禁用
    settings.use_cas = true;

    settings.access = 0700; //unix socket的权限位信息
    settings.port = 11211;//memcached监听的tcp端口
    settings.udpport = 11211;//memcached监听的udp端口
    //memcached绑定的ip地址。如果该值为NULL，那么就是INADDR_ANY。否则该值指向一个ip字符串
    settings.inter = NULL;
    
    settings.maxbytes = 64 * 1024 * 1024; //memcached能够使用的最大内存
    settings.maxconns = 1024; //最多允许多少个客户端同时在线。不同于settings.backlog
   
    settings.verbose = 0;//运行信息的输出级别.该值越大输出的信息就越详细
    settings.oldest_live = 0; //flush_all命令的时间界限。插入时间小于这个时间的item删除。
    settings.evict_to_free = 1;  //标记memcached是否允许LRU淘汰机制。默认是可以的。可以通过-M选项禁止  
    settings.socketpath = NULL;//unix socket监听的socket路径.默认不使用unix socket 
    settings.factor = 1.25; //item的扩容因子
    settings.chunk_size = 48; //最小的一个item能存储多少字节的数据(set、add命令中的数据)
    settings.num_threads = 4; //worker线程的个数
     //多少个worker线程为一个udp socket服务 number of worker threads serving each udp socket
    settings.num_threads_per_udp = 0;
    
    settings.prefix_delimiter = ':'; //分隔符
    settings.detail_enabled = 0;//是否自动收集状态信息
 
    //worker线程连续为某个客户端执行命令的最大命令数。这主要是为了防止一个客户端霸占整个worker线程
    //，而该worker线程的其他客户端的命令无法得到处理
    settings.reqs_per_event = 20;
    
    settings.backlog = 1024;//listen函数的第二个参数，不同于settings.maxconns
    //用户命令的协议，有文件和二进制两种。negotiating_prot是协商，自动根据命令内容判断
    settings.binding_protocol = negotiating_prot;
    settings.item_size_max = 1024 * 1024;//slab内存页的大小。单位是字节
    settings.maxconns_fast = false;//如果连接数超过了最大同时在线数(由-c选项指定)，是否立即关闭新连接上的客户端。
 
    //用于指明memcached是否启动了LRU爬虫线程。默认值为false，不启动LRU爬虫线程。
    //可以在启动memcached时通过-o lru_crawler将变量的值赋值为true，启动LRU爬虫线程
    settings.lru_crawler = false;
    settings.lru_crawler_sleep = 100;//LRU爬虫线程工作时的休眠间隔。单位为微秒 
    settings.lru_crawler_tocrawl = 0; //LRU爬虫检查每条LRU队列中的多少个item,如果想让LRU爬虫工作必须修改这个值
 
    //哈希表的长度是2^n。这个值就是n的初始值。可以在启动memcached的时候通过-o hashpower_init
    //设置。设置的值要在[12, 64]之间。如果不设置，该值为0。哈希表的幂将取默认值16
    settings.hashpower_init = 0;  /* Starting hash power level */
 
    settings.slab_reassign = false;//是否开启调节不同类型item所占的内存数。可以通过 -o slab_reassign选项开启
    settings.slab_automove = 0;//自动检测是否需要进行不同类型item的内存调整，依赖于settings.slab_reassign的开启
 
    settings.shutdown_command = false;//是否支持客户端的关闭命令，该命令会关闭memcached进程
 
    //用于修复item的引用数。如果一个worker线程引用了某个item，还没来得及解除引用这个线程就挂了
    //那么这个item就永远被这个已死的线程所引用而不能释放。memcached用这个值来检测是否出现这种
    //情况。因为这种情况很少发生，所以该变量的默认值为0(即不进行检测)。
    //在启动memcached时，通过-o tail_repair_time xxx设置。设置的值要大于10(单位为秒)
    //TAIL_REPAIR_TIME_DEFAULT 等于 0。
    settings.tail_repair_time = TAIL_REPAIR_TIME_DEFAULT; 
    settings.flush_enabled = true;//是否运行客户端使用flush_all命令
}

libevent(){
1. memcached使用"主线程统一accept/dispatch子线程"网络模型处理客户端的连接和通信，
1.1  "主线程统一accept/dispatch子线程"的基础设施：主线程创建多个子线程(这些子线程也称为worker线程)，
每一个线程都维持自己的事件循环，即每个线程都有自己的epoll，并且都会调用epoll_wait函数进入事件监听状态。
每一个worker线程(子线程)和主线程之间都用一条管道相互通信。每一个子线程都监听自己对应那条管道的读端。
当主线程想和某一个worker线程进行通信，直接往对应的那条管道写入数据即可。
1.2   "主线程统一accept/dispatch子线程"模型的工作流程：主线程负责监听进程对外的TCP监听端口。
当客户端申请连接connect到进程的时候，主线程负责接收accept客户端的连接请求。然后主线程选择其中一个worker线程，
把客户端fd通过对应的管道传给worker线程。worker线程得到客户端的fd后负责和这个客户端进行一切的通信。

2. libevent
2.1 memcached使用libevent作为进行事件监听；
2.2 memcached往管道里面写的内容不是fd，而是一个简单的字符。
    每一个worker线程都维护一个CQ队列，主线程把fd和一些信息写入一个CQ_ITEM里面，
然后主线程往worker线程的CQ队列里面push这个CQ_ITEM。接着主线程使用管道通知worker线程:
"我已经发了一个新客户给你，你去处理吧"。


用户线程使用libevent则通常按以下步骤：
1）用户线程通过event_init()函数创建一个event_base对象。event_base对象管理所有注册到自己内部的IO事件。
多线程环境下，event_base对象不能被多个线程共享，即一个event_base对象只能对应一个线程。
2）然后该线程通过event_add函数，将与自己感兴趣的文件描述符相关的IO事件，注册到event_base对象，同时指定
事件发生时所要调用的事件处理函数(event handler)。服务器程序通常监听套接字(socket)的可读事件。比如，
服务器线程注册套接字sock1的EV_READ事件，并指定event_handler1()为该事件的回调函数。libevent将IO事件封
装成struct event类型对象，事件类型用EV_READ/EV_WRITE等常量标志。
3） 注册完事件之后，线程调用event_base_loop进入循环监听(monitor)状态。该循环内部会调用epoll等IO复用
函数进入阻塞状态，直到描述符上发生自己感兴趣的事件。此时，线程会调用事先指定的回调函数处理该事件。例
如，当套接字sock1发生可读事件，即sock1的内核buff中已有可读数据时，被阻塞的线程立即返回(wake up)并调
用event_handler1()函数来处理该次事件。
4）处理完这次监听获得的事件后，线程再次进入阻塞状态并监听，直到下次事件发生。

3. CQ队列
typedef struct conn_queue_item  CQ_ITEM;
typedef struct conn_queue  CQ;
3.1 函数
void cq_init(CQ *cq)                 # 连接队列初始化
CQ_ITEM *cq_pop(CQ *cq)              # 获取一个连接
void cq_push(CQ *cq, CQ_ITEM *item)  # 添加一个连接信息
CQ_ITEM *cqi_new(void)               # 创建连接队列
void cqi_free(CQ_ITEM *item)         # 释放item，也就是将item添加到空闲链表中
}


main(){
1. 初始化系统环境
sanitycheck             检查libevent版本是否满足
settings_init           对memcached设置取默认值 
setbuf(stderr, NULL);   错误输出无缓存
2. 命令行解析
getopt                  解析memcached启动参数
2.1 通过参数配置系统环境
hash_init(hash_type)    初始化hash表

3. 初始化进程环境
3.1 初始化libevent
main_base = event_init();
3.2 初始化进程资源
stats_init();
assoc_init(settings.hashpower_init);
conn_init();
slabs_init(settings.maxbytes, settings.factor, preallocate);
thread_init(settings.num_threads, main_base);
start_assoc_maintenance_thread()
start_slab_maintenance_thread()
init_lru_crawler();
3.3 启动libevent
event_base_loop(main_base, 0) 
3.4 释放进程占用资源
stop_assoc_maintenance_thread();
}


protocol(){
1. 保存: "set", "add", "replace", "append" "prepend" and "cas"
2. 获取: "get" and "gets"

Error strings 
----------------
1. "ERROR\r\n"
2. "CLIENT_ERROR <error>\r\n"
3. "SERVER_ERROR <error>\r\n"

Authentication
----------------
set <key> <flags> <exptime> <bytes>\r\n
username password\r\n
- "STORED\r\n" indicates success. After this point any command should work normally. 
- "CLIENT_ERROR [message]\r\n" will be returned if authentication fails for any reason.

Storage commands
----------------
<command name> <key> <flags> <exptime> <bytes> [noreply]\r\n
cas            <key> <flags> <exptime> <bytes> <cas unique> [noreply]\r\n
<command name>: set add replace append prepend 
set
add
replace
append
prepend
case
<key>
<flags>
<exptime>
<bytes>

<data block>\r\n

1. - "STORED\r\n", to indicate success.
2. - "NOT_STORED\r\n" to indicate the data was not stored, but not
because of an error. This normally means that the
condition for an "add" or a "replace" command was not met.
3. - "EXISTS\r\n" to indicate that the item you are trying to store 
with a "cas" command has been modified since you last fetched it.
4. - "NOT_FOUND\r\n" to indicate that the item you are trying to store with 
a "cas" command did not exist.
}
1 调整slab参数
slab对于memcached的空间利用率占有决定因素.

1.1:比较重要的几个启动参数:
-f:增长因子,chunk的值会按照增长因子的比例增长(chunk size growth factor).
-n:每个chunk的初始大小(minimum space allocated for key+value+flags),chunk大小还包括本身结构体大小.
-I:每个slab page大小(Override the size of each slab page. Adjusts max item size)
-m:需要分配的大小(max memory to use for items in megabytes)

1.2. stats slabs
chunk_size:chunk大小
chunk_per_page:每个page的chunk数量
total_pages:page数量
total_chunks:chunk数量*page数量
used_chunks:已被分配的chunk数量
free_chunks:曾经被使用,但是目前被回收的chunk数.
free_chunks_end:从来没被使用的chunk数
mem_requested:请求存储的字节数
active_slabs:活动的slabs.
total_malloced:实际已分配的内存数.

2. stats

