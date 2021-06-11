/*
 * Copyright (C) Igor Sysoev
 */


#include "mem_pool.h"


static void *mem_palloc_block(mem_pool *pool, size_t size);
static void *mem_palloc_large(mem_pool *pool, size_t size);


mem_pool *
mem_create_pool(size_t size)
{
    mem_pool  *p;

    size = (size == 0) ? NGX_DEFAULT_POOL_SIZE : size;
    p = (mem_pool *)mem_memalign(NGX_POOL_ALIGNMENT, size);
    if (p == NULL) {
        return NULL;
    }

    p->d.last = (u_char *) p + sizeof(mem_pool);
    p->d.end = (u_char *) p + size;
    p->d.next = NULL;
    p->d.failed = 0;

    size = size - sizeof(mem_pool);
    p->max = (size < NGX_MAX_ALLOC_FROM_POOL) ? size : NGX_MAX_ALLOC_FROM_POOL;

    p->current = p;
    p->large = NULL;
    p->cleanup = NULL;

    return p;
}

void
mem_destroy_pool(mem_pool *pool)
{
    mem_pool          *p, *n;
    mem_pool_large_t    *l;
    mem_pool_cleanup_t  *c;

    for (c = pool->cleanup; c; c = c->next) {
        if (c->handler) {
            c->handler(c->data);
        }
    }

    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            mem_free(l->alloc);
        }
    }

    for (p = pool, n = pool->d.next; /* void */; p = n, n = n->d.next) {
        mem_free(p);
        if (n == NULL) {
            break;
        }
    }
}


void
mem_reset_pool(mem_pool *pool)
{
    mem_pool        *p;
    mem_pool_large_t  *l;

    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            mem_free(l->alloc);
        }
    }

    pool->large = NULL;

    for (p = pool; p; p = p->d.next) {
        p->d.last = (u_char *) p + sizeof(mem_pool);
    }
}


void *
mem_palloc(mem_pool *pool, size_t size)
{
    u_char      *m;
    mem_pool  *p;

    if (size <= pool->max) {

        p = pool->current;

        do {
            m = mem_align_ptr(p->d.last, NGX_ALIGNMENT);

            if ((size_t) (p->d.end - m) >= size) {
                p->d.last = m + size;

                return m;
            }

            p = p->d.next;

        } while (p);

        return mem_palloc_block(pool, size);
    }

    return mem_palloc_large(pool, size);
}


void *
ngx_pnalloc(mem_pool *pool, size_t size)
{
    u_char      *m;
    mem_pool  *p;

    if (size <= pool->max) {

        p = pool->current;

        do {
            m = p->d.last;

            if ((size_t) (p->d.end - m) >= size) {
                p->d.last = m + size;

                return m;
            }

            p = p->d.next;

        } while (p);

        return mem_palloc_block(pool, size);
    }

    return mem_palloc_large(pool, size);
}


static void *
mem_palloc_block(mem_pool *pool, size_t size)
{
    u_char      *m;
    size_t       psize;
    mem_pool  *p, *new_pool, *current;

    psize = (size_t) (pool->d.end - (u_char *) pool);

    m = (u_char *)mem_memalign(NGX_POOL_ALIGNMENT, psize);
    if (m == NULL) {
        return NULL;
    }

    new_pool = (mem_pool *) m;

    new_pool->d.end = m + psize;
    new_pool->d.next = NULL;
    new_pool->d.failed = 0;

    m += sizeof(mem_pool_data_t);
	printf("%x,",m);
    m = mem_align_ptr(m, NGX_ALIGNMENT);
	printf("%x\n",m);
    new_pool->d.last = m + size;

    current = pool->current;

    for (p = current; p->d.next; p = p->d.next) {
        if (p->d.failed++ > 4) {
            current = p->d.next;
        }
    }

    p->d.next = new_pool;

    pool->current = current ? current : new_pool;

    return m;
}


static void *
mem_palloc_large(mem_pool *pool, size_t size)
{
    void              *p;
    mem_uint_t         n;
    mem_pool_large_t  *large;

    p = malloc(size);
    if (p == NULL) {
        return NULL;
    }

    n = 0;

    for (large = pool->large; large; large = large->next) {
        if (large->alloc == NULL) {
            large->alloc = p;
            return p;
        }

        if (n++ > 3) {
            break;
        }
    }

    large = (mem_pool_large_t *)mem_palloc(pool, sizeof(mem_pool_large_t));
    if (large == NULL) {
        mem_free(p);
        return NULL;
    }

    large->alloc = p;
    large->next = pool->large;
    pool->large = large;

    return p;
}

