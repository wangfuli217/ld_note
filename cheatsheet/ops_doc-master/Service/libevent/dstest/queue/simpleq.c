#include <stdlib.h>
#include <stdio.h>

#include <sys/queue.h>

/* struct simpleq_head declaration */
SIMPLEQ_HEAD (simpleq_head, char_node);

struct char_node {
    SIMPLEQ_ENTRY (char_node) node;
    char data;
};

#define CHAR_NODE_FMT "%c(%d)"

int main (void) {

    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct char_node *cur;
    struct char_node *first;
    struct char_node *second;
    struct simpleq_head head;

    puts ("singly-linked queue API demo");

    /* initialization ... */
    head = (struct simpleq_head) SIMPLEQ_HEAD_INITIALIZER (head);
    /* ... equivalent to doing */
    SIMPLEQ_INIT (&head);

    /* insert at the head */
    SIMPLEQ_INSERT_HEAD (&head, &node_a, node);
    /* insert at the tail */
    SIMPLEQ_INSERT_TAIL (&head, &node_c, node);
    /* insert after an element */
    SIMPLEQ_INSERT_AFTER (&head, &node_a, &node_b, node);
    /* no insert before macro */

    /* walk through */
    puts ("whole queue:");
    SIMPLEQ_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    /* element removal */
    SIMPLEQ_REMOVE (&head, &node_b, char_node, node);

    puts ("After b's removal:");
    SIMPLEQ_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    /* head element */
    first = SIMPLEQ_FIRST (&head);
    printf ("head element is " CHAR_NODE_FMT "\n", first->data, first->data);
    /* iterate by hand */
    second = SIMPLEQ_NEXT (first, node);
    printf ("second element is " CHAR_NODE_FMT "\n", second->data, second->data);

    /* SIMPLEQ_ENTRT: test for emptiness (not the action of emtpying */
    SIMPLEQ_REMOVE_HEAD (&head, node);
    printf ("queue is %s empty\n", SIMPLEQ_EMPTY (&head) ? "" : "n't");
    SIMPLEQ_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    SIMPLEQ_REMOVE_HEAD (&head, node);
    printf ("queue is %s empty\n", SIMPLEQ_EMPTY (&head) ? "" : "n't");

    SIMPLEQ_FOREACH (cur, &head, node)
        printf ("\tvalue is " CHAR_NODE_FMT "\n", cur->data, cur->data);

    return EXIT_SUCCESS;

}
