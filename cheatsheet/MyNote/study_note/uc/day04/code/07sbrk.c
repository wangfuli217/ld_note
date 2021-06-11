//sbrk函数的使用
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>

int main(void)
{
	//申请4个字节的动态内存
	void *p1=sbrk(4);
	void *p2=sbrk(4);
	void *p3=sbrk(4);
	printf("p1=%p,p2=%p,p3=%p\n",p1,p2,p3);
	printf("----------------------------------\n");
	void *cur=sbrk(0);             //获取内存块当前的末尾位置+1
	printf("cur=%p\n",cur);           //p3+4
	//释放4个字节的内存空间
	void *p4=sbrk(-4);
	printf("pr=%p\n",p4);			//cur
	cur=sbrk(0);
	printf("cur=%p\n",cur);          //p3
	sbrk(-4);
	printf("------------------------------------\n");
	printf("当前进程PID:%d\n",getpid());
	printf("目前进程有4个字节\n");
	getchar();
	sbrk(4093);
	printf("申请了4093个字节的内存，恰好超过了1个内存页\n");
	getchar();
	sbrk(-1);
	printf("释放了1个字节的内存，回到了1个内存页的范围\n");
	getchar();
	return 0;
}
