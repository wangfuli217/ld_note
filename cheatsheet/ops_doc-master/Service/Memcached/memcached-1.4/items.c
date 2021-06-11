/* -*- Mode: C; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*- */
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
#include <time.h>
#include <assert.h>
#include <unistd.h>

/* Forward Declarations */
static void item_link_q(item *it);
static void item_unlink_q(item *it);

#define LARGEST_ID POWER_LARGEST
/*
automove�߳�Ҫ�����Զ���⣬������ҪһЩʵʱ���ݽ��з�����Ȼ��ó����ۣ��ĸ�slabclass_t��Ҫ������ڴ棬
�ĸ��ֲ���Ҫ��automove�߳�ͨ��ȫ�ֱ���itemstats�ռ�item�ĸ������ݡ�

itemstats������һ�����飬���Ǻ�slabclass����һһ��Ӧ�ġ�itemstats�����Ԫ�ظ����ռ�slabclass�����ж�ӦԪ�ص���Ϣ��
itemstats_t�ṹ����Ȼ�ṩ�˺ܶ��Ա�������ռ��ܶ���Ϣ����automove�߳�ֻ�õ���һ����Աevicted
*/
typedef struct { //�ṹ����itemstats[]
    uint64_t evicted; //��ΪLRU���˶��ٸ�item 
    //��ʹһ��item��exptime����Ϊ0��Ҳ�ǻᱻ�ߵ�  
    uint64_t evicted_nonzero;//���ߵ�item�У���ʱʱ��(exptime)��Ϊ0��item��  
    rel_time_t evicted_time;//���һ����itemʱ�����ߵ�item�Ѿ����ڶ����  
    uint64_t reclaimed; //item���ظ�ʹ�õĴ�������ֵ��do_item_alloc  //������itemʱ�����ֹ��ڲ����յ�item����  
    uint64_t outofmemory; //��slab�л�ȡmemʧ�ܵĴ�������do_item_alloc  //Ϊitem�����ڴ棬ʧ�ܵĴ���  
    uint64_t tailrepairs; //��Ҫ�޸���item����(����worker�߳����������һ��Ϊ0)  
    uint64_t expired_unfetched; //�����ʹ����ҳ�ʱ��item,��ֵ��do_item_alloc   //ֱ������ʱɾ��ʱ����û�����ʹ���item����  
    uint64_t evicted_unfetched; //ֱ����LRU�߳�ʱ����û�б����ʹ���item����  
    uint64_t crawler_reclaimed; //��slabclass�����item��  //��LRU���淢�ֵĹ���item����  
    uint64_t lrutail_reflocked;//����item������LRU����ʱ��������worker�߳����õ�item����  
} itemstats_t; //item��״̬ͳ����Ϣ������Ͳ�������

//ָ��ÿһ��LRU����ͷ  LRU���п��Բο�http://blog.csdn.net/luotuo44/article/details/42869325
//���ڶ���ǰ��ı�ʾ��������ʵ�key������head��������ʾ���û���ʸ�key����Ϊÿ�η���key�����key-value��Ӧ��itemȡ�����ŵ�headͷ������do_item_update
//lru���������item�Ǹ���time���������

//LRU��������̭����ʵ�ֹ�����do_item_alloc->it = slabs_alloc(ntotal, id)) == NULL ��û�й��ڵ�item����ȡ��item��ʧ���ˣ������LRU��̭����
static item *heads[LARGEST_ID]; //LRU����ָ��,  ÿ��classidһ��LRU��
//ָ��ÿһ��LRU����β  
static item *tails[LARGEST_ID]; //LRU��βָ�룬ÿ��classidһ��LRU�� 

//crawlers��һ��αitem�������顣����û�Ҫ����ĳһ��LRU���У���ô�������LRU�����в���һ��αitem  
static crawler crawlers[LARGEST_ID]; //lru_crawler_crawl
static itemstats_t itemstats[LARGEST_ID];
//ÿһ��LRU�����ж��ٸ�item
static unsigned int sizes[LARGEST_ID];//ÿ��classid��LRU���ĳ���(item������

static int crawler_count = 0; //��������Ҫ������ٸ�LRU����  
static volatile int do_run_lru_crawler_thread = 0; //Ϊ1��ʶ�Ѿ����������߳�
static int lru_crawler_initialized = 0;//��ʾ�Ƿ��ʼ��lru�����߳�����lru�����߳���������
static pthread_mutex_t lru_crawler_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t  lru_crawler_cond = PTHREAD_COND_INITIALIZER;

void item_stats_reset(void) {
    mutex_lock(&cache_lock);
    memset(itemstats, 0, sizeof(itemstats));
    mutex_unlock(&cache_lock);
}


/* Get the next CAS id for a new item. */
uint64_t get_cas_id(void) {
    static uint64_t cas_id = 0;
    return ++cas_id;
}

/* Enable this for reference-count debugging. */
#if 0
# define DEBUG_REFCNT(it,op) \
                fprintf(stderr, "item %x refcnt(%c) %d %c%c%c\n", \
                        it, op, it->refcount, \
                        (it->it_flags & ITEM_LINKED) ? 'L' : ' ', \
                        (it->it_flags & ITEM_SLABBED) ? 'S' : ' ')
#else
# define DEBUG_REFCNT(it,op) while(0)
#endif

/**
 * Generates the variable-sized part of the header for an object.
 *
 * key     - The key
 * nkey    - The length of the key
 * flags   - key flags
 * nbytes  - Number of bytes to hold value and addition CRLF terminator
 * suffix  - Buffer for the "VALUE" line suffix (flags, size).
 * nsuffix - The length of the suffix is stored here.
 *
 * Returns the total size of the header.
 */
static size_t item_make_header(const uint8_t nkey, const int flags, const int nbytes,
                     char *suffix, uint8_t *nsuffix) {
    /* suffix is defined at 40 chars elsewhere.. */
    *nsuffix = (uint8_t) snprintf(suffix, 40, " %d %d\r\n", flags, nbytes - 2);  

    //snpintf��*nsuffic��СӦ�þ�������""�е��ֽ���
    return sizeof(item) + nkey + *nsuffix + nbytes; //expire���浽it->expire  cas������it->data->case�е�
}

/*
��worker�߳̽��յ�flush_all����󣬻���ȫ�ֱ���settings��oldest_live��Ա�洢���յ����������һ�̵�ʱ��(׼ȷ��˵��
��worker�߳̽�����֪����һ��flush_all������һ���ټ�һ)������Ϊsettings.oldest_live =current_time - 1;Ȼ�����
item_flush_expired��������cache_lock��Ȼ�����do_item_flush_expired������ɹ�����
    ����ɾ�����Բο�do_item_get�е�if (settings.oldest_live != 0 && settings.oldest_live <= current_time int i;
do_item_get�����⣬do_item_alloc����Ҳ�ǻᴦ�����ʧЧitem��
*/


//�����洢��slabclass[id]�е�tunck�е����ݸ�ʽ��item_make_header

