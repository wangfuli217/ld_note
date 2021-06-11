#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct animal_ {
    struct {
        struct animal_ *tqe_next;
        struct animal_ **tqe_prev;
    } link;
    char name[32];
} animal;

struct animal_head_ {
    struct animal_ *tqh_first;
    struct animal_ **tqh_last;
};
typedef struct animal_head_ animal_head;

int main (void) {

    animal_head bird_tailq;
    do {
        (&bird_tailq)->tqh_first = ((void *) 0);
        (&bird_tailq)->tqh_last = &(&bird_tailq)->tqh_first;
    } while (0);

    if (((&bird_tailq)->tqh_first == ((void *) 0))) {
        printf ("There is not any bird in the tail queue\n");
        printf ("\n");
    }

    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    do {
        if (((&duck)->link.tqe_next = (&bird_tailq)->tqh_first) != ((void *) 0))
            (&bird_tailq)->tqh_first->link.tqe_prev = &(&duck)->link.tqe_next;
        else
            (&bird_tailq)->tqh_last = &(&duck)->link.tqe_next;
        (&bird_tailq)->tqh_first = (&duck);
        (&duck)->link.tqe_prev = &(&bird_tailq)->tqh_first;
    } while (0);

    animal *bird = ((void *) 0);
    for ((bird) = ((&bird_tailq)->tqh_first); (bird); (bird) = ((bird)->link.tqe_next))
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    animal sparrow;
    strcpy (sparrow.name, "sparrow");
    printf ("Insert tail %s\n", sparrow.name);
    do {
        (&sparrow)->link.tqe_next = ((void *) 0);
        (&sparrow)->link.tqe_prev = (&bird_tailq)->tqh_last;
        *(&bird_tailq)->tqh_last = (&sparrow);
        (&bird_tailq)->tqh_last = &(&sparrow)->link.tqe_next;
    } while (0);

    bird = ((void *) 0);
    for ((bird) = ((&bird_tailq)->tqh_first); (bird); (bird) = ((bird)->link.tqe_next))
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s \n", chicken.name, duck.name);
    do {
        if (((&chicken)->link.tqe_next = (&duck)->link.tqe_next) != ((void *) 0))
            (&chicken)->link.tqe_next->link.tqe_prev = &(&chicken)->link.tqe_next;
        else
            (&bird_tailq)->tqh_last = &(&chicken)->link.tqe_next;
        (&duck)->link.tqe_next = (&chicken);
        (&chicken)->link.tqe_prev = &(&duck)->link.tqe_next;
    } while (0);

    bird = ((void *) 0);
    for ((bird) = ((&bird_tailq)->tqh_first); (bird); (bird) = ((bird)->link.tqe_next))
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    animal goose;
    strcpy (goose.name, "goose");
    printf ("Insert %s before %s\n", goose.name, duck.name);
    do {
        (&goose)->link.tqe_prev = (&duck)->link.tqe_prev;
        (&goose)->link.tqe_next = (&duck);
        *(&duck)->link.tqe_prev = (&goose);
        (&duck)->link.tqe_prev = &(&goose)->link.tqe_next;
    } while (0);

    bird = ((void *) 0);
    for ((bird) = ((&bird_tailq)->tqh_first); (bird); (bird) = ((bird)->link.tqe_next))
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    bird = ((&bird_tailq)->tqh_first);
    if (bird == ((void *) 0)) {
        printf ("The first bird in the tail queue is %s", bird->name);
    } else {
        printf ("The tail queue is empty, no first bird found\n");
    }
    printf ("\n");

    bird = (*(((struct animal_head_ *) ((&bird_tailq)->tqh_last))->tqh_last));
    if (bird == ((void *) 0)) {
        printf ("The last bird in the tail queue is %s\n", bird->name);
    } else {
        printf ("The tail queue is empty, no last bird found\n");
    }
    printf ("\n");

    bird = ((&chicken)->link.tqe_next);
    if (bird == ((void *) 0)) {
        printf ("The next bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf ("The next bird of %s is NULL\n", chicken.name);
    }
    printf ("\n");

    bird = (*(((struct animal_head_ *) ((&chicken)->link.tqe_prev))->tqh_last));
    if (bird == ((void *) 0)) {
        printf ("The pre bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf ("The pre bird of %s is NULL\n", chicken.name);
    }
    printf ("\n");

    do {
        if (((&sparrow)->link.tqe_next) != ((void *) 0))
            (&sparrow)->link.tqe_next->link.tqe_prev = (&sparrow)->link.tqe_prev;
        else
            (&bird_tailq)->tqh_last = (&sparrow)->link.tqe_prev;
        *(&sparrow)->link.tqe_prev = (&sparrow)->link.tqe_next;
    } while (0);
    printf ("Remove %s from tail queue\n", sparrow.name);

    bird = ((void *) 0);
    for ((bird) = ((&bird_tailq)->tqh_first); (bird); (bird) = ((bird)->link.tqe_next))
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    return 0;
}
