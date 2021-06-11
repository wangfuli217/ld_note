#include<stdio.h>
void swap(int *a,int *b)
{
	int temp=*a;
	*a=*b;
	*b=temp;
}
int  perm(int *a,int begin,int end)
{
	static int num=0;
	if(begin==end)
	{
		num++;
		for(int i=0;i<=end;i++)
			printf("%d ",*(a+i));
		printf("\n");
		return num;
	}
	else
	{
		for(int j=begin;j<=end;j++)
		{
			swap(a+j,a+begin);
			perm(a,begin+1,end);
			swap(a+j,a+begin);
		}
	}
	return num;
}
int main()
{
	int arr[5]={1,2,3,4,5};
	printf("%d\n",perm(arr,1,4));
	return 0;
}
