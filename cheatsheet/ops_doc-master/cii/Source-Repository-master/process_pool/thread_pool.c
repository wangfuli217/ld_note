#include "typedef.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<pthread.h>
#include"semi_generic_lqueue.h"
#include"process_pool.h"
#include "debug.h"


//添加文件描述符
void pool_add_task(int sockfd){
	task_t task;
	task.fcn=pfcn;
	task.arg=arg;

	in_lqueue(Q,&task);
	pthread_cond_signal(&cond);	//添加了一个任务，用signal更好
}

//创建进程池
void create_pool(int processNum){
	
}


