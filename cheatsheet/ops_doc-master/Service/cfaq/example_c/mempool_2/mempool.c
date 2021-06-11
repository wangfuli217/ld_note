/*********************************************************************
 *
 * License: GPL v2
 *
 * Author:  Wu Honghui(wuhonghui0280@163.com)
 *
 *********************************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <assert.h>
#include <errno.h>

#include "mempool.h"

/* round up size to n * TP_MEMPOOL_ALIGN */
static inline unsigned int tp_mempool_size_round_up(const unsigned int size, const unsigned int align)
{
    return ((size + (align - 1)) &~ (align - 1));
}

tp_mempool_t * tp_mempool_create(const char *name, 
								const unsigned int align_bytes,
								const unsigned int max_bytes,
								const unsigned int init_size, 
								const unsigned int grow_size)
{
    int i = 0;
	unsigned int n_align_bytes = align_bytes;
	unsigned int n_max_bytes = max_bytes;

	if (grow_size <= 0 || init_size <= 0 || NULL == name || align_bytes < 4 || max_bytes < 4)
	{
		return NULL;
	}

	n_align_bytes = align_bytes;

	i = 1;
	while((i * n_align_bytes) < max_bytes)
	{
		i++;
	}
	n_max_bytes = i * n_align_bytes;

    tp_mempool_t *p = (tp_mempool_t *)malloc(sizeof(tp_mempool_t));
	if (!p)
	{
		goto create_failed;
	}

	memset(p, 0, sizeof(tp_mempool_t));
	strncpy(p->name, name, TP_MEMPOOL_NAME_LEN);
	p->name[TP_MEMPOOL_NAME_LEN] = '\0';

	p->magic 		= TP_MEMPOOL_MAGIC;
	p->max_bytes 	= n_max_bytes;
	p->min_bytes 	= n_align_bytes;
	p->align_bytes 	= n_align_bytes;

	p->init_size	= init_size;
    p->grow_size 	= grow_size;

    /* init mempool_free_lists */
	p->mempool_free_lists = (mempool_block_header_t *)malloc((p->max_bytes /p->align_bytes) * sizeof(mempool_block_header_t));
	if (!(p->mempool_free_lists))
	{
		goto create_failed;
	}
    for(i = 0; i < (p->max_bytes /p->align_bytes); ++i)
    {
		mempool_block_header_t *list = p->mempool_free_lists + i;
        
        /* allocate block list when received first request */
		list->block_list_head.unit_size = 0;
		list->block_list_head.block_size = 0;
		list->block_list_head.free_blocks = 0;
		list->block_list_head.first = NULL;
		list->block_list_head.next = &(list->block_list_head);
		list->block_list_head.prev = &(list->block_list_head);

        pthread_spin_init(&(list->lock), PTHREAD_PROCESS_PRIVATE);

        #ifdef __TP_MEMPOOL_DEBUG__
		list->block_list_size = 0;
        list->alloc_count = 0;
        list->free_count = 0;
        list->failed_count = 0;
        #endif
    }

	/* init mempool_large_list */
	p->mempool_large_list = (mempool_large_block_header_t *)malloc(sizeof(mempool_large_block_header_t));
	if (!(p->mempool_large_list))
	{
		goto create_failed;
	}

	p->mempool_large_list->large_block_list_head.next = &(p->mempool_large_list->large_block_list_head);
	p->mempool_large_list->large_block_list_head.prev = &(p->mempool_large_list->large_block_list_head);
	p->mempool_large_list->large_block_list_head.unit_size = 0;
	p->mempool_large_list->large_block_list_head.block_size = 0;
	pthread_spin_init(&(p->mempool_large_list->lock), PTHREAD_PROCESS_PRIVATE);

    #ifdef __TP_MEMPOOL_DEBUG__
	p->mempool_large_list->block_list_size = 0;
	p->mempool_large_list->alloc_count = 0;
	p->mempool_large_list->free_count = 0;
    #endif

    return p;

create_failed:
	if(p)
	{
		if(p->mempool_free_lists)
		{
			free(p->mempool_free_lists);
		}
		if(p->mempool_large_list)
		{
			free(p->mempool_large_list);
		}
		free(p);
	}

	return NULL;
}

