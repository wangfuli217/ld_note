#include <string.h>
#include <limits.h>
#include <stddef.h>
#include <stdio.h>

#include "assert.h"
#include "str.h"
#include "mem.h"
#include "except.h"
#include "safeint.h"
#include "portable.h"

char *Str_asub(const char *s, size_t i, size_t j) {
    char *str, *p;
    assert(s);

    safe_sub_sisi(j, i);

    if(*s == '\0') {
        p = ALLOC(1);
        *p = '\0';
        return p;
    }

    p = str = ALLOC(j - i + 1);

    while (i < j)
        *p++ = s[i++];

    *p = '\0';
    return str;
}

char *Str_adup(const char *s) {
    size_t len;
    void* s1;

    assert(s);

    len = strlen (s) + 1;

    s1 = ALLOC (len);
    return (char *) memcpy (s1, s, len);
}

char *Str_areverse(const char *s) {
    char* p, *str;
    size_t len;

    assert(s);

    len = strlen(s);

    str = p = ALLOC(len + 1);

    *(str+len) = '\0';
    while(len--)
        *p++ = *(s + len);

    return str;
}

char *Str_acat(const char *s1, const char *s2) {
    size_t l1, l2;
    char* t;

    assert(s1);
    assert(s2);

    l1 = strlen(s1);
    l2 = strlen(s2);

    safe_sum_sisi(l1, l2);
    safe_sum_sisi(l1 + l2, 1);

    t = ALLOC(l1 + l2 + 1);

    memcpy(t, s1, l1);
    memcpy(t + l1, s2, l2);
    *(t + l1 + l2) = '\0';
    return t;
}

char *Str_acatvx(const char *s, ...) {
    char *str, *p;
    const char *save = s;
    size_t len = 0;
    va_list ap;

    assert(s);

    va_start(ap, s);
    while (s) {
        size_t len1;

        assert(s);
        len1 = strlen(s);

        safe_sum_sisi(len, len1);
        len += len1;
        s = va_arg(ap, const char *);
    }
    va_end(ap);

    safe_sum_sisi(len, 1);

    p = str = ALLOC(len + 1);
    s = save;

    va_start(ap, s);
    while (s) {
        assert(s);
        while (*s)
            *p++ = *s++;

        s = va_arg(ap, const char *);
    }

    va_end(ap);
    *p = '\0';
    return str;
}

char *Str_amap(const char *s, const char *from, const char *to) {
    char map[256] = { 0 };

    if (from && to) {
        unsigned c;
        for (c = 0; c < sizeof map; c++)
            map[c] = (char)c;

        while (*from && *to)
            map[(unsigned char)*from++] = *to++;

        assert(*from == 0 && *to == 0);
    } else {
        assert(from == NULL && to == NULL && s);
        assert(map['a']);
    }

    if (s) {
        char *str, *p;
        size_t len = strlen(s) + 1;

        p = str = ALLOC(len);

        while (*s)
            *p++ = map[(unsigned char)*s++];

        *p = '\0';
        return str;
    } else
        return NULL;
}

char* Str_avsprintf(const char *fmt, va_list ap);

char* Str_avsprintf(const char *fmt, va_list ap)
{
    int cnt = 0;
    size_t sz = 0, cntsz;
    char *buf;

    sz = 512;
    buf = (char*)ALLOC(sz);
    cnt = vsnprintf(buf, sz, fmt, ap);

    cntsz = safe_cast_su(cnt);

    safe_sum_sisi(cntsz, 3);
    cntsz += 2;

    if (cntsz >= sz) {
        int new_cnt;
        size_t new_cntsz;

        REALLOC(buf, cntsz + 1);
        new_cnt = vsnprintf(buf, cntsz, fmt, ap);
        new_cntsz = safe_cast_su(new_cnt);

        assert(new_cntsz <= cntsz + 3);
    }

    return buf;
}

char* Str_asprintf(const char *fmt, ...)
{
    char* buf;
    va_list args;

    va_start(args, fmt);

    buf = Str_avsprintf(fmt, args);

    va_end(args);
    return buf;
}

char** Str_split(char* s, const char* delimiters, unsigned empties, size_t* size) {
    tokenizer_t tok = tokenizer( s, delimiters, empties );
    char** buf = ALLOC(512 * sizeof(char*));
    size_t n = 0;
    char* token;
    size_t allocs = 1;

    assert(s);
    assert(delimiters);
    assert(empties == TOKENIZER_EMPTIES_OK || empties == TOKENIZER_NO_EMPTIES);
    assert(*delimiters != '\0');

    while ( (token = tokenize( &tok )) != NULL) {
        size_t alloc_index;

        safe_sum_sisi(n, 1);
        buf[n++] = token;

        safe_mul_sisi(512, allocs);
        alloc_index = 512 * allocs;

        if(n >= alloc_index) {
            safe_sum_sisi(allocs, 1);
            allocs++;

            safe_mul_sisi(alloc_index, sizeof(char*));
            REALLOC(buf, alloc_index * sizeof(char*));
        }
    }
    *size = n;
    return buf;
}

