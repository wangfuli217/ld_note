#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"assert.h"
#include"except.h"
#include"mem.h"

#define HTAB_LEN 2048

const except_t MemFailedException          = {"MemFailedException"};

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

static struct descriptor{
    struct descriptor *free;
    struct descriptor *link;
    const void *ptr;
    ssize_t size;
    const char *file;
    const char *func;
    int line;
} *htab[HTAB_LEN];


static struct descriptor freelist = {.free = &freelist};

#define NDESCRIPTORS 512

#define NALLOC ((4096 + sizeof(union align) - 1) / \
        (sizeof(union align))) * (sizeof(union align))

#define hash(p, t) (((unsigned long) (p) >> 3) & \
        (sizeof((t)) / sizeof((t)[0]) - 1))


static 
struct descriptor *
_find(const void *ptr)
{
    struct descriptor *bp = htab[hash(ptr, htab)];

    while(bp && ptr != bp->ptr)
        bp = bp->link;

    return bp;
}


static 
struct descriptor *
_dalloc(void *ptr, 
        ssize_t size,
        const char *file,
        const char *func,
        int line)
{
    static struct descriptor *avail;
    static int nleft;

    if(nleft <= 0){

        avail = malloc(NDESCRIPTORS * sizeof(*avail));
        if(NULL == avail)
            return NULL;

        nleft = NDESCRIPTORS;
    }
    
    avail->ptr = ptr;
    avail->size = size;
    avail->file = file;
    avail->func = func;
    avail->line = line;
    avail->free = avail->link = NULL;
    nleft --;

    return avail++;
}


void 
mem_free(void *ptr,
                const char *file,
                const char *func,
                int line)
{

    if(ptr){
        struct descriptor *bp;
        
        if(((unsigned long) ptr) % (sizeof(union align)) != 0){ 
            except_raise(&AssertFailedException, file, func, "mem free align", line);
        } 
        else if(NULL == (bp = _find(ptr))){ 
            except_raise(&AssertFailedException, file, func, "mem_free _find bp", line);
        }
        else if(bp->free){ 
            except_raise(&AssertFailedException, file, func, "mem_free double free", line);
        }
        
        bp->free = freelist.free;
        freelist.free = bp;
    }
}

void *
mem_resize(ssize_t len,
                void *ptr,
                const char *file,
                const char *func,
                int line)
{
    struct descriptor *bp;
    void *newptr;
    
    assert(ptr);
    assert(len > 0);
    
    if(((unsigned long) ptr) % (sizeof(union align)) != 0){ 
        except_raise(&AssertFailedException, file, func, "mem_resize align", line);
    } 
    else if(NULL == (bp = _find(ptr))){ 
        except_raise(&AssertFailedException, file, func, "mem_resize find bp", line);
    }
    else if(bp->free){ 
        except_raise(&AssertFailedException, file, func, "mem_resize double free", line);
    }

    newptr = mem_alloc(len, file, func, line);
    memcpy(newptr, ptr, len < bp->size ? len : bp->size);

    mem_free(ptr, file, func, line);

    return newptr;
}

void *
mem_calloc(ssize_t count,
                ssize_t len,
                const char *file,
                const char *func,
                int line)
{
    void *ptr;

    assert(count > 0);
    assert(len > 0);

    ptr = mem_alloc(count * len, file, func, line);
    memset(ptr, '\0', count * len);
    
    return ptr;
}

void *
mem_alloc(ssize_t len, 
                const char *file,
                const char *func,
                int line)
{
    struct descriptor *bp;
    void *ptr;

    assert(len > 0);

    len = ((len + sizeof(union align) - 1) / 
           (sizeof(union align))) * (sizeof(union align));

    for(bp = freelist.free; bp; bp = bp->free){
        
        if(bp->size > len){
            bp->size -= len;

            ptr = (char *)bp->ptr + bp->size;
            if(NULL != (bp = _dalloc(ptr, len, file, func, line))){
                unsigned int h = hash(ptr, htab);
                bp->link = htab[h];
                htab[h] = bp;

                return ptr;
            }else{
                RAISE(MemFailedException, "dalloc failed");
            }
        }

        if(bp == &freelist){
            struct descriptor *newptr;

            if(NULL == (ptr = malloc(len + NALLOC)) ||
                NULL == (newptr = _dalloc(ptr, len + NALLOC,
                        __FILE__, __func__, __LINE__))){

                RAISE(MemFailedException, "malloc failed");
            }

            newptr->free = freelist.free;
            freelist.free = newptr;
        }
    }

    assert(0);
    return NULL; 
}


void 
mem_leak(void (*apply)(const void *ptr,
                            ssize_t size,
                            const char *file,
                            const char *func,
                            int line,
                            void *cl),
                void *cl)
{
    struct descriptor *bp;
    int i;

     
    for(i = 0; i < HTAB_LEN; i++){
        bp = htab[i];

        while(bp && !bp->free){

            (*apply)(bp->ptr, 
                    bp->size, 
                    bp->file, 
                    bp->func, 
                    bp->line, 
                    cl);
            bp = bp->link;
        }
    }
}
