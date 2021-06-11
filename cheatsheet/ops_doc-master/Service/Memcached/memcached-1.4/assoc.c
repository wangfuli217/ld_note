/* -*- Mode: C; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*- */
/*
 * Hash table
 *
 * The hash function used here is by Bob Jenkins, 1996:
 *    <http://burtleburtle.net/bob/hash/doobs.html>
 *       "By Bob Jenkins, 1996.  bob_jenkins@burtleburtle.net.
 *       You may use this code any way you wish, private, educational,
 *       or commercial.  It's free."
 *
 * The rest of the file is licensed under the BSD license.  See LICENSE.
 */

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

//hashsize(2)Ϊ2���ݣ�����hashmask��ֵ�Ķ�������ʽ���Ǻ���ȫΪ1��������ͺ���λ���������&
//value & hashmask(n)�Ľ���϶���hashsize(n)С��һ�����֣��������hash������
#define hashsize(n) ((ub4)1<<(n))
//hashmask(n)Ҳ���Գ�Ϊ��ϣ����
#define hashmask(n) (hashsize(n)-1)

/* Main hash table. This is where we look except during expansion. */
//��ϣ������ָ��  ������hash��չ��ʱ�򣬿����µ�hash�ռ䣬��assoc_expand  ֮ǰ�ľ�hash����old_hashtable
//��hash��ṹ���壬��hash������ʱ�����д�hash������������hash�����֣��ýṹ��ָ���ָ�룬Ҳ���൱������ָ��
static item** primary_hashtable = 0;

/*
 * Previous hash table. During expansion, we look here for keys that haven't
 * been moved over to the primary yet.
 */ //������hash��չ��ʱ�򣬿����µ�hash�ռ䣬��assoc_expand  ֮ǰ�ľ�hash����old_hashtable
static item** old_hashtable = 0;

/* Number of items in the hash table. */
static unsigned int hash_items = 0;

/* Flag: Are we in the middle of expanding now? */
static bool expanding = false; //hash��չ��ʱ����1����assoc_expand
static bool started_expanding = false;

/*
 * During expansion we migrate values with bucket granularity; this is how
 * far we've gotten so far. Ranges from 0 .. hashsize(hashpower - 1) - 1.
 */
static unsigned int expand_bucket = 0;

//Ĭ�ϲ���Ϊ0.��������main�������ã�������Ĭ��ֵΪ0
void assoc_init(const int hashtable_init) {
    if (hashtable_init) { //��������˳�ʼ�������������õĲ������г�ʼ��
        hashpower = hashtable_init;
    }
	//��Ϊ��ϣ���������������Ҫʹ�ö�̬�ڴ���䡣��ϣ��洢��������һ��
	//ָ�룬������ʡ�ռ䡣
	//hashsize(hashpower)���ǹ�ϣ��ĳ�����
    primary_hashtable = calloc(hashsize(hashpower), sizeof(void *));
    if (! primary_hashtable) {
        fprintf(stderr, "Failed to init hashtable.\n");
        exit(EXIT_FAILURE);//��ϣ����memcached�����Ļ��������ʧ��ֻ���˳�����
    }
    STATS_LOCK(); //ȫ��ͳ����Ϣ��������֤����ͬ��
    stats.hash_power_level = hashpower;
    stats.hash_bytes = hashsize(hashpower) * sizeof(void *);
    STATS_UNLOCK();
}

