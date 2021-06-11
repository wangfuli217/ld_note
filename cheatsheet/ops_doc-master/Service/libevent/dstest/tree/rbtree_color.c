#include "tree.h"
#include <err.h>                /* err() */
#include <stdio.h>              /* printf(), puts() */
#include <stdlib.h>             /* calloc(), free() */
#include <string.h>             /* strcmp() */

/*
 * color_example:
 *   Maps color strings to integer values, like "red" => 0xff0000.
 *
 * I will use a red-black tree of type 'struct ctree', which contains
 * nodes of type 'struct cnode'.
 */
struct cnode {
    RB_ENTRY (cnode) entry;
    char *key;
    int value;
};

static int cnodecmp (struct cnode *a, struct cnode *b) {
    return strcmp (a->key, b->key);
}

RB_HEAD (ctree, cnode);
RB_PROTOTYPE (ctree, cnode, entry, cnodecmp);
RB_GENERATE (ctree, cnode, entry, cnodecmp);

static void color_example (void) {
    struct ctree head = RB_INITIALIZER (&head); /* an empty tree */
    struct cnode n, *np, *op;
    int i;

    puts ("color_example:");

    /* Add keys => values to tree. */
    {
        char *keys[] = { "red", "green", "blue" };
        int values[] = { 0xff0000, 0x00ff00, 0x0000ff };

        for (i = 0; i < 3; i++) {
            if ((np = calloc (1, sizeof np[0])) == NULL)
                err (1, "calloc");
            np->key = keys[i];
            np->value = values[i];
            RB_INSERT (ctree, &head, np);
        }
    }

    /* Check if keys exist. */
    {
        char *keys[] = { "blue", "green", "orange", "red" };

        for (i = 0; i < 4; i++) {
            n.key = keys[i];
            np = RB_FIND (ctree, &head, &n);

            if (np) {
                printf ("\t'%s' has value %06x\n", np->key, np->value);
            } else {
                printf ("\t'%s' is not in tree\n", n.key);
            }
        }
    }

    /* Free tree. */
    for (np = RB_MIN (ctree, &head); np != NULL; np = op) {
        op = RB_NEXT (ctree, &head, np);
        RB_REMOVE (ctree, &head, np);
        free (np);
    }
}

/*
 * number_example:
 *   Maps numbers to strings or numbers, like 2 => 2.71828 or 4 => "four".
 *
 * This node has a value that can either be a string or a number.
 */
struct dnode {
    RB_ENTRY (dnode) entry;
    double key;
    int v_type;
#define T_NUM	0x1             /* use v_num */
#define T_STR	0x2             /* use v_str */

    union {
        double u_num;
        char *u_str;
    } v_union;
#define v_num v_union.u_num
#define v_str v_union.u_str
};

static int dnodecmp (struct dnode *a, struct dnode *b) {
    double aa = a->key;
    double bb = b->key;
    return (aa < bb) ? -1 : (aa > bb);
}

RB_HEAD (dtree, dnode);
RB_PROTOTYPE (dtree, dnode, entry, dnodecmp)
    RB_GENERATE (dtree, dnode, entry, dnodecmp)

static void number_example (void) {
    struct dtree head = RB_INITIALIZER (&head);
    struct dnode n, *np, *op;
    int i;

    puts ("number_example:");

    /* Add numeric values. */
    {
        double keys[] = { 2, 3, 4, 5.6 };
        double values[] = { 2.71828, 3.14159, 4.47214, 7.8 };

        for (i = 0; i < 4; i++) {
            if ((np = calloc (1, sizeof np[0])) == NULL)
                err (1, "calloc");
            np->key = keys[i];
            np->v_type = T_NUM;
            np->v_num = values[i];
            RB_INSERT (dtree, &head, np);
        }
    }

    /*
     * Add string values.
     *
     * For this example, all of my values will be static string
     * constants. This removes the need to free(np->v_str)
     * when I replace or delete a value.
     */
    {
        double keys[] = { 4, 8, 10 };
        char *values[] = { "four", "eight", "ten" };

        for (i = 0; i < 3; i++) {
            /*
             * This shows how to add or replace a value
             * in the tree (so I can change an entry
             * from 4 => 4.47214 to 4 => "four").
             */
            n.key = keys[i];
            if ((np = RB_FIND (dtree, &head, &n)) != NULL) {
                np->v_type = T_STR;
                np->v_str = values[i];
            } else if ((np = calloc (1, sizeof np[0])) != NULL) {
                np->key = keys[i];
                np->v_type = T_STR;
                np->v_str = values[i];
                RB_INSERT (dtree, &head, np);
            } else
                err (1, "calloc");
        }
    }

    /* Delete key 8. */
    n.key = 8;
    if ((np = RB_FIND (dtree, &head, &n)) != NULL)
        RB_REMOVE (dtree, &head, np);

    /* Iterate all keys. */
    i = 1;
    RB_FOREACH (np, dtree, &head) {
        if (i) {
            printf ("\tall keys: %g", np->key);
            i = 0;
        } else
            printf (", %g", np->key);
    }
    if (i)
        puts ("\tno keys!");
    else
        puts ("");

    /* Check if keys exist. */
    {
        double keys[] = { 2, 3, 4, 5.6, 7, 8, 10 };

        for (i = 0; i < 7; i++) {
            n.key = keys[i];
            np = RB_FIND (dtree, &head, &n);

            if (np == NULL) {
                printf ("\t%g is not in the tree\n", keys[i]);
            } else if (np->v_type & T_NUM) {
                printf ("\t%g has value %g\n", keys[i], np->v_num);
            } else if (np->v_type & T_STR) {
                printf ("\t%g has value '%s'\n", keys[i], np->v_str);
            } else {
                printf ("\t%g has invalid value\n", keys[i]);
            }
        }
    }

    /* Free tree. */
    for (np = RB_MIN (dtree, &head); np != NULL; np = op) {
        op = RB_NEXT (dtree, &head, np);
        RB_REMOVE (dtree, &head, np);
        free (np);
    }
}

int main (void) {
    color_example ();
    number_example ();
    return 0;
}
