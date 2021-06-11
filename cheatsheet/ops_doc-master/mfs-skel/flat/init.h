#ifndef __MAIN_INIT_H_
#define __MAIN_INIT_H_

#include <stdio.h>

/* Run Table */
typedef int (*runfn)(void);

typedef struct {
    runfn fn;
    char *name;
} sRunTab;

sRunTab RunTab[]={
    {(runfn)0,"****"}
};
sRunTab LateRunTab[]={
    {(runfn)0,"****"}
};


#endif

