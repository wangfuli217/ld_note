红黑树用于快速查找；
对于超时事件处理而言，红黑树可以快速查找到最近超时时间和最近超时处理对象。       tcpcopy
对于libevent中处理windows的FD事件处理而言，能将无序的FD关联的内容快速查找出来。   libevent
kernel和sheepdog是比较好的红黑树实例。

1. tcpcopy的红黑树和时间事件业务紧密相连，不容易剥离开业务，而且对应相同超时时间事件的处理存在问题。
   libevent的红黑树则是宏定义的扩展，宏调用直接导致红黑树关联对象的代码再次定义，相比kernel和sheepdog而言更隐晦一点。
   kernel和sheepdog的红黑树则是对红黑树数据结构和操作的抽象，红黑树这使得对实例操作和实例数据本身更加统一，容易理解。

双向链表：
1. kernel和tcpcopy是双向循环链表，dnsmasq和redis是双向不循环链表；
2. redis的双向链表数据节点有value字段，用于存储数据；双向链表头结点有dup、free、match函数用于复制，释放和比对。
   tcpcopy的双向链表数据节点有value和key两个字段，用于存储映射关系。头结点len用于显示当前节点存储数据的个数。
   dnsmaq是一个简单的有头有尾的双向不循环链表；
   kernel提供了双向循环链表的抽象。提供了双向链表的所有操作。
3. redis的双向链表为抽象的K-V查找链表；tcpcopy的双向链表为抽象的K-V查找链表，两个链表核心都是从Key到Value的查找，
   redis抽象成统一的value以及value相关的dup,free,match的操作；而tcpcopy则抽象统一的key和value，标明key是整数类型。
   redis和tcpcopy对数据的管理是面向对象，redis双向链表的value是对象，dup,free,match是对象操作函数。
   free可以看作对象的析构函数。
   
   kernel的双向链表是链表和链表操作的抽象，该链表是否为K-V这样对应，还是可以K对应多个Value并没有说明，那个就算是业务了。
   dnsmasq的双向链表则是具体业务的实现，链表的操作和业务仅仅相连。
   

单向链表: moosefs
功能点：从头节点添加、从头节点遍历、从头节点全删除，没有插入                      moosefs中main.c文件对外提供注册函数
功能点：从头节点添加、从头节点遍历、指定删除，没有插入      [无序链表]            用于网络连接管理
功能点：队列类型单向链表<从头删除从尾添加>                  [从头删除从尾添加]    用于接收和发送数据包管理，以及pcqueue.c中消息队列
功能点：哈希类型单向链表<随机添加随机删除>                                        用于大量节点的数据管理                                       

对于队列类型单向列表：可能需要字段有，队列的总长度限制，队列内存总使用量限制，队列的已使用长度，队列已使用内存总使用量。
                      以及队列长度达到总长度限制后，添加节点的处理方法；队列内存使用量达到限制后，添加节点的处理方法。
                      
