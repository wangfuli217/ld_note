#ifndef SLIST_INCLUDED
#define SLIST_INCLUDED

#include "utils.h"

BEGIN_DECLS

#define T SList_T
typedef struct T *T;

struct T {
	T rest;
	void *first;
};

#define SList_list(...) SList_listx(__VA_ARGS__, NULL)

extern T        SList_new         ();
extern T        SList_append      (T list, T tail);
extern T        SList_copy        (T list);
extern T        SList_listx       (void *x, ...);
extern T        SList_pop_front   (T list, void **x);
extern T        SList_push_front  (T list, void *x);
extern T        SList_reverse     (T list);
extern unsigned SList_length      (T list);
extern void     SList_free        (T *list);
extern void     SList_map         (T list, void apply(void **x, void *cl), void *cl);
extern void **  SList_toArray     (T list, void *end);
extern int      SList_find        (T list, int(*pred)(void**x, void* cl), void* cl, void** ret);

END_DECLS

#undef T
#endif
