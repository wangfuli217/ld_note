#include<stdio.h>
int main()
{
	int size=0,num=0;
	printf("请输入一个整数:");
	scanf("%d",&size);
	int arr[size];
	for(num=0;num<size;num++)
	{
		arr[num]=num+1;
		printf("%d ",arr[num]);
	}
	printf("\n");
	return 0;
}
