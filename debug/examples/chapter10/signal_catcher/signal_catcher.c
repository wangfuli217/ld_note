/* signal_catcher.c */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <signal.h>
#include <stdio.h>
 
static int  num_sigusr1=0;
 
void handler(int sig) {
    num_sigusr1++;
    signal(SIGUSR1,&handler);
}

int main(int argc, char** argv) {
    int n,m, pol=0;
    signal(SIGUSR1,&handler);
    printf("- program starts\n"); fflush(stdout);
    for (n=0; n<10; n++) {
        raise(SIGUSR1);
        for (m=0; m<1000000000; m++)
            pol++;
    }
    printf("- program ends: received SIGUSR1 %d time(s)\n",
        num_sigusr1);
    fflush(stdout);
    return 0;
}