1. 静态数据操作用数组；
2. 动态数据操作：数据量不大的用单向链表；数据量大的用哈希表；
3. 需要满足头尾都可以插入和删除的使用双向链表，只需要满足队列方式：从尾部添加，从头部删除的用头尾都有指针的单向链表。
4. 在大量数据的情况下，链表的操作效率肯定比hash表和红黑树低。hash表可以存储多个Key相同的数据节点，而红黑树不允许Key相同。
5. 跳表也能实现大数据量的查找和插入操作，且效率和红黑树差不多。
6. moosefs中的fsnode和fsedge所构成的树和红黑树、延展树有很大不同，一个是为了快速查找，一个是为了实现数据存储和数据显示统一。


  
va_list(定制打印输出函数方法)
{
1. C语言的const char *fmt, ...格式对应
    va_start(ap, fmt);
    vsnprintf(err, ANET_ERR_LEN, fmt, ap);
    va_end(ap);
2. C语言的宏ldproxy_config_tracing(format, ...)格式对应
    fprintf(g_host_config_rtu_fp,format, __VA_ARGS__); 
    
3. C语言的宏rtu_noticeex(mod, fmt, args...) 格式对应
    log_writeex(RTU_NOTICE, mod, __func__, __LINE__, fmt, ##args)
即  void log_writeex(int prio, uint32_t module, const char *func, int line, const char *fmt, ...)函数    
}


  
                      
https://en.wikipedia.org/wiki/Linked_list
https://en.wikipedia.org/wiki/Red%E2%80%93black_tree

tcpcopy(rbtree 红黑树)
{
[tc_rbtree.c]  !有点复杂!  定时器处理还是很有意思的
    tc_rbtree.h/tc_rbtree.c  红黑树
    红黑树用来实现超时时间管理。
    初始化  
    tc_event_timer_rbtree       tc_rbtree_t类型根节点
    tc_event_timer_sentinel     tc_rbtree_node_t类型儿子节点
    tc_rbtree_init(&tc_event_timer_rbtree,  &tc_event_timer_sentinel, tc_rbtree_insert_timer_value);  初始化
    tc_rbtree_insert_timer_value  插入函数
    
    tc_event_find_timer(void)                                           tc_rbtree_min   查找最小等待时间
    tc_event_expire_timers(void)                                        tc_rbtree_min   查找超时节点
    tc_event_del_timer(tc_event_timer_t *ev)                            删除某特节点
    tc_event_update_timer(tc_event_timer_t *ev, tc_msec_t timer)        更新超时时间值
    tc_event_add_timer(tc_pool_t *pool, tc_msec_t timer, void *data, tc_event_timer_handler_pt handler) 添加某个节点
      
}

tcpcopy(Circular Linked list 双向循环链表)
{
tc_link_list.h/tc_link_list.c  双向循环链表
    
    

}


tcpcopy(hash 哈希表)
{
tc_hash.h/tc_hash.c            哈希表

}




libevent(rbtree 红黑树 SplayTree 伸展树)
{
关联数值，不能重复的内存数据对象。

[tree.h]  !简单!
    tree.h  红黑树
    RB_PROTOTYPE(name, type, field, cmp)
    RB_PROTOTYPE(event_map, event_entry, node, compare);  定义红黑树数据结构
    RB_GENERATE(event_map, event_entry, node, compare);   定义红黑树函数
    RB_GENERATE(name, type, field, cmp)
    event_map：红黑树名字，关系到调用函数的名称；
    event_entry：关联的数据结构类型，
    node：RB_ENTRY(event_entry) node; 关联数据结构类型的实例。
    compare：比较函数
    
    RB_HEAD(event_map, event_entry) event_root;   红黑树头
    RB_INIT(&winop->event_root);                  初始化红黑树头结点
    RB_ENTRY(event_entry) node;                   红黑树节点
    
    val = RB_FIND(event_map, &op->event_root, &key); 根据key查找event_entry，key实例为只有key字段比较值的event_entry。
          RB_INSERT(event_map, &op->event_root, val); 将val添加到event_root。val为event_entry对象的引用。
          RB_REMOVE(event_map, &win32op->event_root, ent); 根据ent删除event_entry，ent实例为只有key字段。

          
伸展树（Splay Tree）
    假想这么一种情况，我们想要对一个二叉查找树执行一系列的查找操作，为了使整个查找时间更短，那些查
频率比较高的节点就应该经常处于比较靠近树根的位置，于是最直观的想法就是将每次查找访问的节点都放到树根处，
这样再次查找该节点时将会很快的找到该节点。在每次查找访问节点之后对该树进行重构，将被查找的节点搬移到树根，
这种自调整型式的二叉查找树就是splay tree（伸展树），它会沿着从某个被访问节点到树根之间的路径，通过一系列
的旋转把这个被访问节点搬移到树根。
}

libevent(链表：都是指针操作)
{
字符串类或者多个数字关联的，可以重复的内存数据对象。

  链表头        链表节点       初始化链表头 第一个最后一个下一个为空  遍历链表            尾部插入数据         头部插入数据          删除数据
SLIST_HEAD     SLIST_ENTRY     SLIST_INIT    FIRST|END|NEXT|EMPTY  SLIST_FOREACH                            SLIST_INSERT_HEAD     SLIST_REMOVE_HEAD     
LIST_HEAD      LIST_ENTRY      LIST_INIT     FIRST|END|NEXT|EMPTY  LIST_FOREACH                             LIST_INSERT_HEAD      LIST_REMOVE           
SIMPLEQ_HEAD   SIMPLEQ_ENTRY   SIMPLEQ_INIT  FIRST|END|NEXT|EMPTY  SIMPLEQ_FOREACH    SIMPLEQ_INSERT_TAIL   SIMPLEQ_INSERT_HEAD   SIMPLEQ_REMOVE_HEAD   
TAILQ_HEAD     TAILQ_ENTRY     TAILQ_INIT    FIRST|END|NEXT|EMPTY  TAILQ_FOREACH      TAILQ_INSERT_TAIL     TAILQ_INSERT_HEAD     TAILQ_REMOVE          
CIRCLEQ_HEAD   CIRCLEQ_ENTRY   CIRCLEQ_INIT  FIRST|END|NEXT|EMPTY  CIRCLEQ_FOREACH    CIRCLEQ_INSERT_TAIL   CIRCLEQ_INSERT_HEAD   CIRCLEQ_REMOVE        
定义一个结构体 定义一个结构体  初始化操作    指针转换               val为对象指针 

SLIST_HEAD：  单向链表->不支持随机删除和替换；            不支持节点前插入；  不支持尾部插入；  # 静态链表
LIST_HEAD：   单向链表->比SLIST_HEAD需要更多内存。比SIMPLEQ_HEAD需要更多内存。不支持尾部插入。  # hash表
SIMPLEQ_HEAD：尾部入队，头部出队。->不支持随机删除和替换，不支持节点前插入；  支持尾部插入。    # 数据收发队列
TAILQ_HEAD：  双向非循环链表。->                                                                # 内存数据对象
CIRCLEQ_HEAD：双向循环链表。-> 几乎和TAILQ_HEAD功能一样。                                       # 内存数据对象

LIST_HEAD(rtu)：双向循环链表。同CIRCLEQ_HEAD
hlist_head：    双线不循环链表。同LIST_HEAD
}

libevent(min_heap)
{
最小堆，是一种经过排序的完全二叉树，其中任一非终端节点的数据值均不大于其左孩子和右孩子节点的值。
最大堆：根结点的键值是所有堆结点键值中最大者。
最小堆：根结点的键值是所有堆结点键值中最小者。

堆一般是用数组来存储的,也就是说实际存储结构是连续的,只是逻辑上是一棵树的结构.这样做的好处是很容易找到堆顶的元素,
对Libevent来说,很容易就可以找到距当前时间最近的timeout事件.

由于堆这种结构在逻辑上的这种二叉树的关系,其插入也好,删除也好,就是一个与父节点或是子节点比较然后调整位置,这一过程
循环往复直到达到边界条件的过程.记住这一点,就不难写出代码了.
二叉树节点i:父节点为(i-1)/2.子节点为2i+1,2(i+1)。

typedef struct min_heap
{
    struct event** p;
    unsigned n, a;//n队列元素的多少,a代表队列空间的大小. } min_heap_t;
}
min_heap_ctor      初始化
min_heap_dtor      释放
min_heap_elem_init 元素初始化
min_heap_push      添加元素
min_heap_erase     删除元素
min_heap_top       第一个元素 
}

libevent(bufferevent)
{
#
struct event ev_read;  
struct event ev_write;  
struct evbuffer *input;  
struct evbuffer *output;  
……  
bufferevent_data_cb readcb;  
bufferevent_data_cb writecb;  
bufferevent_event_cb errorcb;
#
可以看出struct bufferevent内置了两个event（读/写）和对应的缓冲区。
1. 当有数据被读入(input)的时候，readcb被调用，
2. 当output被输出完成的时候，writecb被调用，
3. 当网络I/O出现错误，如链接中断，超时或其他错误时，errorcb被调用。

1. 设置sock为非阻塞的
evutil_make_socket_nonblocking(fd);
2. 使用bufferevent_socket_new创建一个structbufferevent *bev，关联该sockfd，托管给event_base
bev = bufferevent_socket_new(base, fd, BEV_OPT_CLOSE_ON_FREE);
3. 设置读写对应的回调函数
void bufferevent_setcb(struct bufferevent *bufev,  
    bufferevent_data_cb readcb, bufferevent_data_cb writecb,  
    bufferevent_event_cb eventcb, void *cbarg)  
eg.  bufferevent_setcb(bev, readcb, NULL, errorcb, NULL);
4. 启用读写事件,其实是调用了event_add将相应读写事件加入事件监听队列poll。正如文档所说，如果相应事件不置为true，bufferevent是不会读写数据的
int bufferevent_enable(struct bufferevent *bufev, short event) 
5. 进入bufferevent_setcb回调函数：
在readcb里面从input中读取数据，处理完毕后填充到output中；
writecb对于服务端程序，只需要readcb就可以了，可以置为NULL；
errorcb用于处理一些错误信息。

char *evbuffer_readln(struct evbuffer*buffer, size_t *n_read_out,enum evbuffer_eol_style eol_style);
返回值：读到的一行内容
int evbuffer_add(struct evbuffer *buf,const void *data, size_t datlen);
含义：将数据添加到evbuffer的结尾
返回值：成功返回0，失败返回-1
int evbuffer_remove(struct evbuffer*buf, void *data, size_t datlen);  
含义：从evbuffer读取数据到data
返回值：成功返回0，失败返回-1
size_t evbuffer_get_length(const structevbuffer *buf); 
含义：返回evbuffer中存储的字节长度
}
kernel(rttree 红黑树)
{
[rbtree.h] !简单!
    struct mytype {                                             关联节点
        struct rb_node node;                        
        char *keystring;                        
    };                      
                            
 struct rb_root mytree = RB_ROOT;                               根节点
 
struct mytype *my_search(struct rb_root *root, char *string)    查找
{ 
    struct rb_node *node = root->rb_node;
    
#    while (node) { 
    struct mytype *data = container_of(node, struct mytype, node); 
    int result;
    
    result = strcmp(string, data->keystring);
    
    if (result < 0) 
        node = node->rb_left; 
    else if (result > 0) 
        node = node->rb_right; 
    else 
        return data; 
    }
    return NULL; 
}
 
int my_insert(struct rb_root *root, struct mytype *data)        插入
{ 
    struct rb_node **new = &(root->rb_node), *parent = NULL;
    /* Figure out where to put new node */
    
#    while (*new) { 
        struct mytype *this = container_of(*new, struct mytype, node);
        int result = strcmp(data->keystring, this->keystring);
        parent = *new; 
        if (result < 0) 
            new = &((*new)->rb_left); 
        else if (result > 0) 
            new = &((*new)->rb_right); 
        else return FALSE; 
    }
    /* Add new node and rebalance tree. */
    rb_link_node(&data->node, parent, new);
    rb_insert_color(&data->node, root);
    return TRUE;
}

