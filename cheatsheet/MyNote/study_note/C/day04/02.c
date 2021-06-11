#include<stdio.h>
int main()
{
	int nu1=0,nu2=0,nu3=0;
	printf("请输入三个整数:");
	scanf("%d%d%d",&nu1,&nu2,&nu3);
	printf("三个数中最大的数为:%d\n",(nu1>nu2?nu1:nu2)>nu3?(nu1>nu2?nu1:nu2):nu3);
	return 0;
}
