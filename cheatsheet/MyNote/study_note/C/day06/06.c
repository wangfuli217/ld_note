#include<stdio.h>
int main()
{
	int a[38]={0};
	printf("%d\n",sizeof(a)/sizeof(a[0]));
	return 0;
}
