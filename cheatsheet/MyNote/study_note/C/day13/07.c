/*
   二级指针演示
   */
#include<stdio.h>
int main()
{
	char *strs[]={"abc","def","xyz"};
	char **pp_strs=strs;
	int num=0;
	for(num=0;num<3;num++)
	{
		printf("%s\n",strs[num]);
		printf("%s\n",pp_strs[num]);
		printf("%s\n",*(pp_strs+num));
	}
	return 0;
}
