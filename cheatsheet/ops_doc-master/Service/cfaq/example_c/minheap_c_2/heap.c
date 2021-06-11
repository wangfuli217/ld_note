#include "heap.h"

int 
heap_up(heap_t *heap, long int index, heap_node_t *node);

int 
heap_down(heap_t *heap, long int index, heap_node_t *node);

int heap_init(heap_t *heap, long int size, int (*compar)(const void *, const void *))
{
        errno = 0;
        if (heap == NULL || size == 0)
        {
                errno = EINVAL;
                return -1;
        }
        heap->heap = NULL;
        heap->size = size;
        heap->last_index = -1;
        heap->compar = compar;
        if (size>0)
        {
                heap->heap = (heap_node_t **)malloc(sizeof(heap_node_t *)*size);
                if (heap->heap == NULL)
                {
                        errno = ENOMEM;
                        return -1;
                }
        }
        return 0;
}



int heap_up(heap_t *heap, long int index)
{
        long int p_index; 
        heap_node_t *node = heap->heap[index];
        p_index = PARENT(index);
        while (index > 0 && heap->compar(node, heap->heap[p_index]) < 0)
        {
                heap->heap[index] = heap->heap[p_index];
                heap->heap[index]->index = index;
                index = p_index;
                p_index = PARENT(index);
        }
        node->index = index;
        heap->heap[index] = node;
        return 0;
}



int heap_down(heap_t *heap, long int index)
{
        long int min, l_index, r_index;
        heap_node_t *node = heap->heap[index];
        long int last_index = heap->last_index;
        for (;;)
        {
                l_index = LEFT(index);
                r_index = l_index+1;
                if (l_index >= last_index)
                {

                        break;
                }
                else
                if (r_index == last_index || heap->compar(heap->heap[l_index], heap->heap[r_index]) <= 0)
                        min = l_index;
                else
                        min = r_index;
                if (heap->compar(node, heap->heap[min]) <= 0)
                        break;
                heap->heap[index] = heap->heap[min];
                heap->heap[index]->index = index;
                index = min;

        }
        heap->heap[index] = node;
        node->index = index;
        return 0;

}

int heap_insert(heap_t *heap, heap_node_t *node)
{
        heap_node_t **p;
        long int size;
        errno = 0;
        if (heap == NULL || node == NULL)
        {
                errno = EINVAL;
                return -1;
        }
        if (heap->last_index+1 >=  heap->size)
        {
                size = heap->size * 2;
                p = (heap_node_t **)realloc(heap->heap, sizeof(heap_node_t *)*size);
                if (p == NULL)
                {
                        errno = ENOMEM;
                        return -1;
                }
                heap->size = size;
                heap->heap = p;
        }
        heap->last_index++;
        heap->heap[heap->last_index] = node;
        node->index = heap->last_index;
        heap_up(heap, heap->last_index);
        return 0;
}

int heap_delete(heap_t *heap, heap_node_t *node)
{
        long int i, index, swap_index, last_index;
        if (heap == NULL || node == NULL)
        {
                errno = EINVAL;
                return -1;
        }
        index = node->index;
        last_index = heap->last_index;
        if (index < 0 || last_index < 0 ||  index > last_index)
        {
                errno = EINVAL;
                return -1;
        }
        if (heap->heap[index] != node)
        {
                errno = EINVAL;
                return -1;
        }
        if (index != swap_index)
        {
                heap->heap[index] = heap->heap[last_index];
                heap_up(heap, index);
                heap_down(heap, index);
        }
        heap->last_index--;
        node->index = -1;
        return 0;
}

heap_node_t *heap_top(heap_t *heap)
{
        if (heap->last_index < 0)
                return NULL;
        return heap->heap[0];
}

int heap_destroy(heap_t *heap)
{
        if (heap == NULL)
        {
                errno = EINVAL;
                return -1;
        }
        if (heap->heap != NULL)
                free(heap->heap);
        heap->size = 0;
        heap->last_index = -1;
        heap->compar = NULL;
        return 0;
}
