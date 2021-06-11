#include<stdlib.h>
#include<float.h>
#include"assert.h"
#include"mem.h"
#include"arena.h"
#include"digraph.h"
#include"indexminpq.h"
#include"seq.h"

#define T digraph_t

struct adj{
    struct adj  *link;
    int         from;
    int         to;
    double      weight;
};

/**
 * 图数据结构
 */
struct T{
    /**
     * 图数据及算法附属数据所用的内存池
     */
    arena_t     arena;

    /**
     * 邻接表数组
     */
    seq_t   adj_seq;
};

struct digraph_sr_t{
    int size;
    int start;
    struct adj  **edge_array;
    double      *dist_to;
};

struct digraph_path_t{
    int     start;
    seq_t   node_seq;
};

static void _relax(digraph_t digraph, digraph_sr_t dsr, iminpq_t iminpq, int v);

T
digraph_new
(int hint)
{
    T digraph;
    int i;
    digraph = ALLOC(sizeof(*digraph));
    digraph->arena = arena_new();
    digraph->adj_seq = seq_new(hint+512);
    return digraph;
}


void
digraph_free
(T *digraph)
{
    assert(digraph);
    assert(*digraph);
    arena_free((*digraph)->arena);
    seq_free(&((*digraph)->adj_seq));
    FREE(*digraph);
}


void             
digraph_add         
(T digraph, int index)
{
    assert(digraph);
    assert(seq_length(digraph->adj_seq) == index);
    seq_add_high(digraph->adj_seq, NULL);
}


void             
digraph_add_seg     
(T digraph, int len){
    int i;
    assert(digraph);
    for(i = 0; i < len; i++){
        seq_add_high(digraph->adj_seq, NULL);
    }
}

int
digraph_count
(T digraph)
{
    assert(digraph);
    return seq_length(digraph->adj_seq);
}


void
digraph_connect
(T digraph, int from, int to, double weight)
{
    struct adj *adj_list, *new_adj;
    assert(digraph);
    assert(from != to);
    assert(from >= 0 && from < digraph_count(digraph));
    assert(to >= 0 && to < digraph_count(digraph));
    adj_list = seq_get(digraph->adj_seq, from);
    new_adj  = ARENA_ALLOC(digraph->arena, sizeof(*new_adj));
    new_adj->link = adj_list;
    new_adj->from = from;
    new_adj->to = to;
    new_adj->weight = weight;
    seq_put(digraph->adj_seq, from, new_adj);
}


int
digraph_is_connect
(T digraph, int from, int to)
{
    struct adj *adj_list;
    assert(digraph);
    assert(from != to);
    assert(from >= 0 && from < digraph_count(digraph));
    assert(to >= 0 && to < digraph_count(digraph));
    adj_list = seq_get(digraph->adj_seq, from);
    while(adj_list){
        if(to == adj_list->to){
            return 1;
        }
        adj_list = adj_list->link;
    }
    return 0;
}


digraph_sr_t
digraph_dijkstra
(T digraph, int start)
{
    int i;
    digraph_sr_t sr;
    iminpq_t    iminpq;

    assert(digraph);
    assert(start >= 0 && start < digraph_count(digraph));

    iminpq = iminpq_new(digraph_count(digraph));
    
    sr = ALLOC(sizeof(*sr));
    sr->size = digraph_count(digraph);
    sr->start = start;
    sr->dist_to = ALLOC(sr->size * sizeof(double));
    sr->edge_array = ALLOC(sr->size * sizeof(struct adj *));

    for(i = 0; i < sr->size; i++){
        sr->dist_to[i] = DBL_MAX;
        sr->edge_array[i] = NULL;
    }

    sr->dist_to[start] = 0.0;
    iminpq_insert(iminpq, start, 0.0);
    while(!iminpq_is_empty(iminpq)){
        _relax(digraph, sr, iminpq, iminpq_delete_min(iminpq));
    }

    iminpq_free(&iminpq);
    return sr;
}


static
void
_relax
(digraph_t digraph, digraph_sr_t dsr, iminpq_t iminpq, int v)
{
    int         w;
    double      weight;
    struct adj  *adj_list;
    struct adj  **edge_array;
    double      *dist_to;

    dist_to = dsr->dist_to;
    edge_array = dsr->edge_array;

    adj_list = seq_get(digraph->adj_seq, v);
    while(adj_list){
        w = adj_list->to;
        weight = adj_list->weight;
        if(dist_to[w] > dist_to[v] + weight){
            dist_to[w] = dist_to[v] + weight;
            edge_array[w] = adj_list;
        
            if(iminpq_contains(iminpq, w))
                iminpq_change_key(iminpq, w, dist_to[w]);
            else
                iminpq_insert(iminpq, w, dist_to[w]);
        }

        adj_list = adj_list->link;
    }
}


void
digraph_sr_free
(digraph_sr_t *dsr)
{
    assert(dsr);
    assert(*dsr);
    FREE((*dsr)->dist_to);
    FREE((*dsr)->edge_array);
    FREE(*dsr);
}


int
digraph_sr_start
(digraph_sr_t dsr)
{
    assert(dsr);
    return dsr->start;
}


int
digraph_sr_has_path
(digraph_sr_t dsr, int end)
{
    assert(dsr);
    assert(end >= 0 && end <= dsr->size);
    return dsr->dist_to[end] < DBL_MAX;
}


double
digraph_sr_dist
(digraph_sr_t dsr, int end)
{
    assert(dsr);
    assert(end >= 0 && end <= dsr->size);
    return dsr->dist_to[end];
}

/*
 *
struct digraph_path_t{
    int     start;
    seq_t   node_seq;
};
struct digraph_sr_t{
    int size;
    int start;
    struct adj  **edge_array;
    double      *dist_to;
};
 */

digraph_path_t
digraph_sr_path_to
(digraph_sr_t dsr, int end)
{
    digraph_path_t path;
    assert(dsr);
    assert(end >= 0 && end <= dsr->size);

    if(!digraph_sr_has_path(dsr, end)){
        return NULL;
    }

    path = ALLOC(sizeof(*path));
    path->start = dsr->start;
    path->node_seq = seq_new(512);

    struct adj  **edge_array;
    struct adj  *edge;

    edge_array = dsr->edge_array;
    
    edge = edge_array[end];
    while(edge){
        seq_add_low(path->node_seq, edge);
        edge = edge_array[edge->from];
    }
    return path;
}


void
digraph_path_free
(digraph_path_t *dp)
{
    assert(dp);
    assert(*dp);
    seq_free(&((*dp)->node_seq));
    FREE(*dp);
}


int
digraph_path_length
(digraph_path_t dp)
{
    assert(dp);
    return seq_length(dp->node_seq);
}


int              
digraph_path_get     
(digraph_path_t dp, int pos)
{
    struct adj  *edge;
    assert(dp);
    edge = seq_get(dp->node_seq, pos);
    return edge->to;
}

