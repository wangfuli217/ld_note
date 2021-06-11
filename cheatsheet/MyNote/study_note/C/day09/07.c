#include<stdio.h>
int main()
{
	int num=10;
	void *p_num=&num;
	printf("%d\n",*(int *)p_num);
	return 0;
}
