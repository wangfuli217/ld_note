#include<stdio.h>
#define LENGTH(n)  ((((n).pt2.row-(n).pt1.row)*((n).pt2.row-(n).pt1.row))+(((n).pt2.col-(n).pt1.col)*((n).pt2.col-(n).pt1.col)))
typedef struct
{
	int row,col;
}pt;
typedef struct
{
	pt pt1,pt2;
}rect;
void larger(const rect *p_re1,const rect *p_re2,rect **pp_larger)
{
	*pp_larger=(rect *)(LENGTH(*p_re1)>LENGTH(*p_re2)?p_re1:p_re2);
}
int main()
{
	rect re1={},re2={};
	rect *p_re=NULL;
	printf("请输入长方形一左上角顶点和右下角顶点的坐标:");
	scanf("%d%d%d%d",&re1.pt1.row,&re1.pt1.col,&re1.pt2.row,&re1.pt2.col);
	printf("请输入长方形二左上角顶点和右下角顶点的坐标:");
	scanf("%d%d%d%d",&re2.pt1.row,&re2.pt1.col,&re2.pt2.row,&re2.pt2.col);
	larger(&re1,&re2,&p_re);
	printf("面积较大的长方形是:((%d,%d),(%d,%d))\n",p_re->pt1.row,p_re->pt1.col,p_re->pt2.row,p_re->pt2.col);
	return 0;
}
