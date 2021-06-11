#include <stdio.h>
#include <stdlib.h>

// LIST_HEAD (list_head, char_node);
struct list_head {
    struct char_node *lh_first;
};

struct char_node {
    //LIST_ENTRY (char_node) node;
    struct {
        struct char_node *le_next;
        struct char_node **le_prev;
    } node;
    char data;
};

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct list_head head;

    puts ("doubly-linked list API demo");
    // LIST_HEAD_INITIALIZER (head);
    head = (struct list_head) {
    ((void *) 0)};

    do {                        //LIST_INIT (&head);
        (&head)->lh_first = ((void *) 0);
    } while (0);

    do {                        //LIST_INSERT_HEAD (&head, &node_a, node);
        if (((&node_a)->node.le_next = (&head)->lh_first) != ((void *) 0)) {
            (&head)->lh_first->node.le_prev = &(&node_a)->node.le_next;
        }
        (&head)->lh_first = (&node_a);
        (&node_a)->node.le_prev = &(&head)->lh_first;
    } while (0);

    do {                        //LIST_INSERT_AFTER (&node_a, &node_c, node);
        if (((&node_c)->node.le_next = (&node_a)->node.le_next) != ((void *) 0)) {
            (&node_a)->node.le_next->node.le_prev = &(&node_c)->node.le_next;
        }
        (&node_a)->node.le_next = (&node_c);
        (&node_c)->node.le_prev = &(&node_a)->node.le_next;
    } while (0);

    do {                        // LIST_INSERT_BEFORE (&node_c, &node_b, node);
        (&node_b)->node.le_prev = (&node_c)->node.le_prev;
        (&node_b)->node.le_next = (&node_c);
        *(&node_c)->node.le_prev = (&node_b);
        (&node_c)->node.le_prev = &(&node_b)->node.le_next;
    } while (0);

    puts ("whole list:");
    struct char_node *cur;
    for ((cur) = ((&head)->lh_first); (cur); (cur) = ((cur)->node.le_next))
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    struct char_node *first = ((&head)->lh_first);
    if (first != ((void *) 0))
        printf ("head element is " "%c(%d)" "\n", first->data, first->data);

    struct char_node *second = ((first)->node.le_next);
    if (second != ((void *) 0))
        printf ("second element is " "%c(%d)" "\n", second->data, second->data);

    puts ("Iterate list:");
    // LIST_FIRST (&head);
    cur = ((&head)->lh_first);
    while (cur != ((void *) 0)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
        // LIST_NEXT (cur, node);
        cur = ((cur)->node.le_next);
    }

    do {                        //LIST_REMOVE (LIST_FIRST (&head), node)
        if ((((&head)->lh_first))->node.le_next != ((void *) 0)) {
            (((&head)->lh_first))->node.le_next->node.le_prev = (((&head)->lh_first))->node.le_prev;
        }
        *(((&head)->lh_first))->node.le_prev = (((&head)->lh_first))->node.le_next;
    } while (0);
    printf ("list is%s empty\n", ((&head)->lh_first == ((void *) 0)) ? "" : "n't");
    for ((cur) = ((&head)->lh_first); (cur); (cur) = ((cur)->node.le_next))
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    do {
        if ((((&head)->lh_first))->node.le_next != ((void *) 0)) {
            (((&head)->lh_first))->node.le_next->node.le_prev = (((&head)->lh_first))->node.le_prev;
        }
        *(((&head)->lh_first))->node.le_prev = (((&head)->lh_first))->node.le_next;
    } while (0);
    printf ("list is%s empty\n", ((&head)->lh_first == ((void *) 0)) ? "" : "n't");
    for ((cur) = ((&head)->lh_first); (cur); (cur) = ((cur)->node.le_next))
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    do {
        if ((((&head)->lh_first))->node.le_next != ((void *) 0)) {
            (((&head)->lh_first))->node.le_next->node.le_prev = (((&head)->lh_first))->node.le_prev;
        }
        *(((&head)->lh_first))->node.le_prev = (((&head)->lh_first))->node.le_next;
    } while (0);
    printf ("list is%s empty\n", ((&head)->lh_first == ((void *) 0)) ? "" : "n't");
    for ((cur) = ((&head)->lh_first); (cur); (cur) = ((cur)->node.le_next))
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);

    do {                        // LIST_INSERT_HEAD (&head, &node_a, node);
        if (((&node_a)->node.le_next = (&head)->lh_first) != ((void *) 0)) {
            (&head)->lh_first->node.le_prev = &(&node_a)->node.le_next;
        }
        (&head)->lh_first = (&node_a);
        (&node_a)->node.le_prev = &(&head)->lh_first;
    } while (0);
    do {                        // LIST_INSERT_AFTER (&node_a, &node_c, node);
        if (((&node_c)->node.le_next = (&node_a)->node.le_next) != ((void *) 0)) {
            (&node_a)->node.le_next->node.le_prev = &(&node_c)->node.le_next;
        }
        (&node_a)->node.le_next = (&node_c);
        (&node_c)->node.le_prev = &(&node_a)->node.le_next;
    } while (0);
    do {                        // LIST_INSERT_BEFORE (&node_c, &node_b, node);
        (&node_b)->node.le_prev = (&node_c)->node.le_prev;
        (&node_b)->node.le_next = (&node_c);
        *(&node_c)->node.le_prev = (&node_b);
        (&node_c)->node.le_prev = &(&node_b)->node.le_next;
    } while (0);
    struct list_head lhead;
    do {
        (&lhead)->lh_first = ((void *) 0);
    } while (0);
    puts ("swap between head and lhead");
    do {                        //LIST_SWAP (&head, &lhead, char_node, node);
        struct char_node *swap_tmp = (((&head))->lh_first);
        (((&head))->lh_first) = (((&lhead))->lh_first);
        (((&lhead))->lh_first) = swap_tmp;
        if ((swap_tmp = (((&head))->lh_first)) != ((void *) 0)) {
            swap_tmp->node.le_prev = &(((&head))->lh_first);
        }
        if ((swap_tmp = (((&lhead))->lh_first)) != ((void *) 0)) {
            swap_tmp->node.le_prev = &(((&lhead))->lh_first);
        }
    } while (0);
    cur = ((&head)->lh_first);
    while (cur != ((void *) 0)) {
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.le_next);
    }
    cur = ((&lhead)->lh_first);
    while (cur != ((void *) 0)) {
        printf ("\tlhead value is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.le_next);
    }

    do {                        // LIST_REMOVE (LIST_FIRST (&lhead), node);
        if ((((&lhead)->lh_first))->node.le_next != ((void *) 0)) {
            (((&lhead)->lh_first))->node.le_next->node.le_prev = (((&lhead)->lh_first))->node.le_prev;
        }
        *(((&lhead)->lh_first))->node.le_prev = (((&lhead)->lh_first))->node.le_next;
    } while (0);
    do {                        // LIST_REPLACE (LIST_FIRST (&lhead), &node_a, node);
        if (((&node_a)->node.le_next = (((&lhead)->lh_first))->node.le_next) != ((void *) 0)) {
            (&node_a)->node.le_next->node.le_prev = &(&node_a)->node.le_next;
        }
        (&node_a)->node.le_prev = (((&lhead)->lh_first))->node.le_prev;
        *(&node_a)->node.le_prev = (&node_a);
    } while (0);
    puts ("remove first then replace first by node_a");
    cur = ((&lhead)->lh_first);
    while (cur != ((void *) 0)) {
        printf ("\tlhead value is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.le_next);
    }

    struct char_node *tval;
    // LIST_FOREACH_SAFE (cur, &lhead, node, tval)
    for ((cur) = (((&lhead))->lh_first); (cur) && ((tval) = (((cur))->node.le_next), 1); (cur) = (tval)) {
        do {
            if ((cur)->node.le_next != ((void *) 0)) {
                (cur)->node.le_next->node.le_prev = (cur)->node.le_prev;
            }
            *(cur)->node.le_prev = (cur)->node.le_next;
        } while (0);
    }
    puts ("after foreach_safe and removal:");
    printf ("head is%s empty\n", ((&head)->lh_first == ((void *) 0)) ? "" : "n't");
    printf ("lhead is%s empty\n", ((&lhead)->lh_first == ((void *) 0)) ? "" : "n't");

    return 0;
}
