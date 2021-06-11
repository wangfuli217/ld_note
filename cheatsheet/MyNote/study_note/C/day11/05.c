#include<stdio.h>
#define sub(n1,n2) ((n1)-(n2))
int main()
{
	int num1=0,num2=0;
	printf("请输入两个整数:");
	scanf("%d%d",&num1,&num2);
	printf("差为:%d\n",sub(num1,num2));
	return 0;
}
