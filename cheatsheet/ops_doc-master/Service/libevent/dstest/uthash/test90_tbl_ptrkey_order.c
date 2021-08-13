#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "uthash.h"

struct item {
    unsigned char *sort_field;
    size_t sort_field_len;
    int some_user_data;
    UT_hash_handle hh;
};
static int sort_func (const struct item *a, const struct item *b) {
    int va = *(int *) (void *) a->sort_field;
    int vb = *(int *) (void *) b->sort_field;
    return (va < vb) ? -1 : (va > vb);
}

int main (void) {
    size_t i;
    struct item *p, *tmp;
    int total = 0;

    struct item *list = NULL;
    int counter = 0;

    for (i = 0; i < 100; i++) {
        p = (struct item *) malloc (sizeof (*p));
        p->sort_field_len = sizeof (int);
        p->sort_field = (unsigned char *) malloc (p->sort_field_len);
        *(int *) (void *) p->sort_field = counter++;
        HASH_ADD_KEYPTR_INORDER (hh, list, p->sort_field, p->sort_field_len, p, sort_func);
    }

    printf ("filling in is ok\n");

    HASH_ITER (hh, list, p, tmp) {
        total += *(int *) (void *) p->sort_field;
        HASH_DEL (list, p);
        free (p->sort_field);
        free (p);
    }

    printf ("cleanup is ok\n");
    return 0;
}