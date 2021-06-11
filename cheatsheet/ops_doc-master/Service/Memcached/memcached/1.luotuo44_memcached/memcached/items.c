#define LARGEST_ID POWER_LARGEST

//注意上面代码是在items.c文件的，并且全局变量itemstats是static类型。
//itemstats变量是一个数组，它是和slabclass数组一一对应的。
//itemstats数组的元素负责收集slabclass数组中对应元素的信息。
//itemstats_t结构体虽然提供了很多成员，可以收集很多信息，但automove线程只用到第一个成员evicted。
//automove线程需要知道每一个尺寸的item的被踢情况，然后判断哪一类item资源紧缺，哪一类item资源又过剩。

typedef struct {  
    uint64_t evicted;//因为LRU踢了多少个item  
    //即使一个item的exptime设置为0，也是会被踢的  
    uint64_t evicted_nonzero;//被踢的item中，超时时间(exptime)不为0的item数  
    //最后一次踢item时，被踢的item已经过期多久了  
    //itemstats[id].evicted_time = current_time - search->time;  
    rel_time_t evicted_time;  
    uint64_t reclaimed;//在申请item时，发现过期并回收的item数量  
    uint64_t outofmemory;//为item申请内存，失败的次数  
    uint64_t tailrepairs;//需要修复的item数量(除非worker线程有问题否则一般为0)  
    //直到被超时删除时都还没被访问过的item数量  
    uint64_t expired_unfetched;  
    //直到被LRU踢出时都还没有被访问过的item数量  
    uint64_t evicted_unfetched;  
    uint64_t crawler_reclaimed;//被LRU爬虫发现的过期item数量  
    //申请item而搜索LRU队列时，被其他worker线程引用的item数量  
    uint64_t lrutail_reflocked;  
} itemstats_t;  

static item *heads[LARGEST_ID];
static item *tails[LARGEST_ID];
static crawler crawlers[LARGEST_ID];
static itemstats_t itemstats[LARGEST_ID];
static unsigned int sizes[LARGEST_ID];

static int crawler_count = 0;//本次任务要处理多少个LRU队列
static volatile int do_run_lru_crawler_thread = 0;
static int lru_crawler_initialized = 0;
static pthread_mutex_t lru_crawler_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  lru_crawler_cond = PTHREAD_COND_INITIALIZER;

//do_开头的函数:
//item操作都是需要加锁的，因为可能多个worker线程同时操作哈希表和LRU队列。
//功能函数: 函数名以do_作为前缀是
//包裹函数:去掉前缀do_,中加锁和解锁

uint64_t get_cas_id(void) {
    static uint64_t cas_id = 0;
    return ++cas_id;
}

//获取1个item存了数据后的实际总长度, 但是缺少cas的长度
static size_t item_make_header(const uint8_t nkey, const int flags, const int nbytes,
                     char *suffix, uint8_t *nsuffix) {
    /* suffix is defined at 40 chars elsewhere.. */
    *nsuffix = (uint8_t) snprintf(suffix, 40, " %d %d\r\n", flags, nbytes - 2);
    return sizeof(item) + nkey + *nsuffix + nbytes;
}

//tail_repair_time：
//考虑这样的情况:某个worker线程通过refcount_incr增加了一个item的引用数。
//但由于某种原因(可能是内核出了问题)，这个worker线程还没来得及调用refcount_decr就挂了。
//此时这个item的引用数就肯定不会等于0，也就是总有worker线程占用着它.
//但实际上这个worker线程早就挂了。所以对于这种情况需要修复。
//修复也很多简单：直接把这个item的引用计数赋值为1。

//根据什么判断某一个worker线程挂了呢?
//首先在memcached里面，一般来说，任何函数都的调用都不会耗时太大的，即使这个函数需要加锁。
//所以如果这个item的最后一次访问时间距离现在都比较遥远了，
//但它却还被一个worker线程所引用，那么就几乎可以判断这个worker线程挂了。
//在1.4.16版本之前，这个时间距离都是固定的为3个小时。
//从1.4.16开就使用settings.tail_repair_time存储时间距离，可以在启动memcached的时候设置，默认时间距离为1个小时。
//现在这个版本1.4.21默认都不进行这个修复了，settings.tail_repair_time的默认值为0。
//因为memcached的作者很少看到这个bug了，估计是因为操作系统的进一步稳定。
//上面的版本说明来自链接1和链接2。

//settings.tail_repair_time指明有没有开启这种检测，默认是没有开启的(默认值等于0)。
//可以在启动memcached的时候通过-o tail_repair_time选项开启。
//具体可以参考《memcached启动参数详解以及关键配置的默认值》。

//=======================================================================================================

//itemstats广泛分布在items.c文件的多个函数中(主要是为了能收集各种数据)，所以这里就不给出itemstats的具体收集实现了。
//当然由于evicted是重要的而且只在一个函数出现，就贴出evicted的收集代码吧。

//=======================================================================================================

