/*
   字符串演示
   */
#include<stdio.h>
#include<stdlib.h>
int main()
{
	char str[20]={};
	int num=26;
	char ch='t';
	float fnum=4.7f;
	sprintf(str,"%d %c %g\n",num,ch,fnum);
	sscanf("psldfk,2.4,62","%s,%g,%d",str,&fnum,&num);
	printf("%s %g %d\n",str,fnum,num);
//	printf("%d\n",atoi("4a86"));
//	printf("%lg\n",atof("34.5892837"));
	return 0;
}
