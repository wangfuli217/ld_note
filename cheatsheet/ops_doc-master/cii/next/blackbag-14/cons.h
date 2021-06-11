#ifndef CONS_H
#define CONS_H

/* 
 * Lisp-like cons-cell list implementation, with managed
 * allocation. This is cheaper-time than slist, slightly
 * more expensive-space than slist, and less structured. I
 * added this because using formal slists for callback data
 * is too cumbersome, using pair_t's is too limiting, and
 * the per-callback malloc() just creeps me out.
 *
 * This whole library is an expiriment I've used exactly once
 * and is probably a mistake.
 */

#include <sys/types.h>

typedef struct cons_s {
	void *car;
	void *cdr;
} cons_t;

/* a cons cell is a "first" ("car") and a "second" ("cdr")
 * element. A list of cons cells has a value (or pointer-to-
 * value) in its "car" and a pointer-to-cons in its "cdr".
 */
cons_t *cons(void *car, void *cdr);

/* Embed integers in cons cells. This is a hackish thing to
 * do in slists, but one of the rationales for having cons
 * cells to begin with. NB: see caveats for "consp".
 */
cons_t *consi(int car, int cdr);
cons_t *consu(u_int32_t car, u_int32_t cdr);

/* Like consi/consu, but utilities for constructing cons lists
 * instead of simple pairs-of-integers.
 */
cons_t *consic(int car, void *cdr);
cons_t *consuc(u_int32_t car, void *cdr);

/* Retrieve cons cells from "cdr" (the common case) or "car"
 * (much less common) without casting. car(codr(c)) is idiomatic.
 */
cons_t *codr(cons_t *c);
cons_t *coar(cons_t *c);

/* Retrieve car and cdr. 
 */
void   *car(cons_t *c);
void   *cdr(cons_t *c);

/* Retrieve them as integer values without casting. 
 */
int	cari(cons_t *c);
int     cdri(cons_t *c);
u_int32_t caru(cons_t *c);
u_int32_t cdru(cons_t *c);

/* Retrieve the value one, or two, "hops" into a cons list.
 * Read as: "car of cdr" or "car of car of cdr".
 */
void   *cadr(cons_t *c);
void   *caadr(cons_t *c);

/* Is the pointer, or car of the cons, or cdr of the cons,
 * itself a cons? This is somewhat expensive (2-3 pointer
 * dereferences and 6-8 integer compares in a typical application
 * under load), so the library doesn't do it automatically.
 *
 * NB: if you are embedding integers-as-pointers with "consi"
 *     or "consic", there is a small but realistic chance that
 *     you could confuse these routines --- your integers might
 *     alias to addresses on the heap. For instance, an IP
 *     address like "240.224.1.0" resembles an OpenBSD heap
 *     address.
 */
int     consp(void *c);
int     consarp(cons_t *c);
int     consdrp(cons_t *c);

/* Assuming (at your peril) that the cons chain is in fact
 * a lisp-like cons list (chained conses), get the nth element
 * from point in the list you're at, or NULL if you walk off
 * the end.
 */
void   *consnth(cons_t *c, size_t n);

/* get the chaining cons cell, instead of the car-data 
 */
cons_t *consnthc(cons_t *c, size_t n);

/* With the same assumption as above, release a whole cons 
 * list.
 */
void    cons_unravel(cons_t *c);

/* Release an allocated cons back to the memory manager, returning
 * the cons as a temporary.
 */
cons_t  cons_release(cons_t *c);

#endif
