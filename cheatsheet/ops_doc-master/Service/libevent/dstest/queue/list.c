#include <stdlib.h>
#include <stdio.h>

#include "queue.h"

/* struct list_head declaration */
LIST_HEAD (list_head, char_node);

struct char_node {
    LIST_ENTRY (char_node) node;
    char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct list_head head;

    puts ("doubly-linked list API demo");
    head = (struct list_head) LIST_HEAD_INITIALIZER (head);
    /* ...equivalent to doing */
    LIST_INIT (&head);

    /* insert at the head */
    LIST_INSERT_HEAD (&head, &node_a, node);
    /* insert after an element */
    LIST_INSERT_AFTER (&node_a, &node_c, node);
    /* insert before an element */
    LIST_INSERT_BEFORE (&node_c, &node_b, node);

    /* walk through */
    puts ("whole list:");
    struct char_node *cur;
    LIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    /* head element */
    struct char_node *first = LIST_FIRST (&head);
    if (first != NULL)
        printf ("head element is " CHAR_NODE_FMT "\n", first->data, first->data);

    struct char_node *second = LIST_NEXT (first, node);
    if (second != NULL)
        printf ("second element is " CHAR_NODE_FMT "\n", second->data, second->data);

//    struct char_node *prevous = LIST_PREV(second, &head, char_node, node);
//    printf("second prevous element is "CHAR_NODE_FMT"\n", second->data, second->data);

    puts ("Iterate list:");
    cur = LIST_FIRST (&head);
    while (cur != NULL) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = LIST_NEXT (cur, node);
    }

    /* LIST_EMPTY: test for emptiness (not the action of emptying) */
    LIST_REMOVE (LIST_FIRST (&head), node);
    printf ("list is%s empty\n", LIST_EMPTY (&head) ? "" : "n't");
    LIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    LIST_REMOVE (LIST_FIRST (&head), node);
    printf ("list is%s empty\n", LIST_EMPTY (&head) ? "" : "n't");
    LIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    LIST_REMOVE (LIST_FIRST (&head), node);
    printf ("list is%s empty\n", LIST_EMPTY (&head) ? "" : "n't");
    LIST_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    /* LIST_SWAP: */
    LIST_INSERT_HEAD (&head, &node_a, node);
    LIST_INSERT_AFTER (&node_a, &node_c, node);
    LIST_INSERT_BEFORE (&node_c, &node_b, node);
    struct list_head lhead;
    LIST_INIT (&lhead);
    puts ("swap between head and lhead");
    LIST_SWAP (&head, &lhead, char_node, node);
    cur = LIST_FIRST (&head);
    while (cur != NULL) {
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = LIST_NEXT (cur, node);
    }
    cur = LIST_FIRST (&lhead);
    while (cur != NULL) {
        printf ("\tlhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = LIST_NEXT (cur, node);
    }

    /* LIST_REPLACE: */
    LIST_REMOVE (LIST_FIRST (&lhead), node);
    LIST_REPLACE (LIST_FIRST (&lhead), &node_a, node);
    puts ("remove first then replace first by node_a");
    cur = LIST_FIRST (&lhead);
    while (cur != NULL) {
        printf ("\tlhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = LIST_NEXT (cur, node);
    }

    /* LIST_FOREACH: */
    struct char_node *tval;
    LIST_FOREACH_SAFE (cur, &lhead, node, tval) {
        LIST_REMOVE (cur, node);
    }
    puts ("after foreach_safe and removal:");
    printf ("head is%s empty\n", LIST_EMPTY (&head) ? "" : "n't");
    printf ("lhead is%s empty\n", LIST_EMPTY (&lhead) ? "" : "n't");

    return 0;
}
