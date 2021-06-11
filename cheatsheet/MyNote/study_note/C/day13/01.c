/*
   结构体演示
   */
#include<stdio.h>
typedef struct
{
	int row,col;
}pt;
void print(const pt *p_a)
{
	printf("(%d,%d)\n",p_a->row,p_a->col);
}
pt * read(pt * p_pt1)
{
	scanf("%d%d",&p_pt1->row,&p_pt1->col);
	return p_pt1;
}
int main()
{
	pt pt1={};
	printf("请输入点的位置:");
	read(&pt1);
	print(&pt1);
	return 0;
}
