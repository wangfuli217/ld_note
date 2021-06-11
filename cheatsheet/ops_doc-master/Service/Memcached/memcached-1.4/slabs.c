/* -*- Mode: C; tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*- */
/*
 * Slabs memory allocation, based on powers-of-N. Slabs are up to 1MB in size
 * and are divided into chunks. The chunk sizes start off at the size of the
 * "item" structure plus space for a small key and value. They increase by
 * a multiplier factor from there, up to half the maximum slab size. The last
 * slab size is always 1MB, since that's the maximum item size allowed by the
 * memcached protocol.
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

/* powers-of-N allocation structures */

typedef struct {  //���Բο�slabs_init
	//slab�����������item�Ĵ�С������item�ṹͷ��
    unsigned int size;      /* sizes of items */
	//ÿ��slab�������ܷ�����ٸ�item
    unsigned int perslab;   /* how many items per slab */

	//ָ�����item����
    void *slots;           /* list of item ptrs */
	//����item�ĸ���  ÿȡ��һ��item��1����do_slabs_alloc
    unsigned int sl_curr;   /* total free items in list */

	//������Ѿ��������ڴ��slabs������list_size�����slab����(slab_list)�Ĵ�С
	//��ʾ�ж��ٸ������͵�slab�����Բο�http://blog.csdn.net/yxnyxnyxnyxnyxn/article/details/7869900
    unsigned int slabs;     /* how many slabs were allocated for this class */

    //grow_slab_list�и���ֵ������ָ��      //grow_slab_list�д����ռ�͸�ֵ
	//slab���飬�����ÿһ��Ԫ�ؾ���һ��slab����������Щ��������������ͬ�ߴ���ڴ�
	//���ڹ�����trunk��ͬ��slabs,����chunk����128��slab,�Ѿ�����3��chunkΪ128��slab����ô��3��slab��ͨ��slab_list����
    void **slab_list;       /* array of slab pointers */ //������1M��Сchunk��slab����ͨ����list����

	//slab����Ĵ�С��list_size >= slabs  grow_slab_list�и���ֵ
    unsigned int list_size; /* size of prev array */ //grow_slab_list�д����ռ�͸�ֵ

	//����reassign��ָ��slabclass-t�е��ĸ��ڴ���Ҫ������slabclass_tʹ�ã����ط�ҳ��ʱ��ʹ�ã���slab_rebalance_start
    unsigned int killing;  /* index+1 of dying slab, or zero if none */

	//��slabclass_t�����ȥ�����ֽ��� do_slabs_alloc   ʵ��ռ�õ�chunk�е�ʵ��ʹ���ֽ�����ʵ����Ҫ��chunk�٣���Ϊһ�㲻��պô洢key-value���ȸպ�Ϊchunk
    size_t requested; /* The number of requested bytes */
} slabclass_t;

static slabclass_t slabclass[MAX_NUMBER_OF_SLAB_CLASSES];

//�û����õ��ڴ�������� Ҳ����settings.maxbytes
static size_t mem_limit = 0;
static size_t mem_malloced = 0;
static int power_largest; //chunk����item��Ӧ��slabclass[]id�ţ�Ҳ����chunk����settings.item_size_max��item

//�������Ҫ��Ԥ�ȷ����ڴ棬�����ǵ�����Ҫ��ʱ��ŷ����ڴ棬��ô
//mem_base����ָ���ǿ�Ԥ�ȷ�����ڴ�
//mem_currentָ�򻹿���ʹ�õ��ڴ�Ŀ�ʼλ��
//mem_availָ�����ж����ڴ����ʹ��  �ο�memory_allocate
static void *mem_base = NULL;  //�����ΪNULL����Ϊ�������ͰѸ�memcached������������ʹ�ÿռ�һ���Է���ã���slabs_init
//ʵ��malloc���ڴ�ռ䣬��memory_allocate   mem_currentָ�򻹿���ʹ�õ��ڴ�Ŀ�ʼλ��
static void *mem_current = NULL;
static size_t mem_avail = 0; //mem_availָ�����ж����ڴ����ʹ��

/**
 * Access to the slab allocator is protected by this lock
 */
static pthread_mutex_t slabs_lock = PTHREAD_MUTEX_INITIALIZER;
static pthread_mutex_t slabs_rebalance_lock = PTHREAD_MUTEX_INITIALIZER;

/*
 * Forward Declarations
 */
static int do_slabs_newslab(const unsigned int id);
static void *memory_allocate(size_t size);
static void do_slabs_free(void *ptr, const size_t size, unsigned int id);

/* Preallocate as many slab pages as possible (called from slabs_init)
   on start-up, so users don't get confused out-of-memory errors when
   they do have free (in-slab) space, but no space to make new slabs.
   if maxslabs is 18 (POWER_LARGEST - POWER_SMALLEST + 1), then all
   slab types can be made.  if max memory is less than 18 MB, only the
   smaller ones will be made.  */
static void slabs_preallocate (const unsigned int maxslabs);

/*
 * Figures out which slab class (chunk size) is required to store an item of
 * a given size.
 *
 * Given object size, return id to use when allocating/freeing memory for object
 * 0 means error: can't store such a large object
 */

unsigned int slabs_clsid(const size_t size) {
    int res = POWER_SMALLEST; //res�ĳ�ʼֵΪ1

	//����0��ʾ����ʧ�ܣ���Ϊslabclass�����У���һ��Ԫ����û��ʹ�õ�
    if (size == 0)
        return 0;
	//��Ϊslabclass�����и���Ԫ���ܷ����item��С�������
	//���Դ�С����ֱ���жϿ��������ҵ���С�����������Ԫ��
    while (size > slabclass[res].size)
        if (res++ == power_largest)     /* won't fit in the biggest slab */
            return 0;
    return res;
}

unsigned int slabs_get_curr(item *it) {
    int id = slabs_clsid(ITEM_ntotal(it));
    slabclass_t *p = &slabclass[id];
    
    printf("yang test xxxxxxxxxxxxxxxxxxxxxxxxxx frenum:%u\n", p->sl_curr);

    return 0;
}


/**
 * Determines the chunk sizes and initializes the slab class descriptors
 * accordingly.
 //
 */ //http://xenojoshua.com/2011/04/deep-in-memcached-how-it-works/ 
 //����factor���������ӣ�Ĭ��ֵ��1.25
