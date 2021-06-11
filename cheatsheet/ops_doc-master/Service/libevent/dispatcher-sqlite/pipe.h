#ifndef __PIPE_H__
#define __PIPE_H__

#include <stddef.h>

typedef struct {
    void *object;
    int block;
} pipe_t;

void pipe_open (pipe_t * pip, int block);
int pipe_read (pipe_t * pip, void *data, size_t sz);
int pipe_write (pipe_t * pip, void *data, size_t sz);
int pipe_fd (pipe_t * pip, int type);
void pipe_close (pipe_t * pip);

#endif
