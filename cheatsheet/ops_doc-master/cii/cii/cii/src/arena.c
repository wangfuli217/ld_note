#include<stdlib.h>
#include<string.h>
#include"assert.h"
#include"except.h"
#include"arena.h"

#define T arena_t

const except_t ArenaNewFailedException = 
                {"ArenaNewFailedException"};
const except_t ArenaFailedException =
                {"ArenaFailedException"};

struct T{
    T prev;
    char *avail;
    char *limit;
};

union align{
    int i;
    long l;
    long *lp;
    void *p;
    void (*fp)(void);
    float f;
    double d;
    long double ld;
};

union header{
    struct T b;
    union align a;
};

static T freechunks;
static int nfree;

#define THRESHOLD 10

T       
arena_new(void)
{
    T arena = malloc(sizeof(*arena));

    if(NULL == arena)
        RAISE(ArenaNewFailedException, "");

    arena->prev = NULL;
    arena->limit = arena->avail = NULL;
    return arena;
}


void
arena_dispose(T *ap)
{
    assert(ap && *ap);
    arena_free(*ap);
    free(*ap);
    *ap = NULL;
}


void *
arena_alloc(T arena, 
            ssize_t len,
            const char *file,
            const char *func,
            int line)
{
    T ptr;
    char *limit;
    ssize_t m;

    assert(arena);
    assert(len > 0);

    len = ((len + sizeof(union align) - 1) /
            (sizeof(union align))) * (sizeof(union align));

    while(len > arena->limit - arena->avail){
        
        if((ptr = freechunks) != NULL){
            freechunks = freechunks->prev;
            nfree --;
            limit = ptr->limit;
        }else{
            m = sizeof(union header) + len + 10 * 1024; 
            ptr = malloc(m);

            if(NULL == ptr){
                if(NULL == file)
                    RAISE(ArenaFailedException, "malloc chunk");
                else
                    except_raise(&ArenaFailedException, 
                            file, func, "malloc chunk", line);
            }

            limit = (char *)ptr + m;
        }

        *ptr = *arena;
        arena->avail = (char*)((union header *)ptr + 1);
        arena->limit = limit;
        arena->prev = ptr;
    }

    arena->avail += len;
    return arena->avail - len;
}

void *
arena_calloc(T arena,
               ssize_t count,
               ssize_t len,
               const char *file,
               const char *func,
               int line)
{
    void *ptr;

    assert(count > 0);

    ptr = arena_alloc(arena, count * len, file, func, line);
    memset(ptr, '\0', count * len);
    return ptr;
}

void
arena_free(T arena)
{
    struct T tmp;
    assert(arena);

    while(arena->prev){
        tmp = *arena->prev;
        
        if(nfree < THRESHOLD){
            arena->prev->prev = freechunks;
            freechunks = arena->prev;
            nfree++;
            freechunks->limit = arena->limit;
        }else{
            free(arena->prev);
        }

        *arena = tmp;
    }
    assert(NULL == arena->limit);
    assert(NULL == arena->avail);
}
