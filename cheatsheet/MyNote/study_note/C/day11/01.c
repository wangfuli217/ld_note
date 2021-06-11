/*
   指针数组演示
   */
#include<stdio.h>
int main()
{
	char *strs[5]={"123","234","345","456","567"};
	int i=0;
	for(;i<5;i++)
		printf("%s\n",strs[i]);
	return 0;
}
