#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <vector>
#include <queue>
#include <unistd.h>
#include <map>
#include <execinfo.h>
#include "log.h"

void *PrintHello(void *)
{
    int stack[1024*1024*1 + 1024*1022] = {0,};
    return (void *)0;

}

void create_detached_attr_pthread() {

    static uint32_t pth_count = 0;

    pthread_t pid;

//    pthread_attr_t attr;
//    pthread_attr_init(&attr);
//    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);


//    int rc = pthread_create(&pid, &attr, PrintHello, NULL);

    int rc = pthread_create(&pid, NULL, PrintHello, NULL);


//    pthread_attr_destroy(&attr);

    if (rc) {
        printf("maxpthNum is %u\n", pth_count);
        printf("ERROR; return code from pthread_create() is %d\n", rc);
    } else {
        pth_count++;
    }
}