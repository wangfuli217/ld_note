#include "memcached.h"
#include <assert.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <pthread.h>

#define ITEMS_PER_ALLOC 64

//结构体conn_queue(即CQ队列结构体)有一个pthread_mutex_t类型变量lock，
//这说明主线程往某个worker线程的CQ队列里面push一个CQ_ITEM的时候必然要加锁的。
//下面是初始化CQ队列，以及push、pop一个CQ_ITEM的代码。
/* An item in the connection queue. */
typedef struct conn_queue_item CQ_ITEM;
struct conn_queue_item {
    int               sfd;
    enum conn_states  init_state;
    int               event_flags;
    int               read_buffer_size;
    enum network_transport     transport;
    CQ_ITEM          *next;
};

typedef struct conn_queue CQ;
struct conn_queue {
	CQ_ITEM *head;//指向队列的第一个节点  
	CQ_ITEM *tail;//指向队列的最后一个节点  
	pthread_mutex_t lock; //一个队列就对应一个锁  
};

/* Free list of CQ_ITEM structs */
static CQ_ITEM *cqi_freelist;
static pthread_mutex_t cqi_freelist_lock;


static pthread_mutex_t *item_locks;//指向段锁数组的指针  
/* size of the item lock hash table */  
static uint32_t item_lock_count;//段锁的数量  
static unsigned int item_lock_hashpower;  
#define hashsize(n) ((unsigned long int)1<<(n))
#define hashmask(n) (hashsize(n)-1)
static pthread_mutex_t item_global_lock;//全局锁
static pthread_key_t item_lock_type_key;//线程私有数据key

static LIBEVENT_THREAD *threads;


//refcount_incr(&it->refcount);一般是这样调用的  
//refcount_decr(&it->refcount); 
unsigned short refcount_incr(unsigned short *refcount) {
    unsigned short res;
    mutex_lock(&atomics_mutex);
    (*refcount)++;
    res = *refcount;
    mutex_unlock(&atomics_mutex);
    return res;
}

unsigned short refcount_decr(unsigned short *refcount) {
    unsigned short res;
    mutex_lock(&atomics_mutex);
    (*refcount)--;
    res = *refcount;
    mutex_unlock(&atomics_mutex);
    return res;
}

void item_lock_global(void) {  
    mutex_lock(&item_global_lock);  
}  
  
void item_unlock_global(void) {  
    mutex_unlock(&item_global_lock);  
}

void item_lock(uint32_t hv) {  
    //获取线程私有变量  
    uint8_t *lock_type = pthread_getspecific(item_lock_type_key);  
    //likely这个宏定义用于代码指令优化  
    //likely(*lock_type == ITEM_LOCK_GRANULAR)用来告诉编译器  
    //*lock_type等于ITEM_LOCK_GRANULAR的可能性很大  
    if (likely(*lock_type == ITEM_LOCK_GRANULAR)) {//使用段级别锁的概率很大  
        //对某些桶的item加锁,实现了多个bucket对应到一个段级锁!!!!!!!!!! 
        mutex_lock(&item_locks[hv & hashmask(item_lock_hashpower)]);  
    } else {  
        //对所有item加锁  
        mutex_lock(&item_global_lock);  
    }  
}  

void item_unlock(uint32_t hv) {  
    uint8_t *lock_type = pthread_getspecific(item_lock_type_key);  
    if (likely(*lock_type == ITEM_LOCK_GRANULAR)) {  
        mutex_unlock(&item_locks[hv & hashmask(item_lock_hashpower)]);  
    } else {  
        mutex_unlock(&item_global_lock);  
    }  
}  

static void wait_for_thread_registration(int nthreads) {
    while (init_count < nthreads) {
        pthread_cond_wait(&init_cond, &init_lock);
    }
}

static void register_thread_initialized(void) {
    pthread_mutex_lock(&init_lock);
    init_count++;
    pthread_cond_signal(&init_cond);
    pthread_mutex_unlock(&init_lock);
}

