#include<stdio.h>
#include"seq.h"

int
main(int argc, char *argv[])
{
    seq_t seq;
    long tmp, i;

    seq = seq_new(0);

    for(i = 0; i < 1024; i++){
        seq_add_high(seq, (void *)i);
    }

    printf("seq length:%zd\n", seq_length(seq));

    tmp = (long)seq_remove_high(seq);
    printf("remove high got:%ld\n", tmp);

    printf("seq length:%zd\n", seq_length(seq));

    tmp = (long)seq_remove_low(seq);
    printf("remove low got:%ld\n", tmp);

    printf("seq length:%zd\n", seq_length(seq));
}
