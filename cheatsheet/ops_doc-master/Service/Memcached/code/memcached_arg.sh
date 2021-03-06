main()
{
"a:" //unix socket的权限位信息，unix socket的权限位信息和普通文件的权限位信息一样
"p:" //memcached监听的TCP端口值，默认是11211
"s:" //unix socket监听的socket文件路径
"U:" //memcached监听的UDP端口值，默认是11211
"m:" //memcached使用的最大内存值，默认是64M
"M"  //当memcached的内存使用完时，不进行LRU淘汰数据，直接返回错误，该选项就是关闭LRU
"c:" //memcached的最大连接数,如果不指定，按系统的最大值进行
"k"  //是否锁定memcached所持有的内存，如果锁定了内存，其他业务持有的内存就会减小
"hi" //帮助信息
"r"  //core文件的大小，如果不指定，按系统的最大值进行
"v"  //调试信息
"v  " //提示信息（在事件循环中打印错误/警告信息。）
"vv " //详细信息（还打印客户端命令/响应）
"vvv" //超详细信息（还打印内部状态的变化）
"d"  //设定以daemon方式运行
"l:" //绑定的ip信息，如果服务器有多个ip，可以在多个ip上面启动多个Memcached实例，注意：这个不是可接收的IP地址
"u:" //memcached运行的用户，如果以root启动，需要指定用户，否则程序错误，退出。
"P:" //memcached以daemon方式运行时，保存pid的文件路径信息
"f:" //内存的扩容因子，这个关系到Memcached内部初始化空间时的一个变化，后面详细说明
"n:" //chunk的最小大小(byte)，后续的增长都是该值*factor来进行增长的
"t:" //内部worker线程的个数，默认是4个，最大值推荐不超过64个
"D:" //内部数据存储时的分割符
"L"  //指定内存页的大小，默认内存页大小为4K，页最大不超过2M，调大页的大小，可有效减小页表的大小,提高内存访问的效率
"R:" //单个worker的最大请求个数
"C"  //禁用业务的cas,即compare and set
"b:" //listen操作缓存连接个数
"B:" //ascii,binary,auto（默认）
"I:" //单个item的最大值，默认是1M,可以修改，修改的最小值为1k,最大值不能超过128M
"S"  //打开sasl安全协议
"o:" //有四个参数项可以设置:
 maxconns_fast(如果连接数超过最大连接数，立即关闭新的连接)
 hashpower(hash表的大小的指数值，是按1 hashpower来创建hash表的，默认的hashpower为16，配置值建议不超过64)
 slab_reassign（是否调整/平衡各个slab所占的内存）
 slab_automove（是否自动移动各个slab，如果该选项打开，会有专门的线程来进行slab的调整）

}

setting()
{
Memcached内部是通过settings来抽象上面的这些初始化参数。
struct settings {  
    size_t maxbytes;  
    int maxconns;  
    int port;  
    int udpport;  
    char *inter;  
    int verbose;  
    rel_time_t oldest_live; /* ignore existing items older than this */  
    int evict_to_free;  
    char *socketpath;   /* path to unix socket if using local socket */  
    int access;  /* access mask (a la chmod) for unix domain socket */  
    double factor;          /* chunk size growth factor */  
    int chunk_size;  
    int num_threads;        /* number of worker (without dispatcher) libevent threads to run */  
    int num_threads_per_udp; /* number of worker threads serving each udp socket */  
    char prefix_delimiter;  /* character that marks a key prefix (for stats) */  
    int detail_enabled;     /* nonzero if we are collecting detailed stats */  
    int reqs_per_event;     /* Maximum number of io to process on each 
                               io-event. */  
    bool use_cas;  
    enum protocol binding_protocol;  
    int backlog;  
    int item_size_max;        /* Maximum item size, and upper end for slabs */  
    bool sasl;              /* SASL on/off */  
    bool maxconns_fast;     /* Whether or not to early close connections */  
    bool slab_reassign;     /* Whether or not slab reassignment is allowed */  
    int slab_automove;     /* Whether or not to automatically move slabs */  
    int hashpower_init;     /* Starting hash power level */  
};


I                   item_size_max
-o slab_chunk_max   slab_chunk_size_max
                    slab_page_size=1024*1024
slab_chunk_size_max大于item_size_max
item_size_max%slab_chunk_size_max==0
slab_page_size%slab_chunk_size_max==0


}
settings_init(){}
static void settings_init(void)  
{  
    settings.use_cas = true;  
    settings.access = 0700;  
    settings.port = 11211;  
    settings.udpport = 11211;  
    /* By default this string should be NULL for getaddrinfo() */  
    settings.inter = NULL;  
    settings.maxbytes = 64 * 1024 * 1024; /* default is 64MB */  
    settings.maxconns = 1024; /* to limit connections-related memory to about 5MB */  
    settings.verbose = 0;  
    settings.oldest_live = 0;  
    settings.evict_to_free = 1; /* push old items out of cache when memory runs out */  
    settings.socketpath = NULL; /* by default, not using a unix socket */  
    settings.factor = 1.25;  
    settings.chunk_size = 48; /* space for a modest key and value */  
    settings.num_threads = 4; /* N workers */  
    settings.num_threads_per_udp = 0;  
    settings.prefix_delimiter = ':';  
    settings.detail_enabled = 0;  
    settings.reqs_per_event = 20;  
    settings.backlog = 1024;  
    settings.binding_protocol = negotiating_prot;  
    settings.item_size_max = 1024 * 1024; /* The famous 1MB upper limit. */  
    settings.maxconns_fast = false;  
    settings.hashpower_init = 0;  
    settings.slab_reassign = false;  
    settings.slab_automove = 0;  
}

