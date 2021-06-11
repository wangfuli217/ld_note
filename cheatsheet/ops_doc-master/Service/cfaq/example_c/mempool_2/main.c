/*********************************************************************
 *
 * License: GPL v2
 *
 * Author:  Wu Honghui(wuhonghui0280@163.com)
 *
 *********************************************************************/
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <time.h>
#include <unistd.h>
#include <sys/time.h>
#include "mempool.h"

tp_mempool_t * pool;

#define pool_align 16
#define pool_max 1024
#define pool_init 400
#define pool_grow 100

static void pool_create()
{
	pool = tp_mempool_create("mypool", pool_align, pool_max, pool_init, pool_grow);
}

static void * pool_alloc(unsigned int size)
{
	return tp_mempool_alloc(pool, size);
}

static int pool_free(void *p)
{
	return tp_mempool_free(pool, p);
}

static void pool_show()
{
	tp_mempool_show(pool);
}

static void pool_destory()
{
	tp_mempool_destory(pool);
}


#define iter_time 	10000000
#define pointer_len 800

void *pool_small_test_thread(void *args)
{
	void * p[pointer_len];
	memset(p, 0, sizeof(p));

	srandom(time(NULL));

	int i;
	int rand;
	int rand_size;

	for(i = 0; i < iter_time; i++) {
		rand = random()% (sizeof(p)/sizeof(void *));
		rand_size = random() % (pool_max + 1);
		if (p[rand] == NULL) {
			p[rand] = pool_alloc(rand_size);
			memset(p[rand], 0, rand_size);
		} else {
			pool_free(p[rand]);
			p[rand] = NULL;
		}
	}

	//free all
	for(i = 0; i < (sizeof(p)/sizeof(void *)); i++) {
		if (p[i]!= NULL) {
			pool_free(p[i]);
			p[i] = NULL;
		}
	}
	
	pthread_exit(0);
}

void *pool_large_test_thread(void *args)
{
	void * p[pointer_len];
	memset(p, 0, sizeof(p));

	srandom(time(NULL));

	int i;
	int rand;
	int rand_size;

	for(i = 0; i < iter_time; i++)
	{
		rand = random()% (sizeof(p)/sizeof(void *));
		rand_size = random() % 1024 + pool_max + 1;
		if (p[rand] == NULL)
		{
			p[rand] = pool_alloc(rand_size);
			memset(p[rand], 0, rand_size);
		}
		else
		{
			pool_free(p[rand]);
			p[rand] = NULL;
		}
	}

	//free all
	for(i = 0; i < (sizeof(p)/sizeof(void *)); i++)
	{
		if (p[i]!= NULL)
		{
			pool_free(p[i]);
			p[i] = NULL;
		}
	}
	pthread_exit(0);
}

void *random_test_thread(void *args)
{
	void * p[pointer_len];
	memset(p, 0, sizeof(p));

	srandom(time(NULL));

	int i;
	int rand;
	int rand_size;

	for(i = 0; i < iter_time; i++)
	{
		rand = random()% (sizeof(p)/sizeof(void *));
		rand_size = random() % 1024 + pool_max + 1;
	}

	pthread_exit(0);
}


void pool_small_test()
{
	pthread_t pool_thread_id1;
	pthread_create(&pool_thread_id1, NULL, pool_small_test_thread, NULL);

	pthread_t pool_thread_id2;
	pthread_create(&pool_thread_id2, NULL, pool_small_test_thread, NULL);

	pthread_t pool_thread_id3;
	pthread_create(&pool_thread_id3, NULL, pool_small_test_thread, NULL);


	pthread_join(pool_thread_id3, NULL);
	pthread_join(pool_thread_id2, NULL);
	pthread_join(pool_thread_id1, NULL);

	pool_show();
}

void pool_large_test()
{
	pthread_t pool_thread_id1;
	pthread_create(&pool_thread_id1, NULL, pool_large_test_thread, NULL);

	pthread_t pool_thread_id2;
	pthread_create(&pool_thread_id2, NULL, pool_large_test_thread, NULL);

	pthread_t pool_thread_id3;
	pthread_create(&pool_thread_id3, NULL, pool_large_test_thread, NULL);

	pthread_join(pool_thread_id1, NULL);
	pthread_join(pool_thread_id2, NULL);
	pthread_join(pool_thread_id3, NULL);

	pool_show();
}

