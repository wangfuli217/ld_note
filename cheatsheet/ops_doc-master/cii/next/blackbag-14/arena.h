#ifndef ARENA_H
#define ARENA_H

/*
 *
 * From DRH LCC/C Interfaces and Implementations
 *
 * The arena allocator wraps standard malloc. It requests
 * memory in 10kB chunks and portions those chunks out to 
 * satisfy requests to _alloc() and _calloc(). 
 *
 * It is not possible to explicitly free memory obtained
 * from an arena. Because the arena does not maintain freelists
 * for every allocation you make, it is very, very fast.
 * 
 * It is possible to free ALL the memory EVER obtained from
 * a single arena, by calling arena_free(). arena_free()
 * leaves the arena data structure intact and ready to satisfy
 * future requests. If you will not need to use the arena 
 * again, arena_release() will also free the arena data
 * structure.
 *
 * This behavior not only speeds up malloc-bound code, but 
 * also provides a primitive form of garbage collection (by
 * deferring all your free()'s to one place, where they are
 * performed by calling arena_free()).
 */

typedef struct arena arena_t;

/* get a new arena. You can have as many of these as you want.
 * useful idea: associate an arena with every data type in your
 * code, and use an slist to keep an ad-hoc freelist of those
 * data types, for a fast and flexible "real" allocator.
 */
arena_t *arena_new(void);

/* release all storeage associated with an arena, NULL-ing the
 * pointer in the process. Use this when you are absolutely 
 * finished with an arena.
 */
void  arena_release(arena_t **ap);

/* obtain "nbytes" bytes from the arena, returning NULL if the
 * request can't be satisfied. If most of your allocations are
 * small, calls to arena_alloc() will very infrequently result
 * in calls to malloc(). Note that allocations larger than 10k
 * will ALWAYS result in calls to malloc(). 
 */
void *arena_alloc(arena_t *arena, long nbytes);

/* as with arena_alloc(), but with calloc() semantics. The
 * "memset()" in calloc() can get expensive!
 */
void *arena_calloc(arena_t *arena, long count, long nbytes);

/* arena_strdup, just like strdup, only in arena'd memory */
char *arena_strdup(arena_t *arena, const char *s);

/* collapse all the allocated memory in the arena, freeing
 * (almost) all of it, but leaving the arena ready to satisfy
 * future requests. The next call to arena_alloc() after this
 * will not result in a call to malloc().
 */
void  arena_free(arena_t *arena);

#endif /* ARENA_H */
