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

static pthread_cond_t maintenance_cond = PTHREAD_COND_INITIALIZER;

typedef  unsigned long  int  ub4;   /* unsigned 4-byte quantities */
typedef  unsigned       char ub1;   /* unsigned 1-byte quantities */

/* how many powers of 2's worth of buckets we use */
unsigned int hashpower = HASHPOWER_DEFAULT;

#define hashsize(n) ((ub4)1<<(n))
#define hashmask(n) (hashsize(n)-1)

/* Main hash table. This is where we look except during expansion. */
static item** primary_hashtable = 0;

static bool expanding = false;
static bool started_expanding = false;

//指向待迁移的桶
static unsigned int expand_bucket = 0;


//assoc_init() 初始化HashTable
//当我们进入assoc_find这个方法后，发现HashTable的操作都在assoc.c这个文件中。
//1. assoc_init这个方法为HashTable初始化，assoc_init这个方法是在入口函数main中初始化的。
//2. HashTable默认设置为16，1 << 16后得到65536个桶。如果用户自定义设置，设置值在12-64之间。
//3. 一般情况下，memcached的桶的个数足够使用了。
//默认参数值为0。本函数由main函数调用，参数的默认值为0  
void assoc_init(const int hashtable_init) {  
    //初始化的时候 hashtable_init值需要大于12 小于64  
    //如果hashtable_init的值没有设定，则hashpower使用默认值为16
    if (hashtable_init) {  
        hashpower = hashtable_init;  
    }  
  
    //因为哈希表会慢慢增大，所以要使用动态内存分配。哈希表存储的数据是一个  
    //指针，这样更省空间。  
    //hashsize(hashpower)就是哈希表的长度,就是桶的个数  
    //primary_hashtable主要用来存储这个HashTable  
    //hashsize方法是求桶的个数，默认如果hashpower=16的话，桶的个数为：65536 
    primary_hashtable = calloc(hashsize(hashpower), sizeof(void *));  
    if (! primary_hashtable) {  
        fprintf(stderr, "Failed to init hashtable.\n");  
        exit(EXIT_FAILURE);//哈希表是memcached工作的基础，如果失败只能退出运行  
    }  
}  

//查找item：
//往哈希表插入item后，就可以开始查找item了。
//下面看一下怎么在哈希表中查找一个item。
//item的键值hv只能定位到哈希表中的桶位置，但一个桶的冲突链上可能有多个item，
//所以除了查找的时候除了需要hv外还需要item的键值。

//由于哈希值只能确定是在哈希表中的哪个桶(bucket)，但一个桶里面是有一条冲突链的  
//此时需要用到具体的键值遍历并一一比较冲突链上的所有节点。因为key并不是以'\0'结尾  
//的字符串，所以需要另外一个参数nkey指明这个key的长度 

//assoc_find 查找一个Item
//1. 首先通过key的hash值hv找到对应的桶。
//2. 然后遍历桶的单链表，比较key值，找到对应item
item *assoc_find(const char *key, const size_t nkey, const uint32_t hv) {
    item *it;
    unsigned int oldbucket;

    //判断是否在扩容中...  
    if (expanding &&//正在扩展哈希表
        (oldbucket = (hv & hashmask(hashpower - 1))) >= expand_bucket) //该item还在旧表里面
    {
        it = old_hashtable[oldbucket];
    } else {
        //由哈希值判断这个key是属于那个桶(bucket)的  
        it = primary_hashtable[hv & hashmask(hashpower)];
    }

	//到这里，已经确定这个key是属于那个桶的。 遍历对应桶的冲突链即可

    item *ret = NULL;
    int depth = 0;
    while (it) {
		//长度相同的情况下才调用memcmp比较，更高效
        if ((nkey == it->nkey) && (memcmp(key, ITEM_key(it), nkey) == 0)) {
            ret = it;
            break;
        }
        it = it->h_next;
        ++depth;
    }
    MEMCACHED_ASSOC_FIND(key, nkey, depth);
    return ret;
}//end assoc_find()


//获取一个item在bucket冲突列表的前驱item
//查找item。返回前驱节点的h_next成员地址,如果查找失败那么就返回冲突链中最后  
//一个节点的h_next成员地址。因为最后一个节点的h_next的值为NULL。通过对返回值  
//使用 * 运算符即可知道有没有查找成功。
/* returns the address of the item pointer before the key.  if *item == 0,
   the item wasn't found */
