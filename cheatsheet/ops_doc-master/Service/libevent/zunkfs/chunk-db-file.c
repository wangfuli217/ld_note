
#define _GNU_SOURCE

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/file.h>
#include <openssl/sha.h>

#include "utils.h"
#include "zunkfs.h"
#include "chunk-db.h"
#include "byteorder.h"

#define MAX_INDEX		(CHUNK_SIZE / (sizeof(struct index)))
#define SPLIT_AT		((MAX_INDEX + 1) / 2)
#define INVALID_CHUNK_NR	0

/*
* Simple, 2-level btree. 2nd level is all leaf nodes. Should be 
* enough to store upto 4TB of data: MAX_INDEX * MAX_INDEX * CHUNK_SIZE =
* (8192 * 8192 * 65536B) = 4TB. Tho in reality it'll be about 1/2 of that
* due to leaf splitting.
*
* Note that 20-byte digests are converted to 4-byte hashes. This may lead
* to hash collisions. This is dealt with by allowing the same hash to
* appear multiple times in a leaf. Collisions are resolved at lookup.
*
* The first MAX_INDEX + 1chunks are reserved for leaf index chunks. (~512MB)
* Scan through these chunks to build the root node.
*/

struct index {
    be32_t hash;
    be32_t chunk_nr;
} __attribute__ ((packed));

struct db {
    struct index *root;
    int fd;
    uint32_t next_nr;
    unsigned ro:1;
};

static inline unsigned char *__map_chunk (struct db *db, uint32_t nr, int extra_flags) {
    void *chunk;

    chunk = mmap (NULL, CHUNK_SIZE, PROT_READ | (db->ro ? 0 : PROT_WRITE), MAP_SHARED | extra_flags, db->fd, (off_t) nr * CHUNK_SIZE);
    if (chunk == MAP_FAILED)
        return ERR_PTR (errno);

    return chunk;
}

/*
 * Take some premature optimizations:
 * - don't prolong caching of the chunk
 * - ask the OS to prefault the chunk, as it'll be used soon
 */
static inline void *map_chunk (struct db *db, uint32_t nr) {
    void *chunk;

    if (nr >= db->next_nr)
        return ERR_PTR (ERANGE);

    chunk = __map_chunk (db, nr, MAP_NOCACHE | MAP_POPULATE);
#if MAP_POPULATE == 0
    if (!IS_ERR (chunk))
        posix_madvise (chunk, CHUNK_SIZE, POSIX_MADV_WILLNEED);
#endif
    return chunk;
}

static inline void unmap_chunk (void *chunk) {
    int error = munmap (chunk, CHUNK_SIZE);
    assert (error == 0);
}

static int load_root (struct db *db) {
    if (db->next_nr > MAX_INDEX) {
        db->root = map_chunk (db, 0);
        if (!IS_ERR (db->root))
            return 0;
        return -PTR_ERR (db->root);
    }

    if (ftruncate (db->fd, CHUNK_SIZE * (MAX_INDEX + 1)))
        return -errno;

    db->next_nr = MAX_INDEX + 1;

    db->root = map_chunk (db, 0);
    if (IS_ERR (db->root))
        return -PTR_ERR (db->root);

    db->root[0].hash = htobe32 (1);
    db->root[0].chunk_nr = htobe32 (1);

    return 0;
}

