
#define _GNU_SOURCE

#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <sys/stat.h>

#include "zunkfs.h"
#include "file.h"
#include "dir.h"

#define MIN_FILE_CHUNK_CACHE_SIZE	16

#if CHUNK_SIZE > 4096
#define FILE_CHUNK_CACHE_SIZE	(MIN_FILE_CHUNK_CACHE_SIZE * CHUNK_SIZE / 4096)
#else
#define FILE_CHUNK_CACHE_SIZE	MIN_FILE_CHUNK_CACHE_SIZE
#endif

#define CACHED_CHUNK_MAGIC	((void *)0xf0f0f0f0)

struct open_file {
    struct dentry *dentry;
    struct chunk_node *ccache[FILE_CHUNK_CACHE_SIZE];
    unsigned ccache_index;
};

#define lock_file(of)  lock(&(of)->dentry->mutex)
#define unlock_file(of)  unlock(&(of)->dentry->mutex)
#define assert_file_locked(of) assert(have_mutex(&(of)->dentry->mutex))

/*
 * Only regular files may cache their chunks. For other files,
 * it's possible that cnode->_private will already point
 * to something else.
 */
static inline int cachable (const struct open_file *ofile) {
    return S_ISREG (ofile->dentry->mode);
}

static inline void set_cached (struct chunk_node *cnode) {
    assert (cnode->_private == NULL);
    cnode->_private = CACHED_CHUNK_MAGIC;
}

static inline void clear_cached (struct chunk_node *cnode) {
    assert (cnode->_private == CACHED_CHUNK_MAGIC);
    cnode->_private = NULL;
}

static inline int is_cached (struct chunk_node *cnode) {
    assert (cnode->_private == CACHED_CHUNK_MAGIC || cnode->_private == NULL);
    return cnode->_private == CACHED_CHUNK_MAGIC;
}

static struct open_file *open_file_dentry (struct dentry *dentry) {
    struct open_file *ofile;

    ofile = calloc (1, sizeof (struct open_file));
    if (!ofile)
        return ERR_PTR (ENOMEM);

    ofile->dentry = dentry;
    return ofile;
}

struct open_file *open_file (const char *path) {
    struct dentry *dentry;
    struct open_file *ofile;
    int dir_as_file = 0;

    dentry = find_dentry (path, &dir_as_file);
    if (IS_ERR (dentry))
        return (void *) dentry;

    ofile = open_file_dentry (dentry);
    if (IS_ERR (ofile))
        put_dentry (dentry);

    return ofile;
}

struct open_file *create_file (const char *path, mode_t mode) {
    struct dentry *dentry;
    struct open_file *ofile;

    assert (S_ISREG (mode));
    assert (!S_ISDIR (mode));

    dentry = create_dentry (path, mode | S_IFREG);
    if (IS_ERR (dentry))
        return (void *) dentry;

    ofile = open_file_dentry (dentry);
    if (IS_ERR (ofile))
        put_dentry (dentry);

    return ofile;
}

static void release_cached_chunks (struct open_file *ofile) {
    struct chunk_node *cnode;
    int i;

    assert_file_locked (ofile);

    for (i = 0; i < FILE_CHUNK_CACHE_SIZE; i++) {
        cnode = ofile->ccache[i];
        if (cnode) {
            clear_cached (cnode);
            ofile->ccache[i] = NULL;
            put_chunk_node (cnode);
        }
    }
}

int close_file (struct open_file *ofile) {
    unsigned retv = 0;

    lock_file (ofile);
    release_cached_chunks (ofile);
    if (ofile->dentry->chunk_tree.root)
        retv = flush_chunk_tree (&ofile->dentry->chunk_tree);
    unlock_file (ofile);

    put_dentry (ofile->dentry);

    memset (ofile, 0xcc, sizeof (struct open_file));
    free (ofile);

    return retv;
}

int flush_file (struct open_file *ofile) {
    unsigned retv = 0;

    lock_file (ofile);
    release_cached_chunks (ofile);
    if (ofile->dentry->chunk_tree.root)
        retv = flush_chunk_tree (&ofile->dentry->chunk_tree);
    unlock_file (ofile);

    return retv;
}

