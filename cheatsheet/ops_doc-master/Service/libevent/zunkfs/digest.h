
#ifndef __DIGEST_H__
#define __DIGEST_H__

#include <openssl/sha.h>

#ifndef SHA_DIGEST_BITS
#define SHA_DIGEST_BITS (SHA_DIGEST_LENGTH * 8)
#endif

#ifndef SHA_DIGEST_INTS
#define SHA_DIGEST_INTS (SHA_DIGEST_LENGTH / sizeof(int))
#endif

#ifndef SHA_DIGEST_STRLEN
#define SHA_DIGEST_STRLEN (SHA_DIGEST_LENGTH * 2)
#endif

int verify_digest (const unsigned char *digest, const unsigned char *data, size_t data_size);

const char *__digest_string (const unsigned char *digest, char *strbuf);

#define digest_string(digest) \
	__digest_string(digest, alloca(SHA_DIGEST_STRLEN + 1))

unsigned char *__string_digest (const char *str, unsigned char *digest);

#define string_digest(str) __string_digest(str, alloca(SHA_DIGEST_LENGTH))

int digest_distance (const unsigned char *a, const unsigned char *b);

#endif
