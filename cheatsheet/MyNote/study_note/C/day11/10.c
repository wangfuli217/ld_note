#include<stdio.h>
int main()
{
	int num=0;
	printf("请输入一个数字(1.小龙虾 2.小鸡炖蘑菇):");
	scanf("%d",&num);
#ifdef ZHAO
	if(num==1)	printf("对不起，没有\n");
	if(num==2)	printf("这个真没有\n");
#else
	if(num==1) printf("好的，有龙虾\n");
	if(num==2) printf("这个没有\n");
#endif
	return 0;
}
