/*
   二级指针形式参数演示
   */
#include<stdio.h>
typedef struct
{
	int row,col;
}pt;
typedef struct
{
	pt mid;
	int radius;
}circle;
/*const circle *large(const circle *p_cl1,const circle *p_cl2)
{
	return	p_cl1->radius>p_cl1->radius?p_cl1:p_cl2;
}*/
void large(const circle *p_cl1,const circle *p_cl2,circle **pp_larger)
{
	if(p_cl1->radius>p_cl2->radius)
		*pp_larger=(circle *)p_cl1;
	else
		*pp_larger=(circle *)p_cl2;
}
int main()
{
	circle cl1={},cl2={};
    circle *p_cl=NULL;
	printf("请输入第一个圆的位置:");
	scanf("%d%d%d",&cl1.mid.row,&cl1.mid.col,&cl1.radius);
	printf("请输入第二个圆的位置:");
	scanf("%d%d%d",&cl2.mid.row,&cl2.mid.col,&cl2.radius);
	large(&cl1,&cl2,&p_cl);
	printf("比较大的圆是:((%d,%d),%d)\n",p_cl->mid.row,p_cl->mid.col,p_cl->radius);
	return 0;
}
