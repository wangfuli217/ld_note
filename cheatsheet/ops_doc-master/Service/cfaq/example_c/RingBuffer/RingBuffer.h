#ifndef __RING_BUFFER_H_
#define __RING_BUFFER_H_

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    char*       data;
    uint32_t    size;
    uint32_t    r;
    uint32_t    w;
}ring_buffer_s;

typedef ring_buffer_s ring_buffer_t;

extern ring_buffer_t*
rb_create(size_t size);

extern int
rb_read(ring_buffer_t* b, char* out, size_t n);

extern int
rb_write(ring_buffer_t* b, const char* in, size_t n);

extern void
rb_empty(ring_buffer_t* b);

extern int
rb_readable(ring_buffer_t* b);

extern int
rb_writeable(ring_buffer_t* b);

extern void
rb_dump(ring_buffer_t* b);

#ifdef __cplusplus
}
#endif

#endif // __RING_BUFFER_H_
