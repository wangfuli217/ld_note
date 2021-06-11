#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
        LL_APPEND (head, name);
    }
    LL_SORT (head, namecmp);

    LL_FOREACH (head, elt) {
        printf ("%s", elt->bname);
    }

    memcpy (etmp.bname, "WES\n", 5UL);
    LL_SEARCH (head, elt, &etmp, namecmp);
    if (elt != NULL) {
        printf ("found %s\n", elt->bname);
    }

    printf ("deleting head %shead->prev: %s", head->bname, head->prev->bname);
    LL_DELETE (head, head);
    LL_FOREACH (head, tmp) {
        printf ("%s", tmp->bname);
    }

    LL_FOREACH_SAFE (head, elt, tmp) {
        LL_DELETE (head, elt);
    }
    fclose (file);
    return 0;
}