//���ڹ�ϣֵֻ��ȷ�����ڹ�ϣ���е��ĸ�Ͱ(bucket)����һ��Ͱ��������һ����ͻ����
//��ʱ��Ҫ�õ�����ļ�ֵ������һһ�Ƚϳ�ͻ���ϵ����нڵ㡣��Ȼkey����'\0'��β��
//�ַ�����������strlen�����е��ʱ(��Ҫ������ֵ�ַ���)��������Ҫ����һ������nkey
//ָ�����key�ĳ���       ���ڿ��ٲ��Ҹ�key��Ӧ��item����assoc_find   item����hash����assoc_insert
item *assoc_find(const char *key, const size_t nkey, const uint32_t hv) {
    item *it;
    unsigned int oldbucket;

    if (expanding &&
        (oldbucket = (hv & hashmask(hashpower - 1))) >= expand_bucket)
    {
        it = old_hashtable[oldbucket];
    } else {
    	//�ɹ�ϣֵ�ж����key�������ĸ�Ͱ��
        it = primary_hashtable[hv & hashmask(hashpower)];
    }

	//������Ѿ�ȷ�����key�������ĸ�Ͱ�ģ�������ӦͰ�ĳ�ͻ������
    item *ret = NULL;
    int depth = 0;
    while (it) {
		//������ͬ������²ŵ���memcmp�Ƚϣ�����Ч
        if ((nkey == it->nkey) && (memcmp(key, ITEM_key(it), nkey) == 0)) {
            ret = it;
            break;
        }
        it = it->h_next;
        ++depth;
    }
    MEMCACHED_ASSOC_FIND(key, nkey, depth);
    return ret;
}

/* returns the address of the item pointer before the key.  if *item == 0,
   the item wasn't found */
//����item������ǰ������h_next��Ա��ַ���������ʧ����ô�ͷ��س�ͻ�������
//һ���ڵ��h_next��Ա��ַ����Ϊ���һ���ڵ��h_next��ֵΪNULL��ͨ���Է���ֵ
//ʹ��*���㼴��֪����û�в��ҳɹ�
static item** _hashitem_before (const char *key, const size_t nkey, const uint32_t hv) {
    item **pos;
    unsigned int oldbucket;

    if (expanding && //������չ��ϣ��
        (oldbucket = (hv & hashmask(hashpower - 1))) >= expand_bucket)
    {
        pos = &old_hashtable[oldbucket];
    } else {
    	//�ҵ���ϣ���ж�Ӧ��Ͱ��λ��
        pos = &primary_hashtable[hv & hashmask(hashpower)];
    }

	//����Ͱ�ĳ�ͻ������item
    while (*pos && ((nkey != (*pos)->nkey) || memcmp(key, ITEM_key(*pos), nkey))) {
        pos = &(*pos)->h_next;
    }
	//*pos�Ϳ���֪����û�в��ҳɹ������*pos����NULL��ô����ʧ�ܣ�������ҳɹ�
    return pos;
}

/* grows the hashtable to the next power of 2. */
//�����ϣ��ı�
static void assoc_expand(void) {
    old_hashtable = primary_hashtable;

	//����һ���¹�ϣ������old_hashtableָ��ɹ�ϣ��
    primary_hashtable = calloc(hashsize(hashpower + 1), sizeof(void *));
    if (primary_hashtable) {
        if (settings.verbose > 1)
            fprintf(stderr, "Hash table expansion starting\n");
        hashpower++;
		//�����Ѿ�������չ״̬
        expanding = true;
		//��0��Ͱ��ʼ����Ǩ��
        expand_bucket = 0;
        STATS_LOCK();
        stats.hash_power_level = hashpower;
        stats.hash_bytes += hashsize(hashpower) * sizeof(void *);
        stats.hash_is_expanding = 1;
        STATS_UNLOCK();
    } else {
        primary_hashtable = old_hashtable;
        /* Bad news, but we can keep running. */
    }
}

//assoc_insert��������ñ���������item�������˹�ϣ�����1.5���Ż���� 
static void assoc_start_expand(void) {
    if (started_expanding)
        return;
    started_expanding = true;
    pthread_cond_signal(&maintenance_cond);
}

