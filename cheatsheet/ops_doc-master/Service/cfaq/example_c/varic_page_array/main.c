#include <stdio.h>

typedef unsigned long unit_t; 

#define __NEW_PAGE__(p, sz) do {								\
	p = (shared_page_t*)malloc(sizeof(shared_page_t));			\
	if (p) {													\
		p->us = (unit_t*)malloc(sizeof(unit_t*) * sz);			\
		p->sz = 0;												\
		if (p->us) {											\
			p->sz = sz;											\
		}														\
	}															\
} while (0)

#define __DEL_PAGE__(p) do {
	if (p) {
		free(p->us);
		p->us = NULL;
		p->sz = p->idx = 0;
	}
	free(p);
	p = NULL;
} while (0)

typedef struct shared_page_s shared_page_t;
struct shared_page_s {
	unsigned int sz;
	unsigned int idx;
	unit_t *us;
};

#define __NEW_ARRAY__(p, sz) do {
	p = (shared_array_t*)malloc(sizeof(shared_array_t));
	if (p) {
		p->sz = p->idx = 0;
		p->pgs = (shared_page_t**)malloc(sizeof(shared_page_t*) * sz);
		if (p->pgs) {
			p->sz = sz;
		}
	}
} while (0)

typedef struct shared_arrary_s shared_array_t;
struct shared_array_s {
	unsigned long 	sz;
	unsigned long   idx;
	shared_page_t 	**pgs;
};


int main(int argc, char **argv)
{
	printf("hello world\n");
	return 0;
}
