#ifndef LIST_INCLUDE
#define LIST_INCLUDE

#define T list_t

typedef struct T *T;

struct T{
    T rest;
    void *first;
};

extern T        list_append     (T list, T tail);
extern T        list_copy       (T list);
extern T        list_list       (void *x, ...);
extern T        list_pop        (T list, void **x);
extern T        list_push       (T list, void *x);
extern T        list_reverse    (T list);
extern int      list_length     (T list);
extern void     list_free       (T *list);
extern void     list_map        (T list,
                                void (*apply)(void **x, void *cl), 
                                void *cl);
extern void   **list_to_array   (T list, void *end);


#undef T

#endif /*LIST_INCLUDE*/