//key、flags、exptime三个参数是用户在使用set、add命令存储一条数据时输入的参数。  
//nkey是key字符串的长度。nbytes则是用户要存储的data长度+2,因为在data的结尾处还要加上"\r\n"  
//cur_hv则是根据键值key计算得到的哈希值。
item *do_item_alloc(char *key, const size_t nkey, const int flags,
                    const rel_time_t exptime, const int nbytes,
                    const uint32_t cur_hv) {
    uint8_t nsuffix;
    item *it = NULL;
    char suffix[40];
    //要存储这个item需要的总空间。要注意第一个参数是nkey+1，所以上面的那些宏计算时  
    //使用了(item)->nkey + 1 
    size_t ntotal = item_make_header(nkey + 1, flags, nbytes, suffix, &nsuffix);
    if (settings.use_cas) {
        ntotal += sizeof(uint64_t);
    }

    //根据大小判断从属于哪个slab  
    unsigned int id = slabs_clsid(ntotal);
	//0表示不属于任何一个slab
    if (id == 0)
        return 0;

    mutex_lock(&cache_lock);
    /* do a quick check if we have any expired items in the tail.. */
    int tries = 5;
    /* Avoid hangs if a slab has nothing but refcounted stuff in it. */
    int tries_lrutail_reflocked = 1000;
    int tried_alloc = 0;
    item *search;
    item *next_it;
    void *hold_lock = NULL;
    rel_time_t oldest_live = settings.oldest_live;

    search = tails[id];
    /* We walk up *only* for locked items. Never searching for expired.
     * Waste of CPU for almost all deployments */
     //第一次看这个for循环，直接认为search等于NULL，直接看for循环后面的代码  
     //这个循环里面会在对应LRU队列中查找过期失效的item，最多尝试tries个item。  
     //从LRU的队尾开始尝试。如果item被其他worker线程引用了，那么就尝试下一  
     //个。如果没有的被其他worker线程所引用，那么就测试该item是否过期失效。  
     //如果过期失效了，那么就可以使用这个item(最终会返回这个item)。如果没有  
     //过期失效，那么不再尝试其他item了(因为是从LRU队列的队尾开始尝试的),  
     //直接调用slabs_alloc申请一个新的内存存储item。如果申请新内存都失败，  
     //那么在允许LRU淘汰的情况下就会启动踢人机制。
    for (; tries > 0 && search != NULL; tries--, search=next_it) {
        /* we might relink search mid-loop, so search->prev isn't reliable */
        next_it = search->prev;
        if (search->nbytes == 0 && search->nkey == 0 && search->it_flags == 1) {
            /* We are a crawler, ignore it. */
            //这是一个爬虫item，直接跳过  
            tries++;//爬虫item不计入尝试的item数中  
            continue;
        }
        uint32_t hv = hash(ITEM_key(search), search->nkey);
        /* Attempt to hash item lock the "search" item. If locked, no
         * other callers can incr the refcount
         */
        /* Don't accidentally grab ourselves, or bail if we can't quicklock */
        //尝试抢占锁，抢不了就走人，不等待锁。  
        if (hv == cur_hv || (hold_lock = item_trylock(hv)) == NULL)
            continue;
        /* Now see if the item is refcount locked */
        if (refcount_incr(&search->refcount) != 2) {//引用数>=3，还有其他线程在引用，不能霸占这个item
            /* Avoid pathological case with ref'ed items in tail */
			//刷新这个item的访问时间以及在LRU队列中的位置 
            do_item_update_nolock(search);
            tries_lrutail_reflocked--;
            tries++;
            refcount_decr(&search->refcount);
            //此时引用数>=2  
            itemstats[id].lrutail_reflocked++;
            /* Old rare bug could cause a refcount leak. We haven't seen
             * it in years, but we leave this code in to prevent failures
             * just in case */
            //考虑这样的情况:某一个worker线程通过refcount_incr增加了一个  
            //item的引用数。但由于某种原因(可能是内核出了问题)，这个worker  
            //线程还没来得及调用refcount_decr就挂了。此时这个item的引用数  
            //就肯定不会等于0，也就是总有worker线程占用着它.但实际上这个  
            //worker线程早就挂了。所以对于这种情况需要修复。直接把这个item  
            //的引用计数赋值为1。  
            //根据什么判断某一个worker线程挂了呢?首先在memcached里面，一般  
            //来说，任何函数都的调用都不会耗时太大的，即使这个函数需要加锁  
            //所以如果这个item的最后一次访问时间距离现在都比较遥远了，但它  
            //却还被一个worker所引用，那么就几乎可以判断这个worker线程挂了.  
            //在1.4.16版本之前，这个时间距离都是固定的为3个小时。从1.4.16开  
            //就使用settings.tail_repair_time存储时间距离，可以在启动memcached  
            //的时候设置，默认时间距离为1个小时。现在这个版本1.4.21默认都不  
            //进行这个修复了，settings.tail_repair_time的默认值为0。因为  
            //memcached的作者很少看到这个bug了，估计是因为操作系统的进一步稳定  
            //http://brionas.github.io/2014/01/06/memcached-manage/  
            //http://www.oschina.net/news/46787/memcached-1-4-16
            if (settings.tail_repair_time &&
                    search->time + settings.tail_repair_time < current_time) {
                itemstats[id].tailrepairs++;
                search->refcount = 1;
                do_item_unlink_nolock(search, hv);
            }
            if (hold_lock)
                item_trylock_unlock(hold_lock);

            if (tries_lrutail_reflocked < 1)
                break;

            continue;
        }

        //search指向的item的refcount等于2，这说明此时这个item除了本worker  
        //线程外，没有其他任何worker线程索引其。可以放心释放并重用这个item  
          
        //因为这个循环是从lru链表的后面开始遍历的。所以一开始search就指向  
        //了最不常用的item，如果这个item都没有过期。那么其他的比其更常用  
        //的item就不要删除了(即使它们过期了)。此时只能向slabs申请内存
        /* Expired or flushed */
        if ((search->exptime != 0 && search->exptime < current_time)
            || (search->time <= oldest_live && oldest_live <= current_time)) {
			//search指向的item是一个过期失效的item，可以使用之
            itemstats[id].reclaimed++;
            if ((search->it_flags & ITEM_FETCHED) == 0) {
                itemstats[id].expired_unfetched++;
            }
            it = search;
            //重新计算一下这个slabclass_t分配出去的内存大小  
            //直接霸占旧的item就需要重新计算  
            slabs_adjust_mem_requested(it->slabs_clsid, ITEM_ntotal(it), ntotal);
            do_item_unlink_nolock(it, hv);//从哈希表和lru链表中删除
            /* Initialize the item block: */
            it->slabs_clsid = 0;
        } else if ((it = slabs_alloc(ntotal, id)) == NULL) {//申请内存失败  
            //前面if过期失效的item没有找到.这里else if申请内存又失败了。
			//看来只能使用LRU淘汰一个item(即使这个item并没有过期失效)
            tried_alloc = 1;//标志尝试过了alloc
            if (settings.evict_to_free == 0) {//设置了不进行LRU淘汰item
                //此时只能向客户端回复错误了  
                itemstats[id].outofmemory++;
            } else {
                itemstats[id].evicted++;//增加被踢的item数 
                itemstats[id].evicted_time = current_time - search->time;
                //即使一个item的exptime成员设置为永不超时(0)，还是会被踢的  
                if (search->exptime != 0)
                    itemstats[id].evicted_nonzero++;
                if ((search->it_flags & ITEM_FETCHED) == 0) {
                    itemstats[id].evicted_unfetched++;
                }
                it = search;
                //重新计算一下这个slabclass_t分配出去的内存大小  
                //直接霸占旧的item就需要重新计算  
                slabs_adjust_mem_requested(it->slabs_clsid, ITEM_ntotal(it), ntotal);
                do_item_unlink_nolock(it, hv);//从哈希表和lru链表中删除
                /* Initialize the item block: */
                it->slabs_clsid = 0;

				//一旦发现有item被踢，那么就启动内存页重分配操作  
                //这个太频繁了，不推荐   
                /* If we've just evicted an item, and the automover is set to
                 * angry bird mode, attempt to rip memory into this slab class.
                 * TODO: Move valid object detection into a function, and on a
                 * "successful" memory pull, look behind and see if the next alloc
                 * would be an eviction. Then kick off the slab mover before the
                 * eviction happens.
                 */
                if (settings.slab_automove == 2)
                    slabs_reassign(-1, id);
            }
        }
        //引用计数减一。此时该item已经没有任何worker线程索引其，并且哈希表也  
        //不再索引其
        refcount_decr(&search->refcount);
        /* If hash values were equal, we don't grab a second lock */
        if (hold_lock)
            item_trylock_unlock(hold_lock);
        break;
    }

    //没有尝试过alloc，并且在查找特定次数后还是没有找到可用的item  
    if (!tried_alloc && (tries == 0 || search == NULL))
        it = slabs_alloc(ntotal, id);//从slab分配器中申请内存

    if (it == NULL) {
        itemstats[id].outofmemory++;
        mutex_unlock(&cache_lock);
        return NULL;
    }

    assert(it->slabs_clsid == 0);
    assert(it != heads[id]);

    /* Item initialization can happen outside of the lock; the item's already
     * been removed from the slab LRU.
     */
    it->refcount = 1;     /* the caller will have a reference */
    mutex_unlock(&cache_lock);
    //脱离之前的前后关系  
    it->next = it->prev = it->h_next = 0;
    it->slabs_clsid = id;

    //此时这个item没有插入任何LRU队列和没有插入到哈希表中  

    DEBUG_REFCNT(it, '*');
    //默认情况下memcached是支持CAS的，如果想取消可以在启动memcached的时候加入  
    //参数C(大写的c)  
    it->it_flags = settings.use_cas ? ITEM_CAS : 0;
    it->nkey = nkey;
    it->nbytes = nbytes;
    memcpy(ITEM_key(it), key, nkey);
    it->exptime = exptime;
    memcpy(ITEM_suffix(it), suffix, (size_t)nsuffix);
    it->nsuffix = nsuffix;
    return it;
}//end do_item_alloc()


