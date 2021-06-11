#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "buffer.h"
#include "unit.h"

int buff_info (buffer_t * buf, char *b) {
    return sprintf (b, "cap:%d, rdi:%d, wri:%d", buf->capacity, buf->rdi, buf->wri);
}

char *buffer_tests () {
    buffer_t *buf = NULL;
    int i;
    char mbuf[10] = "helloworld";
    char info[1024];

    buf = buf_new (1024);
    for (i = 0; i < 200; i++) {
        mbuf[8] = '0' + i % 10;
        mbuf[9] = '\0';
        buf_write (buf, mbuf, 10);
    }
    memset (mbuf, 0, sizeof (mbuf));
    for (i = 0; i < 50; i++) {
        buf_read (buf, mbuf, 10);
        buff_info (buf, info);
        ph_debug ("%d:%s %s", i, mbuf, info);
    }

    for (i = 0; i < 100; i++) {
        mbuf[8] = '0' + i % 10;
        mbuf[9] = '\0';
        buf_write (buf, mbuf, 10);
    }

    ph_debug ("total buf: %s", buf->data);

    memset (mbuf, 0, sizeof (mbuf));
    for (i = 0; i < 200; i++) {
        buf_read (buf, mbuf, 10);
        buff_info (buf, info);
        ph_debug ("%d:%s %s", i, mbuf, info);
    }

    buf_free (buf);
    return NULL;
}

char *buffer_full_tests () {
    buffer_t *buf = buf_new (32);
    char mybuf[1024];

    buf_write (buf, "81dc9bdb52d04dc20036dbd8313ed055", 32);
    buf_write (buf, "hello", 5);
    buf_read (buf, mybuf, 32);
    mybuf[32] = '\0';
    ph_debug ("%s", mybuf);

    buf_free (buf);

    return NULL;
}

char *run_all_tests () {
    ph_suite_start ();
    ph_run_test (buffer_tests);
    ph_run_test (buffer_full_tests);

    return NULL;
}

PH_RUN_TESTS (run_all_tests);
