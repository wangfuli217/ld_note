#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/queue.h>

typedef struct animal_ {
    TAILQ_ENTRY (animal_) link;
    char name[32];
} animal;

TAILQ_HEAD (animal_head_, animal_);
typedef struct animal_head_ animal_head;

int main (void) {
    /* Create empty tail queue */
    animal_head bird_tailq;
    TAILQ_INIT (&bird_tailq);

    if (TAILQ_EMPTY (&bird_tailq)) {
        printf ("There is not any bird in the tail queue\n");
        printf ("\n");
    }

    /* 1. Insert an item at tail queue's head */
    animal duck;
    strcpy (duck.name, "duck");
    printf ("Insert head %s\n", duck.name);
    TAILQ_INSERT_HEAD (&bird_tailq, &duck, link);

    /* Show every item in tail queue */
    animal *bird = NULL;
    TAILQ_FOREACH (bird, &bird_tailq, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 2. Insert an item at tail queue's tail */
    animal sparrow;
    strcpy (sparrow.name, "sparrow");
    printf ("Insert tail %s\n", sparrow.name);
    TAILQ_INSERT_TAIL (&bird_tailq, &sparrow, link);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH (bird, &bird_tailq, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 3. Insert an item after another item in the tail queue */
    animal chicken;
    strcpy (chicken.name, "chicken");
    printf ("Insert %s after %s \n", chicken.name, duck.name);
    TAILQ_INSERT_AFTER (&bird_tailq, &duck, &chicken, link);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH (bird, &bird_tailq, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 4.Insert an item before another item in the tail queue */
    animal goose;
    strcpy (goose.name, "goose");
    printf ("Insert %s before %s\n", goose.name, duck.name);
    TAILQ_INSERT_BEFORE (&duck, &goose, link);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH (bird, &bird_tailq, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    /* 5. The first item in the tail queue */
    bird = TAILQ_FIRST (&bird_tailq);
    if (bird == NULL) {
        printf ("The first bird in the tail queue is %s", bird->name);
    } else {
        printf ("The tail queue is empty, no first bird found\n");
    }
    printf ("\n");

    /* 6. The last item in tail queue */
    bird = TAILQ_LAST (&bird_tailq, animal_head_);
    if (bird == NULL) {
        printf ("The last bird in the tail queue is %s\n", bird->name);
    } else {
        printf ("The tail queue is empty, no last bird found\n");
    }
    printf ("\n");

    /* 7. The next item of the specified item in the tail queue */
    bird = TAILQ_NEXT (&chicken, link);
    if (bird == NULL) {
        printf ("The next bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf ("The next bird of %s is NULL\n", chicken.name);
    }
    printf ("\n");

    /* 8. The pre item of the specified item in the tail queue */
    bird = TAILQ_PREV (&chicken, animal_head_, link);
    if (bird == NULL) {
        printf ("The pre bird of %s, is %s\n", chicken.name, bird->name);
    } else {
        printf ("The pre bird of %s is NULL\n", chicken.name);
    }
    printf ("\n");

    /* 9. Remove an item in the tail queue */
    TAILQ_REMOVE (&bird_tailq, &sparrow, link);
    printf ("Remove %s from tail queue\n", sparrow.name);

    /* Show every item in tail queue */
    bird = NULL;
    TAILQ_FOREACH (bird, &bird_tailq, link)
        printf ("bird name is %s\n", bird->name);
    printf ("\n");

    return 0;
}
