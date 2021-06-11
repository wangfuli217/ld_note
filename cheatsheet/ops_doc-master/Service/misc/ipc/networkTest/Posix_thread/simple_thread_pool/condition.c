/*************************************************************************
	> File Name: condition.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 21 Mar 2016 09:37:32 AM CST
 ************************************************************************/

#include "condition.h"

int condition_init(condition_t *cond)
{
	int ret;
	ret = pthread_cond_init(&cond->pcond,NULL);
	if(ret != 0)
	{
		printf("condition_pcon init error:%s\n",strerror(ret));
		return ret;
	}
	ret = pthread_mutex_init(&cond->pmutex,NULL);
	if(ret != 0)
	{
		printf("condition_pmutex init error:%s\n",strerror(ret));
		return ret;
	}

	return 0;
}

int condition_lock(condition_t *cond)
{
	int ret;
	ret = pthread_mutex_lock(&cond->pmutex);
	if(ret != 0)
	{
		printf("condition_pmutex_lock error %s\n",strerror(ret));
		return ret;
	}
	return 0;
}
int condition_unlock(condition_t * cond)
{
	int ret;
	ret = pthread_mutex_unlock(&cond->pmutex);
	if(ret != 0)
	{
		printf("condition_pmutex_unlock error %s\n",strerror(ret));
		return ret;
	}
	return 0;
}
int condition_wait(condition_t *cond)
{
	int ret;
	pthread_cond_wait(&cond->pcond,&cond->pmutex);
	return 0;
}
int condition_timedwait(condition_t *cond, const struct timespec *abstime)
{
	return  pthread_cond_timedwait(&cond->pcond,&cond->pmutex,abstime);
}
int condition_signal(condition_t *cond)
{
	int ret = pthread_cond_signal(&cond->pcond);
	return ret;
}
int condition_broadcast(condition_t *cond)
{
	pthread_cond_broadcast(&cond->pcond);
	return 0;
}
int condition_destroy(condition_t *cond)
{
	pthread_mutex_destroy(&cond->pmutex);
	pthread_cond_destroy(&cond->pcond);
	return 0;
}