/*@null@*/
//key��flags��exptime�����������û���ʹ��set��add����洢һ������ʱ����Ĳ���
//nkey��key�ַ����ĳ��ȡ�nbytes�����û�Ҫ�洢��data����+2����Ϊ��data��β����Ҫ����"\r\n",data��\r\n�ڸú���ǰ+2��
//cur_hv���Ǹ��ݼ�ֵkey����õ��Ĺ�ϣֵ
item *do_item_alloc(char *key, const size_t nkey, const int flags,
                    const rel_time_t exptime, const int nbytes,
                    const uint32_t cur_hv) { //do_item_alloc (����item) �� item_free ���ͷ�item��
    uint8_t nsuffix;
    item *it = NULL;
    char suffix[40];

	//Ҫ�洢���item��Ҫ���ܿռ�  nkey+1����Ϊset key 0 0 3\n  abc\r\n  ��Ӧ��key�к�����\n
    size_t ntotal = item_make_header(nkey + 1, flags, nbytes, suffix, &nsuffix);
    if (settings.use_cas) {
        ntotal += sizeof(uint64_t);
    }

	//���ݴ�С�жϴ������ĸ�slab
    unsigned int id = slabs_clsid(ntotal);
    if (id == 0) //0��ʾ�������κ�һ��slab  slabclass�Ǵ�1��ʼ��
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

	//��һ�ο����forѭ����ֱ����Ϊsearch����NULL��ֱ�ӿ�forѭ������Ĵ���
	//���ѭ��������ڶ�ӦLRU�����в��ҹ���ʧЧ��item����ೢ��tries��item��
	//��LRU�Ķ�β��ʼ���ԡ����item������worker�߳������ˣ���ô�ͳ�����һ��
	//���û�еı�����worker�߳������ã���ô�Ͳ��Ը�item�Ƿ����ʧЧ
	//�������ʧЧ�ˣ���ô�Ϳ���ʹ�����item(���ջ᷵�����item)�����û��
	//����ʧЧ����ô���ٳ�������item��(��Ϊ�Ǵ�LRU���еĶ�β��ʼ���Ե�,��β�Ķ�û��ʧЧ������ǰ��Ŀ϶�����ʧЧ)��
	//ֱ�ӵ���slabs_alloc����һ���µ��ڴ�洢item������������ڴ涼ʧ�ܣ�
	//��ô������LRU��̭������¾ͻ��������˻���
	
    for (; tries > 0 && search != NULL; tries--, search=next_it) {
        /* we might relink search mid-loop, so search->prev isn't reliable */
        next_it = search->prev;
        if (search->nbytes == 0 && search->nkey == 0 && search->it_flags == 1) {
            /* We are a crawler, ignore it. */
			//����һ������item��ֱ������
            tries++; //����item�����볢�Ե�item����
            continue;
        }
        uint32_t hv = hash(ITEM_key(search), search->nkey);
        /* Attempt to hash item lock the "search" item. If locked, no
         * other callers can incr the refcount
         */
        /* Don't accidentally grab ourselves, or bail if we can't quicklock */
		//������ռ���������˾����ˣ����ȴ�����
        if (hv == cur_hv || (hold_lock = item_trylock(hv)) == NULL)
            continue;
        /* Now see if the item is refcount locked */
        if (refcount_incr(&search->refcount) != 2) { //���ü���>=3  //�����������������߳������ã����ܰ�ռ���item  
            /* Avoid pathological case with ref'ed items in tail */
			//ˢ�����item�ķ���ʱ���Լ���LRU�����е�λ��
            do_item_update_nolock(search);
            tries_lrutail_reflocked--;
            tries++;
            refcount_decr(&search->refcount);

			//��ʱ������>=2
            itemstats[id].lrutail_reflocked++;
            /* Old rare bug could cause a refcount leak. We haven't seen
             * it in years, but we leave this code in to prevent failures
             * just in case */
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


//searchָ���item��refcount����2����˵����ʱ���item���˱�worker�߳��⣬û�������κ�worker�߳������䡣���Է����ͷŲ��������item  
          
//��Ϊ���ѭ���Ǵ�lru����ĺ��濪ʼ�����ġ�����һ��ʼsearch��ָ��������õ�item��������item��û�й��ڡ���ô�����ı��������  
//��item�Ͳ�Ҫɾ����(��ʹ���ǹ�����)����ʱֻ����slabs�����ڴ�   
        /* Expired or flushed */
        if ((search->exptime != 0 && search->exptime < current_time)
            || (search->time <= oldest_live && oldest_live <= current_time)) { 
            ////searchָ���item��һ������ʧЧ��item������ʹ��֮  
            itemstats[id].reclaimed++;
            if ((search->it_flags & ITEM_FETCHED) == 0) {
                itemstats[id].expired_unfetched++;
            }
            it = search;
            //���¼���һ�����slabclass_t�����ȥ���ڴ��Сֱ�Ӱ�ռ�ɵ�item����Ҫ���¼���  
            slabs_adjust_mem_requested(it->slabs_clsid, ITEM_ntotal(it), ntotal); 
            do_item_unlink_nolock(it, hv);  
            /* Initialize the item block: */
            it->slabs_clsid = 0;
        } else if ((it = slabs_alloc(ntotal, id)) == NULL) { //��id���ڵ�slab��û�й��ڵ�item�����slab���»�ȡһ��item
            tried_alloc = 1;
            if (settings.evict_to_free == 0) { //�����˲�����LRU��̭item  
                itemstats[id].outofmemory++; //��ʱֻ����ͻ��˻ظ�������  
            } else {
                //�˿̣�����ʧЧ��itemû���ҵ��������ڴ���ʧ���ˡ�����ֻ��ʹ��  
                //LRU��̭һ��item(��ʹ���item��û�й���ʧЧ)  
                itemstats[id].evicted++;//���ӱ��ߵ�item��  
                itemstats[id].evicted_time = current_time - search->time;
                if (search->exptime != 0) //��ʹһ��item��exptime��Ա����Ϊ������ʱ(0)�����ǻᱻ�ߵ�  
                    itemstats[id].evicted_nonzero++;
                if ((search->it_flags & ITEM_FETCHED) == 0) { 
                    itemstats[id].evicted_unfetched++;
                }
                it = search;
                slabs_adjust_mem_requested(it->slabs_clsid, ITEM_ntotal(it), ntotal);
                do_item_unlink_nolock(it, hv);
                /* Initialize the item block: */
                it->slabs_clsid = 0;

                /* If we've just evicted an item, and the automover is set to
                 * angry bird mode, attempt to rip memory into this slab class.
                 * TODO: Move valid object detection into a function, and on a
                 * "successful" memory pull, look behind and see if the next alloc
                 * would be an eviction. Then kick off the slab mover before the
                 * eviction happens.
                 */
                //һ��������item���ߣ���ô�������ڴ�ҳ�ط������  
                //���̫Ƶ���ˣ����Ƽ�   
                if (settings.slab_automove == 2)
                    slabs_reassign(-1, id);
            }
        }

        //���ü�����һ����ʱ��item�Ѿ�û���κ�worker�߳������䣬���ҹ�ϣ��Ҳ  
        //����������  
        refcount_decr(&search->refcount);
        /* If hash values were equal, we don't grab a second lock */
        if (hold_lock)
            item_trylock_unlock(hold_lock);
        break;
    }

    if (!tried_alloc && (tries == 0 || search == NULL))
        it = slabs_alloc(ntotal, id);

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
    it->refcount = 1;     /* the caller will have a reference */  //�¿��̵�Ĭ�ϳ�ֵΪ1
    mutex_unlock(&cache_lock);
    it->next = it->prev = it->h_next = 0;
    it->slabs_clsid = id;

    DEBUG_REFCNT(it, '*');
    it->it_flags = settings.use_cas ? ITEM_CAS : 0;
    it->nkey = nkey;
    it->nbytes = nbytes;  //set cas���������е�expire���浽it->expire  cas������it->data->case�е�
    memcpy(ITEM_key(it), key, nkey);
    it->exptime = exptime;
    memcpy(ITEM_suffix(it), suffix, (size_t)nsuffix);
    it->nsuffix = nsuffix; //ʵ�ʷ����item�ռ��СΪit->nkey +1 + it->nsuffix +it->nbytes
    return it;
}

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
}