void switch_item_lock_type(enum item_lock_types type) {
    char buf[1];
    int i;

    switch (type) {
        case ITEM_LOCK_GRANULAR:
            buf[0] = 'l';
            break;
        case ITEM_LOCK_GLOBAL:
            buf[0] = 'g';
            break;
        default:
            fprintf(stderr, "Unknown lock type: %d\n", type);
            assert(1 == 0);
            break;
    }

    pthread_mutex_lock(&init_lock);
    init_count = 0;
    for (i = 0; i < settings.num_threads; i++) {
        if (write(threads[i].notify_send_fd, buf, 1) != 1) {
            perror("Failed writing to notify pipe");
            /* TODO: This is a fatal problem. Can it ever happen temporarily? */
        }
    }
    wait_for_thread_registration(settings.num_threads);
    pthread_mutex_unlock(&init_lock);
}//end switch_item_lock_type()

static void cq_init(CQ *cq) {  
    pthread_mutex_init(&cq->lock, NULL);  
    cq->head = NULL;  
    cq->tail = NULL;  
}  
  
static CQ_ITEM *cq_pop(CQ *cq) {  
    CQ_ITEM *item;  
  
    pthread_mutex_lock(&cq->lock);  
    item = cq->head;  
    if (NULL != item) {  
        cq->head = item->next;  
        if (NULL == cq->head)  
            cq->tail = NULL;  
    }  
    pthread_mutex_unlock(&cq->lock);  
  
    return item;  
}  
  
static void cq_push(CQ *cq, CQ_ITEM *item) {  
    item->next = NULL;  
  
    pthread_mutex_lock(&cq->lock);  
    if (NULL == cq->tail)  
        cq->head = item;  
    else  
        cq->tail->next = item;  
    cq->tail = item;  
    pthread_mutex_unlock(&cq->lock);  
}  

//CQ_ITEM内存池：
//memcached在申请一个CQ_ITEM结构体时，并不是直接使用malloc申请的。
//因为这样做的话可能会导致大量的内存碎片(作为长期运行的服务器进程memcached需要考虑这个问题)。
//为此，memcached也为CQ_ITEM使用类似内存池的技术：预分配一块比较大的内存，将这块大内存切分成多个CQ_ITEM。

//本函数采用了一些优化手段.并非每调用一次本函数就申请一块内存。这会导致  
//内存碎片。这里采取的优化方法是，一次性分配64个CQ_ITEM大小的内存(即预分配).  
//下次调用本函数的时候，直接从之前分配64个中要一个即可。  
//由于是为了防止内存碎片，所以不是以链表的形式放置这64个CQ_ITEM。而是数组的形式。  
//于是，cqi_free函数就有点特别了。它并不会真正释放.而是像内存池那样归还 
/*
 * Returns a fresh connection queue item.
 */
static CQ_ITEM *cqi_new(void) {
	//所有线程都会访问cqi_freelist的。所以需要加锁
	CQ_ITEM *item = NULL;
	pthread_mutex_lock(&cqi_freelist_lock);
	if (cqi_freelist) {
		item = cqi_freelist;
		cqi_freelist = item->next;
	}
	pthread_mutex_unlock(&cqi_freelist_lock);

	if (NULL == item) {//没有多余的CQ_ITEM了
		int i;

		/* Allocate a bunch of items at once to reduce fragmentation */
		item = malloc(sizeof(CQ_ITEM) * ITEMS_PER_ALLOC);
		if (NULL == item) {
			STATS_LOCK();
			stats.malloc_fails++;
			STATS_UNLOCK();
			return NULL;
		}

        //item[0]直接返回为调用者，不用next指针连在一起。调用者负责将  
        //item[0].next赋值为NULL 
		/*
		 * Link together all the new items except the first one
		 * (which we'll return to the caller) for placement on
		 * the freelist.
		 */
		//将这块内存分成一个个的item并且用next指针像链表一样连起来
		for (i = 2; i < ITEMS_PER_ALLOC; i++)
			item[i - 1].next = &item[i];

        //因为主线程负责申请CQ_ITEM，子线程负责释放CQ_ITEM。所以cqi_freelist此刻  
        //可能并不等于NULL。由于使用头插法，所以无论cqi_freeelist是否为NULL，都能  
        //把链表连起来的。 
		pthread_mutex_lock(&cqi_freelist_lock);
		item[ITEMS_PER_ALLOC - 1].next = cqi_freelist;
		cqi_freelist = &item[1];
		pthread_mutex_unlock(&cqi_freelist_lock);
	}

	return item;
}//end cqi_new

