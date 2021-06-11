/* alist.h: a CPP-based template implementation of array lists (resizable array) */

#ifndef ALIST_H_INCLUDED
#define ALIST_H_INCLUDED

#include <stdlib.h>

#define ALIST_PROTO(T, N) \
	typedef struct N N; \
	typedef int N##_iterator; \
	N *N##_new(void); \
	N *N##_new_cap(int size); \
	void N##_free(N *s); \
	int N##_size(const N *s); \
	int N##_insert(N *s, T item, int pos); \
	T N##_pop(N *s, int pos); \
	T N##_get(const N *s, int pos); \
	void N##_set(N *s, T item, int pos); \
	int N##_resize(N *s, int size); \
	N##_iterator N##_iterate(const N *s); \
	int N##_next(const N *s, N##_iterator *iter); \
	T N##_get_at(const N *s, N##_iterator iter); \
	void N##_set_at(N *s, T item, N##_iterator iter); \
	int N##_insert_at(N *s, T item, N##_iterator iter); \
	T N##_pop_at(N *s, N##_iterator iter)

/* defines functions for an arraylist with elements of type T named N */
#define ALIST(T, N) \
	struct N { int cap; int len; T *arr; }; \
	const int N##_sizeof_element = sizeof(T); \
	N *N##_new(void) \
	{ \
		return N##_new_cap(8); \
	} \
	N *N##_new_cap(int size) \
	{ \
		N *s; \
		s = malloc(sizeof(struct N)); \
		if (!s) return NULL; \
		s->cap = size; \
		s->len = 0; \
		s->arr = malloc(size * N##_sizeof_element); \
		if (!s->arr) { free(s); return NULL; } \
		return s; \
	} \
	void N##_free(N *s) \
	{ \
		free(s->arr); \
		free(s); \
	} \
	int N##_size(const N *s) \
	{ \
		return s->len; \
	} \
	int N##_insert(N *s, T item, int pos) \
	{ \
		T *temp; \
		int i; \
		if (s->len >= s->cap) { \
			temp = realloc(s->arr, s->cap*1.5*N##_sizeof_element); \
			if (!temp) return 0; \
			s->arr = temp; \
			s->cap *= 1.5; \
		} \
		if (pos >= 0 && pos != s->len) { \
			for (i=s->len; i>pos; --i) { \
				s->arr[i] = s->arr[i-1]; \
			} \
		} \
		s->arr[pos<0?s->len:pos] = item; \
		s->len++; \
		return 1; \
	} \
	T N##_pop(N *s, int pos) \
	{ \
		T temp; \
		int i; \
		if (pos < 0) return s->arr[s->len-1]; \
		temp = s->arr[pos]; \
		for (i=pos; i<s->len-1; ++i) { \
			s->arr[i] = s->arr[i+1]; \
		} \
		--s->len; \
		return temp; \
	} \
	T N##_get(const N *s, int pos) \
	{ \
		return s->arr[pos<0||pos>=s->len?s->len-1:pos]; \
	} \
	void N##_set(N *s, T item, int pos) \
	{ \
		s->arr[pos<0||pos>=s->len?s->len-1:pos] = item; \
	} \
	int N##_resize(N *s, int size) \
	{ \
		T *temp; \
		temp = realloc(s->arr, size*N##_sizeof_element); \
		if (!temp) return 0; \
		s->arr = temp; \
		if (size < s->len) s->len = size; \
		s->cap = size; \
		return 1; \
	} \
	N##_iterator N##_iterate(const N *s) \
	{ \
		return -1; \
	} \
	int N##_next(const N *s, N##_iterator *iter) \
	{ \
		if (*iter < 0) { \
			++*iter; \
			return s->len > 0; \
		} \
		if (*iter >= s->len-1) { \
			return 0; \
		} \
		++*iter; \
		return 1; \
	} \
	T N##_get_at(const N *s, N##_iterator iter) \
	{ \
		return s->arr[iter]; \
	} \
	void N##_set_at(N *s, T item, N##_iterator iter) \
	{ \
		s->arr[iter] = item; \
	} \
	int N##_insert_at(N *s, T item, N##_iterator iter) \
	{ \
		return N##_insert(s, item, iter); \
	} \
	T N##_pop_at(N *s, N##_iterator iter) \
	{ \
		return N##_pop(s, iter); \
	} \
	struct N /* to avoid extra semicolon outside of a function */

#endif /* ifndef ALIST_H_INCLUDED */
