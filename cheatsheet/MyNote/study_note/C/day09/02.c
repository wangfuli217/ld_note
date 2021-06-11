#include<stdio.h>
int main()
{
	int *p_num=NULL,*p_num1=NULL;
	int num=0,num1=0;
	p_num=&num;
	p_num1=&num1;
	printf("%d %d\n",*p_num,*p_num1);
	return 0;
}
