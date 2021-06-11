#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    STAILQ_ENTRY(animal_) link;
    char name[32];
} animal;


STAILQ_HEAD(animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main(void) {
    /* Create empty single tail queue */
    animal_head bird_stailq;
    STAILQ_INIT(&bird_stailq);

    if (STAILQ_EMPTY(&bird_stailq)) {
        printf("There is not any bird in the single tail queue\n");
        printf("\n");
    }

    /* 1. Insert an item at single tail queue's head*/
    char *duck_name = "duck";
    animal duck;
    memcpy(&duck.name, duck_name, strlen(duck_name) + 1);
    printf("Insert head %s\n", duck.name);
    STAILQ_INSERT_HEAD(&bird_stailq, &duck, link);

    /* Show every item in single tail queue */
    animal *bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 2. Insert an item at single tail queue's tail*/
    char *sparrow_name = "sparrow";
    animal sparrow;
    memcpy(&sparrow.name, sparrow_name, strlen(sparrow_name) + 1);
    printf("Insert tail %s\n", sparrow.name);
    STAILQ_INSERT_TAIL(&bird_stailq, &sparrow, link);

    /* Show every item in single tail queue */
    bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 3. Insert an item after another item in the single tail queue */
    char *chicken_name = "chicken";
    animal chicken;
    memcpy(&chicken.name, chicken_name, strlen(chicken_name) + 1);
    printf("Insert %s after %s\n", chicken.name, duck.name);
    STAILQ_INSERT_AFTER(&bird_stailq, &duck, &chicken, link);

    /* Show every item in single tail queue */
    bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 4. The first item in the single tail queue */
    bird = NULL;
    bird = STAILQ_FIRST(&bird_stailq);
    if (bird != NULL) {
        printf("The first bird in the single tail queue is %s\n", bird->name);
    } else {
        printf("The single tail queue is empty, no first bird found\n");
    }
    printf("\n");

    /* 5. The next item of the specified item in the single tail queue */
    bird = NULL;
    bird = STAILQ_NEXT(&chicken, link);
    if (bird != NULL) {
        printf("The next bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf("The next bird of %s is NULL\n", chicken.name);
    }
    printf("\n");

    /* 6. Remove the head item in the single tail queue */
    STAILQ_REMOVE_HEAD(&bird_stailq, link);
    printf("Remve the head item in the single tail queue\n");

    /* Show every item in single tail queue */
    bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 7. Remove an item in the single tail queue */
    STAILQ_REMOVE(&bird_stailq, &sparrow, animal_, link);
    printf("Remve %s from single tail queue\n", sparrow.name);

    /* Show every item in single tail queue */
    bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 8. If single tail queue is empty */
    if (STAILQ_EMPTY(&bird_stailq)) {
        printf("The bird single tail queue is empty\n");
    } else {
        printf("The bird single tail queue is not empty\n");
    }
    printf("\n");

    /* 9. Concat two single tail queue */
    printf("Create insect single tail queue.\n");
    printf("\n");

    /* Create empty single tail queue */
    animal_head insect_stailq;
    STAILQ_INIT(&insect_stailq);

    /* 9.1 Insert an item at single tail queue's head*/
    char *bee_name = "bee";
    animal bee;
    memcpy(&bee.name, bee_name, strlen(bee_name) + 1);
    printf("Insert head %s\n", bee.name);
    STAILQ_INSERT_HEAD(&insect_stailq, &bee, link);

    char *cricket_name = "cricket";
    animal cricket;
    memcpy(&cricket.name, cricket_name, strlen(cricket_name) + 1);
    printf("Insert head %s\n", cricket.name);
    STAILQ_INSERT_HEAD(&insect_stailq, &cricket, link);

    char *wasp_name = "wasp";
    animal wasp;
    memcpy(&wasp.name, wasp_name, strlen(wasp_name) + 1);
    printf("Insert head %s\n", wasp.name);
    STAILQ_INSERT_HEAD(&insect_stailq, &wasp, link);

    /* Show every item in single tail queue */
    printf("\n");
    printf("Insect single tail queue has:\n");
    animal *insect = NULL;
    STAILQ_FOREACH(insect, &insect_stailq, link)
        printf("insect name is %s\n", insect->name);
    printf("\n");

    printf("bird single tail queue has:\n");
    bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 9.2 Concat two single tail queue */
    printf("Concat insect single tail queue into bird single tail queue!\n\n");
    STAILQ_CONCAT(&bird_stailq, &insect_stailq);

    /* Show every item in single tail queue */
    printf("Bird single tail queue has:\n");
    bird = NULL;
    STAILQ_FOREACH(bird, &bird_stailq, link)
        printf("Name is %s\n", bird->name);
    printf("\n");

    if (STAILQ_EMPTY(&insect_stailq)) {
        printf("The insect single tail queue is empty\n");
        printf("\n");
    }

    return 0;
}
