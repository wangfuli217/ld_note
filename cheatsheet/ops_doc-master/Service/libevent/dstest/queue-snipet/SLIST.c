SLIST_HEAD(slisthead, entry) head =
    SLIST_HEAD_INITIALIZER(head);
struct slisthead *headp;		/* Singly-linked List
                                           head. */
struct entry {
    ...
    SLIST_ENTRY(entry) entries;	/* Singly-linked List. */
    ...
} *n1, *n2, *n3, *np;

SLIST_INIT(&head);			/* Initialize the list. */

n1 = malloc(sizeof(struct entry));	/* Insert at the head. */
SLIST_INSERT_HEAD(&head, n1, entries);

n2 = malloc(sizeof(struct entry));	/* Insert after. */
SLIST_INSERT_AFTER(n1, n2, entries);

SLIST_REMOVE(&head, n2, entry, entries);/* Deletion. */
free(n2);

n3 = SLIST_FIRST(&head);
SLIST_REMOVE_HEAD(&head, entries);	/* Deletion from the head. */
free(n3);
                    /* Forward traversal. */
SLIST_FOREACH(np, &head, entries)
    np-> ...

while (!SLIST_EMPTY(&head)) {		/* List Deletion. */
    n1 = SLIST_FIRST(&head);
    SLIST_REMOVE_HEAD(&head, entries);
    free(n1);
}
