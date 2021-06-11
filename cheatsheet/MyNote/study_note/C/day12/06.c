#include<stdio.h>
#include<math.h>
typedef struct
{
	int row;
	int row1;
	int col;
	int col1;
}xd;
int main()
{
	xd xd1={},xd2={};
	printf("请输入线段一左右两点的坐标:");
	scanf("%d%d%d%d",&xd1.row,&xd1.col,&xd1.row1,&xd1.col1);
	printf("请输入线段二左右两点的坐标:");
	scanf("%d%d%d%d",&xd2.row,&xd2.col,&xd2.row1,&xd2.col1);
	printf("较长线段的坐标是:");
	if(pow(xd1.row1-xd1.row,2)+pow(xd1.col1-xd1.col,2)>pow(xd2.row1-xd2.row,2)+pow(xd2.col1-xd2.col,2))
		printf("((%d %d),(%d %d))\n",xd1.row,xd1.col,xd1.row1,xd1.col1);
	else
		printf("((%d %d),(%d %d))\n",xd2.row,xd2.col,xd2.row1,xd2.col1);
	return 0;
}
