#include <stdio.h>
#include <stdlib.h>

#include "RingBuffer.h"

int main()
{
    ring_buffer_t* rb = rb_create(10);

    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));

    rb_write(rb, "12345", strlen("12345"));

    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));

    char out[11] = {0};

    rb_read(rb, out, 10);

    printf("out:%s\n", out);
    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));
    rb_dump(rb);

    rb_write(rb, "12345", strlen("12345"));

    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));

    rb_read(rb, out, 10);

    printf("out:%s\n", out);
    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));
    rb_dump(rb);


    rb_write(rb, "123456", strlen("123456"));

    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));

    rb_read(rb, out, 10);

    printf("out:%s\n", out);
    printf("readable: %d\n", rb_readable(rb));
    printf("writeable: %d\n", rb_writeable(rb));
    rb_dump(rb);

    return 0;
}
