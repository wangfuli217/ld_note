#include "uthash.h"
#include <stdlib.h>
#include <stdio.h>

/*
...key and handle
HASH_ADD_INT(head, keyfield_name, item_ptr)
# HASH_ADD (hh_name, head, keyfield_name, key_len, item_ptr)
HASH_FIND_INT (head, key_ptr, item_ptr)
# HASH_FIND (hh_name, head, key_ptr, key_len, item_ptr)
HASH_REPLACE_INT(head, keyfiled_name, item_ptr,replaced_item_ptr)
# HASH_REPLACE(hh_name, head, keyfield_name, key_len, item_ptr, replaced_item_ptr)

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
    UT_hash_handle alth;
} example_user_t;

static int ascending_sort (void *_a, void *_b) {
    example_user_t *a = (example_user_t *) _a;
    example_user_t *b = (example_user_t *) _b;
    if (a->id == b->id) {
        return 0;
    }
    return (a->id < b->id) ? -1 : 1;
}

static int descending_sort (void *_a, void *_b) {
    example_user_t *a = (example_user_t *) _a;
    example_user_t *b = (example_user_t *) _b;
    if (a->id == b->id) {
        return 0;
    }
    return (a->id < b->id) ? 1 : -1;
}

int main (int argc, char *argv[]) {
    int i;
    example_user_t *user, *users = NULL, *altusers = NULL;

    /* create elements */
    puts ("create example_user_t users and altusers");
    for (i = 0; i < 10; i++) {  // HASH_ADD_INT + HASH_ADD
        user = (example_user_t *) malloc (sizeof (example_user_t));
        if (user == NULL) {
            exit (-1);
        }
        user->id = i;
        user->cookie = i * i;
        // HASH_ADD_INT(head,intfield,add) 
        // HASH_ADD(hh,head,intfield,sizeof(int),add)
        HASH_ADD_INT (users, id, user);
        HASH_ADD (alth, altusers, cookie, sizeof (int), user);
    }

    puts ("output example_user_t using cookie by next pointer");
    for (user = altusers; user != NULL; user = (example_user_t *) (user->alth.next)) {  // alth.next
        printf ("\tcookie %d, user %d\n", user->cookie, user->id);
    }

    // HASH_SORT(head,cmpfcn) HASH_SRT(hh,head,cmpfcn)
    printf ("sorting users by ascending\n");
    HASH_SRT (hh, users, ascending_sort);
    for (user = users; user != NULL; user = (example_user_t *) (user->alth.next)) { // alth.next
        printf ("\tcookie %d, user %d\n", user->cookie, user->id);
    }
    printf ("sorting users by descending\n");
    HASH_SRT (alth, altusers, descending_sort);
    for (user = altusers; user != NULL; user = (example_user_t *) (user->alth.next)) {  // alth.next
        printf ("\tcookie %d, user %d\n", user->cookie, user->id);
    }

    int j;
    example_user_t *tmp = NULL;
    puts ("find example_user_t using cookie in even");
    for (i = 0; i < 10; i += 2) {   // HASH_FIND
        j = i * i;
        // HASH_FIND_INT(head,findint,out)
        // HASH_FIND(hh,head,findint,sizeof(int),out)
        HASH_FIND (alth, altusers, &j, sizeof (int), tmp);
        if (tmp != NULL) {
            printf ("\tcookie %d found, user id %d\n", tmp->cookie, tmp->id);
        } else {
            printf ("\tcookie %d not found\n", j);
        }
    }

    // HASH_COUNT(head) HASH_CNT(hh,head)
    printf ("example count in hash table %d/HASH_COUNT\n", HASH_COUNT (users));
    printf ("example count in alt hash table %d/HASH_COUNT\n", HASH_CNT (alth, altusers));

    HASH_ITER (alth, altusers, user, tmp) { // HASH_DELETE
        printf ("\tdeleting cookie %d found, user id %d\n", user->cookie, user->id);
        HASH_DELETE (hh, users, user);
        HASH_DELETE (alth, altusers, user);
        free (user);
    }

    printf ("example count in hash table %d/HASH_COUNT\n", HASH_COUNT (users));
    printf ("example count in alt hash table %d/HASH_COUNT\n", HASH_CNT (alth, altusers));
    return 0;
}
