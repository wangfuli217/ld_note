/* testmalloc.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include <stdlib.h>
#ifdef _MSC_VER
#define sleep(x) _sleep(1000*(x))
#else
#include <unistd.h>
#endif

#define blocksize 1024

/* make the program wait, so it is possible to inspect process for memory use */
void wait_for_input(const char *prefix, int is_interactive) {
    char c;
    if(is_interactive) {
        printf("%s hit return to continue\n", prefix); fflush(stdout);
        c = getchar();
    }
    else
    {   sleep(1); }
}

/* program entry point */
int main(int argc, char **argv) {
    const char *usage = "usage: testmalloc i[interactive]|n n iterations\n";
    int n, i, j, iterations, is_interactive = 0;
    int **myarray;

    if(argc != 4) {
        fprintf(stderr, usage);
	  return 1;
    }

    if(argv[1][0] == 'i')
        is_interactive = 1;

    n = atoi(argv[2]);
    iterations = atoi(argv[3]);
    if(n <= 0 || iterations < 0) {
        fprintf(stderr, usage);
	  return 2;
    }

    for(i=0; i<iterations; i++) {
	wait_for_input("before malloc: ", is_interactive);
#ifdef USE_NEW
        myarray = new int*[n];
#else
        myarray = (int **) malloc(n * (sizeof(int *)));
#endif
	for(j=0; j<n; j++) {
#ifdef USE_NEW
            myarray[j] = new int[blocksize];
#else
            myarray[j] = (int *) malloc(blocksize * sizeof(int));
#endif
        }
        wait_for_input("after malloc:  ", is_interactive);
        for(j=0; j<n; j++) {
#ifdef USE_NEW
            delete [] myarray[j];
#else
            free(myarray[j]);
#endif
        }

#ifdef USE_NEW
        delete [] myarray;
#else
        free(myarray);
#endif	
    }
    return 0;
}