static int hash_insert (struct db *db, uint32_t hash, uint32_t chunk_nr) {
    struct index *root = db->root;
    struct index *leaf;
    struct index *split;
    int i, split_at, leaf_nr;

    /* XXX: this may need to become a binary search */
    for (leaf_nr = 1; leaf_nr < be32toh (root[0].hash); leaf_nr++)
        if (hash < be32toh (root[leaf_nr].hash))
            break;

    if (be32toh (root[0].hash) == MAX_INDEX)
        return -ENOSPC;

    leaf = map_chunk (db, be32toh (root[leaf_nr - 1].chunk_nr));
    if (IS_ERR (leaf))
        return -PTR_ERR (leaf);

    /* XXX: this may need to become a binary search */
    for (i = 0; i < MAX_INDEX; i++) {
        if (be32toh (leaf[i].chunk_nr) == INVALID_CHUNK_NR)
            break;
        if (hash < be32toh (leaf[i].hash))
            break;
    }

    if (be32toh (leaf[MAX_INDEX - 1].chunk_nr) != INVALID_CHUNK_NR)
        goto split_leaf;

  do_insert:
    memmove (leaf + i + 1, leaf + i, sizeof (*leaf) * (MAX_INDEX - i - 1));
    leaf[i].hash = htobe32 (hash);
    leaf[i].chunk_nr = htobe32 (chunk_nr);

    unmap_chunk (leaf);
    return 0;
  split_leaf:
    /*
     * Be smart where to split. If a hash repeats, make sure that
     * all it stays in the same leaf.
     */
    for (split_at = SPLIT_AT; split_at != MAX_INDEX; split_at++)
        if (leaf[split_at].hash.v != leaf[split_at - 1].hash.v)
            goto split_here;
    for (split_at = SPLIT_AT - 1; split_at > 0; split_at--)
        if (leaf[split_at].hash.v != leaf[split_at - 1].hash.v)
            goto split_here;
    unmap_chunk (leaf);
    return -ENOSPC;
  split_here:
    split = map_chunk (db, be32toh (root[0].hash));
    if (IS_ERR (split)) {
        unmap_chunk (leaf);
        return -PTR_ERR (split);
    }

    memcpy (split, leaf + split_at, sizeof (*leaf) * (MAX_INDEX - split_at));
    memset (leaf + split_at, 0, sizeof (*leaf) * (MAX_INDEX - split_at));

    memmove (root + leaf_nr + 1, root + leaf_nr, sizeof (*root) * (be32toh (root[0].hash) - leaf_nr));

    root[leaf_nr].hash = split[0].hash;
    root[leaf_nr].chunk_nr = root[0].hash;

    root[0].hash = htobe32 (be32toh (root[0].hash) + 1);

    if (i > split_at) {
        unmap_chunk (leaf);
        leaf = split;
        i -= split_at;
    } else
        unmap_chunk (split);

    goto do_insert;
}

unsigned char *lookup_chunk (struct db *db, const unsigned char *digest) {
    struct index *root = db->root;
    struct index *leaf;
    uint32_t hash = *(uint32_t *) digest;
    int i, leaf_nr;
    unsigned char *chunk;

    /* XXX: this may need to become a binary search */
    for (leaf_nr = 1; leaf_nr < be32toh (root[0].hash); leaf_nr++)
        if (hash < be32toh (root[leaf_nr].hash))
            break;

    TRACE ("leaf_nr=%d chunk_nr=%u hash=%x\n", leaf_nr, be32toh (root[leaf_nr - 1].chunk_nr), be32toh (root[leaf_nr - 1].hash));

    leaf = map_chunk (db, be32toh (root[leaf_nr - 1].chunk_nr));
    if (IS_ERR (leaf))
        return (void *) leaf;

    for (i = 0; i < MAX_INDEX; i++) {
        if (be32toh (leaf[i].chunk_nr) == INVALID_CHUNK_NR)
            break;
        if (hash < be32toh (leaf[i].hash))
            break;
        if (hash == be32toh (leaf[i].hash)) {
            chunk = map_chunk (db, be32toh (leaf[i].chunk_nr));
            if (IS_ERR (chunk))
                goto out;
            if (verify_chunk (chunk, digest))
                goto out;
            unmap_chunk (chunk);
        }
    }
    chunk = NULL;
  out:
    unmap_chunk (leaf);
    return chunk;
}