void item_free(item *it) {
    size_t ntotal = ITEM_ntotal(it);
    unsigned int clsid;
    assert((it->it_flags & ITEM_LINKED) == 0);
    assert(it != heads[it->slabs_clsid]);
    assert(it != tails[it->slabs_clsid]);
    assert(it->refcount == 0);

    /* so slab size changer can tell later if item is already free or not */
    clsid = it->slabs_clsid;
    it->slabs_clsid = 0;
    DEBUG_REFCNT(it, 'F');
    slabs_free(it, ntotal, clsid);
}//end item_free()




//对于memcached来说几乎所有的操作时间复杂度都是常数级的。
//插入操作：
//假设我们有一个item要插入到LRU链表中，那么可以通过调用item_link_q函数把item插入到LRU队列中。
//将item插入到LRU队列的头部  
static void item_link_q(item *it) { /* item is the new head */  
    item **head, **tail;  
    assert(it->slabs_clsid < LARGEST_ID);  
	//确保这个item已经从slab分配出去
    assert((it->it_flags & ITEM_SLABBED) == 0);  
  
    head = &heads[it->slabs_clsid];  
    tail = &tails[it->slabs_clsid];  
    assert(it != *head);  
    assert((*head && *tail) || (*head == 0 && *tail == 0));  
  
    //头插法插入该item  
    it->prev = 0;  
    it->next = *head;  
    if (it->next) it->next->prev = it;  
    *head = it;//该item作为对应链表的第一个节点  
  
    //如果该item是对应id上的第一个item，那么还会被认为是该id链上的最后一个item  
    //因为在head那里使用头插法，所以第一个插入的item，到了后面确实成了最后一个item  
    if (*tail == 0) *tail = it;  
    sizes[it->slabs_clsid]++;//个数加一  
    return;  
}//end  item_link_q()  