/**
 * Returns true if an item will fit in the cache (its size does not exceed
 * the maximum for a cache entry.)
 */
bool item_size_ok(const size_t nkey, const int flags, const int nbytes) {
    char prefix[40];
    uint8_t nsuffix;

    size_t ntotal = item_make_header(nkey + 1, flags, nbytes,
                                     prefix, &nsuffix);
    if (settings.use_cas) {
        ntotal += sizeof(uint64_t);
    }

    return slabs_clsid(ntotal) != 0;
}

//��item���뵽LRU���е�ͷ��  //��item���뵽��Ӧclassid��LRU����head   ����hash����Ϊassoc_insert  ����lru���еĺ���Ϊitem_link_q
static void item_link_q(item *it) { /* item is the new head */
    item **head, **tail;
    assert(it->slabs_clsid < LARGEST_ID);
    assert((it->it_flags & ITEM_SLABBED) == 0);

    head = &heads[it->slabs_clsid];
    tail = &tails[it->slabs_clsid];
    assert(it != *head);
    assert((*head && *tail) || (*head == 0 && *tail == 0));

	//ͷ�巨�����item
    it->prev = 0;
    it->next = *head;
    if (it->next) it->next->prev = it;
    *head = it;//��item��Ϊ��Ӧ����ĵ�һ���ڵ�

	//�����item��Ӧid�ϵĵ�һ��item����ô���ᱻ��Ϊ�Ǹ�id�������һ��item
	//��Ϊ��head����ʹ��ͷ�巨�����Ե�һ�������item�����˺���ȷʵ�������һ��item
    if (*tail == 0) *tail = it;
    sizes[it->slabs_clsid]++;
    return;
}

//��it�Ӷ�Ӧ��LRU������ɾ��  //��item�Ӷ�Ӧclassid��LRU�����Ƴ�
static void item_unlink_q(item *it) {
    item **head, **tail;
    assert(it->slabs_clsid < LARGEST_ID);
    head = &heads[it->slabs_clsid];
    tail = &tails[it->slabs_clsid];

	//�����ϵĵ�һ���ڵ�
    if (*head == it) { 
        assert(it->prev == 0);
        *head = it->next;
    }
	//�����ϵ����һ���ڵ�
    if (*tail == it) {
        assert(it->next == 0);
        *tail = it->prev;
    }
    assert(it->next != it);
    assert(it->prev != it);
	//��item��ǰ�����ͺ��������������
    if (it->next) it->next->prev = it->prev;
    if (it->prev) it->prev->next = it->next;
	//������һ
    sizes[it->slabs_clsid]--;
    return;
}

////��item���뵽hashtable�����뵽��Ӧclassid��LRU���С�
int do_item_link(item *it, const uint32_t hv) {
    MEMCACHED_ITEM_LINK(ITEM_key(it), it->nkey, it->nbytes);
    assert((it->it_flags & (ITEM_LINKED|ITEM_SLABBED)) == 0);
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
    assoc_insert(it, hv); //���뵽hash���У����ڿ��ٲ���
    item_link_q(it); //���뵽LRU����
    refcount_incr(&it->refcount); //����refcount������
    mutex_unlock(&cache_lock);

    return 1;
}

/*
��һ��item���뵽��ϣ���LRU���к���ô���item�ͱ���ϣ���LRU�����������ˡ���ʱ�����û�������߳����������item�Ļ���
��ô���item��������Ϊ1(��ϣ���LRU���п���һ������)������һ��worker�߳�Ҫɾ��һ��item(��Ȼ��ɾ��ǰ���worker�߳�Ҫ
ռ�����item)����ô��Ҫ��������item����������һ���Ǽ��ٹ�ϣ���LRU���е����ã�����һ���Ǽ����Լ������á����Ծ�����
�ڴ����п���ɾ��һ��item��Ҫ���ú���do_item_unlink (it, hv)��do_item_remove(it)������������
*/
//��item��hashtable��LRU�����Ƴ�����do_item_link��������� do_item_unlink�����hash��lru�Ĺ����������ͷ�item��do_item_remove
void do_item_unlink(item *it, const uint32_t hv) {
    MEMCACHED_ITEM_UNLINK(ITEM_key(it), it->nkey, it->nbytes);
    mutex_lock(&cache_lock);
    if ((it->it_flags & ITEM_LINKED) != 0) {
        it->it_flags &= ~ITEM_LINKED;
        STATS_LOCK();
        stats.curr_bytes -= ITEM_ntotal(it);
        stats.curr_items -= 1;
        STATS_UNLOCK();
        assoc_delete(ITEM_key(it), it->nkey, hv);
        item_unlink_q(it);
        do_item_remove(it);
    }
    mutex_unlock(&cache_lock);  
}

/* FIXME: Is it necessary to keep this copy/pasted code? */
//��hash��item��ɾ��
void do_item_unlink_nolock(item *it, const uint32_t hv) {
    MEMCACHED_ITEM_UNLINK(ITEM_key(it), it->nkey, it->nbytes);
    if ((it->it_flags & ITEM_LINKED) != 0) {
        it->it_flags &= ~ITEM_LINKED;
        STATS_LOCK();
        stats.curr_bytes -= ITEM_ntotal(it);
        stats.curr_items -= 1;
        STATS_UNLOCK();
        assoc_delete(ITEM_key(it), it->nkey, hv);
        item_unlink_q(it);
        do_item_remove(it);
    }
}

