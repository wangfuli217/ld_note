#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    SLIST_ENTRY (animal_) link;
    char name[32];
} animal;

SLIST_HEAD (animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main (void) {

    /* Create empty single list */
    animal_head bird_slist;
    SLIST_INIT (&bird_slist);

    if (SLIST_EMPTY (&bird_slist)) {
        printf ("There is not any bird in the single list\n");
        printf ("\n");
    }

    /* 1. Insert an item at single list's head */
    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    SLIST_INSERT_HEAD (&bird_slist, &duck, link);

    /* Show every item in single list */
    animal *bird = NULL;
    SLIST_FOREACH (bird, &bird_slist, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 2. Insert an item after another item in the single list */
    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s \n", chicken.name, duck.name);
    SLIST_INSERT_AFTER (&duck, &chicken, link);

    /* Show every item in single list */
    SLIST_FOREACH (bird, &bird_slist, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 4. Insert an item at the head of the single list */
    animal hen;
    strcpy (hen.name, "hen");
    printf ("Insert %s at the head of the single list\n", hen.name);
    SLIST_INSERT_HEAD (&bird_slist, &hen, link);

    /* Show every item in single list */
    SLIST_FOREACH (bird, &bird_slist, link)
        printf ("\tbird name is %s\n", bird->name);
    printf ("\n");

    /* 5. The first item in the single list */
    bird = SLIST_FIRST (&bird_slist);
    if (bird != NULL) {
        printf ("The first bird in the single list is %s\n", bird->name);
    } else {
        printf ("The single list is empty, no first bird found\n");
    }

    /* 6.The next item of the specified item in the single list */
    bird = SLIST_NEXT (&hen, link);
    if (bird != NULL) {
        printf ("The next bird of %s, is %s\n", hen.name, bird->name);
    } else {
        printf ("The next bird of %s is NULL\n", hen.name);
    }
    printf ("\n");

    /* Iterate by hand */
    printf ("Iterate one bye one\n");
    bird = SLIST_FIRST (&bird_slist);
    while (bird != NULL) {
        printf ("\tbird name is %s\n", bird->name);
        bird = SLIST_NEXT (bird, link);
    }

    /* traverse and remove */
    printf ("foreach_safe\n");
    animal *tval;
    SLIST_FOREACH_SAFE (bird, &bird_slist, link, tval) {
        printf ("\tbird name is %s\n", bird->name);
        SLIST_REMOVE (&bird_slist, bird, animal_, link);
    }

    SLIST_INSERT_HEAD (&bird_slist, &hen, link);
    SLIST_INSERT_HEAD (&bird_slist, &chicken, link);
    SLIST_INSERT_HEAD (&bird_slist, &duck, link);

    /* 7. Remove an item in the single list */
    SLIST_REMOVE (&bird_slist, &hen, animal_, link);
    printf ("Remove  %s from single list\n", hen.name);

    SLIST_REMOVE_AFTER (&duck, link);
    printf ("Remove duck after bird from single list\n");

    SLIST_REMOVE_HEAD (&bird_slist, link);
    printf ("Remove head %s from single list\n", duck.name);

    /* Show every item in single list */
    SLIST_FOREACH (bird, &bird_slist, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 8. If single list is empty */
    if (SLIST_EMPTY (&bird_slist)) {
        printf ("The bird single list is empty\n");
    } else {
        printf ("The bird single list is not empty\n");
    }

    /* swap: ignore ( see in slist.c ) */
    printf ("\n");

    return 0;

}
