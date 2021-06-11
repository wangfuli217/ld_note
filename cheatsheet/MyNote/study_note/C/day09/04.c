#include<stdio.h>
void swap(int *p_num,int *p_num1)
{
	*p_num+=*p_num1;
	*p_num1=*p_num-*p_num1;
	*p_num-=*p_num1;
}
int main()
{
	int num=0,num1=0,*p_num=&num,*p_num1=&num1;
	scanf("%d%d",p_num,p_num1);
	swap(p_num,p_num1);
	printf("%d %d\n",*p_num,*p_num1);
	return 0;
}
