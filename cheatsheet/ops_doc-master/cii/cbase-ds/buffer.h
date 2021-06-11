/**
 * File: buffer.h
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#ifndef _BUFFER_H
#define _BUFFER_H

#include <pool.h>
#include <list.h>
#include <stdlib.h>

struct buffer {
	/* head  data  tail   end
	 *   |-----|-----|-----|
	 */
	char *head, *data, *tail, *end;	/* position pointers */
	struct buffer *parent;	/* if separated from another buffer */
	unsigned int refcnt;	/* ref counter */
	struct list_head list;	/* join with other buffers into a chain */
	struct pool *pool;
};

#define BUFFER_POOL_SIZE(bufsize) ((bufsize) + sizeof(struct buffer))

/* allocate a buffer contains bufsize bytes at most */
struct buffer *buffer_create(size_t bufsize, struct pool *pool);

/* separate a buffer into two parts at postion n, return the tail part */
struct buffer *buffer_separate(struct buffer *b, size_t n);

/* release a single buffer */
void buffer_release(struct buffer *b);

/* release all buffers in the chain */
static inline void buffer_release_chain(struct list_head *chain)
{
	struct buffer *b, *n;

	list_for_each_entry_safe(b, n, chain, list)
		buffer_release(b);
}

#endif /* _BUFFER_H */
