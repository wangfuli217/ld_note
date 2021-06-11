#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    LIST_ENTRY (animal_) link;
    char name[32];
} animal;

LIST_HEAD (animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main (void) {
    /* Create empty list */
    animal_head bird_list;
    LIST_INIT (&bird_list);

    if (LIST_EMPTY (&bird_list)) {
        printf ("There is not any bird in the list\n");
        printf ("\n");
    }

    /* 1. Insert an item at list's head */
    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    LIST_INSERT_HEAD (&bird_list, &duck, link);

    /* Show every item in list */
    animal *bird = NULL;
    LIST_FOREACH (bird, &bird_list, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 2.Insert an item after another item in the list */
    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s\n", chicken.name, duck.name);
    LIST_INSERT_AFTER (&duck, &chicken, link);

    /* Show every item in list */
    LIST_FOREACH (bird, &bird_list, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 3.Insert an item before another item in the list */
    animal goose;
    strcpy (goose.name, "goose");
    printf ("Insert %s before %s\n", goose.name, chicken.name);
    LIST_INSERT_BEFORE (&chicken, &goose, link);

    /* Show every item in list */
    LIST_FOREACH (bird, &bird_list, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 5. Insert an item at list's head */
    animal hen;
    strcpy (hen.name, "hen");
    printf ("Insert head %s\n", hen.name);
    LIST_INSERT_HEAD (&bird_list, &hen, link);

    /* Show every item in list */
    LIST_FOREACH (bird, &bird_list, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 5. The first item in the list */
    bird = LIST_FIRST (&bird_list);
    if (bird != NULL) {
        printf ("The first bird in the list is %s\n", bird->name);
    } else {
        printf ("The list is emtpy, no first bird found\n");
    }

    bird = LIST_NEXT (&goose, link);
    if (bird != NULL) {
        printf ("The next bird of %s, is %s\n", goose.name, bird->name);
    } else {
        printf ("The next bird of %s is NULL\n", goose.name);
    }

    /* Iterate by hand */
    printf ("Iterate by hand\n");
    bird = LIST_FIRST (&bird_list);
    while (bird != NULL) {
        printf ("\tbird name is %s\n", bird->name);
        bird = LIST_NEXT (bird, link);
    }

    /* foreach_safe and remove */
    printf ("list foreach safe in remove\n");
    animal *tval;
    LIST_FOREACH_SAFE (bird, &bird_list, link, tval) {
        LIST_REMOVE (bird, link);
    }
    if (LIST_EMPTY (&bird_list)) {
        printf ("The bird list is empty\n");
    } else {
        printf ("The bird list is not empty\n");
    }

    LIST_INSERT_HEAD (&bird_list, &chicken, link);
    LIST_INSERT_HEAD (&bird_list, &goose, link);
    LIST_INSERT_HEAD (&bird_list, &duck, link);
    LIST_INSERT_HEAD (&bird_list, &hen, link);

    /* 7. Remove an item in the list */
    LIST_REMOVE (&goose, link);
    printf ("Remove %s from list\n", goose.name);

    /* Show every item in list */
    bird = NULL;
    LIST_FOREACH (bird, &bird_list, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 8. If list is empty */
    if (LIST_EMPTY (&bird_list)) {
        printf ("The bird list is empty\n");
    } else {
        printf ("The bird list is not empty\n");
    }
    printf ("\n");

    return 0;
}
