/*
   宏演示
   */
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int arr[SIZE]={};
	int i=0;
	srand(time(0));
	for(i=0;i<SIZE;i++)
		arr[i]=rand()%NUM+1;
	for(i=0;i<SIZE;i++)
		printf("%d ",arr[i]);
	printf("\n");
	return 0;
}
