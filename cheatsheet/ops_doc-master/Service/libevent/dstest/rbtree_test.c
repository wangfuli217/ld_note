#include <sys/tree.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>

struct node {
    RB_ENTRY(node) entry;
    int i;
};

int
intcmp(struct node *e1, struct node *e2)
{
    return (e1->i < e2->i ? -1 : e1->i > e2->i);
}

RB_HEAD(inttree, node) head = RB_INITIALIZER(&head);
RB_GENERATE(inttree, node, entry, intcmp)

int testdata[] = {
    20, 16, 17, 13, 3, 6, 1, 8, 2, 4, 10, 19, 5, 9, 12, 15, 18,
    7, 11, 14
};

void
print_tree(struct node *n)
{
    struct node *left, *right;

    if (n == NULL) {
        printf("nil");
        return;
    }
    left = RB_LEFT(n, entry);
    right = RB_RIGHT(n, entry);
    if (left == NULL && right == NULL)
        printf("%d", n->i);
    else {
        printf("%d(", n->i);
        print_tree(left);
        printf(",");
        print_tree(right);
        printf(")");
    }
}

int
main(void)
{
    int i;
    struct node *n;

    for (i = 0; i < sizeof(testdata) / sizeof(testdata[0]); i++) {
        if ((n = malloc(sizeof(struct node))) == NULL)
                err(1, NULL);
        n->i = testdata[i];
        RB_INSERT(inttree, &head, n);
    }

    RB_FOREACH(n, inttree, &head) {
        printf("%d\n", n->i);
    }
    print_tree(RB_ROOT(&head));
    printf("\n");
    return (0);
}