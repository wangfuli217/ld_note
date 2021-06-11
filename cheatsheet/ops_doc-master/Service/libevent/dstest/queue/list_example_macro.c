#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct animal_ {
    struct {
        struct animal_ *le_next;
        struct animal_ **le_prev;
    } link;
    char name[32];
} animal;

struct animal_head_ {
    struct animal_ *lh_first;
};
typedef struct animal_head_ animal_head;

int main (void) {

    animal_head bird_list;
    do {
        (&bird_list)->lh_first = ((void *) 0);
    } while (0);

    if (((&bird_list)->lh_first == ((void *) 0))) {
        printf ("There is not any bird in the list\n");
        printf ("\n");
    }

    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    do {
        if (((&duck)->link.le_next = (&bird_list)->lh_first) != ((void *) 0)) {
            (&bird_list)->lh_first->link.le_prev = &(&duck)->link.le_next;
        }
        (&bird_list)->lh_first = (&duck);
        (&duck)->link.le_prev = &(&bird_list)->lh_first;
    } while (0);

    animal *bird = ((void *) 0);
    for ((bird) = ((&bird_list)->lh_first); (bird); (bird) = ((bird)->link.le_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s\n", chicken.name, duck.name);
    do {
        if (((&chicken)->link.le_next = (&duck)->link.le_next) != ((void *) 0)) {
            (&duck)->link.le_next->link.le_prev = &(&chicken)->link.le_next;
        }
        (&duck)->link.le_next = (&chicken);
        (&chicken)->link.le_prev = &(&duck)->link.le_next;
    } while (0);

    for ((bird) = ((&bird_list)->lh_first); (bird); (bird) = ((bird)->link.le_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    animal goose;
    strcpy (goose.name, "goose");
    printf ("Insert %s before %s\n", goose.name, chicken.name);
    do {
        (&goose)->link.le_prev = (&chicken)->link.le_prev;
        (&goose)->link.le_next = (&chicken);
        *(&chicken)->link.le_prev = (&goose);
        (&chicken)->link.le_prev = &(&goose)->link.le_next;
    } while (0);

    for ((bird) = ((&bird_list)->lh_first); (bird); (bird) = ((bird)->link.le_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    animal hen;
    strcpy (hen.name, "hen");
    printf ("Insert head %s\n", hen.name);
    do {
        if (((&hen)->link.le_next = (&bird_list)->lh_first) != ((void *) 0)) {
            (&bird_list)->lh_first->link.le_prev = &(&hen)->link.le_next;
        }
        (&bird_list)->lh_first = (&hen);
        (&hen)->link.le_prev = &(&bird_list)->lh_first;
    } while (0);

    for ((bird) = ((&bird_list)->lh_first); (bird); (bird) = ((bird)->link.le_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    bird = ((&bird_list)->lh_first);
    if (bird != ((void *) 0)) {
        printf ("The first bird in the list is %s\n", bird->name);
    } else {
        printf ("The list is emtpy, no first bird found\n");
    }

    bird = ((&goose)->link.le_next);
    if (bird != ((void *) 0)) {
        printf ("The next bird of %s, is %s\n", goose.name, bird->name);
    } else {
        printf ("The next bird of %s is NULL\n", goose.name);
    }

    printf ("Iterate by hand\n");
    bird = ((&bird_list)->lh_first);
    while (bird != ((void *) 0)) {
        printf ("\tbird name is %s\n", bird->name);
        bird = ((bird)->link.le_next);
    }

    printf ("list foreach safe in remove\n");
    animal *tval;
    for ((bird) = (((&bird_list))->lh_first); (bird) && ((tval) = (((bird))->link.le_next), 1); (bird) = (tval)) {
        do {
            if ((bird)->link.le_next != ((void *) 0)) {
                (bird)->link.le_next->link.le_prev = (bird)->link.le_prev;
            }
            *(bird)->link.le_prev = (bird)->link.le_next;
        } while (0);
    }
    if (((&bird_list)->lh_first == ((void *) 0))) {
        printf ("The bird list is empty\n");
    } else {
        printf ("The bird list is not empty\n");
    }

    do {
        if (((&chicken)->link.le_next = (&bird_list)->lh_first) != ((void *) 0)) {
            (&bird_list)->lh_first->link.le_prev = &(&chicken)->link.le_next;
        }
        (&bird_list)->lh_first = (&chicken);
        (&chicken)->link.le_prev = &(&bird_list)->lh_first;
    } while (0);
    do {
        if (((&goose)->link.le_next = (&bird_list)->lh_first) != ((void *) 0)) {
            (&bird_list)->lh_first->link.le_prev = &(&goose)->link.le_next;
        }
        (&bird_list)->lh_first = (&goose);
        (&goose)->link.le_prev = &(&bird_list)->lh_first;
    } while (0);
    do {
        if (((&duck)->link.le_next = (&bird_list)->lh_first) != ((void *) 0)) {
            (&bird_list)->lh_first->link.le_prev = &(&duck)->link.le_next;
        }
        (&bird_list)->lh_first = (&duck);
        (&duck)->link.le_prev = &(&bird_list)->lh_first;
    } while (0);
    do {
        if (((&hen)->link.le_next = (&bird_list)->lh_first) != ((void *) 0)) {
            (&bird_list)->lh_first->link.le_prev = &(&hen)->link.le_next;
        }
        (&bird_list)->lh_first = (&hen);
        (&hen)->link.le_prev = &(&bird_list)->lh_first;
    } while (0);

    do {
        if ((&goose)->link.le_next != ((void *) 0)) {
            (&goose)->link.le_next->link.le_prev = (&goose)->link.le_prev;
        }
        *(&goose)->link.le_prev = (&goose)->link.le_next;
    } while (0);
    printf ("Remove %s from list\n", goose.name);

    bird = ((void *) 0);
    for ((bird) = ((&bird_list)->lh_first); (bird); (bird) = ((bird)->link.le_next))
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    if (((&bird_list)->lh_first == ((void *) 0))) {
        printf ("The bird list is empty\n");
    } else {
        printf ("The bird list is not empty\n");
    }
    printf ("\n");

    return 0;
}
