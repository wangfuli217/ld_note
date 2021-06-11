#include <stdio.h>
#include <stdlib.h>

extern char etext, edata, end; /* The symbols must have some type,
                                   or "gcc -Wall" complains */

int
main(int argc, char *argv[])
{
    printf("First address past:\n");
    printf("    program text (etext)      %10p\n", &etext);
    printf("    initialized data (edata)  %10p\n", &edata);
    printf("    uninitialized data (end)  %10p\n", &end);

    exit(EXIT_SUCCESS);
}
/*
$ ./a.out
First address past:
    program text (etext)       0x8048568
    initialized data (edata)   0x804a01c
    uninitialized data (end)   0x804a024
*/