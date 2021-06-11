#include <stdio.h>
#include <signal.h>
#include <sys/wait.h>
#include <unistd.h>
#include <errno.h>

static void sig_hup(int signo)
{
    printf("SIGHUP received, pid = %ld\n", getpid());
}

static void pr_ids(char *name)
{
    printf("%s: pid=%ld, ppid=%ld, pgrp=%ld, sid=%ld, tpgrp=%ld\n",
            name, getpid(), getppid(), getpgrp(), getsid(0), tcgetpgrp(STDIN_FILENO));
}

int main()
{
    char c;
    pid_t pid;
    pr_ids("parent");
    pid = fork();
    if (pid > 0)
        sleep(5);//父进程睡眠5秒后终止
    else
    {
        pr_ids("child");
        signal(SIGHUP, sig_hup);
        kill(getpid(), SIGTSTP);//向自身发送停止信号
        pr_ids("child");//发送SIGHUP信号，接着发送SIGCONT信号，得以继续执行
        if (read(STDIN_FILENO, &c, 1) != 1)//读控制终端
            printf("read error %d on controlling TTY\n", errno);
    }
    exit(0);
}
