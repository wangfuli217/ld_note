#include "memcached.h"
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/signal.h>
#include <sys/resource.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <pthread.h>

static pthread_mutex_t slabs_lock = PTHREAD_MUTEX_INITIALIZER;

//slabclass 划分数据空间 
//1.Memcached在启动的时候，会初始化一个slabclass数组，该数组用于存储最大200个slabclass_t的数据结构体。
//2.Memcached并不会将所有大小的数据都会放置在一起，而是预先将数据空间划分为一系列的slabclass_t。
//3.每个slabclass_t，都只存储一定大小范围的数据。
//slabclass数组中，前一个slabclass_t可以存储的数据大小要小于下一个slabclass_t结构可以存储的数据大小。
//4.例如：slabclass[3]只存储大小介于120 （slabclass[2]的最大值）到 150 bytes的数据。
//如果一个数据大小为134byte将被分配到slabclass[3]中。
//5.memcached默认情况下下一个slabclass_t存储数据的最大值为前一个的1.25倍（settings.factor），这个可以通过修 改-f参数来修改增长比例

//确定slab分配器的分配规格：
//现在来看一下memcached是怎么确定slab分配器的分配规格的。因为memcached使用了全局变量，先来看一下全局变量
typedef struct {  
    //当前的slabclass存储最大多大的item  
    unsigned int size;//slab分配器分配的item的大小     
    //每一个slab上可以存储多少个item.每个slab大小为1M，可以存储的item个数根据(1024*1024)/size决定。  
    unsigned int perslab; //每一个slab分配器能分配多少个item

    //当前slabclass的（空闲item列表）freelist 的链表头部地址  
    //freelist的链表是通过item结构中的item->next和item->prev连建立链表结构关系  
    void *slots;  //指向空闲item链表  

    //当前总共剩余多少个空闲的item  
    //当sl_curr=0的时候，说明已经没有空闲的item，需要分配一个新的slab（每个1M，可以切割成N多个Item结构）  
    unsigned int sl_curr;   //空闲item的个数  
  
    //这个是已经分配了内存的slabs个数。list_size是这个slabs数组(slab_list)的大小    
    unsigned int slabs; //本slabclass_t可用的slab分配器个数     
    //slab数组，数组的每一个元素就是一个slab分配器，这些分配器都分配相同尺寸的内存  
    void **slab_list;     
    unsigned int list_size; //slab数组的大小, list_size >= slabs  
  
    //用于reassign，指明slabclass_t中的哪个块内存要被其他slabclass_t使用  
    unsigned int killing;   
  
    size_t requested; //本slabclass_t分配出去的字节数  
} slabclass_t;

//数组元素虽然有MAX_NUMBER_OF_SLAB_CLASSES个，但实际上并不是全部都使用的。  
//实际使用的元素个数由power_largest指明  

//定义了一个全局slabclass数组。
//这个数组就是前面那些图的slabclass_t数组。
//虽然slabclass数组有201个元素,第1个元素不使用所以最多可以使用的元素个数200个,但可能并不会所有元素都使用的。
//由全局变量power_largest指明使用了多少个元素.
static slabclass_t slabclass[MAX_NUMBER_OF_SLAB_CLASSES];//201  

static size_t mem_limit = 0;//用户设置的内存最大限制  
static size_t mem_malloced = 0;  
static int power_largest;//slabclass数组中,已经使用了的元素个数.  
  
//如果程序要求预先分配内存，而不是到了需要的时候才分配内存，那么  
//mem_base就指向那块预先分配的内存.  
//mem_current指向还可以使用的内存的开始位置  
//mem_avail指明还有多少内存是可以使用的  
static void *mem_base = NULL;  
static void *mem_current = NULL;  
static size_t mem_avail = 0;  


//向内存池申请内存：
//与do_slabs_free函数对应的是do_slabs_alloc函数。
//当worker线程向内存池申请内存时就会调用该函数。
//在调用之前就要根据所申请的内存大小，确定好要向slabclass数组的哪个元素申请内存了。
//函数slabs_clsid就是完成这个任务。

//slabs_clsid - 查询slabclass的ID
//slabs_clsid方法，主要通过item的长度来查询应该适合存放到哪个slabsclass_t上面。
unsigned int slabs_clsid(const size_t size) {//返回slabclass索引下标值  
    int res = POWER_SMALLEST;//res的初始值为1  

    //slabclass这个结构上的size会存储该class适合多大的item存储  
    //例如  
    //slabclass[0] 存储96byte  
    //slabclass[1] 存储120byte  
    //slabclass[2] 存储150byte  
    //则，如果存储的item等于109byte，则存储在slabclass[1]上 

    //返回0表示查找失败，因为slabclass数组中，第一个元素是没有使用的  
    if (size == 0)  
        return 0;  
      
    //因为slabclass数组中各个元素能分配的item大小是升序的  
    //所以从小到大直接判断即可在数组找到最小但又能满足的元素  
    while (size > slabclass[res].size)  
        if (res++ == power_largest)     /* won't fit in the biggest slab */  
            return 0;  
    return res;  
}//end nlabs_clsid() 

//代码中出现的item是用来存储我们放在memcached的数据。
//代码中的循环决定了slabclass数组中的每一个slabclass_t能分配的item大小，
//也就是slab分配器能分配的item大小，同时也确定了slab分配器能分配的item个数。

//可以通过增大settings.item_size_max而使得memcached可以存储更大的一条数据信息。
//当然是有限制的，最大也只能为128MB。巧的是，slab分配器能分配的最大内存也是受这个settings.
//item_size_max所限制。
//因为每一个slab分配器能分配的最大内存有上限，所以slabclass数组中的每一个slabclass_t都有多个slab分配器，其用一个数组管理这些slab分配器。
//而这个数组大小是不受限制的，所以对于某个特定的尺寸的item是可以有很多很多的。
//当然整个memcached能分配的总内存大小也是有限制的，可以在启动memcached的时候通过-m选项设置，默认值为64MB。
//slabs_init函数中的limit参数就是memcached能分配的总内存。