//do_item_unlink�����hash��lru�Ĺ����������ͷ�item��do_item_remove
void do_item_remove(item *it) {
    MEMCACHED_ITEM_REMOVE(ITEM_key(it), it->nkey, it->nbytes);
    assert((it->it_flags & ITEM_SLABBED) == 0);
    assert(it->refcount > 0);

    if (refcount_decr(&it->refcount) == 0) {
        item_free(it);
    }
}

/* Copy/paste to avoid adding two extra branches for all common calls, since
 * _nolock is only used in an uncommon case. */
void do_item_update_nolock(item *it) {
    MEMCACHED_ITEM_UPDATE(ITEM_key(it), it->nkey, it->nbytes);
	//����Ĵ�����Կ���update����ʱ��ʱ�ġ�������itemƵ��������
	//��ô�ᵼ�¹����update�������һϵ�з�ʱ��������ʱ���¼����Ӧ�˶�����
	//�����һ�εķ���ʱ��(Ҳ����˵��updateʱ��)��������(current_time)
	//���ڸ��¼���ڵģ��Ͳ����¡������˲Ÿ��¡�
    if (it->time < current_time - ITEM_UPDATE_INTERVAL) {
        assert((it->it_flags & ITEM_SLABBED) == 0);

        if ((it->it_flags & ITEM_LINKED) != 0) {
			//��LRU������ɾ��
            item_unlink_q(it);
			//���·���ʱ��
            it->time = current_time;
			//���뵽LRU���е�ͷ��
            item_link_q(it);
        }
    }
}

/*
ΪʲôҪ��item���뵽LRU����ͷ���أ���Ȼʵ�ּ�������һ��ԭ�򡣵�����Ҫ��������һ��LRU���У������ǵò���ϵͳ�����LRU�ɡ�
����һ����̭���ơ���LRU�����У��ŵ�Խ�������Ϊ��Խ��ʹ�õ�item����ʱ����̭�ļ��ʾ�Խ����������item(����ʱ����)��Ҫ��
�ڲ���ô����item��ǰ�棬���Բ���LRU���е�ͷ���ǲ���ѡ�������do_item_update������֤����һ�㡣do_item_update�������Ȱ�
�ɵ�item��LRU������ɾ����Ȼ���ٲ��뵽LRU������(��ʱ����LRU�������ŵ���ǰ)�����˸���item�ڶ����е�λ���⣬�������item��
time��Ա���ó�Աָ����һ�η��ʵ�ʱ��(����ʱ��)���������Ϊ��LRU����ôdo_item_update������򵥵�ʵ�־���ֱ�Ӹ���time��Ա���ɡ�

memcached����get����ʱ�����do_item_update��������item�ķ���ʱ�䣬��������LRU���е�λ�á���memcached��get�����Ǻ�Ƶ�������
����LRU���е�һ����ǰ����item����Ƶ����get����������ǰ������item��˵������do_item_update�����岻��ģ���Ϊ����do_item_update
����λ�û���ǰ����������LRU��̭�ٶ�itemҲ������̭��������(һ��LRU���е�item�����Ǻܶ��)����һ���棬do_item_update������ʱ��
�ǻ���һ���ĺ�ʱ����ΪҪ��ռcache_lock�������Ƶ������do_item_update�������ܽ��½��ܶࡣ����memcached����ʹ���˸��¼����
*/
//����һ��item��������ʱ�䣬������Ҫ��һ��ʱ��֮��  ���·���ʱ��
void do_item_update(item *it) {
    MEMCACHED_ITEM_UPDATE(ITEM_key(it), it->nkey, it->nbytes);
    if (it->time < current_time - ITEM_UPDATE_INTERVAL) {
        /*
            //����Ĵ�����Կ���update�����Ǻ�ʱ�ġ�������itemƵ�������ʣ�  
            //��ô�ᵼ�¹����update�������һϵ�з�ʱ��������ʱ���¼����Ӧ�˶���  
            //�ˡ������һ�εķ���ʱ��(Ҳ����˵��updateʱ��)��������(current_time)  
            //���ڸ��¼���ڵģ��Ͳ����¡������˲Ÿ��¡�  
        */
        assert((it->it_flags & ITEM_SLABBED) == 0);

        mutex_lock(&cache_lock);
        if ((it->it_flags & ITEM_LINKED) != 0) {
            item_unlink_q(it);
            it->time = current_time;
            item_link_q(it);
        }
        mutex_unlock(&cache_lock);
    }
}

//��item��new_item����
int do_item_replace(item *it, item *new_it, const uint32_t hv) {  //ע��������old_it->refcount���1��new_it����1
    MEMCACHED_ITEM_REPLACE(ITEM_key(it), it->nkey, it->nbytes,
                           ITEM_key(new_it), new_it->nkey, new_it->nbytes);
    assert((it->it_flags & ITEM_SLABBED) == 0);

    do_item_unlink(it, hv);
    return do_item_link(new_it, hv);
}

/*@null@*/
char *do_item_cachedump(const unsigned int slabs_clsid, const unsigned int limit, unsigned int *bytes) {
    unsigned int memlimit = 2 * 1024 * 1024;   /* 2MB max response size */
    char *buffer;
    unsigned int bufcurr;
    item *it;
    unsigned int len;
    unsigned int shown = 0;
    char key_temp[KEY_MAX_LENGTH + 1];
    char temp[512];

    it = heads[slabs_clsid];

    buffer = malloc((size_t)memlimit);
    if (buffer == 0) return NULL;
    bufcurr = 0;

    while (it != NULL && (limit == 0 || shown < limit)) {
        assert(it->nkey <= KEY_MAX_LENGTH);
        if (it->nbytes == 0 && it->nkey == 0) {
            it = it->next;
            continue;
        }
        /* Copy the key since it may not be null-terminated in the struct */
        strncpy(key_temp, ITEM_key(it), it->nkey);
        key_temp[it->nkey] = 0x00; /* terminate */
        len = snprintf(temp, sizeof(temp), "ITEM %s [%d b; %lu s]\r\n",
                       key_temp, it->nbytes - 2,
                       (unsigned long)it->exptime + process_started);
        if (bufcurr + len + 6 > memlimit)  /* 6 is END\r\n\0 */
            break;
        memcpy(buffer + bufcurr, temp, len);
        bufcurr += len;
        shown++;
        it = it->next;
    }

    memcpy(buffer + bufcurr, "END\r\n", 6);
    bufcurr += 5;

    *bytes = bufcurr;
    return buffer;
}

void item_stats_evictions(uint64_t *evicted) {
    int i;
    mutex_lock(&cache_lock);
    for (i = 0; i < LARGEST_ID; i++) {
        evicted[i] = itemstats[i].evicted;
    }
    mutex_unlock(&cache_lock);
}

