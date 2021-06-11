#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

extern char **environ;
static pthread_key_t    key;
pthread_mutex_t env_mutex;
static pthread_once_t   init_done = PTHREAD_ONCE_INIT;
static void thread_init(void)
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr,PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&env_mutex,&attr);
    pthread_mutexattr_destroy(&attr);
    pthread_key_create(&key,free);
}
char* mygetenv(const char *name)
{
    int i,len;
    char *envbuf;
    //调用thread_inti一次
    pthread_once(&init_done,thread_init);
    pthread_mutex_lock(&env_mutex);
    //获取线程中与key关联的私有数据
    envbuf = (char*)pthread_getspecific(key);
    if(envbuf == NULL)
    {
        envbuf = (char*)malloc(100);
        if(envbuf == NULL)
        {
             pthread_mutex_unlock(&env_mutex);
             return NULL;
        }
        //将envbuf设置为与key关联
        pthread_setspecific(key,envbuf);
    }
    len = strlen(name);
    for(i=0;environ[i] != NULL;i++)
    {
        if((strncmp(name,environ[i],len) == 0) &&
           (environ[i][len] == '='))
           {

               strcpy(envbuf,&environ[i][len+1]);
               pthread_mutex_unlock(&env_mutex);
               return envbuf;
           }
    }
    pthread_mutex_unlock(&env_mutex);
    return NULL;
}
void * thread_func1(void *arg)
{
    char *pvalue;
    printf("thread 1 start.\n");
    pvalue = mygetenv("HOME");
    printf("HOME=%s\n",pvalue);
    printf("thread 1 exit.\n");
    pthread_exit((void*)1);
}
void * thread_func2(void *arg)
{
    char *pvalue;
    printf("thread 2 start.\n");
    pvalue = mygetenv("SHELL");
    printf("SHELL=%s\n",pvalue);
    printf("thread 2 exit.\n");
    pthread_exit((void*)2);
}

int main()
{
    pthread_t pid1,pid2;
    int err;
    void *pret;
    pthread_create(&pid1,NULL,thread_func1,NULL);
    pthread_create(&pid2,NULL,thread_func2,NULL);
    pthread_join(pid1,&pret);
    printf("thread 1 exit code is: %d\n",(int)pret);
    pthread_join(pid2,&pret);
    printf("thread 2 exit code is: %d\n",(int)pret);
    exit(0);
}