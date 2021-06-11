#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

int main()
{
    pid_t  pid;
    //循环创建子进程
    while(1)
    {
        pid = fork();
        if (pid < 0)
        {
            perror("fork error:");
            exit(1);
        }
        else if (pid == 0)
        {
            printf("I am a child process.\nI am exiting.\n");
            //子进程退出，成为僵尸进程
            exit(0);
        }
        else
        {
            //父进程休眠20s继续创建子进程
            sleep(20);
            continue;
        }
    }
    return 0;
}