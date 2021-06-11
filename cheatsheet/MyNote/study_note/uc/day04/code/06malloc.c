//使用malloc和free搭配使用，观察内存变化的效果
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
int main(void)
{
	printf("进程号是%d\n",getpid());
	int *p1=(int*)malloc(4096);
	printf("申请1个内存页的内存后,p1=%p\n",p1);
	getchar();

	int *p2=(int*)malloc(30*4096);
	printf("申请30个内存页之后,p2=%p\n",p2);
	getchar();

	int *p3=(int*)malloc(3*4096);
	printf("申请3个内存页，此时已超过33个内存页,p3=%p\n",p3);
	getchar();

	free(p3);
	p3=NULL;
	printf("释放了3个内存页\n");
	getchar();

	free(p2);
	p2=NULL;
	printf("释放了30个内存页\n");
	getchar();

	free(p1);
	p1=NULL;
	printf("所有内存全部释放\n");
	getchar();
	return 0;
}
