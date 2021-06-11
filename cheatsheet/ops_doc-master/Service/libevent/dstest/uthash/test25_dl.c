#include <stdio.h>
#include "utlist.h"

/*
DL_PREPEND(head,add);              
DL_PREPEND_ELEM(head,ref,add);     
DL_APPEND_ELEM(head,ref,add);      
DL_REPLACE_ELEM(head,del,add);     
DL_APPEND(head,add);               
DL_INSERT_INORDER(head,add,cmp);   
DL_CONCAT(head1,head2);            
DL_DELETE(head,del);               
DL_SORT(head,cmp);                 
DL_FOREACH(head,elt) {бн}           
DL_FOREACH_SAFE(head,elt,tmp) {бн}  
DL_SEARCH_SCALAR(head,elt,mbr,val);
DL_SEARCH(head,elt,like,cmp);      
DL_LOWER_BOUND(head,elt,like,cmp); 
DL_COUNT(head,elt,count);          
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
    DL_APPEND (head, &els[0]);
    DL_APPEND (head, &els[1]);
    DL_APPEND (head, &els[2]);
    DL_PREPEND (head, &els[3]);
    DL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    DL_COUNT (head, e, count);
    printf ("count = %d\n", count);

    printf ("deleting b\n");
    DL_DELETE (head, &els[1]);
    DL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    printf ("deleting a\n");
    DL_DELETE (head, &els[0]);
    DL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    printf ("deleting c\n");
    DL_DELETE (head, &els[2]);
    DL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    printf ("deleting d\n");
    DL_DELETE (head, &els[3]);
    DL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    printf ("doubly-link list searching and search-scalaring\n");
    DL_APPEND (head, &els[0]);
    DL_APPEND (head, &els[1]);
    DL_APPEND (head, &els[2]);
    DL_PREPEND (head, &els[3]);
    DL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }

    printf ("\n");
    DL_SEARCH_SCALAR (head, e, id, 'b');
    if (e != NULL) {
        printf ("\tsearch scalar found b\n");
    }
    DL_SEARCH (head, e, &els[0], eltcmp);
    if (e != NULL) {
        printf ("\tsearch found %c\n", e->id);
    }

    printf ("doubly-link list foreach safe then deleting\n");
    el *tmp = NULL;
    DL_FOREACH_SAFE (head, e, tmp) {
        printf ("\tdeleting %c \n", e->id);
        DL_DELETE (head, e);
    }
    return 0;
}
