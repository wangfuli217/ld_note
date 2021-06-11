#include<stdio.h>
int main()
{
	int *p_num,*p_num1,*p_num2;
	printf("请输入三个整数:");
	scanf("%d%d%d",p_num,p_num1,p_num2);
	if(*p_num<*p_num1)
		*p_num=*p_num1;
	if(*p_num<*p_num2);
		*p_num=*p_num2;
	printf("最大值是%d\n",*p_num);
	return 0;
}
