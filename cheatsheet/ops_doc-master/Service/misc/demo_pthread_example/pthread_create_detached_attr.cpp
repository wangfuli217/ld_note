#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

static void *PrintHello(void *arg)
{
    int stack[1024 * 20] = {0,};
}


int main(int argc, char *argv[])
{
    pthread_t pid;
    int rc;
    long t;
    while (1) {

        pthread_attr_t attr;
        pthread_t thread;
        pthread_attr_init (&attr);
        pthread_attr_setdetachstate (&attr, PTHREAD_CREATE_DETACHED);
        rc = pthread_create(&pid, &attr, PrintHello, NULL);
        pthread_attr_destroy (&attr);
        if (rc) {
            printf("ERROR; return code from pthread_create() is %d\n", rc);
        }
        usleep(1000);

    }


}