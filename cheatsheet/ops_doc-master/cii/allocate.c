#include <setjmp.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int Allocation_handled = 0;
jmp_buf Allocate_Failed;

void *allocate(unsigned n) {
    void *new = malloc(n);
    
    if (new)
        return new;
    if (Allocation_handled)
        longjmp(Allocate_Failed, 1);
    assert(0);
}

int main() {
    char *buf;
    Allocation_handled = 1;
    if (setjmp(Allocate_Failed)) {
        fprintf(stderr, "couldn't allocate the buffer\n");
        exit(EXIT_FAILURE);
    }
    buf = allocate(1);
    Allocation_handled = 0;
    return 0;
}