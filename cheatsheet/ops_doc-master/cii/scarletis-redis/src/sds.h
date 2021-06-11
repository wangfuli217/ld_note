#ifndef SDS_H
#define SDS_H

#include <stdlib.h>
#include <string.h>

typedef char *sds;

struct sdshdr {
    size_t len;
    char buf[];
};

#define SDS_HDR(s) ((struct sdshdr *)((s) - sizeof(struct sdshdr)))

sds sdsnnew(const void *init, size_t len);
#define sdsnew(init) sdsnnew(init, init ? strlen(init) : 0)

#define sdsfree(s) free(SDS_HDR(s))

#define sdslen(s) (SDS_HDR(s)->len)

#define sdsclear(s) bzero(SDS_HDR(s), sizeof(struct sdshdr) + SDS_HDR(s)->len + 1)
sds sdscpy(sds s, const char *t);
sds sdsncpy(sds s, const char *t, size_t n);
sds sdscat(sds s, const char *t);
sds sdsncat(sds s, const char *t, size_t n);

#define sdstoll(s) strtoll(s, NULL, 0)
sds lltosds(long long n);

#endif