// Memcachedʹ��SLAB�������ڴ棬SLAB�ڴ����ֱ�۵Ľ��;��Ƿ���һ�����ڴ棬֮�󰴲�ͬ�Ŀ�
// ��48byte,64byte,...1M�����з���Щ�ڴ棬�洢ҵ������ʱ������ѡ����ʵ��ڴ�ռ�洢���ݡ�
//Memcached�״�Ĭ�Ϸ���64M���ڴ棬֮�����е����ݶ�������64M�ռ���д洢����Memcached����֮��
//�������Щ�ڴ�ִ���ͷŲ�������Щ�ڴ�ֻ�е�Memcached�����˳�֮��ᱻϵͳ���գ�
void slabs_init(const size_t limit, const double factor, const bool prealloc) {
    int i = POWER_SMALLEST - 1;

	//settings.chunk_sizeĬ��ֵΪ48������������memcached��ʱ��ͨ��-nѡ������
	//size�����������: item�ṹ�屾������item��Ӧ������
	//���������Ҳ����set��add�����е��Ǹ����ݣ������ѭ�����Կ������size����
	//�������������factor�������������ܴ洢�����ݳ���Ҳ�����

	unsigned int size = sizeof(item) + settings.chunk_size;

	//�û����û�Ĭ�ϵ��ڴ��С����
    mem_limit = limit;

	//�û�Ҫ��Ԥ����һ����ڴ棬�Ժ���Ҫ�ڴ棬��������ڴ�����
    if (prealloc) { //Ĭ��false
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

	//��ʼ�����飬�����������Ҫ������������Ԫ�صĳ�Ա������Ϊ0��
    memset(slabclass, 0, sizeof(slabclass));

	//slabclass�����еĵ�һ��Ԫ�ز���ʹ��
	//settings.item_size_max��memecached֧�ֵ����item�ߴ磬Ĭ��Ϊ1M
	//Ҳ����������˵��memcahced�洢���������Ϊ1MB
    while (++i < POWER_LARGEST && size <= settings.item_size_max / factor) {
        /* Make sure items are always n-byte aligned */
        if (size % CHUNK_ALIGN_BYTES) //8�ֽڶ���
            size += CHUNK_ALIGN_BYTES - (size % CHUNK_ALIGN_BYTES);

		//���slabclass��slab�������ܷ����item�Ĵ�С
        slabclass[i].size = size;
		//���slabclass��slab����������ܷ�����ٸ�item(Ҳ����������������ڴ�)
        slabclass[i].perslab = settings.item_size_max / slabclass[i].size;
		//����
        size *= factor;
        if (settings.verbose > 1) {
            fprintf(stderr, "slab class %3d: chunk size %9u perslab %7u\n",
                    i, slabclass[i].size, slabclass[i].perslab);
        }
    }
	//����item
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
	//Ԥ�ȷ����ڴ�
    if (prealloc) {
        slabs_preallocate(power_largest);
    }
}

//����ֵΪʹ�õ���slabclass����Ԫ�ظ���
//Ϊslabclass�����ÿһ��Ԫ��(ʹ�õ���Ԫ��)�����ڴ�
static void slabs_preallocate (const unsigned int maxslabs) {
    int i;
    unsigned int prealloc = 0;

    /* pre-allocate a 1MB slab in every size class so people don't get
       confused by non-intuitive "SERVER_ERROR out of memory"
       messages.  this is the most common question on the mailing
       list.  if you really don't want this, you can rebuild without
       these three lines.  */

	//����slabclass����
    for (i = POWER_SMALLEST; i <= POWER_LARGEST; i++) {
		//��Ȼֻ�Ǳ���ʹ���˵�����Ԫ��
        if (++prealloc > maxslabs)
            return;
        if (do_slabs_newslab(i) == 0) {
			//Ϊÿһ��slabclass_t����һ���ڴ�ҳ
			//�������ʧ�ܣ����˳�������Ϊ���Ԥ������ڴ��Ǻ���������еĻ���
			//����������ʧ���ˣ�����Ĵ����޴�ִ�С�����ֱ���˳�����
            fprintf(stderr, "Error while preallocating slab memory!\n"
                "If using -L or other prealloc options, max memory must be "
                "at least %d megabytes.\n", power_largest);
            exit(1);
        }
    }

}

//����slab_list��Աָ����ڴ棬Ҳ��������slab_list���顣ʹ�ÿ����и����slab������
//�����ڴ����ʧ�ܣ������Ƿ���-1�������Ƿ�����������
static int grow_slab_list (const unsigned int id) {
    slabclass_t *p = &slabclass[id];
    if (p->slabs == p->list_size) {//������֮ǰ���뵽��slab_list���������Ԫ��
        size_t new_size =  (p->list_size != 0) ? p->list_size * 2 : 16;
        void *new_list = realloc(p->slab_list, new_size * sizeof(void *));
        if (new_list == 0) return 0;
        p->list_size = new_size;
        p->slab_list = new_list;
    }
    return 1;
}

//��һ��slab������1M�ռ��и��perslab��chunk��ͨ��next��prevָ��������һ��
static void split_slab_page_into_freelist(char *ptr, const unsigned int id) {
    slabclass_t *p = &slabclass[id];
    int x;
    for (x = 0; x < p->perslab; x++) {
        do_slabs_free(ptr, 0, id);
        ptr += p->size;
    }
}

//slabclass_t��slab����Ŀ����������ġ��ú�����������Ϊslabclass_t�����һ��slab
//����idָ����slabclass�����е��Ǹ�slabclass_t
static int do_slabs_newslab(const unsigned int id) {
    slabclass_t *p = &slabclass[id];
	//setting.slab_rassingn��Ĭ��ֵΪfalse������Ͳ���false
    int len = settings.slab_reassign ? settings.item_size_max
        : p->size * p->perslab;
    char *ptr;

	//mem_malloced��ֵͨ�������������ã�Ĭ��Ϊ0
    if ((mem_limit && mem_malloced + len > mem_limit && p->slabs > 0) ||
        (grow_slab_list(id) == 0) || //����slab_list(ʧ�ܷ���0)��һ���ɹ��������޷������ڴ�
        ((ptr = memory_allocate((size_t)len)) == 0)) { //����len�ֽ��ڴ�(Ҳ����һ��ҳ)

        MEMCACHED_SLABS_SLABCLASS_ALLOCATE_FAILED(id);
        return 0;
    }

    memset(ptr, 0, (size_t)len);//����ڴ���Ǳ����

	//������ڴ��г�һ������item����Ȼitem�Ĵ�С��id������
	split_slab_page_into_freelist(ptr, id);

	//������õ����ڴ�ҳ����slab_list�ƹ�
    p->slab_list[p->slabs++] = ptr; //salb_list[0] = ptr,Ȼ��slabs++��Ϊ1��Ҳ����[0]ָ���һ��item
    mem_malloced += len;
    MEMCACHED_SLABS_SLABCLASS_ALLOCATE(id);

    return 1;
}

/*@null@*/
//��slabclass����һ��item���ڵ��ú���֮ǰ���Ѿ�����slabs_clsid����ȷ��
//�������������ĸ�slabclass_t����item�ˣ�����id����ָ�������ĸ�slabclass_t
//����item�������slabclass_t���п���item����ô�ʹӿ��е�item���з���һ��
//���û�п���item����ô������һ���ڴ�ҳ���ٴ��������ҳ�з���һ��item
// ����ֵΪ�õ���item�����û���ڴ��ˣ�����NULL
static void *do_slabs_alloc(const size_t size, unsigned int id) {
    slabclass_t *p;
    void *ret = NULL;
    item *it = NULL;

    if (id < POWER_SMALLEST || id > power_largest) {//�±�Խ��
        MEMCACHED_SLABS_ALLOCATE_FAILED(size, 0);
        return NULL;
    }

    p = &slabclass[id];
    assert(p->sl_curr == 0 || ((item *)p->slots)->slabs_clsid == 0);

	//���p->sl_curr����0����˵����slabclass_tû�п��е�item�ˡ�
	//��ʱ��Ҫ����do_slabs_newslab����һ���ڴ�ҳ
    /* fail unless we have space at the end of a recently allocated page,
       we have something on our freelist, or we could allocate a new page */
    if (! (p->sl_curr != 0 || do_slabs_newslab(id) != 0)) {
        /* We don't have more memory available */
		//��p->sl_curr����0����do_slabs_newslab�ķ���ֵ����0ʱ����������
        ret = NULL; //˵��ָ������memcached�ڴ�ﵽ������
    } else if (p->sl_curr != 0) {
        /* return off our freelist */
		//����do_slabs_newslab����ʧ�ܣ����򶼻������������һ��ʼsl_curr�Ƿ�Ϊ0.
		//p->slotsָ���һ�����е�item����ʱҪ�ѵ�һ�����е�item�����ȥ
        it = (item *)p->slots;
        p->slots = it->next;//slotsָ����һ�����е�item
        if (it->next) it->next->prev = 0;
        p->sl_curr--; //������Ŀ��һ
        ret = (void *)it;
    }

    if (ret) {
        p->requested += size;//����slabclass�����ȥ���ֽ���
        MEMCACHED_SLABS_ALLOCATE(size, id, p->size, ret);
    } else {
        MEMCACHED_SLABS_ALLOCATE_FAILED(size, id);
    }

    return ret;
}

////��������item �����ص���Ӧslabclass�Ŀ���������  
static void do_slabs_free(void *ptr, const size_t size, unsigned int id) {
    slabclass_t *p;
    item *it;

    assert(((item *)ptr)->slabs_clsid == 0);
    assert(id >= POWER_SMALLEST && id <= power_largest);
    if (id < POWER_SMALLEST || id > power_largest)
        return;

    MEMCACHED_SLABS_FREE(size, id, ptr);
    p = &slabclass[id];

    it = (item *)ptr;
	//Ϊitem��it_flags���ITEM_SLABBED���ԣ��������item����slab��û�б������ȥ
    it->it_flags |= ITEM_SLABBED;

	//��split_slab_page_into_freelist����ʱ������4�е�������
	//����Щitem��prev��next�໥ָ�򣬰���Щitem��������
	//������������worker�߳����ڴ�ع黹�ڴ�ʱ���ã���ô����4�е������ǣ�
	//ʹ������ͷ�巨�Ѹ�item���뵽����item������
    it->prev = 0;
    it->next = p->slots;
    if (it->next) it->next->prev = it;
    p->slots = it; //slot����ָ���һ�����п���ʹ�õ�item

    p->sl_curr++; //���п���ʹ�õ�item����
    p->requested -= size;//�������slabclass_t�����ȥ���ֽ���
    return;
}

static int nz_strcmp(int nzlength, const char *nz, const char *z) {
    int zlength=strlen(z);
    return (zlength == nzlength) && (strncmp(nz, z, zlength) == 0) ? 0 : -1;
}

bool get_stats(const char *stat_type, int nkey, ADD_STAT add_stats, void *c) {
    bool ret = true;

    if (add_stats != NULL) {
        if (!stat_type) {
            /* prepare general statistics for the engine */
            STATS_LOCK();
            APPEND_STAT("bytes", "%llu", (unsigned long long)stats.curr_bytes);
            APPEND_STAT("curr_items", "%u", stats.curr_items);
            APPEND_STAT("total_items", "%u", stats.total_items);
            STATS_UNLOCK();
            item_stats_totals(add_stats, c);
        } else if (nz_strcmp(nkey, stat_type, "items") == 0) {
            item_stats(add_stats, c);
        } else if (nz_strcmp(nkey, stat_type, "slabs") == 0) {
            slabs_stats(add_stats, c);
        } else if (nz_strcmp(nkey, stat_type, "sizes") == 0) {
            item_stats_sizes(add_stats, c);
        } else {
            ret = false;
        }
    } else {
        ret = false;
    }

    return ret;
}

/*
stats slabs
STAT 1:chunk_size 96
STAT 1:chunks_per_page 10922
STAT 1:total_pages 1
STAT 1:total_chunks 10922
STAT 1:used_chunks 4
STAT 1:free_chunks 10918
STAT 1:free_chunks_end 0
STAT 1:mem_requested 300
STAT 1:get_hits 2
STAT 1:cmd_set 6
STAT 1:delete_hits 0
STAT 1:incr_hits 0
STAT 1:decr_hits 0
STAT 1:cas_hits 0
STAT 1:cas_badval 0
STAT 1:touch_hits 0
STAT 4:chunk_size 192
STAT 4:chunks_per_page 5461
STAT 4:total_pages 1
STAT 4:total_chunks 5461
STAT 4:used_chunks 11
STAT 4:free_chunks 5450
STAT 4:free_chunks_end 0
STAT 4:mem_requested 2041
STAT 4:get_hits 0
STAT 4:cmd_set 16169
STAT 4:delete_hits 0
STAT 4:incr_hits 0
STAT 4:decr_hits 0
STAT 4:cas_hits 0
STAT 4:cas_badval 0
STAT 4:touch_hits 0
STAT active_slabs 2
STAT total_malloced 2097024
END
*/
/*@null@*/
static void do_slabs_stats(ADD_STAT add_stats, void *c) {
    int i, total;
    /* Get the per-thread stats which contain some interesting aggregates */
    struct thread_stats thread_stats;
    threadlocal_stats_aggregate(&thread_stats);

    total = 0;
    for(i = POWER_SMALLEST; i <= power_largest; i++) {
        slabclass_t *p = &slabclass[i];
        if (p->slabs != 0) {
            uint32_t perslab, slabs;
            slabs = p->slabs;
            perslab = p->perslab;

            char key_str[STAT_KEY_LEN];
            char val_str[STAT_VAL_LEN];
            int klen = 0, vlen = 0;

            APPEND_NUM_STAT(i, "chunk_size", "%u", p->size);
            APPEND_NUM_STAT(i, "chunks_per_page", "%u", perslab);
            APPEND_NUM_STAT(i, "total_pages", "%u", slabs);
            APPEND_NUM_STAT(i, "total_chunks", "%u", slabs * perslab);
            APPEND_NUM_STAT(i, "used_chunks", "%u",
                            slabs*perslab - p->sl_curr);
            APPEND_NUM_STAT(i, "free_chunks", "%u", p->sl_curr);
            /* Stat is dead, but displaying zero instead of removing it. */
            APPEND_NUM_STAT(i, "free_chunks_end", "%u", 0);
            APPEND_NUM_STAT(i, "mem_requested", "%llu",
                            (unsigned long long)p->requested);
            APPEND_NUM_STAT(i, "get_hits", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].get_hits);
            APPEND_NUM_STAT(i, "cmd_set", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].set_cmds);
            APPEND_NUM_STAT(i, "delete_hits", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].delete_hits);
            APPEND_NUM_STAT(i, "incr_hits", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].incr_hits);
            APPEND_NUM_STAT(i, "decr_hits", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].decr_hits);
            APPEND_NUM_STAT(i, "cas_hits", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].cas_hits);
            APPEND_NUM_STAT(i, "cas_badval", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].cas_badval);
            APPEND_NUM_STAT(i, "touch_hits", "%llu",
                    (unsigned long long)thread_stats.slab_stats[i].touch_hits);
            total++;
        }
    }

    /* add overall slab stats and append terminator */

    APPEND_STAT("active_slabs", "%d", total);
    APPEND_STAT("total_malloced", "%llu", (unsigned long long)mem_malloced);
    add_stats(NULL, 0, NULL, 0, c);
}

