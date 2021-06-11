#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>
#include <signal.h>

void print_exit(int status)
{
    if (WIFEXITED(status))
        printf("normal termination, exit status = %d\n", WEXITSTATUS(status));
    else if (WIFSIGNALED(status))
        printf("abnormal termination, signal number = %d%s\n", WTERMSIG(status),
#ifdef WCOREDUMP
        WCOREDUMP(status) ? ("core file generated") : (""));
#else
    "");
#endif
    else if (WIFSTOPPED(status))
        printf("child stopped, signal number=%d\n", WSTOPSIG(status));
}

void sig_usr(int signo)
{
    if (signo == SIGUSR1)
        printf("received SIGUSR1\n");
    else if (signo == SIGUSR2)
        printf("received SIGUSR2\n");
    else
        printf("received signal %d\n", signo);
}

int main(int argc, char** argv)
{
    pid_t pid;
    struct sigaction act, oact;
    int status;
    int ret;

    act.sa_handler = sig_usr;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0|SA_NOCLDWAIT;
    sigaction(SIGCHLD, &act, &oact);

    if ((pid=fork()) < 0)
    {
        printf("fork error\n");
        return -1;
    }
    else if (pid == 0)
    {
        printf("child exit\n");
        return 0;
    }
    else
    {
        printf("parent sleep(100)\n");
        sleep(100);
        //ret = wait(&status);
        //print_exit(status);
        printf("parent exit\n");
    }


    exit(0);
}