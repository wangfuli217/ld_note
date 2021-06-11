#include<stdio.h>
typedef struct
{
	int row;
	int col;
}pl;
typedef struct
{
	pl pl1;
	pl pl2;
}rect;
int main()
{
	rect re={};
	int midx=0,midy=0;
	printf("请输入两个点的坐标:");
	scanf("%d%d%d%d",&re.pl1.row,&re.pl1.col,&re.pl2.row,&re.pl2.col);
	printf("中间点的坐标是:(%d,%d)\n",(re.pl2.row-re.pl1.row)/2+re.pl1.row,(re.pl2.col-re.pl1.col)/2+re.pl1.col);
	return 0;
}
