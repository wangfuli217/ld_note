#include <stdlib.h>
#include <stdio.h>

//TAILQ_HEAD (tailq_head, char_node);
struct tailq_head {
    struct char_node *tqh_first;
    struct char_node **tqh_last;
};

struct char_node {
    // TAILQ_ENTRY (char_node) node;
    struct {
        struct char_node *tqe_next;
        struct char_node **tqe_prev;
    } node;
    char data;
};

int main (void) {
    struct char_node node_a = {.data = 'a' };
    struct char_node node_b = {.data = 'b' };
    struct char_node node_c = {.data = 'c' };
    struct char_node node_d = {.data = 'd' };
    struct char_node node_e = {.data = 'e' };
    struct char_node node_f = {.data = 'f' };
    struct tailq_head head;

    puts ("doubly-linked tail queue API demo");

    // TAILQ_HEAD_INITIALIZER (head);
    head = (struct tailq_head) {
    ((void *) 0), &(head).tqh_first};

    do {                        // TAILQ_INIT (&head);
        (&head)->tqh_first = ((void *) 0);
        (&head)->tqh_last = &(&head)->tqh_first;
    } while (0);

    do {                        // TAILQ_INSERT_HEAD (&head, &node_a, node);
        if (((&node_a)->node.tqe_next = (&head)->tqh_first) != ((void *) 0)) {
            (&head)->tqh_first->node.tqe_prev = &(&node_a)->node.tqe_next;
        } else {
            (&head)->tqh_last = &(&node_a)->node.tqe_next;
        }
        (&head)->tqh_first = (&node_a);
        (&node_a)->node.tqe_prev = &(&head)->tqh_first;
    } while (0);

    do {                        //TAILQ_INSERT_TAIL (&head, &node_c, node);
        (&node_c)->node.tqe_next = ((void *) 0);
        (&node_c)->node.tqe_prev = (&head)->tqh_last;
        *(&head)->tqh_last = (&node_c);
        (&head)->tqh_last = &(&node_c)->node.tqe_next;
    } while (0);

    do {                        //TAILQ_INSERT_AFTER (&head, &node_a, &node_b, node);
        if (((&node_b)->node.tqe_next = (&node_a)->node.tqe_next) != ((void *) 0)) {
            (&node_b)->node.tqe_next->node.tqe_prev = &(&node_b)->node.tqe_next;
        } else {
            (&head)->tqh_last = &(&node_b)->node.tqe_next;
        }
        (&node_a)->node.tqe_next = (&node_b);
        (&node_b)->node.tqe_prev = &(&node_a)->node.tqe_next;
    } while (0);

    do {                        //TAILQ_INSERT_BEFORE (&node_a, &node_d, node);
        (&node_d)->node.tqe_prev = (&node_a)->node.tqe_prev;
        (&node_d)->node.tqe_next = (&node_a);
        *(&node_a)->node.tqe_prev = (&node_d);
        (&node_a)->node.tqe_prev = &(&node_d)->node.tqe_next;
    } while (0);

    puts ("whole queue:");
    struct char_node *cur;
    for ((cur) = ((&head)->tqh_first); (cur) != ((void *) 0); (cur) = ((cur)->node.tqe_next)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }

    do {                        //TAILQ_REMOVE (&head, &node_d, node);
        if (((&node_d)->node.tqe_next) != ((void *) 0)) {
            (&node_d)->node.tqe_next->node.tqe_prev = (&node_d)->node.tqe_prev;
        } else {
            (&head)->tqh_last = (&node_d)->node.tqe_prev;
        }
        *(&node_d)->node.tqe_prev = (&node_d)->node.tqe_next;
    } while (0);
    puts ("After d's removal:");
    for ((cur) = ((&head)->tqh_first); (cur) != ((void *) 0); (cur) = ((cur)->node.tqe_next)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }

    //TAILQ_FIRST (&head);
    struct char_node *first = ((&head)->tqh_first);
    if (first != ((void *) 0))
        printf ("head element is " "%c(%d)" "\n", first->data, first->data);

    //TAILQ_NEXT (first, node)
    struct char_node *second = ((first)->node.tqe_next);
    if (second != ((void *) 0))
        printf ("second element is " "%c(%d)" "\n", second->data, second->data);

    // TAILQ_LAST (&head, tailq_head);
    struct char_node *last = (*(((struct tailq_head *) ((&head)->tqh_last))->tqh_last));
    if (last != ((void *) 0))
        printf ("last element is " "%c(%d)" "\n", last->data, last->data);

    //TAILQ_PREV (last, tailq_head, node);
    struct char_node *previous = (*(((struct tailq_head *) ((last)->node.tqe_prev))->tqh_last));
    if (previous != ((void *) 0))
        printf ("previous element is " "%c(%d)" "\n", previous->data, previous->data);

    struct tailq_head tqhead;
    do {
        (&tqhead)->tqh_first = ((void *) 0);
        (&tqhead)->tqh_last = &(&tqhead)->tqh_first;
    } while (0);
    do {
        if (((&node_f)->node.tqe_next = (&tqhead)->tqh_first) != ((void *) 0)) {
            (&tqhead)->tqh_first->node.tqe_prev = &(&node_f)->node.tqe_next;
        } else {
            (&tqhead)->tqh_last = &(&node_f)->node.tqe_next;
        }
        (&tqhead)->tqh_first = (&node_f);
        (&node_f)->node.tqe_prev = &(&tqhead)->tqh_first;
    } while (0);
    do {
        if (((&node_e)->node.tqe_next = (&tqhead)->tqh_first) != ((void *) 0)) {
            (&tqhead)->tqh_first->node.tqe_prev = &(&node_e)->node.tqe_next;
        } else {
            (&tqhead)->tqh_last = &(&node_e)->node.tqe_next;
        }
        (&tqhead)->tqh_first = (&node_e);
        (&node_e)->node.tqe_prev = &(&tqhead)->tqh_first;
    } while (0);
    do {
        if (((&node_d)->node.tqe_next = (&tqhead)->tqh_first) != ((void *) 0)) {
            (&tqhead)->tqh_first->node.tqe_prev = &(&node_d)->node.tqe_next;
        } else {
            (&tqhead)->tqh_last = &(&node_d)->node.tqe_next;
        }
        (&tqhead)->tqh_first = (&node_d);
        (&node_d)->node.tqe_prev = &(&tqhead)->tqh_first;
    } while (0);
    puts ("head and tqhead whole queue:");
    cur = ((&head)->tqh_first);
    while (cur != ((void *) 0)) {
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.tqe_next);
    }
    cur = ((&tqhead)->tqh_first);
    while (cur != ((void *) 0)) {
        printf ("\ttqhead value is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.tqe_next);
    }

    puts ("swap tailq between head and tqhead");
    do {                        // TAILQ_SWAP (&head, &tqhead, char_node, node);
        struct char_node *swap_first = (&head)->tqh_first;
        struct char_node **swap_last = (&head)->tqh_last;
        (&head)->tqh_first = (&tqhead)->tqh_first;
        (&head)->tqh_last = (&tqhead)->tqh_last;
        (&tqhead)->tqh_first = swap_first;
        (&tqhead)->tqh_last = swap_last;
        if ((swap_first = (&head)->tqh_first) != ((void *) 0)) {
            swap_first->node.tqe_prev = &(&head)->tqh_first;
        } else {
            (&head)->tqh_last = &(&head)->tqh_first;
        }
        if ((swap_first = (&tqhead)->tqh_first) != ((void *) 0)) {
            swap_first->node.tqe_prev = &(&tqhead)->tqh_first;
        } else {
            (&tqhead)->tqh_last = &(&tqhead)->tqh_first;
        }
    } while (0);
    for ((cur) = ((&head)->tqh_first); (cur) != ((void *) 0); (cur) = ((cur)->node.tqe_next)) {
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);
    }
    for ((cur) = ((&tqhead)->tqh_first); (cur) != ((void *) 0); (cur) = ((cur)->node.tqe_next)) {
        printf ("\ttqhead value is " "%c(%d)" "\n", cur->data, cur->data);
    }

    puts ("reverse head and tqhead");
    for ((cur) = (*(((struct tailq_head *) ((&head)->tqh_last))->tqh_last)); (cur) != ((void *) 0); (cur) = (*(((struct tailq_head *) ((cur)->node.tqe_prev))->tqh_last))) {
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);
    }
    for ((cur) = (*(((struct tailq_head *) ((&tqhead)->tqh_last))->tqh_last)); (cur) != ((void *) 0); (cur) = (*(((struct tailq_head *) ((cur)->node.tqe_prev))->tqh_last))) {
        printf ("\ttqhead value is " "%c(%d)" "\n", cur->data, cur->data);
    }

    do {                        // TAILQ_CONCAT (&head, &tqhead, node);
        if (!((&tqhead)->tqh_first == ((void *) 0))) {
            *(&head)->tqh_last = (&tqhead)->tqh_first;
            (&tqhead)->tqh_first->node.tqe_prev = (&head)->tqh_last;
            (&head)->tqh_last = (&tqhead)->tqh_last;
            do {
                ((&tqhead))->tqh_first = ((void *) 0);
                ((&tqhead))->tqh_last = &((&tqhead))->tqh_first;
            } while (0);
        }
    } while (0);
    puts ("concat head and tqhead");
    for ((cur) = (*(((struct tailq_head *) ((&head)->tqh_last))->tqh_last)); (cur) != ((void *) 0); (cur) = (*(((struct tailq_head *) ((cur)->node.tqe_prev))->tqh_last))) {
        printf ("\thead value is " "%c(%d)" "\n", cur->data, cur->data);
    }

    puts ("after foreach_safe and remove:");
    struct char_node *tval;
    for ((cur) = ((&head)->tqh_first); (cur) != ((void *) 0) && ((tval) = ((cur)->node.tqe_next), 1); (cur) = (tval)) {
        do {
            if (((cur)->node.tqe_next) != ((void *) 0)) {
                (cur)->node.tqe_next->node.tqe_prev = (cur)->node.tqe_prev;
            } else {
                (&head)->tqh_last = (cur)->node.tqe_prev;
            }
            *(cur)->node.tqe_prev = (cur)->node.tqe_next;
        } while (0);
    }
    printf ("head is %s empty\n", ((&head)->tqh_first == ((void *) 0)) ? "" : "n't");

    do {
        (&tqhead)->tqh_first = ((void *) 0);
        (&tqhead)->tqh_last = &(&tqhead)->tqh_first;
    } while (0);
    do {
        if (((&node_f)->node.tqe_next = (&tqhead)->tqh_first) != ((void *) 0)) {
            (&tqhead)->tqh_first->node.tqe_prev = &(&node_f)->node.tqe_next;
        } else {
            (&tqhead)->tqh_last = &(&node_f)->node.tqe_next;
        }
        (&tqhead)->tqh_first = (&node_f);
        (&node_f)->node.tqe_prev = &(&tqhead)->tqh_first;
    } while (0);
    do {
        if (((&node_e)->node.tqe_next = (&tqhead)->tqh_first) != ((void *) 0)) {
            (&tqhead)->tqh_first->node.tqe_prev = &(&node_e)->node.tqe_next;
        } else {
            (&tqhead)->tqh_last = &(&node_e)->node.tqe_next;
        }
        (&tqhead)->tqh_first = (&node_e);
        (&node_e)->node.tqe_prev = &(&tqhead)->tqh_first;
    } while (0);
    do {
        if (((&node_d)->node.tqe_next = (&tqhead)->tqh_first) != ((void *) 0)) {
            (&tqhead)->tqh_first->node.tqe_prev = &(&node_d)->node.tqe_next;
        } else {
            (&tqhead)->tqh_last = &(&node_d)->node.tqe_next;
        }
        (&tqhead)->tqh_first = (&node_d);
        (&node_d)->node.tqe_prev = &(&tqhead)->tqh_first;
    } while (0);
    puts ("tqhead whole queue and foreach_reverse_safe");
    for ((cur) = (*(((struct tailq_head *) ((&tqhead)->tqh_last))->tqh_last)); (cur) != ((void *) 0); (cur) = (*(((struct tailq_head *) ((cur)->node.tqe_prev))->tqh_last))) {
        printf ("\ttqhead value is " "%c(%d)" "\n", cur->data, cur->data);
    }
    for ((cur) = (*(((struct tailq_head *) (((&head))->tqh_last))->tqh_last)); (cur) != ((void *) 0) && ((tval) = (*(((struct tailq_head *) (((cur))->node.tqe_prev))->tqh_last)), 1); (cur) = (tval)) {
        do {
            if (((cur)->node.tqe_next) != ((void *) 0)) {
                (cur)->node.tqe_next->node.tqe_prev = (cur)->node.tqe_prev;
            } else {
                (&head)->tqh_last = (cur)->node.tqe_prev;
            }
            *(cur)->node.tqe_prev = (cur)->node.tqe_next;
        } while (0);
    }
    printf ("tqhead is %s empty\n", ((&head)->tqh_first == ((void *) 0)) ? "" : "n't");

    return 0;
}
