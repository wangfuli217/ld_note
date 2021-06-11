#include <stdlib.h>
#include <stdio.h>

#include "queue.h"

/* struct stailq head declaration */
STAILQ_HEAD (stailq_head, char_node);

struct char_node {
    STAILQ_ENTRY (char_node) node;
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

    puts ("singly-linked tail queue API demo");
    struct stailq_head head;

    /* initialization ... */
    head = (struct stailq_head) STAILQ_HEAD_INITIALIZER (head);
    /* ... equivalent to doing */
    STAILQ_INIT (&head);

    /* insert at the head */
    STAILQ_INSERT_HEAD (&head, &node_a, node);
    /* insert at the tail */
    STAILQ_INSERT_TAIL (&head, &node_c, node);
    /* insert after an element */
    STAILQ_INSERT_AFTER (&head, &node_a, &node_b, node);
    STAILQ_INSERT_AFTER (&head, &node_c, &node_f, node);
    STAILQ_INSERT_AFTER (&head, &node_c, &node_e, node);
    STAILQ_INSERT_AFTER (&head, &node_c, &node_d, node);

    /* walk througth */
    puts ("whole simple tail queue:");
    struct char_node *cur;
    STAILQ_FOREACH (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    /* element removal: */
    STAILQ_REMOVE (&head, &node_f, char_node, node);
    STAILQ_REMOVE_AFTER (&head, &node_d, node);
    STAILQ_REMOVE_HEAD (&head, node);

    puts ("After node f and  d'after and head removal:");
    STAILQ_FOREACH (cur, &head, node) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
    }

    /* head element */
    struct char_node *first = STAILQ_FIRST (&head);
    if (first != NULL)
        printf ("head element is " CHAR_NODE_FMT "\n", first->data, first->data);
    /* iterate by hand */
    struct char_node *second = STAILQ_NEXT (first, node);
    if (second != NULL)
        printf ("second element is " CHAR_NODE_FMT "\n", second->data, second->data);
    /* tail elememt */
    struct char_node *last = STAILQ_LAST (&head, char_node, node);
    if (last != NULL)
        printf ("last element is " CHAR_NODE_FMT "\n", last->data, last->data);

    puts ("Iterate whole list:");
    cur = STAILQ_FIRST (&head);
    while (cur != NULL) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = STAILQ_NEXT (cur, node);
    }

    /* STAILQ_REMOVE_HEAD_UNTIL */
    STAILQ_REMOVE_HEAD_UNTIL (&head, &node_c, node);
    puts ("remove until node c");
    cur = STAILQ_FIRST (&head);
    while (cur != NULL) {
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = STAILQ_NEXT (cur, node);
    }

    struct stailq_head stqhead;
    STAILQ_INIT (&stqhead);
    STAILQ_INSERT_HEAD (&stqhead, &node_a, node);
    STAILQ_INSERT_AFTER (&stqhead, &node_a, &node_b, node);
    STAILQ_INSERT_AFTER (&stqhead, &node_b, &node_c, node);
    puts ("swap stailq between stqhead and head");
    STAILQ_SWAP (&head, &stqhead, char_node);
    cur = STAILQ_FIRST (&head);
    while (cur != NULL) {
        printf ("\thead value is" CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = STAILQ_NEXT (cur, node);
    }
    cur = STAILQ_FIRST (&stqhead);
    while (cur != NULL) {
        printf ("\tstqhead value is" CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = STAILQ_NEXT (cur, node);
    }

    puts ("concat stailq head and stqhead");
    STAILQ_CONCAT (&head, &stqhead);
    cur = STAILQ_FIRST (&head);
    while (cur != NULL) {
        printf ("\thead value is" CHAR_NODE_FMT "\n", cur->data, cur->data);
        cur = STAILQ_NEXT (cur, node);
    }

    struct char_node *tval;
    STAILQ_FOREACH_SAFE (cur, &head, node, tval) {
        STAILQ_REMOVE (&head, cur, char_node, node);
    }

    printf ("head is%s empty\n", STAILQ_EMPTY (&head) ? "" : "n't");
    printf ("stqhead is%s empty\n", STAILQ_EMPTY (&stqhead) ? "" : "n't");

    return 0;
}