void do_item_stats_totals(ADD_STAT add_stats, void *c) {
    itemstats_t totals;
    memset(&totals, 0, sizeof(itemstats_t));
    int i;
    for (i = 0; i < LARGEST_ID; i++) {
        totals.expired_unfetched += itemstats[i].expired_unfetched;
        totals.evicted_unfetched += itemstats[i].evicted_unfetched;
        totals.evicted += itemstats[i].evicted;
        totals.reclaimed += itemstats[i].reclaimed;
        totals.crawler_reclaimed += itemstats[i].crawler_reclaimed;
        totals.lrutail_reflocked += itemstats[i].lrutail_reflocked;
    }
    APPEND_STAT("expired_unfetched", "%llu",
                (unsigned long long)totals.expired_unfetched);
    APPEND_STAT("evicted_unfetched", "%llu",
                (unsigned long long)totals.evicted_unfetched);
    APPEND_STAT("evictions", "%llu",
                (unsigned long long)totals.evicted);
    APPEND_STAT("reclaimed", "%llu",
                (unsigned long long)totals.reclaimed);
    APPEND_STAT("crawler_reclaimed", "%llu",
                (unsigned long long)totals.crawler_reclaimed);
    APPEND_STAT("lrutail_reflocked", "%llu",
                (unsigned long long)totals.lrutail_reflocked);
}

/*
stats items
STAT items:1:number 4
STAT items:1:age 571
STAT items:1:evicted 0
STAT items:1:evicted_nonzero 0
STAT items:1:evicted_time 0
STAT items:1:outofmemory 0
STAT items:1:tailrepairs 0
STAT items:1:reclaimed 0
STAT items:1:expired_unfetched 0
STAT items:1:evicted_unfetched 0
STAT items:1:crawler_reclaimed 0
STAT items:1:lrutail_reflocked 0
STAT items:4:number 11
STAT items:4:age 2632
STAT items:4:evicted 0
STAT items:4:evicted_nonzero 0
STAT items:4:evicted_time 0
STAT items:4:outofmemory 0
STAT items:4:tailrepairs 0
STAT items:4:reclaimed 0
STAT items:4:expired_unfetched 0
STAT items:4:evicted_unfetched 0
STAT items:4:crawler_reclaimed 0
STAT items:4:lrutail_reflocked 0
END
*/
void do_item_stats(ADD_STAT add_stats, void *c) {
    int i;
    for (i = 0; i < LARGEST_ID; i++) {
        if (tails[i] != NULL) { //ֻ�ж�Ӧ��slab�����������Чitem�Ż����ͳ��
            const char *fmt = "items:%d:%s";
            char key_str[STAT_KEY_LEN];
            char val_str[STAT_VAL_LEN];
            int klen = 0, vlen = 0;
            if (tails[i] == NULL) {
                /* We removed all of the items in this slab class */
                continue;
            }
            APPEND_NUM_FMT_STAT(fmt, i, "number", "%u", sizes[i]);
            APPEND_NUM_FMT_STAT(fmt, i, "age", "%u", current_time - tails[i]->time);
            APPEND_NUM_FMT_STAT(fmt, i, "evicted",
                                "%llu", (unsigned long long)itemstats[i].evicted);
            APPEND_NUM_FMT_STAT(fmt, i, "evicted_nonzero",
                                "%llu", (unsigned long long)itemstats[i].evicted_nonzero);
            APPEND_NUM_FMT_STAT(fmt, i, "evicted_time",
                                "%u", itemstats[i].evicted_time);
            APPEND_NUM_FMT_STAT(fmt, i, "outofmemory",
                                "%llu", (unsigned long long)itemstats[i].outofmemory);
            APPEND_NUM_FMT_STAT(fmt, i, "tailrepairs",
                                "%llu", (unsigned long long)itemstats[i].tailrepairs);
            APPEND_NUM_FMT_STAT(fmt, i, "reclaimed",
                                "%llu", (unsigned long long)itemstats[i].reclaimed);
            APPEND_NUM_FMT_STAT(fmt, i, "expired_unfetched",
                                "%llu", (unsigned long long)itemstats[i].expired_unfetched);
            APPEND_NUM_FMT_STAT(fmt, i, "evicted_unfetched",
                                "%llu", (unsigned long long)itemstats[i].evicted_unfetched);
            APPEND_NUM_FMT_STAT(fmt, i, "crawler_reclaimed",
                                "%llu", (unsigned long long)itemstats[i].crawler_reclaimed);
            APPEND_NUM_FMT_STAT(fmt, i, "lrutail_reflocked",
                                "%llu", (unsigned long long)itemstats[i].lrutail_reflocked);
        }
    }

    /* getting here means both ascii and binary terminators fit */
    add_stats(NULL, 0, NULL, 0, c);
}

/*
stats sizes
STAT 96 4
STAT 192 11
END
*/
//�鿴ĳ��chunk���ʹ�������
/** dumps out a list of objects of each size, with granularity of 32 bytes */
/*@null@*/
void do_item_stats_sizes(ADD_STAT add_stats, void *c) {

    /* max 1MB object, divided into 32 bytes size buckets */
    const int num_buckets = 32768;
    unsigned int *histogram = calloc(num_buckets, sizeof(int));

    if (histogram != NULL) {
        int i;

        /* build the histogram */
        for (i = 0; i < LARGEST_ID; i++) {
            item *iter = heads[i];
            while (iter) {
                int ntotal = ITEM_ntotal(iter);
                int bucket = ntotal / 32;
                if ((ntotal % 32) != 0) bucket++;
                if (bucket < num_buckets) histogram[bucket]++;
                iter = iter->next;
            }
        }

        /* write the buffer */
        for (i = 0; i < num_buckets; i++) {
            if (histogram[i] != 0) {
                char key[8];
                snprintf(key, sizeof(key), "%d", i * 32);
                APPEND_STAT(key, "%u", histogram[i]);
            }
        }
        free(histogram);
    }
    add_stats(NULL, 0, NULL, 0, c);
}

/*
��worker�߳̽��յ�flush_all����󣬻���ȫ�ֱ���settings��oldest_live��Ա�洢���յ����������һ�̵�ʱ��(׼ȷ��˵��
��worker�߳̽�����֪����һ��flush_all������һ���ټ�һ)������Ϊsettings.oldest_live =current_time - 1;Ȼ�����
item_flush_expired��������cache_lock��Ȼ�����do_item_flush_expired������ɹ�����
    ����ɾ�����Բο�do_item_get�е�if (settings.oldest_live != 0 && settings.oldest_live <= current_time int i;
do_item_get�����⣬do_item_alloc����Ҳ�ǻᴦ�����ʧЧitem��
*/


