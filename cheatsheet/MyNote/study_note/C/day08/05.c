#include<stdio.h>
int Add(int sum,int num)
{
	return num+sum;
}
int main()
{
	int num=0,i=0;
	int num1=0;
	int sum=0;
	printf("请输入您要输入的整数个数:");
	scanf("%d",&num);
	printf("请输入每个整数的值:");
	for(i=0;i<num;i++)
	{
		scanf("%d",&num1);
		sum=Add(sum,num1);
	}
	printf("和为%d\n",sum);
	return 0;
}
