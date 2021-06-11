#include<stdio.h>
int main()
{
	int arr[]={1,2,3,4,5,6,7,8,9,10};
	int num=0,i=0,j=0;
	printf("请输入一个整数:");
	scanf("%d",&num);
	for(i=0;i<10;i++)
		if(arr[i]==num)
		{
			for(;i<9;i++)
			arr[i]=arr[i+1];
			break;
		}
	j=i;
	for(i=0;i<9;i++)
		printf("%d ",arr[i]);
	if(j==10)
		printf("%d",arr[9]);
	printf("\n");
	return 0;
}
