#include<stdio.h>
/*
   数组名称演示
   */
#include<stdio.h>
int main()
{
	int arr[5]={};
	int arr1[2][3]={};
//	printf("arr是%p,&arr[0]是%p\n",arr,&arr[0]);
//	printf("arr1是%p,arr1[0]是%p,&arr1[0][0]是%p\n",arr1,arr1[0],&arr1[0][0]);
	printf("arr1是%p,&arr1[1][0]是%p\n",arr1,&arr1[1][0]);
	return 0;
}
int main()
{
	int arr1[3][3]={0},arr2[3][3]={0},arr3[3][3]={0};
	int i=0,j=0,m=1,p=0,sum=0;
	for(i=0;i<3;i++)
		for(j=0;j<3;j++)
			arr1[i][j]=arr2[i][j]=m++;
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
		{
			sum=m=p=0;
			sum+=arr1[i][m++]*arr2[p++][j];
			sum+=arr1[i][m++]*arr2[p++][j];
			sum+=arr1[i][m++]*arr2[p++][j];
			arr3[i][j]=sum;
		}
	}
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
			printf("%3d ",arr3[i][j]);
			printf("\n");
	}
	return 0;
}
