/* llist.h: a CPP-based template implementation of singly-linked list */

#ifndef LLIST_H_INCLUDED
#define LLIST_H_INCLUDED

#include <stdlib.h>

#define LLIST_PROTO(T, N) \
	typedef struct N##_pair N##_pair; \
	typedef struct N N; \
	typedef struct N##_iterator N##_iterator; \
	N *N##_new(void); \
	void N##_free(N *s); \
	N##_pair *N##_pair_new(T item); \
	int N##_size(const N *s); \
	int N##_insert(N *s, T item, int pos); \
	T N##_pop(N *s, int pos); \
	T N##_get(const N *s, int pos); \
	void N##_set(N *s, T item, int pos); \
	N##_iterator N##_iterate(const N *s); \
	int N##_next(const N *s, N##_iterator *iter); \
	T N##_get_at(const N *s, N##_iterator iter); \
	void N##_set_at(N *s, T item, N##_iterator iter); \
	int N##_insert_at(N *s, T item, N##_iterator iter); \
	T N##_pop_at(N *s, N##_iterator iter)

#define LLIST(T, N) \
	struct N##_pair { T car; N##_pair *cdr; }; \
	struct N { int len; N##_pair *first; N##_pair *last; }; \
	struct N##_iterator { N##_pair *prev; N##_pair *curr; }; \
	N *N##_new(void) \
	{ \
		N *s; \
		s = malloc(sizeof(struct N)); \
		if (!s) return NULL; \
		s->len = 0; \
		s->first = NULL; \
		s->last = NULL; \
		return s; \
	} \
	void N##_free(N *s) \
	{ \
		N##_pair *p, *temp; \
		temp = NULL; \
		for (p=s->first; p; ) { \
			temp = p; \
			p = p->cdr; \
			free(temp); \
		} \
		free(s); \
	} \
	N##_pair *N##_pair_new(T item) \
	{ \
		N##_pair *p; \
		p = malloc(sizeof(struct N##_pair)); \
		if (!p) return NULL; \
		p->car = item; \
		p->cdr = NULL; \
		return p; \
	} \
	int N##_size(const N *s) \
	{ \
		return s->len; \
	} \
	int N##_insert(N *s, T item, int pos) \
	{ \
		int i; \
		N##_pair *newp, *p; \
		newp = N##_pair_new(item); \
		if (!newp) return 0; \
		if (!s->first) { \
			s->first = s->last = newp; \
			++s->len; \
			return 1; \
		} \
		if (pos < 0 || pos == s->len) { \
			s->last->cdr = newp; \
			s->last = newp; \
			++s->len; \
			return 1; \
		} \
		if (pos == 0) { \
			newp->cdr = s->first; \
			s->first = newp; \
			++s->len; \
			return 1; \
		} \
		for (p=s->first, i=0; i<pos-1 && p; ++i) p=p->cdr; \
		if (!p) { \
			free(newp); \
			return 0; \
		} \
		newp->cdr = p->cdr; \
		p->cdr = newp; \
		++s->len; \
		if (!newp->cdr || p == s->last) { \
			s->last = newp; \
		} \
		return 1; \
	} \
	T N##_pop(N *s, int pos) \
	{ \
		N##_pair *p, *p2; \
		T temp; \
		int i; \
		if (pos == 0) { \
			p = s->first; \
			s->first = p->cdr; \
			temp = p->car; \
			if (!p->cdr) s->last = NULL; \
			free(p); \
			--s->len; \
			return temp; \
		} \
		if (pos < 0) { \
			pos = s->len - 1; \
		} \
		for (p=s->first, i=0; i<pos-1 && p; ++i) p=p->cdr; \
		temp = p->cdr->car; \
		p2 = p->cdr; \
		p->cdr = p2->cdr; \
		if (!p->cdr) { \
			s->last = p; \
		} \
		free(p2); \
		--s->len; \
		return temp; \
	} \
	T N##_get(const N *s, int pos) \
	{ \
		int i; \
		N##_pair *p; \
		if (pos == 0) { \
			return s->first->car; \
		} \
		if (pos < 0) { \
			return s->last->car; \
		} \
		for (p=s->first, i=0; i<pos && p; ++i) p=p->cdr; \
		return p->car; \
	} \
	void N##_set(N *s, T item, int pos) \
	{ \
		int i; \
		N##_pair *p; \
		if (pos == 0) { \
			s->first->car = item; \
		} else if (pos < 0) { \
			s->last->car = item; \
		} else { \
			for (p=s->first, i=0; i<pos && p; ++i) p=p->cdr; \
			p->car = item; \
		} \
	} \
	N##_iterator N##_iterate(const N *s) \
	{ \
		N##_iterator iter = {NULL, NULL}; \
		return iter; \
	} \
	int N##_next(const N *s, N##_iterator *iter) \
	{ \
		if (!iter->curr) { \
			iter->curr = s->first; \
			return 1; \
		} \
		if (!iter->curr->cdr) { \
			return 0; \
		} \
		iter->prev = iter->curr; \
		iter->curr = iter->curr->cdr; \
		return 1; \
	} \
	T N##_get_at(const N *s, N##_iterator iter) \
	{ \
		return iter.curr->car; \
	} \
	void N##_set_at(N *s, T item, N##_iterator iter) \
	{ \
		iter.curr->car = item; \
	} \
	int N##_insert_at(N *s, T item, N##_iterator iter) \
	{ \
		N##_pair *newp; \
		newp = N##_pair_new(item); \
		if (!newp) return 0; \
		++s->len; \
		newp->cdr = iter.curr; \
		if (!iter.prev) { \
			s->first = newp; \
		} else { \
			iter.prev->cdr = newp; \
		} \
		return 1; \
	} \
	T N##_pop_at(N *s, N##_iterator iter) \
	{ \
		T val; \
		--s->len; \
		if (!iter.prev) { \
			s->first = iter.curr->cdr; \
		} else { \
			iter.prev->cdr = iter.curr->cdr; \
		} \
		if (s->last == iter.curr) s->last = iter.prev; \
		val = iter.curr->car; \
		free(iter.curr); \
		return val; \
	} \
	struct N /* to avoid extra semicolon outside of a function */

#endif /* ifndef LLIST_H_INCLUDED */
