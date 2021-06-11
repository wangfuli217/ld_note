#include <stdio.h>
#include <stdlib.h>
#include <sys/queue.h>

struct event {
    int value;
     TAILQ_ENTRY (event) entries;
};

#if (0)
TAILQ_HEAD (event_list, event);
struct event_list eventqueue;
#else
TAILQ_HEAD (, event) eventqueue;
#endif

int main (void) {
    struct event *item = NULL;

    TAILQ_INIT (&eventqueue);

    // print
    TAILQ_FOREACH (item, &eventqueue, entries) {
        printf ("%d ->", item->value);
    }
    printf ("\n");

    int i;
    for (i = 0; i < 10; i++) {
        item = calloc (1, sizeof (struct event));
        if (item == NULL)
            break;

        item->value = i;
        TAILQ_INSERT_TAIL (&eventqueue, item, entries);
    }

    // recurser and print
    item = NULL;
    TAILQ_FOREACH (item, &eventqueue, entries) {
        printf ("%d->", item->value);
    }
    printf ("\n");

    //releas queue
    while (item = TAILQ_FIRST (&eventqueue)) {
        TAILQ_REMOVE (&eventqueue, item, entries);
        printf ("remove item:%d\n", item->value);

        if (item != NULL)
            free (item);
    }

    return 0;
}
