/* main.c dll */
/* Copyright (c) 2008 Thorsten Groetker, Ulrich Holtmann, Holger Keding, 
Markus Wloka. All rights reserved. Your use or disclosure of this source code 
is subject to the terms and conditions of the end user license agreement (EULA)
that is part of this software package. */

#include <dlfcn.h>
#include <stdio.h>
void show1(char* msg, int value);
void show2(char* msg, int value);

int main(int argc, char* argv[])
{
    void *dll;
    void (*fn)(char*,int);

    show1("pol", 42);

    if((dll=dlopen("./libutil2.so",RTLD_NOW|RTLD_GLOBAL)) == 0) {
        fprintf(stderr,"%s\n",dlerror());
        return 1;
    }
    if ((fn = dlsym(dll,"show2")) == 0) {
        fprintf(stderr,"%s\n",dlerror());
        return 2;
    }
    (fn)("pol", 42);

    return 0;
}
