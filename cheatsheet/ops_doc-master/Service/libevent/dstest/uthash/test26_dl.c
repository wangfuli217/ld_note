#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
        DL_APPEND (head, name);
    }
    DL_SORT (head, namecmp);

    DL_FOREACH (head, elt) {
        printf ("%s", elt->bname);
    }

    memcpy (etmp.bname, "WES\n", 5UL);
    DL_SEARCH (head, elt, &etmp, namecmp);
    if (elt != NULL) {
        printf ("found %s\n", elt->bname);
    }

    printf ("deleting head %shead->prev: %s", head->bname, head->prev->bname);
    DL_DELETE (head, head);
    DL_FOREACH (head, tmp) {
        printf ("%s", tmp->bname);
    }

    DL_FOREACH_SAFE (head, elt, tmp) {
        DL_DELETE (head, elt);
    }
    fclose (file);
    return 0;
}
