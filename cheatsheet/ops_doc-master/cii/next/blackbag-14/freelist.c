#include "firebert.h"
#include "freelist.h"
#include "arena.h"

struct freelist_s {
	arena_t *a;
	size_t s;
	void *f;
};

static void _alloc(freelist_t *f);
static void *_get(freelist_t *f);

/* ------------------------------------------------------------ */

freelist_t *
freelist_new(size_t el, size_t hint) {
	int i = 0;
	freelist_t *f = malloc(sizeof(*f));

	f->a = arena_new();
	f->s = el;
	f->f = NULL;	

	for(i = 0; i < hint; i++) 
		_alloc(f);

	return(f);
}

/* ------------------------------------------------------------ */

static void
_alloc(freelist_t *f) {
	void *block = arena_alloc(f->a, sizeof(block) + f->s);

	*(void **)block = f->f;
	f->f = block;
}

/* ------------------------------------------------------------ */

static void *
_get(freelist_t *f) {
	void *ret = NULL;

	assert(f->f);

	ret = f->f;
	f->f = *(void **)f->f;
	return(ret);
}

/* ------------------------------------------------------------ */

void *
freelist_get(freelist_t *f) {
	u_char *ret = NULL;

	if(!f->f) _alloc(f);

	ret = _get(f);
	ret += sizeof(ret);	       
	
	return(ret);	       
}

/* ------------------------------------------------------------ */

void *
freelist_get0(freelist_t *f) {
	void *ret = freelist_get(f);
	memset(ret, 0, f->s);
	return(ret);
}

/* ------------------------------------------------------------ */

size_t
freelist_get_size(freelist_t *f) {
        return (f->s);
}

/* ------------------------------------------------------------ */

void
freelist_free(freelist_t *f, void **ep) {
	u_char *e = *ep;
	
	e -= sizeof(e);
	*(void **)e = f->f;
	f->f = e;

	*ep = NULL;
}

/* ------------------------------------------------------------ */

void
freelist_release(freelist_t **fp) {
	freelist_t *f = *fp;
	*fp = NULL;

	arena_release(&f->a);
	free(f);
}

