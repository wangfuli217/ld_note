#include <stdlib.h>
#include <stdio.h>

#include "queue.h"

/* struct tailq_head declaration */
TAILQ_HEAD (tailq_head, char_node);

struct char_node {
    TAILQ_ENTRY (char_node) node;
    char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct char_node node_d = {.data = 'd' };
    struct char_node node_e = {.data = 'e' };
    struct char_node node_f = {.data = 'f' };
    struct tailq_head head;

    puts ("doubly-linked tail queue API demo");

    /* initialization ... */
    head = (struct tailq_head) TAILQ_HEAD_INITIALIZER (head);
    /* ... equivalent to doing */
    TAILQ_INIT (&head);

    /* insert at the head */
    TAILQ_INSERT_HEAD (&head, &node_a, node);
    /* insert at the tail */
    TAILQ_INSERT_TAIL (&head, &node_c, node);
    /* insert after an element */
    TAILQ_INSERT_AFTER (&head, &node_a, &node_b, node);
    /* insert before an element */
    TAILQ_INSERT_BEFORE (&node_a, &node_d, node);

    /* walk through */
    puts ("whole queue:");
    struct char_node *cur;
    TAILQ_FOREACH (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    /* element removal */
    TAILQ_REMOVE (&head, &node_d, node);
    puts ("After d's removal:");
    TAILQ_FOREACH (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    /* head element */
    struct char_node *first = TAILQ_FIRST (&head);
    if (first != NULL)
        printf ("head element is " CHAR_NODE_FMT "\n", first->data, first->data);
    /* next element */
    struct char_node *second = TAILQ_NEXT (first, node);
    if (second != NULL)
        printf ("second element is " CHAR_NODE_FMT "\n", second->data, second->data);
    /* last element */
    struct char_node *last = TAILQ_LAST (&head, tailq_head);
    if (last != NULL)
        printf ("last element is " CHAR_NODE_FMT "\n", last->data, last->data);
    /* prevous element */
    struct char_node *previous = TAILQ_PREV (last, tailq_head, node);
    if (previous != NULL)
        printf ("previous element is " CHAR_NODE_FMT "\n", previous->data, previous->data);

    struct tailq_head tqhead;
    TAILQ_INIT (&tqhead);
    TAILQ_INSERT_HEAD (&tqhead, &node_f, node);
    TAILQ_INSERT_HEAD (&tqhead, &node_e, node);
    TAILQ_INSERT_HEAD (&tqhead, &node_d, node);
    puts ("head and tqhead whole queue:");
    cur = TAILQ_FIRST (&head);
    while (cur != NULL) {
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = TAILQ_NEXT (cur, node);
    }
    cur = TAILQ_FIRST (&tqhead);
    while (cur != NULL) {
        printf ("\ttqhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = TAILQ_NEXT (cur, node);
    }

    puts ("swap tailq between head and tqhead");
    TAILQ_SWAP (&head, &tqhead, char_node, node);
    TAILQ_FOREACH (cur, &head, node) {
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }
    TAILQ_FOREACH (cur, &tqhead, node) {
        printf ("\ttqhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    puts ("reverse head and tqhead");
    TAILQ_FOREACH_REVERSE (cur, &head, tailq_head, node) {
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }
    TAILQ_FOREACH_REVERSE (cur, &tqhead, tailq_head, node) {
        printf ("\ttqhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    TAILQ_CONCAT (&head, &tqhead, node);
    puts ("concat head and tqhead");
    TAILQ_FOREACH_REVERSE (cur, &head, tailq_head, node) {
        printf ("\thead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    puts ("after foreach_safe and remove:");
    struct char_node *tval;
    TAILQ_FOREACH_SAFE (cur, &head, node, tval) {
        TAILQ_REMOVE (&head, cur, node);
    }
    printf ("head is %s empty\n", TAILQ_EMPTY (&head) ? "" : "n't");

    TAILQ_INIT (&tqhead);
    TAILQ_INSERT_HEAD (&tqhead, &node_f, node);
    TAILQ_INSERT_HEAD (&tqhead, &node_e, node);
    TAILQ_INSERT_HEAD (&tqhead, &node_d, node);
    puts ("tqhead whole queue and foreach_reverse_safe");
    TAILQ_FOREACH_REVERSE (cur, &tqhead, tailq_head, node) {
        printf ("\ttqhead value is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }
    TAILQ_FOREACH_REVERSE_SAFE (cur, &head, tailq_head, node, tval) {
        TAILQ_REMOVE (&head, cur, node);
    }
    printf ("tqhead is %s empty\n", TAILQ_EMPTY (&head) ? "" : "n't");

    return 0;
}
