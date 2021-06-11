/*
   人员信息管理系统
   */
#include<stdio.h>
typedef struct
{
	int id;
	float salary;
	char name[20];
}person;
int main()
{
	FILE *	p_file=fopen("person.bin","rb");
	int  size=0;
	person p={};
	if(!p_file)
	{
		printf("打开失败");
		return 0;
	}
	while(1)
	{
		size=fread(&p,sizeof(p),1,p_file);
		if(size!=1)
			break;
		printf("id是%d,工资是%g,姓名是%s\n",p.id,p.salary,p.name);
	}
	fclose(p_file);
	p_file=NULL;
	return 0;
}
