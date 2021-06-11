/*
   fread函数演示
   */
#include<stdio.h>
int main()
{
	FILE *p_file=fopen("a.bin","r");
	int arr[5]={};
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fread(arr,sizeof(int),5,p_file);
	for(int i=0;i<5;i++)
		printf("%d ",arr[i]);
	printf("\n");
	fclose(p_file);
	p_file=NULL;
	return 0;
}
