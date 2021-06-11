#define DATA_BUFFER_SIZE 2048
#define UDP_READ_BUFFER_SIZE 65536
#define UDP_MAX_PAYLOAD_SIZE 1400
#define UDP_HEADER_SIZE 8
#define MAX_SENDBUF_SIZE (256 * 1024 * 1024)
/* I'm told the max length of a 64-bit num converted to string is 20 bytes.
 * Plus a few for spaces, \r\n, \0 */
#define SUFFIX_SIZE 24

/** Initial size of list of items being returned by "get". */
#define ITEM_LIST_INITIAL 200

/** Initial size of list of CAS suffixes appended to "gets" lines. */
#define SUFFIX_LIST_INITIAL 20

/** Initial size of the sendmsg() scatter/gather array. */
#define IOV_LIST_INITIAL 400

/** Initial number of sendmsg() argument structures to allocate. */
#define MSG_LIST_INITIAL 10

/** High water marks for buffer shrinking */
#define READ_BUFFER_HIGHWAT 8192
#define ITEM_LIST_HIGHWAT 400
#define IOV_LIST_HIGHWAT 600
#define MSG_LIST_HIGHWAT 100


#define ITEM_UPDATE_INTERVAL 60

#define POWER_SMALLEST 1  
#define POWER_LARGEST  200  
#define CHUNK_ALIGN_BYTES 8  
#define MAX_NUMBER_OF_SLAB_CLASSES (POWER_LARGEST + 1)  

#define TAIL_REPAIR_TIME_DEFAULT 0

#define ITEM_key(item) (((char*)&((item)->data)) \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define ITEM_suffix(item) ((char*) &((item)->data) + (item)->nkey + 1 \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define ITEM_data(item) ((char*) &((item)->data) + (item)->nkey + 1 \
         + (item)->nsuffix \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))

#define ITEM_ntotal(item) (sizeof(struct _stritem) + (item)->nkey + 1 \
         + (item)->nsuffix + (item)->nbytes \
         + (((item)->it_flags & ITEM_CAS) ? sizeof(uint64_t) : 0))


enum protocol {
    ascii_prot = 3, /* arbitrary value. */
    binary_prot,
    negotiating_prot /* Discovering the protocol */
};

enum item_lock_types {
    ITEM_LOCK_GRANULAR = 0, //段级锁
    ITEM_LOCK_GLOBAL//全局锁
};

#define ITEM_LINKED 1 //该item插入到LRU队列了  
#define ITEM_CAS 2 //该item使用CAS  
#define ITEM_SLABBED 4 //该item还在slab的空闲队列里面，没有分配出去  
#define ITEM_FETCHED 8 //该item插入到LRU队列后，被worker线程访问过 

//Item 缓存数据存储的基本单元
//1. Item是Memcached存储的最小单位
//2. 每一个缓存都会有自己的一个Item数据结构
//3. Item主要存储缓存的key、value、key的长度、value的长度、缓存的时间等信息。
//4. HashTable和LRU链表结构都是依赖Item结构中的元素的。
typedef struct _stritem {  
    //记录下一个item的地址,主要用于LRU链和freelist链  
    struct _stritem *next;  
    //记录下一个item的地址,主要用于LRU链和freelist链  
    struct _stritem *prev;  
    //记录HashTable的下一个Item的地址  
    struct _stritem *h_next;  
    //最近访问的时间，只有set/add/replace等操作才会更新这个字段  
    //当执行flush命令的时候，需要用这个时间和执行flush命令的时间相比较，来判断是否失效  
    rel_time_t      time;//最后一次访问时间。绝对时间
    //缓存的过期时间。设置为0的时候，则永久有效。  
    //如果Memcached不能分配新的item的时候，设置为0的item也有可能被LRU淘汰  
    rel_time_t      exptime;//过期失效时间，绝对时间
    //value数据大小  
    int             nbytes;//本item存放的数据的长度
    //引用的次数。通过这个引用的次数，可以判断item是否被其它的线程在操作中。  
    //也可以通过refcount来判断当前的item是否可以被删除，只有refcount -1 = 0的时候才能被删除  
    unsigned short  refcount;  
    uint8_t         nsuffix;//后缀长度
    uint8_t         it_flags;//item属性
    //slabs_class的ID。  
    uint8_t         slabs_clsid;//item属于哪个slab_class
    uint8_t         nkey;//key长度       /* key length, w/terminating null and padding */  
    /* this odd type prevents type-punning issues when we do 
     * the little shuffle to save space when not using CAS. */  
    //数据存储结构  
    union {  
        uint64_t cas;  
        char end;  
    } data[];  
    /* if it_flags & ITEM_CAS we have 8 bytes CAS */  
    /* then null-terminated key */  
    /* then " flags length\r\n" (no terminating null) */  
    /* then data with terminating \r\n (no terminating null; it's binary!) */  
} item;  

