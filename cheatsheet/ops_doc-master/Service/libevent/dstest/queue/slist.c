#include <stdlib.h>
#include <stdio.h>

#include "queue.h"
//#include <sys/queue.h>

/* struct slist_head declaration */
SLIST_HEAD (slist_head, char_node);

struct char_node {
    SLIST_ENTRY (char_node) node;
    char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    SLIST_HEAD (slist_head, char_node) head;

    puts ("singly-linked list API demo");

    /* initialization ... */
    head = (struct slist_head) SLIST_HEAD_INITIALIZER (head);
    /* ... equivalent to doing */
    SLIST_INIT (&head);

    /* insert at the head */
    SLIST_INSERT_HEAD (&head, &node_a, node);
    /* insert after an element */
    SLIST_INSERT_AFTER (&node_a, &node_c, node);
    SLIST_INSERT_AFTER (&node_a, &node_b, node);
    /* no insert before macro */

    /* walk through */
    puts ("whole list:");
    struct char_node *cur;
    SLIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    /* element removal */
    SLIST_REMOVE (&head, &node_b, char_node, node);
    puts ("After b's removal:");
    SLIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    struct char_node *first = SLIST_FIRST (&head);
    if (first != NULL)
        printf ("head element is " CHAR_NODE_FMT "\n", first->data, first->data);
    /* iterate by hand */
    struct char_node *second = SLIST_NEXT (first, node);
    if (second != NULL)
        printf ("second element is " CHAR_NODE_FMT "\n", second->data, second->data);
    /* previous node */
    //struct char_node *previous = SLIST_PREV(second, &head, struct char_node, node);
    //printf("previous element is "CHAR_NODE_FMT"\n", previous->data, previous->data);

    puts ("Iterate whole list:");
    cur = SLIST_FIRST (&head);
    while (cur != NULL) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = SLIST_NEXT (cur, node);
    }
    SLIST_INSERT_AFTER (&node_a, &node_b, node);

    /* SLIST_EMPTY: test for emptniess(not the action of emptying) */
    SLIST_REMOVE_HEAD (&head, node);
    puts ("After remove_head");
    SLIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    SLIST_REMOVE_AFTER (&node_b, node);
    puts ("After remove_after b");
    SLIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    SLIST_REMOVE (&head, &node_b, char_node, node);
    puts ("After remove b self");
    SLIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    SLIST_INSERT_HEAD (&head, &node_a, node);
    SLIST_INSERT_AFTER (&node_a, &node_c, node);
    SLIST_INSERT_AFTER (&node_a, &node_b, node);

    struct slist_head slhead;
    SLIST_INIT (&slhead);
    SLIST_SWAP (&head, &slhead, char_node);
    puts ("After swap between head and slhead");
    SLIST_FOREACH (cur, &head, node)
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    SLIST_FOREACH (cur, &slhead, node)
        printf ("\tslhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    struct char_node *tval;
    SLIST_FOREACH_SAFE (cur, &slhead, node, tval) {
        SLIST_REMOVE (&slhead, cur, char_node, node);
    }
    puts ("After foreach_safe and remove:");
    SLIST_FOREACH (cur, &slhead, node)
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    printf ("head is%s empty\n", SLIST_EMPTY (&head) ? "" : "n't");
    printf ("slhead is%s empty\n", SLIST_EMPTY (&slhead) ? "" : "n't");
    return 0;

}
