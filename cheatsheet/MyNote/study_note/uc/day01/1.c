#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<time.h>
#define MAX 10000
int ss(int num)
{
	int i=1;
	int temp=2;
	while(i<=num-1)
	{
		if(temp>=num)
			temp%=num;
		if(temp!=1)
			return 0;
		i++;
		if(i<=num-1)
			temp*=2;
	}
//	if(temp%num!=1)
//		return 0;
	return 1;
}
int ss1(int num)
{
	int i=0;
	for(i=2;i<=sqrt(num);i++)
		if(num%i==0)
			return 0;
	return 1;
}
int main(void)
{
	int num=0,cnt=1;
	srand(time(0));
	printf("2 ");
	for(num=3;num<=MAX;num++)
	{
		if(ss(num))
		{
			printf("%d ",num);
			cnt++;
		}
	}
//	printf("%d\n",cnt);
	printf("\n");
	return 0;
}
