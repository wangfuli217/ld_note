#ifndef _LIST__H_
#define _LIST__H_

struct List_T
{
	struct List *rest;
	void   		*first;
}*List;

extern List List_append (List list, T tail);
extern List List_copy   (List list);
extern List List_list   (void *x, ...);
extern List List_pop    (List list, void **x);
extern List List_push   (List list, void *x);
extern List List_reverse(List list);
extern int    List_length (List list);
extern void   List_free   (List *list);
extern void   List_map    (List list,
						void apply(void **x, void *cl), void *cl);
extern void **List_toArray(List list, void *end);

#endif

