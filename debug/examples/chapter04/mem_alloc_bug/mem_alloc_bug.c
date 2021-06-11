/* mem_alloc_bug.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char* argv[]) {
    char* mystr1=strdup("test");
    char* mystr2=strdup("TEST");
    mystr1=mystr2;

    printf ("mystr1=%s\n", mystr1);
    free(mystr1);

    printf ("mystr2=%s\n", mystr2);
    free(mystr2);
    return 0;
}