/* size have been round up to align size */
static inline void *tp_mempool_small_alloc(tp_mempool_t *pool, unsigned int size)
{
	int index = 0;
	unsigned int magic;
	unsigned int total_size;
	void *p = NULL;
	mempool_block_header_t *block_header;
	mempool_block_t *block_head;
	mempool_block_t *block;

	/* unit total size */
	total_size = sizeof(unsigned int)+ sizeof(void *) + size + sizeof(unsigned int);

	magic = pool->magic;

	index = (size - pool->min_bytes) / pool->align_bytes;
	if(pool->mempool_free_lists != NULL)
    {
        block_header = pool->mempool_free_lists + index;
    }
	else
	{
		return NULL;
	}

	if(!block_header)
	{
		return NULL;
	}

	pthread_spin_lock(&(block_header->lock));

    #ifdef __TP_MEMPOOL_DEBUG__
	block_header->alloc_count++;
    #endif

	block_head =&(block_header->block_list_head);
	block = block_head->next;
	while (block != block_head)
	{
		if (block->free_blocks> 0)
		{
			p = block->first;

			if (*((unsigned int *)(p)) != magic)
			{
				*((unsigned int *)(p)) = magic;
			}

			p = (void *)((char *)p + sizeof(unsigned int));
			block->first = (void *)(*(unsigned int *)p);			
			*((unsigned int *)(p)) = (unsigned int)block;

			p = (void *)((char *)p + sizeof(void *));

			if (*((unsigned int *)((char *)p + size)) != magic)	
			{
				*((unsigned int *)((char *)p + size)) = magic;
			}

			(block->free_blocks)--;
			break;
		}
		else
		{
			block = block->next;
		}
	}

	if (NULL == p) //not more free node in all blocks
	{
		int i = 0;
		unsigned int grow_size;
		unsigned int block_size;
		unsigned int magic_tail_offset;
		void * init_p;
		mempool_block_t * new_block;

		grow_size = pool->grow_size;
		if (block_head->next == block_head)
		{
			grow_size = pool->init_size;
		}

		block_size = sizeof(mempool_block_t) + (grow_size) * total_size;
		new_block = (mempool_block_t *)malloc(block_size);
		if (NULL == new_block)
		{
			perror("can't malloc new block!!!\n");
			return NULL;
		}

		/* init block */
		init_p = (void *)((char *)(new_block) + sizeof(mempool_block_t)); 
		magic_tail_offset = sizeof(unsigned int) + sizeof(void *) + size;
		for(i = 0; i < grow_size - 1; i++) 	// do not init last node in this loop;
		{
			*((unsigned int *)init_p) = magic;
			*((unsigned int *)((char *)init_p + sizeof(unsigned int))) = (unsigned int)((char *)init_p + total_size);
			*((unsigned int *)((char *)init_p + magic_tail_offset)) = magic;

			init_p = (void *)((char *)init_p + total_size);
		}

		*((unsigned int *)init_p) = magic;
		*((unsigned int *)((char *)init_p + sizeof(unsigned int))) = 0; //NULL
		*((unsigned int *)((char *)init_p + magic_tail_offset)) = magic;

		new_block->unit_size = size;
		new_block->free_blocks = grow_size;
		new_block->block_size = block_size;
		new_block->first = (void *)((char *)(new_block) + sizeof(mempool_block_t));

		new_block->next = block_head->next;
		new_block->prev = block_head;
		block_head->next->prev = new_block;
		block_head->next = new_block;

		#ifdef __TP_MEMPOOL_DEBUG__
		block_header->block_list_size++;
		block_header->failed_count++;
		#endif

		p = new_block->first;
		p = (void *)((char *)p + sizeof(unsigned int));
		new_block->first = (void *)(*(unsigned int *)p);

		*((unsigned int *)(p)) = (unsigned int)new_block;
		p = (void *)((char *)p + sizeof(void *));
		(new_block->free_blocks)--;
	}

	pthread_spin_unlock(&(block_header->lock));

	return p;
}

static inline void *tp_mempool_large_alloc(tp_mempool_t *pool, unsigned int size)
{
	void *p = NULL;
	mempool_large_block_header_t *block_header;
	mempool_large_block_t *block_head;
	unsigned int block_size;
	mempool_large_block_t *new_block;

	block_header = pool->mempool_large_list;
	if (!block_header)
	{
		return NULL;
	}

	pthread_spin_lock(&(block_header->lock));

	block_head = &(block_header->large_block_list_head);
	if (!block_head)
	{
		return NULL;
	}

	block_size = sizeof(mempool_large_block_t) + sizeof(unsigned int) + sizeof(void *) + size + sizeof(unsigned int);
	new_block = (mempool_large_block_t *)malloc(block_size);
	if(!new_block)
	{
		perror("can't malloc new block!!!\n");
		return NULL;
	}
	new_block->unit_size = size;
	new_block->block_size = block_size;

	new_block->next = block_head->next;
	new_block->prev = block_head;
	block_head->next =new_block;
	new_block->next->prev = new_block;

	#ifdef __TP_MEMPOOL_DEBUG__
	block_header->block_list_size++;
	block_header->alloc_count++;
	#endif

	p = (void *)((char *)new_block + sizeof(mempool_large_block_t));
	*((unsigned int *)p) = pool->magic;

	p = (void *)((char *)p + sizeof(unsigned int));
	*((unsigned int *)p) = (unsigned int)(new_block);

	p = (void *)((char *)p + sizeof(void *));
	*((unsigned int *)((char *)p + size)) = pool->magic;

	pthread_spin_unlock(&(block_header->lock));

	return p;
}


