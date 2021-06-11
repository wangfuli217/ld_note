#include<stdio.h>
int main()
{
	int num=0;
	printf("请输入一个1到99之间的整数:");
	scanf("%d",&num);
	for(;num<=100;num++)
		if(num%10==7||num/10==7||num%7==0)
			continue;
		else
			printf("%d ",num);
	printf("\n");
	return 0;
}
