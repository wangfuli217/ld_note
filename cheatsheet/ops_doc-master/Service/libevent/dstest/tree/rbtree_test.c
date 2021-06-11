#include "tree.h"
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

struct node {
    int index;
     RB_ENTRY (node) entry;
};

static int intcmp (struct node *e1, struct node *e2) {
    if (e1->index < e2->index) {
        return -1;
    } else {
        return (e1->index > e2->index);
    }
    //   return (e1->index < e2->index ? -1 : e1->index > e2->index);
}

RB_HEAD (inttree, node) head = RB_INITIALIZER (head);
RB_PROTOTYPE (inttree, node, entry, intcmp);
RB_GENERATE (inttree, node, entry, intcmp);

int testdata[] = {
    20, 16, 17, 13, 3, 6, 1, 8, 2, 4, 10, 19, 5, 9, 12, 15, 18,
    7, 11, 14
};

static void print_tree (struct node *n) {
    struct node *left, *right;

    if (n == NULL) {
        printf ("nil");
        return;
    }
    left = RB_LEFT (n, entry);
    right = RB_RIGHT (n, entry);
    if (left == NULL && right == NULL)
        printf ("%d", n->index);
    else {
        printf ("%d(", n->index);
        print_tree (left);
        printf (",");
        print_tree (right);
        printf (")");
    }
}

int main (void) {
    int i;
    struct node *n;

    for (i = 0; i < sizeof (testdata) / sizeof (testdata[0]); i++) {
        if ((n = malloc (sizeof (struct node))) == NULL)
            err (1, NULL);
        n->index = testdata[i];
        RB_INSERT (inttree, &head, n);
    }

    RB_FOREACH (n, inttree, &head) {
        printf ("%d\n", n->index);
    }
    print_tree (RB_ROOT (&head));
    printf ("\n");
    return (0);
}
