/*
   函数声明演示
   */
#include<stdio.h>
#include<stdlib.h>
double add(double,double);
int main()
{
	double num=add(3.4f,40.3f);
	exit(876);
	printf("%lg\n",num);
	return 0;
}
double add(double num,double num1)
{
	return num+num1;
}