//并非释放，而是像内存池那样归还  
static void cqi_free(CQ_ITEM *item) {  
    pthread_mutex_lock(&cqi_freelist_lock);  
    item->next = cqi_freelist;  
    cqi_freelist = item;  //头插法归还  
    pthread_mutex_unlock(&cqi_freelist_lock);  
}  


/*
 * Creates a worker thread.
 */
static void create_worker(void *(*func)(void *), void *arg) {
    pthread_t       thread;
    pthread_attr_t  attr;
    int             ret;

    pthread_attr_init(&attr);

    if ((ret = pthread_create(&thread, &attr, func, arg)) != 0) {
        fprintf(stderr, "Can't create thread: %s\n",
                strerror(ret));
        exit(1);
    }
}

/****************************** LIBEVENT THREADS *****************************/

/*
 * Set up a thread's information.
 */
static void setup_thread(LIBEVENT_THREAD *me) {
	me->base = event_init();//新建一个event_base
	if (! me->base) {
		fprintf(stderr, "Can't allocate event base\n");
		exit(1);
	}

	//监听管道的读端  
	event_set(&me->notify_event, me->notify_receive_fd,//监听管道的读端  
			EV_READ | EV_PERSIST, thread_libevent_process, me); //等同于event_new  
	event_base_set(me->base, &me->notify_event);//将event_base和event相关联  

	if (event_add(&me->notify_event, 0) == -1) {
		fprintf(stderr, "Can't monitor libevent notify pipe\n");
		exit(1);
	}

	//创建一个CQ队列  
	me->new_conn_queue = malloc(sizeof(struct conn_queue));
	if (me->new_conn_queue == NULL) {
		perror("Failed to allocate memory for connection queue");
		exit(EXIT_FAILURE);
	}
	cq_init(me->new_conn_queue);

	if (pthread_mutex_init(&me->stats.mutex, NULL) != 0) {
		perror("Failed to initialize mutex");
		exit(EXIT_FAILURE);
	}

	me->suffix_cache = cache_create("suffix", SUFFIX_SIZE, sizeof(char*),
			NULL, NULL);
	if (me->suffix_cache == NULL) {
		fprintf(stderr, "Failed to create suffix cache\n");
		exit(EXIT_FAILURE);
	}
}//end  setup_thread


/*
 * Worker thread: main event loop
 */
static void *worker_libevent(void *arg) {
    LIBEVENT_THREAD *me = arg;

    /* Any per-thread setup can happen here; thread_init() will block until
     * all threads have finished initializing.
     */

    /* set an indexable thread-specific memory item for the lock type.
     * this could be unnecessary if we pass the conn *c struct through
     * all item_lock calls...
     */
    me->item_lock_type = ITEM_LOCK_GRANULAR;
    pthread_setspecific(item_lock_type_key, &me->item_lock_type);

    register_thread_initialized();

    event_base_loop(me->base, 0);
    return NULL;
}

//现在主线程已经通知了选定的worker线程。接下来就是worker线程怎么处理这个通知了。
//下面看一下worker线程的管道可读事件回调函数thread_libevent_process。

//memcached为每一个连接申请一个conn结构体进行维护。
//conn_new函数内部会为这个socket fd申请一个event并添加到该worker线程的event_base里面。
//当客户端发送命令时，worker线程就能监听到。这个conn_new函数前面已经说过了，这里也就不给出代码了。

//在以后，都是worker线程负责这里这个客户端的一切通信，也是worker线程负责完成客户端的命令，包括申请内存存储数据、查询数据、删掉数据。
//这些苦工都是worker线程完成的，而没有其它线程帮忙。
//不过大可放心，memcached对于这命令一般都能在常数时间时间复杂度内完成。
//所以，即使一个worker线程有多个客户端连接，也完全应付得过来。