//参数factor是扩容因子，默认值是1.25  

//slabs_init - slabclass的初始化
//slabs_init方法主要用于初始化slabclass数组结构。

/**
 * Determines the chunk sizes and initializes the slab class descriptors
 * accordingly.
 */
void slabs_init(const size_t limit, const double factor, const bool prealloc) {
    int i = POWER_SMALLEST - 1;
    //settings.chunk_size默认值为48，可以在启动memcached的时候通过-n选项设置  
    //size由两部分组成: item结构体本身 和 这个item对应的数据  
    //这里的数据也就是set、add命令中的那个数据.后面的循环可以看到这个size变量会  
    //根据扩容因子factor慢慢扩大，所以能存储的数据长度也会变大的 
    unsigned int size = sizeof(item) + settings.chunk_size;

    mem_limit = limit;////用户设置或者默认的内存最大限制

    //用户要求预分配一大块的内存，以后需要内存，就向这块内存申请。  
    if (prealloc) {//默认值为false
        /* Allocate everything in a big chunk with malloc */
        mem_base = malloc(mem_limit);
        if (mem_base != NULL) {
            mem_current = mem_base;
            mem_avail = mem_limit;
        } else {
            fprintf(stderr, "Warning: Failed to allocate requested memory in"
                    " one large chunk.\nWill allocate in smaller chunks\n");
        }
    }

    //初始化数组，这个操作很重要，数组中所有元素的成员变量值都为0了  
	//slabclass数组中的第一个元素并不使用  
    memset(slabclass, 0, sizeof(slabclass));

    //factor 默认等于1.25 ，也就是说前一个slabclass允许存储96byte大小的数据，  
    //则下一个slabclass可以存储120byte  
    while (++i < POWER_LARGEST && size <= settings.item_size_max / factor) {
        /* Make sure items are always n-byte aligned */
        if (size % CHUNK_ALIGN_BYTES) //8字节对齐
            size += CHUNK_ALIGN_BYTES - (size % CHUNK_ALIGN_BYTES);

        //这个slabclass的slab分配器能分配的item大小  
        slabclass[i].size = size;
        //这个slabclass的slab分配器最多能分配多少个item(也决定了最多分配多少内存)  
        slabclass[i].perslab = settings.item_size_max / slabclass[i].size;
        size *= factor;
        if (settings.verbose > 1) {
            fprintf(stderr, "slab class %3d: chunk size %9u perslab %7u\n",
                    i, slabclass[i].size, slabclass[i].perslab);
        }
    }

	//最大的item 
    power_largest = i;
    slabclass[power_largest].size = settings.item_size_max;
    slabclass[power_largest].perslab = 1;
    if (settings.verbose > 1) {
        fprintf(stderr, "slab class %3d: chunk size %9u perslab %7u\n",
                i, slabclass[i].size, slabclass[i].perslab);
    }

    /* for the test suite:  faking of how much we've already malloc'd */
    {
        char *t_initial_malloc = getenv("T_MEMD_INITIAL_MALLOC");
        if (t_initial_malloc) {
            mem_malloced = (size_t)atol(t_initial_malloc);
        }

    }

    if (prealloc) {//预分配内存
        slabs_preallocate(power_largest);
    }
}//end slab_init()

//预分配内存：
//现在就假设用户需要预先分配一些内存，而不是等到客户端发送存储数据命令的时候才分配内存。
//slabs_preallocate函数是为slabclass数组中每一个slabclass_t元素预先分配一些空闲的item。
//由于item可能比较小(上面的代码也可以看到这一点)，所以不能以item为单位申请内存（这样很容易造成内存碎片）。
//于是在申请的使用就申请一个比较大的一块内存，然后把这块内存划分成一个个的item，这样就等于申请了多个item。
//本文将申请得到的这块内存称为内存页，也就是申请了一个页。
//如果全局变量settings.slab_reassign为真，那么页的大小为settings.item_size_max，否则等于slabclass_t.size * slabclass_t.perslab。
//settings.slab_reassign主要用于平衡各个slabclass_t的。后文将统一使用内存页、页大小称呼这块分配内存，不区分其大小。

//现在就假设用户需要预先分配内存，看一下slabs_preallocate函数。
//该函数的参数值为使用到的slabclass数组元素个数。slabs_preallocate函数的调用是分配slab内存块和和设置item的。
static void slabs_preallocate (const unsigned int maxslabs) {
    int i;
    unsigned int prealloc = 0;

    /* pre-allocate a 1MB slab in every size class so people don't get
       confused by non-intuitive "SERVER_ERROR out of memory"
       messages.  this is the most common question on the mailing
       list.  if you really don't want this, you can rebuild without
       these three lines.  */

    for (i = POWER_SMALLEST; i <= POWER_LARGEST; i++) {
        if (++prealloc > maxslabs)
            return;
        if (do_slabs_newslab(i) == 0) {
            fprintf(stderr, "Error while preallocating slab memory!\n"
                "If using -L or other prealloc options, max memory must be "
                "at least %d megabytes.\n", power_largest);
            exit(1);
        }
    }
}//end slabs_preallocate()





//增加slab_list成员指向的内存，也就是增大slab_list数组。使得可以有更多的slab分配器  
//除非内存分配失败，否则都是返回1,无论是否真正增大了  
static int grow_slab_list (const unsigned int id) {
    slabclass_t *p = &slabclass[id];
    if (p->slabs == p->list_size) {//用完了之前申请到的slab_list数组的所有元素
        size_t new_size =  (p->list_size != 0) ? p->list_size * 2 : 16;
        void *new_list = realloc(p->slab_list, new_size * sizeof(void *));
        if (new_list == 0) return 0;
        p->list_size = new_size;
        p->slab_list = new_list;
    }
    return 1;
}

