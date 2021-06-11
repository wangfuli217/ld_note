#include<stdio.h>
#include<stdlib.h>
typedef struct
{
	int row,col;
}pt;
pt *GetMide(const pt *p_1,const pt *p_2,pt  *p_pt)
{
	p_pt=(pt *)malloc(sizeof(pt));
	p_pt->row=(p_1->row+p_2->row)/2;
	p_pt->col=(p_1->col+p_2->col)/2;
	return p_pt;
}
int main()
{
	pt pt1={},pt2={};
	pt *p_pt=NULL;
	printf("请输入两个点的坐标:");
	scanf("%d%d%d%d",&pt1.row,&pt1.col,&pt2.row,&pt2.col);
	p_pt=GetMide(&pt1,&pt2,p_pt);
	printf("中点坐标是:(%d,%d)\n",p_pt->row,p_pt->col);
	return 0;
}