//删除操作：
//有了插入函数，肯定有对应的删除函数。
//删除函数是蛮简单，主要是处理删除这个节点后，该节点的前后驱节点怎么拼接在一起。
//将it从对应的LRU队列中删除  
static void item_unlink_q(item *it) {  
    item **head, **tail;  
    assert(it->slabs_clsid < LARGEST_ID);  
    head = &heads[it->slabs_clsid];  
    tail = &tails[it->slabs_clsid];  
  
      
    if (*head == it) {//链表上的第一个节点  
        assert(it->prev == 0);  
        *head = it->next;  
    }  
    if (*tail == it) {//链表上的最后一个节点  
        assert(it->next == 0);  
        *tail = it->prev;  
    }  
    assert(it->next != it);  
    assert(it->prev != it);  
  
    //把item的前驱节点和后驱节点连接起来  
    if (it->next) it->next->prev = it->prev;  
    if (it->prev) it->prev->next = it->next;  
    sizes[it->slabs_clsid]--;//个数减一  
    return;  
}//end  item_unlink_q  


//将item插入到哈希表和LRU队列中，插入到哈希表需要哈希值hv  
int do_item_link(item *it, const uint32_t hv) {
    MEMCACHED_ITEM_LINK(ITEM_key(it), it->nkey, it->nbytes);
    //确保这个item已经从slab分配出去并且还没插入到LRU队列中  
    assert((it->it_flags & (ITEM_LINKED|ITEM_SLABBED)) == 0);
    //当哈希表不在为扩展而迁移数据时，就往哈希表插入item  
    //当哈希表在迁移数据时，会占有这个锁。 
    mutex_lock(&cache_lock);
    it->it_flags |= ITEM_LINKED;
    it->time = current_time;

    STATS_LOCK();
    stats.curr_bytes += ITEM_ntotal(it);
    stats.curr_items += 1;
    stats.total_items += 1;
    STATS_UNLOCK();

    /* Allocate a new CAS ID on link. */
    ITEM_set_cas(it, (settings.use_cas) ? get_cas_id() : 0);
    assoc_insert(it, hv);//插入到hashtable
    item_link_q(it);//插入到LRU队列
    refcount_incr(&it->refcount);//引用计数加一
    mutex_unlock(&cache_lock);

    return 1;
}//end do_item_link()


//从哈希表删除，所以需要哈希值hv  
void do_item_unlink(item *it, const uint32_t hv) {
    MEMCACHED_ITEM_UNLINK(ITEM_key(it), it->nkey, it->nbytes);
    mutex_lock(&cache_lock);
    if ((it->it_flags & ITEM_LINKED) != 0) {
        it->it_flags &= ~ITEM_LINKED;
        STATS_LOCK();
        stats.curr_bytes -= ITEM_ntotal(it);
        stats.curr_items -= 1;
        STATS_UNLOCK();
        assoc_delete(ITEM_key(it), it->nkey, hv);//将这个item从哈希表中删除
        item_unlink_q(it);//从链表中删除该item
        do_item_remove(it);//向slab归还这个item
    }
    mutex_unlock(&cache_lock);
}//end do_item_unlink()


//向slab归还这个item 
//在使用do_item_remove函数向slab归还item时，会先测试这个item的引用数是否等于0。
//引用数可以简单理解为是否有worker线程在使用这个item。
//引用数的将会在后面的《item引用计数》中详细讲解。
void do_item_remove(item *it) {
    MEMCACHED_ITEM_REMOVE(ITEM_key(it), it->nkey, it->nbytes);
    assert((it->it_flags & ITEM_SLABBED) == 0);
    assert(it->refcount > 0);

    if (refcount_decr(&it->refcount) == 0) {//引用计数等于0的时候归还  
        item_free(it);//归还该item给slab  
    }
}//end do_item_remove()


