#include "uthash.h"
#include <stdlib.h>             /* malloc */
#include <errno.h>              /* perror */
#include <stdio.h>              /* printf */

#define BUFLEN 20

typedef struct name_rec {
    char boy_name[BUFLEN];
    UT_hash_handle hh;
} name_rec;

static int namecmp (void *_a, void *_b) {
    name_rec *a = (name_rec *) _a;
    name_rec *b = (name_rec *) _b;
    return strcmp (a->boy_name, b->boy_name);
}
int main (int argc, char *argv[]) {
    name_rec *name, *names = NULL;
    char linebuf[BUFLEN];
    FILE *file;

    file = fopen ("test11.dat", "r");
    if (file == NULL) {
        perror ("can't open");
        exit (-1);
    }

    int i = 0;
    while (fgets (linebuf, BUFLEN, file) != NULL) {
        name = (name_rec *) malloc (sizeof (name_rec));
        strcpy (name->boy_name, linebuf);
        HASH_ADD_STR (names, boy_name, name);
        i++;
    }

    fseek (file, 0L, SEEK_SET);

    int j = 0;
    while (fgets (linebuf, BUFLEN, file) != NULL) {
        HASH_FIND_STR (names, linebuf, name);
        if (!name) {
            printf ("failed to find:%s\n", linebuf);
        } else {
            j++;
        }
    }

    fclose (file);

    printf ("lookup on %d of %d names\n", j, i);
    HASH_SORT (names, namecmp);
    for (name = names; name != NULL; name = (name_rec *) (name->hh.next)) {
        printf ("%s", name->boy_name);
    }

    return 0;
}
