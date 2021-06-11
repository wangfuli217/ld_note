#include "mem.h"
#include "assert.h"

#include "_mem.h"
#include "_arena.h"

const MemFuncs _Mem_functions = {
    _Mem_alloc,
    _Mem_calloc,
    _Mem_free,
    _Mem_realloc,
    _Mem_print_stats
};

thread_local struct MemFuncs Mem_functions = {
    _Mem_alloc,
    _Mem_calloc,
    _Mem_free,
    _Mem_realloc,
    _Mem_print_stats
};

void Mem_print_stats() {
    Mem_functions.print_stats();
}

/* Plug Arena into the common allocation framework */

thread_local  Arena_T Arena_default;

void* a_alloc  (size_t nbytes, const char *file, int line);
void* a_calloc (size_t count, size_t nbytes, const char *file, int line);
void  a_free   (void *ptr, const char *file, int line);
void* a_realloc(void *ptr, size_t nbytes, const char *file, int line);
void  a_print_stats ();

void* a_alloc  (size_t nbytes, const char *file, int line) {
    return Arena_alloc(Arena_default, nbytes, file, line);
}

void* a_calloc (size_t count, size_t nbytes, const char *file, int line) {
    return Arena_calloc(Arena_default, count, nbytes, file, line);
}

void  a_free   (void *ptr, const char *file, int line) {
    (void) ptr, (void)file, (void)line;
}

void* a_realloc(void *ptr, size_t nbytes, const char *file, int line) {
    return Arena_realloc(Arena_default, ptr, nbytes, file, line);
}
void  a_print_stats () { Arena_print_stats();}

const MemFuncs _Arena_functions = {
    a_alloc,
    a_calloc,
    a_free,
    a_realloc,
    a_print_stats
};

extern MemFuncs Mem_set_functions(MemFuncs functions) {
    MemFuncs tmp = Mem_functions;
    Mem_functions = functions;
    return tmp;
}

extern MemFuncs Mem_set_arena(Arena_T arena) {
    MemFuncs tmp;
    assert(arena);

    Arena_default = arena;
    tmp = Mem_functions;
    Mem_functions = _Arena_functions;
    return tmp;
}

extern MemFuncs Mem_set_default() {
    MemFuncs tmp = Mem_functions;

    Arena_default = NULL;
    Mem_functions = _Mem_functions;
    return tmp;
}
