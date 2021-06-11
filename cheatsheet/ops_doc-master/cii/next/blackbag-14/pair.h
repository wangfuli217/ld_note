#ifndef PAIR_INCLUDED
#define PAIR_INCLUDED

#include <stdlib.h>
#include <sys/types.h>

/* you will need this _all the time_, you just don't know it yet.
 * a pass-by-value 2-item tuple, originally used for hash table, but
 * overloaded like crazy elsewhere. PASS THESE BY VALUE, NOT BY 
 * REFERENCE (that's the point).
 */
typedef struct pair {
	void *key;
	void *value;
} pair_t;

/* this is basically struct iovec, but it's portable. PASS BY VALUE,
 * NOT BY REFERENCE.
 */
typedef struct iopair { 
	u_char *data;
	size_t len;
} iopair_t;

/* return-by-value args as iopair
 */
static __inline iopair_t iopair(void *d, size_t l) { 
	iopair_t p = { (u_char*)d, l };
	return(p);
}

static __inline iopair_t striopair(char *str) { 
	iopair_t p; p.data = (u_char*) strdup(str); p.len = strlen(str);
	return(p);
}

/* return-by-value a pair, as in, foo(pair(k, v)) if foo takes "pair"
 */
static __inline pair_t pair(void *k, void *v) {
	pair_t p = { k, v };
	return(p);
}

/* easy malloc-a-pair, though, don't malloc pairs.
 */
static __inline pair_t *mpair(void *k, void *v) {
	pair_t *p = malloc(sizeof(*p));
	p->key = k;
	p->value = v;
	return(p);
}

/* overload pointer field as int (convert int to ptr)
 */
static __inline void *v2p(u_int32_t val) {
	return((void*)val);
}

/* recover int from ptr. NB: these are not 64-clean.
 */
static __inline u_int32_t p2v(void *ptr) {
	return((u_int32_t)ptr);
}

static __inline void rmiopair(iopair_t p) {
	free(p.data);
	p.data = NULL;
	p.len = 0;	       
}

#endif
