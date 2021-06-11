#include<stdio.h>
#include<time.h>
int main()
{
	int num=0;
	clock_t start=0,finish=0;
	start=clock();
	for(num=0;num<1000;num++)
		printf("1");
	printf("\n");
	finish=clock();
	printf("程序运行时间:%lf\n",(double)(finish-start)/CLOCKS_PER_SEC);
	return 0;
}
