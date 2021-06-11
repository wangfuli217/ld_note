#include<stdio.h>
int main()
{
	FILE *p_file=fopen("a.bin","r");
	int arr[5][5]={};
	int i=0,j=0;
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fread(arr,sizeof(int),25,p_file);
	for(i=4;i>=0;i--)
	{
		for(j=0;j<5;j++)
			printf("%3d ",arr[i][j]);
		printf("\n");
	}
	fclose(p_file);
	p_file=NULL;
	return 0;
}
