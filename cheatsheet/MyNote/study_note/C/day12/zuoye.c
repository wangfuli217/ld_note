#include<stdio.h>
#include<string.h>
#define PI 3.14f
typedef struct
{
	float radius;
	int cx;
	int cy;
	float area;
	float peri;
	char connet[5];
}circle;
int main()
{
	circle cir={};
	int row=0,col=0;
	printf("请输入圆心的坐标和圆的半径:");
	scanf("%d%d%f",&cir.cx,&cir.cy,&cir.radius);
	printf("请输入某个点的坐标:");
	scanf("%d%d",&row,&col);
	if(((row-cir.cx)*(row-cir.cx)+(col-cir.cy)*(col-cir.cy))>cir.radius*cir.radius)
		strcpy(cir.connet,"圆外");
	else if(((row-cir.cx)*(row-cir.cx)+(col-cir.cy)*(col-cir.cy))==cir.radius*cir.radius)
		strcpy(cir.connet,"圆上");
	else
		strcpy(cir.connet,"圆内");
	cir.area=PI*cir.radius*cir.radius;
	cir.peri=2*PI*cir.radius;
	printf("圆的面积是:%g,周长是:%g\n",cir.area,cir.peri);
	printf("此点在%s\n",cir.connet);
	return 0;
}
