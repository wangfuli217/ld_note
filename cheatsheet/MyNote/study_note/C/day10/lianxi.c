#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main()
{
	char ranks[50]={};
	char rank[10]={};
	char *p_ch=NULL;
	int num=0;
	int sum=0;
	while(1)
	{
		printf("请输入一个成绩:");
		scanf("%d",&num);
		if(num<=0)
			break;
		sprintf(rank,"%d",num);
		strcat(ranks,rank);
		strcat(ranks,",");
	}
	ranks[strlen(ranks)-1]=0;
	printf("字符串是:%s\n",ranks);
	p_ch=ranks;
	while(1)
	{
		sum+=atoi(p_ch);
		p_ch=strstr(p_ch,",");
		if(!p_ch)
			break;
		p_ch++;
	}
	printf("总和是:%d\n",sum);
	return 0;
}
