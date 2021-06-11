/* answer.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>

void runexperiment() {
    int *answerp;
    answerp = (void *) 42;
    printf("The answer is %d\n", *answerp); 
}

void createplanet() {
    runexperiment();
}

int main() {
    printf("Hello Universe! Computing answer ...\n");
    fflush(stdout);
    createplanet();
    return 0;
}
