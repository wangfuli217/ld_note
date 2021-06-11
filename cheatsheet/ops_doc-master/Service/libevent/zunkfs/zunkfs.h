#ifndef __ZUNKFS_H__
#define __ZUNKFS_H__

#ifndef CHUNK_SIZE
#define CHUNK_SIZE		(1UL << 16)
#endif

#include <string.h>
#include <stdbool.h>

#include "digest.h"

#define CHUNK_DIGEST_LEN	SHA_DIGEST_LENGTH
#define CHUNK_DIGEST_STRLEN	SHA_DIGEST_STRLEN
#define DIGESTS_PER_CHUNK	(CHUNK_SIZE / CHUNK_DIGEST_LEN)

/*
 * write_chunk() updates 'digest' field.
 */
bool write_chunk (const unsigned char *chunk, unsigned char *digest);
bool read_chunk (unsigned char *chunk, const unsigned char *digest);
void zero_chunk_digest (unsigned char *digest);
int random_chunk_digest (unsigned char *digest);

static inline int verify_chunk (const unsigned char *chunk, const unsigned char *digest) {
    return verify_digest (digest, chunk, CHUNK_SIZE);
}

#endif
