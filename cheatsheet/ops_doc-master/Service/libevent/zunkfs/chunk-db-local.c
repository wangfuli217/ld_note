
#define _GNU_SOURCE
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "utils.h"

static bool local_read_chunk (unsigned char *chunk, const unsigned char *digest, void *db_info) {
    char *chunk_dir = db_info;
    int fd, len, n;
    char *path;
    int err;

    err = asprintf (&path, "%s/%s", chunk_dir, digest_string (digest));
    if (err < 0)
        return false;

    TRACE ("path=%s\n", path);

    fd = open (path, O_RDONLY);
    if (fd < 0) {
        WARNING ("%s: %s\n", path, strerror (errno));
        free (path);
        return false;
    }
    free (path);

    len = 0;
    while (len < CHUNK_SIZE) {
        n = read (fd, chunk + len, CHUNK_SIZE - len);
        if (n < 0) {
            if (errno == EINTR)
                continue;
            WARNING ("read %s: %s\n", path, strerror (errno));
            close (fd);
            return false;
        }
        len += n;
    }
    close (fd);

    return true;
}

static bool local_write_chunk (const unsigned char *chunk, const unsigned char *digest, void *db_info) {
    char *chunk_dir = db_info;
    int fd, len, n;
    char *path;
    int err;

    err = asprintf (&path, "%s/%s", chunk_dir, digest_string (digest));
    if (err < 0)
        return false;

    TRACE ("path=%s\n", path);

    fd = open (path, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
    if (fd < 0) {
        WARNING ("%s: %s\n", path, strerror (errno));
        free (path);
        return false;
    }
    free (path);

    len = 0;
    while (len < CHUNK_SIZE) {
        n = write (fd, chunk + len, CHUNK_SIZE - len);
        if (n < 0) {
            if (errno == EINTR)
                continue;
            WARNING ("%s: %s\n", path, strerror (errno));
            close (fd);
            return false;
        }
        len += n;
    }
    err = close (fd);
    if (err)
        return false;

    return true;
}

static char *local_chunkdb_ctor (const char *spec, struct chunk_db *cdb) {
    struct stat stbuf;
    int err;

    TRACE ("mode=0x%x spec=%s\n", cdb->mode, spec);

    err = stat (spec, &stbuf);
    if (err == -1)
        return sprintf_new ("Can't stat %s: %s.", spec, strerror (errno));
    if (!S_ISDIR (stbuf.st_mode))
        return sprintf_new ("%s is not a directory.", spec);
    if (access (spec, R_OK | ((cdb->mode & CHUNKDB_RW) ? W_OK : 0)))
        return sprintf_new ("%s.", strerror (errno));

    cdb->db_info = (void *) spec;

    return NULL;
}

static struct chunk_db_type local_chunkdb_type = {
    .spec_prefix = "dir:",
    .info_size = 0,
    .ctor = local_chunkdb_ctor,
    .read_chunk = local_read_chunk,
    .write_chunk = local_write_chunk,
    .help = "   dir:<path>              Chunks are stored in specified directory.\n"
};

REGISTER_CHUNKDB (local_chunkdb_type);
