#include<stdio.h>
#include<stdlib.h>
#include"list.h"

static
void
print(void **x, void *cl)
{
    FILE *fp = cl;
    char *str = (char *)*x;
    fprintf(cl, "%s\n", str);
}
/*
extern T        list_append     (T list, T tail);      check
extern T        list_copy       (T list);              check
extern T        list_list       (void *x, ...);        check
extern T        list_pop        (T list, void **x);    check
extern T        list_push       (T list, void *x);     check
extern T        list_reverse    (T list);              check
extern int      list_length     (T list);              check
extern void     list_free       (T *list);             check
extern void     list_map        (T list,               check
                                void (*apply)(void **x, void *cl), 
                                void *cl);
extern void   **list_to_array   (T list, void *end);   check
*/

int
main(int argc, char *argv[])
{
    char *pop_item;
    char **array;
    int len, index;
    list_t list, tail = NULL;
    list = list_list("agc", "GAE", "SAE", "JVM", NULL);
    list_map(list, print, stdout);

    tail = list_push(tail, "wtf");
    list_append(list, tail);
    list_map(tail, print, stdout);

    list = list_reverse(list);
    list_free(&tail);
    tail = list_copy(list);
    list_map(tail, print, stdout);
    len = list_length(tail);
    printf("length of tail:%d\n", len);

    for(index = 0; index < len; index++){
        tail = list_pop(tail, (void**)&pop_item);
        printf("poped:%s\n", pop_item);
    }

    array = (char **)list_to_array(list, NULL);
    for(index = 0; array[index]; index++){
        printf("array[%d]=%s\n", index, array[index]);
    }
}