//更新操作：
//为什么要把item插入到LRU队列头部呢？
//当然实现简单是其中一个原因。
//但更重要的是这是一个LRU队列！！
//还记得操作系统里面的LRU吧。这是一种淘汰机制。
//在LRU队列中，排得越靠后就认为是越少使用的item，此时被淘汰的几率就越大。
//所以新鲜item(访问时间新)，要排在不那么新鲜item的前面，所以插入LRU队列的头部是不二选择。
//下面的do_item_update函数佐证了这一点。
//do_item_update函数是先把旧的item从LRU队列中删除，然后再插入到LRU队列中(此时它在LRU队列中排得最前)。
//除了更新item在队列中的位置外，还会更新item的time成员，该成员指明上一次访问的时间(绝对时间)。
//如果不是为了LRU，那么do_item_update函数最简单的实现就是直接更新time成员即可。
void do_item_update(item *it) {  
    //下面的代码可以看到update操作是耗时的。如果这个item频繁被访问，  
    //那么会导致过多的update，过多的一系列费时操作。此时更新间隔就应运而生  
    //了。如果上一次的访问时间(也可以说是update时间)距离现在(current_time)  
    //还在更新间隔内的，就不更新。超出了才更新。  
    if (it->time < current_time - ITEM_UPDATE_INTERVAL) {  
  
        mutex_lock(&cache_lock);  
        if ((it->it_flags & ITEM_LINKED) != 0) {  
            item_unlink_q(it);//从LRU队列中删除  
            it->time = current_time;//更新访问时间  
            item_link_q(it);//插入到LRU队列的头部  
        }  
        mutex_unlock(&cache_lock);  
    }  
}//end do_item_update()

int item_replace(item *old_it, item *new_it, const uint32_t hv) {  
    return do_item_replace(old_it, new_it, hv);  
}  
  
//把旧的删除，插入新的。replace命令会调用本函数.  
//无论旧item是否有其他worker线程在引用，都是直接将之从哈希表和LRU队列中删除  
int do_item_replace(item *it, item *new_it, const uint32_t hv) {  
    MEMCACHED_ITEM_REPLACE(ITEM_key(it), it->nkey, it->nbytes,  
                           ITEM_key(new_it), new_it->nkey, new_it->nbytes);  
    assert((it->it_flags & ITEM_SLABBED) == 0);  
  
    do_item_unlink(it, hv);//直接丢弃旧item  
    return do_item_link(new_it, hv);//插入新item，作为替换  
}  

void item_stats_evictions(uint64_t *evicted) {
    int i;
    mutex_lock(&cache_lock);
    for (i = 0; i < LARGEST_ID; i++) {
        evicted[i] = itemstats[i].evicted;
    }
    mutex_unlock(&cache_lock);
}

/** wrapper around assoc_find which does the lazy expiration logic */
//调用do_item_get的函数都已经加上了item_lock(hv)段级别锁或者全局锁  
item *do_item_get(const char *key, const size_t nkey, const uint32_t hv) {
    //mutex_lock(&cache_lock);
    item *it = assoc_find(key, nkey, hv);//assoc_find函数内部没有加锁
    if (it != NULL) {//找到了，此时item的引用计数至少为1
        refcount_incr(&it->refcount);//线程安全地自增一
        /* Optimization for slab reassignment. prevents popular items from
         * jamming in busy wait. Can only do this here to satisfy lock order
         * of item_lock, cache_lock, slabs_lock. */
		//这个item刚好在要移动的内存页里面。此时不能返回这个item  
		//worker线程要负责把这个item从哈希表和LRU队列中删除这个item，避免  
		//后面有其他worker线程又访问这个不能使用的item
        if (slab_rebalance_signal &&
            ((void *)it >= slab_rebal.slab_start && (void *)it < slab_rebal.slab_end)) {
            do_item_unlink_nolock(it, hv);
            do_item_remove(it);
            it = NULL;
        }
    }
    //mutex_unlock(&cache_lock);
    int was_found = 0;

    if (settings.verbose > 2) {
        int ii;
        if (it == NULL) {
            fprintf(stderr, "> NOT FOUND ");
        } else {
            fprintf(stderr, "> FOUND KEY ");
            was_found++;
        }
        for (ii = 0; ii < nkey; ++ii) {
            fprintf(stderr, "%c", key[ii]);
        }
    }

    if (it != NULL) {
		//settings.oldest_live初始化值为0  
        //检测用户是否使用过flush_all命令，删除所有item。  
        //it->time <= settings.oldest_live就说明用户在使用flush_all命令的时候  
        //就已经存在该item了。那么该item是要删除的。  
        //flush_all命令可以有参数，用来设定在未来的某个时刻把所有的item都设置  
        //为过期失效，此时settings.oldest_live是一个比worker接收到flush_all  
        //命令的那一刻大的时间,所以要判断settings.oldest_live <= current_time  
		//settings.oldest_live != 0 说明其他线程执行过flush_all
        if (settings.oldest_live != 0 && settings.oldest_live <= current_time &&
            it->time <= settings.oldest_live) {//flush_all:懒惰删除
            do_item_unlink(it, hv);//引用计数会减一  
            do_item_remove(it);//引用计数减一,如果引用计数等于0，就删除
            it = NULL;
            if (was_found) {
                fprintf(stderr, " -nuked by flush");
            }
        } else if (it->exptime != 0 && it->exptime <= current_time) {//item过期:懒惰删除
            do_item_unlink(it, hv);
            do_item_remove(it);
            it = NULL;
            if (was_found) {
                fprintf(stderr, " -nuked by expire");
            }
        } else {
            //把这个item标志为被访问过的  
            it->it_flags |= ITEM_FETCHED;
            DEBUG_REFCNT(it, '+');
        }
    }

    if (settings.verbose > 2)
        fprintf(stderr, "\n");

    return it;
}//end do_item_get()