//将ptr指向的内存页划分成一个个的item  
static void split_slab_page_into_freelist(char *ptr, const unsigned int id) {  
    slabclass_t *p = &slabclass[id];  
    int x;  
    for (x = 0; x < p->perslab; x++) {  
        //将ptr指向的内存划分成一个个的item.一共划成perslab个  
        //并将这些item前后连起来。  
        //do_slabs_free函数本来是worker线程向内存池归还内存时调用的。但在这里  
        //新申请的内存也可以当作是向内存池归还内存。把内存注入内存池中  
        do_slabs_free(ptr, 0, id);  
        ptr += p->size;//size是item的大小  
    }  
}//end  split_slab_page_into_freelist()  

//slabclass_t中slab的数目是慢慢增多的。该函数的作用就是为slabclass_t申请多一个slab  
//参数id指明是slabclass数组中的那个slabclass_t  

//do_slabs_newslab函数内部调用了三个函数。
//函数grow_slab_list的作用是增大slab数组的大小(如下图所示的slab数组)。
//memory_allocate函数则是负责申请大小为len字节的内存。
//而函数split_slab_page_into_freelist则负责把申请到的内存切分成多个item，并且把这些item用指向连起来，形成双向链表。
static int do_slabs_newslab(const unsigned int id) {  
    slabclass_t *p = &slabclass[id];  
    //settings.slab_reassign的默认值为false，这里就采用false。  

	//当settings.slab_reassign为true，也就是启动rebalance功能的时候:
	//slabclass数组中所有slabclass_t的内存页都是一样大的，等于settings.item_size_max(默认为1MB)。
	//这样做的好处就是在需要将一个内存页从某一个slabclass_t强抢给另外一个slabclass_t时， 比较好处理。
	//不然的话，slabclass[i]从slabclass[j] 抢到的一个内存页可以切分为n个item，
	//而从slabclass[k]抢到的一个内存页却切分为m个item，而本身的一个内存页有s个item。
	//这样的话是相当混乱的。假如毕竟统一了内存页大小，那么无论从哪里抢到的内存页都是切分成一样多的item个数。
    int len = settings.slab_reassign ? settings.item_size_max  
        : p->size * p->perslab;//其积 <= settings.item_size_max  
    char *ptr;  
  
    //mem_malloced的值通过环境变量设置，默认为0  
    if ((mem_limit && mem_malloced + len > mem_limit && p->slabs > 0) ||  
        (grow_slab_list(id) == 0) ||//增长slab_list(失败返回0)。一般都会成功,除非无法分配内存  
        ((ptr = memory_allocate((size_t)len)) == 0)) {//分配len字节内存(也就是一个页)  
        return 0;  
    }  
  
    memset(ptr, 0, (size_t)len);//清零内存块是必须的  
    //将这块内存切成一个个的item，当然item的大小有id所控制  
    split_slab_page_into_freelist(ptr, id);  
  
    //将分配得到的内存页交由slab_list掌管  
    p->slab_list[p->slabs++] = ptr;  
    mem_malloced += len;  
  
    return 1;  
}//end do_slabs_newslab()

//在do_slabs_alloc函数中如果对应的slabclass_t有空闲的item，那么就直接将之分配出去。
//否则就需要扩充slab得到一些空闲的item然后分配出去。代码如下面所示：

//向slabclass申请一个item。在调用该函数之前，已经调用slabs_clsid函数确定  
//本次申请是向哪个slabclass_t申请item了，参数id就是指明是向哪个slabclass_t  
//申请item。如果该slabclass_t是有空闲item，那么就从空闲的item队列中分配一个  
//如果没有空闲item，那么就申请一个内存页。再从新申请的页中分配一个item  
//返回值为得到的item，如果没有内存了，返回NULL  

//可以看到在do_slabs_alloc函数的内部也是通过调用do_slabs_newslab增加item的。

//do_slabs_alloc - 分配一个item
//1. Memcached分配一个item，会先检查freelist空闲的列表中是否有空闲的item，
//如果有的话就用空闲列表中的item。
//2. 如果空闲列表没有空闲的item可以分配，则Memcached会去申请一个slab（默认大小为1M）的内存块，
//如果申请失败，则返回NULL，表明分配失败。
//3. 如果申请成功，则会去将这个1M大小的内存块，根据slabclass_t可以存储的最大的item的size，
//将slab切割成N个item，然后放进freelist（空闲列表中）
//4. 然后去freelist（空闲列表）中取出一个item来使用。
static void *do_slabs_alloc(const size_t size, unsigned int id) {  
    slabclass_t *p;  
    void *ret = NULL;  
    item *it = NULL;  
  
    if (id < POWER_SMALLEST || id > power_largest) {//下标越界  
        MEMCACHED_SLABS_ALLOCATE_FAILED(size, 0);  
        return NULL;  
    }  
  
    p = &slabclass[id];  
    assert(p->sl_curr == 0 || ((item *)p->slots)->slabs_clsid == 0);  
      
    //如果p->sl_curr等于0，就说明该slabclass_t没有空闲的item了。  
    //此时需要调用do_slabs_newslab申请一个内存页  
    if (! (p->sl_curr != 0 || do_slabs_newslab(id) != 0)) {  
        //当p->sl_curr等于0并且do_slabs_newslab的返回值等于0时，进入这里  
        /* We don't have more memory available */  
        ret = NULL;  
    } else if (p->sl_curr != 0) {  
    //除非do_slabs_newslab调用失败，否则都会来到这里.无论一开始sl_curr是否为0。  
    //p->slots指向第一个空闲的item，此时要把第一个空闲的item分配出去  
      
        /* return off our freelist */  
        it = (item *)p->slots;  
        p->slots = it->next;//slots指向下一个空闲的item  
        if (it->next) it->next->prev = 0;  
        p->sl_curr--;//空闲数目减一  
        ret = (void *)it;  
    }  
  
    if (ret) {  
        p->requested += size;//增加本slabclass分配出去的字节数  
    }  
  
    return ret;  
}// end do_slabs_alloc()

