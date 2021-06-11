#include <stdlib.h>
#include <stdio.h>

struct circleq_head {
    struct char_node *cqh_first;
    struct char_node *cqh_last;
};

struct char_node {
    struct {
        struct char_node *cqe_next;
        struct char_node *cqe_prev;
    } node;
    char data;
};

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct char_node node_d = {.data = 'd' };
    struct circleq_head head;

    puts ("circular queue API demo");

    head = (struct circleq_head) {
    (void *) &head, (void *) &head};

    do {
        (&head)->cqh_first = (void *) (&head);
        (&head)->cqh_last = (void *) (&head);
    } while (0);

    do {
        (&node_a)->node.cqe_next = (&head)->cqh_first;
        (&node_a)->node.cqe_prev = (void *) (&head);
        if ((&head)->cqh_last == (void *) (&head)) {
            (&head)->cqh_last = (&node_a);
        } else {
            (&head)->cqh_first->node.cqe_prev = (&node_a);
        }
        (&head)->cqh_first = (&node_a);
    } while (0);

    do {
        (&node_d)->node.cqe_next = (void *) (&head);
        (&node_d)->node.cqe_prev = (&head)->cqh_last;
        if ((&head)->cqh_first == (void *) (&head)) {
            (&head)->cqh_first = (&node_d);
        } else {
            (&head)->cqh_last->node.cqe_next = (&node_d);
        }
        (&head)->cqh_last = (&node_d);
    } while (0);

    do {
        (&node_b)->node.cqe_next = (&node_a)->node.cqe_next;
        (&node_b)->node.cqe_prev = (&node_a);
        if ((&node_a)->node.cqe_next == (void *) (&head)) {
            (&head)->cqh_last = (&node_b);
        } else {
            (&node_a)->node.cqe_next->node.cqe_prev = (&node_b);
        }
        (&node_a)->node.cqe_next = (&node_b);
    } while (0);

    do {
        (&node_c)->node.cqe_next = (&node_d);
        (&node_c)->node.cqe_prev = (&node_d)->node.cqe_prev;
        if ((&node_d)->node.cqe_prev == (void *) (&head)) {
            (&head)->cqh_first = (&node_c);
        } else {
            (&node_d)->node.cqe_prev->node.cqe_next = (&node_c);
        }
        (&node_d)->node.cqe_prev = (&node_c);
    } while (0);

    struct char_node *cur;
    puts ("whole queue travese:");
    for ((cur) = ((&head)->cqh_first); (cur) != ((void *) (&head)); (cur) = ((cur)->node.cqe_next)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }
    puts ("whole queue reverse travese:");
    for ((cur) = ((&head)->cqh_last); (cur) != ((void *) (&head)); (cur) = ((cur)->node.cqe_prev)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }

    do {
        if ((&node_d)->node.cqe_next == (void *) (&head)) {
            (&head)->cqh_last = (&node_d)->node.cqe_prev;
        } else {
            (&node_d)->node.cqe_next->node.cqe_prev = (&node_d)->node.cqe_prev;
        }
        if ((&node_d)->node.cqe_prev == (void *) (&head)) {
            (&head)->cqh_first = (&node_d)->node.cqe_next;
        } else {
            (&node_d)->node.cqe_prev->node.cqe_next = (&node_d)->node.cqe_next;
        }
    } while (0);
    puts ("After d's removal");
    for ((cur) = ((&head)->cqh_first); (cur) != ((void *) (&head)); (cur) = ((cur)->node.cqe_next)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }
    struct char_node *first = ((&head)->cqh_first);
    if (!(((&head)->cqh_first) == ((void *) (&head))))
        printf ("head element is " "%c(%d)" "\n", first->data, first->data);
    struct char_node *second = ((first)->node.cqe_next);
    printf ("second element is " "%c(%d)" "\n", second->data, second->data);
    struct char_node *last = ((&head)->cqh_last);
    if (!(((&head)->cqh_first) == ((void *) (&head))))
        printf ("last element is " "%c(%d)" "\n", last->data, last->data);
    struct char_node *prev = ((last)->node.cqe_prev);
    printf ("previous element is " "%c(%d)" "\n", prev->data, prev->data);

    struct char_node *loopnext = (((last)->node.cqe_next == (void *) (&head)) ? ((&head)->cqh_first) : (last->node.cqe_next));
    printf ("last loop next element is " "%c(%d)" "\n", loopnext->data, loopnext->data);
    struct char_node *loopprev = (((first)->node.cqe_prev == (void *) (&head)) ? ((&head)->cqh_last) : (first->node.cqe_prev));
    printf ("first loop prev element is " "%c(%d)" "\n", loopprev->data, loopprev->data);

    puts ("foreach_safe");
    struct char_node *tval;
    for ((cur) = ((&head)->cqh_first); (cur) != ((void *) (&head)) && ((tval) = ((cur)->node.cqe_next), 1); (cur) = (tval)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }

    puts ("foreach_reverse_safe and remove");
    for ((cur) = ((&head)->cqh_last); (cur) != ((void *) (&head)) && ((tval) = ((cur)->node.cqe_prev)); (cur) = (tval)) {
        do {
            if ((cur)->node.cqe_next == (void *) (&head)) {
                (&head)->cqh_last = (cur)->node.cqe_prev;
            } else {
                (cur)->node.cqe_next->node.cqe_prev = (cur)->node.cqe_prev;
            }
            if ((cur)->node.cqe_prev == (void *) (&head)) {
                (&head)->cqh_first = (cur)->node.cqe_next;
            } else {
                (cur)->node.cqe_prev->node.cqe_next = (cur)->node.cqe_next;
            }
        } while (0);
    }

    printf ("head is%s empty\n", (((&head)->cqh_first) == ((void *) (&head))) ? "" : "n't");

    return 0;
}
