#include <stdio.h>
#include <ctype.h>
#include "../src/sds.h"

void sdsprint(const sds s) {
    size_t len = sdslen(s);
    putchar('"');
    for (size_t i = 0; i != len; ++i) {
        if (isprint(s[i]))
            putchar(s[i]);
        else
            printf("\\%03o", s[i]);
    }
    putchar('"');
    printf("(%ld)\n", len);
}

int main() {
    sds s = sdsnew("andy");

    sdsprint(s);

    s = sdscat(s, "roiiid");
    sdsprint(s);

    s = sdsncat(s, "\n\n\n", 1);
    sdsprint(s);

    s = sdscpy(s, "andyroiiid");
    sdsprint(s);

    s = sdsncpy(s, "andyroiiid", 4);
    sdsprint(s);

    sds t = sdsnew("andy");
    sdsprint(s);

    printf("strcmp? %d\n", strcmp(s, t));

    sds u = sdsnew("123456789");
    printf("strtoll %lld\n", sdstoll(u));
    sdsfree(u);

    long long n = -9223372036854775807 - 1;
    u = lltosds(n);
    sdsprint(u);

    sdsfree(s);
    sdsfree(t);
    sdsfree(u);

    return 0;
}