void do_item_flush_expired(void) {  
    int i;  
    item *iter, *next;  
    if (settings.oldest_live == 0)  
        return;  
    for (i = 0; i < LARGEST_ID; i++) {  
        for (iter = heads[i]; iter != NULL; iter = next) {  
            //iter->time == 0的是lru爬虫item，直接忽略  
            //一般情况下iter->time是小于settings.oldest_live的。但在这种情况下  
            //就有可能出现iter->time >= settings.oldest_live :  worker1接收到  
            //flush_all命令，并给settings.oldest_live赋值为current_time-1。  
            //worker1线程还没来得及调用item_flush_expired函数，就被worker2  
            //抢占了cpu，然后worker2往lru队列插入了一个item。这个item的time  
            //成员就会满足iter->time >= settings.oldest_live  
            if (iter->time != 0 && iter->time >= settings.oldest_live) {  
                next = iter->next;  
                if ((iter->it_flags & ITEM_SLABBED) == 0) {  
                    //虽然调用的是nolock,但本函数的调用者item_flush_expired  
                    //已经锁上了cache_lock，才调用本函数的  
                    do_item_unlink_nolock(iter, hash(ITEM_key(iter), iter->nkey));  
                }  
            } else {  
                //因为lru队列里面的item是根据time降序排序的，所以当存在一个item的time成员  
                //小于settings.oldest_live,剩下的item都不需要再比较了  
                break;  
            }  
        }  
    }  
}  

//将这个伪item插入到对应的lru队列的尾部  
static void crawler_link_q(item *it) { /* item is the new tail */
    item **head, **tail;
    assert(it->slabs_clsid < LARGEST_ID);
    assert(it->it_flags == 1);
    assert(it->nbytes == 0);

    head = &heads[it->slabs_clsid];
    tail = &tails[it->slabs_clsid];
    assert(*tail != 0);
    assert(it != *tail);
    assert((*head && *tail) || (*head == 0 && *tail == 0));
    it->prev = *tail;
    it->next = 0;
    if (it->prev) {
        assert(it->prev->next == 0);
        it->prev->next = it;
    }
    *tail = it;
    if (*head == 0) *head = it;
    return;
}//end crawler_link_q




/* This is too convoluted, but it's a difficult shuffle. Try to rewrite it
 * more clearly. */
static item *crawler_crawl_q(item *it) {
    item **head, **tail;
    assert(it->it_flags == 1);
    assert(it->nbytes == 0);
    assert(it->slabs_clsid < LARGEST_ID);
    head = &heads[it->slabs_clsid];
    tail = &tails[it->slabs_clsid];

	//伪item是在LRU队列头部
    /* We've hit the head, pop off */
    if (it->prev == 0) {
        assert(*head == it);
        if (it->next) {
            *head = it->next;
            assert(it->next->prev == it);
            it->next->prev = 0;
        }
        return NULL; /* Done */
    }

	//伪item不是当前LRU队列的唯一一个元素
    /* Swing ourselves in front of the next item */
    /* NB: If there is a prev, we can't be the head */
    assert(it->prev != it);
    if (it->prev) {
        if (*head == it->prev) {
            /* Prev was the head, now we're the head */
            *head = it;
        }
        if (*tail == it) {
            /* We are the tail, now they are the tail */
            *tail = it->prev;
        }
        assert(it->next != it);
        if (it->next) {
            assert(it->prev->next == it);
            it->prev->next = it->next;
            it->next->prev = it->prev;
        } else {
            /* Tail. Move this above? */
            it->prev->next = 0;
        }
        /* prev->prev's next is it->prev */
        it->next = it->prev;
        it->prev = it->next->prev;
        it->next->prev = it;
        /* New it->prev now, if we're not at the head. */
        if (it->prev) {
            it->prev->next = it;
        }
    }
    assert(it->next != it);
    assert(it->prev != it);

    return it->next; /* success */
}//end crawler_crawl_q()