//worker线程向内存池归还内存时，该函数也是会被调用的。
//因为同一slab内存块中的各个item归还时间不同，所以memcached运行一段时间后，
//item链表就会变得很混乱
static void do_slabs_free(void *ptr, const size_t size, unsigned int id) {  
    slabclass_t *p;  
    item *it;  
  
    assert(((item *)ptr)->slabs_clsid == 0);  
    assert(id >= POWER_SMALLEST && id <= power_largest);  
    if (id < POWER_SMALLEST || id > power_largest)  
        return;  
  
    p = &slabclass[id];  
  
    it = (item *)ptr;  
    //为item的it_flags添加ITEM_SLABBED属性，标明这个item是在slab中没有被分配出去  
    it->it_flags |= ITEM_SLABBED;  
  
    //由split_slab_page_into_freelist调用时，下面4行的作用是  
    //让这些item的prev和next相互指向，把这些item连起来.  
    //当本函数是在worker线程向内存池归还内存时调用，那么下面4行的作用是,  
    //使用链表头插法把该item插入到空闲item链表中。  
    it->prev = 0;  
    it->next = p->slots;  
    if (it->next) it->next->prev = it;  
    p->slots = it;//slot变量指向第一个空闲可以使用的item  
  
    p->sl_curr++;//空闲可以使用的item数量  
    p->requested -= size;//减少这个slabclass_t分配出去的字节数  
    return;  
}//end do_slabs_free()

//申请分配内存，如果程序是有预分配内存块的，就向预分配内存块申请内存  
//否则调用malloc分配内存  
static void *memory_allocate(size_t size) {  
    void *ret;  
  
    //如果程序要求预先分配内存，而不是到了需要的时候才分配内存，那么  
    //mem_base就指向那块预先分配的内存.  
    //mem_current指向还可以使用的内存的开始位置  
    //mem_avail指明还有多少内存是可以使用的  
    if (mem_base == NULL) {//不是预分配内存  
        /* We are not using a preallocated large memory chunk */  
        ret = malloc(size);  
    } else {  
        ret = mem_current;  
  
        //在字节对齐中，最后几个用于对齐的字节本身就是没有意义的(没有被使用起来)  
        //所以这里是先计算size是否比可用的内存大，然后才计算对齐  
  
        if (size > mem_avail) {//没有足够的可用内存  
            return NULL;  
        }  
  
        //现在考虑对齐问题，如果对齐后size 比mem_avail大也是无所谓的  
        //因为最后几个用于对齐的字节不会真正使用  
        /* mem_current pointer _must_ be aligned!!! */  
        if (size % CHUNK_ALIGN_BYTES) {//字节对齐.保证size是CHUNK_ALIGN_BYTES (8)的倍数  
            size += CHUNK_ALIGN_BYTES - (size % CHUNK_ALIGN_BYTES);  
        }  
  
  
        mem_current = ((char*)mem_current) + size;  
        if (size < mem_avail) {  
            mem_avail -= size;  
        } else {//此时，size比mem_avail大也无所谓  
            mem_avail = 0;  
        }  
    }  
  
    return ret;  
}//end memory_allocate()

//作为memcached这个用锁大户，有点不正常。
//其实前面的代码中，有一些是要加锁才能访问的，比如do_slabs_alloc函数。
//之所以上面的代码中没有看到，是因为memcached使用了包裹函数
//(这个概念对应看过《UNIX网络编程》的读者来说很熟悉吧)。
//memcached在包裹函数中加锁后，才访问上面的那些函数的。下面就是两个包裹函数。

//分配一个Item
void *slabs_alloc(size_t size, unsigned int id) {  
    void *ret;  
    pthread_mutex_lock(&slabs_lock);  
    //size：需要分配的item的长度  
    //id：需要分配在哪个slab class上面  
    ret = do_slabs_alloc(size, id);  
    pthread_mutex_unlock(&slabs_lock);  
    return ret;  
}//end slabs_alloc()
  
void slabs_free(void *ptr, size_t size, unsigned int id) {  
    pthread_mutex_lock(&slabs_lock);  
    do_slabs_free(ptr, size, id);  
    pthread_mutex_unlock(&slabs_lock);  
}//end slabs_free()  

//新的item直接霸占旧的item就会调用这个函数  
void slabs_adjust_mem_requested(unsigned int id, size_t old, size_t ntotal)  
{  
    pthread_mutex_lock(&slabs_lock);  
    slabclass_t *p;  
    if (id < POWER_SMALLEST || id > power_largest) {  
        fprintf(stderr, "Internal error! Invalid slab class\n");  
        abort();  
    }  
  
    p = &slabclass[id];  
    //重新计算一下这个slabclass_t分配出去的内存大小  
    p->requested = p->requested - old + ntotal;  
    pthread_mutex_unlock(&slabs_lock);  
}  

