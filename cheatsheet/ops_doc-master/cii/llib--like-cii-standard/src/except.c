#include <stdlib.h> /* for abort */
#include <stdio.h>  /* for fprintf */

#include "except.h"
#include "log.h"

#define T Except_T

thread_local Except_T Native_Exception = { "A native exception has occurred" };

thread_local Except_Frame *Except_stack = NULL;

void Except_raise_data(const T *e, const void* data, const char *file, int line) {

    Except_Frame *p = Except_stack;

    if (p == NULL) {
        fprintf(stderr, "Uncaught exception");
        if (e->reason)
            fprintf(stderr, " %s", e->reason);
        else
            fprintf(stderr, " at 0x%p", e);
        if (file && line > 0)
            fprintf(stderr, " raised at %s:%d\n", file, line);
        fprintf(stderr, "aborting...\n");
        fflush(stderr);
        abort();
    }

    p->exception = e;
    p->file = file;
    p->line = line;
    p->data = data;

    Except_stack = Except_stack->prev;

    longjmp(p->env, Except_raised);
}

void Except_raise(const T *e, const char *file, int line) {
    Except_raise_data(e, NULL, file, line);
}
