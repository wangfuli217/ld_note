#include <stdio.h>
#include <sys/wait.h>

void pr_exit(int status);//确定子进程终止状态类型

int main()
{
        pid_t pid;
        int status;
        if ((pid = fork()) < 0)
        {
                perror("fork() error");
                exit(-1);
        }
        if (pid == 0)
        {
                printf("I am child process, pid = %d\n", getpid());
                exit(0);
        }
        else
                sleep(1);//父进程睡眠1秒，确保子进程退出。可以不要这句，因为，下面的wait本来就会阻塞父进程直到子进程终止
        wait(&status);
        printf("I am parent process, pid = %d\n", getpid());
        pr_exit(status);

        if ((pid = fork()) < 0)
        {
                perror("fork() error");
                exit(-1);
        }
        if (pid == 0)
        {
                printf("I am child process, pid = %d\n", getpid());
                sleep(3);//睡眠3秒，测试父进程是否会阻塞
                abort();
        }
        //waitpid(pid, &status, 0);//0会阻塞
        waitpid(pid, &status, WNOHANG);//WNOHANG设置为非阻塞
        printf("I am parent process, pid = %d\n", getpid());//非阻塞情况下，子进程在sleep(3)，而父进程会继续向下执行
        sleep(6);//确保子进程退出
        pr_exit(status);

        exit(0);
}

void pr_exit(int status)
{
        if (WIFEXITED(status))
                printf("normal exit, exit status = %d\n", WEXITSTATUS(status));
        if (WIFSIGNALED(status))
                printf("abnormal exit, signal number = %d\n", WTERMSIG(status));
        if (WIFSTOPPED(status))
                printf("child stoped, signal number = %d\n", WSTOPSIG(status));
}
