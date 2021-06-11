
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <event.h>
#include "base64.h"

static const char base64_chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static unsigned char base64_map (const char **strp) {
    const char *str = *strp;
    const char *ptr;

    while (*(str = *strp) && *str != '=') {
        *strp = str + 1;
        ptr = strchr (base64_chars, *str);
        if (ptr)
            return ptr - base64_chars;
    }

    return 0;
}

/*
 * Returns actual size of decoded buffer.
 */
size_t base64_decode (const char *str, unsigned char *buf, size_t size) {
    unsigned int n;
    size_t i, j, actual = 0;

    for (i = 0; *str && *str != '=';) {
        n = base64_map (&str) << 18;
        n += base64_map (&str) << 12;
        n += base64_map (&str) << 6;
        n += base64_map (&str);

        if (i < size)
            buf[i++] = (n >> 16) & 255;
        if (i < size)
            buf[i++] = (n >> 8) & 255;
        if (i < size)
            buf[i++] = n & 255;

        actual += 3;
    }

    /* account for padding */
    for (j = 0; j < 3 && str[j] == '='; j++)
        actual--;

    return actual;
}

int base64_encode_evbuf (struct evbuffer *evbuf, const unsigned char *s, size_t length) {
    unsigned int n;
    char string[4];
    size_t i;
    int ret = 0;

    for (i = 0; i < length;) {
        n = s[i++] << 16;
        n += (i < length) ? s[i++] << 8 : 0;
        n += (i < length) ? s[i++] : 0;

        string[0] = base64_chars[(n >> 18) & 63];
        string[1] = base64_chars[(n >> 12) & 63];
        string[2] = base64_chars[(n >> 6) & 63];
        string[3] = base64_chars[n & 63];

        ret = evbuffer_add (evbuf, string, 4);
        if (ret)
            return ret;
    }

    /* padd to make length a multiple of 3 */
    for (i = 0; length % 3 != 0; i++, length++)
        string[i] = '=';
    if (i)
        ret = evbuffer_add (evbuf, string, i);

    return ret;
}
