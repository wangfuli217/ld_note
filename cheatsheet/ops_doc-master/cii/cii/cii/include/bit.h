#ifndef BIT_INCLUDE
#define BIT_INCLUDE

#define T bit_t

typedef struct T *T;


extern  T       bit_new     (ssize_t length);
extern  ssize_t bit_length  (T bset);
extern  ssize_t bit_count   (T bset);

extern  void    bit_free    (T *bset);

extern  int     bit_get     (T bset, ssize_t position);
extern  int     bit_put     (T bset, ssize_t position, int bit);

extern  void    bit_clear   (T bset, ssize_t low, ssize_t high);
extern  void    bit_set     (T bset, ssize_t low, ssize_t high);
extern  void    bit_not     (T bset, ssize_t low, ssize_t high);

extern  int     bit_lt      (T s, T t);
extern  int     bit_eq      (T s, T t);
extern  int     bit_leq     (T s, T t);

extern  void    bit_map     (T bset,
                                void (*apply)(ssize_t position, int bit, void *cl),
                                void *cl);

extern T        bit_union   (T s, T t);
extern T        bit_inter   (T s, T t);
extern T        bit_minus   (T s, T t);
extern T        bit_diff    (T s, T t);

#undef T
#endif /*BIT_INCLUDE*/