/*
 * Processes an incoming "handle a new connection" item. This is called when
 * input arrives on the libevent wakeup pipe.
 */
static void thread_libevent_process(int fd, short which, void *arg) {
    LIBEVENT_THREAD *me = arg;
    CQ_ITEM *item;
    char buf[1];

    if (read(fd, buf, 1) != 1)
        if (settings.verbose > 0)
            fprintf(stderr, "Can't read from libevent pipe\n");

    switch (buf[0]) {
    case 'c':
	//从CQ队列中读取一个item,因为是pop所以读取后，CQ队列会把这个item从队列中删除  
    item = cq_pop(me->new_conn_queue);

    if (NULL != item) {
		//为sfd分配一个conn结构体，并且为这个sfd建立一个event，然后让base监听这个event  
		//这个sfd的事件回调函数是event_handler  
        conn *c = conn_new(item->sfd, item->init_state, item->event_flags,
                           item->read_buffer_size, item->transport, me->base);
        if (c == NULL) {
            if (IS_UDP(item->transport)) {
                fprintf(stderr, "Can't listen for events on UDP socket\n");
                exit(1);
            } else {
                if (settings.verbose > 0) {
                    fprintf(stderr, "Can't listen for events on fd %d\n",
                        item->sfd);
                }
                close(item->sfd);
            }
        } else {
            c->thread = me;
        }
        cqi_free(item);
    }
        break;
    /* we were told to flip the lock type and report in */
    case 'l':
    me->item_lock_type = ITEM_LOCK_GRANULAR;
    register_thread_initialized();
        break;
    case 'g':
    me->item_lock_type = ITEM_LOCK_GLOBAL;
    register_thread_initialized();
        break;
    }
}//end  thread_libevent_process()

/*
 * Dispatches a new connection to another thread. This is only ever called
 * from the main thread, either during initialization (for UDP) or because
 * of an incoming connection.
 */
void dispatch_conn_new(int sfd, enum conn_states init_state, int event_flags,
                       int read_buffer_size, enum network_transport transport) {
    CQ_ITEM *item = cqi_new();//申请一个CQ_ITEM
    char buf[1];
    if (item == NULL) {
        close(sfd);
        /* given that malloc failed this may also fail, but let's try */
        fprintf(stderr, "Failed to allocate memory for connection object\n");
        return ;
    }

    int tid = (last_thread + 1) % settings.num_threads;//轮询的方式选定一个worker线程

    LIBEVENT_THREAD *thread = threads + tid;

    last_thread = tid;

    item->sfd = sfd;
    item->init_state = init_state;
    item->event_flags = event_flags;
    item->read_buffer_size = read_buffer_size;
    item->transport = transport;

    cq_push(thread->new_conn_queue, item);////把这个item放到选定的worker线程的CQ队列中

    MEMCACHED_CONN_DISPATCH(sfd, thread->thread_id);
    buf[0] = 'c';
    if (write(thread->notify_send_fd, buf, 1) != 1) {////通知worker线程，有新客户端连接到来
        perror("Writing to thread notify pipe");
    }
}//end  dispatch_conn_new()


//这边的item_*系列的方法，就是Memcached核心存储块的接口  

//怎么使用引用计数：
//当然即使有了引用计数还是需要加锁的。
//因为在获取item和增加引用计数这一间隔，可能有其他线程把这个item给删除了。
//所以一般流程是这样：worker线程先加锁，然后获取item，之后增加这item的引用计数，最后释放锁。
//此时worker线程就占有了这个item，其他worker线程在执行删除操作时必须检测这个item的引用计数是否为0，
//也就是检查是否还有其他worker线程在使用(引用)这个item
item *item_get(const char *key, const size_t nkey) {  
    item *it;  
    uint32_t hv;  
    hv = hash(key, nkey); //对key进行hash,返回一个uint32_t类型的值  
    item_lock(hv); //块锁，当取数据的时候，不允许其他的操作，保证取数据的原子性  
    it = do_item_get(key, nkey, hv);  
    item_unlock(hv);  
    return it;  
}  

