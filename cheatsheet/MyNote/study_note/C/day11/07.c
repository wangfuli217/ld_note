#include<stdio.h>
#define POW(n) ((n)*(n))
int main()
{
	int num=0;
	printf("请输入一个数:");
	scanf("%d",&num);
	printf("%d\n",POW(++num));
	return 0;
}
