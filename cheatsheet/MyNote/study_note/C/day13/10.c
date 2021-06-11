/*
   函数指针演示
   */
#include<stdio.h>
int add(int num,int num1)
{
	return num+num1;
}
int main()
{
	int (*p_add)(int,int)=NULL;
	p_add=add;
	printf("%d\n",p_add(3,7));
	return 0;
}
