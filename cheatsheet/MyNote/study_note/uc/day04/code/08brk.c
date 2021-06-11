//brk函数的使用
#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
int main(void)
{
	//使用brk函数申请内存
	void *p=sbrk(0);
	printf("p=%p\n",p);
	int res=brk(p+4);
	if(-1==res)
		perror("brk"),exit(-1);
	void *cur=sbrk(0);
	printf("cur=%p\n",cur);
	brk(p+8);
	cur=sbrk(0);
	printf("cur=%p\n",cur);
	brk(p+4);
	cur=sbrk(0);
	printf("cur=%p\n",cur);
	return 0;
}
