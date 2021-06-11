#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    SLIST_ENTRY(animal_) link;
    char name[32];
} animal;


SLIST_HEAD(animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main(void) {
    /* Create empty single list */
    animal_head bird_slist;
    SLIST_INIT(&bird_slist);

    if (SLIST_EMPTY(&bird_slist)) {
        printf("There is not any bird in the single list\n");
        printf("\n");
    }

    /* 1. Insert an item at single list's head*/
    char *duck_name = "duck";
    animal duck;
    memcpy(&duck.name, duck_name, strlen(duck_name) + 1);
    printf("Insert head %s\n", duck.name);
    SLIST_INSERT_HEAD(&bird_slist, &duck, link);

    /* Show every item in single list */
    animal *bird = NULL;
    SLIST_FOREACH(bird, &bird_slist, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 2. Insert an item after another item in the single list */
    char *chicken_name = "chicken";
    animal chicken;
    memcpy(&chicken.name, chicken_name, strlen(chicken_name) + 1);
    printf("Insert %s after %s\n", chicken.name, duck.name);
    SLIST_INSERT_AFTER(&duck, &chicken, link);

    /* Show every item in single list */
    bird = NULL;
    SLIST_FOREACH(bird, &bird_slist, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 4. Insert an item at the head of the single list */
    char *hen_name = "hen";
    animal hen;
    memcpy(&hen.name, hen_name, strlen(hen_name) + 1);
    printf("Insert %s at the head of the single list\n", hen.name);
    SLIST_INSERT_HEAD(&bird_slist, &hen, link);

    /* Show every item in single list */
    bird = NULL;
    SLIST_FOREACH(bird, &bird_slist, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 5. The first item in the single list */
    bird = NULL;
    bird = SLIST_FIRST(&bird_slist);
    if (bird != NULL) {
        printf("The first bird in the single list is %s\n", bird->name);
    } else {
        printf("The single list is empty, no first bird found\n");
    }
    printf("\n");

    /* 6. The next item of the specified item in the single list */
    bird = NULL;
    bird = SLIST_NEXT(&hen, link);
    if (bird != NULL) {
        printf("The next bird of %s, is %s\n", hen.name, bird->name);
    } else {
        printf("The next bird of %s is NULL\n", hen.name);
    }
    printf("\n");

    /* 7. Remove an item in the single list */
    SLIST_REMOVE(&bird_slist, &hen, animal_, link);
    printf("Remve %s from single list\n", hen.name);

    /* Show every item in single list */
    bird = NULL;
    SLIST_FOREACH(bird, &bird_slist, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 8. If  single list is empty */
    if (SLIST_EMPTY(&bird_slist)) {
        printf("The bird single list is empty\n");
    } else {
        printf("The bird single list is not empty\n");
    }
    printf("\n");

    return 0;
}
