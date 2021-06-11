
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "utils.h"
#include "mutex.h"
#include "chunk-db.h"
#include "zunkfs.h"
#include "list.h"

#define MAX_CACHE_SIZE	65536

struct chunk {
    unsigned char digest[CHUNK_DIGEST_LEN];
    unsigned char data[CHUNK_SIZE];
    struct list_head lru_entry;
    struct list_head hash_entry;
};

struct cache {
    struct list_head chunk_lru;
    struct list_head *chunk_table;
    unsigned long hash_mask;
    unsigned long count;
    unsigned long max;
    struct mutex mutex;
};

static inline struct list_head *cache_bucket (struct cache *cache, const unsigned char *digest) {
    return cache->chunk_table + (*(unsigned long *) digest & cache->hash_mask);
}

static bool mem_read_chunk (unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct cache *cache = db_info;
    struct chunk *cp;
    struct list_head *bucket;
    bool status = false;

    lock (&cache->mutex);

    bucket = cache_bucket (cache, digest);

    list_for_each_entry (cp, bucket, hash_entry) {
        if (!memcmp (digest, cp->digest, CHUNK_DIGEST_LEN)) {
            memcpy (chunk, cp->data, CHUNK_SIZE);
            list_move (&cp->lru_entry, &cache->chunk_lru);
            status = true;
            break;
        }
    }

    unlock (&cache->mutex);

    return status;
}

static bool mem_write_chunk (const unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct cache *cache = db_info;
    struct list_head *bucket;
    struct chunk *cp;
    bool status = false;

    lock (&cache->mutex);

    bucket = cache_bucket (cache, digest);

    list_for_each_entry (cp, bucket, hash_entry) {
        if (!memcmp (digest, cp->digest, CHUNK_DIGEST_LEN)) {
            TRACE ("%s is a duplicate\n", digest_string (digest));
            goto found;
        }
    }

    cp = malloc (sizeof (struct chunk));
    if (!cp)
        goto out;

    memcpy (cp->digest, digest, CHUNK_DIGEST_LEN);
    memcpy (cp->data, chunk, CHUNK_SIZE);

    list_add (&cp->lru_entry, &cache->chunk_lru);
    list_add (&cp->hash_entry, bucket);

    cache->count++;
    if (cache->count > cache->max) {
        cp = list_entry (cache->chunk_lru.prev, struct chunk, lru_entry);
        list_del (&cp->lru_entry);
        list_del (&cp->hash_entry);
        free (cp);
        cache->count--;
    }

  found:
    status = true;
  out:
    unlock (&cache->mutex);
    return status;
}

static char *mem_chunkdb_ctor (const char *spec, struct chunk_db *chunk_db) {
    struct cache *cache = chunk_db->db_info;
    unsigned i;

    if (!(chunk_db->mode & CHUNKDB_RW))
        return sprintf_new ("Memory cache has to be writable.");

    list_head_init (&cache->chunk_lru);
    init_mutex (&cache->mutex);

    cache->count = 0;
    cache->max = -1;

    if (spec[0]) {
        cache->max = atol (spec);
        if (!cache->max)
            cache->max = -1;
    }

    if (cache->max == -1)
        cache->max = MAX_CACHE_SIZE;

    cache->hash_mask = 1;
    while (cache->hash_mask < cache->max)
        cache->hash_mask |= (cache->hash_mask << 1);

    cache->chunk_table = malloc ((cache->hash_mask + 1) * sizeof (struct list_head));
    if (!cache->chunk_table)
        return ERR_PTR (ENOMEM);

    for (i = 0; i <= cache->hash_mask; i++)
        list_head_init (&cache->chunk_table[i]);

    TRACE ("hash_mask=0x%x (%d buckets)\n", cache->hash_mask, i);

    return NULL;
}

static struct chunk_db_type mem_chunkdb_type = {
    .spec_prefix = "mem:",
    .info_size = sizeof (struct cache),
    .ctor = mem_chunkdb_ctor,
    .read_chunk = mem_read_chunk,
    .write_chunk = mem_write_chunk,
    .help =
        "   mem:[max]               Dummy chunk database that stores all chunks in\n"
        "                           memory. To limit memory usage, set max to\n" "                           maximum number of chunks that can be cached.\n"
};

REGISTER_CHUNKDB (mem_chunkdb_type);
