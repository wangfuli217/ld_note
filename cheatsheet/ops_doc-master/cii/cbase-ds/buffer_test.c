/**
 * File: buffer_test.c
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#include <buffer.h>
#include <log.h>
#include <systime.h>
#include <stdio.h>
#include <string.h>

static inline void print_buffer(struct buffer *b)
{
	log_info("buffer %p datalen %ld freelen %ld data '%.*s'", b,
		 b->tail - b->data, b->end - b->tail, b->tail - b->data, b->data);
}

int main()
{
	struct pool *pool;
	struct list_head head = LIST_HEAD_INIT(head);
	struct buffer *b, *b1, *b2;
	int i;

	update_pid();
	update_sys_time();
	set_log_level(LOG_DEBUG);

	pool = pool_create(BUFFER_POOL_SIZE(20));
	if (!pool)
		return 1;

	b = buffer_create(20, pool);
	if (!b)
		return 1;
	list_add_tail(&b->list, &head);
	print_buffer(b);

	for (i = 0; i < 16; i++) {
		char c = 'a' + i;
		memcpy(b->tail++, &c, 1);
		log_info("append %c to buffer %p", c, b);
	}
	print_buffer(b);

	b1 = buffer_separate(b, 10);
	if (!b1)
		return 1;
	print_buffer(b);
	print_buffer(b1);

	b2 = buffer_separate(b1, 5);
	if (!b2)
		return 1;
	print_buffer(b1);
	print_buffer(b2);

	for (i = 0; b2->end > b2->tail; i++) {
		char c = 'A' + i;
		memcpy(b2->tail++, &c, 1);
		log_info("append %c to buffer %p", c, b);
	}
	print_buffer(b2);

	buffer_release_chain(&head);
	pool_destroy(pool);
	return 0;
}
