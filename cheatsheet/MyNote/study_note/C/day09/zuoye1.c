#include<stdio.h>
int main()
{
	int a[10]={0};
	int i=0;
	for(i=0;i<10;i++)
		*(a+i)=i;
	for(i=0;i<10;i++)
		printf("%d ",*(a+i));
	printf("\n");
	return 0;
}