//锁定内存页：
//函数slab_rebalance_start对要源slab class进行一些标注，
//当worker线程要访问源slab class的时候意识到正在内存页重分配。
static int slab_rebalance_start(void) {  
    slabclass_t *s_cls;  
    int no_go = 0;  
  
    pthread_mutex_lock(&cache_lock);  
    pthread_mutex_lock(&slabs_lock);  
  
    if (slab_rebal.s_clsid < POWER_SMALLEST ||  
        slab_rebal.s_clsid > power_largest  ||  
        slab_rebal.d_clsid < POWER_SMALLEST ||  
        slab_rebal.d_clsid > power_largest  ||  
        slab_rebal.s_clsid == slab_rebal.d_clsid)//非法下标索引  
        no_go = -2;  
  
    s_cls = &slabclass[slab_rebal.s_clsid];  
  
    //为这个目标slab class增加一个页表项都失败，那么就  
    //根本无法为之增加一个页了  
    if (!grow_slab_list(slab_rebal.d_clsid)) {  
        no_go = -1;  
    }  
  
    if (s_cls->slabs < 2)//源slab class页数太少了，无法分一个页给别人  
        no_go = -3;  
  
    if (no_go != 0) {  
        pthread_mutex_unlock(&slabs_lock);  
        pthread_mutex_unlock(&cache_lock);  
        return no_go; /* Should use a wrapper function... */  
    }  
  
    //标志将源slab class的第几个内存页分给目标slab class  
    //这里是默认是将第一个内存页分给目标slab class  
    s_cls->killing = 1;  
  
    //记录要移动的页的信息。slab_start指向页的开始位置。slab_end指向页  
    //的结束位置。slab_pos则记录当前处理的位置(item)  
    slab_rebal.slab_start = s_cls->slab_list[s_cls->killing - 1];  
    slab_rebal.slab_end   = (char *)slab_rebal.slab_start +  
        (s_cls->size * s_cls->perslab);  //因为是支持settings.slab_reassign这里+1M
    slab_rebal.slab_pos   = slab_rebal.slab_start;  
    slab_rebal.done       = 0;  
  
    /* Also tells do_item_get to search for items in this slab */  
    slab_rebalance_signal = 2;//要rebalance线程接下来进行内存页移动  
    
  
    pthread_mutex_unlock(&slabs_lock);  
    pthread_mutex_unlock(&cache_lock);  
  
    return 0;  
}  

enum move_status {
    MOVE_PASS=0, MOVE_DONE, MOVE_BUSY, MOVE_LOCKED
};

//移动(归还)item：
//现在回过头继续看rebalance线程。
//前面说到已经标注了源slab class的一个内存页。
//标注完rebalance线程就会调用slab_rebalance_move函数完成真正的内存页迁移操作。
//源slab class上的内存页是有item的，那么在迁移的时候怎么处理这些item呢？
//memcached的处理方式是很粗暴的：直接删除。
//如果这个item还有worker线程在使用，rebalance线程就等你一下。
//如果这个item没有worker线程在引用，那么即使这个item没有过期失效也将直接删除。
//
//因为一个内存页可能会有很多个item，所以memcached也采用分期处理的方法，每次只处理少量的item(默认为一个)。
//所以呢，slab_rebalance_move函数会在slab_rebalance_thread线程函数中多次调用，直到处理了所有的item。
static int slab_rebalance_move(void) {  
    slabclass_t *s_cls;  
    int x;  
    int was_busy = 0;  
    int refcount = 0;  
    enum move_status status = MOVE_PASS;  
  
    pthread_mutex_lock(&cache_lock);  
    pthread_mutex_lock(&slabs_lock);  
  
    s_cls = &slabclass[slab_rebal.s_clsid];  
  
    //会在start_slab_maintenance_thread函数中读取环境变量设置slab_bulk_check  
    //默认值为1.同样这里也是采用分期处理的方案处理一个页上的多个item  
    for (x = 0; x < slab_bulk_check; x++) {  
        item *it = slab_rebal.slab_pos;  
        status = MOVE_PASS;  
        if (it->slabs_clsid != 255) {  
            void *hold_lock = NULL;  
            uint32_t hv = hash(ITEM_key(it), it->nkey);  
            if ((hold_lock = item_trylock(hv)) == NULL) {  
                status = MOVE_LOCKED;  
            } else {  
                refcount = refcount_incr(&it->refcount);  
                if (refcount == 1) { /* item is unlinked, unused */  
                    //如果it_flags&ITEM_SLABBED为真，那么就说明这个item  
                    //根本就没有分配出去。如果为假，那么说明这个item被分配  
                    //出去了，但处于归还途中。参考do_item_get函数里面的  
                    //判断语句，有slab_rebalance_signal作为判断条件的那个。  
                    if (it->it_flags & ITEM_SLABBED) {//没有分配出去  
                        /* remove from slab freelist */  
                        if (s_cls->slots == it) {  
                            s_cls->slots = it->next;  
                        }  
                        if (it->next) it->next->prev = it->prev;  
                        if (it->prev) it->prev->next = it->next;  
                        s_cls->sl_curr--;  
                        status = MOVE_DONE;//这个item处理成功  
                    } else {//此时还有另外一个worker线程在归还这个item  
                        status = MOVE_BUSY;  
                    }  
                } else if (refcount == 2) { /* item is linked but not busy */  
                    //没有worker线程引用这个item  
                    if ((it->it_flags & ITEM_LINKED) != 0) {  
                        //直接把这个item从哈希表和LRU队列中删除  
                        do_item_unlink_nolock(it, hv);  
                        status = MOVE_DONE;  
                    } else {  
                        /* refcount == 1 + !ITEM_LINKED means the item is being 
                         * uploaded to, or was just unlinked but hasn't been freed 
                         * yet. Let it bleed off on its own and try again later */  
                        status = MOVE_BUSY;  
                    }  
                } else {//现在有worker线程正在引用这个item  
                    status = MOVE_BUSY;  
                }  
                item_trylock_unlock(hold_lock);  
            }  
        }  
  
        switch (status) {  
            case MOVE_DONE:  
                it->refcount = 0;//引用计数清零  
                it->it_flags = 0;//清零所有属性  
                it->slabs_clsid = 255;  
                break;  
            case MOVE_BUSY:  
                refcount_decr(&it->refcount); //注意这里没有break  
            case MOVE_LOCKED:  
                slab_rebal.busy_items++;  
                was_busy++;//记录是否有不能马上处理的item  
                break;  
            case MOVE_PASS:  
                break;  
        }  
  
        //处理这个页的下一个item  
        slab_rebal.slab_pos = (char *)slab_rebal.slab_pos + s_cls->size;  
        if (slab_rebal.slab_pos >= slab_rebal.slab_end)//遍历完了这个页  
            break;  
    }  
  
    //遍历完了这个页的所有item  
    if (slab_rebal.slab_pos >= slab_rebal.slab_end) {  
        /* Some items were busy, start again from the top */  
        //在处理的时候，跳过了一些item(因为有worker线程在引用)  
        if (slab_rebal.busy_items) {//此时需要从头再扫描一次这个页  
            slab_rebal.slab_pos = slab_rebal.slab_start;  
            slab_rebal.busy_items = 0;  
        } else {  
            slab_rebal.done++;//标志已经处理完这个页的所有item  
        }  
    }  
  
    pthread_mutex_unlock(&slabs_lock);  
    pthread_mutex_unlock(&cache_lock);  
  
    return was_busy;//返回记录  
}//end  slab_rebalance_move()  

