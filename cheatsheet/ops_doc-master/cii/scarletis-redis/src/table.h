#ifndef TABLE_H
#define TABLE_H

struct table_t {
    int size;
    int (*cmp)(const void *x, const void *y);
    unsigned int (*hash)(const void *key);
    int length;
    unsigned int timestamp;

    struct binding {
        struct binding *link;
        void *key;
        void *value;
    } **buckets;
};

#define T table_t
typedef struct T *T;

extern T        table_new   (int hint,
        int cmp(const void *x, const void *y),
        unsigned int hash(const void *key));
extern void     table_free  (T *table);

extern int      table_length(T table);
extern void    *table_put   (T table, void *key, void *value);
extern void    *table_get   (T table, const void *key);
extern struct binding  *table_remove(T table, void *key);

extern void     table_map   (T table,
        void apply(void *key, void **value));

extern void     table_map_cl(T table,
        void apply(void *key, void **value, void *cl),
        void *cl);

#undef T

#endif
