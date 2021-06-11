#include<stdio.h>
int main()
{
	int arr[]={1,10,2,9,3,8,4,7,5,6};
	int i=0,j=0;
	int temp=0;
	int num=0;
	for(i=1;i<10;i++)
		for(j=0;j<=i-1;j++)
			if(arr[i]>arr[j])
			{
				temp=arr[i];
				for(num=i;num>j;num--)
					arr[num]=arr[num-1];
				arr[j]=temp;
				break;
			}
	for(i=0;i<10;i++)
		printf("%d ",arr[i]);
	printf("\n");
	return 0;
}
