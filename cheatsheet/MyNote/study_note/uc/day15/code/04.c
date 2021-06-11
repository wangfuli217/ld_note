#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>
#define PI 3.14
void *task(void *p)
{
	printf("圆的周长是:%g\n",2*PI**(int*)p);
	printf("圆的面积是:%g\n",PI**(int*)p**(int*)p);
}
int main(void)
{
	int *radius=(int *)malloc(sizeof(int));
	*radius=2;
	pthread_t tid=0;
	pthread_create(&tid,NULL,task,radius);
	//使用prhread_join函数进行等待
	pthread_join(tid,NULL);
	free(radius);
	return 0;
}