//劫富济贫：
//上面代码中的was_busy就标志了是否有worker线程在引用内存页中的一个item。
//其实slab_rebalance_move函数的名字取得不好，因为实现的不是移动(迁移)，而是把内存页中的item删除从哈希表和LRU队列中删除。
//如果处理完内存页的所有item，那么就会slab_rebal.done++，标志处理完成。
//在线程函数slab_rebalance_thread中，如果slab_rebal.done为真就会调用slab_rebalance_finish函数完成真正的内存页迁移操作，
//把一个内存页从一个slab class 转移到另外一个slab class中。
static void slab_rebalance_finish(void) {  
    slabclass_t *s_cls;  
    slabclass_t *d_cls;  
  
    pthread_mutex_lock(&cache_lock);  
    pthread_mutex_lock(&slabs_lock);  
  
    s_cls = &slabclass[slab_rebal.s_clsid];  
    d_cls   = &slabclass[slab_rebal.d_clsid];  
  
    /* At this point the stolen slab is completely clear */  
    //相当于把指针赋NULL值  
    s_cls->slab_list[s_cls->killing - 1] =  
        s_cls->slab_list[s_cls->slabs - 1];  
    s_cls->slabs--;//源slab class的内存页数减一  
    s_cls->killing = 0;  
  
    //内存页所有字节清零，这个也很重要的  
    memset(slab_rebal.slab_start, 0, (size_t)settings.item_size_max);  
  
    //将slab_rebal.slab_start指向的一个页内存馈赠给目标slab class  
    //slab_rebal.slab_start指向的页是从源slab class中得到的。  
    d_cls->slab_list[d_cls->slabs++] = slab_rebal.slab_start;  
    //按照目标slab class的item尺寸进行划分这个页，并且将这个页的  
    //内存并入到目标slab class的空闲item队列中  
    split_slab_page_into_freelist(slab_rebal.slab_start,  
        slab_rebal.d_clsid);  
  
    //清零  
    slab_rebal.done       = 0;  
    slab_rebal.s_clsid    = 0;  
    slab_rebal.d_clsid    = 0;  
    slab_rebal.slab_start = NULL;  
    slab_rebal.slab_end   = NULL;  
    slab_rebal.slab_pos   = NULL;  
  
    slab_rebalance_signal = 0;//rebalance线程完成工作后，再次进入休眠状态  
  
    pthread_mutex_unlock(&slabs_lock);  
    pthread_mutex_unlock(&cache_lock);  
  
}//end  slab_rebalance_finish()  


static pthread_cond_t maintenance_cond = PTHREAD_COND_INITIALIZER;
static pthread_cond_t slab_rebalance_cond = PTHREAD_COND_INITIALIZER;
static volatile int do_run_slab_thread = 1;
static volatile int do_run_slab_rebalance_thread = 1;

#define DEFAULT_SLAB_BULK_CHECK 1  
int slab_bulk_check = DEFAULT_SLAB_BULK_CHECK;  
  
static pthread_mutex_t slabs_lock = PTHREAD_MUTEX_INITIALIZER;  
static pthread_mutex_t slabs_rebalance_lock = PTHREAD_MUTEX_INITIALIZER;  


//本函数选出最佳被踢选手，和最佳不被踢选手。返回1表示成功选手两位选手  
//返回0表示没有选出。要同时选出两个选手才返回1。并用src参数记录最佳不  
//不踢选手的id，dst记录最佳被踢选手的id  

//从slabclass数组中选出两个选手：
//一个是连续三次没有被踢item了， 另外一个则是连续三次都成为最佳被踢手。
//如果找到了满足条件的两个选手，那么返回1。此时automove线程就会调用slabs_reassign函数。
static int slab_automove_decision(int *src, int *dst) {  
    static uint64_t evicted_old[POWER_LARGEST];  
    static unsigned int slab_zeroes[POWER_LARGEST];  
    static unsigned int slab_winner = 0;  
    static unsigned int slab_wins   = 0;  
    uint64_t evicted_new[POWER_LARGEST];  
    uint64_t evicted_diff = 0;  
    uint64_t evicted_max  = 0;  
    unsigned int highest_slab = 0;  
    unsigned int total_pages[POWER_LARGEST];  
    int i;  
    int source = 0;  
    int dest = 0;  
    static rel_time_t next_run;  
  
    /* Run less frequently than the slabmove tester. */  
    //本函数的调用不能过于频繁，至少10秒调用一次  
    if (current_time >= next_run) {  
        next_run = current_time + 10;  
    } else {  
        return 0;  
    }  
  
    //获取每一个slabclass的被踢item数  
    item_stats_evictions(evicted_new);  
    pthread_mutex_lock(&cache_lock);  
    for (i = POWER_SMALLEST; i < power_largest; i++) {  
        total_pages[i] = slabclass[i].slabs;  
    }  
    pthread_mutex_unlock(&cache_lock);  
  
    //本函数会频繁被调用，所以有次数可说。  
      
    /* Find a candidate source; something with zero evicts 3+ times */  
    //evicted_old记录上一个时刻每一个slabclass的被踢item数  
    //evicted_new则记录了现在每一个slabclass的被踢item数  
    //evicted_diff则能表现某一个LRU队列被踢的频繁程度  
    for (i = POWER_SMALLEST; i < power_largest; i++) {  
        evicted_diff = evicted_new[i] - evicted_old[i];  
        if (evicted_diff == 0 && total_pages[i] > 2) {  
            //evicted_diff等于0说明这个slabclass没有item被踢，而且  
            //它又占有至少两个slab。           
            slab_zeroes[i]++;//增加计数  
            //这个slabclass已经历经三次都没有被踢记录，说明空间多得很  
            //就选你了,最佳不被踢选手  
            if (source == 0 && slab_zeroes[i] >= 3)  
                source = i;  
        } else {  
            slab_zeroes[i] = 0;//计数清零  
            if (evicted_diff > evicted_max) {  
                evicted_max = evicted_diff;  
                highest_slab = i;  
            }  
        }  
        evicted_old[i] = evicted_new[i];  
    }  
  
    /* Pick a valid destination */  
    //选出一个slabclass，这个slabclass要连续3次都是被踢最多item的那个slabclass  
    if (slab_winner != 0 && slab_winner == highest_slab) {  
        slab_wins++;  
        if (slab_wins >= 3)//这个slabclass已经连续三次成为最佳被踢选手了  
            dest = slab_winner;  
    } else {  
        slab_wins = 1;//计数清零(当然这里是1)  
        slab_winner = highest_slab;//本次的最佳被踢选手  
    }  
  
    if (source && dest) {  
        *src = source;  
        *dst = dest;  
        return 1;  
    }  
    return 0;  
}//end slab_automove_decision()