//��������ڴ棬�����������Ԥ�����ڴ��ģ�����Ԥ�����ڴ�������ڴ�
//�������malloc�����ڴ�
static void *memory_allocate(size_t size) { //�����sizeһ����settings.item_size_max��СҲ����Ĭ��1M
    void *ret;

	//�������Ҫ��Ԥ�ȷ����ڴ棬�����ǵ�����Ҫ��ʱ��ŷ����ڴ棬��ô
	//mem_base��ָ���ǿ�Ԥ�ȷ�����ڴ�
	//mem_currentָ�򻹿���ʹ�õ��ڴ�Ŀ�ʼλ��
	//mem_availָ�����ж����ڴ��ǿ���ʹ�õ�
    if (mem_base == NULL) { //����Ԥ������ڴ�
        /* We are not using a preallocated large memory chunk */
        ret = malloc(size);
    } else {
        ret = mem_current;

		//���ֽڶ����У���󼸸����ڶ�����ֽڱ������û������
		//���������ȼ���size�Ƿ�ȿ��õ��ڴ��Ȼ��ż������
        if (size > mem_avail) { //û���㹻���ڴ����
            return NULL;
        }

		//���ڿ��Ƕ�������⣬��������size��mem_avail��Ҳ������ν��
		//��Ϊ��󼸸����ڶ�����ֽڲ�������ʹ��
        /* mem_current pointer _must_ be aligned!!! */
        if (size % CHUNK_ALIGN_BYTES) { //�ֽڶ��룬��֤size��CHUNK_ALIGN_BYTES(8)�ı���
            size += CHUNK_ALIGN_BYTES - (size % CHUNK_ALIGN_BYTES);
        }

        mem_current = ((char*)mem_current) + size;
        if (size < mem_avail) {
            mem_avail -= size;
        } else {//��ʱ��size��mem_avail��Ҳ����ν
            mem_avail = 0;
        }
    }

    return ret;
}

