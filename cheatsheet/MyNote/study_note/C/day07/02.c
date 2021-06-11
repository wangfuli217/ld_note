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
