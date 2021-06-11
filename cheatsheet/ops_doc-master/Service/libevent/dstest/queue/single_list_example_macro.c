#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct animal_ {
    struct {
        struct animal_ *sle_next;
    } link;
    char name[32];
} animal;

struct animal_head_ {
    struct animal_ *slh_first;
};
typedef struct animal_head_ animal_head;

int main (void) {

    animal_head bird_slist;
    do {
        (&bird_slist)->slh_first = ((void *) 0);
    } while (0);

    if (((&bird_slist)->slh_first == ((void *) 0))) {
        printf ("There is not any bird in the single list\n");
        printf ("\n");
    }

    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    do {
        (&duck)->link.sle_next = (&bird_slist)->slh_first;
        (&bird_slist)->slh_first = (&duck);
    } while (0);

    animal *bird = ((void *) 0);
    for ((bird) = (&bird_slist)->slh_first; (bird); (bird) = (bird)->link.sle_next)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s \n", chicken.name, duck.name);
    do {
        (&chicken)->link.sle_next = (&duck)->link.sle_next;
        (&duck)->link.sle_next = (&chicken);
    } while (0);

    for ((bird) = (&bird_slist)->slh_first; (bird); (bird) = (bird)->link.sle_next)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    animal hen;
    strcpy (hen.name, "hen");
    printf ("Insert %s at the head of the single list\n", hen.name);
    do {
        (&hen)->link.sle_next = (&bird_slist)->slh_first;
        (&bird_slist)->slh_first = (&hen);
    } while (0);

    for ((bird) = (&bird_slist)->slh_first; (bird); (bird) = (bird)->link.sle_next)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    bird = ((&bird_slist)->slh_first);
    if (bird != ((void *) 0)) {
        printf ("The first bird in the single list is %s\n", bird->name);
    } else {
        printf ("The single list is empty, no first bird found\n");
    }

    bird = ((&hen)->link.sle_next);
    if (bird != ((void *) 0)) {
        printf ("The next bird of %s, is %s\n", hen.name, bird->name);
    } else {
        printf ("The next bird of %s is NULL\n", hen.name);
    }
    printf ("\n");

    printf ("Iterate one bye one\n");
    bird = ((&bird_slist)->slh_first);
    while (bird != ((void *) 0)) {
        printf ("\tbird name is %s\n", bird->name);
        bird = ((bird)->link.sle_next);
    }

    printf ("foreach_safe\n");
    animal *tval;
    for ((bird) = (((&bird_slist))->slh_first); (bird) && ((tval) = (((bird))->link.sle_next), 1); (bird) = (tval)) {
        printf ("\tbird name is %s\n", bird->name);
        do {
            if ((&bird_slist)->slh_first == (bird)) {
                do {
                    ((&bird_slist))->slh_first = ((&bird_slist))->slh_first->link.sle_next;
                } while (0);
            } else {
                struct animal_ *curelm = (&bird_slist)->slh_first;
                while (curelm->link.sle_next != (bird)) {
                    curelm = curelm->link.sle_next;
                }
                curelm->link.sle_next = curelm->link.sle_next->link.sle_next;
            }
        } while (0);
    }

    do {
        (&hen)->link.sle_next = (&bird_slist)->slh_first;
        (&bird_slist)->slh_first = (&hen);
    } while (0);
    do {
        (&chicken)->link.sle_next = (&bird_slist)->slh_first;
        (&bird_slist)->slh_first = (&chicken);
    } while (0);
    do {
        (&duck)->link.sle_next = (&bird_slist)->slh_first;
        (&bird_slist)->slh_first = (&duck);
    } while (0);

    do {
        if ((&bird_slist)->slh_first == (&hen)) {
            do {
                ((&bird_slist))->slh_first = ((&bird_slist))->slh_first->link.sle_next;
            } while (0);
        } else {
            struct animal_ *curelm = (&bird_slist)->slh_first;
            while (curelm->link.sle_next != (&hen)) {
                curelm = curelm->link.sle_next;
            }
            curelm->link.sle_next = curelm->link.sle_next->link.sle_next;
        }
    } while (0);
    printf ("Remove  %s from single list\n", hen.name);

    do {
        (&duck)->link.sle_next = (((((&duck))->link.sle_next))->link.sle_next);
    } while (0);
    printf ("Remove duck after bird from single list\n");

    do {
        (&bird_slist)->slh_first = (&bird_slist)->slh_first->link.sle_next;
    } while (0);
    printf ("Remove head %s from single list\n", duck.name);

    for ((bird) = (&bird_slist)->slh_first; (bird); (bird) = (bird)->link.sle_next)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    if (((&bird_slist)->slh_first == ((void *) 0))) {
        printf ("The bird single list is empty\n");
    } else {
        printf ("The bird single list is not empty\n");
    }

    printf ("\n");

    return 0;

}
