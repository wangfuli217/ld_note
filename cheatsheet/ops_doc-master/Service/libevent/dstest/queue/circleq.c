#include <stdlib.h>
#include <stdio.h>

#include "queue.h"
CIRCLEQ_HEAD (circleq_head, char_node);

struct char_node {
    CIRCLEQ_ENTRY (char_node) node;
    char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct char_node node_d = {.data = 'd' };
    struct circleq_head head;

    puts ("circular queue API demo");

    /* initialization ... */
    head = (struct circleq_head) CIRCLEQ_HEAD_INITIALIZER (head);
    /* ... equivalent */
    CIRCLEQ_INIT (&head);

    /* insert at the head */
    CIRCLEQ_INSERT_HEAD (&head, &node_a, node);
    /* insert at the tail */
    CIRCLEQ_INSERT_TAIL (&head, &node_d, node);
    /* insert after an element */
    CIRCLEQ_INSERT_AFTER (&head, &node_a, &node_b, node);
    /* insert before an element */
    CIRCLEQ_INSERT_BEFORE (&head, &node_d, &node_c, node);

    /* walk through */
    struct char_node *cur;
    puts ("whole queue travese:");
    CIRCLEQ_FOREACH (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }
    puts ("whole queue reverse travese:");
    CIRCLEQ_FOREACH_REVERSE (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    CIRCLEQ_REMOVE (&head, &node_d, node);
    puts ("After d's removal");
    CIRCLEQ_FOREACH (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }
    struct char_node *first = CIRCLEQ_FIRST (&head);
    if (!CIRCLEQ_EMPTY (&head))
        printf ("head element is " CHAR_NODE_FMT "\n", first->data, first->data);
    struct char_node *second = CIRCLEQ_NEXT (first, node);
    printf ("second element is " CHAR_NODE_FMT "\n", second->data, second->data);
    struct char_node *last = CIRCLEQ_LAST (&head);
    if (!CIRCLEQ_EMPTY (&head))
        printf ("last element is " CHAR_NODE_FMT "\n", last->data, last->data);
    struct char_node *prev = CIRCLEQ_PREV (last, node);
    printf ("previous element is " CHAR_NODE_FMT "\n", prev->data, prev->data);

    struct char_node *loopnext = CIRCLEQ_LOOP_NEXT (&head, last, node);
    printf ("last loop next element is " CHAR_NODE_FMT "\n", loopnext->data, loopnext->data);
    struct char_node *loopprev = CIRCLEQ_LOOP_PREV (&head, first, node);
    printf ("first loop prev element is " CHAR_NODE_FMT "\n", loopprev->data, loopprev->data);

    puts ("foreach_safe");
    struct char_node *tval;
    CIRCLEQ_FOREACH_SAFE (cur, &head, node, tval) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    puts ("foreach_reverse_safe and remove");
    CIRCLEQ_FOREACH_REVERSE_SAFE (cur, &head, circleq_head, node, tval) {
        CIRCLEQ_REMOVE (&head, cur, node);
    }

    printf ("head is%s empty\n", CIRCLEQ_EMPTY (&head) ? "" : "n't");

    return 0;
}
