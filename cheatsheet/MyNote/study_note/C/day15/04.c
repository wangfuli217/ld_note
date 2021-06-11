#include<stdio.h>
int main()
{
	int arr[5][5]={};
	int i=0,j=0;
	int p=0;
	for(i=0;i<5;i++)
		for(j=0;j<5;j++)
			arr[i][j]=++p;
	FILE *p_file=fopen("a.bin","w");
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	fwrite(arr,sizeof(int),25,p_file);
	fclose(p_file);
	p_file=NULL;
	return 0;
}
