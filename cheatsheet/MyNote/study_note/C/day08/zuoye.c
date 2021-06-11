#include<stdio.h>
int Sum(int num)
{
	if(num==1) return 1;
	return Sum(num-1)+num;
}
int main()
{
	int num=0;
	int sum=0;
	scanf("%d",&num);
	sum=Sum(num);
	printf("%d\n",sum);
	return 0;
}
