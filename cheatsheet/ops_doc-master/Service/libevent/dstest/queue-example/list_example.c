#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    LIST_ENTRY(animal_) link;
    char name[32];
} animal;


LIST_HEAD(animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main(void) {
    /* Create empty list */
    animal_head bird_list;
    LIST_INIT(&bird_list);

    if (LIST_EMPTY(&bird_list)) {
        printf("There is not any bird in the list\n");
        printf("\n");
    }

    /* 1. Insert an item at list's head*/
    char *duck_name = "duck";
    animal duck;
    memcpy(&duck.name, duck_name, strlen(duck_name) + 1);
    printf("Insert head %s\n", duck.name);
    LIST_INSERT_HEAD(&bird_list, &duck, link);

    /* Show every item in list */
    animal *bird = NULL;
    LIST_FOREACH(bird, &bird_list, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 2. Insert an item after another item in the list */
    char *chicken_name = "chicken";
    animal chicken;
    memcpy(&chicken.name, chicken_name, strlen(chicken_name) + 1);
    printf("Insert %s after %s\n", chicken.name, duck.name);
    LIST_INSERT_AFTER(&duck, &chicken, link);

    /* Show every item in list */
    bird = NULL;
    LIST_FOREACH(bird, &bird_list, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 3. Insert an item before another item in the list */
    char *goose_name = "goose";
    animal goose;
    memcpy(&goose.name, goose_name, strlen(goose_name) + 1);
    printf("Insert %s before %s\n", goose.name, chicken.name);
    LIST_INSERT_BEFORE(&chicken, &goose, link);

    /* Show every item in list */
    bird = NULL;
    LIST_FOREACH(bird, &bird_list, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 4. Insert an item at the head of the list */
    char *hen_name = "hen";
    animal hen;
    memcpy(&hen.name, hen_name, strlen(hen_name) + 1);
    printf("Insert %s at the head of the list\n", hen.name);
    LIST_INSERT_HEAD(&bird_list, &hen, link);

    /* Show every item in list */
    bird = NULL;
    LIST_FOREACH(bird, &bird_list, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 5. The first item in the list */
    bird = NULL;
    bird = LIST_FIRST(&bird_list);
    if (bird != NULL) {
        printf("The first bird in the list is %s\n", bird->name);
    } else {
        printf("The list is empty, no first bird found\n");
    }
    printf("\n");

    /* 6. The next item of the specified item in the list */
    bird = NULL;
    bird = LIST_NEXT(&goose, link);
    if (bird != NULL) {
        printf("The next bird of %s, is %s\n", goose.name, bird->name);
    } else {
        printf("The next bird of %s is NULL\n", goose.name);
    }
    printf("\n");

    /* 7. Remove an item in the list */
    LIST_REMOVE(&goose, link);
    printf("Remve %s from list\n", goose.name);

    /* Show every item in list */
    bird = NULL;
    LIST_FOREACH(bird, &bird_list, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 8. If list is empty */
    if (LIST_EMPTY(&bird_list)) {
        printf("The bird list is empty\n");
    } else {
        printf("The bird list is not empty\n");
    }
    printf("\n");

    return 0;
}
