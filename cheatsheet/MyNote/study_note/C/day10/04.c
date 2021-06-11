#include<stdio.h>
#include<string.h>
int main()
{
	char a[3];
	memset(a,'1',3);
	printf("%d %d %d\n",a[0],a[1],a[2]);
	return 0;
}
