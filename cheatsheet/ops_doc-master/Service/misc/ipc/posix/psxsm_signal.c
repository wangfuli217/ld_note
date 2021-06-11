#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <time.h>
#include <assert.h>
#include <errno.h>
#include <signal.h>

sem_t sem;

#define handle_error(msg) \
    do { perror(msg); exit(EXIT_FAILURE); } while (0)//错误处理宏

static void handler(int sig)//信号处理函数
{//信号处理函数中将信号挂出
    printf("in signal handler \r\n");
    write(STDOUT_FILENO, "sem_post() from handler\n", 24);
    if (sem_post(&sem) == -1) {
        write(STDERR_FILENO, "sem_post() failed\n", 18);
        _exit(EXIT_FAILURE);
    }
}

int main(int argc, char *argv[])
{
    struct sigaction sa;//注册信号处理函数
    struct timespec ts;//超时
    int s;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <alarm-secs> <wait-secs>\n",
            argv[0]);
        exit(EXIT_FAILURE);
    }//第一个函数

    if (sem_init(&sem, 0, 0) == -1)
    handle_error("sem_init");


    sa.sa_handler = handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if (sigaction(SIGALRM, &sa, NULL) == -1)//设置定时器信号处理
        handle_error("sigaction");
    alarm(atoi(argv[1])); //开启定时器

    if (clock_gettime(CLOCK_REALTIME, &ts) == -1)
        handle_error("clock_gettime");

    ts.tv_sec += atoi(argv[2]);


    while ((s = sem_timedwait(&sem, &ts)) == -1 && errno == EINTR)//超时等待信号量
        continue;       


    if (s == -1) {
        if (errno == ETIMEDOUT)
            printf("sem_timedwait() timed out\n");
        else
            perror("sem_timedwait");
    } else
        printf("sem_timedwait() succeeded\n");

    exit((s == 0) ? EXIT_SUCCESS : EXIT_FAILURE);
}