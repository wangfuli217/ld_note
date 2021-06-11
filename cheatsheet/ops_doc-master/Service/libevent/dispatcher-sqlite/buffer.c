#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "utils.h"
#include "debug.h"
#include "buffer.h"

buffer_t *buf_new (size_t sz) {
    buffer_t *buf = malloc (sizeof (*buf));
    if (buf == NULL) {
        ph_log_err ("fatal error: malloc(%d)", sizeof (*buf));
    }
    buf_init (buf, sz);

    return buf;
}

void buf_init (buffer_t * buf, size_t sz) {
    assert (buf != NULL);

    char *data = NULL;
    memset (buf, 0, sizeof (*buf));

    if (buf->data == NULL) {
        data = calloc (sz + 1, 1);
        if (data == NULL) {
            ph_log_err ("fatal error: calloc(%d, %d)", sz, sizeof (char));
        }
    }

    buf->data = data;
    buf->rdi = 0;
    buf->wri = 0;
    buf->capacity = sz + 1;
}

int buf_write (buffer_t * buf, void *data, size_t n) {
    if (buf_isfull (buf) == 0) {
        ph_debug ("ringbuf is full, cap:%d rdi:%d wri:%d", buf->capacity - 1, buf->rdi, buf->wri);
        return 1;
    }

    int sz, m;
    if (buf->rdi <= buf->wri) {
        sz = buf->capacity - (buf->wri - buf->rdi) - 1;
        if (sz < n) {
            ph_debug ("ringbuf out of size, cap:%d ava:%d rdi:%d wri:%d n:%d", buf->capacity - 1, sz, buf->rdi, buf->wri, n);
            return -1;
        }

        m = buf->capacity - buf->wri;
        if (n < m) {
            memcpy (buf->data + buf->wri, data, n);
            buf->wri = (buf->wri + n) % buf->capacity;
        } else {
            memcpy (buf->data + buf->wri, data, m);
            buf->wri = (buf->wri + m) % buf->capacity;

            memcpy (buf->data + buf->wri, (char *) data + m, n - m);
            buf->wri = (buf->wri + n - m) % buf->capacity;
        }
    } else {
        sz = buf->rdi - buf->wri - 1;
        if (sz < n) {
            ph_debug ("ringbuf out of size, cap:%d ava:%d rdi:%d wri:%d n:%d", buf->capacity - 1, sz, buf->rdi, buf->wri, n);
            return -1;
        }

        memcpy (buf->data + buf->wri, data, n);
        buf->wri = (buf->wri + n) % buf->capacity;
    }

    return 0;
}

int buf_read (buffer_t * buf, void *data, size_t n) {
    if (buf_isempty (buf) == 0) {
        ph_debug ("ring buf is empty, cap:%d rdi:%d wri:%d", buf->capacity - 1, buf->rdi, buf->wri);
        return -1;
    }

    int sz, m;
    if (buf->wri <= buf->rdi) {
        sz = buf->capacity - (buf->rdi - buf->wri) - 1;
        if (sz < n) {
            ph_debug ("ringbuf out of size, cap:%d ava:%d rdi:%d wri:%d n:%d", buf->capacity - 1, sz, buf->rdi, buf->wri, n);
            return -1;
        }
        m = buf->capacity - buf->rdi;
        if (n < m) {
            memcpy (data, buf->data + buf->rdi, n);
            buf->rdi = (buf->rdi + n) % buf->capacity;
        } else {
            memcpy (data, buf->data + buf->rdi, m);
            buf->rdi = (buf->rdi + m) % buf->capacity;

            memcpy (data + m, buf->data + buf->rdi, n - m);
            buf->rdi = (buf->rdi + n - m) % buf->capacity;
        }
    } else {
        sz = buf->wri - buf->rdi;
        if (sz < n) {
            ph_debug ("ringbuf out of size, cap:%d ava:%d, rdi:%d wri:%d n:%d", buf->capacity - 1, sz, buf->rdi, buf->wri, n);
            return -1;
        }
        memcpy (data, buf->data + buf->rdi, n);
        buf->rdi = (buf->rdi + n) % buf->capacity;
    }

    return 0;
}

void buf_clear (buffer_t * buf) {
    buf->wri = buf->rdi = 0;
}

int buf_isempty (buffer_t * buf) {
    return buf->wri == buf->rdi ? 0 : -1;
}

int buf_isfull (buffer_t * buf) {
    return (buf->wri + 1) % buf->capacity == buf->rdi ? 0 : -1;
}

void buf_deinit (buffer_t * buf) {
    if (buf->data) {
        free (buf->data);
    }
    memset (buf, 0, sizeof (*buf));
}

void buf_free (buffer_t * buf) {
    if (buf) {
        buf_deinit (buf);
        free (buf);
    }
}
