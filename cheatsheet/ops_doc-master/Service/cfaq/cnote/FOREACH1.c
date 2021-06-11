#include <stdio.h>
#include <stdlib.h>
struct LinkedListNode
{
    int data;
    struct LinkedListNode *next;
};
#define FOREACH_LIST(node, list) \
     for (node=list; node; node=node->next)
/* Usage */
int main(void)
{
    struct LinkedListNode *list, **plist = &list, *node;
    int i;
    for (i=0; i<10; i++)
    {
         *plist = malloc(sizeof(struct LinkedListNode));
         (*plist)->data = i;
         (*plist)->next = NULL;
         plist          = &(*plist)->next;
    }
    /* printing the elements here */
    FOREACH_LIST(node, list)
    {
        printf("%d\n", node->data);
    }
}