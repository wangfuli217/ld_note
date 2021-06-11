#include<stdio.h>
#include<stdlib.h>
typedef struct
{
	int row,col;
}pt;
int main()
{
	pt *p_num=(pt *)malloc(5*sizeof(pt));
	if(!p_num)
	{
		printf("分配失败\n");
		return 0;
	}
	int i=0;
	printf("请输入五个点的坐标:");
	for(i=0;i<5;i++)
		scanf("%d%d",&(p_num+i)->row,&(p_num+i)->col);
	for(i=4;i>=0;i--)
		printf("(%d,%d) ",(p_num+i)->row,(p_num+i)->col);
	printf("\n");
	free(p_num);
	p_num=NULL;
	return 0;
}
