/**
 * File: pool_test.c
 * Author: ZhuXindi
 * Date: 2013-07-11
 */

#include <pool.h>
#include <log.h>
#include <systime.h>

int main()
{
	struct pool *pool;
	void *ptr;

	update_pid();
	update_sys_time();
	set_log_level(LOG_DEBUG);

	pool = pool_create(4);

	ptr = pool_alloc(pool);

	pool_destroy(pool);

	pool_free(pool, ptr);
	return 0;
}
