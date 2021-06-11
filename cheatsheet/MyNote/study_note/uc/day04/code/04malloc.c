#include<stdio.h>
#include<stdlib.h>

int main(void)
{
	int *p1=(int *)malloc(4);
	int *p2=(int *)malloc(4);
	int *p3=(int *)malloc(4);
	int *p4=(int *)malloc(4);
	int *p5=(int *)malloc(4);
	printf("p1=%p,p2=%p,p3=%p,p4=%p,p5=%p\n",p1,p2,p3,p4,p5);
	//破坏多余的12个字节数据
	*p1=1;
	*(p1+1)=2;
	*(p1+2)=3;
	*(p1+3)=4;
	*(p1+4)=5;
	free(p1);
	p1=NULL;
	printf("*p2=%d\n",*p2);
	return 0;
}
