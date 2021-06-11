#ifndef __BUFFER_H__
#define __BUFFER_H__

#include <stddef.h>

typedef struct {
    char *data;
    size_t rdi;
    size_t wri;
    size_t capacity;
} buffer_t;

void buf_init (buffer_t * buf, size_t sz);
buffer_t *buf_new (size_t sz);
int buf_read (buffer_t * buf, void *data, size_t n);
int buf_write (buffer_t * buf, void *data, size_t n);
void buf_clear (buffer_t * buf);
int buf_isfull (buffer_t * buf);
int buf_isempty (buffer_t * buf);
void buf_deinit (buffer_t * buf);
void buf_free (buffer_t * buf);

#endif
