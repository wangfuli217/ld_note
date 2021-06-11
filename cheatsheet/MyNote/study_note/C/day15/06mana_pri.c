#include<stdio.h>
int main()
{
	int id=0;
	float salary=0.0f;
	char name[10]={};
	int size=0;
	FILE *p_file=fopen("person.txt","r");
	if(!p_file)
	{
		printf("打开失败\n");
		return 0;
	}
	while(1)
	{
		size=fscanf(p_file,"%d %g %s\n",&id,&salary,name);
		if(size!=3)
			break;
		printf("%10s %10d %20g\n",name,id,salary);
	}
	fclose(p_file);
	p_file=NULL;
	return 0;
}
