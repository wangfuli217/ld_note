#include<stdio.h>
#include<stdlib.h>
#include"dlist.h"

static
void
print(void **x, void *cl)
{
    FILE *fp = cl;
    char *str = (char *)*x;
    fprintf(cl, "%s\n", str);
}

/*
extern T        dlist_append     (T dlist, T dtail);    check
extern T        dlist_copy       (T dlist);             check
extern T        dlist_list       (void *x, ...);        check
extern T        dlist_pop        (T dlist, void **x);   check
extern T        dlist_push       (T dlist, void *x);    check
extern T        dlist_reverse    (T dlist);
extern int      dlist_length     (T dlist);             check
extern void     dlist_free       (T *dlist);            check
extern void     dlist_map        (T dlist,              check
                                void (*apply)(void **x, void *cl), 
                                void *cl);
extern void   **dlist_to_array   (T dlist, void *end);
*/

int
main(int argc, char *argv[])
{
    char *pop_item;
    char **array;
    int len, index;
    dlist_t dlist, tail = NULL;
    dlist = dlist_list("aaa", "bbb", "ccc", "ddd", NULL);
    len = dlist_length(dlist);
    dlist_map(dlist, print, stdout);

    printf("-------------------------------\n");

    tail = dlist_push(tail, "wtf");
    dlist = dlist_append(dlist, tail);
    dlist_map(dlist, print, stdout);

    printf("-------------------------------\n");

    dlist = dlist_reverse(dlist);
    dlist_map(dlist, print, stdout);
    
    printf("-------------------------------\n");

    dlist_free(&tail);
    tail = dlist_copy(dlist);
    dlist_map(tail, print, stdout);

    printf("-------------------------------\n");

    tail = dlist_pop(tail, (void**)&pop_item);
    printf("pop from tail got:%s\n", pop_item);
    dlist_map(tail, print, stdout);

    printf("-------------------------------\n");

    array = (char **)dlist_to_array(tail, NULL);
    for(index = 0; array[index]; index++){
        printf("array[%d]=%s\n", index, array[index]);
    }
}
