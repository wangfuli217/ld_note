#include<stdio.h>
#include"mem.h"

struct test_t{
    int n;
    char *str;
    union{
        long uid;
        long aid;
    }person;
};

static 
void 
inuse(const void *ptr,
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

int
main(int argc, char *argv[])
{
    char *p, *pp;
    struct test_t *p_test;
    struct test_t *t_array;

    p = ALLOC(1024);
    p_test = NEW(p_test);
    t_array = NEWARRAY(t_array, 1024);

    p = RESIZE(p, 2048);
    pp = p;

    printf("Leaking check 1:\n");
    mem_leak(inuse, stdout);


    FREE(p);
    FREE(p_test);
    FREE(t_array);
    
    printf("Leaking check 2:\n");
    mem_leak(inuse, stdout);
}
