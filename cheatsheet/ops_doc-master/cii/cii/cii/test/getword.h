#ifndef GETWORD_INCLUDE
#define GETWORD_INCLUDE
#include<stdio.h>

extern int getword(FILE *fp, 
                    char *buf,
                    ssize_t size,
                    int first(int c), 
                    int rest(int c));

#endif /*GETWORD_INCLUDE*/
