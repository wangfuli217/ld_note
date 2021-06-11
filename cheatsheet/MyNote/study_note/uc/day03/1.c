#include<stdio.h>
#include<stdlib.h>
#include<time.h>
int ran(void)
{
	int num=rand()%10+1;
	if(num==5)
		return -1;
	return num;
}
int max(int num1,int num2,int *num)
{
	if(num1==num2)
		return -1;
	*num=num1>num2?num1:num2;
	return 0;
}
char *stri(const char *str)
{
	if(!strcmp(str,"error"))
		return "error";
	return "ok";
}
void print(const char *str)
{
	printf("%s",str);
}
int main(void)
{
	srand(time(0));
	int num=ran();
	if(num==-1)
		printf("num等于5,返回错误\n");
	else
		printf("num是%d\n",num);
	int num1=max(-1,-1,&num);
	if(num1==-1)
		printf("相等，返回错误\n");
	else
		printf("最大值是:%d\n",num);
	char *str=stri("error");
	printf("%s\n",str);
	print("slkdjflksdjfl\n");
	return 0;
}
