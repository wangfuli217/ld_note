#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

#define BUFLEN 20

typedef struct el {
    char bname[BUFLEN];
    struct el *next, *prev;
} el;

static int namecmp (void *_a, void *_b) {
    el *a = (el *) _a;
    el *b = (el *) _b;
    return strcmp (a->bname, b->bname);
}

int main (int argc, char *argv[]) {
    el *name, *elt, *tmp, etmp;
    el *head = NULL;

    char linebuf[BUFLEN];
    FILE *file = fopen ("test11.dat", "r");
    if (file == NULL) {
        perror ("can't open:");
        exit (-1);
    }

    while (fgets (linebuf, BUFLEN, file) != NULL) {
        name = (el *) malloc (sizeof (el));
        if (name == NULL)
            exit (-1);
        strcpy (name->bname, linebuf);
        CDL_APPEND (head, name);
    }
    CDL_SORT (head, namecmp);

    CDL_FOREACH (head, elt) {
        printf ("%s", elt->bname);
    }

    memcpy (etmp.bname, "WES\n", 5UL);
    CDL_SEARCH (head, elt, &etmp, namecmp);
    if (elt != NULL) {
        printf ("found %s\n", elt->bname);
    }

    printf ("deleting head %shead->prev: %s", head->bname, head->prev->bname);
    CDL_DELETE (head, head);
    CDL_FOREACH (head, tmp) {
        printf ("%s", tmp->bname);
    }

    fclose (file);
    return 0;
}