/** wrapper around assoc_find which does the lazy expiration logic */
////����do_item_get�ĺ������Ѿ�������item_lock(hv)�μ���������ȫ����  
item *do_item_get(const char *key, const size_t nkey, const uint32_t hv) {
    //mutex_lock(&cache_lock);
    item *it = assoc_find(key, nkey, hv); //assoc_find�����ڲ�û�м���
    if (it != NULL) {
        refcount_incr(&it->refcount);
        /* Optimization for slab reassignment. prevents popular items from
         * jamming in busy wait. Can only do this here to satisfy lock order
         * of item_lock, cache_lock, slabs_lock. */
         //���item�պ���Ҫ�ƶ����ڴ�ҳ���档��ʱ���ܷ������item  
            //worker�߳�Ҫ��������item�ӹ�ϣ���LRU������ɾ�����item������  
            //����������worker�߳��ַ����������ʹ�õ�item  
        if (slab_rebalance_signal &&
            ((void *)it >= slab_rebal.slab_start && (void *)it < slab_rebal.slab_end)) {
            do_item_unlink_nolock(it, hv);//���ü������һ
            do_item_remove(it);//���ü�����һ��������ü�������0����ɾ��
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
        if (settings.oldest_live != 0 && settings.oldest_live <= current_time &&
            it->time <= settings.oldest_live) {//flush_all�������
            do_item_unlink(it, hv);//���ü������һ  
            do_item_remove(it);//���ü�����һ,������ü�������0����ɾ��
            it = NULL;
            if (was_found) {
                fprintf(stderr, " -nuked by flush");
            }
        } else if (it->exptime != 0 && it->exptime <= current_time) {//��item�Ѿ�����ʧЧ��  
            do_item_unlink(it, hv);
            do_item_remove(it);
            it = NULL;
            if (was_found) {
                fprintf(stderr, " -nuked by expire");
            }
        } else {
            it->it_flags |= ITEM_FETCHED;//�����item��־Ϊ�����ʹ���  
            DEBUG_REFCNT(it, '+');
        }
    }

    if (settings.verbose > 2)
        fprintf(stderr, "\n");

    return it;
}

item *do_item_touch(const char *key, size_t nkey, uint32_t exptime,
                    const uint32_t hv) {
    item *it = do_item_get(key, nkey, hv);
    if (it != NULL) {
        it->exptime = exptime;
    }
    return it;
}

/*
��worker�߳̽��յ�flush_all����󣬻���ȫ�ֱ���settings��oldest_live��Ա�洢���յ����������һ�̵�ʱ��(׼ȷ��˵��
��worker�߳̽�����֪����һ��flush_all������һ���ټ�һ)������Ϊsettings.oldest_live =current_time - 1;Ȼ�����
item_flush_expired��������cache_lock��Ȼ�����do_item_flush_expired������ɹ�����
    ����ɾ�����Բο�do_item_get�е�if (settings.oldest_live != 0 && settings.oldest_live <= current_time int i;
do_item_get�����⣬do_item_alloc����Ҳ�ǻᴦ�����ʧЧitem��

flush_all�����ǿ�����ʱ������ġ����ʱ�������ʱ��һ��ȡֵ��Χ�� 1��REALTIME_MAXDELTA(30��)���������Ϊflush_all 100��
��ô99������е�itemʧЧ����ʱsettings.oldest_live��ֵΪcurrent_time+100-1��do_item_flush_expired����Ҳû��ʲô����
(�ܲ��ᱻ��ռCPU99���)��Ҳ�������ԭ����Ҫ��do_item_get���棬����settings.oldest_live<= current_time����жϣ���ֹ����ɾ����item��
*/

/* expires items that are more recent than the oldest_live setting. */
void do_item_flush_expired(void) { 
//flush_all�����ǰϵͳ�����е�item��ʵ����item->time�ȵ�ǰʱ��С�Ļ��Ǵ�����item�У�֪ʶ�ѷ���ʱ���settings.oldest_live��������
//����һ�������㷨����Ϊ����ʱ��item->time�ȵ�ǰʱ��settings.oldest_liveС��itemȫ��ͨ������ɾ��ʵ�֣�����do_item_get�е�if (settings.oldest_live != 0 && settings.oldest_live <= current_time 
    int i;
    item *iter, *next;
    if (settings.oldest_live == 0)
        return;
    for (i = 0; i < LARGEST_ID; i++) {
        /* The LRU is sorted in decreasing time order, and an item's timestamp
         * is never newer than its last access time, so we only need to walk
         * back until we hit an item older than the oldest_live time.
         * The oldest_live checking will auto-expire the remaining items.
         */
        for (iter = heads[i]; iter != NULL; iter = next) {

            /*
                //iter->time == 0����lru����item��ֱ�Ӻ���  
                //һ�������iter->time��С��settings.oldest_live�ġ��������������  
                //���п��ܳ���iter->time >= settings.oldest_live :  worker1���յ�  
                //flush_all�������settings.oldest_live��ֵΪcurrent_time-1��  
                //worker1�̻߳�û���ü�����item_flush_expired�������ͱ�worker2  
                //��ռ��cpu��Ȼ��worker2��lru���в�����һ��item�����item��time  
                //��Ա�ͻ�����iter->time >= settings.oldest_live  
            */
            
            /* iter->time of 0 are magic objects. */
            if (iter->time != 0 && iter->time >= settings.oldest_live) {
                next = iter->next;
                if ((iter->it_flags & ITEM_SLABBED) == 0) { //˵���ýڵ�û�й黹��slab������Ҫ�黹��slab
                    //��Ȼ���õ���nolock,���������ĵ�����item_flush_expired  
                    //�Ѿ�������cache_lock���ŵ��ñ�������  
                    do_item_unlink_nolock(iter, hash(ITEM_key(iter), iter->nkey));
                }
            } else {
                /* We've hit the first old item. Continue to the next queue. */
                break;
            }
        }
    }
}

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
}

static void crawler_unlink_q(item *it) {
    item **head, **tail;
    assert(it->slabs_clsid < LARGEST_ID);
    head = &heads[it->slabs_clsid];
    tail = &tails[it->slabs_clsid];

    if (*head == it) {
        assert(it->prev == 0);
        *head = it->next;
    }
    if (*tail == it) {
        assert(it->next == 0);
        *tail = it->prev;
    }
    assert(it->next != it);
    assert(it->prev != it);

    if (it->next) it->next->prev = it->prev;
    if (it->prev) it->prev->next = it->next;
    return;
}

/*
αitemͨ����ǰ���ڵ㽻��λ��ʵ��ǰ�������αitem��LRU���е�ͷ�ڵ㣬��ô�ͽ����αitem�Ƴ�LRU���С�
����crawler_crawl_q�������������������ҷ��ؽ���ǰαitem��ǰ���ڵ�(��Ȼ�ڽ�����ͱ��αitem�ĺ����ڵ���)��
���αitem����LRU���е�ͷ������ô�ͷ���NULL(��ʱû��ǰ���ڵ���)
*/
/* This is too convoluted, but it's a difficult shuffle. Try to rewrite it
 * more clearly. */
static item *crawler_crawl_q(item *it) {
    item **head, **tail;
    assert(it->it_flags == 1);
    assert(it->nbytes == 0);
    assert(it->slabs_clsid < LARGEST_ID);
    head = &heads[it->slabs_clsid];
    tail = &tails[it->slabs_clsid];

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
}

/* I pulled this out to make the main thread clearer, but it reaches into the
 * main thread's values too much. Should rethink again.
 */ //������item����ʧЧ�ˣ���ô��ɾ��
