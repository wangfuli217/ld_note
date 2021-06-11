#include<sys/times.h>
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<errno.h>
#include"indexminpq.h"

static
void
_usage()
{

    printf("Usage: count\n");
}

static 
void 
_inuse(const void *ptr,
        ssize_t size,
        const char *file,
        const char *func,
        int line,
        void *cl)
{
    FILE *log = cl;

    fprintf(log, "**memory in use at %p\n", ptr);
    fprintf(log, "  This block is %zd bytes long and allocated from"
                 " %s (%s:%d)\n", size, func, file, line);
}


static
void
_dummy_insert
(iminpq_t iminpq, int count)
{
    int i;
    int key;
    clock_t clock_time;

    clock_time = clock();
    srandom((long)clock_time);

    for(i = 0; i < count; i++){
        key = random();
        if(key < 0){
            key *= -1;
        }
        printf("--insert i:%d, key:%d\n", i, key);
        iminpq_insert(iminpq, i, key);
    }
}

static
void
_dummy_delete
(iminpq_t iminpq)
{
    int i;
    double k = 0;
    while(!iminpq_is_empty(iminpq)){
        
        i = iminpq_min_index(iminpq); 
        k = iminpq_key_of(iminpq, i);
        iminpq_delete(iminpq, i);

        printf("--delete i:%d, k:%f\n", i, k);
    }
}

int
main(int argc, char *argv[])
{
    int count;
    iminpq_t    iminpq;

    if(2 != argc){
        _usage();
        return EXIT_FAILURE;
    }


    count   = atoi(argv[1]);

    iminpq = iminpq_new(count);

    printf("Leaking check 0:\n");
    mem_leak(_inuse, stdout);

    _dummy_insert(iminpq, count);

    printf("Leaking check 1:\n");
    mem_leak(_inuse, stdout);

    _dummy_delete(iminpq);

    printf("Leaking check 2:\n");
    mem_leak(_inuse, stdout);

    iminpq_free(&iminpq);

    printf("Leaking check 3:\n");
    mem_leak(_inuse, stdout);

    return EXIT_SUCCESS;
}
