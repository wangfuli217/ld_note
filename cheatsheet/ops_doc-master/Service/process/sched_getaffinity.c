#define _GNU_SOURCE

#include <sched.h>
#include <stdio.h>
#include <errno.h>

int main(void)
{
     cpu_set_t *mask;
     size_t size;
     int i;
     int nrcpus = 1024;

 realloc:
     mask = CPU_ALLOC(nrcpus);
     size = CPU_ALLOC_SIZE(nrcpus);
     CPU_ZERO_S(size, mask);
     if ( sched_getaffinity(0, size, mask) == -1 ) {
             CPU_FREE(mask);
             if (errno == EINVAL &&
                 nrcpus < (1024 << 8)) {
                    nrcpus = nrcpus << 2;
                    goto realloc;
             }
             perror("sched_getaffinity");
             return -1;
     }

     for ( i = 0; i < nrcpus; i++ ) {
             if ( CPU_ISSET_S(i, size, mask) ) {
                     printf("CPU %d is set\n", (i+1));
             }
     }

     CPU_FREE(mask);

     return 0;
}