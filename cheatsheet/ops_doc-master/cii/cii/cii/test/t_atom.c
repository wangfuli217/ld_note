#include<stdio.h>
#include"atom.h"
#include"mem.h"

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
    int i;
    for(i = 0; i < argc; i++){
        atom_string(argv[i]);
    }
    printf("Mem check 1:\n");
    mem_leak(inuse, stdout);

    for(i = 0; i < argc; i++){
        printf("length of %s:%d\n", argv[i], 
                atom_length(atom_string(argv[i])));
    }

    printf("Mem check 2:\n");
    mem_leak(inuse, stdout);
}
