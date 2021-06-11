#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "ht-internal.h"


struct Node {
    int id;
    int data;
    struct Node *p;
    HT_ENTRY(Node) entry;
};

HT_HEAD(NodeHead, Node);
static unsigned long hash_func(struct Node *node) {
    return (unsigned long)node;
}
static int hash_equal(struct Node *node1, struct Node *node2)
{
    return node1 == node2;
}

HT_PROTOTYPE(NodeHead, Node, entry, hash_func, hash_equal);
HT_GENERATE(NodeHead, Node, entry, hash_func, hash_equal, 1, malloc, realloc, free);

#define N 1000000
struct NodeHead head;
int main(void) {
    int i;
    struct Node *p;
    struct Node *vect[N];

    HT_INIT(NodeHead, &head);
    for(i=0; i< N; i++) {
        p = malloc(sizeof(struct Node));
        assert(p);
        p->p = p;
        p->id = i;
        HT_INSERT(NodeHead, &head, p);
        vect[i] = p;
    }
    printf("size = %d\n", HT_SIZE(&head));

    for(i = 0; i < N; i++) {
        //printf("addr = %p\n", vect[i]);
        p = HT_FIND(NodeHead, &head, vect[i]);
        if(p != vect[i]) {
            printf("%p, %p not found\n", p, vect[i]);
            //HT_REMOVE(NodeHead, &head, p);
        }
        else
        {
            HT_REMOVE(NodeHead, &head, p);
        }
    }
    printf("size = %d\n", HT_SIZE(&head));
    return 0;
}