void rb_erase(struct rb_node *victim, struct rb_root *tree);        删除

void rb_replace_node(struct rb_node *old, struct rb_node *new, struct rb_root *tree); 替换


struct rb_node *rb_first(struct rb_root *tree);  遍历
struct rb_node *rb_last(struct rb_root *tree);
struct rb_node *rb_next(struct rb_node *node);
struct rb_node *rb_prev(struct rb_node *node);

struct rb_node *node; for (node = rb_first(&mytree); node; node = rb_next(node))  遍历实例
    printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
}


sheepdog(rbtree 红黑树)
{
rbtree.c
static struct rb_root events_tree = RB_ROOT;

rb_search(&events_tree, &key, rb, event_cmp);
rb_insert(&events_tree, ei, rb, event_cmp);
rb_erase(&ei->rb, &events_tree);
rb_for_each_entry(method, &mock_methods, rb)
rb_for_each(pos, root)
rb_destroy(root, type, member)
rb_copy(root, type, member, outroot, compar)


管理根节点类型rb_root；关联根节点实例events_tree；
关联节点类型rb_node；关联节点实例rb；比较节点函数event_cmp；
相关函数rb_search；rb_insert；rb_erase
struct event_info {
    event_handler_t handler;
    int fd;
    void *data;
    struct rb_node rb;
    int prio;
};
}


