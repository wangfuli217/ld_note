/**
 死锁调试
 1) -g参数
 2) attach
 3) info threads
 4) thread + number切换到对应的线程或thread apply all bt全部设置断点
 */

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void *workThread(void *arg) {
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, 0);
    usleep(1000 * 1000);
    fprintf(stderr, "timeout we will start dead lock\n");
    pthread_mutex_lock(&mutex);
    pthread_mutex_lock(&mutex);
}

void *AliveThread(void * arg) {
    while (true) {
        usleep(1000 * 1000);
    }
}

int main(int argc, char *argv[]) {
    pthread_t alivepid;
    pthread_create(&alivepid, 0, AliveThread, 0);
    pthread_t deadpid;
    pthread_create(&deadpid, 0, workThread, 0);
    void *retval = 0;
    pthread_join(deadpid, &retval);
    void *retval2 = 0;
    pthread_join(alivepid, &retval2);
    return 0;
}