static item** _hashitem_before (const char *key, const size_t nkey, const uint32_t hv) {
    item **pos;
    unsigned int oldbucket;

	//同样，看的时候直接跳到else部分
    if (expanding &&
        (oldbucket = (hv & hashmask(hashpower - 1))) >= expand_bucket)
    {
        pos = &old_hashtable[oldbucket];
    } else {
        //找到哈希表中对应的桶位置  
        pos = &primary_hashtable[hv & hashmask(hashpower)];
    }

	//到这里已经确定了要查找的item是属于哪个表的了，并且也确定了桶位置。遍历对应桶的冲突链即可

    //遍历桶的冲突链查找item  
    while (*pos && ((nkey != (*pos)->nkey) || memcmp(key, ITEM_key(*pos), nkey))) {
        pos = &(*pos)->h_next;
    }

	//*pos就可以知道有没有查找成功。如果*pos等于NULL那么查找失败，否则查找成功。
    return pos;
}//end _hashitem_before()


/* grows the hashtable to the next power of 2. */
static void assoc_expand(void) {
    old_hashtable = primary_hashtable;
	//申请一个新哈希表，并用old_hashtable指向旧哈希表
    primary_hashtable = calloc(hashsize(hashpower + 1), sizeof(void *));
    if (primary_hashtable) {
        if (settings.verbose > 1)
            fprintf(stderr, "Hash table expansion starting\n");
        hashpower++;
        expanding = true;//标明已经进入扩展状态
        expand_bucket = 0;//从0号桶开始数据迁移
        STATS_LOCK();
        stats.hash_power_level = hashpower;
        stats.hash_bytes += hashsize(hashpower) * sizeof(void *);
        stats.hash_is_expanding = 1;
        STATS_UNLOCK();
    } else {
        primary_hashtable = old_hashtable;
        /* Bad news, but we can keep running. */
    }
}//end assoc_expand()

//迁移线程被创建后会进入休眠状态(通过等待条件变量)，当worker线程插入item后，
//发现需要扩展哈希表就会调用assoc_start_expand函数唤醒这个迁移线程。

static void assoc_start_expand(void) {
    if (started_expanding)
        return;
    started_expanding = true;
    pthread_cond_signal(&maintenance_cond);
}


//插入item:
//接着看一下怎么在哈希表中插入一个item。
//它是直接根据哈希值找到哈希表中的位置(即找到对应的桶)，然后使用头插法插入到桶的冲突链中。
//item结构体有一个专门的h_next指针成员变量用于连接哈希冲突链。
//hv是这个item键值的哈希值  

//assoc_insert 新增一个Item
//1. 首先通过key的hash值hv找到对应的桶。
//2. 然后将item放到对应桶的单链表的头部
//3. 判断是否需要扩容，如果扩容，则会在单独的线程中进行。（桶的个数(默认：65536) * 3） / 2

/* Note: this isn't an assoc_update.  The key must not already exist to call this */
int assoc_insert(item *it, const uint32_t hv) {
    unsigned int oldbucket;

//    assert(assoc_find(ITEM_key(it), it->nkey) == 0);  /* shouldn't have duplicately named things defined */

    //判断是否在扩容，如果是扩容中，看查到的oldbucket是在新扩容的hashtable还是在老的hashtable
    if (expanding &&
        (oldbucket = (hv & hashmask(hashpower - 1))) >= expand_bucket)
    {
        it->h_next = old_hashtable[oldbucket];
        old_hashtable[oldbucket] = it;
    } else {//看这
        it->h_next = primary_hashtable[hv & hashmask(hashpower)];
        primary_hashtable[hv & hashmask(hashpower)] = it;
    }

    hash_items++;
	//这个*3/2 实际的意思就是*1.5
	//如果item总数大于(hashtable 长度*1.5),则需要扩容hashtable
    if (! expanding && hash_items > (hashsize(hashpower) * 3) / 2) {
        assoc_start_expand();
    }

    MEMCACHED_ASSOC_INSERT(ITEM_key(it), it->nkey, hash_items);
    return 1;
}

