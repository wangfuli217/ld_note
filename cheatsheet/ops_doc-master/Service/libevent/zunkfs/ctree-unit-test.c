
#define _GNU_SOURCE
#include <assert.h>
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "zunkfs.h"
#include "zunkfs-tests.h"
#include "dir.h"
#include "chunk-db.h"

#define NR_NODES	3 * DIGESTS_PER_CHUNK

static const char spaces[] = "                                                                                                                                                               ";
#define indent_start (spaces + sizeof(spaces) - 1)

static unsigned char rand_digest[CHUNK_DIGEST_LEN];
static unsigned char rand_chunk[CHUNK_SIZE];

static int test_read_chunk (unsigned char *chunk, const unsigned char *digest) {
    int i, err;

    printf ("test_read_chunk: %s\n", digest_string (digest));

    err = read_chunk (chunk, digest);
    if (err < 0)
        return err;

    for (i = 0; i < CHUNK_SIZE; i++)
        chunk[i] ^= rand_chunk[i];

    return err;
}

static int test_write_chunk (const unsigned char *chunk, unsigned char *digest) {
    unsigned char real_chunk[CHUNK_SIZE];
    int i, err;

    for (i = 0; i < CHUNK_SIZE; i++)
        real_chunk[i] = chunk[i] ^ rand_chunk[i];

    err = write_chunk (real_chunk, digest);
    if (err < 0)
        return err;

    printf ("test_write_chunk: %s\n", digest_string (digest));
    return err;
}

struct chunk_tree_operations ctree_ops = {
    .free_private = free,
    .read_chunk = test_read_chunk,
    .write_chunk = test_write_chunk,
};

int main (int argc, char **argv) {
    struct chunk_tree ctree;
    struct chunk_node *cnode[NR_NODES];
    unsigned char root_digest[CHUNK_DIGEST_LEN];
    int i, err;
    char *errstr;

    err = set_logging ("T,stdout");
    if (err)
        panic ("set_logging: %s\n", strerror (-err));

    errstr = add_chunkdb ("rw,mem:");
    if (errstr)
        panic ("add_chunkdb: %s\n", STR_OR_ERROR (errstr));

    err = random_chunk_digest (rand_digest);
    if (err < 0)
        panic ("random_chunk_digest: %s\n", strerror (-err));

    err = read_chunk (rand_chunk, rand_digest);
    if (err < 0)
        panic ("read_chunk(rand_chunk): %s\n", strerror (-err));

    memcpy (root_digest, rand_digest, CHUNK_DIGEST_LEN);

    err = init_chunk_tree (&ctree, 1, root_digest, &ctree_ops);
    if (err)
        panic ("init_chunk_tree: %s\n", strerror (-err));

    printf ("After init:\n");
    dump_ctree (&ctree, indent_start, NULL);

    for (i = 0; i < NR_NODES; i++) {
        cnode[i] = get_nth_chunk (&ctree, i);
        if (IS_ERR (cnode[i]))
            panic ("get_chunk_nr(%d): %s\n", i, strerror (PTR_ERR (cnode[i])));
        printf ("[%d] = %p\n", i, cnode[i]);
    }

    printf ("\nAfter inserting %d nodes:\n", i);
    dump_ctree (&ctree, indent_start, NULL);

    for (i = 0; i < NR_NODES; i++)
        put_chunk_node (cnode[i]);

    printf ("\nAfter putting %d nodes:\n", i);
    dump_ctree (&ctree, indent_start, NULL);

    for (i = 0; i < NR_NODES; i++) {
        cnode[i] = get_nth_chunk (&ctree, i);
        if (IS_ERR (cnode[i]))
            panic ("get_chunk_nr(%d): %s\n", i, strerror (PTR_ERR (cnode[i])));
        printf ("[%d] = %p\n", i, cnode[i]);
    }

    printf ("\nAfter getting %d nodes:\n", i);
    dump_ctree (&ctree, indent_start, NULL);

    return 0;
}