//伪item：
//memcached为了实现随机访问，使用了一个很巧妙的方法。它在LRU队列尾部插入一个伪item，然后驱动这个伪item向队列头部前进，每次前进一位。

//这个伪item是全局变量，LRU爬虫线程无须从LRU队列头部或者尾部遍历就可以直接访问这个伪item。
//通过这个伪item的next和prev指针，就可以访问真正的item。
//于是，LRU爬虫线程无需遍历就可以直接访问LRU队列中间的某一个item。

//这个结构体和item结构体长得很像,是伪item结构体，用于LRU爬虫
typedef struct {  
    struct _stritem *next;  
    struct _stritem *prev;  
    struct _stritem *h_next;    /* hash chain next */  
    rel_time_t      time;       /* least recent access */  
    rel_time_t      exptime;    /* expire time */  
    int             nbytes;     /* size of data */  
    unsigned short  refcount;  
    uint8_t         nsuffix;    /* length of flags-and-length string */  
    uint8_t         it_flags;   /* ITEM_* above */  
    uint8_t         slabs_clsid;/* which slab class we're in */  
    uint8_t         nkey;       /* key length, w/terminating null and padding */  
    uint32_t        remaining;  /* Max keys to crawl per slab per invocation */  
} crawler;  

//为worker线程构建CQ队列：
//主线程又是怎么访问各个worker线程的CQ队列呢？
//在C语言里面的答案当然是使用全局变量啦。memcached专门定义了结构体，如下：

//看到LIBEVENT_THREAD结构体的这些成员，完全可以顾名思义。
//memcached定义了LIBEVENT_THREAD类型的一个全局变量指针threads。
//当确定了memcached有多少个worker线程后，就会动态申请一个LIBEVENT_THREAD数组，
//并让threads指向其。于是每一个worker线程都对应有一个LIBEVENT_THREAD结构体。
//主线程通过全局变量threads就可以很方便地访问每一个worker线程的CQ队列和通信管道。
typedef struct {
    pthread_t thread_id; //线程id        
    struct event_base *base; //线程所使用的event_base   
    struct event notify_event;//用于监听管道读事件的event  
    int notify_receive_fd; //管道的读端fd  
    int notify_send_fd;   //管道的写端fd  
    struct thread_stats stats;  /* Stats generated by this thread */
    struct conn_queue *new_conn_queue; /* queue of new connections to handle */
    cache_t *suffix_cache;      /* suffix cache */
    uint8_t item_lock_type;     /* use fine-grained or global item lock */
} LIBEVENT_THREAD;

typedef struct conn conn;

struct conn {
    int    sfd;//该conn对应的socket fd
    sasl_conn_t *sasl_conn;
    bool authenticated;
    enum conn_states  state;
    enum bin_substates substate;
    rel_time_t last_cmd_time;
    struct event event;//该conn对应的event
    short  ev_flags;//event当前监听的事件类型
    short  which;   /** which events were just triggered */ //触发event回调函数的原因
	//读缓冲区
    char   *rbuf;   /** buffer to read commands into */
	//有效数据的开始位置。从rbuf到rcurr之间的数据是已经处理的了，变成无效数据了
    char   *rcurr;  /** but if we parsed some already, this is where we stopped */
	//读缓冲区的总长度 
    int    rsize;   /** total allocated size of rbuf */
	//有效数据的长度。初始值为0
    int    rbytes;  /** how much data, starting from rcur, do we have unparsed */

