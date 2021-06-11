#include <stdio.h>
#include "utlist.h"

/*
CDL_PREPEND(head,add);
CDL_PREPEND_ELEM(head,ref,add);
CDL_APPEND_ELEM(head,ref,add);
CDL_REPLACE_ELEM(head,del,add);
CDL_APPEND(head,add);
CDL_INSERT_INORDER(head,add,cmp);

CDL_DELETE(head,del);
CDL_SORT(head,cmp);
CDL_FOREACH(head,elt) {бн}
CDL_FOREACH_SAFE(head,elt,tmp1,tmp2) {бн}
CDL_SEARCH_SCALAR(head,elt,mbr,val);
CDL_SEARCH(head,elt,like,cmp);
CDL_LOWER_BOUND(head,elt,like,cmp);
CDL_COUNT(head,elt,count);
*/

typedef struct el {
    int id;
    struct el *next, *prev;
} el;

static int eltcmp (el * a, el * b) {
    return a->id - b->id;
}

int main (int argc, char *argv[]) {
    int i;
    int count;
    el els[10], *e;
    el *head = NULL;
    for (i = 0; i < 10; i++) {
        els[i].id = (int) 'a' + i;
    }

    printf ("test CDL macro\n");
    CDL_PREPEND (head, &els[0]);
    CDL_PREPEND (head, &els[1]);
    CDL_PREPEND (head, &els[2]);
    CDL_APPEND (head, &els[3]);
    CDL_FOREACH (head, e) {
        printf ("\t%c ", e->id);
    }
    printf ("\n");

    CDL_COUNT (head, e, count);
    printf ("count = %d\n", count);

    printf ("advancing head pointer\n");
    head = head->next;
    CDL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    for (i = 0, e = head; e && i < 10; i++, e = e->next) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    for (i = 0, e = head; e && i < 10; i++, e = e->prev) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    printf ("deleting b\n");
    CDL_DELETE (head, &els[1]);
    CDL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    printf ("deleting a\n");
    CDL_DELETE (head, &els[0]);
    CDL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    printf ("deleting c\n");
    CDL_DELETE (head, &els[2]);
    CDL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    printf ("deleting d\n");
    CDL_DELETE (head, &els[3]);
    CDL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }

    printf ("circle doubly-link list searching and search-scalaring\n");
    CDL_PREPEND (head, &els[0]);
    CDL_PREPEND (head, &els[1]);
    CDL_PREPEND (head, &els[2]);
    CDL_APPEND (head, &els[3]);

    CDL_SEARCH_SCALAR (head, e, id, 'b');
    if (e != NULL) {
        printf ("\tsearch scalar found b\n");
    }
    CDL_SEARCH (head, e, &els[0], eltcmp);
    if (e != NULL) {
        printf ("\tsearch found %c\n", e->id);
    }

    printf ("circle doubly-link list foreach safe then deleting\n");
    el *tmp = NULL, *tmp2 = NULL;
    CDL_FOREACH_SAFE (head, e, tmp, tmp2) {
        printf ("\tdeleting %c \n", e->id);
        CDL_DELETE (head, e);
    }
    return 0;
}
