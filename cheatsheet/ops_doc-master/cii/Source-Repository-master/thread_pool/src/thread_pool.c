#include "typedef.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<pthread.h>
#include"semi_generic_lqueue.h"
#include"thread_pool.h"
#include "debug.h"

//互斥量和条件变量
pthread_mutex_t lock;
pthread_cond_t cond;

//全局的表
PtLQu_t Q;

//每个线程的任务
static void* do_task(void* p){
	task_t task;
	int ret=0;
	while(1){
		pthread_mutex_lock(&lock);
		while(is_empty_lqueue(Q)){				//大家收到广播，因为延迟，可能醒了好几个，要判断一下是不是自己
			pthread_cond_wait(&cond,&lock);		//先抢到锁再醒
		}
		ret=out_lqueue(Q,&task);
		pthread_mutex_unlock(&lock);
		task.fcn(task.arg);
	}
}
//添加任务
void pool_add_task(void*(*pfcn)(void*parg),void*arg){
	task_t task;
	task.fcn=pfcn;
	task.arg=arg;

	in_lqueue(Q,&task);
	pthread_cond_signal(&cond);	//添加了一个任务，用signal更好
}

//创建线程池
void create_pool(int dataSize,UdFreeNode_t free_node,UdShowNode_t show_node){
	//初始化队列
	Q=create_lqueue(dataSize,free_node,show_node);
	//初始化互斥量
	pthread_mutex_init(&lock,NULL);
	//初始化条件变量
	pthread_cond_init(&cond,NULL);
	int i=THREAD_NUM;
	pthread_t tid[THREAD_NUM];
	while(i--)
		pthread_create(&tid[i],NULL,do_task,NULL);
}


