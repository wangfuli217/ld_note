#include <stdio.h>
#include "utarray.h"

static int reverse (const void *a, const void *b) {
    int _a = *(int *) a;
    int _b = *(int *) b;
    return _b - _a;
}

// ut_int_icd
int main (void) {
    UT_array *a;
    int i, *p;
    utarray_new (a, &ut_int_icd);
    for (i = 0; i < 10; i++) {
        utarray_push_back (a, &i);
    }
    for (p = (int *) utarray_front (a); p != NULL; p = (int *) utarray_next (a, p)) {
        printf ("%d ", *p);
    }
    printf ("\n");
    utarray_sort (a, reverse);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    // utarray_erase
    printf ("utarray_erase(3,3)\n");
    utarray_erase (a, 3, 3);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    printf ("utarray_erase(1,2)\n");
    utarray_erase (a, 1, 2);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    printf ("utarray_erase(0,1)\n");
    utarray_erase (a, 0, 1);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    printf ("utarray_erase(3,1)\n");
    utarray_erase (a, 3, 1);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    printf ("utarray_resize(5)\n");
    utarray_resize (a, 5);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    printf ("utarray_resize(3)\n");
    utarray_resize (a, 3);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");

    printf ("utarray_erase(0,3)\n");
    utarray_erase (a, 0, 3);
    while ((p = (int *) utarray_next (a, p)) != NULL) {
        printf ("%d ", *p);
    }
    printf ("\n");
    utarray_free (a);
    return 0;
}
