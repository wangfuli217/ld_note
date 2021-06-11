#include <stdio.h>
#include <stdlib.h>
typedef struct CollectionItem_
{
    int data;
    struct CollectionItem_ *next;
} CollectionItem;
typedef struct Collection_
{
    /* interface functions */
    void* (*first)(void *coll);
    void* (*last) (void *coll);
    void* (*next) (void *coll, CollectionItem *currItem);
    CollectionItem *collectionHead;
    /* Other fields */
} Collection;
/* must implement */
void *first(void *coll)
{
    return ((Collection*)coll)->collectionHead;
}
/* must implement */
void *last(void *coll)
{
    return NULL;
}
/* must implement */
void *next(void *coll, CollectionItem *curr)
{
    return curr->next;
}
CollectionItem *new_CollectionItem(int data)
{
    CollectionItem *item = malloc(sizeof(CollectionItem));
    item->data = data;
    item->next = NULL;
    return item;
}
void Add_Collection(Collection *coll, int data)
{
    CollectionItem **item = &coll->collectionHead;
    while(*item)
        item = &(*item)->next;
    (*item) = new_CollectionItem(data);
}
Collection *new_Collection()
{
    Collection *nc = malloc(sizeof(Collection));
    nc->first = first;
    nc->last  = last;
    nc->next  = next;
    return nc;
}
/* generic implementation */
#define FOREACH(node, collection)                      \
    for (node  = (collection)->first(collection);      \
         node != (collection)->last(collection);       \
         node  = (collection)->next(collection, node))
int main(void)
{
    Collection *coll = new_Collection();
    CollectionItem *node;
    int i;
    for(i=0; i<10; i++)
    {
         Add_Collection(coll, i);
    }
    /* printing the elements here */
    FOREACH(node, coll)
    {
        printf("%d\n", node->data);
    }
}