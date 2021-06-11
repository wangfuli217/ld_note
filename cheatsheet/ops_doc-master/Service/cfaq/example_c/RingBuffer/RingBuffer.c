#include "RingBuffer.h"

ring_buffer_t*
rb_create(size_t size)
{
    ring_buffer_t* b = malloc(sizeof(ring_buffer_t));

    if (b) {
        b->data = (char*)calloc(sizeof(char), size);
        b->size = size;
        b->r = 0;
        b->w = 0;
    }

    return b;
}

int
rb_read(ring_buffer_t* b, char* out, size_t n)
{
    if (b->w > b-> r) {
        if (n > (b->w - b->r)) {
            memcpy(out, b->data + b->r, b->w - b->r);

            int nread = b->w - b-> r;

            b->r = b->w;

            return nread;
        } else {
            memcpy(out, b->data + b->r, n);

            int nread = n;

            b->r += n;

            return nread;
        }
    } else if (b->w < b->r) {
        if ( n > ( b->size - b->r)) {
            if (n < (b->size - b->r + b->w)) {
                memcpy(out, b->data + b->r, b->size - b->r);
                memcpy(out + b->size - b->r, b->data,  n - (b->size - b->r));

                b->r = n - (b->size - b->r);

                return n;
            } else if (n > (b->size - b->r + b->w)) {
                memcpy(out, b->data + b->r, b->size - b->r);
                memcpy(out + b->size - b->r, b->data,  b->w);

                int nread = b->size - b->r + b->w;

                b->r = b->w;

                return nread;
            }

        } else {
            memcpy(out, b->data + b->r, n);

            b->r += n;

            return n;
        }
    }

    return 0; /* b->w == b->r  */
}

int
rb_write(ring_buffer_t* b, const char* in, size_t n)
{
    if (b->w >= b->r) {
        if (n <= (b->size - b->w)) {
            memcpy(b->data + b->w, in, n);

            b->w += n;

            return n;
        } else {
            int n1 = b->size - b->w;
            int n2 = n - b->size + b->w >= b->r ? b->r : n - b->size + b->w;

            memcpy(b->data + b->w, in, n1);
            memcpy(b->data, in + b->size - b->w, n2);

            b->w = n2;

            return n1 + n2;
        }
    } else {
        if (n <= (b->r - b->w)) {
            memcpy(b->data + b->w, in, n);
            b->w += n;

            return n;
        } else {
            int n1 = b->r - b->w;

            memcpy(b->data + b->w, in, b->r - b->w);

            b->w = b->r;

            return n1;
        }

    }


}

int
rb_readable(ring_buffer_t* b)
{
//    int n = 0;
//
//    if (b->w > b->r) {
//        n = b->w - b->r;
//    } else if (b->w < b->r) {
//        n = b->size - b->r + b->w;
//    } else if (b->w == b->r) {
//        n = 0;
//    }

    return b->w > b->r ? b->w - b->r :
                            b->w < b->r ? b->size - b->r + b->w :
                                b->w == b->r ? 0 : 0;

    //return n;
}

int
rb_writeable(ring_buffer_t* b)
{
    return b->w > b->r ? b->size - b->w + b->r :
                            b->w < b->r ? b->r - b->w :
                                b->w == b->r ? b->size - b->w + b->r : 0;
}

void
rb_empty(ring_buffer_t* b)
{
    if (b) {
        if (b->data) {
            memset(b->data, 0, b->w);
        }
    }
}

void
rb_dump(ring_buffer_t* b)
{
    if (b) {
        if (b->data) {
            printf("data: ");
            for (int i = 0; i < b->size; i++) {
                printf("%#x ", *(b->data + i));
            }

            printf("\n");
        }
    }
}
