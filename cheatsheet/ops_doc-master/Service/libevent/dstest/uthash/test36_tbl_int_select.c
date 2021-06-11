#include "uthash.h"
#include <stdlib.h>             /* malloc */
#include <stdio.h>              /* printf */

typedef struct {
    int id;
    UT_hash_handle hh;
    UT_hash_handle ah;
} example_user_t;

#define EVENS(x) (((x)->id%2)== 0)
static int evens (void *userv) {
    example_user_t *user = (example_user_t *) userv;
    return ((user->id % 2) ? 0 : 1);
}

static int idcmp (void *_a, void *_b) {
    example_user_t *a = (example_user_t *) _a;
    example_user_t *b = (example_user_t *) _b;
    return (a->id - b->id);
}

int main (int argc, char *argv[]) {
    int i;
    example_user_t *user, *users = NULL, *ausers = NULL;

    /*create elements */
    puts ("create users hash table, id from 0 to 10");
    for (i = 0; i < 10; i++) {
        user = (example_user_t *) malloc (sizeof (example_user_t));
        if (user == NULL)
            exit (-1);
        user->id = i;
        HASH_ADD_INT (users, id, user);
    }

    puts ("output users hash table by next pointer");
    for (user = users; user != NULL; user = (example_user_t *) user->hh.next) {
        printf ("\tuser %d\n", user->id);
    }

    /*now select some users into ausers */
    puts ("select users to ausers hash table by even order");
    HASH_SELECT (ah, ausers, hh, users, evens);
    HASH_SRT (ah, ausers, idcmp);

    puts ("output ausers in users found");
    for (user = users; user != NULL; user = (example_user_t *) user->hh.next) {
        example_user_t *found = NULL;
        int should_find = !!evens (user);
        HASH_FIND (ah, ausers, &user->id, sizeof (user->id), found);
        printf ("\tuser=%d should_find=%d found=%d\n", user->id, should_find, (int) (!!found));
    }

    puts ("output ausers hash table by next pointer");
    for (user = ausers; user != NULL; user = (example_user_t *) user->hh.next) {
        printf ("\tuser %d\n", user->id);
    }

    printf ("ausers count: %u\n", HASH_CNT (ah, ausers));
    HASH_CLEAR (ah, ausers);
    printf ("cleared ausers.\n");
    printf ("ausers count: %u\n", HASH_CNT (ah, ausers));
    for (user = ausers; user != NULL; user = (example_user_t *) (user->ah.next)) {
        printf ("\tauser %d\n", user->id);
    }
    printf ("users count: %u\n", HASH_CNT (hh, users));
    return 0;

}
