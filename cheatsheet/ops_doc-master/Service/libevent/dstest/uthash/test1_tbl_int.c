#include "uthash.h"
#include <stdlib.h>
#include <stdio.h>

/*
...key and handle
HASH_ADD_INT(head, keyfield_name, item_ptr)
# HASH_ADD (hh_name, head, keyfield_name, key_len, item_ptr)
HASH_FIND_INT (head, key_ptr, item_ptr)
# HASH_FIND (hh_name, head, key_ptr, key_len, item_ptr)

...handle
HASH_DEL (head, item_ptr)
# HASH_DELETE (hh_name, head, item_ptr)
HASH_SORT (head, cmp)
# HASH_SRT (hh_name, head, cmp)

...common
HASH_COUNT (head)
HASH_CLEAR (hh_name, head)
HASH_ITER (hh_name, head, item_ptr, tmp_item_ptr)
*/

typedef struct example_user_t {
    int id;
    int cookie;
    UT_hash_handle hh;
} example_user_t;

int main (int argc, char *argv[]) {
    example_user_t *user, *users = NULL;

    /* create elements */
    puts ("create example_user_t hash table, id from 0 to 10");
    int i;
    for (i = 0; i < 10; i++) {  // HASH_ADD_INT
        user = (example_user_t *) malloc (sizeof (example_user_t));
        if (user == NULL) {
            exit (-1);
        }
        user->id = i;
        user->cookie = i * i;
        HASH_ADD_INT (users, id, user);
        printf ("\tnum_items in hash:%u\n", user->hh.tbl->num_items);
    }

    puts ("output example_user_t hash table by next pointer");
    for (user = users; user != NULL; user = (example_user_t *) (user->hh.next)) {   // hh.next
        printf ("\tuser %d, cookie %d\n", user->id, user->cookie);
    }

    /* find each even ID */
    puts ("find example_user_t hash table by even order");
    example_user_t *tmp = NULL;
    for (i = 0; i < 10; i += 2) {   // HASH_FIND_INT
        HASH_FIND_INT (users, &i, tmp);
        if (tmp != NULL) {
            printf ("\tuser id %d found, cookie %d\n", tmp->id, tmp->cookie);
        } else {
            printf ("\tuser id %d not found\n", i);
        }
    }

    /* delete each even ID */
    puts ("delete example_user_t hash table by even order");
    for (i = 0; i < 10; i += 2) {   // HASH_DEL
        HASH_FIND_INT (users, &i, tmp);
        if (tmp != NULL) {
            HASH_DEL (users, tmp);
            free (tmp);
            printf ("\tdeleted; num_items in hash:%u\n", users->hh.tbl->num_items);
        } else {
            printf ("\tuser id %d not found\n", i);
        }
    }

    puts ("after delete, output example hash table by HASH_ITER");
    HASH_ITER (hh, users, user, tmp) {  //HASH_ITER
        printf ("\tuser %d, cookie %d\n", user->id, user->cookie);
    }

    i = 9;
    puts ("output example_user_t hash table by prev pointer");
    HASH_FIND_INT (users, &i, tmp); // HASH_FIND_INT
    if (tmp != NULL) {
        while (tmp != NULL) {
            printf ("\tid: %d, following prev..\n", tmp->id);
            tmp = (example_user_t *) tmp->hh.prev;
        }
    }
    // HASH_COUNT(head) HASH_CNT(hh,head)
    printf ("example_user_t count in hash table %d/HASH_COUNT\n", HASH_COUNT (users));
    printf ("example_user_t count in hash table %d/hh.tbl->num_items\n", users->hh.tbl->num_items);

    puts ("continue delete in HASH_ITER");
    HASH_ITER (hh, users, user, tmp) {  // HASH_ITER + HASH_DEL
        printf ("\tuser %d, cookie %d\n", user->id, user->cookie);
        HASH_DEL (users, user);
        free (user);
    }
    printf ("example count in hash table %d/HASH_COUNT\n", HASH_COUNT (users));
    // printf("example count in hash table %d/hh.tbl->num_items\n", users->hh.tbl->num_items); /* core dumpd */
    printf ("call HASH_CLEAR\n");
    HASH_CLEAR (hh, users);     // HASH_CLEAR

    return 0;
}
