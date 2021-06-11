#include "db.h"

#include <string.h>

#include "log.h"
#include "hash.h"

table_t s_db;

int cmp_str(const void *x, const void *y) {
    return strcmp((const char *)x, (const char *)y);
}

unsigned int hash_str(const void *str) {
    return dictGenHashFunction(str, strlen((const char*)str));
}

int db_init() {
    s_log("Init DB");
    s_db = table_new(1024, cmp_str, hash_str);
    return 0;
}

void db_free_k_v(void *key, void **value) {
    free(key);
    free(*value);
}

int db_dstr() {
    table_map(s_db, db_free_k_v);
    table_free(&s_db);
    s_log("DB Destoryed");
    return 0;
}