/* Note: this isn't an assoc_update.  The key must not already exist to call this */
//hv�����item��ֵ�Ĺ�ϣֵ�����ڿ��ٲ��Ҹ�key��Ӧ��item����assoc_find   item����hash����assoc_insert
int assoc_insert(item *it, const uint32_t hv) {
    unsigned int oldbucket; // ����hash����Ϊassoc_insert  ����lru���еĺ���Ϊitem_link_q

//    assert(assoc_find(ITEM_key(it), it->nkey) == 0);  /* shouldn't have duplicately named things defined */
	//ʹ��ͷ�巨������һ��item
	//��һ�ο���������ֱ�ӿ�else����
    if (expanding &&
        (oldbucket = (hv & hashmask(hashpower - 1))) >= expand_bucket)
    {
        it->h_next = old_hashtable[oldbucket];
        old_hashtable[oldbucket] = it;
    } else {
    	//ʹ��ͷ�巨�����ϣ����
        it->h_next = primary_hashtable[hv & hashmask(hashpower)];
        primary_hashtable[hv & hashmask(hashpower)] = it;
    }

    hash_items++;//��ϣ���item������һ
    if (! expanding && hash_items > (hashsize(hashpower) * 3) / 2) {
        assoc_start_expand();
    }

    MEMCACHED_ASSOC_INSERT(ITEM_key(it), it->nkey, hash_items);
    return 1;
}

void assoc_delete(const char *key, const size_t nkey, const uint32_t hv) {
	//�õ�ǰ������h_next��Ա��ַ
    item **before = _hashitem_before(key, nkey, hv);

    if (*before) {//���ҳɹ�
        item *nxt;
        hash_items--;
        /* The DTrace probe cannot be triggered as the last instruction
         * due to possible tail-optimization by the compiler
         */
        MEMCACHED_ASSOC_DELETE(key, nkey, hash_items);

		//��Ϊbefore��һ������ָ�룬��ֵΪ������item��ǰ��item��h_next��Ա��ַ
		//����*beforeָ����������ҵ�item����Ϊbefore��һ������ָ�룬����*before
		//��Ϊ��ֵʱ�����Ը�h_next��Ա������ֵ�������������д�����
		//ʹ��ɾ���м��item��ǰ���item��������������
		
        nxt = (*before)->h_next;
        (*before)->h_next = 0;   /* probably pointless, but whatever. */
        *before = nxt;
        return;
    }
    /* Note:  we never actually get here.  the callers don't delete things
       they can't find. */
    assert(*before != 0);
}


static volatile int do_run_maintenance_thread = 1;

#define DEFAULT_HASH_BULK_MOVE 1
int hash_bulk_move = DEFAULT_HASH_BULK_MOVE;

