#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "queue.h"

typedef struct animal_ {
    TAILQ_ENTRY(animal_) link;
    char name[32];
} animal;


TAILQ_HEAD(animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main(void) {
    /* Create empty tail queue */
    animal_head bird_tailq;
    TAILQ_INIT(&bird_tailq);

    if (TAILQ_EMPTY(&bird_tailq)) {
        printf("There is not any bird in the tail queue\n");
        printf("\n");
    }

    /* 1. Insert an item at tail queue's head*/
    char *duck_name = "duck";
    animal duck;
    memcpy(&duck.name, duck_name, strlen(duck_name) + 1);
    printf("Insert head %s\n", duck.name);
    TAILQ_INSERT_HEAD(&bird_tailq, &duck, link);

    /* Show every item in tail queue */
    animal *bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 2. Insert an item at tail queue's tail*/
    char *sparrow_name = "sparrow";
    animal sparrow;
    memcpy(&sparrow.name, sparrow_name, strlen(sparrow_name) + 1);
    printf("Insert tail %s\n", sparrow.name);
    TAILQ_INSERT_TAIL(&bird_tailq, &sparrow, link);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 3. Insert an item after another item in the tail queue */
    char *chicken_name = "chicken";
    animal chicken;
    memcpy(&chicken.name, chicken_name, strlen(chicken_name) + 1);
    printf("Insert %s after %s\n", chicken.name, duck.name);
    TAILQ_INSERT_AFTER(&bird_tailq, &duck, &chicken, link);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 4. Insert an item before another item in the tail queue */
    char *goose_name = "goose";
    animal goose;
    memcpy(&goose.name, goose_name, strlen(goose_name) + 1);
    printf("Insert %s before %s\n", goose.name, duck.name);
    TAILQ_INSERT_BEFORE(&duck, &goose, link);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 5. The first item in the tail queue */
    bird = NULL;
    bird = TAILQ_FIRST(&bird_tailq);
    if (bird != NULL) {
        printf("The first bird in the tail queue is %s\n", bird->name);
    } else {
        printf("The tail queue is empty, no first bird found\n");
    }
    printf("\n");

    /* 6. The last item in the tail queue */
    bird = NULL;
    bird = TAILQ_LAST(&bird_tailq, animal_head_);
    if (bird != NULL) {
        printf("The last bird in the tail queue is %s\n", bird->name);
    } else {
        printf("The tail queue is empty, no last bird found\n");
    }
    printf("\n");

    /* 7. The next item of the specified item in the tail queue */
    bird = NULL;
    bird = TAILQ_NEXT(&chicken, link);
    if (bird != NULL) {
        printf("The next bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf("The next bird of %s is NULL\n", chicken.name);
    }
    printf("\n");

    /* 8. The pre item of the specified item in the tail queue */
    bird = NULL;
    bird = TAILQ_PREV(&chicken, animal_head_, link);
    if (bird != NULL) {
        printf("The pre bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf("The pre bird of %s is NULL\n", chicken.name);
    }
    printf("\n");

    /* 9. Remove an item in the tail queue */
    TAILQ_REMOVE(&bird_tailq, &sparrow, link);
    printf("Remove %s from tail queue\n", sparrow.name);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 10. Show every item in tail queue from tail to head */
    printf("The bird in bird tail queue from tail to head is:\n");
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 11. If tail queue is empty */
    if (TAILQ_EMPTY(&bird_tailq)) {
        printf("The bird tail queue is empty\n");
    } else {
        printf("The bird tail queue is not empty\n");
    }
    printf("\n");

    /* 12. Concat two tail queue */
    printf("Create insect tail queue.\n");
    printf("\n");

    /* Create empty tail queue */
    animal_head insect_stailq;
    TAILQ_INIT(&insect_stailq);

    /* 12.1 Insert an item at tail queue's head*/
    char *bee_name = "bee";
    animal bee;
    memcpy(&bee.name, bee_name, strlen(bee_name) + 1);
    printf("Insert head %s\n", bee.name);
    TAILQ_INSERT_HEAD(&insect_stailq, &bee, link);

    char *cricket_name = "cricket";
    animal cricket;
    memcpy(&cricket.name, cricket_name, strlen(cricket_name) + 1);
    printf("Insert head %s\n", cricket.name);
    TAILQ_INSERT_HEAD(&insect_stailq, &cricket, link);

    char *wasp_name = "wasp";
    animal wasp;
    memcpy(&wasp.name, wasp_name, strlen(wasp_name) + 1);
    printf("Insert head %s\n", wasp.name);
    TAILQ_INSERT_HEAD(&insect_stailq, &wasp, link);

    /* Show every item in tail queue */
    printf("\n");
    printf("Insect tail queue has:\n");
    animal *insect = NULL;
    TAILQ_FOREACH(insect, &insect_stailq, link)
        printf("insect name is %s\n", insect->name);
    printf("\n");

    printf("bird tail queue has:\n");
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("bird name is %s\n", bird->name);
    printf("\n");

    /* 12.2 Concat two tail queue */
    printf("Concat insect tail queue into bird tail queue!\n\n");
    TAILQ_CONCAT(&bird_tailq, &insect_stailq, link);

    /* Show every item in tail queue */
    printf("Bird tail queue has:\n");
    bird = NULL;
    TAILQ_FOREACH(bird, &bird_tailq, link)
        printf("Name is %s\n", bird->name);
    printf("\n");

    if (TAILQ_EMPTY(&insect_stailq)) {
        printf("The insect tail queue is empty\n");
        printf("\n");
    }

    return 0;
}