void pool_misc_test()
{
	pthread_t pool_thread_id1;
	pthread_create(&pool_thread_id1, NULL, pool_small_test_thread, NULL);

	pthread_t pool_thread_id2;
	pthread_create(&pool_thread_id2, NULL, pool_small_test_thread, NULL);

	pthread_t pool_thread_id3;
	pthread_create(&pool_thread_id3, NULL, pool_small_test_thread, NULL);

	pthread_t pool_thread_id4;
	pthread_create(&pool_thread_id4, NULL, pool_large_test_thread, NULL);

	pthread_t pool_thread_id5;
	pthread_create(&pool_thread_id5, NULL, pool_large_test_thread, NULL);

	pthread_t pool_thread_id6;
	pthread_create(&pool_thread_id6, NULL, pool_large_test_thread, NULL);

	pthread_join(pool_thread_id6, NULL);
	pthread_join(pool_thread_id5, NULL);
	pthread_join(pool_thread_id4, NULL);	
	pthread_join(pool_thread_id3, NULL);
	pthread_join(pool_thread_id2, NULL);
	pthread_join(pool_thread_id1, NULL);

	pool_show();

}


void *malloc_small_test_thread(void *args)
{
	void * p[pointer_len];
	memset(p, 0, sizeof(p));

	srandom(time(NULL));

	int i;
	int rand;
	int rand_size;

	for(i = 0; i < iter_time; i++)
	{
		rand = random()% (sizeof(p)/sizeof(void *));
		rand_size = random() % 1024 + pool_max + 1;
		if (p[rand] == NULL)
		{
			p[rand] = malloc(rand_size);
			memset(p[rand], 0, rand_size);
		}
		else
		{
			free(p[rand]);
			p[rand] = NULL;
		}
	}

	//free all
	for(i = 0; i < (sizeof(p)/sizeof(void *)); i++)
	{
		if (p[i]!= NULL)
		{
			free(p[i]);
			p[i] = NULL;
		}
	}
	pthread_exit(0);
}


void *malloc_large_test_thread(void *args)
{
	void * p[pointer_len];
	memset(p, 0, sizeof(p));

	srandom(time(NULL));

	int i;
	int rand;
	int rand_size;

	for(i = 0; i < iter_time; i++)
	{
		rand = random()% (sizeof(p)/sizeof(void *));
		rand_size = random() % 1024 + pool_max + 1;
		if (p[rand] == NULL)
		{
			p[rand] = malloc(rand_size);
			memset(p[rand], 0, rand_size);
		}
		else
		{
			free(p[rand]);
			p[rand] = NULL;
		}
	}

	//free all
	for(i = 0; i < (sizeof(p)/sizeof(void *)); i++)
	{
		if (p[i]!= NULL)
		{
			free(p[i]);
			p[i] = NULL;
		}
	}
	pthread_exit(0);
}


void pool_performance_time_cost(void * (*function)(void *), const char *name)
{
	struct timeval tv_start, tv_end;
	float gap = 0.0;

	gettimeofday(&tv_start, NULL);
	pthread_t pool_thread_id6;
	pthread_create(&pool_thread_id6, NULL, function, NULL);
	pthread_join(pool_thread_id6, NULL);
	gettimeofday(&tv_end, NULL);
	gap = tv_end.tv_sec - tv_start.tv_sec;
	gap += (float)(tv_end.tv_usec - tv_start.tv_usec) / (float)(1000000);
	printf("%s cost time: %.6f s.\n", name, gap);
}



int main()
{
	pool_create();

//	pool_large_test();
//	pool_small_test();
//	pool_misc_test();

	pool_performance_time_cost(random_test_thread, "[random gen test]");
	pool_performance_time_cost(pool_small_test_thread, "[pool small test]");
	pool_performance_time_cost(pool_large_test_thread, "[pool large test]");
	pool_performance_time_cost(malloc_small_test_thread, "[malloc small test]");
	pool_performance_time_cost(malloc_large_test_thread, "[malloc large test]");


//	pool_show();

	pool_destory();

    return 0;
}
