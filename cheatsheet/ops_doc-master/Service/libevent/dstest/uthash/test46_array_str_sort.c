#include <stdio.h>
#include "utarray.h"

/*
putting elements into it, 
taking them out, and 
iterating over them.
pick from that deal with either single elements or ranges of elements
Push, pop
*/
static int strsort (const void *_a, const void *_b) {
    char *a = *(char **) _a;
    char *b = *(char **) _b;
    return strcmp (a, b);
}

static int revsort (const void *_a, const void *_b) {
    char *a = *(char **) _a;
    char *b = *(char **) _b;
    return strcmp (b, a);
}

int main (void) {
    UT_array *strs, *strs2;
    char *s, **p = NULL;

    printf ("append hello world to strs\n");
    utarray_new (strs, &ut_str_icd);
    s = (char *) "hello";
    utarray_push_back (strs, &s);
    s = (char *) "world";
    utarray_push_back (strs, &s);
    while ((p = (char **) utarray_next (strs, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");
    s = (char *) "begin";

    printf ("insert begin to strs[0]\n");
    utarray_insert (strs, &s, 0);
    while ((p = (char **) utarray_next (strs, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");

    printf ("append alt oth to strs2\n");
    utarray_new (strs2, &ut_str_icd);
    s = (char *) "alt";
    utarray_push_back (strs2, &s);
    s = (char *) "oth";
    utarray_push_back (strs2, &s);

    printf ("insert strs2[1] from strs\n");
    utarray_inserta (strs2, strs, 1);
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");

    printf ("utarray_erase(strs2,0,2)\n");
    utarray_erase (strs2, 0, 2);
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");

    printf ("utarray_pop_back(strs2)\n");
    utarray_pop_back (strs2);
    printf ("output strs2\n");
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");
    printf ("output strs\n");
    while ((p = (char **) utarray_next (strs, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");

    printf ("utarray_concat(strs2, strs);\n");
    utarray_concat (strs2, strs);
    printf ("output strs2\n");
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");

    utarray_clear (strs2);
    utarray_concat (strs2, strs);
    printf ("output strs\n");
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");
    printf ("sorting strs2\n");
    utarray_sort (strs2, strsort);
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");

    printf ("reverse sorting strs2\n");
    utarray_sort (strs2, revsort);
    while ((p = (char **) utarray_next (strs2, p)) != NULL) {
        printf ("\t%s ", *p);
    }
    printf ("\n");
    utarray_clear (strs2);
    utarray_free (strs2);
    utarray_free (strs);
    return 0;
}