//��id��Ӧ��slabclass[id]�е�һ��chunk�л�ȡ�����size�ռ�
void *slabs_alloc(size_t size, unsigned int id) {
    void *ret;

    pthread_mutex_lock(&slabs_lock);
    ret = do_slabs_alloc(size, id);
    pthread_mutex_unlock(&slabs_lock);
    return ret;
}

void slabs_free(void *ptr, size_t size, unsigned int id) {
    pthread_mutex_lock(&slabs_lock);
    do_slabs_free(ptr, size, id);
    pthread_mutex_unlock(&slabs_lock);
}

void slabs_stats(ADD_STAT add_stats, void *c) {
    pthread_mutex_lock(&slabs_lock);
    do_slabs_stats(add_stats, c);
    pthread_mutex_unlock(&slabs_lock);
}

//�µ�itemֱ�Ӱ�ռ�ɵ�item�ͻ�����������   ���¼���һ�����slabclass_t�����ȥ���ڴ��С  
void slabs_adjust_mem_requested(unsigned int id, size_t old, size_t ntotal)
{
    pthread_mutex_lock(&slabs_lock);
    slabclass_t *p;
    if (id < POWER_SMALLEST || id > power_largest) {
        fprintf(stderr, "Internal error! Invalid slab class\n");
        abort();
    }

    p = &slabclass[id];
    p->requested = p->requested - old + ntotal;
    pthread_mutex_unlock(&slabs_lock);
}

static pthread_cond_t maintenance_cond = PTHREAD_COND_INITIALIZER;
static pthread_cond_t slab_rebalance_cond = PTHREAD_COND_INITIALIZER;
static volatile int do_run_slab_thread = 1;
static volatile int do_run_slab_rebalance_thread = 1;

#define DEFAULT_SLAB_BULK_CHECK 1
int slab_bulk_check = DEFAULT_SLAB_BULK_CHECK;