static bool file_read_chunk (unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct db *db = db_info;
    unsigned char *db_chunk;
    bool status = false;

    flock (db->fd, LOCK_SH);

    db_chunk = lookup_chunk (db, digest);
    if (db_chunk) {
        if (IS_ERR (db_chunk)) {
            TRACE ("digest=%s: %s\n", digest_string (digest), strerror (PTR_ERR (db_chunk)));
        } else {
            status = true;
            memcpy (chunk, db_chunk, CHUNK_SIZE);
            unmap_chunk (db_chunk);
        }
    }
    flock (db->fd, LOCK_UN);

    return status;
}

static bool file_write_chunk (const unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct db *db = db_info;
    unsigned char *db_chunk;
    bool status = false;
    int error;

    flock (db->fd, LOCK_EX);

    db_chunk = lookup_chunk (db, digest);
    if (db_chunk) {
        if (IS_ERR (db_chunk)) {
            TRACE ("lookup_chunk(%s): %s\n", digest_string (digest), strerror (PTR_ERR (db_chunk)));
        } else
            status = true;
        goto out;
    }

    /*
     * When adding a new chunk, the file needs to be resized, otherwise
     * any access to the chunk will cause a SIGBUS. 
     */
    if (ftruncate (db->fd, ((off_t) db->next_nr + 1) * CHUNK_SIZE)) {
        TRACE ("ftruncate(%u * CHUNK_SIZE): %s\n", db->next_nr + 1, strerror (errno));
        goto out;
    }

    db_chunk = __map_chunk (db, db->next_nr, 0);
    if (IS_ERR (db_chunk)) {
        TRACE ("__map_chunk(%u): %s\n", db->next_nr, strerror (PTR_ERR (db_chunk)));
        goto out;
    }

    memcpy (db_chunk, chunk, CHUNK_SIZE);

    error = hash_insert (db, *(uint32_t *) digest, db->next_nr);
    if (error) {
        TRACE ("hash_insert(0x%x, %u): %s\n", *(uint32_t *) digest, db->next_nr, strerror (-error));
        goto out;
    }

    status = true;
    db->next_nr++;
  out:
    unmap_chunk (db_chunk);
    flock (db->fd, LOCK_UN);
    return status;
}

static char *file_chunkdb_ctor (const char *spec, struct chunk_db *chunk_db) {
    const char *path = spec;
    struct db *db = chunk_db->db_info;
    struct stat st;
    int error;

    db->ro = (chunk_db->mode == CHUNKDB_RO);

    db->fd = open (path, db->ro ? O_RDONLY : O_RDWR | O_CREAT, 0644);
    if (db->fd < 0)
        return sprintf_new ("Can't open %s: %s.", path, strerror (errno));

    if (fstat (db->fd, &st))
        goto set_error;

    error = -EINVAL;
    if (!S_ISREG (st.st_mode))
        goto error;

    db->next_nr = st.st_size / CHUNK_SIZE;

    error = load_root (db);
    if (error)
        goto error;

    /*
     * Tell the OS that it doesn't eed to do read-ahead on this file.
     */
    posix_fadvise (db->fd, 0, 0, POSIX_FADV_RANDOM);

    return NULL;
  set_error:
    error = -errno;
  error:
    close (db->fd);
    return sprintf_new ("Error loading database file %s: %s.", path, strerror (-error));
}

static struct chunk_db_type file_chunkdb_type = {
    .spec_prefix = "file:",
    .info_size = sizeof (struct db),
    .ctor = file_chunkdb_ctor,
    .read_chunk = file_read_chunk,
    .write_chunk = file_write_chunk,
    .help =
        "   file:<path>             Use an (almost) flat file for storing chunks.\n"
        "                           The first 512MB of the file are reserved for\n"
        "                           an index of the chunks. With this index, the file\n" "                           can store upto 4TB of data in chunks.\n"
};

REGISTER_CHUNKDB (file_chunkdb_type);
