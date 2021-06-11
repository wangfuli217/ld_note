#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <pthread.h>

struct foo
{
    int                 f_count;
    int                 f_addtimes;
    pthread_mutex_t     f_mutex;
};
struct foo * foo_alloc()
{
    struct foo* fp;
    fp = (struct foo*)malloc(sizeof(struct foo));
    if(fp != NULL)
    {
        fp->f_count = 0;
        fp->f_addtimes = 0;
        //设置互斥量类型为递归锁，可以对已加锁再次加锁
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr,PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&fp->f_mutex,&attr);
    }
    return fp;
}
void foo_addtimes(struct foo *fp)
{
    pthread_mutex_lock(&fp->f_mutex);
    fp->f_addtimes++;
    pthread_mutex_unlock(&fp->f_mutex);
}

void foo_add(struct foo *fp)
{
    pthread_mutex_lock(&fp->f_mutex);
    fp->f_count++;
    foo_addtimes(fp);
    pthread_mutex_unlock(&fp->f_mutex);
}
void * thread_func1(void *arg)
{

    struct foo *fp = (struct foo*)arg;
    printf("thread 1 start.\n");
    foo_add(fp);
    printf("in thread 1 count = %d\n",fp->f_count);
    printf("thread 1 exit.\n");
    pthread_exit((void*)1);
}
void * thread_func2(void *arg)
{

    struct foo *fp = (struct foo*)arg;
    printf("thread 2 start.\n");
    foo_add(fp);
    printf("in thread 2 count = %d\n",fp->f_count);
    printf("thread 2 exit.\n");
    pthread_exit((void*)2);
}
int main()
{
    pthread_t pid1,pid2;
    int err;
    void *pret;
    struct foo *fobj;
    fobj = foo_alloc();
    pthread_create(&pid1,NULL,thread_func1,(void*)fobj);
    pthread_create(&pid2,NULL,thread_func2,(void*)fobj);
    pthread_join(pid1,&pret);
    printf("thread 1 exit code is: %d\n",(int)pret);
    pthread_join(pid2,&pret);
    printf("thread 2 exit code is: %d\n",(int)pret);
    exit(0);
}