sheepdog(bitmap 位图)
{
ffs, ffsl, ffsll - find first bit set in a word
#include <strings.h>
int ffs(int i);
#define _GNU_SOURCE
#include <string.h>
int ffsl(long int i);
int ffsll(long long int i);

修改申请bitmap的长度，初次申请old_bmap为NULL，old_bits为0即可。new_bits是要申请的bitmap的长度。
unsigned long *alloc_bitmap(unsigned long *old_bmap, size_t old_bits, size_t new_bits)

查找bitmap中下一个bit位为0的位置信息
unsigned long find_next_zero_bit(const unsigned long *addr,unsigned long size, unsigned long offset)

查找bitmap中下一个bit位为1的位置信息
unsigned long find_next_bit(const unsigned long *addr,  unsigned long size,  unsigned long offset)

设置指定bit为1.
void set_bit(int nr, unsigned long *addr)

测试指定bit是否为1
int test_bit(unsigned int nr, const unsigned long *addr)

设置指定bit为0.
void clear_bit(unsigned int nr, unsigned long *addr)
}

redis(rbtree 红黑树)
{
rb.h红黑树

}

redis(bitmap 位图)
{
测试指定bit是否为1
int bitmapTestBit(unsigned char *bitmap, int pos) 
设置指定bit为1.
void bitmapSetBit(unsigned char *bitmap, int pos) 
设置指定bit为0.
void bitmapClearBit(unsigned char *bitmap, int pos) 
}

