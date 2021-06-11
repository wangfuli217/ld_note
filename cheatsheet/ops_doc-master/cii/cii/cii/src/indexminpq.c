#include<stdlib.h>
#include<float.h>
#include"assert.h"
#include"mem.h"
#include"indexminpq.h"

#define T iminpq_t


struct T{
    int     size;
    int     count;
    int     *pq;
    int     *qp;
    double  *keys;
};

   
static void _exch(T iminpq, int i, int j);
static int  _greater(T iminpq, int i, int j);
static void _sink(T iminpq, int k);
static void _swim(T iminpq, int k);


T
iminpq_new
(int size)
{
    int i;
    T iminpq;
    assert(size >= 0);
    iminpq = ALLOC(sizeof(*iminpq));
    iminpq->size = size;
    iminpq->count = 0;
    iminpq->pq = ALLOC((size + 1) * sizeof(int));
    iminpq->qp = ALLOC((size + 1) * sizeof(int));
    iminpq->keys = ALLOC((size + 1) * sizeof(double));

    for(i = 0; i <= size; i++){
        iminpq->qp[i] = -1;
    }
    return iminpq;
}


void
iminpq_free
(T *iminpq)
{
    assert(iminpq);
    assert(*iminpq);
    FREE((*iminpq)->pq);
    FREE((*iminpq)->qp);
    FREE((*iminpq)->keys);
    FREE(*iminpq);
}


void
iminpq_clean
(T iminpq)
{
    int size, i;
    assert(iminpq);
    size = iminpq->size;
    iminpq->count = 0;
    for(i = 0; i <= size; i++){
        iminpq->qp[i] = -1;
        iminpq->keys[i] = DBL_MAX;
    }
}


int
iminpq_size
(T iminpq)
{
    return iminpq->size;
}


int
iminpq_count
(T iminpq)
{
    return iminpq->count;
}


void
iminpq_change_key
(T iminpq, int i, double key)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(iminpq_contains(iminpq, i));
    iminpq->keys[i] = key;
    _swim(iminpq, iminpq->qp[i]);
    _sink(iminpq, iminpq->qp[i]);
}


void
iminpq_decrease_key
(T iminpq, int i, double key)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(iminpq_contains(iminpq, i));
    assert(iminpq->keys[i] > key);
    iminpq->keys[i] = key;
    _swim(iminpq, iminpq->qp[i]);
}


void            
iminpq_increase_key
(T iminpq, int i, double key)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(iminpq_contains(iminpq, i));
    assert(iminpq->keys[i] < key);
    iminpq->keys[i] = key;
    _swim(iminpq, iminpq->qp[i]);
}


int        
iminpq_delete_min
(T iminpq)
{
    assert(iminpq);
    assert(iminpq->count > 0);

    int min;
    min = iminpq->pq[1];        
    _exch(iminpq, 1, iminpq->count); 
    iminpq->count -= 1;
    _sink(iminpq, 1);
    iminpq->qp[min] = -1; 
    iminpq->keys[iminpq->pq[iminpq->count+1]] = DBL_MAX;
    iminpq->pq[iminpq->count+1] = -1;
    return min; 
}


void
iminpq_delete
(T iminpq, int i)
{
    int index;
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(iminpq_contains(iminpq, i));

    index = iminpq->qp[i];
    _exch(iminpq, index, iminpq->count);
    iminpq->count -= 1;
    _swim(iminpq, index);
    _sink(iminpq, index);
    iminpq->keys[i] = DBL_MAX;
    iminpq->qp[i] = -1;
}


void
iminpq_insert
(T iminpq, int i, double key)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(!iminpq_contains(iminpq, i));
    iminpq->count += 1;
    iminpq->qp[i] = iminpq->count;
    iminpq->pq[iminpq->count] = i;
    iminpq->keys[i] = key;
    _swim(iminpq, iminpq->count);
}


int             
iminpq_contains    
(T iminpq, int i)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    return -1 != iminpq->qp[i];
}


int             
iminpq_is_empty     
(T iminpq)
{
    assert(iminpq);
    return 0 == iminpq->count;
}


double          
iminpq_key_of       
(T iminpq, int i)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(iminpq_contains(iminpq, i));
    return iminpq->keys[i];
}


int             
iminpq_min_index    
(T iminpq)
{
    assert(iminpq);
    assert(iminpq->count > 0);
    return iminpq->pq[1];        
}


double          
iminpq_min_key      
(T iminpq)
{
    assert(iminpq);
    assert(iminpq->count > 0);
    return iminpq->keys[iminpq->pq[1]];        
}


static
void
_exch(T iminpq, int i, int j)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(j >= 0 && j <= iminpq->size);
    int swap = iminpq->pq[i]; 
    iminpq->pq[i] = iminpq->pq[j]; 
    iminpq->pq[j] = swap;
    iminpq->qp[iminpq->pq[i]] = i; 
    iminpq->qp[iminpq->pq[j]] = j;
}


static
int
_greater(T iminpq, int i, int j)
{
    assert(iminpq);
    assert(i >= 0 && i <= iminpq->size);
    assert(j >= 0 && j <= iminpq->size);
    return iminpq->keys[iminpq->pq[i]] > iminpq->keys[iminpq->pq[j]];
}


static
void
_sink(T iminpq, int k)
{
    assert(iminpq);
    assert(k >= 0 && k <= iminpq->size);
    while (2*k <= iminpq->count) {
        int j = 2*k;
        if (j < iminpq->count && _greater(iminpq, j, j+1)) j++;
        if (!_greater(iminpq, k, j)) break;
        _exch(iminpq, k, j);
        k = j;
    }
}


static
void
_swim(T iminpq, int k)
{
    assert(iminpq);
    assert(k >= 0 && k <= iminpq->size);
    while (k > 1 && _greater(iminpq, k/2, k)) {
        _exch(iminpq, k, k/2);
        k = k/2;
    }
}
