#include<stdio.h>
#include<stdlib.h>
typedef struct
{
	int row,col;
}pt;
pt *GetMid(const pt *p_pt1,const pt *p_pt2)
{
	pt *p_mid=(pt *)malloc(sizeof(pt));
	if(!p_mid)
	{
		printf("分配失败\n");
		exit (0);
	}
	p_mid->row=(p_pt1->row+p_pt2->row)/2;
	p_mid->col=(p_pt1->col+p_pt2->col)/2;
	return p_mid;
}
int main()
{
	pt pt1={},pt2={};
	pt *p_mid=NULL;
	printf("请输入两个点的位置:");
	scanf("%d%d%d%d",&pt1.row,&pt1.col,&pt2.row,&pt2.col);
	p_mid=GetMid(&pt1,&pt2);
	printf("中点位置为:(%d,%d)\n",p_mid->row,p_mid->col);
	free(p_mid);
	p_mid=NULL;
	return 0;
}
