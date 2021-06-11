#include<stdio.h>
#include<string.h>
typedef struct
{
	int id;
	float salary;
	char name[20];
}person;
int main()
{
	FILE *p_file=fopen("person.bin","ab");
	int num=0;
	person p={};
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	while(1)
	{
		printf("请输入id:");
		scanf("%d",&p.id);
		printf("请输入工资:");
		scanf("%g",&p.salary);
		scanf("%*[^\n]");
		scanf("%*c");
		printf("请输入姓名:");
		fgets(p.name,20,stdin);
		if(strlen(p.name)==19&&p.name[18]!='\n')
		{
			scanf("%*[^\n]");
			scanf("%*c");
		}
		fwrite(&p,sizeof(p),1,p_file);
		printf("是否需要输入下一个人员信息?0代表不需要，1代表需要");
		scanf("%d",&num);
		if(!num)
			break;
	}
	fclose(p_file);
	p_file=NULL;
	return 0;
}
