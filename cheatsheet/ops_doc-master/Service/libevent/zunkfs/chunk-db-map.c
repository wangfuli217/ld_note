
#define _GNU_SOURCE
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sqlite3.h>
#include <limits.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "utils.h"
#include "mutex.h"

/*
 * Database schema is:
 *
 * 	CREATE TABLE chunk_map (
 * 			hash CHAR(20) PRIMARY KEY,
 * 			path VARCHAR(1024),
 * 			chunk_nr INTEGER
 * 	);
 */

static const char *map_query = "SELECT path,chunk_nr FROM chunk_map WHERE hash='%s';";

struct chunk_map {
    char path[PATH_MAX];
    int chunk_nr;
};

struct db_info {
    struct mutex mutex;
    const char *db_name;
    union {
        sqlite3 *sqlite3_db;
    };
    int (*query_map) (struct db_info *, const char *query, struct chunk_map * map);
};

#define lock_db(db) lock(&(db)->mutex)
#define unlock_db(db) unlock(&(db)->mutex)

static int read_chunk_from_file (const char *path, unsigned nr, unsigned char *chunk) {
    int len, n, fd;
    off_t offset;

    fd = open (path, O_RDONLY);
    if (fd < 0)
        return -EIO;

    offset = (off_t) nr *CHUNK_SIZE;
    if (lseek (fd, offset, SEEK_SET) == (off_t) - 1) {
        close (fd);
        return -EIO;
    }

    for (len = 0; len < CHUNK_SIZE;) {
        n = read (fd, chunk + len, CHUNK_SIZE - len);
        if (n < 0) {
            if (errno == EINTR)
                continue;
            close (fd);
            return -EIO;
        }
        if (!n)
            break;
        len += n;
    }

    close (fd);
    return len;
}

static int sqlite3_query_callback (void *user_data, int argc, char **argv, char **column_names) {
    struct chunk_map *cmap = user_data;

    if (argc == 0)
        return SQLITE_OK;

    if (argc != 2) {
        ERROR ("Unexpected number of results: %d\n", argc);
        return SQLITE_ERROR;
    }

    snprintf (cmap->path, PATH_MAX, "%s", argv[0]);
    cmap->chunk_nr = atoi (argv[1]);

    return SQLITE_OK;
}

static int query_map_sqlite3 (struct db_info *db, const char *query, struct chunk_map *map) {
    char *errmsg;
    int err;

    TRACE ("db=%s query=%s", db->db_name, query);

    lock_db (db);
    err = sqlite3_exec (db->sqlite3_db, query, sqlite3_query_callback, map, &errmsg);
    unlock_db (db);
    if (err != SQLITE_OK) {
        ERROR ("%s: Query '%s' failed: %s\n", db->db_name, query, errmsg);
        return 0;
    }

    return 1;
}

static bool map_read_chunk (unsigned char *chunk, const unsigned char *digest, void *db_info) {
    struct db_info *db = db_info;
    struct chunk_map map;
    char *query;
    int err;

    err = asprintf (&query, map_query, digest_string (digest));
    if (err)
        return false;

    err = -EIO;
    if (db->query_map (db, query, &map))
        err = read_chunk_from_file (map.path, map.chunk_nr, chunk);

    free (query);
    return err == 0;
}

static char *map_chunkdb_ctor (const char *spec, struct chunk_db *chunk_db) {
    struct db_info *db_info = chunk_db->db_info;
    int error;

    db_info->db_name = spec;
    db_info->query_map = query_map_sqlite3;

    error = sqlite3_open (db_info->db_name, &db_info->sqlite3_db);
    if (error != SQLITE_OK) {
        char *errstr = sprintf_new ("Can't open SQLite database '%s': %s.",
                                    db_info->db_name,
                                    sqlite3_errmsg (db_info->sqlite3_db));
        sqlite3_close (db_info->sqlite3_db);
        return errstr;
    }

    return NULL;
}

static struct chunk_db_type map_chunkdb_type = {
    .spec_prefix = "map:sqlite:",
    .ctor = map_chunkdb_ctor,
    .read_chunk = map_read_chunk,
    .info_size = sizeof (struct db_info),
    .help =
        "   map:sqlite:<db>         Use an SQLite database to store mapping between\n"
        "                           (path, offset) and chunk hash. The database\n"
        "                           schema is\n"
        "                              CREATE TABLE chunk_map (\n"
        "                                      hash      CHAR(20) PRIMARY KEY,\n"
        "                                      path      VARCHAR(1024),\n" "                                      chunk_nr INTEGER\n" "                              );\n"
};

REGISTER_CHUNKDB (map_chunkdb_type);
