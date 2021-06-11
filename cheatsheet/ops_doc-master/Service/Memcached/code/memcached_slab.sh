 http://jiangbo.me/blog/2012/08/31/something-about-memcache-internal/
 
    Memcached作为内存cache服务器，内存高效管理是其最重要的任务之一，Memcached使用SLAB管理其内存，SLAB内存管理直观的解释就是
分配一块大的内存，之后按不同的块（48byte,64byte,...1M）等切分这些内存，存储业务数据时，按需选择合适的内存空间存储数据。

    Memcached首次默认分配64M的内存，之后所有的数据都是在这64M空间进行存储，在Memcached启动之后，不会对这些内存执行释放操作，
这些内存只有到Memcached进程退出之后会被系统回收，

Memcached内部维护了一个内存池来减少频繁的malloc和free，在该内存池的基础上面实现了slab内存管理，


//内存初始化，settings.maxbytes是Memcached初始启动参数指定的内存值大小,settings.factor是内存增长因子  
slabs_init(settings.maxbytes, settings.factor, preallocate);  
  
#define POWER_SMALLEST 1   //最小slab编号  
#define POWER_LARGEST  200 //首次初始化200个slab  
  
//实现内存池管理相关的静态全局变量  
static size_t mem_limit = 0;//总的内存大小  
static size_t mem_malloced = 0;//初始化内存的大小，这个貌似没什么用  
static void *mem_base = NULL;//指向总的内存的首地址  
static void *mem_current = NULL;//当前分配到的内存地址  
static size_t mem_avail = 0;//当前可用的内存大小  
  
static slabclass_t slabclass[MAX_NUMBER_OF_SLAB_CLASSES];//定义slab结合，总共200个


//创建空闲item  
static void do_slabs_free(void *ptr, const size_t size, unsigned int id)

//将ptr指向的内存空间按第id个slabclass的size进行切分  
static void split_slab_page_into_freelist(char *ptr, const unsigned int id)

//从内存池分配size个空间  
static void *memory_allocate(size_t size)

//初始化slabclass的slab_class,而slab_list中的指针指向每个slab,id为slabclass的序号  
static int grow_slab_list (const unsigned int id)

//执行分配操作  
static int do_slabs_newslab(const unsigned int id)

//分配每个slab的内存空间  
static void slabs_preallocate (const unsigned int maxslabs)

slab(graph)
{
Item、Chunk、Page、Slab
Data Item
+---------------------------------------+
|  key-value | cas | suffix | item head |  
+---------------------------------------+
Item指实际存放到memcache中的数据对象结构，除key-value数据外，还包括memcache自身对数据对象的描述信息（Item=key+value+后缀长+32byte结构体）

Chunk
Chunk指Memcache用来存放Data Item的最小单元，同一个Slab中的chunk大小是固定的。
+------------------------------+
|   data item    | empty space |
+------------------------------+

Page
+-------------------------------------+
|  chunk1 | chunk2 | chunk3 | chunk4  |
+-------------------------------------+
每个Slab中按照Page来申请内存，Page的大小默认为1M，可以通过-l参数调整，最小1k，最大128m.

Slab
+--------------------------------+
|  Page1 | Page2 | Page3 | Page4 |
+--------------------------------+
Memcache将分配给它的内存（-m 参数指定，默认64m）按照Chunk大小不同，划分为多个slab。

他们三者的关系如下图所示:

                 Chunk
                   ^                                                         
+------------------|------------------------------------------------------------+
|   Memory         |                                                            | 
|  +---------------|---------------------------------------------------------+  |
|  |      +--------|---------------------+  +------------------------------+ |  |
|  |      |Page1 +-|---+ +-----+ +-----+ |  |Page2 +-----+ +-----+ +-----+ | |  |
|  | Slab |(1M)  | 96B | | 68B | | 72B | |  |(1M)  | 92B | | 76B | | 84B | | |  | 
|  |  1   |      +-----+ +-----+ +-----+ |  |      +-----+ +-----+ +-----+ | |  |
|  |      +------------------------------+  +------------------------------+ |  |
|  +-------------------------------------------------------------------------+  |
|                                                                               |
|  +-------------------------------------------------------------------------+  |
|  |      +------------------------------+  +------------------------------+ |  |
|  |      |Page1 +------+    +------+    |  |Page2 +------+    +-------+   | |  |
|  | Slab | (1M) | 128B |    | 120B |    |  |(1M)  | 128B |    | 97B   |   | |  |
|  |   2  |      +------+    +------+    |  |      +------+    +-------+   | |  |
|  |      +------------------------------+  +------------------------------+ |  |
|  +-------------------------------------------------------------------------+  |
+-------------------------------------------------------------------------------+


数据存储过程

一个数据项的大致存储量过程可以理解为（完整代码较长，不在粘贴，具体可参见items.c中do_item_alloc()方法）：

1. 构造一个数据项结构体，计算数据项的大小，（假设默认配置下，数据项大小为102B）
2. 根据数据项的大小，找到最合适的slab，（100<102<125，所以存储在slab3中）
3. 检查该slab中是否有过期的数据，如有清理掉
4. 如果没有过期的数据项，则从当前slab中申请空间，参见slabs.c中slab_alloc()方法。
5. 如果当前slab中申请失败，则尝试根据LRU算法逐出一个数据项，默认memcache是允许逐出的，如果被设置为禁止逐出，那么这是会反生悲剧的oom了
6. 获取到item空间后将数据存储到改空间中，并追加到该slab的item列表中

内存浪费
根据上述描述，Memcache使用Slab预分配的方式进行内存管理提升了性能（减少分配内存的消耗），但是带来了内存浪费，主要体现在：
    1. Data Item Size <= Chunk Size，Chunk是存储数据项的最小单元，数据项的大小必须不大于其所在的Chunk大小。也就是说76B的数据对象存入96B的Chunk中，将带来96B-76B=20B的空间浪费。
    2. Memcache是按照Page申请和使用内存的，当Page大小不是Chunk的整数倍时，余下的空间将被浪费。即如果PageSize=1M，ChunkSize=1000B,那么将有1024*1024%1000=576B的空间浪费。
    3. Memcache默认是不开启slab reasign的，也就是说分配已经分配给一个slab的内存空间，即使该slab不用，默认也不会分配给其他slab的
}
