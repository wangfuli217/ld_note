#include <stdlib.h>
#include <stdio.h>
#include "utlist.h"

typedef struct el {
    int id;
    struct el *next, *prev;
} el;

int main (void) {
    int i = 0;
    el els[20], *e, *tmp;
    el *headA = NULL;
    el *headB = NULL;
    for (i = 0; i < 20; i++) {
        els[i].id = (int) 'a' + i;
    }

    /*test CDL macros */
    printf ("Dl replace elem\n");
    CDL_APPEND (headA, &els[0]);
    CDL_APPEND (headA, &els[1]);
    CDL_APPEND (headA, &els[2]);
    CDL_APPEND (headA, &els[3]);
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }

    printf ("\n");
    /* replace head elem */
    puts ("replace head index 0 with index 4");
    CDL_REPLACE_ELEM (headA, &els[0], &els[4]);
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    puts ("replace head index 4 with index 5");
    CDL_REPLACE_ELEM (headA, &els[4], &els[5]);
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    /* replace last elem */
    puts ("replace last index 4 with index 6");
    CDL_REPLACE_ELEM (headA, &els[3], &els[6]);
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    puts ("replace last index 6 with index 7");
    CDL_REPLACE_ELEM (headA, &els[6], &els[7]);
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    /* replace middle elem */
    puts ("replace middle index 1,2 with index 8,9");
    CDL_REPLACE_ELEM (headA, &els[1], &els[8]);
    CDL_REPLACE_ELEM (headA, &els[2], &els[9]);
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    /* replace all just to be sure the list is intact... */
    puts ("replace in FOREACH_SAFE");
    i = 10;
    el *tmp2;
    CDL_FOREACH_SAFE (headA, e, tmp, tmp2) {
        CDL_REPLACE_ELEM (headA, e, &els[i]);
        i++;
    }
    CDL_FOREACH (headA, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    /* single elem */
    puts ("replace single");
    CDL_APPEND (headB, &els[18]);
    CDL_FOREACH (headB, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    CDL_REPLACE_ELEM (headB, &els[18], &els[19]);
    CDL_FOREACH (headB, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    return 0;
}
