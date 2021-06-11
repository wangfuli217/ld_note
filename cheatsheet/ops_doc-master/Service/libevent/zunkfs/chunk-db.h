#ifndef __ZUNKFS_CHUNKDB_H__
#define __ZUNKFS_CHUNKDB_H__

#include <stdbool.h>
#include "list.h"

struct chunk_db;

struct chunk_db_type {
    const char *spec_prefix;
    unsigned info_size;
    struct list_head type_entry;
    /* return error string, freed by caller, NULL if successful */
    char *(*ctor) (const char *spec, struct chunk_db * chunk_db);
    /* return TRUE if successful, FALSE otherwise. */
     bool (*read_chunk) (unsigned char *chunk, const unsigned char *digest, void *db_info);
     bool (*write_chunk) (const unsigned char *chunk, const unsigned char *digest, void *db_info);
    /*
     * Help string. Format is:
     * <spec>   <description>.
     * spec must be indented 3 spaces,
     * and must not exceed 23 characters.
     * A help line should not exceed 80 characters.
     */
    const char *help;
};

/*
 * Chunk database.
 */
struct chunk_db {
    struct chunk_db_type *type;
    int mode;
    void *db_info;
    struct list_head db_entry;
};

#define CHUNKDB_RO 0            /* read-only */
#define CHUNKDB_RW 1            /* read-write */
#define CHUNKDB_WT 2            /* write thru */
#define CHUNKDB_NC 4            /* not-a-cache */

void register_chunkdb (struct chunk_db_type *type);
char *add_chunkdb (const char *spec);

void help_chunkdb (void);

#define REGISTER_CHUNKDB(type) \
static void __attribute__((constructor)) register_chunkdb_##type(void) \
{ \
	register_chunkdb(&type); \
}

#endif
