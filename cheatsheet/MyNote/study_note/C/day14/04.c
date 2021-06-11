/*
   动态分配内存演示
   */
#include<stdio.h>
#include<stdlib.h>
int *read(void)
{
	int *p_num=(int *)malloc(sizeof(int));
	if(!p_num)
	{
		printf("分配失败\n");
		exit(0);
	}
	printf("请输入一个整数:");
	scanf("%d",p_num);
	return p_num;
}
int main()
{
	int *p_num=NULL;
	p_num=read();
	printf("%d \n",*p_num);
	free(p_num);
	p_num=NULL;
	return 0;
}
