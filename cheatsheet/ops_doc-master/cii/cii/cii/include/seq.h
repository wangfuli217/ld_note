#ifndef SEQ_INCLUDE
#define SEQ_INCLUDE

#define T seq_t

typedef struct T *T;

extern T        seq_new(ssize_t hint);
extern T        seq_seq(void *x, ...);

extern void     seq_free(T *seq);
extern ssize_t  seq_length(T seq);

extern void    *seq_get(T seq, ssize_t position);
extern void    *seq_put(T seq, ssize_t position, void *x);

extern void    *seq_add_low(T seq, void *x);
extern void    *seq_add_high(T seq, void *x);

extern void    *seq_remove_low(T seq);
extern void    *seq_remove_high(T seq);

#undef T

#endif /*SEQ_INCLUDE*/