static int slab_rebalance_start(void) {
    slabclass_t *s_cls;
    int no_go = 0;

    pthread_mutex_lock(&cache_lock);
    pthread_mutex_lock(&slabs_lock);

    if (slab_rebal.s_clsid < POWER_SMALLEST ||
        slab_rebal.s_clsid > power_largest  ||
        slab_rebal.d_clsid < POWER_SMALLEST ||
        slab_rebal.d_clsid > power_largest  ||
        slab_rebal.s_clsid == slab_rebal.d_clsid) //�Ƿ��±�����  
        no_go = -2;

    s_cls = &slabclass[slab_rebal.s_clsid];

    //Ϊ���Ŀ��slab class����һ��ҳ���ʧ�ܣ���ô��  
    //�����޷�Ϊ֮����һ��ҳ��  
    if (!grow_slab_list(slab_rebal.d_clsid)) {
        no_go = -1;
    }

    if (s_cls->slabs < 2) //Դslab classҳ��̫���ˣ��޷���һ��ҳ������  
        no_go = -3;

    if (no_go != 0) {
        pthread_mutex_unlock(&slabs_lock);
        pthread_mutex_unlock(&cache_lock);
        return no_go; /* Should use a wrapper function... */
    }

    //��־��Դslab class�ĵڼ����ڴ�ҳ�ָ�Ŀ��slab class  
    //������Ĭ���ǽ���һ���ڴ�ҳ�ָ�Ŀ��slab class  
    s_cls->killing = 1;

    //��¼Ҫ�ƶ���ҳ����Ϣ��slab_startָ��ҳ�Ŀ�ʼλ�á�slab_endָ��ҳ  
    //�Ľ���λ�á�slab_pos���¼��ǰ�����λ��(item)  
    slab_rebal.slab_start = s_cls->slab_list[s_cls->killing - 1];
    slab_rebal.slab_end   = (char *)slab_rebal.slab_start +
        (s_cls->size * s_cls->perslab);
    slab_rebal.slab_pos   = slab_rebal.slab_start;
    slab_rebal.done       = 0;

    /* Also tells do_item_get to search for items in this slab */
    //��do_item_get�������ȡ��key-value�պþ��Ǹ�src�ж�Ӧ��item��������һЩ���⴦���ο�do_item_get
    slab_rebalance_signal = 2; //Ҫrebalance�߳̽����������ڴ�ҳ�ƶ�  

    if (settings.verbose > 1) {
        fprintf(stderr, "Started a slab rebalance\n");
    }

    pthread_mutex_unlock(&slabs_lock);
    pthread_mutex_unlock(&cache_lock);

    STATS_LOCK();
    stats.slab_reassign_running = true;
    STATS_UNLOCK();

    return 0;
}

enum move_status {
    MOVE_PASS=0, 
    MOVE_DONE, //���item����ɹ�  
    MOVE_BUSY, //��ʱ��������һ��worker�߳��ڹ黹���item  
    MOVE_LOCKED
};

/* refcount == 0 is safe since nobody can incr while cache_lock is held.
 * refcount != 0 is impossible since flags/etc can be modified in other
 * threads. instead, note we found a busy one and bail. logic in do_item_get
 * will prevent busy items from continuing to be busy
 */

/*
slab_rebalance_move����������ȡ�ò��ã���Ϊʵ�ֵĲ����ƶ�(Ǩ��)�����ǰ��ڴ�ҳ�е�itemɾ���ӹ�ϣ���LRU������ɾ����
����������ڴ�ҳ������item����ô�ͻ�slab_rebal.done++����־������ɡ����̺߳���slab_rebalance_thread�У���
��slab_rebal.doneΪ��ͻ����slab_rebalance_finish��������������ڴ�ҳǨ�Ʋ�������һ���ڴ�ҳ��һ��slab class 
ת�Ƶ�����һ��slab class�С�
*/

/*
    �ع�ͷ������rebalance�̡߳�ǰ��˵���Ѿ���ע��Դslab class��һ���ڴ�ҳ����ע��rebalance�߳̾ͻ����
slab_rebalance_move��������������ڴ�ҳǨ�Ʋ�����Դslab class�ϵ��ڴ�ҳ����item�ģ���ô��Ǩ�Ƶ�ʱ����
ô������Щitem�أ�memcached�Ĵ���ʽ�Ǻֱܴ��ģ�ֱ��ɾ����������item����worker�߳���ʹ�ã�rebalance
�߳̾͵���һ�¡�������itemû��worker�߳������ã���ô��ʹ���itemû�й���ʧЧҲ��ֱ��ɾ����
    ��Ϊһ���ڴ�ҳ���ܻ��кܶ��item������memcachedҲ���÷��ڴ���ķ�����ÿ��ֻ����������item(Ĭ��Ϊһ��)����
���أ�slab_rebalance_move��������slab_rebalance_thread�̺߳����ж�ε��ã�ֱ�����������е�item��
*/
static int slab_rebalance_move(void) {
    slabclass_t *s_cls;
    int x;
    int was_busy = 0;//was_busy�ͱ�־���Ƿ���worker�߳��������ڴ�ҳ�е�һ��item
    int refcount = 0;
    enum move_status status = MOVE_PASS;

    pthread_mutex_lock(&cache_lock);
    pthread_mutex_lock(&slabs_lock);

    s_cls = &slabclass[slab_rebal.s_clsid];

    //����start_slab_maintenance_thread�����ж�ȡ������������slab_bulk_check  
    //Ĭ��ֵΪ1.ͬ������Ҳ�ǲ��÷��ڴ���ķ�������һ��ҳ�ϵĶ��item  
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
                    //���it_flags&ITEM_SLABBEDΪ�棬��ô��˵�����item  
                    //������û�з����ȥ�����Ϊ�٣���ô˵�����item������  
                    //��ȥ�ˣ������ڹ黹;�С��ο�do_item_get���������  
                    //�ж���䣬��slab_rebalance_signal��Ϊ�ж��������Ǹ��� 
                    if (it->it_flags & ITEM_SLABBED) {//û�з����ȥ  
                        /* remove from slab freelist */
                        if (s_cls->slots == it) {
                            s_cls->slots = it->next;
                        }
                        if (it->next) it->next->prev = it->prev;
                        if (it->prev) it->prev->next = it->next;
                        s_cls->sl_curr--;
                        status = MOVE_DONE;//���item����ɹ�  
                    } else { //��ʱ��������һ��worker�߳��ڹ黹���item  
                        status = MOVE_BUSY;
                    }
                } else if (refcount == 2) { /* item is linked but not busy */
                    //û��worker�߳��������item  
                    if ((it->it_flags & ITEM_LINKED) != 0) {
                        //ֱ�Ӱ����item�ӹ�ϣ���LRU������ɾ��  
                        do_item_unlink_nolock(it, hv);
                        status = MOVE_DONE;
                    } else { //������worker�߳������������item  
                        /* refcount == 1 + !ITEM_LINKED means the item is being
                         * uploaded to, or was just unlinked but hasn't been freed
                         * yet. Let it bleed off on its own and try again later */
                        status = MOVE_BUSY;
                    }
                } else {
                    if (settings.verbose > 2) {
                        fprintf(stderr, "Slab reassign hit a busy item: refcount: %d (%d -> %d)\n",
                            it->refcount, slab_rebal.s_clsid, slab_rebal.d_clsid);
                    }
                    status = MOVE_BUSY;
                }
                item_trylock_unlock(hold_lock);
            }
        }

        switch (status) {
            case MOVE_DONE:
                it->refcount = 0;//���ü�������  
                it->it_flags = 0;//������������ 
                it->slabs_clsid = 255;
                break;
            case MOVE_BUSY:
                refcount_decr(&it->refcount); //ע������û��break  
            case MOVE_LOCKED:
                slab_rebal.busy_items++;//��¼�Ƿ��в������ϴ����item  
                was_busy++;
                break;
            case MOVE_PASS:
                break;
        }

        //�������ҳ����һ��item  
        slab_rebal.slab_pos = (char *)slab_rebal.slab_pos + s_cls->size;
        if (slab_rebal.slab_pos >= slab_rebal.slab_end) //�����������ҳ 
            break;
    }

    if (slab_rebal.slab_pos >= slab_rebal.slab_end) {//�����������ҳ������item  
        /* Some items were busy, start again from the top */
        if (slab_rebal.busy_items) {//�ڴ����ʱ��������һЩitem(��Ϊ��worker�߳�������)  
            slab_rebal.slab_pos = slab_rebal.slab_start; //��ʱ��Ҫ��ͷ��ɨ��һ�����ҳ  
            slab_rebal.busy_items = 0;
        } else {
            slab_rebal.done++;//��־�Ѿ����������ҳ������item  
        }
    }

    pthread_mutex_unlock(&slabs_lock);
    pthread_mutex_unlock(&cache_lock);

    return was_busy;//���ؼ�¼   was_busy�ͱ�־���Ƿ���worker�߳��������ڴ�ҳ�е�һ��item
}

