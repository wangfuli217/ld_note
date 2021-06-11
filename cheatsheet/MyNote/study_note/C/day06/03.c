#include<stdio.h>
int main()
{
	int num[10]={1,2,3,4,5,6,7,8,9,10};
	int num1[10]={0};
	int i=0;
	for(;i<10;i++)
	{
		num1[i]=num[i];
		printf("%d ",num1[i]);
	}
	printf("\n");
	return 0;
}
