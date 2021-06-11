#include<stdio.h>
int main()
{
	int arr[5];  //数组声明
	/*printf("arr[2]是%d\n",arr[2]);*/
	for(int i=4;i>=0;i--)
	{
		arr[i]=i+1;
		printf("%d ",arr[i]);
	}
	printf("\n");
	return 0;
}
