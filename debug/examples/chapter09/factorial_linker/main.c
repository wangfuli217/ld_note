/* main.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include <stdlib.h>
#include "factorial.h"

int main(int argc, char **argv) {
    int n, result;
    if(argc != 2) {
        fprintf(stderr, "usage: factorial n, n >=0\n");
        return 1;
    }
    n = atoi(argv[1]);
    result = factorial(n);
    printf("factorial %d!=%d\n", n, result);
    return 0;
}
