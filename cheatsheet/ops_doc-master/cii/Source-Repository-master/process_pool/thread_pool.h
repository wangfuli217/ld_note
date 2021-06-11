#ifndef __THREAD_POOL_H__
#define __THREAD_POOL_H__

#define THREAD_NUM 10
#define TASK_NUM 100

typedef struct{
	void* (*fcn)(void* arg);
	void* arg;
}task_t;


/* Create a thread pool */
void create_pool(int,UdFreeNode_t,UdShowNode_t);

/* Add a task to the thread pool */
void pool_add_task(void*(*)(void*),void*);

#endif	//__THREAD_POOL_H__






