Memcached中Master线程和Worker线程之间通信连接信息时，是通过连接队列来通信的，即Master线程投递一个消息到Worker线程的连接队列中，Worker线程从连接队列中读取链接信息来执行连接操作，下面我们简单分析下Memcached的连接队列结构。

typedef struct conn_queue_item CQ_ITEM;//每个连接信息的封装  
struct conn_queue_item {  
    int               sfd;//accept之后的描述符  
    enum conn_states  init_state;//连接的初始状态  
    int               event_flags;//libevent标志  
    int               read_buffer_size;//读取数据缓冲区大小  
    enum network_transport     transport;//内部通信所用的协议  
    CQ_ITEM          *next;//用于实现链表的指针  
};  
typedef struct conn_queue CQ;//连接队列的封装  
struct conn_queue {  
    CQ_ITEM *head;//头指针，注意这里是单链表，不是双向链表  
    CQ_ITEM *tail;//尾部指针，  
    pthread_mutex_t lock;//锁  
    pthread_cond_t  cond;//条件变量  
};


//释放item，也就是将item添加到空闲链表中  
static void cqi_free(CQ_ITEM *item)

//创建连接队列  
static CQ_ITEM *cqi_new(void)

//添加一个连接信息  
static void cq_push(CQ *cq, CQ_ITEM *item)

//获取一个连接  
static CQ_ITEM *cq_pop(CQ *cq)

//连接队列初始化
static void cq_init(CQ *cq)


