/*
   宏存储区演示
   */
#include<stdio.h>
//#define VAR(n) {int n;}
#define ABS(n)  n=0-n
void myabs( int* p_num)
{
	*p_num=0-*p_num;
}
int main()
{
/*	int name=10;
	VAR(name)*/
	int num=0;
	printf("请输入一个数字:");
	scanf("%d",&num);
	ABS(num);
	printf("%d\n",num);
	return 0;
}
