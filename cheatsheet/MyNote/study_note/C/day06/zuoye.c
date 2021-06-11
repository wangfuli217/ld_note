#include<stdio.h>
int main()
{
	int num=0,arr[10]={0},i=0;
	printf("请输入一个非负整数:");
	scanf("%d",&num);
	do
	{
		arr[num%10]++;
		num/=10;
	}while(num);
	for(i=0;i<10;i++)
		if(arr[i])
			printf("%d出现%d次\n",i,arr[i]);
	return 0;
}
