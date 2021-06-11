#include <stdarg.h>
#include <stddef.h>
#include <assert.h>
#include "mem.h"
#include "list.h"

List List_push(List list, void *x) {
	List p;
	NEW(p);
	p->first = x;
	p->rest  = list;
	return p;
}
List List_list(void *x, ...) {
	va_list ap;
	List list, *p = &list;
	va_start(ap, x);
	for ( ; x; x = va_arg(ap, void *)) {
		NEW(*p);
		(*p)->first = x;
		p = &(*p)->rest;
	}
	*p = NULL;
	va_end(ap);
	return list;
}
List List_append(List list, List tail) {
	List *p = &list;
	while (*p)
		p = &(*p)->rest;
	*p = tail;
	return list;
}
List List_copy(List list) {
	List head, *p = &head;
	for ( ; list; list = list->rest) {
		NEW(*p);
		(*p)->first = list->first;
		p = &(*p)->rest;
	}
	*p = NULL;
	return head;
}
List List_pop(List list, void **x) {
	if (list) {
		List head = list->rest;
		if (x)
			*x = list->first;
		FREE(list);
		return head;
	} else
		return list;
}
List List_reverse(T list) {
	T head = NULL, next;
	for ( ; list; list = next) {
		next = list->rest;
		list->rest = head;
		head = list;
	}
	return head;
}
int List_length(T list) {
	int n;
	for (n = 0; list; list = list->rest)
		n++;
	return n;
}
void List_free(T *list) {
	T next;
	assert(list);
	for ( ; *list; *list = next) {
		next = (*list)->rest;
		FREE(*list);
	}
}
void List_map(T list,
	void apply(void **x, void *cl), void *cl) {
	assert(apply);
	for ( ; list; list = list->rest)
		apply(&list->first, cl);
}
void **List_toArray(T list, void *end) {
	int i, n = List_length(list);
	void **array = ALLOC((n + 1)*sizeof (*array));
	for (i = 0; i < n; i++) {
		array[i] = list->first;
		list = list->rest;
	}
	array[i] = end;
	return array;
}
