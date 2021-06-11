#include <stdlib.h>
#include <stdio.h>

struct slist_head {
    struct char_node *slh_first;
};

struct char_node {
    struct {
        struct char_node *sle_next;
    } node;
    char data;
};

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct slist_head {
        struct char_node *slh_first;
    } head;

    puts ("singly-linked list API demo");

    //SLIST_HEAD_INITIALIZER (head);
    head = (struct slist_head) {
    ((void *) 0)};
    //SLIST_INIT (&head);
    (&head)->slh_first = ((void *) 0);

    //SLIST_INSERT_HEAD (&head, &node_a, node);
    (&node_a)->node.sle_next = (&head)->slh_first;
    (&head)->slh_first = (&node_a);

    //SLIST_INSERT_AFTER (&node_a, &node_c, node);
    (&node_c)->node.sle_next = (&node_a)->node.sle_next;
    (&node_a)->node.sle_next = (&node_c);

    //SLIST_INSERT_AFTER (&node_a, &node_b, node);
    (&node_b)->node.sle_next = (&node_a)->node.sle_next;
    (&node_a)->node.sle_next = (&node_b);

    puts ("whole list:");
    struct char_node *cur;
    //SLIST_FOREACH (cur, &head, node)
    for ((cur) = (&head)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    //SLIST_REMOVE (&head, &node_b, char_node, node);
    if ((&head)->slh_first == (&node_b)) {
        ((&head))->slh_first = ((&head))->slh_first->node.sle_next;
    } else {
        struct char_node *curelm = (&head)->slh_first;
        while (curelm->node.sle_next != (&node_b)) {
            curelm = curelm->node.sle_next;
        }
        curelm->node.sle_next = curelm->node.sle_next->node.sle_next;
    }

    puts ("After b's removal:");
    //SLIST_FOREACH (cur, &head, node)
    for ((cur) = (&head)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    //SLIST_FIRST (&head);
    struct char_node *first = ((&head)->slh_first);
    if (first != ((void *) 0))
        printf ("head element is " "%c(%d)" "\n", first->data, first->data);

    //SLIST_NEXT (first, node);
    struct char_node *second = ((first)->node.sle_next);
    if (second != ((void *) 0))
        printf ("second element is " "%c(%d)" "\n", second->data, second->data);

    puts ("Iterate whole list:");
    //SLIST_FIRST (&head);
    cur = ((&head)->slh_first);
    while (cur != ((void *) 0)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
        // SLIST_NEXT (cur, node);
        cur = ((cur)->node.sle_next);
    }
    //SLIST_INSERT_AFTER (&node_a, &node_b, node);
    (&node_b)->node.sle_next = (&node_a)->node.sle_next;
    (&node_a)->node.sle_next = (&node_b);

    //SLIST_REMOVE_HEAD (&head, node);
    (&head)->slh_first = (&head)->slh_first->node.sle_next;
    puts ("After remove_head");

    //SLIST_FOREACH (cur, &head, node)
    for ((cur) = (&head)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    //SLIST_REMOVE_AFTER (&node_b, node);
    (&node_b)->node.sle_next = (((((&node_b))->node.sle_next))->node.sle_next);

    puts ("After remove_after b");
    for ((cur) = (&head)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    // SLIST_REMOVE (&head, &node_b, char_node, node);
    if ((&head)->slh_first == (&node_b)) {
        ((&head))->slh_first = ((&head))->slh_first->node.sle_next;
    } else {
        struct char_node *curelm = (&head)->slh_first;
        while (curelm->node.sle_next != (&node_b)) {
            curelm = curelm->node.sle_next;
        }
        curelm->node.sle_next = curelm->node.sle_next->node.sle_next;
    }
    puts ("After remove b self");
    for ((cur) = (&head)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    // SLIST_INSERT_HEAD (&head, &node_a, node);
    (&node_a)->node.sle_next = (&head)->slh_first;
    (&head)->slh_first = (&node_a);
    // SLIST_INSERT_AFTER (&node_a, &node_c, node);
    (&node_c)->node.sle_next = (&node_a)->node.sle_next;
    (&node_a)->node.sle_next = (&node_c);
    // SLIST_INSERT_AFTER (&node_a, &node_b, node);
    (&node_b)->node.sle_next = (&node_a)->node.sle_next;
    (&node_a)->node.sle_next = (&node_b);

    struct slist_head slhead;
    (&slhead)->slh_first = ((void *) 0);

    // SLIST_SWAP (&head, &slhead, char_node);
    struct char_node *swap_first = ((&head)->slh_first);
    ((&head)->slh_first) = ((&slhead)->slh_first);
    ((&slhead)->slh_first) = swap_first;

    puts ("After swap between head and slhead");
    for ((cur) = (&head)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);
    for ((cur) = (&slhead)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\tslhead value is " "%c(%d)" "\n", cur->data, cur->data);

    // SLIST_FOREACH_SAFE (cur, &slhead, node, tval)
    struct char_node *tval;
    for ((cur) = (((&slhead))->slh_first); (cur) && ((tval) = (((cur))->node.sle_next), 1); (cur) = (tval)) {
        //SLIST_REMOVE (&slhead, cur, char_node, node);
        if ((&slhead)->slh_first == (cur)) {
            ((&slhead))->slh_first = ((&slhead))->slh_first->node.sle_next;
        } else {
            struct char_node *curelm = (&slhead)->slh_first;
            while (curelm->node.sle_next != (cur)) {
                curelm = curelm->node.sle_next;
            }
            curelm->node.sle_next = curelm->node.sle_next->node.sle_next;
        }
    }
    puts ("After foreach_safe and remove:");
    for ((cur) = (&slhead)->slh_first; (cur); (cur) = (cur)->node.sle_next)
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);

    printf ("head is%s empty\n", ((&head)->slh_first == ((void *) 0)) ? "" : "n't");
    printf ("slhead is%s empty\n", ((&slhead)->slh_first == ((void *) 0)) ? "" : "n't");
    return 0;

}