//确定贫穷和富有item：
//现在回过来看一下automove线程的线程函数slab_maintenance_thread。
static void *slab_maintenance_thread(void *arg) {  
    int src, dest;  
  
    while (do_run_slab_thread) {  
        if (settings.slab_automove == 1) {//启动了automove功能  
            if (slab_automove_decision(&src, &dest) == 1) {  
                /* Blind to the return codes. It will retry on its own */  
                slabs_reassign(src, dest);  
            }  
            sleep(1);  
        } else {//等待用户启动automove  
            /* Don't wake as often if we're not enabled. 
             * This is lazier than setting up a condition right now. */  
            sleep(5);  
        }  
    }  
    return NULL;  
}  

//选出一个内存页数大于1的slab class，并且该slab class不能是dst  
//指定的那个。如果不存在这样的slab class，那么返回-1  
static int slabs_reassign_pick_any(int dst) {  
    static int cur = POWER_SMALLEST - 1;  
    int tries = power_largest - POWER_SMALLEST + 1;  
    for (; tries > 0; tries--) {  
        cur++;  
        if (cur > power_largest)  
            cur = POWER_SMALLEST;  
        if (cur == dst)  
            continue;  
        if (slabclass[cur].slabs > 1) {  
            return cur;  
        }  
    }  
    return -1;  
} 

//do_slabs_reassign会把源slab class 和目标slab class保存在全局变量slab_rebal，
//并且在最后会调用pthread_cond_signal唤醒rebalance线程。
static enum reassign_result_type do_slabs_reassign(int src, int dst) {  
    if (slab_rebalance_signal != 0)  
        return REASSIGN_RUNNING;  
  
    if (src == dst)//不能相同  
        return REASSIGN_SRC_DST_SAME;  
  
    /* Special indicator to choose ourselves. */  
    if (src == -1) {//客户端命令要求随机选出一个源slab class  
        //选出一个页数大于1的slab class，并且该slab class不能是dst  
        //指定的那个。如果不存在这样的slab class，那么返回-1  
        src = slabs_reassign_pick_any(dst);  
        /* TODO: If we end up back at -1, return a new error type */  
    }  
  
    if (src < POWER_SMALLEST || src > power_largest ||  
        dst < POWER_SMALLEST || dst > power_largest)  
        return REASSIGN_BADCLASS;  
  
    //源slab class没有或者只有一个内存页，那么就不能分给别的slab class  
    if (slabclass[src].slabs < 2)  
        return REASSIGN_NOSPARE;  
  
    //全局变量slab_rebal  
    slab_rebal.s_clsid = src;//保存源slab class  
    slab_rebal.d_clsid = dst;//保存目标slab class  
  
    slab_rebalance_signal = 1;  
    //唤醒slab_rebalance_thread函数的线程.  
    //在slabs_reassign函数中已经锁上了slabs_rebalance_lock  
    pthread_cond_signal(&slab_rebalance_cond);  
  
    return REASSIGN_OK;  
}//end  do_slabs_reassign()  

//下达 rebalance任务：
//在贴出slabs_reassign函数前，回想一下slabs reassign命令。
//前面讲的都是自动检测要不要进行内存页重分配，都快要忘了还有一个手动要求内存页重分配的命令。
//如果客户端使用了slabs reassign命令，那么worker线程在接收到这个命令后，
//就会调用slabs_reassign函数，函数参数是slabs reassign命令的参数。
//现在自动检测和手动设置大一统了。
enum reassign_result_type slabs_reassign(int src, int dst) {  
    enum reassign_result_type ret;  
    if (pthread_mutex_trylock(&slabs_rebalance_lock) != 0) {  
        return REASSIGN_RUNNING;  
    }  
    ret = do_slabs_reassign(src, dst);  
    pthread_mutex_unlock(&slabs_rebalance_lock);  
    return ret;  
} 

static pthread_t maintenance_tid;  
static pthread_t rebalance_tid;  



