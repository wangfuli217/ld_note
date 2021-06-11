#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
void *fa(void *p)
{
	int i=0;
	for(i=0;i<100;i++)
		printf("%d\n",i);
}
int main(void)
{
	pthread_t tid=0;
	pthread_create(&tid,NULL,fa,NULL);
//	fork();
//	usleep(100000);
	int i=0;
	for(i=0;i<100;i++)
		printf("%d\n",i);
	printf("子线程ID是:%lu",tid);
	printf("主线程ID是:%lu",pthread_self());
	return 0;
}
