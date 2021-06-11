#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <errno.h>
#include <unistd.h>
#define ASIZE 30
#define READ_THREAD_NUM 3
static pthread_rwlock_t arealock;

int locked_area[ASIZE];
int write_changed = 0;
int finished = 0;

void *thread_read(void *arg) {
    int theadid = *(int *) arg;
    int index_start = theadid * (ASIZE / READ_THREAD_NUM);
    int index_end = index_start + ASIZE / READ_THREAD_NUM;
    int ii;
    while (!finished) {
        if (!write_changed) {
            sleep(1);
            continue;
        }
        pthread_rwlock_rdlock(&arealock);
        for (ii = index_start; ii < index_end; ii++)
            printf("thread%d locked_area[%d]=%d\n", theadid, ii,
                    locked_area[ii]);
        pthread_rwlock_unlock(&arealock);
        sleep(1);
        write_changed = 0;
    }
}

void *thread_write(void *arg) {
    int i, j;
    for (j = 0; j < 3; j++) {
        sleep(4);
        pthread_rwlock_wrlock(&arealock);
        for (i = 0; i < ASIZE; i++) {
            locked_area[i] = i + j * 10;
        }
        printf("write thread finished.\n");
        write_changed = 1;
        pthread_rwlock_unlock(&arealock);
    }
    sleep(5);
    finished = 1;
}

int main(void) {
    int res, ii;
    pthread_t rthread[READ_THREAD_NUM], wthread;
    int tno[READ_THREAD_NUM];

    res = pthread_rwlock_init(&arealock, NULL);
    if (res != 0) {
        perror("arealock initialization failed!!\n");
        exit (EXIT_FAILURE);
    }

    for (ii = 0; ii < READ_THREAD_NUM; ii++) {
        tno[ii] = ii;
        res = pthread_create(&rthread[ii], NULL, thread_read, &tno[ii]);
        if (res != 0) {
            perror("Thread creation failed!!\n");
            exit (EXIT_FAILURE);
            return -1;
        }
    }
    res = pthread_create(&wthread, NULL, thread_write, NULL);
    if (res != 0) {
        perror("Thread creation failed\n");
        exit (EXIT_FAILURE);
        return -1;
    }

    for (ii = 0; ii < READ_THREAD_NUM; ii++) {
        res = pthread_join(rthread[ii], NULL);
        if (res != 0) {
            perror("Thread join failed\n");
            exit (EXIT_FAILURE);
        }
    }
    res = pthread_join(wthread, NULL);
    if (res != 0) {
        perror("Thread join failed\n");
        exit (EXIT_FAILURE);
    }
    pthread_rwlock_destroy(&arealock);
    exit (EXIT_SUCCESS);
}
