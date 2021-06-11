#ifndef STACK_INCLUDE
#define STACK_INCLUDE

#define T stack_t

typedef struct T *T;


extern T        stack_new(void);
extern int      stack_empty(T stk);
extern ssize_t  stack_length(T stk);
extern void     stack_free(T *stk);

extern void     stack_push(T stk, void *x);
extern void    *stack_pop(T stk);
extern void    *stack_peek(T stk);

#undef T
#endif /*STACK_INCLUDE*/