redis(adlist 双向不循环操作k-v对象管理链表)
{
adlist.c 独立可移植 # 
adlist.c  listCreate   listRelease  listAddNodeHead  listAddNodeTail  listInsertNode  listDelNode  listDup  listSearchKey  listIndex
相比于libevent的TAILQ_HEAD，指明功能是key-value形式的，并实现了listSearchKey和listIndex两个函数。
同时1. 增加了listDup这个函数，用于实现链表的复制。2. listIter，在C++语言中成为迭代器。

dict.c 独立可移植 # 命令的快速查找，缓存已执行命令同步 键值对 订阅通知链接等等
dict.c    dictCreate  dictRelease  dictAdd  dictDelete  dictFind  dictFetchValue  dictResize dictExpand dictRehash
moosefs的CREATE_BUCKET_ALLOCATOR而言，moosefs将多次小块内存申请聚合成一块大内存申请，同时重复利用已释放的内存。提高内存利用率。
相比于moosefs：指明功能是key-value形式的，并实现了dictFind和dictFetchValue。
dictResize dictExpand dictRehash这三个函数为hash功能的应用函数。

moosefs中csdb.c conncache.c dirattrcache.c matoclserv.c  strerr.c xattrcache.c为静态哈希表，不会自动扩展。
moosefs中chunk.c为动态哈希表，可以自动扩展
CREATE_BUCKET_ALLOCATOR为内存池。

t_zset.c 难独立可移植 # t_zset.c redis.h dict.c和dicht.h networking.c等等，耦合极深
其他都很独立出来
}

