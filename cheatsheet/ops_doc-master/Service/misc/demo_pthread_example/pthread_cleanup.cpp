#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

void cleanup(void *arg){
    printf("cleanup: %s\n",(char *)arg);
}

void *thr_fn1(void *arg) {
    printf("thread 1 start\n");

    pthread_cleanup_push(cleanup, (void *)"thread 1 first handler");
    pthread_cleanup_push(cleanup, (void *)"thread 1 second handler");

    printf("thread 1 push complete\n");

        return ((void *)1);

//    if(arg)
//        return ((void *)1);

    pthread_cleanup_pop(1);
    pthread_cleanup_pop(1);


}

void *thr_fn2(void *arg) {

    printf("thread 2 start\n");

    pthread_cleanup_push(cleanup, (void *)"thread 2 first handler");
    pthread_cleanup_push(cleanup, (void *)"thread 2 second handler");

    printf("thread 2 push complete\n");

    if(arg) {
        pthread_exit((void *)2);
    }

    pthread_cleanup_pop(0);  //取消第一个线程处理程序

    pthread_cleanup_pop(0);  //取消第二个线程处理程序

    pthread_exit((void *) 2);
}

int main(void){
    int err;
    pthread_t tid1,tid2;
    int *tret;

    err = pthread_create(&tid1,NULL,thr_fn1,(void *)1);
    if( err != 0){
        fprintf(stderr,"create thread1 failed: %s",strerror(err));
        exit(1);
    }

    err = pthread_create(&tid2,NULL,thr_fn2,(void *)2);
    if(err != 0){
        fprintf(stderr,"create thread 2 failed: %s",strerror(err));
        exit(1);
    }

    err = pthread_join(tid1,&tret);
    if(err != 0){
        fprintf(stderr,"thread1 join failed: %s",strerror(err));
        exit(1);
    }

//    printf("thread 1 exit code %d\n",*(int *)tret);

    err = pthread_join(tid2,&tret);
    if(err != 0){
        fprintf(stderr,"thread2 join failed: %s",strerror(err));
        exit(1);
    }
//    printf("thread 2 exit code %d\n",*(int *)tret);
    exit(0);
}