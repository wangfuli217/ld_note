#include <stdio.h>
#include "utlist.h"

/*
LL_PREPEND(head,add);              
LL_PREPEND_ELEM(head,ref,add);     
LL_APPEND_ELEM(head,ref,add);      
LL_REPLACE_ELEM(head,del,add);     
LL_APPEND(head,add);               
LL_INSERT_INORDER(head,add,cmp);   
LL_CONCAT(head1,head2);            
LL_DELETE(head,del);               
LL_SORT(head,cmp);                 
LL_FOREACH(head,elt) {бн}           
LL_FOREACH_SAFE(head,elt,tmp) {бн}  
LL_SEARCH_SCALAR(head,elt,mbr,val);
LL_SEARCH(head,elt,like,cmp);      
LL_LOWER_BOUND(head,elt,like,cmp); 
LL_COUNT(head,elt,count);          
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
    LL_APPEND (head, &els[0]);
    LL_APPEND (head, &els[1]);
    LL_APPEND (head, &els[2]);
    LL_PREPEND (head, &els[3]);
    LL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    LL_COUNT (head, e, count);
    printf ("count = %d\n", count);

    printf ("deleting b\n");
    LL_DELETE (head, &els[1]);
    LL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    printf ("deleting a\n");
    LL_DELETE (head, &els[0]);
    LL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    printf ("deleting c\n");
    LL_DELETE (head, &els[2]);
    LL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");
    printf ("deleting d\n");
    LL_DELETE (head, &els[3]);
    LL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }

    printf ("single-link list searching and search-scalaring\n");
    LL_APPEND (head, &els[0]);
    LL_APPEND (head, &els[1]);
    LL_APPEND (head, &els[2]);
    LL_PREPEND (head, &els[3]);

    LL_FOREACH (head, e) {
        printf ("%c ", e->id);
    }
    printf ("\n");

    LL_SEARCH_SCALAR (head, e, id, 'b');
    if (e != NULL) {
        printf ("\tsearch scalar found b\n");
    }

    LL_SEARCH (head, e, &els[0], eltcmp);
    if (e != NULL) {
        printf ("\tsearch found %c\n", e->id);
    }

    printf ("single-link list foreach safe then deleting\n");
    el *tmp = NULL;
    LL_FOREACH_SAFE (head, e, tmp) {
        printf ("\tdeleting %c \n", e->id);
        LL_DELETE (head, e);
    }
    return 0;
}
