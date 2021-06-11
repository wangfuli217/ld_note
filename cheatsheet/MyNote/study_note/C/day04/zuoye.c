#include<stdio.h>
int main()
{
	int year=0;
	printf("请输入年份:");
	scanf("%d",&year);
	if(year%400==0||(year%4==0&&year%100!=0))
		printf("是闰年\n");
	else 
		printf("不是闰年\n");
	return 0;
}