static void __cache_file_chunk (struct open_file *ofile, struct chunk_node *cnode) {
    unsigned index;

    assert_file_locked (ofile);

    index = ofile->ccache_index++ % FILE_CHUNK_CACHE_SIZE;
    if (ofile->ccache[index]) {
        clear_cached (ofile->ccache[index]);
        put_chunk_node (ofile->ccache[index]);
    }

    set_cached (cnode);
    ofile->ccache[index] = cnode;
}

static inline void cache_file_chunk (struct open_file *ofile, struct chunk_node *cnode) {
    if (cachable (ofile) && !is_cached (cnode))
        __cache_file_chunk (ofile, cnode);
    else
        put_chunk_node (cnode);
}

static int rw_file (struct open_file *ofile, char *buf, size_t bufsz, off_t offset, int read) {
    struct chunk_node *cnode;
    unsigned chunk_nr;
    unsigned chunk_off;
    uint64_t file_size;
    int len, cplen;

    file_size = ofile->dentry->size;
    if (S_ISDIR (ofile->dentry->mode))
        file_size *= sizeof (struct disk_dentry);
    if (offset > file_size)
        return -EINVAL;

    if (read && offset == file_size)
        return 0;
    if (bufsz > INT_MAX)
        return -EINVAL;
    if (read && (bufsz + offset) > file_size)
        bufsz = file_size - offset;

    chunk_nr = offset / CHUNK_SIZE;
    chunk_off = offset % CHUNK_SIZE;

    len = 0;
    while (len < bufsz) {
        cnode = get_dentry_chunk (ofile->dentry, chunk_nr);
        if (IS_ERR (cnode))
            return PTR_ERR (cnode);

        cplen = bufsz - len;
        if (cplen > CHUNK_SIZE - chunk_off)
            cplen = CHUNK_SIZE - chunk_off;
        if (read) {
            if (cplen > file_size - len)
                cplen = file_size - len;
            memcpy (buf + len, cnode->chunk_data + chunk_off, cplen);
        } else {
            memcpy (cnode->chunk_data + chunk_off, buf + len, cplen);
            mark_cnode_dirty (cnode);
        }
        len += cplen;

        cache_file_chunk (ofile, cnode);

        chunk_nr++;
        chunk_off = 0;
    }

    if (!read) {
        assert (!S_ISDIR (ofile->dentry->mode));
        if ((len + offset) > file_size)
            ofile->dentry->size = len + offset;
        gettimeofday (&ofile->dentry->mtime, NULL);
        ofile->dentry->dirty = 1;
    }

    return len;
}

/*
 * "directory-as-a-file" file handling.
 */
static int write_dir (struct open_file *ofile, const char *buf, size_t len, off_t offset) {
    const struct disk_dentry *ddent;
    size_t total = 0;
    int err;

    TRACE ("len=%zu off=%zu\n", len, (size_t) offset);

    if (len < sizeof (struct disk_dentry))
        return -EINVAL;
    if (len % sizeof (struct disk_dentry))
        return -EINVAL;
    if (offset % sizeof (struct disk_dentry))
        return -EINVAL;

    while (total < len) {
        ddent = (struct disk_dentry *) (buf + total);
        if (!le64toh (ddent->size))
            return -EINVAL;

        err = dup_disk_dentry (ofile->dentry, ddent);
        if (err)
            return err;

        TRACE ("%s %s %s\n", (char *) ddent->name, digest_string (ddent->digest), digest_string (ddent->secret_digest));

        total += sizeof (struct disk_dentry);
    }

    return total;
}

int read_file (struct open_file *ofile, char *buf, size_t bufsz, off_t offset) {
    int len;

    lock_file (ofile);
    len = rw_file (ofile, buf, bufsz, offset, 1);
    unlock_file (ofile);

    return len;
}

int write_file (struct open_file *ofile, const char *buf, size_t len, off_t off) {
    int retv;

    lock_file (ofile);
    if (S_ISDIR (ofile->dentry->mode))
        retv = write_dir (ofile, buf, len, off);
    else
        retv = rw_file (ofile, (char *) buf, len, off, 0);
    unlock_file (ofile);

    return retv;
}

struct dentry *file_dentry (struct open_file *ofile) {
    return ofile->dentry;
}
