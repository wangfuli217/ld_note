#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    STAILQ_ENTRY (animal_) link;
    char name[32];
} animal;

STAILQ_HEAD (animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main (void) {
    /* Create empty single tail queue */
    animal_head bird_stailq;
    STAILQ_INIT (&bird_stailq);

    if (STAILQ_EMPTY (&bird_stailq)) {
        printf ("There is not any bird in the single tail queue\n");
        printf ("\n");
    }

    /* 1. Insert an item at single tail queue's head */
    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    STAILQ_INSERT_HEAD (&bird_stailq, &duck, link);

    /* Show every item in single tail queue */
    animal *bird = NULL;
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 2. Insert an item at single tail queue'tail */
    animal sparrow;
    strcpy (sparrow.name, "sparrow");
    printf ("Insert tail %s\n", sparrow.name);
    STAILQ_INSERT_TAIL (&bird_stailq, &sparrow, link);

    /* Show every item in single tail queue */
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 3. Insert an item after another item in the single tail queue */
    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s\n", chicken.name, duck.name);
    STAILQ_INSERT_AFTER (&bird_stailq, &duck, &chicken, link);

    /* Show every item in single tail queue */
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 4. The first item in the single tail queue */
    bird = STAILQ_FIRST (&bird_stailq);
    if (bird != NULL) {
        printf ("The first bird in the single tail queue is %s\n", bird->name);
    } else {
        printf ("The single tail queue is empty, no first bird found");
        printf ("\n");
    }

    /* 5. The next item of the specified item in the single tail queue */
    bird = STAILQ_NEXT (&chicken, link);
    if (bird != NULL) {
        printf ("The next bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf ("The next bird of %s, is NULL\n", chicken.name);
    }

    bird = STAILQ_LAST (&bird_stailq, animal_, link);
    if (bird != NULL) {
        printf ("The last bird of %s\n", bird->name);
    } else {
        printf ("The last bird of is NULL\n");
    }
    printf ("\n");

    /* 6. Remove the head item in the single tail queue */
    STAILQ_REMOVE_HEAD (&bird_stailq, link);
    printf ("Remove the head item in the single tail queue");

    /* Show every item in single tail queue */
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* Iterate by hand */
    bird = STAILQ_FIRST (&bird_stailq);
    while (bird != NULL) {
        printf ("bird name is %s\n", bird->name);
        bird = STAILQ_NEXT (bird, link);
    }

    animal *tval;
    STAILQ_FOREACH_SAFE (bird, &bird_stailq, link, tval) {
        STAILQ_REMOVE (&bird_stailq, bird, animal_, link);
    }
    STAILQ_INSERT_HEAD (&bird_stailq, &duck, link);
    STAILQ_INSERT_HEAD (&bird_stailq, &chicken, link);
    STAILQ_INSERT_HEAD (&bird_stailq, &sparrow, link);

    /*7. Remove an item in the single tail queue */
    STAILQ_REMOVE (&bird_stailq, &sparrow, animal_, link);
    printf ("Remove %s from single tail queue \n", sparrow.name);

    /* Show every item in single tail queue */
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 8. If single tail queue is empty */
    if (STAILQ_EMPTY (&bird_stailq)) {
        printf ("The bird single tail queue is empty\n");
    } else {
        printf ("The bird single tail queue is not empty\n");
    }
    printf ("\n");

    /* 9 Concat two single tail queue */
    printf ("Create insect single tail queue. \n");

    /* Create empty single tail queue */
    animal_head insect_stailq;
    STAILQ_INIT (&insect_stailq);

    /* 9.1 Insert an item at single tail queue's head */
    animal bee;
    strcpy (bee.name, "bee");
    printf ("Insert head %s\n", bee.name);
    STAILQ_INSERT_HEAD (&insect_stailq, &bee, link);

    animal cricket;
    strcpy (cricket.name, "cricket");
    printf ("Insert head %s\n", cricket.name);
    STAILQ_INSERT_HEAD (&insect_stailq, &cricket, link);

    animal wasp;
    strcpy (wasp.name, "wasp");
    printf ("Insert head %s\n", wasp.name);
    STAILQ_INSERT_HEAD (&insect_stailq, &wasp, link);

    /* Show every item in single tail queue */
    printf ("\n");
    printf ("Insect single tail queue has:\n");
    animal *insect = NULL;
    STAILQ_FOREACH (insect, &insect_stailq, link)
        printf ("\tinset name is %s\n", insect->name);
    printf ("\n");

    printf ("bird single tail queue has:\n");
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tinset name is %s\n", bird->name);
    printf ("\n");

    /* 9.2 concat two single tail queue */
    printf ("Concat insect single tail queue into bird single tail queue!\n\n");
    STAILQ_CONCAT (&bird_stailq, &insect_stailq);

    printf ("bird single tail queue has:\n");
    STAILQ_FOREACH (bird, &bird_stailq, link)
        printf ("\tinsect name is %s\n", bird->name);
    printf ("\n");

    return 0;
}
