#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

//当程序执行的父进程的时候，n等于5
//当程序执行的子进程的时候，n等于3
//父进程和子进程拥有不同的代码空间；但是他们却又相同的代码。
int main(void)
{
    pid_t pid;
    char *message;
    int n;

    printf("fork program starting\n");
    pid = fork();
    switch(pid) 
    {
    case -1:
        perror("fork failed");
        exit(1);
    case 0:
        message = "This is the child";
        n = 3;
        break;
    default:
        message = "This is the parent";
        n = 5;
        break;
    }

    for(; n > 0; n--) 
	{
        puts(message);
        sleep(1);
    }
    exit(0);
}
