#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../src/table.h"

int cmp(const void *x, const void *y) {
    return strcmp((const char *)x, (const char *)y);
}

unsigned int dictGenHashFunction(const void *key) {
    /* 'm' and 'r' are mixing constants generated offline.
     *      * They're not really 'magic', they just happen to work well.  */
    int len = strlen((const char*)key);
    uint32_t seed = 5381;
    const uint32_t m = 0x5bd1e995;
    const int r = 24;

    /* Initialize the hash to a 'random' value */
    uint32_t h = seed ^ len;

    /* Mix 4 bytes at a time into the hash */
    const unsigned char *data = (const unsigned char *)key;

    while(len >= 4) {
        uint32_t k = *(uint32_t*)data;

        k *= m;
        k ^= k >> r;
        k *= m;

        h *= m;
        h ^= k;

        data += 4;
        len -= 4;
    }

    /* Handle the last few bytes of the input array  */
    switch(len) {
        case 3: h ^= data[2] << 16;
        case 2: h ^= data[1] << 8;
        case 1: h ^= data[0]; h *= m;
    };

    /* Do a few final mixes of the hash to ensure the last few
     *      * bytes are well-incorporated. */
    h ^= h >> 13;
    h *= m;
    h ^= h >> 15;

    return (unsigned int)h;
}

void apply(const void *key, void **value) {
    printf("key: %s\tvalue: %s\n", (const char*)key, (const char*)*value);
}

int main() {
    table_t tab = table_new(1024, cmp, dictGenHashFunction);

    table_put(tab, "append", "cmd_append");
    table_put(tab, "bitcount", "cmd_bitcount");
    table_put(tab, "brpop", "cmd_brpop");
    table_put(tab, "brpoplpush", "cmd_brpoplpush");
    table_put(tab, "decr", "cmd_decr");
    table_put(tab, "decrby", "cmd_decrby");
    table_put(tab, "del", "cmd_del");
    table_put(tab, "exists", "cmd_exists");
    table_put(tab, "get", "cmd_get");
    table_put(tab, "getbit", "cmd_getbit");
    table_put(tab, "getrange", "cmd_getrange");
    table_put(tab, "incr", "cmd_incr");
    table_put(tab, "incrby", "cmd_incrby");
    table_put(tab, "keys", "cmd_keys");
    table_put(tab, "lindex", "cmd_lindex");
    table_put(tab, "linsert", "cmd_linsert");
    table_put(tab, "llen", "cmd_llen");
    table_put(tab, "lpop", "cmd_lpop");
    table_put(tab, "lpush", "cmd_lpush");
    table_put(tab, "lpushx", "cmd_lpushx");
    table_put(tab, "lrange", "cmd_lrange");
    table_put(tab, "lrem", "cmd_lrem");
    table_put(tab, "lset", "cmd_lset");
    table_put(tab, "ltrim", "cmd_ltrim");
    table_put(tab, "mget", "cmd_mget");
    table_put(tab, "msetnx", "cmd_msetnx");
    table_put(tab, "randomkey", "cmd_randomkey");
    table_put(tab, "rename", "cmd_rename");
    table_put(tab, "rpop", "cmd_rpop");
    table_put(tab, "rpoplpush", "cmd_rpoplpush");
    table_put(tab, "rpush", "cmd_rpush");
    table_put(tab, "rpushx", "cmd_rpushx");
    table_put(tab, "set", "cmd_set");
    table_put(tab, "setbit", "cmd_setbit");
    table_put(tab, "setrange", "cmd_setrange");
    table_put(tab, "strlen", "cmd_strlen");
    table_put(tab, "type", "cmd_type");

    table_map(tab, apply);
    printf("len = %d\n", table_length(tab));

    char key[32];
    scanf("%s", key);
    printf("%s\n", (char *)table_get(tab, key));

    printf("remove set\n");
    table_remove(tab, "set");

    table_map(tab, apply);
    printf("len = %d\n", table_length(tab));

    scanf("%s", key);
    printf("%s\n", (char *)table_get(tab, key));

    table_free(&tab);

    return 0;
}
