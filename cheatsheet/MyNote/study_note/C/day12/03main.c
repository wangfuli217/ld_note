#include<stdio.h>
#include"getnum.h"
#include"printnum.h"
int main()
{
	int num=0;
	getnum(&num);
	printnum(num);
	return 0;
}
