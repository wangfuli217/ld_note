#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<sys/types.h>
#include<dirent.h>
#include<unistd.h>
void print(const char *path)
{
	DIR *dir=opendir(path);
	if(dir==NULL)
		return;
	struct dirent *pd=NULL;
	while(pd=readdir(dir))
	{
		if(pd->d_type==8)
			printf("%s	",pd->d_name);
		else if(pd->d_type==4)
		{
			printf("[%s]	",pd->d_name);
		    if(strcmp(pd->d_name,".")==0||strcmp(pd->d_name,"..")==0)
				continue;
			char buf[200]={};
			sprintf(buf,"%s/%s",path,pd->d_name);
			print(buf);
		}
	}
	closedir(dir);
}
int main(int arge,char *argv[])
{
	print(argv[1]);
	printf("\n");
	return 0;
}
