
#define _GNU_SOURCE
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sqlite3.h>

#include "zunkfs.h"
#include "chunk-db.h"
#include "utils.h"
#include "mutex.h"

/*
 * CREATE TABLE chunk (
 * 	hash CHAR(20) PRIMARY KEY UNIQUE,
 * 	data BLOB
 * );
 */

struct db_info {
    sqlite3 *db;
    struct mutex mutex;
};

#define lock_db(db) lock(&(db)->mutex)
#define unlock_db(db) unlock(&(db)->mutex)

static bool write_chunk_sqlite (const unsigned char *chunk, const unsigned char *digest, void *db_info_ptr) {
    static const char sql[] = "INSERT OR IGNORE INTO chunk(hash, data) VALUES(?,?)";
    struct db_info *db_info = db_info_ptr;
    sqlite3_stmt *stmt;
    int err;

    lock_db (db_info);

    err = sqlite3_prepare (db_info->db, sql, -1, &stmt, 0);
    if (err != SQLITE_OK) {
        ERROR ("sqlite3_prepare failed: %s\n", sqlite3_errmsg (db_info->db));
        unlock_db (db_info);
        return false;
    }

    sqlite3_bind_text (stmt, 1, digest_string (digest), -1, SQLITE_STATIC);
    sqlite3_bind_blob (stmt, 2, chunk, CHUNK_SIZE, SQLITE_STATIC);

    err = sqlite3_step (stmt);
    assert (err != SQLITE_ROW);

    if (sqlite3_finalize (stmt) != SQLITE_OK) {
        ERROR ("sqlite3_finalize failed: %s\n", sqlite3_errmsg (db_info->db));
        unlock_db (db_info);
        return false;
    }

    unlock_db (db_info);
    return true;
}

static bool read_chunk_sqlite (unsigned char *chunk, const unsigned char *digest, void *db_info_ptr) {
    static const char sql[] = "SELECT data FROM chunk WHERE hash = ?";
    struct db_info *db_info = db_info_ptr;
    sqlite3_stmt *stmt;
    int err;
    bool status = false;

    lock_db (db_info);
    err = sqlite3_prepare (db_info->db, sql, -1, &stmt, 0);
    if (err != SQLITE_OK) {
        ERROR ("sqlite3_prepare failed: %d\n", sqlite3_errmsg (db_info->db));
        unlock_db (db_info);
        return false;
    }

    TRACE ("%s\n", digest_string (digest));

    sqlite3_bind_text (stmt, 1, digest_string (digest), -1, SQLITE_STATIC);

    err = sqlite3_step (stmt);
    if (err != SQLITE_ROW) {
        ERROR ("sqlite3_step failed: %s\n", sqlite3_errmsg (db_info->db));
    } else if (sqlite3_column_bytes (stmt, 0) != CHUNK_SIZE) {
        ERROR ("sqlite3 query returned %d bytes instead of %d.\n", sqlite3_column_bytes (stmt, 0), CHUNK_SIZE);
    } else {
        TRACE ("sqlite3 query got chunk.\n");
        memcpy (chunk, sqlite3_column_blob (stmt, 0), CHUNK_SIZE);
        status = true;
    }

    sqlite3_finalize (stmt);
    unlock_db (db_info);

    return status;
}

static char *sqlite_chunkdb_ctor (const char *spec, struct chunk_db *chunk_db) {
    struct db_info *db_info = chunk_db->db_info;
    int error;

    init_mutex (&db_info->mutex);

    error = sqlite3_open (spec, &db_info->db);
    if (error != SQLITE_OK) {
        char *errstr = sprintf_new ("Can't open SQLite database '%s': %s.",
                                    spec, sqlite3_errmsg (db_info->db));
        sqlite3_close (db_info->db);
        return errstr;
    }

    return 0;
}

static struct chunk_db_type sqlite_chunkdb_type = {
    .spec_prefix = "sqlite:",
    .ctor = sqlite_chunkdb_ctor,
    .read_chunk = read_chunk_sqlite,
    .write_chunk = write_chunk_sqlite,
    .info_size = sizeof (struct db_info),
    .help =
        "   sqlite:<database>       SQLite storage for chunks. Database schema:\n"
        "                              CREATE TABLE chunk (\n"
        "                                      hash CHAR(20) PRIMARY KEY UNIQUE,\n" "                                      data BLOB\n" "                              );\n"
};

REGISTER_CHUNKDB (sqlite_chunkdb_type);
