/**
 * File: pool.c
 * Author: ZhuXindi
 * Date: 2017-07-19
 */

#include <pool.h>
#include <log.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

static LIST_HEAD(pools);

void pool_flush(struct pool *pool)
{
	void *next = pool->free_list;

	log_debug("flush pool %p", pool);

	/* free all trunks in free list */
	while (next) {
		void *temp = next;
		log_debug("free trunk %p @pool %p", temp, pool);
		next = *(void **)temp;
		pool->allocated--;
		free(temp);
	}

	pool->free_list = next;
}

static inline void pool_release(struct pool *pool)
{
	if (--pool->refcnt == 0) {
		/* free all unused trunks */
		pool_flush(pool);

		log_debug("destroy pool %p", pool);
		free(pool);
	}
}

struct pool *pool_destroy(struct pool *pool)
{
	struct pool *retpool = NULL;
	if (pool->refcnt > 1) {
		log_debug("pool %p is still in use", pool);
		retpool = pool;
	}

	list_del(&pool->list);
	pool_release(pool);
	return retpool;
}

void pool_flush_all(void)
{
	struct pool *pool;

	list_for_each_entry(pool, &pools, list)
		pool_flush(pool);
}

static inline void *__pool_alloc(struct pool *pool)
{
	void *ptr;

	/* check limit */
	if (pool->limit && pool->allocated >= pool->limit) {
		log_error("pool %p exceeds the limit %u", pool, pool->limit);
		return NULL;
	}

	/* alloc trunk size */
	ptr = malloc(pool->size);
	if (!ptr) {
		/* flush all pools then retry */
		pool_flush_all();
		ptr = malloc(pool->size);
		if (!ptr) {
			log_error("malloc() error: %s", strerror(errno));
			return NULL;
		}
	}

	pool->allocated++;
	pool->refcnt++;
	log_debug("alloc trunk %p @pool %p", ptr, pool);
	return ptr;
}

void *pool_alloc(struct pool *pool)
{
	void *ptr = pool->free_list;

	if (!ptr)
		return __pool_alloc(pool);

	/* reuse a trunk allocated before */
	pool->free_list = *(void **)pool->free_list;
	pool->refcnt++;
	log_debug("reuse trunk %p @pool %p", ptr, pool);
	return ptr;
}

void pool_free(struct pool *pool, void *ptr)
{
	/* link to free list */
	if (ptr) {
		log_debug("recycle trunk %p @pool %p", ptr, pool);
		*(void **)ptr = (void *)pool->free_list;
		pool->free_list = (void *)ptr;
		pool_release(pool);
	}
}

struct pool *pool_create(size_t size)
{
	const size_t align = sizeof(void *);
	struct pool *pool;

	/* alloc pool struct */
	pool = calloc(1, sizeof(*pool));
	if (!pool) {
		log_error("calloc() error: %s", strerror(errno));
		return NULL;
	}

	/* we need to write a next pointer in each trunk after pool_free,
	 * so we need to adjust the size up to a multiple of align
	 */
	pool->size = ((size + align - 1) & -align);
	pool->refcnt = 1;
	list_add_tail(&pool->list, &pools);

	log_debug("create pool %p size %lu", pool, size);
	return pool;
}
