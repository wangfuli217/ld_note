
#include <ctype.h>
#include <string.h>

#include "digest.h"
#include "utils.h"

int verify_digest (const unsigned char *digest, const unsigned char *data, size_t data_size) {
    unsigned char tmp_digest[SHA_DIGEST_LENGTH];
    SHA1 (data, data_size, tmp_digest);
    return !memcmp (tmp_digest, digest, SHA_DIGEST_LENGTH);
}

static const char hex_digit[] = "0123456789abcdef";

const char *__digest_string (const unsigned char *digest, char *strbuf) {
    char *ptr;
    int i;

    for (i = 0, ptr = strbuf; i < SHA_DIGEST_LENGTH; i++) {
        *ptr++ = hex_digit[digest[i] & 0xf];
        *ptr++ = hex_digit[(digest[i] >> 4) & 0xf];
    }
    *ptr = 0;

    return strbuf;
}

unsigned char *__string_digest (const char *str, unsigned char *digest) {
    const char *d0, *d1;
    int i;

    if (!digest)
        return ERR_PTR (ENOMEM);

    for (i = 0; i < SHA_DIGEST_LENGTH; i++) {
        if (!*str)
            return ERR_PTR (EINVAL);
        d0 = strchr (hex_digit, tolower (*str++));
        if (!d0 || !*str)
            return ERR_PTR (EINVAL);
        d1 = strchr (hex_digit, tolower (*str++));
        if (!d1)
            return ERR_PTR (EINVAL);
        digest[i] = (d0 - hex_digit) | ((d1 - hex_digit) << 4);
    }

    return digest;
}

int digest_distance (const unsigned char *a, const unsigned char *b) {
    const unsigned *ia = (void *) a;
    const unsigned *ib = (void *) b;
    int i;

    for (i = 0; i < SHA_DIGEST_INTS; i++) {
        unsigned bit = ffs (ia[i] ^ ib[i]);
        if (bit)
            return SHA_DIGEST_BITS - (bit + i * 32);
    }

    return -1;
}
