#include "sds.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

sds sdsnnew(const void *init, size_t len) {
    size_t newsize = sizeof(struct sdshdr) + len + 1;
    struct sdshdr *sh = malloc(newsize);
    bzero(sh, newsize);
    sh->len = len;
    sds s = sh->buf;
    if (init)
        strncpy(s, init, len);
    return s;
}

sds sdscat(sds s, const char *t) {
    size_t tlen = strlen(t);
    size_t len = sdslen(s) + tlen;
    size_t newsize = sizeof(struct sdshdr) + len + 1;
    struct sdshdr *sh = malloc(newsize);
    bzero(sh, newsize);
    sh->len = len;

    strncpy(sh->buf, s, sdslen(s));
    strncat(sh->buf, t, tlen);

    sdsfree(s);
    return sh->buf;
}

sds sdsncat(sds s, const char *t, size_t n) {
    size_t len = sdslen(s) + n;
    size_t newsize = sizeof(struct sdshdr) + len + 1;
    struct sdshdr *sh = malloc(newsize);
    bzero(sh, newsize);
    sh->len = len;

    strncpy(sh->buf, s, sdslen(s));
    strncat(sh->buf, t, n);

    sdsfree(s);
    return sh->buf;
}

sds sdscpy(sds s, const char *t) {
    size_t len = strlen(t);
    size_t newsize = sizeof(struct sdshdr) + len + 1;
    struct sdshdr *sh = malloc(newsize);
    bzero(sh, newsize);

    sh->len = len;
    strncpy(sh->buf, s, sdslen(s));

    sdsfree(s);
    return sh->buf;
}

sds sdsncpy(sds s, const char *t, size_t n) {
    size_t newsize = sizeof(struct sdshdr) + n + 1;
    struct sdshdr *sh = malloc(newsize);
    bzero(sh, newsize);

    sh->len = n;
    strncpy(sh->buf, t, n);

    sdsfree(s);
    return sh->buf;
}

sds lltosds(long long n) {
    size_t len = 20;
    size_t newsize = sizeof(struct sdshdr) + len + 1;
    struct sdshdr *sh = malloc(newsize);
    bzero(sh, newsize);

    sprintf(sh->buf, "%lld", n);
    sh->len = strlen(sh->buf);

    return sh->buf;
}