//删除item：
//下面看一下从哈希表中删除一个item是怎么实现的。
//从链表中删除一个节点的常规做法是：
//先找到这个节点的前驱节点，然后使用前驱节点的next指针进行删除和拼接操作。
void assoc_delete(const char *key, const size_t nkey, const uint32_t hv) {
    item **before = _hashitem_before(key, nkey, hv);

    if (*before) {//查找成功
        item *nxt;
        hash_items--;
        //因为before是一个二级指针，其值为所查找item的前驱item的h_next成员地址.  
        //所以*before指向的是所查找的item.因为before是一个二级指针，所以  
        //*before作为左值时，可以给h_next成员变量赋值。所以下面三行代码是  
        //使得删除中间的item后，前后的item还能连得起来。 
        /* The DTrace probe cannot be triggered as the last instruction
         * due to possible tail-optimization by the compiler
         */
        MEMCACHED_ASSOC_DELETE(key, nkey, hash_items);
        nxt = (*before)->h_next;
        (*before)->h_next = 0;   /* probably pointless, but whatever. */
        *before = nxt;
        return;
    }
    /* Note:  we never actually get here.  the callers don't delete things
       they can't find. */
    assert(*before != 0);
}


//逐步迁移数据：
//=========================================================================================================
//为了避免在迁移的时候worker线程增删哈希表，所以要在数据迁移的时候加锁，worker线程抢到了锁才能增删查找哈希表。
//memcached为了实现快速响应(即worker线程能够快速完成增删查找操作)，就不能让迁移线程占锁太久。
//但数据迁移本身就是一个耗时的操作，这是一个矛盾。
//
//memcached为了解决这个矛盾，就采用了逐步迁移的方法:
//其做法是，在一个循环里面：加锁->只进行小部分数据的迁移->解锁。
//
//这样做的效果是：
//虽然迁移线程会多次抢占锁，但每次占有锁的时间都是很短的，这就增加了worker线程抢到锁的概率，
//使得worker线程能够快速完成它的操作。
//
//一小部分是多少个item呢？
//前面说到的全局变量hash_bulk_move就指明是多少个桶的item，默认值是1个桶，后面为了方便叙述也就认为hash_bulk_move的值为1。
//
//逐步迁移的具体做法是:
//调用assoc_expand函数申请一个新的更大的哈希表，每次只迁移旧哈希表一个桶的item到新哈希表，迁移完一桶就释放锁。
//此时就要求有一个旧哈希表和新哈希表。
//在memcached实现里面，用primary_hashtable表示新表(也有一些博文称之为主表)，old_hashtable表示旧表(副表)。
//
//前面说到，迁移线程被创建后就会休眠直到被worker线程唤醒。
//当迁移线程醒来后，就会调用assoc_expand函数扩大哈希表的表长。
static volatile int do_run_maintenance_thread = 1;
#define DEFAULT_HASH_BULK_MOVE 1  
int hash_bulk_move = DEFAULT_HASH_BULK_MOVE;  