static void item_crawler_evaluate(item *search, uint32_t hv, int i) {
    rel_time_t oldest_live = settings.oldest_live;
    if ((search->exptime != 0 && search->exptime < current_time)//���item��exptimeʱ������ˣ��Ѿ�����ʧЧ��  
        || (search->time <= oldest_live && oldest_live <= current_time)) { //��Ϊ�ͻ��˷���flush_all����������itemʧЧ��    
        itemstats[i].crawler_reclaimed++;

        if (settings.verbose > 1) {
            int ii;
            char *key = ITEM_key(search);
            fprintf(stderr, "LRU crawler found an expired item (flags: %d, slab: %d): ",
                search->it_flags, search->slabs_clsid);
            for (ii = 0; ii < search->nkey; ++ii) {
                fprintf(stderr, "%c", key[ii]);
            }
            fprintf(stderr, "\n");
        }
        if ((search->it_flags & ITEM_FETCHED) == 0) {
            itemstats[i].expired_unfetched++;
        }

         //��item��LRU������ɾ��  
        do_item_unlink_nolock(search, hv);
        do_item_remove(search);
        assert(search->slabs_clsid == 0);
    } else {
        refcount_decr(&search->refcount);
    }
}

/*
����������lru_crawler tocrawl numָ��ÿ��LRU�������ֻ���num-1��item��������㣬�Ǽ����������ɾ������
������num-1��������Ҫ����item_crawler_evaluate�������һ��item�Ƿ���ڣ��ǵĻ���ɾ������������num-1����
αitem����û�е���LRU���е�ͷ������ô��ֱ�ӽ����αitem��LRU������ɾ����
*/
static void *item_crawler_thread(void *arg) {
    int i;

    pthread_mutex_lock(&lru_crawler_lock);
    if (settings.verbose > 2)
        fprintf(stderr, "Starting LRU crawler background thread\n");
    while (do_run_lru_crawler_thread) {
        //�ȴ�worker�߳�ָ��Ҫ�����LRU����,Ҳ���ǵȴ��ͻ���ִ��lru_crawler tocrawl <classid,classid,classid|all> 
        //���lru_crawler crawl<classid,classid,classid|all>������ָ������ġ�������ָ����Ҫ���ĸ�LRU���н�������
        pthread_cond_wait(&lru_crawler_cond, &lru_crawler_lock);
        
        while (crawler_count) {//crawler_count����Ҫ������ٸ�LRU����  
            item *search = NULL;
            void *hold_lock = NULL;

            for (i = 0; i < LARGEST_ID; i++) {
                if (crawlers[i].it_flags != 1) {
                    continue;
                }
                pthread_mutex_lock(&cache_lock);
                //����crawlers[i]��ǰ���ڵ�,������crawlers[i]��ǰ���ڵ��λ��  
                search = crawler_crawl_q((item *)&crawlers[i]);
                if (search == NULL ||
                    (crawlers[i].remaining && --crawlers[i].remaining < 1)) {
                    //crawlers[i]��ͷ�ڵ㣬û��ǰ���ڵ�  
                //remaining��ֵΪsettings.lru_crawler_tocrawl��ÿ������lru  
                //�����̣߳����ÿһ��lru���еĶ��ٸ�item��
                    if (settings.verbose > 2)
                        fprintf(stderr, "Nothing left to crawl for %d\n", i);
                    crawlers[i].it_flags = 0;//������㹻��Σ��˳�������lru����  
                    crawler_count--;//������һ��LRU����,��������һ  
                    crawler_unlink_q((item *)&crawlers[i]);//�����αitem��LRU������ɾ��  
                    pthread_mutex_unlock(&cache_lock);
                    continue;
                }
                uint32_t hv = hash(ITEM_key(search), search->nkey);
                /* Attempt to hash item lock the "search" item. If locked, no
                 * other callers can incr the refcount
                 */
                if ((hold_lock = item_trylock(hv)) == NULL) {//������ס�������item�Ĺ�ϣ��μ�����  
                    pthread_mutex_unlock(&cache_lock);
                    continue;
                }
                /* Now see if the item is refcount locked */
                if (refcount_incr(&search->refcount) != 2) { //��ʱ������worker�߳����������item  
                    refcount_decr(&search->refcount); //lru�����̷߳������ø�item  
                    if (hold_lock)
                        item_trylock_unlock(hold_lock);
                    pthread_mutex_unlock(&cache_lock);
                    continue;
                }

                /* Frees the item or decrements the refcount. */
                /* Interface for this could improve: do the free/decr here
                 * instead? *///������item����ʧЧ�ˣ���ô��ɾ�����item  
                item_crawler_evaluate(search, hv, i);
                
                if (hold_lock)
                    item_trylock_unlock(hold_lock);
                pthread_mutex_unlock(&cache_lock);
                
                if (settings.lru_crawler_sleep)
                    usleep(settings.lru_crawler_sleep);
            }
        }
        if (settings.verbose > 2)
            fprintf(stderr, "LRU crawler thread sleeping\n");
        STATS_LOCK();
        stats.lru_crawler_running = false;
        STATS_UNLOCK();
    }
    pthread_mutex_unlock(&lru_crawler_lock);
    if (settings.verbose > 2)
        fprintf(stderr, "LRU crawler thread stopping\n");

    return NULL;
}

static pthread_t item_crawler_tid; //�����߳�ID

//worker�߳��ڽ��յ�"lru_crawler disable"�����ִ���������  
int stop_item_crawler_thread(void) {
    int ret;
    pthread_mutex_lock(&lru_crawler_lock);
    do_run_lru_crawler_thread = 0;
    //LRU�����߳̿��������ڵȴ�������������Ҫ���Ѳ���ֹͣLRU�����߳�  
    pthread_cond_signal(&lru_crawler_cond);
    pthread_mutex_unlock(&lru_crawler_lock);
    if ((ret = pthread_join(item_crawler_tid, NULL)) != 0) {
        fprintf(stderr, "Failed to stop LRU crawler thread: %s\n", strerror(ret));
        return -1;
    }
    settings.lru_crawler = false;
    return 0;
}

