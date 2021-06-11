#include "cons.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "arena.h"

static struct freelist {
	cons_t *cp;
	struct freelist *prev;
} *Freelist = NULL;

struct arena {
	struct arena *prev;
	char *avail;
	char *limit;
};

static size_t NFree = 0;

int _consifree(void);
int _consifree(void) { return(NFree); } 

static arena_t *Arena = NULL;

/* -------------------------------------------------- */

/* XXX: depends on arena internals.  
 * 
 * In particular, an individual arena_t has an available pool (avail),
 * an pointer to the end of the avail pool (limit), and a pointer to
 * another arena (prev).  What's important is that the avail pool for
 * an arena_t is data just after the arena_t header at prev.  So, to
 * check whether something is in an arena_t, you walk the arena chain,
 * checking to see if the pointer you're looking for is between
 * cur->prev and cur->limit (since that's the continuous chunk).  If
 * not, you move on to prev, and keep checking in that manner.
 *
 * When you reach the end of the chain, prev and limit are both 0, so
 * the check fails, and then the for loop terminates.
 */
static int
isfromarena(arena_t *h, void *x) {
	arena_t *np = NULL;

	for(np = h; np; np = np->prev) {
		if(x > (void*)np->prev && x < (void*)np->limit)
			break;
	}

	return(np == NULL ? 0 : 1);
}

/* -------------------------------------------------- */

cons_t *
cons(void *car, void *cdr) {
	cons_t *ret = NULL;

	if(!Arena)
		Arena = arena_new();

	if(Freelist) {
		ret = Freelist->cp;
		Freelist = Freelist->prev;
		NFree -= 1;
	} else {
		struct freelist *fp = NULL;
		ret = arena_alloc(Arena, sizeof(*ret) * 2);		
		fp = (struct freelist *) &ret[1];
		fp->cp = ret;
	}

	assert(ret || !"managed allocation failed");

	ret->car = car;
	ret->cdr = cdr;

	return(ret);
}

/* -------------------------------------------------- */

cons_t *
consi(int car, int cdr) {
	return(cons((void*)car, (void*)cdr));
}

/* -------------------------------------------------- */

cons_t *
consu(u_int32_t car, u_int32_t cdr) {
	return(cons((void*)car, (void*)cdr));
}

/* -------------------------------------------------- */

int
cari(cons_t *c) {
	return((int)c->car);
}

/* -------------------------------------------------- */

int 
cdri(cons_t *c) {
	return((int)c->cdr);
}

/* -------------------------------------------------- */

u_int32_t
caru(cons_t *c) {
	return((u_int32_t)c->car);
}

/* -------------------------------------------------- */

u_int32_t
cdru(cons_t *c) {
	return((u_int32_t)c->cdr);
}

/* -------------------------------------------------- */

cons_t *
consic(int car, void *cdr) {
	return(cons((void*)car, cdr));
}

/* -------------------------------------------------- */

cons_t *
consuc(u_int32_t car, void *cdr) {
	return(cons((void*)car, cdr));
}

/* -------------------------------------------------- */

cons_t
cons_release(cons_t *c) {
	cons_t cl = *c;
	struct freelist *fp = (struct freelist *) &c[1];
	fp->prev = Freelist;
	Freelist = fp;
	NFree += 1;
	return(cl);
}

/* -------------------------------------------------- */

cons_t *
codr(cons_t *c) {
	return((cons_t *)c->cdr);
}

/* -------------------------------------------------- */

cons_t *
coar(cons_t *c) {
	return((cons_t *)c->car);
}

/* -------------------------------------------------- */

void *
car(cons_t *c) {
	return(c->car);
}

/* -------------------------------------------------- */

void *
cdr(cons_t *c) {
	return(c->cdr);
}

/* -------------------------------------------------- */

void *
cadr(cons_t *c) {
	return(codr(c)->car);
}

/* -------------------------------------------------- */

void *
caadr(cons_t *c) {
	return(codr(codr(c))->car);
}

/* -------------------------------------------------- */

int
consp(void *c) {
	return(isfromarena(Arena, c));
}

/* -------------------------------------------------- */

int
consarp(cons_t *c) {
	return(consp(c->car));
}

/* -------------------------------------------------- */

int
consdrp(cons_t *c) {
	return(consp(c->cdr));
}

/* -------------------------------------------------- */

void *
consnth(cons_t *c, size_t n) {
	unsigned i = 0;

	for(i = 0; i < n; i++) {
		if(consp(cdr(c))) {
			c = cdr(c);
		} else
			break;
	}	

	if(i == n)
		return(car(c));

	return(NULL);
}

/* -------------------------------------------------- */

cons_t *
consnthc(cons_t *c, size_t n) {
	unsigned i = 0;

	for(i = 0; i < n; i++) {
		if(consp(cdr(c))) {
			c = cdr(c);
		} else
			break;
	}	

	if(i == n)
		return(cdr(c));

	return(NULL);
}

/* -------------------------------------------------- */

void
cons_unravel(cons_t *c) {
	if(consp(c)) 
		cons_unravel(cons_release(c).cdr);
}

/* -------------------------------------------------- */


