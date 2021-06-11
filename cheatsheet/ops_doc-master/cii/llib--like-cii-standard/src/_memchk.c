// Note that there are compiler / architecture specific tools/library that do this as
// http://msdn.microsoft.com/en-us/library/x98tx3cf%28v=vs.90%29.aspx
// http://valgrind.org/

#include <stdlib.h>
#ifndef NDEBUG /* Need this to be second to avoid a translation empty error in msvc */

#include <string.h> /* for memcpy */
#include <stdio.h> /* for printf */
#include <stdint.h>

#include "portable.h" /* for thread_local */
#include "assert.h"
#include "except.h"
#include "log.h"
#include "safeint.h"

#include "_mem.h"

union align {
#ifdef MAXALIGN
    char pad[MAXALIGN];
#else
    int i;
    long l;
    long *lp;
    void *p;
    void (*fp)(void);
    float f;
    double d;
    long double ld;
    long long ll;
#endif
};

#define hash(p, t) (((uintptr_t)(p)>>3) & (sizeof (t) / sizeof ((t)[0])-1))

#define NDESCRIPTORS 512

/* A space of 4096 or more bytes that is a multiple of sizeof (union align) */
#define NALLOC ((4096 + sizeof (union align) - 1) / (sizeof (union align)))*(sizeof (union align))

const Except_T Mem_Failed = { "Allocation Failed" };

#define max_hashed  2048

static thread_local  struct descriptor {
    struct descriptor *free;
    struct descriptor *link;
    void *ptr;
    size_t size;
    const char *file;
    int line;
} *htab[max_hashed];

static thread_local struct descriptor freelist;

static struct descriptor *find(const void *ptr) {
    struct descriptor *bp = htab[hash(ptr, htab)];

    while (bp && bp->ptr != ptr)
        bp = bp->link;
    return bp;
}

/* Guess: I cannot initialize this at the declaration side because freelist address
   is assigned at runtime given that it is thread_loocal */
inline static
void init_freelist() {
    if(freelist.free == NULL) freelist.free = &freelist;
}

void _Mem_free(void *ptr, const char *file, int line) {
    init_freelist();

    if (ptr) {
        struct descriptor *bp;

        /* Catches:
            . free on not aligned pointer (i.e. from middle of structure
            . free on pointer not given out with malloc
            . free pointer twice
        */
        unsigned is_not_aligned = ((size_t)ptr) % (sizeof (union align)) != 0;
        bp = find(ptr);
        if ( is_not_aligned || bp == NULL || bp->free)
            Except_raise(&Assert_Failed, file, line);

        bp->free = freelist.free;
        freelist.free = bp;

        log_dbg("%p freed", ptr);
    }
}

void *_Mem_realloc(void *ptr, size_t nbytes, const char *file, int line) {
    struct descriptor *bp;
    void *newptr;

    safe_size(nbytes);

    init_freelist();

    log_dbg("%p realloc %lu bytes", ptr, (unsigned long) nbytes);

    /* This is rather error prone, but it is needed to conform to realloc spec */
    if(!ptr)
        return _Mem_alloc(nbytes, file, line);

    /* This conforms to C90. In C99 it is left implementation dependent.*/
    if(!nbytes)
        _Mem_free(ptr, file, line);

    if (((size_t)ptr)%(sizeof (union align)) != 0 || (bp = find(ptr)) == NULL || bp->free)
        Except_raise(&Assert_Failed, file, line);

    newptr = _Mem_alloc(nbytes, file, line);
    memcpy(newptr, ptr, nbytes < bp->size ? nbytes : bp->size);
    _Mem_free(ptr, file, line);

    return newptr;
}

void *_Mem_calloc(size_t count, size_t nbytes, const char *file, int line) {
    void *ptr;

    init_freelist();

    safe_mul_sisi(count, nbytes);

    ptr = _Mem_alloc(count*nbytes, file, line);
    memset(ptr, '\0', count*nbytes);

    log_dbg("%p calloc %lu bytes", ptr, (unsigned long) nbytes);
    return ptr;
}

/* Initialize the avail descriptor in the list (allocates more if needed) */
static struct descriptor *dalloc(void *ptr, size_t size, const char *file, int line) {
    static struct descriptor *avail;
    static unsigned int nleft;

    init_freelist();

    if (nleft == 0) {
        avail = malloc(NDESCRIPTORS*sizeof (*avail));
        if (avail == NULL)
            return NULL;
        nleft = NDESCRIPTORS;
    }

    avail->ptr  = ptr;
    avail->size = size;
    avail->file = file;
    avail->line = line;
    avail->free = avail->link = NULL;
    assert(nleft > 0);
    nleft--;

    return avail++;
}

void *_Mem_alloc(size_t nbytes, const char *file, int line){
    struct descriptor *bp;
    void *ptr;

    safe_size(nbytes);

    init_freelist();

    /* Makes nbytes a multiple of the necessary alignment size */
    nbytes = ((nbytes + sizeof (union align) - 1) / (sizeof (union align))) * (sizeof (union align));

    for (bp = freelist.free; bp; bp = bp->free) {
        if (bp->size > nbytes) {
            /* Carves out a nbytes block at the end of the block, adds it to the list and returns it */
            bp->size -= nbytes;
            ptr = (char *)bp->ptr + bp->size;

            if ((bp = dalloc(ptr, nbytes, file, line)) != NULL) {
                size_t h = hash(ptr, htab);
                bp->link = htab[h];
                htab[h] = bp;
                return ptr;
            } else
                {
                    if (file == NULL)
                        RAISE(Mem_Failed);
                    else
                        Except_raise(&Mem_Failed, file, line);
                }
        }

        if (bp == &freelist) {
            struct descriptor *newptr;

            /* Malloc nbytes (correctly aligned) + a 4096 correctly aligned block and
               returns a pointer to a descriptor. It means that each allocation adds one more
               page in memory, so that it can satisfy requests for small blocks from this larger chunk.
            */
            if ((ptr = malloc(nbytes + NALLOC)) == NULL ||  (newptr = dalloc(ptr, nbytes + NALLOC,
                    __FILE__, __LINE__)) == NULL)
                {
                    if (file == NULL)
                        RAISE(Mem_Failed);
                    else
                        Except_raise(&Mem_Failed, file, line);
                }
            log_dbg("%p alloc %lu bytes", ptr, (unsigned long) nbytes + NALLOC);
            /* Add the block as the first one in the free list. It will be picked up in the next iteration. */
            newptr->free = freelist.free;
            freelist.free = newptr;
        }
    }

    assert(0);
    return NULL;
}

void _Mem_print_stats() {
    struct descriptor* bp;
    unsigned int i;
    unsigned found = 0;

    init_freelist();

    log_info("Allocated memory blocks (file:line size, ptr)");
    log_info("---------------------------------------------");

    for(i = 0; i < max_hashed ; i++) {
        for(bp = htab[i]; bp; bp = bp->link) {
            if(bp->free == NULL) {
                log_info("%20s:%i%10lu%10p", bp->file, bp->line, (unsigned long) bp->size, bp->ptr);
                found = 1;
            }
        }
    }
    if(!found) log_info("No allocated blocks found.\n");
    else log_info("\n");
}

#endif /*NDEBUG*/
