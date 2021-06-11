#include<stdio.h>
#include<string.h>
void GetPer(FILE *p_file)
{
	int id=0;
	float salary=0.0f;
	char name[20]={};
	scanf("%*[^\n]");
	scanf("%*c");
	printf("请输入人的姓名:");
	fgets(name,20,stdin);
	if(strlen(name)==9&&name[8]!='\n')
	{
		scanf("%*[^\n]");
		scanf("%*c");
	}
	printf("请输入人的id:");
	scanf("%d",&id);
	printf("请输入人的工资:");
	scanf("%g",&salary);
	fprintf(p_file,"%10d %10g %20s\n",id,salary,name);
}
int main()
{
	FILE *p_file=fopen("person.txt","a");
	int num=0;
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	while(1)
	{
		printf("请输入想要做的事(0:退出程序 1:增加人员信息):\n");
		scanf("%d",&num);
		if(!num)
			return 0;
		GetPer(p_file);
	}
	fclose(p_file);
	p_file=NULL;
}
