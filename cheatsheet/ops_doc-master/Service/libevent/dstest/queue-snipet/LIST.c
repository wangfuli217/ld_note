LIST_HEAD(listhead, entry) head =
    LIST_HEAD_INITIALIZER(head);
struct listhead *headp;			/* List head. */
struct entry {
    ...
    LIST_ENTRY(entry) entries;	/* List. */
    ...
} *n1, *n2, *n3, *np, *np_temp;

LIST_INIT(&head);			/* Initialize the list. */

n1 = malloc(sizeof(struct entry));	/* Insert at the head. */
LIST_INSERT_HEAD(&head, n1, entries);

n2 = malloc(sizeof(struct entry));	/* Insert after. */
LIST_INSERT_AFTER(n1, n2, entries);

n3 = malloc(sizeof(struct entry));	/* Insert before. */
LIST_INSERT_BEFORE(n2, n3, entries);

LIST_REMOVE(n2, entries);		/* Deletion. */
free(n2);
                    /* Forward traversal. */
LIST_FOREACH(np, &head, entries)
    np-> ...

while (!LIST_EMPTY(&head)) {		/* List Deletion. */
    n1 = LIST_FIRST(&head);
    LIST_REMOVE(n1, entries);
    free(n1);
}

n1 = LIST_FIRST(&head);			/* Faster List Deletion. */
while (n1 != NULL) {
    n2 = LIST_NEXT(n1, entries);
    free(n1);
    n1 = n2;
}
LIST_INIT(&head);