static void *assoc_maintenance_thread(void *arg) {
   	//do_run_maintenance_thread是全局变量，初始值为1，在stop_assoc_maintenance_thread  
    //函数中会被赋值0，终止迁移线程 
    while (do_run_maintenance_thread) {
        int ii = 0;

		//上锁  
        /* Lock the cache, and bulk move multiple buckets to the new
         * hash table. */
        item_lock_global();//锁上全局级别的锁，全部的item都在全局锁的控制之下  
        //锁住哈希表里面的item。不然别的线程对哈希表进行增删操作时，会出现  
        //数据不一致的情况.在item.c的do_item_link和do_item_unlink可以看到  
        //其内部也会锁住cache_lock锁.  
        mutex_lock(&cache_lock);

		//这里是迁移一个桶的数据到新哈希表
		//进行item迁移  
        //hash_bulk_move用来控制每次迁移，移动多少个桶的item。默认是一个.  
        //如果expanding为true才会进入循环体，所以迁移线程刚创建的时候，并不会进入循环体 
        for (ii = 0; ii < hash_bulk_move && expanding; ++ii) {
            item *it, *next;
            int bucket;
            //在assoc_expand函数中expand_bucket会被赋值0  
            //遍历旧哈希表中由expand_bucket指明的桶,将该桶的所有item  
            //迁移到新哈希表中。
            for (it = old_hashtable[expand_bucket]; NULL != it; it = next) {
                next = it->h_next;
                //重新计算新的哈希值,得到其在新哈希表的位置  
                bucket = hash(ITEM_key(it), it->nkey) & hashmask(hashpower);
                //将这个item插入到新哈希表中  
                it->h_next = primary_hashtable[bucket];
                primary_hashtable[bucket] = it;
            }

            //不需要清空旧桶。直接将冲突链的链头赋值为NULL即可  
            old_hashtable[expand_bucket] = NULL;

            //迁移完一个桶，接着把expand_bucket指向下一个待迁移的桶  
            expand_bucket++;

			//全部数据迁移完毕 
            if (expand_bucket == hashsize(hashpower - 1)) {
                expanding = false;//将扩展标志设置为false
                free(old_hashtable);
                STATS_LOCK();
                stats.hash_bytes -= hashsize(hashpower - 1) * sizeof(void *);
                stats.hash_is_expanding = 0;
                STATS_UNLOCK();
                if (settings.verbose > 1)
                    fprintf(stderr, "Hash table expansion done\n");
            }
        }

        //遍历完hash_bulk_move个桶的所有item后，就释放锁  
        mutex_unlock(&cache_lock);
        item_unlock_global();

        if (!expanding) {//不需要迁移数据了
            /* finished expanding. tell all threads to use fine-grained(细粒度的) locks */  
            //进入到这里，说明已经不需要迁移数据(停止扩展了)。  
            //告诉所有的workers线程，访问item时，切换到段级别的锁。  
            //会阻塞到所有workers线程都切换到段级别的锁
            switch_item_lock_type(ITEM_LOCK_GRANULAR);
            slabs_rebalancer_resume();
            /* We are done expanding.. just wait for next invocation */
            mutex_lock(&cache_lock);
            started_expanding = false;
            //挂起迁移线程，直到worker线程插入数据后发现item数量已经到了1.5倍哈希表大小，  
            //此时调用worker线程调用assoc_start_expand函数，该函数会调用pthread_cond_signal  
            //唤醒迁移线程  
            pthread_cond_wait(&maintenance_cond, &cache_lock);
            /* Before doing anything, tell threads to use a global lock */
            mutex_unlock(&cache_lock);
            slabs_rebalancer_pause();
            //从maintenance_cond条件变量中醒来，说明又要开始扩展哈希表和迁移数据了。  
            //迁移线程在迁移一个桶的数据时是锁上全局级别的锁.  
            //此时workers线程不能使用段级别的锁，而是要使用全局级别的锁，  
            //所有的workers线程和迁移线程一起，争抢全局级别的锁.  
            //哪个线程抢到了，才有权利访问item.  
            //下面一行代码就是通知所有的workers线程，把你们访问item的锁切换  
            //到全局级别的锁。switch_item_lock_type会通过条件变量休眠等待，  
            //直到，所有的workers线程都切换到全局级别的锁，才会醒来过  
            switch_item_lock_type(ITEM_LOCK_GLOBAL);
            mutex_lock(&cache_lock);
            assoc_expand();//申请更大的哈希表,并将expanding设置为true
            mutex_unlock(&cache_lock);
        }
    }
    return NULL;
}//end assoc_maintenance_thread()

//main函数会调用本函数，启动数据迁移线程  
int start_assoc_maintenance_thread() {  
    int ret;  
    char *env = getenv("MEMCACHED_HASH_BULK_MOVE");  
    if (env != NULL) {  
        //hash_bulk_move的作用在后面会说到。这里是通过环境变量给hash_bulk_move赋值  
        hash_bulk_move = atoi(env);  
        if (hash_bulk_move == 0) {  
            hash_bulk_move = DEFAULT_HASH_BULK_MOVE;  
        }  
    }  
    if ((ret = pthread_create(&maintenance_tid, NULL,  
                              assoc_maintenance_thread, NULL)) != 0) {  
        fprintf(stderr, "Can't create thread: %s\n", strerror(ret));  
        return -1;  
    }  
    return 0;  
} 
