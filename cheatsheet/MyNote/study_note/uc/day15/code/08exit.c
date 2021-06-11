#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
void *print(void *p)
{
    int i=1;
	for(i=1;i<=100;i++)
	{
		if(i==10)
			pthread_exit((void*)i);
		printf("子线程中:%d\n",i);
	}
}
int main(void)
{
	pthread_t tid=0;
	pthread_create(&tid,NULL,print,NULL);
	int res=0;
	pthread_join(tid,(void**)&res);
	printf("主线程中:%d\n",res);
	return 0;
}
