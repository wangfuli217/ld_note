#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

static void *thread_sleep_join(void *arg)
{
    sleep(10);
    printf("sleep 10s,end\n");
}

/*
 * 先运行完thread_sleep_join线程，主函数才退出
 */
int main(int argc, char *argv[])
{
    pthread_t thr;
    int s;

    s = pthread_create(&thr, NULL, &thread_sleep_join, NULL);

    if (s != 0)
        printf("pthread_create");

    pthread_join(thr, NULL);  //阻塞等待指定的thr线程结束

    printf("pthread_join end\n");

}