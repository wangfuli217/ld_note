/*************************************************************************
	> File Name: simple_thread_pool.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 21 Mar 2016 10:14:28 AM CST
 ************************************************************************/

#include "thread_pool.h"
void thread_pool_init(thread_pool_t *pool,int max_threads)
{
	pool->front = pool->rear = NULL;
	pool->cur_threads = pool->idle_threads = 0;
	pool->destroy = 0;
	pool->max_threads = max_threads;
	condition_init(&pool->ready);

}
void * thread_routine(void * arg)
{
	int timedout=0;
	int rslt;
	struct timespec abstime;
	thread_pool_t * pool;
	task_t * task_ptr;
	pool = (thread_pool_t *) arg;
	printf("thread 0x%x is starting\n",(int)pthread_self());
	while(1)
	{
		condition_lock(&pool->ready);
		//printf("***********************\n");
		//等待队列中任务到来或线程池销毁通知
		pool->idle_threads++;
		while(pool->front == NULL && !pool->destroy)
		{
			clock_gettime(CLOCK_REALTIME,&abstime);
			abstime.tv_sec += 1;
			
			printf("thread 0x%x is waiting %ld\n",(int)pthread_self(),abstime.tv_sec);
		   //condition_wait(&pool->ready);//该语句一直等待，不能够使得线程超时后自动退出
		   //利下面语句可以使得线程超时自动退出
		   rslt = condition_timedwait(&pool->ready,&abstime);
		  // printf("%d = xxtimeout rslt = %d\n",timedout,rslt);
		   if(rslt == ETIMEDOUT)
		   {
			   timedout =1;
			   printf("%d = timeout 0000001\n",timedout);

			   break;
		   }
		}
		pool->idle_threads--;
		//等待到新任务到来,无论收未到销毁通知，先执行完得到的任务
		if(pool->front != NULL )
		{
			task_ptr = pool->front;
			pool->front = pool->front->next;
			condition_unlock(&pool->ready);//执行任务需要时间,之前一定要先解锁,以便能够添加新任务
			
			task_ptr->run(task_ptr->arg);
			free(task_ptr);
			condition_lock(&pool->ready);//重新上锁
		}
		

		
		//等待到进程池销毁状态,并且在任务执行期间无新任务到达
		if(pool->destroy == 1 && pool->front == NULL)
		{
			pool->cur_threads--;
			if(pool->cur_threads == 0)
			{
				condition_signal(&pool->ready);
			}

			fprintf(stdout,"thread 0x%x exiting\n",pthread_self());
			condition_unlock(&pool->ready);//重新解锁
			break;//跳出循环while(1)

		}

		if(timedout == 1 && pool->front == NULL)
		{

			fprintf(stdout,"thread 0x%x timeout\n",pthread_self());
			pool->cur_threads--;
			if(pool->cur_threads == 0)//线程等待超时也要，减少当前进程数量
			{
				condition_signal(&pool->ready);
			}

			fprintf(stdout,"thread 0x%x exiting\n",pthread_self());
			condition_unlock(&pool->ready);
			break;//break while(1)
		}
		condition_unlock(&pool->ready);//重新解锁
	}
	return NULL;
}
void thread_pool_add_task(thread_pool_t *pool,void *(*run)(void *arg),void *arg)
{
	/*
	if(pool->cur_threads >= pool->max_threads)
	{
		printf("task add failed due to reaching max_threads\n");
		return ;
	}
	*/
	task_t *newtask;
	int rslt =0;
	pthread_t tid;
	newtask = (task_t *) malloc(sizeof(task_t));
	if(newtask == NULL)
	{
		printf("new task errror\n");
		return;
	}
	newtask->run = run;
	newtask->arg = arg;
	newtask->next = NULL;
	condition_lock(&pool->ready);//互斥访问线程池
	//将任务插入任务对列
	if(pool->front == NULL)
	{
		pool->front = newtask;
	}
	else
	{
		pool->rear->next = newtask;
	}
	pool->rear = newtask;
	

	if(pool->idle_threads > 0)//有空闲线程等待信号
	{
		condition_signal(&pool->ready);
	}
	else if(pool->cur_threads < pool->max_threads)
	{
		//如果没有空闲线程，且线程池的线程数量未达到最大数量,则创建新线程
		rslt  = pthread_create(&tid,NULL,thread_routine,(void *)pool);
		if(rslt !=0)
		{
			printf("pthread_create error :%s\n",strerror(rslt));
		}
		else
		{
			pool->cur_threads++;
		}
	
	}
	//else
	//{

		//printf("task add failed due to reaching max_threads\n");

	//}

	condition_unlock(&pool->ready);
	

}
void thread_pool_destroy(thread_pool_t *pool)
{

	if(pool->destroy)
	{
		return ;
	}
	condition_lock(&pool->ready);
	pool->destroy = 1;
	if(pool->cur_threads > 0)
	{
		//广播条件信号给所有空闲的线程
		if(pool->idle_threads >0)
		{
			condition_broadcast(&pool->ready);
		}
		//处于正在执行任务的线程，不会受到广播
		//线程池需要等待执行任务状态中的线程全部退出
		while(pool->cur_threads > 0)
		{
			printf("detroy is waiting\n");
			condition_wait(&pool->ready);
		}
		
	}
	condition_unlock(&pool->ready);
	condition_destroy(&pool->ready);

}
