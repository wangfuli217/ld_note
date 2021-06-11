#include<stdio.h>
int main()
{
	int arr[10000]={1};
	int i=0,j=0,sum=0;
	int num=0;
	printf("请输入一个数:");
	scanf("%d",&num);
	for(i=2;i<=num;i++)
	{
		sum=0;
		for(j=0;j<10000;j++)
		{
			sum+=arr[j]*i;
			arr[j]=sum%10;
			sum/=10;
		}
	}
	for(i=9999;arr[i]==0;i--);
	for(;i>=0;i--)
		printf("%d",arr[i]);
	printf("\n");
	return 0;
}
