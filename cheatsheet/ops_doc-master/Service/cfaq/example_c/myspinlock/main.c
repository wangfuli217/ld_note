#include "myspinlock.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

spinlock lock;

unsigned int count;

static void*
func(void* data)
{
    spin_lock(&lock);
    count++;
    spin_unlock(&lock);
}

int main()
{
    pthread_t worker[10];

    for (int i = 0; i < 10; i++) {
        pthread_create(worker + i, NULL, func, NULL);
    }

    for (int i = 0; i < 10; i++) {
        pthread_join(*(worker + i), NULL);
    }

    printf("count: %u\n", count);

    return 0;
}
