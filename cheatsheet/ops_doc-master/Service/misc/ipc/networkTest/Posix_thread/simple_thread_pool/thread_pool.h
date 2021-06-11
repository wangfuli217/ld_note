/*************************************************************************
	> File Name: simple_thread_pool.h
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 21 Mar 2016 08:53:20 AM CST
 ************************************************************************/
#ifndef SIMPLE_THREAD_POOL_H
#define SIMPLE_THREAD_POOL_H
#include "condition.h"
//由线程池中的线程来执行的任务的结构体
typedef struct task
{
	void *(*run)(void *arg);
	void *arg;
	struct task *next;
}task_t;

//线程池结构
typedef struct thread_pool
{
	condition_t ready;//任务准备就绪（有新任务）或者线程池销毁通知	
	task_t *front;//任务队头指针
	task_t *rear;//任务队尾指针
	int cur_threads;//线程池中当前总得线程数
	int idle_threads;//线程池中空闲的线程数量
	int destroy;//线程池销毁标志，置1销毁
	int max_threads;//线程池中的最大线程数
}thread_pool_t;

//初始化线程池
void thread_pool_init(thread_pool_t *pool,int max_threads);
//往线程池中添加任务
void thread_pool_add_task(thread_pool_t *pool,void*(*run)(void *arg),void *arg);
//销毁线程池
void thread_pool_destroy(thread_pool_t *pool);
#endif
