
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <event.h>

#include <openssl/sha.h>

#include "base64.h"

#define VALUE_SIZE 65536

static const char hex_digits[] = "0123456789abcdef";

static const char *__sha1_string (const void *buf, size_t len, char *string) {
    char *ptr = string;
    unsigned char digest[SHA_DIGEST_LENGTH];
    int i;

    SHA1 (buf, len, digest);

    for (i = 0; i < SHA_DIGEST_LENGTH; i++) {
        *ptr++ = hex_digits[digest[i] & 0xf];
        *ptr++ = hex_digits[(digest[i] >> 4) & 0xf];
    }
    *ptr++ = 0;

    return string;
}

#define sha1_string(buf, len) \
	__sha1_string(buf, len, alloca(SHA_DIGEST_LENGTH * 2 + 1))

int main (int argc, char **argv) {
    struct evbuffer *buf;
    unsigned char value[VALUE_SIZE];
    unsigned char *value_decoded;
    size_t i, size;

    for (i = 0; i < VALUE_SIZE; i++)
        value[i] = random ();

    printf ("%zu %s\n", i, sha1_string (value, VALUE_SIZE));

    buf = evbuffer_new ();
    base64_encode_evbuf (buf, value, VALUE_SIZE);
    evbuffer_add (buf, (u_char *) "\0", 1);

    size = base64_size (EVBUFFER_LENGTH (buf));
    value_decoded = malloc (size);
    assert (value_decoded != NULL);

    if (EVBUFFER_LENGTH (buf) < 160) {
        printf ("%*s\n", (int) EVBUFFER_LENGTH (buf), (char *) EVBUFFER_DATA (buf));
    }

    size = base64_decode ((const char *) EVBUFFER_DATA (buf), value_decoded, size);

    printf ("%zu %s\n", size, sha1_string (value_decoded, VALUE_SIZE));

    return 0;
}
