#include<stdio.h>
int JieChen(int num)
{
	if(num==1) return 1;
	return JieChen(num-1)*num;
}
int main()
{
	int num=0,ji=0;
	scanf("%d",&num);
	ji=JieChen(num);
	printf("%d\n",ji);
	return 0;
}

