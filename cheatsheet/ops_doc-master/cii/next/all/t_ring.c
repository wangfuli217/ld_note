
#include<stdio.h>
#include"ring.h"

int
main(int argc, char *argv[])
{
    ring_t ring;
    long tmp, i;

    ring = ring_new();

    for(i = 0; i < 1024; i++){
        ring_add_high(ring, (void *)i);
    }

    printf("ring length:%zd\n", ring_length(ring));

    tmp = (long)ring_remove_high(ring);
    printf("remove high got:%ld\n", tmp);

    printf("ring length:%zd\n", ring_length(ring));

    tmp = (long)ring_remove_low(ring);
    printf("remove low got:%ld\n", tmp);

    printf("ring length:%zd\n", ring_length(ring));
}
