#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct animal_ {
    struct {
        struct animal_ *stqe_next;
    } link;
    char name[32];
} animal;

struct animal_head_ {
    struct animal_ *stqh_first;
    struct animal_ **stqh_last;
};
typedef struct animal_head_ animal_head;

int main (void) {

    animal_head bird_stailq;
    do {
        (&bird_stailq)->stqh_first = ((void *) 0);
        (&bird_stailq)->stqh_last = &(&bird_stailq)->stqh_first;
    } while (0);

    if (((&bird_stailq)->stqh_first == ((void *) 0))) {
        printf ("There is not any bird in the single tail queue\n");
        printf ("\n");
    }

    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    do {
        if (((&duck)->link.stqe_next = (&bird_stailq)->stqh_first) == ((void *) 0)) {
            (&bird_stailq)->stqh_last = &(&duck)->link.stqe_next;
        }
        (&bird_stailq)->stqh_first = (&duck);
    } while (0);

    animal *bird = ((void *) 0);
    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    animal sparrow;
    strcpy (sparrow.name, "sparrow");
    printf ("Insert tail %s\n", sparrow.name);
    do {
        (&sparrow)->link.stqe_next = ((void *) 0);
        *(&bird_stailq)->stqh_last = (&sparrow);
        (&bird_stailq)->stqh_last = &(&sparrow)->link.stqe_next;
    } while (0);

    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s\n", chicken.name, duck.name);
    do {
        if (((&chicken)->link.stqe_next = (&duck)->link.stqe_next) == ((void *) 0)) {
            (&bird_stailq)->stqh_last = &(&chicken)->link.stqe_next;
        }
        (&duck)->link.stqe_next = (&chicken);
    } while (0);

    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    bird = ((&bird_stailq)->stqh_first);
    if (bird != ((void *) 0)) {
        printf ("The first bird in the single tail queue is %s\n", bird->name);
    } else {
        printf ("The single tail queue is empty, no first bird found");
        printf ("\n");
    }

    bird = ((&chicken)->link.stqe_next);
    if (bird != ((void *) 0)) {
        printf ("The next bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf ("The next bird of %s, is NULL\n", chicken.name);
    }

    bird = ((((&bird_stailq))->stqh_first == ((void *) 0)) ? ((void *) 0) : ((struct animal_ *) (void *) ((char *) ((&bird_stailq)->stqh_last) - __builtin_offsetof (struct animal_, link))));
    if (bird != ((void *) 0)) {
        printf ("The last bird of %s\n", bird->name);
    } else {
        printf ("The last bird of is NULL\n");
    }
    printf ("\n");

    do {
        if (((&bird_stailq)->stqh_first = (&bird_stailq)->stqh_first->link.stqe_next) == ((void *) 0)) {
            (&bird_stailq)->stqh_last = &(&bird_stailq)->stqh_first;
        }
    } while (0);
    printf ("Remove the head item in the single tail queue");

    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    bird = ((&bird_stailq)->stqh_first);
    while (bird != ((void *) 0)) {
        printf ("bird name is %s\n", bird->name);
        bird = ((bird)->link.stqe_next);
    }

    animal *tval;
    for ((bird) = (((&bird_stailq))->stqh_first); (bird) && ((tval) = (((bird))->link.stqe_next), 1); (bird) = (tval)) {
        do {
            if ((&bird_stailq)->stqh_first == (bird)) {
                do {
                    if ((((&bird_stailq))->stqh_first = ((&bird_stailq))->stqh_first->link.stqe_next) == ((void *) 0)) {
                        ((&bird_stailq))->stqh_last = &((&bird_stailq))->stqh_first;
                    }
                } while (0);
            } else {
                struct animal_ *curelm = (&bird_stailq)->stqh_first;
                while (curelm->link.stqe_next != (bird)) {
                    curelm = curelm->link.stqe_next;
                }
                if ((curelm->link.stqe_next = curelm->link.stqe_next->link.stqe_next) == ((void *) 0)) {
                    (&bird_stailq)->stqh_last = &(curelm)->link.stqe_next;
                }
        }} while (0);
    }
    do {
        if (((&duck)->link.stqe_next = (&bird_stailq)->stqh_first) == ((void *) 0)) {
            (&bird_stailq)->stqh_last = &(&duck)->link.stqe_next;
        }
        (&bird_stailq)->stqh_first = (&duck);
    } while (0);
    do {
        if (((&chicken)->link.stqe_next = (&bird_stailq)->stqh_first) == ((void *) 0)) {
            (&bird_stailq)->stqh_last = &(&chicken)->link.stqe_next;
        }
        (&bird_stailq)->stqh_first = (&chicken);
    } while (0);
    do {
        if (((&sparrow)->link.stqe_next = (&bird_stailq)->stqh_first) == ((void *) 0)) {
            (&bird_stailq)->stqh_last = &(&sparrow)->link.stqe_next;
        }
        (&bird_stailq)->stqh_first = (&sparrow);
    } while (0);

    do {
        if ((&bird_stailq)->stqh_first == (&sparrow)) {
            do {
                if ((((&bird_stailq))->stqh_first = ((&bird_stailq))->stqh_first->link.stqe_next) == ((void *) 0)) {
                    ((&bird_stailq))->stqh_last = &((&bird_stailq))->stqh_first;
                }
            } while (0);
        } else {
            struct animal_ *curelm = (&bird_stailq)->stqh_first;
            while (curelm->link.stqe_next != (&sparrow)) {
                curelm = curelm->link.stqe_next;
            }
            if ((curelm->link.stqe_next = curelm->link.stqe_next->link.stqe_next) == ((void *) 0)) {
                (&bird_stailq)->stqh_last = &(curelm)->link.stqe_next;
            }
    }} while (0);
    printf ("Remove %s from single tail queue \n", sparrow.name);

    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    if (((&bird_stailq)->stqh_first == ((void *) 0))) {
        printf ("The bird single tail queue is empty\n");
    } else {
        printf ("The bird single tail queue is not empty\n");
    }
    printf ("\n");

    printf ("Create insect single tail queue. \n");

    animal_head insect_stailq;
    do {
        (&insect_stailq)->stqh_first = ((void *) 0);
        (&insect_stailq)->stqh_last = &(&insect_stailq)->stqh_first;
    } while (0);

    animal bee;
    strcpy (bee.name, "bee");
    printf ("Insert head %s\n", bee.name);
    do {
        if (((&bee)->link.stqe_next = (&insect_stailq)->stqh_first) == ((void *) 0)) {
            (&insect_stailq)->stqh_last = &(&bee)->link.stqe_next;
        }
        (&insect_stailq)->stqh_first = (&bee);
    } while (0);

    animal cricket;
    strcpy (cricket.name, "cricket");
    printf ("Insert head %s\n", cricket.name);
    do {
        if (((&cricket)->link.stqe_next = (&insect_stailq)->stqh_first) == ((void *) 0)) {
            (&insect_stailq)->stqh_last = &(&cricket)->link.stqe_next;
        }
        (&insect_stailq)->stqh_first = (&cricket);
    } while (0);

    animal wasp;
    strcpy (wasp.name, "wasp");
    printf ("Insert head %s\n", wasp.name);
    do {
        if (((&wasp)->link.stqe_next = (&insect_stailq)->stqh_first) == ((void *) 0)) {
            (&insect_stailq)->stqh_last = &(&wasp)->link.stqe_next;
        }
        (&insect_stailq)->stqh_first = (&wasp);
    } while (0);

    printf ("\n");
    printf ("Insect single tail queue has:\n");
    animal *insect = ((void *) 0);
    for ((insect) = ((&insect_stailq)->stqh_first); (insect); (insect) = ((insect)->link.stqe_next))
        printf ("\tinset name is %s\n", insect->name);
    printf ("\n");

    printf ("bird single tail queue has:\n");
    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tinset name is %s\n", bird->name);
    printf ("\n");

    printf ("Concat insect single tail queue into bird single tail queue!\n\n");
    do {
        if (!(((&insect_stailq))->stqh_first == ((void *) 0))) {
            *(&bird_stailq)->stqh_last = (&insect_stailq)->stqh_first;
            (&bird_stailq)->stqh_last = (&insect_stailq)->stqh_last;
            do {
                ((&insect_stailq))->stqh_first = ((void *) 0);
                ((&insect_stailq))->stqh_last = &((&insect_stailq))->stqh_first;
            } while (0);
        }
    } while (0);

    printf ("bird single tail queue has:\n");
    for ((bird) = ((&bird_stailq)->stqh_first); (bird); (bird) = ((bird)->link.stqe_next))
        printf ("\tinsect name is %s\n", bird->name);
    printf ("\n");

    return 0;
}