static void *item_crawler_thread(void *arg) {  
    int i;  
  
    pthread_mutex_lock(&lru_crawler_lock);  
    while (do_run_lru_crawler_thread) {  
    //lru_crawler_crawl函数和stop_item_crawler_thread函数会signal这个条件变量  
    pthread_cond_wait(&lru_crawler_cond, &lru_crawler_lock);  
  
    while (crawler_count) {//crawler_count表明要处理多少个LRU队列  
        item *search = NULL;  
        void *hold_lock = NULL;  
  
        for (i = 0; i < LARGEST_ID; i++) {  
            if (crawlers[i].it_flags != 1) {  
                continue;  
            }  
            pthread_mutex_lock(&cache_lock);  
            //返回crawlers[i]的前驱节点,并交换crawlers[i]和前驱节点的位置  
            search = crawler_crawl_q((item *)&crawlers[i]);  
            if (search == NULL || //crawlers[i]是头节点，没有前驱节点  
                //remaining的值为settings.lru_crawler_tocrawl。每次启动lru  
                //爬虫线程，检查每一个lru队列的多少个item。  
                (crawlers[i].remaining && --crawlers[i].remaining < 1)) {  
                //检查了足够多次，退出检查这个lru队列  
                crawlers[i].it_flags = 0;  
                crawler_count--;//清理完一个LRU队列,任务数减一  
                crawler_unlink_q((item *)&crawlers[i]);//将这个伪item从LRU队列中删除  
                pthread_mutex_unlock(&cache_lock);  
                continue;  
            }  
            uint32_t hv = hash(ITEM_key(search), search->nkey);  
            //尝试锁住控制这个item的哈希表段级别锁  
            if ((hold_lock = item_trylock(hv)) == NULL) {  
                pthread_mutex_unlock(&cache_lock);  
                continue;  
            }  
  
            //此时有其他worker线程在引用这个item  
            if (refcount_incr(&search->refcount) != 2) {  
                refcount_decr(&search->refcount);//lru爬虫线程放弃引用该item  
                if (hold_lock)  
                    item_trylock_unlock(hold_lock);  
                pthread_mutex_unlock(&cache_lock);  
                continue;  
            }  
  
            //如果这个item过期失效了，那么就删除这个item  
            item_crawler_evaluate(search, hv, i);  
  
            if (hold_lock)  
                item_trylock_unlock(hold_lock);  
            pthread_mutex_unlock(&cache_lock);  
  
            //lru爬虫不能不间断地爬lru队列，这样会妨碍worker线程的正常业务  
            //所以需要挂起lru爬虫线程一段时间。在默认设置中，会休眠100微秒  
            if (settings.lru_crawler_sleep)  
                usleep(settings.lru_crawler_sleep);//微秒级  
        }  
    }  
    STATS_LOCK();  
    stats.lru_crawler_running = false;  
    STATS_UNLOCK();  
    }  
    pthread_mutex_unlock(&lru_crawler_lock);  
  
    return NULL;  
}//end item_crawler_thread()

//清理item：
//前面说到，可以用命令lru_crawler tocrawl num指定每个LRU队列最多只检查num-1个item。
//看清楚点，是检查数，不是删除数，而且是num-1个。
//首先要调用item_crawler_evaluate函数检查一个item是否过期，是的话就删除。
//如果检查完num-1个，伪item都还没有到达LRU队列的头部，那么就直接将这个伪item从LRU队列中删除。
//如果这个item过期失效了，那么就删除其  
static void item_crawler_evaluate(item *search, uint32_t hv, int i) {  
    rel_time_t oldest_live = settings.oldest_live;  
  
    //这个item的exptime时间戳到了，已经过期失效了  
    if ((search->exptime != 0 && search->exptime < current_time)  
        //因为客户端发送flush_all命令，导致这个item失效了  
        || (search->time <= oldest_live && oldest_live <= current_time)) {  
        itemstats[i].crawler_reclaimed++;  
  
        if ((search->it_flags & ITEM_FETCHED) == 0) {  
            itemstats[i].expired_unfetched++;  
        }  
  
        //将item从LRU队列中删除  
        do_item_unlink_nolock(search, hv);  
        do_item_remove(search);  
        assert(search->slabs_clsid == 0);  
    } else {  
        refcount_decr(&search->refcount);  
    }  
}//end  item_crawler_evaluate()

//下面看一下lru_crawler enable和disable命令。
//enable命令会启动一个LRU爬虫线程，而disable会停止这个LRU爬虫线程，当然不是直接调用pthread_exit停止线程。
//pthread_exit函数是一个危险函数，不应该在代码出现。

//可以看到worker线程在接收到” lru_crawler enable”命令后会启动一个LRU爬虫线程。
//这个LRU爬虫线程还没去执行任务，因为还没有指定任务。
//命令"lru_crawler tocrawl num"并不是启动一个任务。
//对于这个命令，worker线程只是简单地把settings.lru_crawler_tocrawl赋值为num。

static pthread_t item_crawler_tid;  
  
