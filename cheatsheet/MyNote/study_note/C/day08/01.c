/*
   形式参数演示
   */
#include<stdio.h>
void print(int num,int num1)
{
	printf("%d %d\n",num,num1);
}
int main()
{
	int num=0,num1=0;
	printf("请输入两个数:");
	scanf("%d%d",&num,&num1);
	print(num,num1);
	return 0;
}
