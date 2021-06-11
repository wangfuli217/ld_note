#ifndef INDEXMINPQ_INCLUDE
#define INDEXMINPQ_INCLUDE

#define T iminpq_t

typedef struct T *T;

extern  T               iminpq_new          (int size);
extern  void            iminpq_free         (T *iminpq);
extern  void            iminpq_clean        (T iminpq);
extern  int             iminpq_size         (T iminpq);
extern  int             iminpq_count        (T iminpq);

extern  void            iminpq_change_key   (T iminpq, int i, double key);
extern  void            iminpq_decrease_key (T iminpq, int i, double key);
extern  void            iminpq_increase_key (T iminpq, int i, double key);
extern  int             iminpq_delete_min   (T iminpq);
extern  void            iminpq_delete       (T iminpq, int i);
extern  void            iminpq_insert       (T iminpq, int i, double key);

extern  int             iminpq_contains     (T iminpq, int i);
extern  int             iminpq_is_empty     (T iminpq);
extern  double          iminpq_key_of       (T iminpq, int i);
extern  int             iminpq_min_index    (T iminpq);
extern  double          iminpq_min_key      (T iminpq);

#undef T
#endif /*INDEXMINPQ_INCLUDE*/
