#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include "assert.h"
#include "arena.h"

#define THRESHOLD 10

struct arena {
	struct arena *prev;
	char *avail;
	char *limit;
};

union align {
	int i;
	long l;
	long *lp;
	void *p;
	void (*fp)(void);
	float f;
	double d;
	u_int64_t lll;
	char buf[16];
};

union header {
	struct arena_t *b;
	union align a;
};

/* This seems to scare people. Arena chunks are of fixed size
 * and thus shareable in between arenas; these are legitimate
 * variables! --- tqbf 5/2002
 */

static arena_t *freechunks;
static int nfree;

/* ------------------------------------------------------------ */

arena_t *
arena_new(void) {
	arena_t *arena = malloc(sizeof (*arena));
	assert(arena);

	arena->prev = NULL;
	arena->limit = arena->avail = NULL;
	return arena;
}

/* ------------------------------------------------------------ */

void
arena_release(arena_t **ap) {
	arena_t *a = *ap;
	*ap = NULL;

	if(a) {	
		arena_free(a);
		free(a);
	}
}

/* ------------------------------------------------------------ */

void *
arena_alloc(arena_t *arena, long nbytes) {
	assert(arena);
	assert(nbytes > 0);
	nbytes = ((nbytes + sizeof (union align) - 1)/
		(sizeof (union align)))*(sizeof (union align));
	while (nbytes > arena->limit - arena->avail) {
		arena_t *ptr;
		char *limit;
		if ((ptr = freechunks) != NULL) {
			freechunks = freechunks->prev;
			nfree--;
			limit = ptr->limit;
		} else {
			long m = sizeof (union header) + nbytes + 10*1024;
			ptr = malloc(m);
			assert(ptr);
			limit = (char *)ptr + m;
		}

		*ptr = *arena;
		arena->avail = (char *)((union header *)ptr + 1);
		arena->limit = limit;
		arena->prev  = ptr;
	}

	arena->avail += nbytes;
	return arena->avail - nbytes;
}

/* ------------------------------------------------------------ */

char *
arena_strdup(arena_t *arena, const char *s)
{
	char *ret;
	size_t len = strlen(s) + 1;

	ret = arena_alloc(arena, len);
	memmove(ret, s, len);

	return (ret);
}

/* ------------------------------------------------------------ */

u_char *
arena_bufdup(arena_t *arena, const u_char *b, size_t l) {
	u_char *ret = arena_alloc(arena, l);
	memcpy(ret, b, l);
	return(ret);
}

/* ------------------------------------------------------------ */

void *
arena_calloc(arena_t *arena, long count, long nbytes) {
	void *ptr;
	assert(count > 0);
	ptr = arena_alloc(arena, count*nbytes);
	memset(ptr, '\0', count*nbytes);
	return ptr;
}

/* ------------------------------------------------------------ */

void
arena_free(arena_t *arena) {
	assert(arena);
	while (arena->prev) {
		arena_t tmp = *arena->prev;
		if (nfree < THRESHOLD) {
			arena->prev->prev = freechunks;
			freechunks = arena->prev;
			nfree++;
			freechunks->limit = arena->limit;
		} else
			free(arena->prev);
		*arena = tmp;
	}
	assert(arena->limit == NULL);
	assert(arena->avail == NULL);
}
