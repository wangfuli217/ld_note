#include<stdio.h>
#include<time.h>
#include<stdlib.h>
int GetCai(int *num)
{
	int i=0;
	for(i=0;i<7;i++)
		*(num+i)=rand()%36+1;
}
int main()
{
	int num[7]={};
	int i=0;
	srand(time(0));
	GetCai(num);
	for(i=0;i<7;i++)
		printf("%d ",i[num]);
	printf("\n");
	return 0;
}
