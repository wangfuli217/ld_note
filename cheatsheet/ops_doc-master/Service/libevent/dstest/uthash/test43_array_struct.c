#include <stdio.h>
#include "utarray.h"

typedef struct {
    int a;
    int b;
} intpair_t;

/*
typedef struct {
    size_t sz;
    init_f *init;
    ctor_f *copy;
    dtor_f *dtor;
} UT_icd;

typedef void (ctor_f)(void *dst, const void *src); utarray_push_back, utarray_insert, utarray_inserta, or utarray_concat
typedef void (dtor_f)(void *elt); utarray_resize, utarray_pop_back, utarray_erase, utarray_clear, utarray_done or utarray_free
typedef void (init_f)(void *elt);                  utarray_resize or utarray_extend_back
*/

int main (void) {
    UT_array *pairs, *pairs_cpy;
    intpair_t it, *ip;

    // pairicd define ctor_f dtor_f init_f
    UT_icd pairicd = { sizeof (intpair_t), NULL, NULL, NULL };
    size_t zero = 0;

    // utarray_new utarray_push_back utarray_back utarray_pop_back
    puts ("utarray_new with UT_icd");
    utarray_new (pairs, &pairicd);
    printf ("length is %u\n", utarray_len (pairs));

    puts ("utarray_push_back with (1,2)");
    it.a = 1;
    it.b = 2;
    utarray_push_back (pairs, &it);
    printf ("push\n");
    printf ("length is %u\n", utarray_len (pairs));

    puts ("utarray_back reference last one");
    ip = (intpair_t *) utarray_back (pairs);
    printf ("back is %d %d\n", ip->a, ip->b);

    puts ("utarray_pop_back last one");
    utarray_pop_back (pairs);
    printf ("pop\n");
    printf ("length is %u\n", utarray_len (pairs));

    puts ("utarray_push_back with (1,2) (3,4) and utarray_erase(position,length)");
    it.a = 1;
    it.b = 2;
    utarray_push_back (pairs, &it);
    printf ("push\n");
    printf ("length is %u\n", utarray_len (pairs));
    it.a = 3;
    it.b = 4;
    utarray_push_back (pairs, &it);
    printf ("push\n");
    printf ("length is %u\n", utarray_len (pairs));
    ip = NULL;
    while ((ip = (intpair_t *) utarray_next (pairs, ip)) != NULL) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }
    // utarray_erase
    utarray_erase (pairs, 0, 1);
    printf ("erase [0]\n");
    printf ("length is %u\n", utarray_len (pairs));
    while ((ip = (intpair_t *) utarray_next (pairs, ip)) != NULL) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }

    puts ("utarray_clear all");
    // utarray_clear
    it.a = 1;
    it.b = 2;
    utarray_push_back (pairs, &it);
    printf ("push\n");
    printf ("length is %u\n", utarray_len (pairs));
    utarray_clear (pairs);
    printf ("clear\n");
    printf ("length is %u\n", utarray_len (pairs));

    // utarray_extend_back
    puts ("utarray_extend_back append default by init_f");
    utarray_extend_back (pairs);
    printf ("extend\n");
    ip = (intpair_t *) utarray_back (pairs);
    printf ("length is %u\n", utarray_len (pairs));
    printf ("ip ponits to [0] ? %s\n", (ip == (intpair_t *) utarray_front (pairs)) ? "yes" : "no");
    it.a = 1;
    it.b = 2;
    utarray_push_back (pairs, &it);
    printf ("push\n");
    ip = NULL;
    while ((ip = (intpair_t *) utarray_next (pairs, ip)) != NULL) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }

    puts ("utarray_concat");
    // utarray_erase
    utarray_erase (pairs, 1, 1);
    printf ("erase [1]\n");
    printf ("length is %u\n", utarray_len (pairs));
    while ((ip = (intpair_t *) utarray_next (pairs, ip)) != NULL) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }

    it.a = 3;
    it.b = 4;
    utarray_push_back (pairs, &it);
    printf ("push\n");
    for (ip = (intpair_t *) utarray_front (pairs); ip != NULL; ip = (intpair_t *) utarray_next (pairs, ip)) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }
    ip = (intpair_t *) utarray_back (pairs);
    printf ("back is %d %d\n", ip->a, ip->b);

    // utarray_concat
    utarray_new (pairs_cpy, &pairicd);
    utarray_concat (pairs_cpy, pairs);
    printf ("copy\n");
    printf ("cpy length is %u\n", utarray_len (pairs_cpy));
    ip = NULL;
    while ((ip = (intpair_t *) utarray_next (pairs_cpy, ip)) != NULL) {
        printf ("\tcpy %d %d\n", ip->a, ip->b);
    }

    // utarray_insert
    it.a = 5;
    it.b = 6;
    utarray_insert (pairs_cpy, &it, 0);
    printf ("insert cpy[0]\n");
    printf ("cpy length is %u\n", utarray_len (pairs_cpy));
    while ((ip = (intpair_t *) utarray_next (pairs_cpy, ip)) != NULL) {
        printf ("\tcpy %d %d\n", ip->a, ip->b);
    }

    utarray_erase (pairs_cpy, 0, 2);
    printf ("erase cpy [0] [1]\n");
    printf ("cpy length is %u\n", utarray_len (pairs_cpy));
    while ((ip = (intpair_t *) utarray_next (pairs_cpy, ip)) != NULL) {
        printf ("\tcpy %d %d\n", ip->a, ip->b);
    }

    utarray_inserta (pairs_cpy, pairs, 1);
    printf ("inserta at cpy[1]\n");
    printf ("cpy length is %u\n", utarray_len (pairs_cpy));
    while ((ip = (intpair_t *) utarray_next (pairs_cpy, ip)) != NULL) {
        printf ("\tcpy %d %d\n", ip->a, ip->b);
    }

    utarray_free (pairs_cpy);
    printf ("free cpy\n");
    printf ("length is %u\n", utarray_len (pairs));

    // utarray_resize
    puts ("utarray_resize default by init_f");
    utarray_resize (pairs, 30);
    printf ("resize to 30\n");
    printf ("length is %u\n", utarray_len (pairs));

    // while utarray_next
    puts ("while by utarray_next");
    while ((ip = (intpair_t *) utarray_next (pairs, ip)) != NULL) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }

    // for utarray_front utarray_next
    puts ("for by utarray_front and utarray_next");
    for (ip = (intpair_t *) utarray_front (pairs); ip != NULL; ip = (intpair_t *) utarray_next (pairs, ip)) {
        printf ("\t%d %d\n", ip->a, ip->b);
    }

    utarray_resize (pairs, 1);
    printf ("resize to 1\n");
    printf ("length is %u\n", utarray_len (pairs));
    utarray_resize (pairs, zero);
    printf ("resize to 0\n");
    printf ("length is %u\n", utarray_len (pairs));
    utarray_free (pairs);
    printf ("free\n");
    return 0;
}
