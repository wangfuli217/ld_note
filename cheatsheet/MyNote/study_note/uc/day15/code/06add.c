#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
void* add(void *p)
{
	static int sum=0;
	int i=1;
	for(i=1;i<101;i++)
		sum+=i;
	return &sum;
}
int main(void)
{
	pthread_t tid=0;
	int *pi=NULL;
	pthread_create(&tid,NULL,add,NULL);
	pthread_join(tid,(void**)&pi);
	printf("sum=%d\n",*pi);
	pi=NULL;
	return 0;
}
