#include<stdio.h>
int main(void)
{
	int arr[]={1,2,3,4,5,6,7,8,9};
	int begin=0,end=0,num=0;
	printf("输入要查找的数:");
	scanf("%d",&num);
	for(begin=0,end=8;arr[(begin+end)/2]!=num;)
	{
		if(arr[(begin+end)/2]>num)
			end=(begin+end)/2-1;
		else if(arr[(begin+end)/2]<num)
			begin=(begin+end)/2+1;
		if(begin==end) break;
	}
	if(arr[(begin+end)/2]!=num)
		printf("没找到\n");
	else
		printf("%d\n",num);
	return 0;
}
