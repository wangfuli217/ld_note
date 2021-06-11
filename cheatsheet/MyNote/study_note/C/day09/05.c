#include<stdio.h>
int main()
{
	int num=10;
	const int *p_num=&num;
	*p_num=20;
	return 0;
}