moosefs(Singly linked list 单向链表)
{
1. moosefs 1.6 输入处理没有链表；2.0 以后输入处理增加了链表；1.6 报文数据接收和处理在read中完成；2.0 以后报文数据接收在read中完成，处理在parse中完成。
           1.6 输入数据阻塞在socket缓冲区，增加了poll查询数据的时间；2.0 输入数据缓冲在read函数的缓冲区中，减少了poll查询数据的时间。
2. moosefs 单向链表有的核心操作是轮询；有的核心操作是随机插入|删除；有的核心操作是从尾插入，从头删除。  
           如果单条链表比较长，就要考虑哈希链表，哈希链表要考虑动态扩展的问题。       
3. moosefs 将socket连接和数据报文队列缓冲起来，能更好的实现数据报文处理。

Singly(添加、遍历、全删除，没有插入){}
-------------------------添加、遍历、全删除，没有插入------------------------------
[main.c]
回调函数的注册：                        <添加>
void main_destruct_register (void (*fun)(void));
void main_canexit_register (int (*fun)(void));
void main_wantexit_register (void (*fun)(void));
void main_reload_register (void (*fun)(void));
void main_info_register (void (*fun)(void));
void main_chld_register (pid_t pid,void (*fun)(int));
void main_keepalive_register (void (*fun)(void));
void main_poll_register (void (*desc)(struct pollfd *,uint32_t *),void (*serve)(struct pollfd *));
void main_eachloop_register (void (*fun)(void));
void* main_msectime_register (uint32_t mseconds,uint32_t offset,void (*fun)(void));
int main_msectime_change(void* x,uint32_t mseconds,uint32_t offset);
void* main_time_register (uint32_t seconds,uint32_t offset,void (*fun)(void));
int main_time_change(void *x,uint32_t seconds,uint32_t offset);

void mainloop()                        <遍历>
int canexit()                          <遍历>
void destruct(void)                    <遍历>
void main_keep_alive(void)             <遍历>

void free_all_registered_entries(void) <删除>

-------------------------添加、遍历、全删除，没有插入------------------------------

Singly(添加、遍历、指定删除，没有插入){}
-------------------------添加、遍历、指定删除，没有插入------------------------------
typedef struct csserventry          void matoclserv_disconnection_loop(void) 指定删除
typedef struct masterconn           无指定删除
typedef struct masterconn           无指定删除
typedef struct matoclserventry      void matoclserv_disconnection_loop(void) 指定删除
typedef struct matocsserventry      void matocsserv_disconnection_loop(void) 指定删除
typedef struct matomlserventry      void matomlserv_disconnection_loop(void) 指定删除
typedef struct _finfo

-------------------------添加、遍历、指定删除，没有插入------------------------------

Singly(队列类型单向链表<从头删除从尾添加>){}
-------------------------队列类型单向链表<从头删除从尾添加>------------------------------
in_packetstruct *input_packet;              输入数据数据报文。
in_packetstruct *inputhead,**inputtail;     数据数据数据报文链表。 从头删除从尾添加.
out_packetstruct *outputhead,**outputtail;  数据数据数据报文链表。 从头删除从尾添加.

1. 初始化：
eptr->inputhead = NULL;
eptr->inputtail = &(eptr->inputhead);

2. 从尾添加
eptr->input_packet不为NULL的情况下：
*(eptr->inputtail) = eptr->input_packet;
eptr->inputtail = &(eptr->input_packet->next);
          
3. 从头删除         
ipack = eptr->inputhead
eptr->inputhead = ipack->next;
如果eptr->inputhead为NULL则；eptr->inputtail = &(eptr->inputhead);

1. 初始化：
eptr->outputhead = NULL;
eptr->outputtail = &(eptr->outputhead);

2. 从尾添加
eptr->input_packet不为NULL的情况下：
*(eptr->outputtail) = outpacket;
eptr->outputtail = &(outpacket->next);

3. 从头删除  
opack = eptr->outputhead;
eptr->outputhead = opack->next;

-------------------------队列类型单向链表<从头删除从尾添加>------------------------------


-------------------------哈希类型单向链表<随机添加随机删除>------------------------------
typedef struct _fsedge 
typedef struct _fsnode 
typedef struct chunk
typedef struct chunk
    struct chunk *testnext,**testprev; 用于检测函数
    struct chunk *next;                用于连接所有hash类型的


1. 删除操作
# while ((cit=*chptr)!=NULL) {
#         if (cit==c) {
#             *chptr = c->next;
#             chunkhashelem--;
#             return;
#         }
#         chptr = &(cit->next);
#     }

-------------------------哈希类型单向链表<随机添加随机删除>------------------------------


}

kernel(Doubly linked list 双向链表)
{
list.h <list_head>  双线循环链表
list.h <hlist_node>  多用于hash类型的双线


}

moosefs(Multiply linked list 多重链表)
{


}

redis(Doubly linked list 双向链表)
{
adlist.h <listNode>  双线非循环链表



}