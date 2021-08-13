/********************************************************
 * PING
 * : GCC-4.2.4
 * YSQ-NJUST,yushengqiangyu@163.com
 *
 *******************************************************/

#include<stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

int main()
{
	char *cmd[] = {"ping www.baidu.com -w 10 -c 1 -W 5","ping www.google.cn -w 10 -c 1 -W 5"};
	int i=0;
    char ch;
    for(i=0;i<sizeof(cmd)/sizeof(cmd[0]);i++)
    {
    	printf("%d:%s\n",i,cmd[i]);
		int ret = system(cmd[i]);
		printf("result:%d,%d\n",ret,WEXITSTATUS(ret));
		 if (WIFSIGNALED(ret) &&
		        (WTERMSIG(ret) == SIGINT || WTERMSIG(ret) == SIGQUIT))
		            break;
    	sleep(1);
    }
    return 0;
}

