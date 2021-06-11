/*************************************************************************
	> File Name: atoftest.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Wed 07 Feb 2018 05:17:46 PM CST
 ************************************************************************/

#include<stdio.h>

#include <stdlib.h>

int main(int argc,char *argv[])
{
	double d;
	d = atof("36028797018964123");
	printf("%lf\n",d);
	 char *end;
	 d = strtod("36028797018964123", &end);
	 printf("%lf\n",d);
	 d = 36028797018964123.0;
	 printf("%lf\n",d);
	return 0;
}
