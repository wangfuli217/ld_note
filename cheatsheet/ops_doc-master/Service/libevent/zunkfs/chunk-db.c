
#define _GNU_SOURCE
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <signal.h>

#include <openssl/sha.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "utils.h"

static LIST_HEAD (chunkdb_types);
static LIST_HEAD (chunkdb_list);

static inline int cmp_digest (const unsigned char *a, const unsigned char *b) {
    return memcmp (a, b, CHUNK_DIGEST_LEN);
}

static inline unsigned char *digest_chunk (const unsigned char *chunk, unsigned char *digest) {
    SHA1 (chunk, CHUNK_SIZE, digest);
    return digest;
}

#define INT_CHUNK_SIZE	((CHUNK_SIZE + sizeof(int) - 1) / sizeof(int))

int random_chunk_digest (unsigned char *digest) {
    int i, chunk_data[INT_CHUNK_SIZE] = { 0 };

    for (i = 0; i < INT_CHUNK_SIZE; i++)
        chunk_data[i] = rand ();

    return write_chunk ((void *) chunk_data, digest);
}

static void __attribute__ ((constructor)) seed_random_number_generator (void) {
    sranddev ();
}

void register_chunkdb (struct chunk_db_type *type) {
    assert (type->spec_prefix);
    assert (type->ctor != NULL);
    assert (type->help != NULL);
    list_add_tail (&type->type_entry, &chunkdb_types);
}

char *add_chunkdb (const char *spec) {
    struct chunk_db_type *type;
    struct chunk_db *cdb;
    int mode;
    char *error;

    if (!strncmp (spec, "ro,", 3)) {
        mode = CHUNKDB_RO;
        spec += 3;
    } else if (!strncmp (spec, "rw,", 3)) {
        mode = CHUNKDB_RW;
        spec += 3;
    } else {
        return sprintf_new ("No mode (ro/rw) in spec.");
    }

    if (mode == CHUNKDB_RW) {
        for (;;) {
            if (!strncmp (spec, "wt,", 3)) {
                mode |= CHUNKDB_WT;
                spec += 3;
            } else if (!strncmp (spec, "nc,", 3)) {
                mode |= CHUNKDB_NC;
                spec += 3;
            } else
                break;
        }
    }

    list_for_each_entry (type, &chunkdb_types, type_entry) {
        if (!strncmp (spec, type->spec_prefix, strlen (type->spec_prefix)))
            goto found;
    }

    return sprintf_new ("Unknown chunk-db.");
  found:
    if ((mode & (CHUNKDB_RO | CHUNKDB_RW)) && !type->read_chunk)
        return sprintf_new ("Chunk-db does not spport reading.");
    if ((mode & CHUNKDB_RW) && !type->write_chunk)
        return sprintf_new ("Chunk-db does not support writing.");

    cdb = malloc (sizeof (struct chunk_db) + type->info_size);
    if (!cdb)
        return ERR_PTR (ENOMEM);

    cdb->type = type;
    cdb->mode = mode;
    cdb->db_info = (void *) (cdb + 1);

    error = type->ctor (spec + strlen (type->spec_prefix), cdb);
    if (error) {
        free (cdb);
        return error;
    }

    list_add_tail (&cdb->db_entry, &chunkdb_list);

    return NULL;
}

void help_chunkdb (void) {
    struct chunk_db_type *type;

    list_for_each_entry (type, &chunkdb_types, type_entry)
        if (type->help)
        fprintf (stderr, "%s\n", type->help);
}

bool read_chunk (unsigned char *chunk, const unsigned char *digest) {
    struct chunk_db *cdb;
    struct chunk_db_type *type;

    list_for_each_entry (cdb, &chunkdb_list, db_entry) {
        type = cdb->type;
        if ((cdb->mode & (CHUNKDB_RO | CHUNKDB_RW))) {
            if (type->read_chunk (chunk, digest, cdb->db_info))
                goto cache_chunk;
        }
    }

    TRACE ("chunk not found: %s\n", digest_string (digest));
    return false;
  cache_chunk:
    for (;;) {
        cdb = list_prev_entry (cdb, db_entry);
        if (&cdb->db_entry == &chunkdb_list)
            break;
        type = cdb->type;
        if ((cdb->mode & (CHUNKDB_RW | CHUNKDB_NC)) == CHUNKDB_RW)
            type->write_chunk (chunk, digest, cdb->db_info);
    }

    return true;
}

bool write_chunk (const unsigned char *chunk, unsigned char *digest) {
    struct chunk_db *cdb;
    struct chunk_db_type *type;
    bool wrote = false;

    digest_chunk (chunk, digest);

    TRACE ("digest=%s\n", digest_string (digest));

    list_for_each_entry (cdb, &chunkdb_list, db_entry) {
        type = cdb->type;
        if ((cdb->mode & CHUNKDB_RW)) {
            if (!type->write_chunk (chunk, digest, cdb->db_info))
                continue;
            wrote = true;
            if (!(cdb->mode & CHUNKDB_WT))
                break;
        }
    }

    return wrote;
}
