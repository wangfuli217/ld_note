#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {
    struct timespec temp;

    clock_gettime(CLOCK_REALTIME, &temp);

    printf("CLOCK_REALTIME: %d:%d\n", temp->tv_sec, temp->tv_nsec);

    return 0;
}