void *tp_mempool_alloc(tp_mempool_t *pool, unsigned int size)
{
	if (!pool || size <= 0 || (int)size <= 0)	//avoid casting (int) to (unsigned int)
	{
		return NULL;
	}

	unsigned int request_size = tp_mempool_size_round_up(size, pool->align_bytes);

	if (request_size > pool->max_bytes)
	{
		return tp_mempool_large_alloc(pool, request_size);
	}
	else
	{
		return tp_mempool_small_alloc(pool, request_size);
	}
}

static inline int tp_mempool_small_free(tp_mempool_t *pool, void *p, unsigned int size)
{
	int index;	
	mempool_block_t *block;
	mempool_block_header_t *block_header;

	index = (size - pool->min_bytes) / pool->align_bytes;
	block = (mempool_block_t *)(*(unsigned int *)((char *)p + sizeof(unsigned int)));
	block_header = pool->mempool_free_lists + index;

	if(NULL != block_header)
	{
		pthread_spin_lock(&(block_header->lock));

		#ifdef __TP_MEMPOOL_DEBUG__
		block_header->free_count++;
		#endif

		*(unsigned int *)((char *)p + sizeof(unsigned int)) = (unsigned int)(block->first);
		block->first = p;
		block->free_blocks++;

		// TODO: shrink the pool.
		pthread_spin_unlock(&(block_header->lock));
	}

	return 0;
}

static inline int tp_mempool_large_free(tp_mempool_t *pool, void *p)
{
	mempool_large_block_header_t *block_header = pool->mempool_large_list;

	if(NULL != block_header)
	{
		pthread_spin_lock(&(block_header->lock));

		mempool_large_block_t *block = (mempool_large_block_t *)(*(unsigned int *)((char *)p + sizeof(unsigned int)));

		block->prev->next = block->next;
		block->next->prev = block->prev;

        #ifdef __TP_MEMPOOL_DEBUG__
		block_header->block_list_size--;
		block_header->free_count++;
		#endif

		free(block);

		pthread_spin_unlock(&(block_header->lock));
	}

	return 0;
}


/*   Trying to free a pointer to a address which is already 
 * freed by destory func may cause undefined behavior. 
 *   That is to say, do not free a pointer p after destory 
 * func is called.
 * TODO: set a free lock in pool?
 */
int tp_mempool_free(tp_mempool_t *pool, void *p)
{
	if(!p || !pool)
	{
		return -1;
	}

	p = (void *)((char *)p - sizeof(void *) - sizeof(unsigned int));
	if(*((unsigned int *)p) != pool->magic)
	{
		printf("Head magic damaged.");
		assert(0);
		return 0;
	}

	unsigned int size = *(unsigned int *)(*(unsigned int *)((char *)p + sizeof(unsigned int)));

	if(*((unsigned int *)((char *)p + sizeof(void *) + sizeof(unsigned int) + size)) != pool->magic)
	{
		printf("Tail magic damaged. size: %d\n", size);
		assert(0);
		return 0;
	}

	if (size > pool->max_bytes)
	{
		return tp_mempool_large_free(pool, p);
	}
	else
	{
		return tp_mempool_small_free(pool, p, size);
	}

}