//memcached源码分析-----slab automove和slab rebalance
//
//需求：
//考虑这样的一个情景：在一开始，由于业务原因向memcached存储大量长度为1KB的数据，也就是说memcached服务器进程里面有很多大小为1KB的item。
//现在由于业务调整需要存储大量10KB的数据，并且很少使用1KB的那些数据了。
//由于数据越来越多，内存开始吃紧。大小为10KB的那些item频繁访问，并且由于内存不够需要使用LRU淘汰一些10KB的item。
//
//对于上面的情景，会不会觉得大量1KB的item实在太浪费了。
//由于很少访问这些item，所以即使它们超时过期了，还是会占据着哈希表和LRU队列。
//LRU队列还好，不同大小的item使用不同的LRU队列。
//但对于哈希表来说大量的僵尸item会增加哈希冲突的可能性，并且在迁移哈希表的时候也浪费时间。
//有没有办法干掉这些item？使用LRU爬虫+lru_crawler命令是可以强制干掉这些僵尸item。
//但干掉这些僵尸item后，它们占据的内存是归还到1KB的那些slab分配器中。1KB的slab分配器不会为10KB的item分配内存。所以还是功亏一篑。
//
//那有没有别的办法呢？是有的。
//memcached提供的slab automove 和 rebalance两个东西就是完成这个功能的。
//在默认情况下，memcached不启动这个功能，所以要想使用这个功能必须在启动memcached的时候加上参数-o slab_reassign。
//之后就可以在客户端发送命令slabsreassign <source class> <dest class>，手动将source class的内存页分给dest class。
//后文会把这个工作称为内存页重分配。
//而命令slabs automove则是让memcached自动检测是否需要进行内存页重分配，如果需要的话就自动去操作，这样一切都不需要人工的干预。
//
//如果在启动memcached的时候使用了参数-o slab_reassign，那么就会把settings.slab_reassign赋值为true(该变量的默认值为false)。
//还记得《slab内存分配器》说到的每一个内存页的大小吗？
//在do_slabs_newslab函数中，一个内存页的大小会根据settings.slab_reassign是否为true而不同。

//要注意的是，start_slab_maintenance_thread函数启动了两个线程：
//rebalance线程和automove线程。automove线程会自动检测是否需要进行内存页重分配。
//如果检测到需要重分配，那么就会叫rebalance线程执行这个内存页重分配工作。
//
//默认情况下是不开启自动检测功能的，即使在启动memcached的时候加入了-o slab_reassign参数。
//自动检测功能由全局变量settings.slab_automove控制(默认值为0，0就是不开启)。
//如果要开启可以在启动memcached的时候加入slab_automove选项，并将其参数数设置为1。
//比如命令$memcached -o slab_reassign,slab_automove=1就开启了自动检测功能。
//当然也是可以在启动memcached后通过客户端命令启动automove功能，使用命令slabsautomove <0|1>。
//其中0表示关闭automove，1表示开启automove。
//客户端的这个命令只是简单地设置settings.slab_automove的值，不做其他任何工作。

//由main函数调用，如果settings.slab_reassign为false将不会调用本函数(默认是false)  
int start_slab_maintenance_thread(void) {
    int ret;
    slab_rebalance_signal = 0;
    slab_rebal.slab_start = NULL;
    char *env = getenv("MEMCACHED_SLAB_BULK_CHECK");
    if (env != NULL) {
        slab_bulk_check = atoi(env);
        if (slab_bulk_check == 0) {
            slab_bulk_check = DEFAULT_SLAB_BULK_CHECK;
        }
    }

    if (pthread_cond_init(&slab_rebalance_cond, NULL) != 0) {
        fprintf(stderr, "Can't intiialize rebalance condition\n");
        return -1;
    }
    pthread_mutex_init(&slabs_rebalance_lock, NULL);

    if ((ret = pthread_create(&maintenance_tid, NULL,
                              slab_maintenance_thread, NULL)) != 0) {
        fprintf(stderr, "Can't create slab maint thread: %s\n", strerror(ret));
        return -1;
    }
    if ((ret = pthread_create(&rebalance_tid, NULL,
                              slab_rebalance_thread, NULL)) != 0) {
        fprintf(stderr, "Can't create rebal thread: %s\n", strerror(ret));
        return -1;
    }
    return 0;
}//end start_slab_maintenance_thread()

//rebalance线程：
//现在automove线程已经退出历史舞台了，rebalance线程也从沉睡中苏醒过来并登上舞台。
//现在来看一下rebalance线程的线程函数slab_rebalance_thread。
//注意：在一开始slab_rebalance_signal是等于0的，当需要进行内存页重分配就会把slab_rebalance_signal变量赋值为1。
static void *slab_rebalance_thread(void *arg) {  
    int was_busy = 0;  
    /* So we first pass into cond_wait with the mutex held */  
    mutex_lock(&slabs_rebalance_lock);  
  
    while (do_run_slab_rebalance_thread) {  
        if (slab_rebalance_signal == 1) {  
            //标志要移动的内存页的信息，并将slab_rebalance_signal赋值为2  
            //slab_rebal.done赋值为0，表示没有完成  
            if (slab_rebalance_start() < 0) {//失败  
                /* Handle errors with more specifity as required. */  
                slab_rebalance_signal = 0;  
            }  
  
            was_busy = 0;  
        } else if (slab_rebalance_signal && slab_rebal.slab_start != NULL) {  
            was_busy = slab_rebalance_move();//进行内存页迁移操作  
        }  
  
        if (slab_rebal.done) {//完成内存页重分配操作  
            slab_rebalance_finish();  
        } else if (was_busy) {//有worker线程在使用内存页上的item  
            /* Stuck waiting for some items to unlock, so slow down a bit 
             * to give them a chance to free up */  
            usleep(50);//休眠一会儿，等待worker线程放弃使用item，然后再次尝试  
        }  
  
        if (slab_rebalance_signal == 0) {//一开始就在这里休眠  
            /* always hold this lock while we're running */  
            pthread_cond_wait(&slab_rebalance_cond, &slabs_rebalance_lock);  
        }  
    }  
    return NULL;  
}//end slab_rebalance_thread()   

void stop_slab_maintenance_thread(void) {  
    mutex_lock(&cache_lock);  
    do_run_slab_thread = 0;  
    do_run_slab_rebalance_thread = 0;  
    pthread_cond_signal(&maintenance_cond);  
    pthread_mutex_unlock(&cache_lock);  
  
    /* Wait for the maintenance thread to stop */  
    pthread_join(maintenance_tid, NULL);  
    pthread_join(rebalance_tid, NULL);  
}  

