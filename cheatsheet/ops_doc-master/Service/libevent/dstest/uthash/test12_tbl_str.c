#include "uthash.h"
#include <stdio.h>
#include <stdlib.h>

/*
HASH_ADD_STR(head, keyfield_name, item_ptr)
# HASH_ADD (hh_name, head, keyfield_name, key_len, item_ptr)
HASH_REPLACE_STR(head,keyfield_name, item_ptr, replaced_item_ptr)
# HASH_REPLACE (hh_name, head, keyfield_name, key_len, item_ptr, replaced_item_ptr)
HASH_FIND_STR(head, key_ptr, item_ptr)
# HASH_FIND (hh_name, head, key_ptr, key_len, item_ptr)

HASH_DEL(head, item_ptr)
HASH_SORT(head, cmp)
HASH_COUNThead)
*/
typedef struct persion_t {
    char first_name[10];
    int id;
    UT_hash_handle hh;
} person_t;

int main (int argc, char *argv[]) {
    person_t *people = NULL, *person, *tmp;
    const char **name;
    const char *names[] = { "bob", "jack", "gary", "ty", "bo", "phil", "art",
        "gil", "buck", "ted", NULL
    };
    int id = 0;
    puts ("add persion using string array");
    for (name = names; *name != NULL; name++) {
        person = (person_t *) malloc (sizeof (person_t));
        if (person == NULL) {
            exit (-1);
        }
        strcpy (person->first_name, *name);
        person->id = id++;
        HASH_ADD_STR (people, first_name, person);
        printf ("\tadd %s (id %d)\n", person->first_name, person->id);
    }

    puts ("find persion using pointer");
    for (name = names; *name != NULL; name++) {
        HASH_FIND_STR (people, *name, person);
        if (person != NULL) {
            printf ("\tfound %s (id %d)\n", person->first_name, person->id);
            person_t *new_person = (person_t *) malloc (sizeof (person_t));
            if (new_person == NULL)
                exit (-1);
            memcpy (new_person, person, sizeof (person_t));
            new_person->id = person->id * 10;
            HASH_REPLACE_STR (people, first_name, new_person, tmp);
            printf ("\treplaced (%c) with %s (id %d)\n", (tmp != NULL) ? 'y' : 'n', new_person->first_name, new_person->id);
            if (tmp != NULL) {
                free (tmp);
            }
        } else {
            printf ("\tfailed to find %s\n", *name);
        }
    }

    puts ("find persion using 2 level pointer");
    person = NULL;
    person_t **p = &person;
    for (name = names; *name != NULL; name++) {
        HASH_FIND_STR (people, *name, *p);
        if (person != NULL) {
            printf ("\tfound %s (id %d)\n", person->first_name, person->id);
        } else {
            printf ("\tfailed to find %s\n", *name);
        }
    }

    /* free the hash table contents */
    HASH_ITER (hh, people, person, tmp) {
        HASH_DEL (people, person);
        free (person);
    }
    return 0;
}
