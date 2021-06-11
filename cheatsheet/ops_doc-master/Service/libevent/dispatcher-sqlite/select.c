#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include "select.h"

#define _UNSIGNED_BIT (sizeof(unsigned) * CHAR_BIT)

void select_deinit (select_t * s) {
    int i;

    for (i = 0; i < SELECT_MAX; i++) {
        if (s->fds[i]) {
            free (s->fds[i]);
        }
        s->fds[i] = NULL;
    }
    s->capacity = 0;
}

void select_grow (select_t * s) {
    int i;
    int old_capacity = s->capacity;
    s->capacity = s->capacity ? s->capacity << 1 : 1;

    for (i = 0; i < SELECT_MAX; i++) {
        s->fds[i] = realloc (s->fds[i], s->capacity * sizeof (fd_set));
        memset (s->fds[i] + old_capacity, 0, (s->capacity - old_capacity) * sizeof (fd_set));
    }
}

void select_zero (select_t * s) {
    int i;
    if (s->capacity == 0) {
        return;
    }
    s->maxfd = 0;

    for (i = 0; i < SELECT_MAX; i++) {
        memset (s->fds[i], 0, s->capacity * sizeof (fd_set));
    }
}

void select_add (select_t * s, int set, int fd) {
    unsigned *p;
    while (s->capacity * FD_SETSIZE < fd) {
        select_grow (s);
    }
    p = (unsigned *) s->fds[set];
    p[fd / _UNSIGNED_BIT] |= 1 << (fd % _UNSIGNED_BIT);
    if (fd > s->maxfd) {
        s->maxfd = fd;
    }
}

int select_has (select_t * s, int set, int fd) {
    unsigned *p;

    if (s->maxfd < fd) {
        return 0;
    }
    p = (unsigned *) s->fds[set];

    return p[fd / _UNSIGNED_BIT] & (1 << (fd % _UNSIGNED_BIT));
}
