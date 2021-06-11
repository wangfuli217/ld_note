#ifndef ROOT_FIND_INCLUDED
#define ROOT_FIND_INCLUDED

typedef double (*root_func) (double, void*);

extern int root_find_brackets(root_func func, void* env, double* x1, double* x2); 
extern double root_bisection(root_func func, void* env, double x1, double x2, double xacc) {

#endif