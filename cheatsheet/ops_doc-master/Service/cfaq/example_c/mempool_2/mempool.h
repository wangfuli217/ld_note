/*********************************************************************
 *
 * License: GPL v2
 *
 * Author:  Wu Honghui(wuhonghui0280@163.com)
 *
 *********************************************************************/

#ifndef __MEMPOOL_H_
#define __MEMPOOL_H_

#include <sys/types.h>
#include <pthread.h>

#define __TP_MEMPOOL_DEBUG__

//#define TP_MEMPOOL_ALIGN 		((unsigned int)16)
//#define TP_MEMPOOL_MIN_BYTES	((unsigned int)TP_MEMPOOL_ALIGN) 	//WARNING: TP_MEMPOOL_MIN_BYTES = TP_MEMPOOL_ALIGN is strongly recommanded.
//#define TP_MEMPOOL_MAX_BYTES	((unsigned int)1024)
//#define TP_NR_FREE_LISTS 		((unsigned int)(TP_MEMPOOL_MAX_BYTES/TP_MEMPOOL_ALIGN)) /* pool item size: 8 ~ 16 * 8 */

//#define TP_MEMPOOL_INIT_SIZE 	((unsigned int)40) /* node count in init block */
//#define TP_MEMPOOL_GROW_SIZE 	((unsigned int)20) /* node count in grow blocks*/

#define TP_MEMPOOL_NAME_LEN 	20

#define TP_MEMPOOL_MAGIC 		((unsigned int)0xABCDABCD)

/* inside every node memory model: 
     |---------------|-------------|----------------------|---------------|
     |- 4byte magic -|- 4byte ptr -|- data...data...data -|- 4byte magic -| 
     |---------------|-------------|----------------------|---------------|
   magic: check error;
   ptr: point to next node when in pool, point to its block when out of pool;
*/

typedef struct mempool_block_s
{
	unsigned int unit_size;  		/* unit size in this block WARNING: first member.*/
    unsigned int block_size;       	/* block size */
    unsigned int free_blocks;       /* free node count */
	struct mempool_block_s *next;
	struct mempool_block_s *prev;
    void *first;     /* first free node in this block */
}mempool_block_t;

typedef struct mempool_block_header_s
{
    struct mempool_block_s block_list_head;    /* memory block in this pool */

    /* multi-thread safe */
    pthread_spinlock_t lock;

    #ifdef __TP_MEMPOOL_DEBUG__
	unsigned int block_list_size;
    unsigned int alloc_count;
    unsigned int free_count;
    unsigned int failed_count;
    #endif
}mempool_block_header_t;

typedef struct mempool_large_block_s
{
	unsigned int unit_size;		/* data_size, warning: first member. */ 
	unsigned int block_size;		/* block size */
    struct mempool_large_block_s *prev;
    struct mempool_large_block_s *next;
}mempool_large_block_t;

typedef struct mempool_large_block_header_s
{
    struct mempool_large_block_s large_block_list_head;

    pthread_spinlock_t lock;

	#ifdef __TP_MEMPOOL_DEBUG__
	unsigned int block_list_size;
	unsigned int alloc_count;
	unsigned int free_count;
	#endif
}mempool_large_block_header_t;

typedef struct tp_mempool_s
{
    struct mempool_block_header_s *mempool_free_lists;
    struct mempool_large_block_header_s *mempool_large_list;

	char name[TP_MEMPOOL_NAME_LEN + 1];

	unsigned int magic;
	unsigned int max_bytes;
	unsigned int min_bytes;
	unsigned int align_bytes;	/* 2^n */
	unsigned int align_offset;	/* n */

	unsigned int init_size;		/* pool init size */
    unsigned int grow_size;  	/* pool grow size */
    #ifdef __TP_MEMPOOL_DEBUG__
    #endif
}tp_mempool_t;

tp_mempool_t * tp_mempool_create(const char *name, 
								const unsigned int align_bytes,
								const unsigned int max_bytes,
								const unsigned int init_size, 
								const unsigned int grow_size);



void *tp_mempool_alloc(tp_mempool_t *pool, unsigned int size);

/*   Trying to free a pointer to a address which is already 
 * freed by destory func may cause undefined behavior. 
 *   That is to say, do not free a pointer p after destory 
 * func is called.
 */
int tp_mempool_free(tp_mempool_t *pool, void *p);


/*   Destory a memory pool, After destory, an attempt 
 * to free a pointer p may cause undefined behavior.
 */
int tp_mempool_destory(tp_mempool_t *pool);

void tp_mempool_show(tp_mempool_t *pool);

#endif /* __MEMPOOL_H_ */