    char   *wbuf;
    char   *wcurr;
    int    wsize;
    int    wbytes;
    /** which state to go into after finishing current write */
    enum conn_states  write_and_go;
    void   *write_and_free; /** free this memory after finishing writing */

	//数据直通车  
    char   *ritem;  /** when we read in an item's value, it goes here */
    int    rlbytes;

    /* data for the nread state */

    /**
     * item is used to hold an item structure created after reading the command
     * line of set/add/replace commands, but before we finished reading the actual
     * data. The data is read into ITEM_data(item) to avoid extra copying.
     */

    void   *item;     /* for commands set/add/replace  */

    /* data for the swallow state */
    int    sbytes;    /* how many bytes to swallow */

    //ensure_iov_space函数会扩大数组长度.下面的msglist数组所使用到的  
    //iovec结构体数组就是iov指针所指向的。所以当调用ensure_iov_space  
    //分配新的iovec数组后，需要重新调整msglist数组元素的值。这个调整  
    //也是在ensure_iov_space函数里面完成的  
    /* data for the mwrite state */
    struct iovec *iov;//iovec数组指针  
    int    iovsize;   /* number of elements allocated in iov[] */ //数组大小  
    int    iovused;   /* number of elements used in iov[] */    //已经使用的数组元素个数  

    //因为msghdr结构体里面的iovec结构体数组长度是有限制的。所以为了能  
    //传输更多的数据，只能增加msghdr结构体的个数.add_msghdr函数负责增加  
    struct msghdr *msglist;//指向msghdr数组  
    //数组大小  
    int    msgsize;   /* number of elements allocated in msglist[] */  
    //已经使用了的msghdr元素个数  
    int    msgused;   /* number of elements used in msglist[] */  
    //正在用sendmsg函数传输msghdr数组中的哪一个元素  
    int    msgcurr;   /* element in msglist[] being transmitted now */  
    //msgcurr指向的msghdr总共有多少个字节  
    int    msgbytes;  /* number of bytes in current msg */  


    //worker线程需要占有这个item，直至把item的数据都写回给客户端了  
    //故需要一个item指针数组记录本conn占有的item  
    item   **ilist;   /* list of items to write out */  
    int    isize;//数组的大小  
    item   **icurr;//当前使用到的item(在释放占用item时会用到)  
    int    ileft;//ilist数组中有多少个item需要释放  

    char   **suffixlist;
    int    suffixsize;
    char   **suffixcurr;
    int    suffixleft;

    enum protocol protocol;   /* which protocol this connection speaks */
    enum network_transport transport; /* what transport is used by this connection */

    /* data for UDP clients */
    int    request_id; /* Incoming UDP request ID, if this is a UDP "connection" */
    struct sockaddr_in6 request_addr; /* udp: Who sent the most recent request */
    socklen_t request_addr_size;
    unsigned char *hdrbuf; /* udp packet headers */
    int    hdrsize;   /* number of headers' worth of space is allocated */

    bool   noreply;   /* True if the reply should not be sent. */
    /* current stats command */
    struct {
        char *buffer;
        size_t size;
        size_t offset;
    } stats;

    /* Binary protocol stuff */
    /* This is where the binary header goes */
    protocol_binary_request_header binary_header;
    uint64_t cas; /* the cas to return */
    short cmd; /* current command being processed */
    int opaque;
    int keylen;
    conn   *next;     /* Used for generating a list of conn structures */
	//这个conn属于哪个worker线程 
    LIBEVENT_THREAD *thread; /* Pointer to the thread object serving this connection */
};// end struct conn{..};

struct slab_rebalance {  
    //记录要移动的页的信息。slab_start指向页的开始位置。slab_end指向页  
    //的结束位置。slab_pos则记录当前处理的位置(item)  
    void *slab_start;  
    void *slab_end;  
    void *slab_pos;  
    int s_clsid; //源slab class的下标索引  
    int d_clsid; //目标slab class的下标索引  
    int busy_items; //是否worker线程在引用某个item  
    uint8_t done;//是否完成了内存页移动  
};  