/*
slab_rebalance_move����������ȡ�ò��ã���Ϊʵ�ֵĲ����ƶ�(Ǩ��)�����ǰ��ڴ�ҳ�е�itemɾ���ӹ�ϣ���LRU������ɾ����
����������ڴ�ҳ������item����ô�ͻ�slab_rebal.done++����־������ɡ����̺߳���slab_rebalance_thread�У���
��slab_rebal.doneΪ��ͻ����slab_rebalance_finish��������������ڴ�ҳǨ�Ʋ�������һ���ڴ�ҳ��һ��slab class 
ת�Ƶ�����һ��slab class�С�
*/
static void slab_rebalance_finish(void) {
    slabclass_t *s_cls;
    slabclass_t *d_cls;

    pthread_mutex_lock(&cache_lock);
    pthread_mutex_lock(&slabs_lock);

    s_cls = &slabclass[slab_rebal.s_clsid];
    d_cls   = &slabclass[slab_rebal.d_clsid];

    /* At this point the stolen slab is completely clear */
    s_cls->slab_list[s_cls->killing - 1] =
        s_cls->slab_list[s_cls->slabs - 1];
    s_cls->slabs--;//Դslab class���ڴ�ҳ����һ  
    s_cls->killing = 0;

    memset(slab_rebal.slab_start, 0, (size_t)settings.item_size_max);

    
    //��slab_rebal.slab_startָ���һ��ҳ�ڴ�������Ŀ��slab class  
    //slab_rebal.slab_startָ���ҳ�Ǵ�Դslab class�еõ��ġ�  
    d_cls->slab_list[d_cls->slabs++] = slab_rebal.slab_start;

    //����Ŀ��slab class��item�ߴ���л������ҳ�����ҽ����ҳ��  
    //�ڴ沢�뵽Ŀ��slab class�Ŀ���item������  
    split_slab_page_into_freelist(slab_rebal.slab_start,
        slab_rebal.d_clsid);

    slab_rebal.done       = 0;
    slab_rebal.s_clsid    = 0;
    slab_rebal.d_clsid    = 0;
    slab_rebal.slab_start = NULL;
    slab_rebal.slab_end   = NULL;
    slab_rebal.slab_pos   = NULL;

    slab_rebalance_signal = 0; //rebalance�߳���ɹ������ٴν�������״̬  

    pthread_mutex_unlock(&slabs_lock);
    pthread_mutex_unlock(&cache_lock);

    STATS_LOCK();
    stats.slab_reassign_running = false;
    stats.slabs_moved++;
    STATS_UNLOCK();

    if (settings.verbose > 1) {
        fprintf(stderr, "finished a slab move\n");
    }
}

/* Return 1 means a decision was reached.
 * Move to its own thread (created/destroyed as needed) once automover is more
 * complex.
 */
//settings.slab_automove=1�͵���slab_automove_decision�ж��Ƿ�Ӧ�ý����ڴ�ҳ�ط��䡣����1��˵��
//��Ҫ�ط����ڴ�ҳ����ʱ����slabs_reassign���д���

/*
//������ѡ����ѱ���ѡ�֣�����Ѳ�����ѡ�֡�����1��ʾ�ɹ�ѡ����λѡ��  
//����0��ʾû��ѡ����Ҫͬʱѡ������ѡ�ֲŷ���1������src������¼��Ѳ�  
//����ѡ�ֵ�id��dst��¼��ѱ���ѡ�ֵ�id  
*/ //slab_maintenance_thread�߳�ѭ����ѡ�ٳ��滻�ͱ��滻slabclass��id�ţ�Ȼ�����ź�������slab_rebalance_thread�߳̽����������滻����
static int slab_automove_decision(int *src, int *dst) {
    static uint64_t evicted_old[POWER_LARGEST]; //�ϴν���ú�����ÿ��slabclass���ߵ�item��
    static unsigned int slab_zeroes[POWER_LARGEST];  
    static unsigned int slab_winner = 0;
    static unsigned int slab_wins   = 0;
    uint64_t evicted_new[POWER_LARGEST]; //���ν���ú�����ÿ��slabclass���ߵ�item��
    uint64_t evicted_diff = 0; //���ν��뱾�������ϴν��뱾������ʱ��ÿ��slabclass���ߵ�item��ֵ����ֵ����0��˵��������ʱ�����ĳ��slabclass��item����
    uint64_t evicted_max  = 0; //���ν��뱾����ʱ����ڣ�����ߵ�item��
    unsigned int highest_slab = 0;//���ν��뱾����ʱ����ڣ�����ߵ�item���������ĸ�slabclass[]��Ӧ��id��
    unsigned int total_pages[POWER_LARGEST];
    int i;
    int source = 0;
    int dest = 0;
    static rel_time_t next_run;

    /* Run less frequently than the slabmove tester. */
    if (current_time >= next_run) { //�������ĵ��ò��ܹ���Ƶ��������10�����һ��  
        next_run = current_time + 10;
    } else {
        return 0;
    }

    item_stats_evictions(evicted_new); //��ȡÿһ��slabclass�ı���item��  
    pthread_mutex_lock(&cache_lock);
    for (i = POWER_SMALLEST; i < power_largest; i++) {
        total_pages[i] = slabclass[i].slabs;
    }
    pthread_mutex_unlock(&cache_lock);

    //��������Ƶ�������ã������д�����˵��  
      
    /* Find a candidate source; something with zero evicts 3+ times */  
    //evicted_old��¼��һ��ʱ��ÿһ��slabclass�ı���item��  
    //evicted_new���¼������ÿһ��slabclass�ı���item��  
    //evicted_diff���ܱ���ĳһ��LRU���б��ߵ�Ƶ���̶�  

    /* Find a candidate source; something with zero evicts 3+ times */
    for (i = POWER_SMALLEST; i < power_largest; i++) {
        evicted_diff = evicted_new[i] - evicted_old[i];
        if (evicted_diff == 0 && total_pages[i] > 2) {
            //evicted_diff����0˵�����slabclassû��item���ߣ�����  
            //����ռ����������slab��        
            slab_zeroes[i]++; //���Ӽ���  

            //���slabclass�Ѿ��������ζ�û�б��߼�¼��˵���ռ��ú�  
            //��ѡ����,��Ѳ�����ѡ��  
            if (source == 0 && slab_zeroes[i] >= 3)
                source = i;
        } else { //��������
            slab_zeroes[i] = 0;
            if (evicted_diff > evicted_max) {
                evicted_max = evicted_diff;
                highest_slab = i;
            }
        }
        evicted_old[i] = evicted_new[i]; //�ѱ��εı�������¼��old�У��´���ִ�иú�����ʱ����бȽ�
    }

    /* Pick a valid destination */
    //ѡ��һ��slabclass�����slabclassҪ����3�ζ��Ǳ������item���Ǹ�slabclass  
    if (slab_winner != 0 && slab_winner == highest_slab) {
        slab_wins++;
        if (slab_wins >= 3) //���slabclass�Ѿ��������γ�Ϊ��ѱ���ѡ����  
            dest = slab_winner;
    } else {
        slab_wins = 1; //��������(��Ȼ������1)  
        slab_winner = highest_slab; //���ε���ѱ���ѡ��  
    }

    if (source && dest) {
        *src = source;
        *dst = dest;
        return 1;
    }
    return 0;
}

/* Slab rebalancer thread.
 * Does not use spinlocks since it is not timing sensitive. Burn less CPU and
 * go to sleep if locks are contended
 */ //�ο�http://blog.csdn.net/luotuo44/article/details/43015129
/*
Ĭ��������ǲ������Զ���⹦�ܵģ���ʹ������memcached��ʱ�������-o slab_reassign�������Զ���⹦����
ȫ�ֱ���settings.slab_automove����(Ĭ��ֵΪ0��0���ǲ�����)�����Ҫ��������������memcached��ʱ�����
slab_automoveѡ����������������Ϊ1����������$memcached -o slab_reassign,slab_automove=1�Ϳ�����
�Զ���⹦�ܡ���ȻҲ�ǿ���������memcached��ͨ���ͻ�����������automove���ܣ�ʹ������slabsautomove <0|1>��
����0��ʾ�ر�automove��1��ʾ����automove���ͻ��˵��������ֻ�Ǽ򵥵�����settings.slab_automove��ֵ��
���������κι�����
*/
//automove�̻߳��Զ�����Ƿ���Ҫ�����ڴ�ҳ�ط��䡣�����⵽��Ҫ�ط��䣬��ô�ͻ��rebalance�߳�ִ������ڴ�ҳ�ط��乤����
static void *slab_maintenance_thread(void *arg) { //automove�߳���Ҫ֪��ÿһ���ߴ��item�ı��������Ȼ���ж���һ��item��Դ��ȱ����һ��item��Դ�ֹ�ʣ��
    int src, dest;
    //slab_maintenance_thread�߳�ѭ����ѡ�ٳ��滻�ͱ��滻slabclass��id�ţ�Ȼ�����ź�������slab_rebalance_thread�߳̽����������滻����

    while (do_run_slab_thread) { //Ĭ��Ϊ1  
        if (settings.slab_automove == 1) {
            if (slab_automove_decision(&src, &dest) == 1) {
                /* һ������������û�б���item�ˣ�����һ�������������ζ���Ϊ��ѱ����֡�����ҵ�������
                ����������ѡ�֣���ô����1����ʱautomove�߳̾ͻ����slabs_reassign������ */
                /* Blind to the return codes. It will retry on its own */
                slabs_reassign(src, dest);
            }
            sleep(1);
        } else { //�ȴ��û�����automove  
            /* Don't wake as often if we're not enabled.
             * This is lazier than setting up a condition right now. */
            sleep(5);
        }
    }
    return NULL;
}

/* Slab mover thread.
 * Sits waiting for a condition to jump off and shovel some memory about
 */ //slab_maintenance_thread�߳�ѭ����ѡ�ٳ��滻�ͱ��滻slabclass��id�ţ�Ȼ�����ź�������slab_rebalance_thread�߳̽����������滻����
static void *slab_rebalance_thread(void *arg) {
    int was_busy = 0;
    /* So we first pass into cond_wait with the mutex held */
    mutex_lock(&slabs_rebalance_lock);

    while (do_run_slab_rebalance_thread) {
        if (slab_rebalance_signal == 1) { //do_slabs_reassignѡ��Դ��Ŀ�ĺ�����1,����
            //��־Ҫ�ƶ����ڴ�ҳ����Ϣ������slab_rebalance_signal��ֵΪ2  
            //slab_rebal.done��ֵΪ0����ʾû�����  
            if (slab_rebalance_start() < 0) {
                /* Handle errors with more specifity as required. */
                slab_rebalance_signal = 0;
            }

            was_busy = 0;
        } else if (slab_rebalance_signal && slab_rebal.slab_start != NULL) {
            was_busy = slab_rebalance_move(); //�����ڴ�ҳǨ�Ʋ���  
        }

        if (slab_rebal.done) {
            slab_rebalance_finish();//����ڴ�ҳ�ط������  
        } else if (was_busy) {//��worker�߳���ʹ���ڴ�ҳ�ϵ�item  
            /* Stuck waiting for some items to unlock, so slow down a bit
             * to give them a chance to free up */
            usleep(50);//����һ������ȴ�worker�̷߳���ʹ��item��Ȼ���ٴγ���  
        }

        if (slab_rebalance_signal == 0) { //һ��ʼ������������  
            //�ȴ�do_slabs_reassignѡ��Դ��Ŀ�ĺ�������
            /* always hold this lock while we're running */
            pthread_cond_wait(&slab_rebalance_cond, &slabs_rebalance_lock);
        }
    }
    return NULL;
}

