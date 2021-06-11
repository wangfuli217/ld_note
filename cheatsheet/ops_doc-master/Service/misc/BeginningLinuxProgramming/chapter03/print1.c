/*  We start with the appropriate headers and then a function, printdir,
    which prints out the current directory.
    It will recurse for subdirectories, using the depth parameter is used for indentation.  */

#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <string.h>

//---------------------------------------------------
//	该函数有一点问题，一方面它仅仅统计
//	普通的文件的大小，不统计其他文件的
// 	大小，
//	另一方面:PATH_MAX是隐含定义好的一个宏
//---------------------------------------------------



long GetFilesSizeRecu(const char *filename)
{
	struct 				stat sta;
	long					size = 0, iret;
	DIR						*dirp;
	struct dirent *entp;
	char					path[PATH_MAX + 1];

	if( stat( filename, &sta) < 0)
	{
		//puts(strerror(errno));
		printf("Error in stat");
		return -1;
	}
		
	if( S_ISREG(sta.st_mode)) //普通文件
	{
		return sta.st_size;
	}
	else if ( S_ISDIR(sta.st_mode)) //子目录
	{
		if( (dirp = opendir(filename)) == NULL)
			return -1;
			
		while((entp = readdir(dirp)) != NULL)	
		{
			if( (strcmp(entp->d_name, ".") == 0) || ((strcmp(entp->d_name, "..") == 0)))
				continue;
				
			strcpy(path, filename);
			strcat(path, "/");
			strcat(path, entp->d_name);
			
			//printf("->ready to test %s\n", path);			
			if( (iret = GetFilesSizeRecu(path)) < 0)
			{
				closedir(dirp);
				return 0;
			}
			size += iret;			
		}
		
//		printf("->return from: [%s]\n", filename);		
		closedir(dirp);
	}
	else
		return 0;
	

	return size;
}

//----------------------------------------------------
//可以用递归的方法，来获取当前目录下的
//各个文件和目录的信息。
//----------------------------------------------------

void printdir(char *dir, int depth)
{
    DIR *dp;
    struct dirent *entry;
    struct stat statbuf;

	//sleep(1);
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
            if(strcmp(".",entry->d_name) == 0 
		||  strcmp("..",entry->d_name) == 0)
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

int main(void)
{
	int cnt;
	
    printf("Directory scan of /home:\n");
    printdir("/home",0);
	cnt = GetFilesSizeRecu("./");
	printf("<<<<<<<<<%d>>>>>>>>>>>>>\n",cnt);
    printf("done.\n");

    exit(0);
}