//����Ǩ���̻߳ص�����
static void *assoc_maintenance_thread(void *arg) {

	//do_run_maintenance_thread ��ȫ�ֱ�������ʼֵΪ1����stop_assoc_mainternance_thread
	//�����лᱻ��ֵ0��֮��Ǩ���߳�
    while (do_run_maintenance_thread) {
        int ii = 0;

        /* Lock the cache, and bulk move multiple buckets to the new
         * hash table. */
         //����
        item_lock_global();//����ȫ�ּ��������ȫ����item����ȫ�����Ŀ���֮��  
        //��ס��ϣ�������item����Ȼ����̶߳Թ�ϣ�������ɾ����ʱ�������  
        //���ݲ�һ�µ����.��item.c��do_item_link��do_item_unlink���Կ���  
        //���ڲ�Ҳ����סcache_lock��.  
        mutex_lock(&cache_lock);
		//����itemǨ��
        for (ii = 0; ii < hash_bulk_move && expanding; ++ii) {
            item *it, *next;
            int bucket;

            for (it = old_hashtable[expand_bucket]; NULL != it; it = next) {
                next = it->h_next;

                bucket = hash(ITEM_key(it), it->nkey) & hashmask(hashpower);
                it->h_next = primary_hashtable[bucket];
                primary_hashtable[bucket] = it;
            }

            old_hashtable[expand_bucket] = NULL;

            expand_bucket++;
            if (expand_bucket == hashsize(hashpower - 1)) {
                expanding = false;
                free(old_hashtable);
                STATS_LOCK();
                stats.hash_bytes -= hashsize(hashpower - 1) * sizeof(void *);
                stats.hash_is_expanding = 0;
                STATS_UNLOCK();
                if (settings.verbose > 1)
                    fprintf(stderr, "Hash table expansion done\n");
            }
        }

		//��������ͷ���
        mutex_unlock(&cache_lock);
        item_unlock_global();
		
		//����ҪǨ��������
        if (!expanding) { 
            /*
                Ǩ���߳�ΪʲôҪ��ô�ػ����۵��л�workers�̵߳��������أ�ֱ���޸������̵߳�LIBEVENT_THREAD�ṹ��item_lock_type
             ��Ա��������������
                ����Ҫ����ΪǨ���̲߳�֪��worker�̴߳˿��ڸ�Щʲô�����worker�߳����ڷ���item������ռ�˶μ���������ʱ���worker
             �̵߳����л���ȫ��������worker�߳̽�����ʱ��ͻ��ȫ����(�ο�ǰ���item_lock��item_unlock����)����������ͱ����ˡ�
             ���Բ���Ǩ���߳�ȥ�л���ֻ��Ǩ���߳�֪ͨworker�̣߳�Ȼ��worker�߳��Լ�ȥ�л�����Ȼ��Ҫworker�߳�æ������ͷ�ϵ�����
             �󣬲Ż�ȥ�޸��л��ġ�����Ǩ���߳���֪ͨ�����е�worker�̺߳󣬻����wait_for_thread_registration�������ߵȴ����е�
             worker�̶߳��л���ָ���������ͺ��������
            */
            /* finished expanding. tell all threads to use fine-grained locks */

            //���뵽���˵���Ѿ�����ҪǨ������(ֹͣ��չ��)��  
            //�������е�workers�̣߳�����itemʱ���л����μ��������  
            //������������workers�̶߳��л����μ������  
            switch_item_lock_type(ITEM_LOCK_GRANULAR);
            slabs_rebalancer_resume();
            /* We are done expanding.. just wait for next invocation */
            mutex_lock(&cache_lock);
			// ����
            started_expanding = false;

			//����Ǩ���̣߳�ֱ��worker�̲߳������ݺ���item�����Ѿ�����1.5����ϣ���С��
			//��ʱ����worker�̵߳���assoc_start_expand�������ú��������pthread_cond_signal����Ǩ���߳�
            pthread_cond_wait(&maintenance_cond, &cache_lock);
            /* Before doing anything, tell threads to use a global lock */
            mutex_unlock(&cache_lock);
            slabs_rebalancer_pause();

            //��maintenance_cond����������������˵����Ҫ��ʼ��չ��ϣ���Ǩ�������ˡ�  
            //Ǩ���߳���Ǩ��һ��Ͱ������ʱ������ȫ�ּ������.  
            //��ʱworkers�̲߳���ʹ�öμ������������Ҫʹ��ȫ�ּ��������  
            //���е�workers�̺߳�Ǩ���߳�һ������ȫ�ּ������.  
            //�ĸ��߳������ˣ�����Ȩ������item.  
            //����һ�д������֪ͨ���е�workers�̣߳������Ƿ���item�����л�  
            //��ȫ�ּ��������switch_item_lock_type��ͨ�������������ߵȴ���  
            //ֱ�������е�workers�̶߳��л���ȫ�ּ���������Ż�������  
            switch_item_lock_type(ITEM_LOCK_GLOBAL);
            mutex_lock(&cache_lock);
			//�������Ĺ�ϣ������expanding����Ϊtrue
            assoc_expand();
            mutex_unlock(&cache_lock);
        }
    }
    return NULL;
}

//����Ǩ���߳�
static pthread_t maintenance_tid;

//main��������ñ���������������Ǩ���߳�
int start_assoc_maintenance_thread() {
    int ret;
    char *env = getenv("MEMCACHED_HASH_BULK_MOVE");
    if (env != NULL) {
		//hash_bulk_move�������ں����˵����������ͨ������������hash_bulk_move��ֵ
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

void stop_assoc_maintenance_thread() {
    mutex_lock(&cache_lock);
    do_run_maintenance_thread = 0;
    pthread_cond_signal(&maintenance_cond);
    mutex_unlock(&cache_lock);

    /* Wait for the maintenance thread to stop */
    pthread_join(maintenance_tid, NULL);
}