/*
 * Decrements the reference count on an item and adds it to the freelist if
 * needed.
 */
void item_remove(item *item) {
    uint32_t hv;
    hv = hash(ITEM_key(item), item->nkey);

    item_lock(hv);
    do_item_remove(item);
    item_unlock(hv);
}

enum store_item_type store_item(item *item, int comm, conn* c) {  
    enum store_item_type ret;  
    uint32_t hv;  
  
    hv = hash(ITEM_key(item), item->nkey);  
    item_lock(hv);  
    ret = do_store_item(item, comm, c, hv);  
    item_unlock(hv);  
    return ret;  
}  


//每一个线程都有一个LIBEVENT_THREAD结构体，现在来看一下具体的代码实现。
//注意代码里面监听管道可读的event的回调函数是thread_libevent_process，
//回调参数是线程自己的LIBEVENT_THREAD结构体指针。

//参数nthreads是worker线程的数量。main_base则是主线程的event_base  
//主线程在main函数 调用本函数，创建nthreads个worker线程  
/*
 * Initializes the thread subsystem, creating various worker threads.
 *
 * nthreads  Number of worker event handler threads to spawn
 * main_base Event base for main thread
 */
void thread_init(int nthreads, struct event_base *main_base) {
	int         i;
	int         power;

	pthread_mutex_init(&cache_lock, NULL);
	pthread_mutex_init(&stats_lock, NULL);

	pthread_mutex_init(&init_lock, NULL);
	pthread_cond_init(&init_cond, NULL);
	//申请一个CQ_ITEM时需要加锁，后面会介绍  
	pthread_mutex_init(&cqi_freelist_lock, NULL);
	cqi_freelist = NULL;

	//nthreads是workers线程的数量，由main函数调用时传入来  
	/* Want a wide lock table, but don't waste memory */
	if (nthreads < 3) {
		power = 10;
	} else if (nthreads < 4) {
		power = 11;
	} else if (nthreads < 5) {
		power = 12;
	} else {
		/* 8192 buckets, and central locks don't scale much past 5 threads */
		power = 13;
	}

	item_lock_count = hashsize(power);
	item_lock_hashpower = power;

	//哈希表中段级别的锁。并不是一个桶就对应有一个锁。而是多个桶共用一个锁  
	item_locks = calloc(item_lock_count, sizeof(pthread_mutex_t));
	if (! item_locks) {
		perror("Can't allocate item locks");
		exit(1);
	}
	for (i = 0; i < item_lock_count; i++) {
		pthread_mutex_init(&item_locks[i], NULL);
	}
	pthread_key_create(&item_lock_type_key, NULL);
	pthread_mutex_init(&item_global_lock, NULL);

	//申请具有nthreads个元素的LIBEVENT_THREAD数组
	threads = calloc(nthreads, sizeof(LIBEVENT_THREAD));
	if (! threads) {
		perror("Can't allocate thread descriptors");
		exit(1);
	}

	dispatcher_thread.base = main_base;
	dispatcher_thread.thread_id = pthread_self();

	for (i = 0; i < nthreads; i++) {
		int fds[2];
		if (pipe(fds)) {//为每个worker线程分配一个管道，用于通知worker线程
			perror("Can't create notify pipe");
			exit(1);
		}

		threads[i].notify_receive_fd = fds[0];
		threads[i].notify_send_fd = fds[1];

		//每一个线程配一个event_base,并设置event监听notify_receive_fd的读事件  
		//同时还为这个线程分配一个conn_queue队列  
		setup_thread(&threads[i]);

		/* Reserve three fds for the libevent base, and two for the pipe */
		stats.reserved_fds += 5;
	}

	/* Create threads after we've done all the libevent setup. */
	for (i = 0; i < nthreads; i++) {
		//创建线程，线程函数为worker_libevent, 线程参数为&threads[i]  
		create_worker(worker_libevent, &threads[i]);
	}

	/* Wait for all the threads to set themselves up before returning. */
	pthread_mutex_lock(&init_lock);
	wait_for_thread_registration(nthreads);
	pthread_mutex_unlock(&init_lock);
}//end thread_init



