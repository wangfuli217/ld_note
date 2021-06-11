#include<stdio.h>
typedef struct
{
	int id;
	float salary;
	char name[20];
}person;
int main()
{
	FILE *p_file=fopen("person.bin","rb");
	person p={};
	int num=0;
	int id=0;
	while(1)
	{
		printf("请输入id:");
		scanf("%d",&id);
		while(1)
		{
			if(!fread(&p,sizeof(p),1,p_file))
			{
				printf("对不起，没有此用户\n");
				break;
			}
			if(id==p.id)
			{
				printf("id是%d,工资是%g,姓名是%s\n",p.id,p.salary,p.name);
				break;
			}
		}
		printf("输入0结束程序，输入1继续查找新用户\n");
		scanf("%d",&num);
		if(!num)
			break;
	}
	fclose(p_file);
	p_file=NULL;
	return 0;
}
