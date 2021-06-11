/* util1.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <stdio.h>

void show1(char* msg, int value)
{
    printf("-- in show1 %s %d\n", msg, value); fflush(stdout);
    return;
}
