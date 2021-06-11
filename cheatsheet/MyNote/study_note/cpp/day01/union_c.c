#include<stdio.h>
int main(void)
{
	int n=0x12345678;
	char *p=(char*)&n;
	printf("%#x %#x %#x %#x\n",p[0],p[1],p[2],p[3]);
	return 0;
}
