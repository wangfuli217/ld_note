/*************************************************************************
	> File Name: condition.h
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 21 Mar 2016 09:14:53 AM CST
 ************************************************************************/
#ifndef	CONDITION_H
#define CONDITION_H
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct condition
{
	pthread_mutex_t pmutex;
	pthread_cond_t pcond;
}condition_t;

int condition_init(condition_t *cond);
int condition_lock(condition_t *cond);
int condition_unlock(condition_t * cond);
int condition_wait(condition_t *cond);
int condition_timedwait(condition_t *cond, const struct timespec *abstime);
int condition_signal(condition_t *cond);
int condition_broadcast(condition_t *cond);
int condition_destroy(condition_t *cond);

#endif
