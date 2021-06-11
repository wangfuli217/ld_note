/*************************************************************************
	> File Name: cpuinfo.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Mon 15 Dec 2014 10:37:39 AM CST
 ************************************************************************/

#include<stdio.h>

int get_system_memory_size(long *total)
{

	long ma;
	FILE * fd;
	char line[100];
	char name[100];
	char names[100];
	if (total == NULL)
			return -1;

	fd = fopen("/proc/cpuinfo", "r");
	if (fd == NULL)
	{
		perror("/proc/cpuinfo");
		return -1;
	}
	while (fgets(line, sizeof(line), fd))
	{
		memset(name,0,sizeof(name));
		memset(names,0,sizeof(names));
		sscanf(line, "%[^:]  %*[^ ] %[^\n]", name, names);
		printf("%s %s\n",name, names);
#if 0
		if (strcmp(name, "model name	") == 0)
		{
			printf("%s\n",names);
			break;
		}
#endif
	}
	fclose(fd);
	return 0;
}

int main(int argc,char *argv[])
{
	char name[256];
	long a;
	get_system_memory_size(&a);

	return 0;
}
