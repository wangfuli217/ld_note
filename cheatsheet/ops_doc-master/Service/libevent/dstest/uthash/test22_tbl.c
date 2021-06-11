#include <stdlib.h>             /* malloc       */
#include <stddef.h>             /* offsetof     */
#include <stdio.h>              /* printf       */
#include <string.h>             /* memset       */
#include "uthash.h"

#define UTF32 '\x1'

typedef struct {
    UT_hash_handle hh;
    size_t len;
    char encoding;
    int text[];
} msg_t;

typedef struct {
    char encoding;
    int text[];
} lookup_key_t;

int main (int argc, char *argv[]) {
    unsigned keylen;
    msg_t *msg, *tmp, *msgs = NULL;
    lookup_key_t *lookup_key;

    int beijing[] = { 0x5317, 0x4eac };

    msg = (msg_t *) malloc (sizeof (msg_t) + sizeof (beijing));
    if (msg == NULL)
        exit (-1);

    memset (msg, 0, sizeof (msg_t) + sizeof (beijing));
    msg->len = sizeof (beijing);
    msg->encoding = UTF32;
    memcpy (msg->text, beijing, sizeof (beijing));

    keylen = offsetof (msg_t, text)
        + sizeof (beijing)
        - offsetof (msg_t, encoding);

    printf ("keylen:%d offsetof(msg_t, text):%lu sizeof(beijing):%lu offsetof(msg_t, encoding):%lu\n", keylen, offsetof (msg_t, text), sizeof (beijing), offsetof (msg_t, encoding));
    HASH_ADD (hh, msgs, encoding, keylen, msg);
    msg = NULL;

    lookup_key = (lookup_key_t *) malloc (sizeof (lookup_key_t) + sizeof (beijing));
    if (lookup_key == NULL) {
        exit (-1);
    }

    memset (lookup_key, 0, sizeof (lookup_key_t) + sizeof (beijing));
    lookup_key->encoding = UTF32;
    memcpy (lookup_key->text, beijing, sizeof (beijing));
    HASH_FIND (hh, msgs, &lookup_key->encoding, keylen, msg);
    if (msg != NULL) {
        printf ("found\n");
    }
    free (lookup_key);

    HASH_ITER (hh, msgs, msg, tmp) {
        HASH_DEL (msgs, msg);
        free (msg);
    }
    return 0;

}
