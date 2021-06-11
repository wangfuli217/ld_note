#include <stdlib.h>
#include <stdio.h>

//STAILQ_HEAD (stailq_head, char_node);
struct stailq_head {
    struct char_node *stqh_first;
    struct char_node **stqh_last;
};

struct char_node {
    // STAILQ_ENTRY (char_node) node;
    struct {
        struct char_node *stqe_next;
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

    puts ("singly-linked tail queue API demo");
    struct stailq_head head;

    //STAILQ_HEAD_INITIALIZER (head);
    head = (struct stailq_head) {
    ((void *) 0), &(head).stqh_first};

    //STAILQ_INIT (&head);
    (&head)->stqh_first = ((void *) 0);
    (&head)->stqh_last = &(&head)->stqh_first;

    //STAILQ_INSERT_HEAD (&head, &node_a, node);
    if (((&node_a)->node.stqe_next = (&head)->stqh_first) == ((void *) 0)) {
        (&head)->stqh_last = &(&node_a)->node.stqe_next;
    }
    (&head)->stqh_first = (&node_a);

    // STAILQ_INSERT_TAIL (&head, &node_c, node);
    (&node_c)->node.stqe_next = ((void *) 0);
    *(&head)->stqh_last = (&node_c);
    (&head)->stqh_last = &(&node_c)->node.stqe_next;

    //STAILQ_INSERT_AFTER (&head, &node_a, &node_b, node);
    if (((&node_b)->node.stqe_next = (&node_a)->node.stqe_next) == ((void *) 0)) {
        (&head)->stqh_last = &(&node_b)->node.stqe_next;
    }
    (&node_a)->node.stqe_next = (&node_b);

    //STAILQ_INSERT_AFTER (&head, &node_c, &node_f, node);
    if (((&node_f)->node.stqe_next = (&node_c)->node.stqe_next) == ((void *) 0)) {
        (&head)->stqh_last = &(&node_f)->node.stqe_next;
    }
    (&node_c)->node.stqe_next = (&node_f);

    //STAILQ_INSERT_AFTER (&head, &node_c, &node_e, node);
    if (((&node_e)->node.stqe_next = (&node_c)->node.stqe_next) == ((void *) 0)) {
        (&head)->stqh_last = &(&node_e)->node.stqe_next;
    }
    (&node_c)->node.stqe_next = (&node_e);

    //STAILQ_INSERT_AFTER (&head, &node_c, &node_d, node);
    if (((&node_d)->node.stqe_next = (&node_c)->node.stqe_next) == ((void *) 0)) {
        (&head)->stqh_last = &(&node_d)->node.stqe_next;
    }
    (&node_c)->node.stqe_next = (&node_d);

    puts ("whole simple tail queue:");
    struct char_node *cur;
    for ((cur) = ((&head)->stqh_first); (cur); (cur) = ((cur)->node.stqe_next)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }

    // STAILQ_REMOVE (&head, &node_f, char_node, node);
    if ((&head)->stqh_first == (&node_f)) {
        if ((((&head))->stqh_first = ((&head))->stqh_first->node.stqe_next) == ((void *) 0)) {
            ((&head))->stqh_last = &((&head))->stqh_first;
        }
    } else {
        struct char_node *curelm = (&head)->stqh_first;
        while (curelm->node.stqe_next != (&node_f)) {
            curelm = curelm->node.stqe_next;
        }
        if ((curelm->node.stqe_next = curelm->node.stqe_next->node.stqe_next) == ((void *) 0)) {
            (&head)->stqh_last = &(curelm)->node.stqe_next;
        }
    }

    //STAILQ_REMOVE_AFTER (&head, &node_d, node);
    if ((((&node_d)->node.stqe_next) = ((((&node_d)->node.stqe_next))->node.stqe_next)) == ((void *) 0)) {
        (&head)->stqh_last = &(((&node_d))->node.stqe_next);
    }
    //STAILQ_REMOVE_HEAD (&head, node);
    if (((&head)->stqh_first = (&head)->stqh_first->node.stqe_next) == ((void *) 0)) {
        (&head)->stqh_last = &(&head)->stqh_first;
    }

    puts ("After node f and  d'after and head removal:");
    for ((cur) = ((&head)->stqh_first); (cur); (cur) = ((cur)->node.stqe_next)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
    }

    //STAILQ_FIRST (&head);
    struct char_node *first = ((&head)->stqh_first);
    if (first != ((void *) 0))
        printf ("head element is " "%c(%d)" "\n", first->data, first->data);

    //STAILQ_NEXT (first, node);
    struct char_node *second = ((first)->node.stqe_next);
    if (second != ((void *) 0))
        printf ("second element is " "%c(%d)" "\n", second->data, second->data);

    //STAILQ_LAST (&head, char_node, node);
    struct char_node *last = ((((&head))->stqh_first == ((void *) 0)) ? ((void *) 0) : ((struct char_node *) (void *) ((char *) ((&head)->stqh_last) - __builtin_offsetof (struct char_node, node))));
    if (last != ((void *) 0))
        printf ("last element is " "%c(%d)" "\n", last->data, last->data);

