/*************************************************************************
	> File Name: pipe_test.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Wed 23 Mar 2016 04:10:57 PM CST
 ************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#define MY_MAX_SIZE (100)
void * proutnie(void *)
{
	return NULL;
}
int main()
{
	int pipesfd[2];
	int rslt =0;
	pthread_t tid;
	char buf[MY_MAX_SIZE+1]={0};

	memset(buf,0,MY_MAX_SIZE+1);
	while(fgets(buf,MY_MAX_SIZE,stdin) != NULL)
	{
		
	}


	return 0;
}

