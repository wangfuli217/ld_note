/*
   calloc函数演示
   */
#include<stdio.h>
#include<stdlib.h>
int main()
{
	int *p_num=(int *)calloc(5,sizeof(int));
	int i=0;
	if(!p_num)
	{
		printf("分配失败\n");
		return 0;
	}
	for(i=0;i<5;i++)
		printf("%d ",*(p_num+i));
	printf("\n");
	free(p_num);
	p_num=NULL;
	return 0;
}