//worker线程接收到"lru_crawler enable"命令后会调用本函数  
//启动memcached时如果有-o lru_crawler参数也是会调用本函数  
int start_item_crawler_thread(void) {  
    int ret;  
  
    //在stop_item_crawler_thread函数可以看到pthread_join函数  
    //在pthread_join返回后，才会把settings.lru_crawler设置为false。  
    //所以不会出现同时出现两个crawler线程  
    if (settings.lru_crawler)  
        return -1;  
      
    pthread_mutex_lock(&lru_crawler_lock);  
    do_run_lru_crawler_thread = 1;  
    settings.lru_crawler = true;  
    //创建一个LRU爬虫线程，线程函数为item_crawler_thread。LRU爬虫线程在进入  
    //item_crawler_thread函数后，会调用pthread_cond_wait，等待worker线程指定  
    //要处理的LRU队列  
    if ((ret = pthread_create(&item_crawler_tid, NULL,  
        item_crawler_thread, NULL)) != 0) {  
        fprintf(stderr, "Can't create LRU crawler thread: %s\n",  
            strerror(ret));  
        pthread_mutex_unlock(&lru_crawler_lock);  
        return -1;  
    }  
    pthread_mutex_unlock(&lru_crawler_lock);  
  
    return 0;  
}  
  
  
//worker线程在接收到"lru_crawler disable"命令会执行这个函数  
int stop_item_crawler_thread(void) {  
    int ret;  
    pthread_mutex_lock(&lru_crawler_lock);  
    do_run_lru_crawler_thread = 0;//停止LRU线程  
    //LRU爬虫线程可能休眠于等待条件变量，需要唤醒才能停止LRU爬虫线程  
    pthread_cond_signal(&lru_crawler_cond);  
    pthread_mutex_unlock(&lru_crawler_lock);  
    if ((ret = pthread_join(item_crawler_tid, NULL)) != 0) {  
        fprintf(stderr, "Failed to stop LRU crawler thread: %s\n", strerror(ret));  
        return -1;  
    }  
    settings.lru_crawler = false;  
    return 0;  
}  

int init_lru_crawler(void) {
    if (lru_crawler_initialized == 0) {
        if (pthread_cond_init(&lru_crawler_cond, NULL) != 0) {
            fprintf(stderr, "Can't initialize lru crawler condition\n");
            return -1;
        }
        pthread_mutex_init(&lru_crawler_lock, NULL);
        lru_crawler_initialized = 1;
    }
    return 0;
}

//下面看一下lru_crawler_crawl函数，memcached会在这个函数会把伪item插入到LRU队列尾部的。
//当worker线程接收到lru_crawler crawl<classid,classid,classid|all>命令时就会调用这个函数。
//因为用户可能要求LRU爬虫线程清理多个LRU队列的过期失效item，所以需要一个伪item数组。
//伪item数组的大小等于LRU队列的个数，它们是一一对应的。
enum crawler_result_type lru_crawler_crawl(char *slabs) {  
    char *b = NULL;  
    uint32_t sid = 0;  
    uint8_t tocrawl[POWER_LARGEST];  
  
    //LRU爬虫线程进行清理的时候，会锁上lru_crawler_lock。直到完成所有  
    //的清理任务才会解锁。所以客户端的前一个清理任务还没结束前，不能  
    //再提交另外一个清理任务     
    if (pthread_mutex_trylock(&lru_crawler_lock) != 0) {  
        return CRAWLER_RUNNING;  
    }  
    pthread_mutex_lock(&cache_lock);  
  
    //解析命令，如果命令要求对某一个LRU队列进行清理，那么就在tocrawl数组  
    //对应元素赋值1作为标志  
    if (strcmp(slabs, "all") == 0) {//处理全部lru队列  
        for (sid = 0; sid < LARGEST_ID; sid++) {  
            tocrawl[sid] = 1;  
        }  
    } else {  
        for (char *p = strtok_r(slabs, ",", &b);  
             p != NULL;  
             p = strtok_r(NULL, ",", &b)) {  
  
            //解析出一个个的sid  
            if (!safe_strtoul(p, &sid) || sid < POWER_SMALLEST  
                    || sid > POWER_LARGEST) {//sid越界  
                pthread_mutex_unlock(&cache_lock);  
                pthread_mutex_unlock(&lru_crawler_lock);  
                return CRAWLER_BADCLASS;  
            }  
            tocrawl[sid] = 1;  
        }  
    }  
  
    //crawlers是一个伪item类型数组。如果用户要清理某一个LRU队列，那么  
    //就在这个LRU队列中插入一个伪item  
    for (sid = 0; sid < LARGEST_ID; sid++) {  
        if (tocrawl[sid] != 0 && tails[sid] != NULL) {  
  
            //对于伪item和真正的item，可以用nkey、time这两个成员的值区别  
            crawlers[sid].nbytes = 0;  
            crawlers[sid].nkey = 0;  
            crawlers[sid].it_flags = 1; /* For a crawler, this means enabled. */  
            crawlers[sid].next = 0;  
            crawlers[sid].prev = 0;  
            crawlers[sid].time = 0;  
            crawlers[sid].remaining = settings.lru_crawler_tocrawl;  
            crawlers[sid].slabs_clsid = sid;  
            //将这个伪item插入到对应的lru队列的尾部  
            crawler_link_q((item *)&crawlers[sid]);  
            crawler_count++;//要处理的LRU队列数加一  
        }  
    }  
    pthread_mutex_unlock(&cache_lock);  
    //有任务了，唤醒LRU爬虫线程，让其执行清理任务  
    pthread_cond_signal(&lru_crawler_cond);  
    STATS_LOCK();  
    stats.lru_crawler_running = true;  
    STATS_UNLOCK();  
    pthread_mutex_unlock(&lru_crawler_lock);  
    return CRAWLER_OK;  
}//end  lru_crawler_crawl()

