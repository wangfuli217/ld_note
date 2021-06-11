#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int a[10]={};
	int i=0,j=0;
	srand(time(0));
	for(i=0;i<10;i++)
	{
		p:	a[i]=rand()%36+1;
		for(j=i-1;j>=0;j--)
			if(a[i]==a[j])
				goto p;
		printf("%d ",a[i]);
	}
	printf("\n");
	return 0;
}