    puts ("Iterate whole list:");
    cur = ((&head)->stqh_first);
    while (cur != ((void *) 0)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.stqe_next);
    }

    // STAILQ_REMOVE_HEAD_UNTIL (&head, &node_c, node);
    if (((((&head))->stqh_first) = (((&node_c))->node.stqe_next)) == ((void *) 0)) {
        (&head)->stqh_last = &(((&head))->stqh_first);
    }
    puts ("remove until node c");
    cur = ((&head)->stqh_first);
    while (cur != ((void *) 0)) {
        printf ("\tvalue is " "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.stqe_next);
    }

    struct stailq_head stqhead;
    do {
        (&stqhead)->stqh_first = ((void *) 0);
        (&stqhead)->stqh_last = &(&stqhead)->stqh_first;
    } while (0);
    do {
        if (((&node_a)->node.stqe_next = (&stqhead)->stqh_first) == ((void *) 0)) {
            (&stqhead)->stqh_last = &(&node_a)->node.stqe_next;
        }
        (&stqhead)->stqh_first = (&node_a);
    } while (0);
    do {
        if (((&node_b)->node.stqe_next = (&node_a)->node.stqe_next) == ((void *) 0)) {
            (&stqhead)->stqh_last = &(&node_b)->node.stqe_next;
        }
        (&node_a)->node.stqe_next = (&node_b);
    } while (0);
    do {
        if (((&node_c)->node.stqe_next = (&node_b)->node.stqe_next) == ((void *) 0)) {
            (&stqhead)->stqh_last = &(&node_c)->node.stqe_next;
        }
        (&node_b)->node.stqe_next = (&node_c);
    } while (0);
    puts ("swap stailq between stqhead and head");
    // STAILQ_SWAP (&head, &stqhead, char_node);
    do {
        struct char_node *swap_first = ((&head)->stqh_first);
        struct char_node **swap_last = (&head)->stqh_last;
        ((&head)->stqh_first) = ((&stqhead)->stqh_first);
        (&head)->stqh_last = (&stqhead)->stqh_last;
        ((&stqhead)->stqh_first) = swap_first;
        (&stqhead)->stqh_last = swap_last;
        if (((&head)->stqh_first == ((void *) 0))) {
            (&head)->stqh_last = &((&head)->stqh_first);
        }
        if (((&stqhead)->stqh_first == ((void *) 0))) {
            (&stqhead)->stqh_last = &((&stqhead)->stqh_first);
        }
    } while (0);
    cur = ((&head)->stqh_first);
    while (cur != ((void *) 0)) {
        printf ("\thead value is" "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.stqe_next);
    }
    cur = ((&stqhead)->stqh_first);
    while (cur != ((void *) 0)) {
        printf ("\tstqhead value is" "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.stqe_next);
    }

    puts ("concat stailq head and stqhead");
    // STAILQ_CONCAT (&head, &stqhead);
    do {
        if (!(((&stqhead))->stqh_first == ((void *) 0))) {
            *(&head)->stqh_last = (&stqhead)->stqh_first;
            (&head)->stqh_last = (&stqhead)->stqh_last;
            do {
                ((&stqhead))->stqh_first = ((void *) 0);
                ((&stqhead))->stqh_last = &((&stqhead))->stqh_first;
            } while (0);
        }
    } while (0);
    cur = ((&head)->stqh_first);
    while (cur != ((void *) 0)) {
        printf ("\thead value is" "%c(%d)" "\n", cur->data, cur->data);
        cur = ((cur)->node.stqe_next);
    }

    struct char_node *tval;
    //STAILQ_FOREACH_SAFE (cur, &head, node, tval)
    for ((cur) = (((&head))->stqh_first); (cur) && ((tval) = (((cur))->node.stqe_next), 1); (cur) = (tval)) {
        do {
            if ((&head)->stqh_first == (cur)) {
                do {
                    if ((((&head))->stqh_first = ((&head))->stqh_first->node.stqe_next) == ((void *) 0)) {
                        ((&head))->stqh_last = &((&head))->stqh_first;
                    }
                } while (0);
            } else {
                struct char_node *curelm = (&head)->stqh_first;
                while (curelm->node.stqe_next != (cur)) {
                    curelm = curelm->node.stqe_next;
                }
                if ((curelm->node.stqe_next = curelm->node.stqe_next->node.stqe_next) == ((void *) 0)) {
                    (&head)->stqh_last = &(curelm)->node.stqe_next;
                }
        }} while (0);
    }

    printf ("head is%s empty\n", ((&head)->stqh_first == ((void *) 0)) ? "" : "n't");
    printf ("stqhead is%s empty\n", ((&stqhead)->stqh_first == ((void *) 0)) ? "" : "n't");

    return 0;
}
