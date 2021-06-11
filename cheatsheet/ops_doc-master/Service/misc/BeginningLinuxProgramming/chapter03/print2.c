/*  We start with the appropriate headers and then a function, printdir,
    which prints out the current directory.
    It will recurse for subdirectories, using the depth parameter is used for indentation.  */

#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>

//----------------------------------------------------
//可以用递归的方法，来获取当前目录下的
//各个文件和目录的信息。
//在主函数中的入口，也可以把它变成一个
//函数，让其他的函数调用!
//新联的程序就用到了，该程序来计算整个磁盘
//或整个文件夹的大小
//----------------------------------------------------

void printdir(char *dir, int depth)
{
    DIR *dp;
    struct dirent *entry;
    struct stat statbuf;

	if((dp = opendir(dir)) == NULL)
	{
		fprintf(stderr,"cannot open directory: %s\n", dir);
		return;
	}
	
    	chdir(dir);
	while((entry = readdir(dp)) != NULL)
	{
		lstat(entry->d_name,&statbuf);
		if(S_ISDIR(statbuf.st_mode)) 
		{
			/* Found a directory, but ignore . and .. */
			if(strcmp(".",entry->d_name) == 0 || 
			strcmp("..",entry->d_name) == 0)
			continue;
			printf("%*s%s/\n",depth,"",entry->d_name);
			/* Recurse at a new indent level */
			printdir(entry->d_name,depth+4);
		}
		else 
		{
			printf("%*s%s\n",depth,"",entry->d_name);
		}
			
	}
    chdir("..");
    closedir(dp);
}

/*  Now we move onto the main function.  */

int main(int argc, char* argv[])
{
    char *topdir, pwd[2]=".";
    if (argc != 2)
        topdir=pwd;
    else
        topdir=argv[1];

    printf("Directory scan of %s\n",topdir);
    printdir(topdir,0);
    printf("done.\n");

    exit(0);
}


