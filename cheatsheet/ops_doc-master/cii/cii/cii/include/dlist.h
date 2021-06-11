#ifndef DLIST_INCLUDE
#define DLIST_INCLUDE

#define T dlist_t

typedef struct T *T;

struct T{
    void *data;
    T prev, next;
};

extern T        dlist_append     (T dlist, T dtail);
extern T        dlist_copy       (T dlist);
extern T        dlist_list       (void *x, ...);
extern T        dlist_pop        (T dlist, void **x);
extern T        dlist_push       (T dlist, void *x);
extern T        dlist_reverse    (T dlist);
extern int      dlist_length     (T dlist);
extern void     dlist_free       (T *dlist);
extern void     dlist_map        (T dlist,
                                void (*apply)(void **x, void *cl), 
                                void *cl);
extern void   **dlist_to_array   (T dlist, void *end);


#undef T

#endif /*DLIST_INCLUDE*/