/*
LRU���棺
        ǰ��˵����memcached������ɾ������ʧЧitem�ġ����Լ�ʹ�û��ڿͻ���ʹ����flush_all����ʹ��ȫ��item������ʧЧ�ˣ�
        ����Щitem����ռ���߹�ϣ���LRU���в�û�й黹��slab��������

LRU�����̣߳�
        ��û�а취ǿ�������Щ����ʧЧ��item������ռ�ݹ�ϣ���LRU���еĿռ䲢�黹��slabs�أ���Ȼ���еġ�memcached
        �ṩ��LRU�������ʵ��������ܡ�
        Ҫʹ��LRU����ͱ����ڿͻ���ʹ��lru_crawler���memcached���������ݾ��������������д���
        memcached����һ��ר�ŵ��̸߳��������Щ����ʧЧitem�ģ����Ľ�������߳�ΪLRU�����̡߳�Ĭ�������memcached
        �ǲ���������̵߳ģ�������������memcached��ʱ����Ӳ���-o lru_crawler��������̡߳�Ҳ����ͨ���ͻ���������
        ������ʹ���������LRU�����̣߳����̻߳��ǲ��Ṥ������Ҫ���ⷢ�����ָ��Ҫ���ĸ�LRU���н������������
        �ڿ�һ��lru_crawler����Щ������

LRU�������
lru_crawler  <enable|disable>  ��������ֹͣһ��LRU�����̡߳��κ�ʱ�̣����ֻ��һ��LRU�����̡߳��������
settings.lru_crawler���и�ֵΪtrue����false
lru_crawler crawl <classid,classid,classid|all>  ����ʹ��2,3,6�������б�ָ��Ҫ���ĸ�LRU���н����������
Ҳ����ʹ��all�����е�LRU���н��д���
lru_crawler sleep <microseconds>  LRU�����߳������item��ʱ���ռ�����������worker�̵߳�����ҵ������LRU
�����ڴ����ʱ����Ҫʱ��ʱ����һ�¡�Ĭ������ʱ��Ϊ100΢�롣�������settings.lru_crawler_sleep���и�ֵ
lru_crawler tocrawl <32u>  һ��LRU���п��ܻ��кܶ����ʧЧ��item�����һֱ���������ȥ���Ʊػ����worker
�̵߳�����ҵ�������������ָ�����ֻ���ÿһ��LRU���еĶ��ٸ�item��Ĭ��ֵΪ0�����������ָ����ô�Ͳ��Ṥ
�����������settings.lru_crawler_tocrawl���и�ֵ
���Ҫ����LRU��������ɾ�����ڵ�item����Ҫ������������ʹ��lru_crawler enable��������һ��LRU�����̡߳�
Ȼ��ʹ��lru_crawler tocrawl num����ȷ��ÿһ��LRU���������num-1��item�����ʹ������
lru_crawler crawl <classid,classid,classid|all> ָ��Ҫ�����LRU���С�lru_crawler sleep���Բ����ã�
���Ҫ������ô������lru_crawler crawl����֮ǰ���ü��ɡ�
*/ //�ο�http://blog.csdn.net/luotuo44/article/details/42963793
int start_item_crawler_thread(void) {//�����������������м���-o lru_crawler���߿ͻ���ִ��lru_crawler enable���������������߳�
    int ret;
    //worker�߳̽��յ�"lru_crawler enable"��������ñ�����  
    //����memcachedʱ�����-o lru_crawler����Ҳ�ǻ���ñ�����  


    //��stop_item_crawler_thread�������Կ���pthread_join����  
    //��pthread_join���غ󣬲Ż��settings.lru_crawler����Ϊfalse��  
    //���Բ������ͬʱ��������crawler�߳�  
    if (settings.lru_crawler) //�Ѿ��������´��̣߳������ٴ����߳���
        return -1;
    pthread_mutex_lock(&lru_crawler_lock);
    do_run_lru_crawler_thread = 1;
    settings.lru_crawler = true;

    //����һ��LRU�����̣߳��̺߳���Ϊitem_crawler_thread��LRU�����߳��ڽ���  
    //item_crawler_thread�����󣬻����pthread_cond_wait���ȴ�worker�߳�ָ��  
    //Ҫ�����LRU����  
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

/*
lru_crawler_crawl������memcached��������������αitem���뵽LRU����β���ġ���worker�߳̽��յ�lru_crawler 
crawl<classid,classid,classid|all>����ʱ�ͻ���������������Ϊ�û�����Ҫ��LRU�����߳�������LRU���еĹ�
��ʧЧitem��������Ҫһ��αitem���顣αitem����Ĵ�С����LRU���еĸ�����������һһ��Ӧ��
*/

//���ͻ���ʹ������lru_crawler crawl <classid,classid,classid|all>ʱ��  
//worker�߳̾ͻ���ñ�����,��������ĵڶ���������Ϊ�������Ĳ���  
enum crawler_result_type lru_crawler_crawl(char *slabs) {
    char *b = NULL;
    uint32_t sid = 0;
    uint8_t tocrawl[POWER_LARGEST];

    //LRU�����߳̽��������ʱ�򣬻�����lru_crawler_lock��ֱ���������  
    //����������Ż���������Կͻ��˵�ǰһ����������û����ǰ������  
    //���ύ����һ����������     
    if (pthread_mutex_trylock(&lru_crawler_lock) != 0) {
        return CRAWLER_RUNNING;
    }
    pthread_mutex_lock(&cache_lock);

    //��������������Ҫ���ĳһ��LRU���н���������ô����tocrawl����  
    //��ӦԪ�ظ�ֵ1��Ϊ��־  
    if (strcmp(slabs, "all") == 0) { //����ȫ��lru����  
        for (sid = 0; sid < LARGEST_ID; sid++) {
            tocrawl[sid] = 1;
        }
    } else {
        for (char *p = strtok_r(slabs, ",", &b);//������һ������sid  
             p != NULL;
             p = strtok_r(NULL, ",", &b)) {

            if (!safe_strtoul(p, &sid) || sid < POWER_SMALLEST
                    || sid > POWER_LARGEST) {
                pthread_mutex_unlock(&cache_lock);
                pthread_mutex_unlock(&lru_crawler_lock);
                return CRAWLER_BADCLASS;
            }
            tocrawl[sid] = 1;
        }
    }

    //crawlers��һ��αitem�������顣����û�Ҫ����ĳһ��LRU���У���ô  
    //�������LRU�����в���һ��αitem  
    for (sid = 0; sid < LARGEST_ID; sid++) {
        if (tocrawl[sid] != 0 && tails[sid] != NULL) {
            if (settings.verbose > 2)
                fprintf(stderr, "Kicking LRU crawler off for slab %d\n", sid);
            //����αitem��������item��������nkey��time��������Ա��ֵ����  
            crawlers[sid].nbytes = 0;
            crawlers[sid].nkey = 0;
            crawlers[sid].it_flags = 1; /* For a crawler, this means enabled. */
            crawlers[sid].next = 0;
            crawlers[sid].prev = 0;
            crawlers[sid].time = 0;
            crawlers[sid].remaining = settings.lru_crawler_tocrawl;
            crawlers[sid].slabs_clsid = sid;
            crawler_link_q((item *)&crawlers[sid]); //�����αitem���뵽��Ӧ��lru���е�β��  
            crawler_count++; //Ҫ�����LRU��������һ  
        }
    }
    pthread_mutex_unlock(&cache_lock);
    //���lru_crawler crawl<classid,classid,classid|all>������ָ������ġ�������ָ����Ҫ���ĸ�LRU���н�������
    pthread_cond_signal(&lru_crawler_cond); //�������ˣ�����LRU�����̣߳�����ִ����������  
    STATS_LOCK();
    stats.lru_crawler_running = true;
    STATS_UNLOCK();
    pthread_mutex_unlock(&lru_crawler_lock);
    return CRAWLER_OK;
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