/* Iterate at most once through the slab classes and pick a "random" source.
 * I like this better than calling rand() since rand() is slow enough that we
 * can just check all of the classes once instead.
 *///ѡ��һ���ڴ�ҳ������1��slab class�����Ҹ�slab class������dst  
//ָ�����Ǹ������������������slab class����ô����-1  
static int slabs_reassign_pick_any(int dst) { //�����slabclass[]��ѡ��һ��slabs������1��
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

//�����Զ�automove���ܻ��߽��ܿͻ���slabs reassign�����ʱ����ߵ�����
static enum reassign_result_type do_slabs_reassign(int src, int dst) {
    if (slab_rebalance_signal != 0)
        return REASSIGN_RUNNING;

    if (src == dst) //������ͬ  
        return REASSIGN_SRC_DST_SAME;

    /* Special indicator to choose ourselves. */
    if (src == -1) { 
        //�ͻ�������Ҫ�����ѡ��һ��Դslab class  ֻ����slabs reassign <source class> <dest class>��ָ��srcΪ-1��ʱ��Ż����������
        //ѡ��һ��ҳ������1��slab class�����Ҹ�slab class������dstָ�����Ǹ������������������slab class����ô����-1  
        src = slabs_reassign_pick_any(dst);
        /* TODO: If we end up back at -1, return a new error type */
    }

    if (src < POWER_SMALLEST || src > power_largest ||
        dst < POWER_SMALLEST || dst > power_largest)
        return REASSIGN_BADCLASS;

    if (slabclass[src].slabs < 2) //Դslab classû�л���ֻ��һ���ڴ�ҳ����ô�Ͳ��ָܷ����slab class  
        return REASSIGN_NOSPARE;

    //ȫ�ֱ���slab_rebal  
    slab_rebal.s_clsid = src;//����Դslab class  
    slab_rebal.d_clsid = dst;//����Ŀ��slab class  

    slab_rebalance_signal = 1;
     //����slab_rebalance_thread�������߳�.  
    //��slabs_reassign�������Ѿ�������slabs_rebalance_lock  
    pthread_cond_signal(&slab_rebalance_cond);

    return REASSIGN_OK;
}

//����slab�ط������
enum reassign_result_type slabs_reassign(int src, int dst) {
    enum reassign_result_type ret;
    if (pthread_mutex_trylock(&slabs_rebalance_lock) != 0) {
        return REASSIGN_RUNNING;
    }
    ret = do_slabs_reassign(src, dst);
    pthread_mutex_unlock(&slabs_rebalance_lock);
    return ret;
}

/* If we hold this lock, rebalancer can't wake up or move */
void slabs_rebalancer_pause(void) {
    pthread_mutex_lock(&slabs_rebalance_lock);
}

void slabs_rebalancer_resume(void) {
    pthread_mutex_unlock(&slabs_rebalance_lock);
}

static pthread_t maintenance_tid;
static pthread_t rebalance_tid;

/*
    ����������һ���龰����һ��ʼ������ҵ��ԭ����memcached�洢��������Ϊ1KB�����ݣ�Ҳ����˵memcached����������
�����кܶ��СΪ1KB��item����������ҵ�������Ҫ�洢����10KB�����ݣ����Һ���ʹ��1KB����Щ�����ˡ���������Խ
��Խ�࣬�ڴ濪ʼ�Խ�����СΪ10KB����ЩitemƵ�����ʣ����������ڴ治����Ҫʹ��LRU��̭һЩ10KB��item��
����������龰���᲻����ô���1KB��itemʵ��̫�˷��ˡ����ں��ٷ�����Щitem�����Լ�ʹ���ǳ�ʱ�����ˣ����ǻ�
ռ���Ź�ϣ���LRU���С�LRU���л��ã���ͬ��С��itemʹ�ò�ͬ��LRU���С������ڹ�ϣ����˵�����Ľ�ʬitem������
��ϣ��ͻ�Ŀ����ԣ�������Ǩ�ƹ�ϣ���ʱ��Ҳ�˷�ʱ�䡣��û�а취�ɵ���Щitem��ʹ��LRU����+lru_crawler������
����ǿ�Ƹɵ���Щ��ʬitem�����ɵ���Щ��ʬitem������ռ�ݵ��ڴ��ǹ黹��1KB����Щslab�������С�1KB��slab��
��������Ϊ10KB��item�����ڴ档���Ի��ǹ���һ��

    ����û�б�İ취�أ����еġ�memcached�ṩ��slab automove �� rebalance���������������������ܵġ���Ĭ��
����£�memcached������������ܣ�����Ҫ��ʹ��������ܱ���������memcached��ʱ����ϲ���-o slab_reassign��
֮��Ϳ����ڿͻ��˷�������slabs reassign <source class> <dest class>���ֶ���source class���ڴ�ҳ�ָ�dest 
class�����Ļ�����������Ϊ�ڴ�ҳ�ط��䡣������slabs automove������memcached�Զ�����Ƿ���Ҫ�����ڴ�ҳ�ط��䣬
    �����Ҫ�Ļ����Զ�ȥ����������һ�ж�����Ҫ�˹��ĸ�Ԥ��
���������memcached��ʱ��ʹ���˲���-o slab_reassign����ô�ͻ��settings.slab_reassign��ֵΪtrue(�ñ�����Ĭ��ֵΪfalse)��
���ǵá�slab�ڴ��������˵����ÿһ���ڴ�ҳ�Ĵ�С����do_slabs_newslab�����У�һ���ڴ�ҳ�Ĵ�С�����
settings.slab_reassign�Ƿ�Ϊtrue����ͬ��
 //�ο�http://blog.csdn.net/luotuo44/article/details/43015129

*/ // main���������start_slab_maintenance_thread��������rebalance�̺߳�automove�̡߳�main��������settings.slab_reassignΪtrueʱ�Ż���õġ�
int start_slab_maintenance_thread(void) { //��main�������ã����settings.slab_reassignΪfalse��������ñ�����(Ĭ����false)  
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

    //slab_maintenance_thread�߳�ѭ����ѡ�ٳ��滻�ͱ��滻slabclass��id�ţ�Ȼ�����ź�������slab_rebalance_thread�߳̽����������滻����
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
}

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
