#define _XOPEN_SOURCE 600
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

int
main(int argc, char *argv[])
{
    clockid_t clockid;
    struct timespec ts;

    if (argc != 2) {
        fprintf(stderr, "%s <process-ID>\n", argv[0]);
     exit(EXIT_FAILURE);
    }

    if (clock_getcpuclockid(atoi(argv[1]), &clockid) != 0) {
     perror("clock_getcpuclockid");
     exit(EXIT_FAILURE);
    }

    if (clock_gettime(clockid, &ts) == -1) {
     perror("clock_gettime");
     exit(EXIT_FAILURE);
    }

    printf("CPU-time clock for PID %s is %ld.%09ld seconds\n",
         argv[1], (long) ts.tv_sec, (long) ts.tv_nsec);
    exit(EXIT_SUCCESS);
}
/*
./a.out 1 
*/