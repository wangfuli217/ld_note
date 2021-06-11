#include <stdlib.h>
#include <string.h>
#include "platform.h"
#include "utils.h"
#include "debug.h"
#include "pipe.h"

typedef struct {
    int fd[2];
} mypipe;

void pipe_open (pipe_t * pip, int block) {
    mypipe *mypipe = malloc (sizeof (*mypipe));

    if (mypipe == NULL) {
        ph_debug ("open pipe: malloc(%d): %s", sizeof (*mypipe), strerror (ERRNO));
    }

    memset (mypipe, 0, sizeof (*mypipe));

#ifdef _WIN32
    if (_pipe (mypipe->fd, sizeof (mypipe->fd), 0) < 0)
#else
    if (pipe (mypipe->fd) < 0)
#endif
    {
        ph_debug ("open pipe: pipe(%x): %s", mypipe->fd, strerror (ERRNO));
    }

    if (block == 0) {
        blockmode (mypipe->fd[0], 1);
        blockmode (mypipe->fd[1], 1);
    }

    pip->object = mypipe;
    pip->block = block;

    return;
}

int pipe_read (pipe_t * pip, void *data, size_t sz) {
    mypipe *p = pip->object;

    return read (p->fd[0], data, sz);
}

int pipe_write (pipe_t * pip, void *data, size_t sz) {
    mypipe *p = pip->object;

    return write (p->fd[1], data, sz);
}

int pipe_fd (pipe_t * pip, int type) {
    mypipe *p = pip->object;

    return type == 0 ? p->fd[0] : p->fd[1];
}

void pipe_close (pipe_t * pip) {
    mypipe *p = pip->object;

    close (p->fd[0]);
    close (p->fd[1]);
    if (p) {
        free (p);
    }
}
