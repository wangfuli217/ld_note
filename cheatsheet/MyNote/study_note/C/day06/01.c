#include<stdio.h>
int main()
{
	int num=0,num1=0;
	printf("请输入一个数字:");
	scanf("%d",&num);
	scanf("%*[^\n]%*c");
//	scanf("%*c");
	printf("num是%d\n",num);
	printf("请再输入一个数字:");
	scanf("%d",&num1);
	printf("num1是%d\n",num1);
	return 0;
}
