#include "uthash.h"
#include <string.h>             /* strcpy */
#include <stdlib.h>             /* malloc */
#include <stdio.h>              /* printf */

typedef struct elt {
    char *s;
    UT_hash_handle hh;
} elt;

int main (int argc, char *argv[]) {
    int i;
    elt *head = NULL;
    elt elts[10];
    char label[6] = "hello";

    puts ("create key poniter string hashtable");
    for (i = 0; i < 10; i++) {
        elts[i].s = (char *) malloc (6UL);
        strcpy (elts[i].s, "hello");
        elts[i].s[0] = 'a' + i;
        printf ("\t%d:%s\n", i, elts[i].s);
        HASH_ADD_KEYPTR (hh, head, elts[i].s, 6UL, &elts[i]);
    }

    puts ("find key poniter string hashtable");
    elt *e;
    for (i = 0; i < 10; i++) {
        label[0] = 'a' + i;
        HASH_FIND (hh, head, label, 6UL, e);
        if (e != NULL) {
            printf ("\tfound %s\n", e->s);
        }
    }

    puts ("find_str key poniter string hashtable");
    char find[] = "eello\0";
    //HASH_FIND_STR(head, find, e);   // length
    HASH_FIND (hh, head, find, 6UL, e);
    if (e != NULL) {
        printf ("eello found %s\n", e->s);
    }

    puts ("destroy key poniter string hashtable");
    elt *s, *tmp;
    HASH_ITER (hh, head, s, tmp) {
        HASH_DEL (head, s);
        free (s->s);
    }
    return 0;
}
