#ifndef SET_INCLUDE
#define SET_INCLUDE

#define T set_t

typedef struct T *T;

extern T        set_new     (int hint,
                            int cmp(const void *x, const void *y),
                            unsigned long hash(const void *x));
extern void     set_free    (T *set);


extern int      set_length  (T set);
extern int      set_member  (T set, const void *member);
extern void     set_put     (T set, const void *member);
extern void    *set_remove  (T set, const void *member);

extern void     set_map     (T set,
                            void (*apply)(const void *member, void *cl),
                            void *cl);
extern void   **set_to_array(T set, void *end);


extern T        set_union   (T s, T t);
extern T        set_inter   (T s, T t);
extern T        set_minus   (T s, T t);
extern T        set_diff    (T s, T t);

#undef T

#endif /*SET_INCLUDE*/
