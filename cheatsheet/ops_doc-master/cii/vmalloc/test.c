#include <stdlib.h>
#include <stdio.h>
#include <err.h>

#include "vmalloc.h"

static const size_t big_size = (1 << 20) + 1;

int main(void)
{
    int *a = allocate(sizeof(int));
    int *b = allocate(32);
    int *c = allocate(sizeof(int));
    int *d = allocate(sizeof(int));

    *a = 1;
    *b = 2;
    *c = 3;
    *d = 4;

    /* intentionally looking for stale memory */
    deallocate(c);
    deallocate(d);
    d = allocate(sizeof(int));
    c = allocate(sizeof(int));

    /* test large allocations */
    deallocate(a);
    a = allocate(big_size);
    *a = big_size;

    /* try allocating into a larger pool */
    deallocate(b);
    b = allocate(102);
    *b = 102;

    /* loop to exhaust pool */
    int i;
    int *pool[256];
    for (i = 0; i < 256; ++i) {
        pool[i] = allocate(sizeof(int));

        if (pool[i] == NULL) {
            warn("failed to allocate memory");
            break;
        }

        *pool[i] = -i;
    }

    printf("a b c d: %d %d %d %d\n", *a, *b, *c, *d);

    /* for (i = 0; i < 256; ++i) */
    /*     deallocate(pool[i]); */
}