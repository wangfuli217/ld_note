#ifndef __SELECT_H__
#define __SELECT_H__

#include "platform.h"

enum {
    SELECT_READ,
    SELECT_WRITE,
    SELECT_EXCEPT,
    SELECT_MAX
};

typedef struct {
    int capacity;
    int maxfd;
    fd_set *fds[SELECT_MAX];
} select_t;

/* select */
void select_deinit (select_t * s);
void select_grow (select_t * s);
void select_zero (select_t * s);
void select_add (select_t * s, int set, int fd);
int select_has (select_t * s, int set, int fd);

#endif
