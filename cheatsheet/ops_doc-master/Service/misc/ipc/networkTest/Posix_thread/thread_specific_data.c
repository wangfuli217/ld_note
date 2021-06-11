/*************************************************************************
	> File Name: thread_specific_data.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Thu 10 Mar 2016 09:46:39 AM CST
 ************************************************************************/
#define _REENTRANT
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
pthread_key_t key1;//the global key
void key1_destructor(void * value)
{
	int *v_ptr = (int *)value;
	printf("the value is %d\n",*v_ptr);
	free(v_ptr);
	printf("distory value ...\n");
}
void * t1_routine(void *arg)
{
	char *ptr;	
	ptr = (char *)malloc(sizeof(char));
	*ptr = 'a';
	if(pthread_setspecific(key1,ptr) != 0)
	{
		pthread_exit("t1_routine setspecific error");
	}
	
	printf("thread1---ptr addr = %p, getspecific addr =%p\n",ptr,pthread_getspecific(key1));
	ptr = (char *) pthread_getspecific(key1);
	*ptr = 'b';
	printf("thread1_ptr_data is %c\n",*ptr);
	return "I am thread1";
}
void * t2_routine(void *arg)
{
	int *ptr;
	*(int*)arg = 2;
	printf("t2_routine malloc value =%d\n",*(int *)arg);
	free(arg);
	//specific data test
	ptr = (int *)malloc(sizeof(int));
	*ptr = 2;
	pthread_setspecific(key1,ptr);
	printf("thread2---ptr addr = %p, getspecific addr =%p\n",ptr,pthread_getspecific(key1));

	
	return "I am thread2";
}
int main(int argc ,char *argv[])
{
	pthread_t thread1,thread2;
	int rslt;
	char *ret_ptr;
	int share_data=0;
	rslt=pthread_key_create(&key1,key1_destructor);
	if(rslt != 0)
	{
		fprintf(stdout,"key_create error\n");
		exit(EXIT_FAILURE);
	}

//	rslt = pthread_create(&pthread1,NULL,t1_routine,(void *)&share_data);
//该方式会引起，脏数据因为所有的子线程都有可能修改share_data,出现race condition问题,需要利用互斥和同步机制,而且可移植性差
	rslt = pthread_create(&thread1,NULL,t1_routine,(void *)share_data);//可移植性差，但无脏数据		
	if(rslt != 0)
	{
		fprintf(stdout,"pthread_create1 error\n");
		exit(EXIT_FAILURE);

	}
	rslt = pthread_create(&thread2,NULL,t2_routine,malloc(sizeof(int)));//可移植性差，但无脏数据		
	if(rslt != 0)
	{
		fprintf(stdout,"pthread_create2 error\n");
		exit(EXIT_FAILURE);

	}	

	pthread_join(thread1,(void *)&ret_ptr);
	printf("return from thread1: %s\n",ret_ptr);
	pthread_join(thread2,(void *)&ret_ptr);
	printf("return from thread2: %s\n",ret_ptr);

	return 0;
}
