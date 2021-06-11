#include "portable.h" /* for OS specific alignment functions */
#include "assert.h"
#include "except.h"
#include "log.h"

#include "mem.h"

#define ALIGNMENT   64

static
void *align_alloc(size_t nbytes, const char *file, int line){
    void *ptr;
    assert(nbytes > 0);

    ptr = Aligned_malloc(nbytes, ALIGNMENT);
    if (ptr == NULL)
        {
            if (file == NULL)
                RAISE(Mem_Failed);
            else
                Except_raise(&Mem_Failed, file, line);
        }

    return ptr;
}

static
void *align_calloc(size_t count, size_t nbytes, const char *file, int line) {
    void *ptr;
    assert(count > 0);
    assert(nbytes > 0);

    ptr = Aligned_malloc(count * nbytes, ALIGNMENT);
    if (ptr == NULL)
        {
            if (file == NULL)
                RAISE(Mem_Failed);
            else
                Except_raise(&Mem_Failed, file, line);
        }

    log_dbg("%p calloc %lu bytes", ptr, (unsigned long) nbytes);
    return ptr;
}

static
void align_free(void *ptr, const char *file, int line) {
    (void)file, (void)line;
    if (ptr)
        Aligned_free(ptr);

    log_dbg("%p freed", ptr);
}

static
void *align_realloc(void *ptr, size_t nbytes, const char *file, int line) {
    assert(ptr);
    assert(nbytes > 0);

    ptr = Aligned_realloc(ptr, nbytes, ALIGNMENT);
    if (ptr == NULL)
        {
            if (file == NULL)
                RAISE(Mem_Failed);
            else
                Except_raise(&Mem_Failed, file, line);
        }

    log_dbg("%p realloc %lu bytes", ptr, (unsigned long) nbytes);
    return ptr;
}

static
void align_print_allocated() {}

const MemFuncs _Align_functions = {
    align_alloc,
    align_calloc,
    align_free,
    align_realloc,
    align_print_allocated
};

MemFuncs Mem_set_align() {
    MemFuncs tmp    = Mem_functions;
    Mem_functions   = _Align_functions;
    return tmp;
}
