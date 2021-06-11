#include  "lja_mem.h"
#include  "lja_type.h"
#include  <assert.h>
#include  <malloc.h>
#include  <syslog.h>
#include  <stdlib.h>

u_int64 g_lja_mem_now;             //! 当前分配的内存空间
u_int64 g_lja_mem_his_max;         //! g_lja_mem_now的历史最大值
u_int64 g_lja_mem_max;             //! 内存分配上限, 0表示没有上限
void (*g_lja_mem_no_mem)(const char *);

void lja_mem_init(u_int64 max, void (*no_mem)(const char *))
{
	g_lja_mem_max = max;
	g_lja_mem_now = 0;
	g_lja_mem_his_max = 0;
	g_lja_mem_no_mem = no_mem;
}

void lja_mem_exit()
{
	if(g_lja_mem_now != 0){
		syslog(LOG_ALERT, "退出时g_lja_mem_now不为0，存在内存泄露! %llu \n",g_lja_mem_now);
	}
	syslog(LOG_INFO, "g_lja_mem_his_max %llu \n", g_lja_mem_his_max);
}

void *lja_mem_alloc(u_int64 bytes, const char *func)
{
	assert(bytes > 0);
	void *ptr;

	if(g_lja_mem_max != 0 && g_lja_mem_now + bytes > g_lja_mem_max){
		syslog(LOG_ALERT, "Mem:内存使用超过上限！");
	}

	ptr = malloc(bytes);
	if(ptr == NULL){
		g_lja_mem_no_lja_mem(func);
	}

	g_lja_mem_now += malloc_usable_size(ptr);
	if(g_lja_mem_now > g_lja_mem_his_max){
		g_lja_mem_his_max = g_lja_mem_now;
	}
#ifdef LJA_MEM_DEBUG
	printf("DEBUG lja_mem: alloc %d in %s\n", bytes, func);
#endif
	return ptr;
}

void *lja_mem_calloc(u_int64 count, u_int64 bytes, const char *func)
{
	assert(count>0);
	assert(bytes>0);
	void *ptr;

	if(g_lja_mem_max != 0 && g_lja_mem_now + count*bytes > g_lja_mem_max){
		syslog(LOG_ALERT, "Mem:内存使用超过上限！");
	}

	ptr = calloc(count, bytes);
	if(ptr == NULL){
		g_lja_mem_no_lja_mem(func);
	}

	g_lja_mem_now += malloc_usable_size(ptr);
	if(g_lja_mem_now > g_lja_mem_his_max){
		g_lja_mem_his_max = g_lja_mem_now;
	}
#ifdef LJA_MEM_DEBUG
	printf("DEBUG lja_mem: calloc %d in %s\n", bytes, func);
#endif
	return ptr;
}

void *lja_mem_free(void *ptr, const char *func)
{
	if(ptr != NULL){
		g_lja_mem_now -= malloc_usable_size(ptr);
		free(ptr);
	}
#ifdef LJA_MEM_DEBUG
	printf("DEBUG lja_mem: free in %s\n", func);
#endif
}