int tp_mempool_destory(tp_mempool_t *pool)
{
	if (!pool)
	{
		return -1;
	}

	int i = 0;
	/*******************************************************************
	now free memory block and block head.
	*******************************************************************/
	mempool_block_header_t *block_header = NULL;
	mempool_block_t *block_head = NULL;
	mempool_block_t *block = NULL;
	mempool_block_t *block_to_free = NULL;
	for(i = 0; i < (pool->max_bytes /pool->align_bytes); ++i)
	{
		block_header = pool->mempool_free_lists + i;
		if (block_header)
		{
			pthread_spin_lock(&(block_header->lock));

			#ifdef __TP_MEMPOOL_DEBUG__
			if (block_header->alloc_count != block_header->free_count)
			{
				printf("pool free list %d: alloc count(%d) != free_count(%d)!!!\n", i, 
					block_header->alloc_count, block_header->free_count);
			}
			#endif

			block_head = &(block_header->block_list_head);
			block = block_head->next;

			while(block != block_head)
			{
				#ifdef __TP_MEMPOOL_DEBUG__
				if (block->free_blocks != pool->grow_size && block->free_blocks != pool->init_size)
				{
					printf("\tblock has %d * (%d bytes) mem not free.\n", 
						pool->grow_size - block->free_blocks, block->unit_size);
					// tp_mempool_show_block(block);
				}
				#endif

				block_to_free = block;
				block = block->next;

				block_to_free->next->prev = block_to_free->prev;
				block_to_free->prev->next = block_to_free->next;

				free((void *)block_to_free);

				#ifdef __TP_MEMPOOL_DEBUG__
				block_header->block_list_size--;
				#endif
			}

			pthread_spin_unlock(&(block_header->lock)); // TODO: do not unlock to prevent alloc now?
		}
	}

	free((void *)pool->mempool_free_lists);


	mempool_large_block_header_t *large_block_header = NULL;
	mempool_large_block_t *large_block = NULL;
	mempool_large_block_t *large_block_head = NULL;
	mempool_large_block_t *large_block_to_free = NULL;

	large_block_header = pool->mempool_large_list;
	if(NULL != large_block_header)
	{
		pthread_spin_lock(&(large_block_header->lock));

		#ifdef __TP_MEMPOOL_DEBUG__
		if (large_block_header->alloc_count != large_block_header->free_count)
		{
			printf("pool large block list: alloc count(%d) != free_count(%d)!!!\n", 
				large_block_header->alloc_count, large_block_header->free_count);
		}
		#endif

		large_block_head = &(large_block_header->large_block_list_head);
		large_block = large_block_head->next;

		while(large_block != large_block_head)
		{
			#ifdef __TP_MEMPOOL_DEBUG__
			printf("\tlarge block not free!!(size: %d bytes)\n", large_block->unit_size);
			#endif

			large_block_to_free = large_block;
			large_block = large_block->next;

			large_block_to_free->next->prev = large_block_to_free->prev;
			large_block_to_free->prev->next = large_block_to_free->next;

			free((void *)large_block_to_free);
		}
		pthread_spin_unlock(&(large_block_header->lock)); // TODO: do not unlock to prevent alloc now?

		free((void *)large_block_header);
	}

	/*******************************************************************
	now free pool structure.
	*******************************************************************/
	free(pool);

	return 0;
}

void tp_mempool_show_block(mempool_block_t *block)
{
	if(!block)
	{
		return;
	}
	// TODO: show block details, used node, unused node.
	printf("\t\tblock size:%d, free:%d\n", block->block_size, block->free_blocks);
}

void tp_mempool_show_free_list(mempool_block_header_t *header)
{
	if(!header)
	{
		return;
	}

	pthread_spin_lock(&(header->lock));

	#ifdef __TP_MEMPOOL_DEBUG__
	printf("Block count %d, alloc:%d, free:%d, failed:%d\n", 
		header->block_list_size, header->alloc_count,
		header->free_count, header->failed_count);
    #endif

	mempool_block_t *block_head = &(header->block_list_head);
	mempool_block_t *block = block_head->next;

	while(block != block_head)
	{
		tp_mempool_show_block(block);
		block = block->next;
	}

	pthread_spin_unlock(&(header->lock));
}

void tp_mempool_show_large_list(mempool_large_block_header_t *large_list_header)
{
	if(!large_list_header)
	{
		return;
	}
	pthread_spin_lock(&(large_list_header->lock));

#ifdef __TP_MEMPOOL_DEBUG__
	printf("Large pool:block count %d, alloc count:%d, free count:%d\n", 
		large_list_header->block_list_size, large_list_header->alloc_count, large_list_header->free_count);
#endif

	mempool_large_block_t *block_head = &(large_list_header->large_block_list_head);
	mempool_large_block_t *block = block_head->next;

	while(block != block_head)
	{
		// TODO: show more details
		printf("\tblock alloc size:%d\n", block->unit_size);
		block = block->next;
	}

	pthread_spin_unlock(&(large_list_header->lock));
}

void tp_mempool_show(tp_mempool_t *pool)
{
	if(!pool)
	{
		return;
	}

	printf("Pool: %s\n", pool->name);
	printf("\tfree lists:%d, min bytes:%d, max bytes:%d, align bytes:%d\n", 
		pool->max_bytes/pool->align_bytes, pool->min_bytes, pool->max_bytes, pool->align_bytes);

	int i;
	for(i = 0; i < (pool->max_bytes /pool->align_bytes); ++i)
	{
		printf("List %d:", i);
		tp_mempool_show_free_list(pool->mempool_free_lists + i);
	}

	tp_mempool_show_large_list(pool->mempool_large_list);
}
