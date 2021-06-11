#include<stdio.h>
#include<string.h>
#define PI 3.14f
#define LAR(n,n1) ((((n1).row-(n).row)*((n1).row-(n).row))+(((n1).col-(n).col)*((n1).col-(n).col)))
typedef struct
{
	int row,col;
}pt;
typedef struct
{
	pt mid;
	int radius;
}circle;
float area(int radius)
{
	return PI*radius*radius;
}
float zhch(int radius)
{
	return 2*PI*radius;
}
void guanxi(const circle *p_cl,const pt* p_pt,char *conn)
{
	if(LAR(p_cl->mid,*p_pt)>p_cl->radius*p_cl->radius)
		strcpy(conn,"圆外");
	else if(LAR(p_cl->mid,*p_pt)==p_cl->radius*p_cl->radius)
		strcpy(conn,"圆上");
	else
		strcpy(conn,"圆内");
}
int main()
{
	circle cl={};
	pt pt1={};
	char conn[7]={};
	printf("请输入圆心的坐标和圆的半径:");
	scanf("%d%d%d",&cl.mid.row,&cl.mid.col,&cl.radius);
	printf("请输入某个点的坐标:");
	scanf("%d%d",&pt1.row,&pt1.col);
	guanxi(&cl,&pt1,conn);
	printf("这个点在%s\n",conn);
	printf("圆的面积是:%g\n",area(cl.radius));
	printf("圆的周长是:%g\n",zhch(cl.radius));
	return 0;
}
