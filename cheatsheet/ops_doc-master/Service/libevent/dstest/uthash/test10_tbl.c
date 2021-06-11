#include "uthash.h"
#include <stdlib.h>
#include <stdio.h>

typedef struct example_user_t {
    int id;
    int cookie;
    UT_hash_handle hh;
    UT_hash_handle alth;
} example_user_t;

int main (int argc, char *argv[]) {
    int i;
    example_user_t *user, *users = NULL, *altusers = NULL;

    /* create elements */
    puts ("example_user_t in several hash tables");
    for (i = 0; i < 1000; i++) {
        user = (example_user_t *) malloc (sizeof (example_user_t));
        if (user == NULL) {
            exit (-1);
        }
        user->id = i;
        user->cookie = i * i;
        if (i < 10) {
            HASH_ADD_INT (users, id, user);
        }
        HASH_ADD (alth, altusers, id, sizeof (int), user);
    }

    example_user_t *tmp;

    i = 9;
    HASH_FIND_INT (users, &i, tmp);
    printf ("%d %s in hh\n", i, (tmp != NULL) ? "found" : "not found");
    HASH_FIND (alth, altusers, &i, sizeof (int), tmp);
    printf ("%d %s in alth\n", i, (tmp != NULL) ? "found" : "not found");
    i = 10;
    HASH_FIND_INT (users, &i, tmp);
    printf ("%d %s in hh\n", i, (tmp != NULL) ? "found" : "not found");
    HASH_FIND (alth, altusers, &i, sizeof (int), tmp);
    printf ("%d %s in alth\n", i, (tmp != NULL) ? "found" : "not found");
    return 0;
}
