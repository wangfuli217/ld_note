#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int main()
{
	int ran=0,num=0;
	srand(time(0));
	ran=rand()%100+1;
	while(1)
	{
		printf("请输入一个数:");
		scanf("%d",&num);
		if(num>ran) printf("猜大了\n");
		else if(num<ran) printf("猜小了\n");
		else
		{
			printf("猜对了\n");
				break;
		}
	}
	return 0;
}
