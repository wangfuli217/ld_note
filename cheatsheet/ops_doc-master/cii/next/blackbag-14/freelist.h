#ifndef FREELIST_INCLUDED
#define FREELIST_INCLUDED

typedef struct freelist_s freelist_t;

/*
 * quick and dirty pool allocator (wraps arena for very fast
 * allocation, prepends a list pointer to each allocation to
 * maintain a freelist to recycle elements).
 *
 * for small, fixed-sized allocations, freelists are *much* 
 * faster than malloc; since all allocations come out of big
 * chunks of malloc memory, they can also be fairly memory 
 * efficient.
 *
 * don't abuse. none of the memory that a freelist allocates is
 * ever returned via free(). 
 */

freelist_t *freelist_new(size_t eltsz, size_t hint);

void       *freelist_get(freelist_t *f);
void       *freelist_get0(freelist_t *f);

size_t      freelist_get_size(freelist_t* f);
void        freelist_free(freelist_t *f, void **elt);

void        freelist_release(freelist_t **f);

#endif
