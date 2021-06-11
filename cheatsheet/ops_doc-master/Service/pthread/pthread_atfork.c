#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>
#include <signal.h>

pthread_mutex_t     lock1 = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t     lock2 = PTHREAD_MUTEX_INITIALIZER;

void prepare(void)
{
    printf("preparing locks...\n");
    pthread_mutex_lock(&lock1);
    pthread_mutex_lock(&lock2);
}
void parent(void)
{
    printf("parent unlocking locks...\n");
    pthread_mutex_unlock(&lock1);
    pthread_mutex_unlock(&lock2);
}
void child(void)
{
    printf("child unlocking locks...\n");
    pthread_mutex_unlock(&lock1);
    pthread_mutex_unlock(&lock2);
}
void* thread_func(void *arg)
{
    printf("thread started...\n");
    pause();
    return 0;
}
int main()
{
    pid_t       pid;
    pthread_t   tid;
    pthread_atfork(prepare,parent,child);
    pthread_create(&tid,NULL,thread_func,NULL);
    sleep(2);
    printf("parent about to fork.\n");
    pid = fork();
    if(pid == -1)
    {
        perror("fork() error");
        exit(-1);
    }
    if(pid == 0)
        printf("child returned from fork.\n");
    else
        printf("parent returned form fork.\n");
    exit(0);
}