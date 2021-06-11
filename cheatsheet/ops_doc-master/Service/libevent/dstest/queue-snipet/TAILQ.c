TAILQ_HEAD(tailhead, entry) head =
    TAILQ_HEAD_INITIALIZER(head);
struct tailhead *headp;			/* Tail queue head. */
struct entry {
    ...
    TAILQ_ENTRY(entry) entries;	/* Tail queue. */
    ...
} *n1, *n2, *n3, *np;

TAILQ_INIT(&head);			/* Initialize the queue. */

n1 = malloc(sizeof(struct entry));	/* Insert at the head. */
TAILQ_INSERT_HEAD(&head, n1, entries);

n1 = malloc(sizeof(struct entry));	/* Insert at the tail. */
TAILQ_INSERT_TAIL(&head, n1, entries);

n2 = malloc(sizeof(struct entry));	/* Insert after. */
TAILQ_INSERT_AFTER(&head, n1, n2, entries);

n3 = malloc(sizeof(struct entry));	/* Insert before. */
TAILQ_INSERT_BEFORE(n2, n3, entries);

TAILQ_REMOVE(&head, n2, entries);	/* Deletion. */
free(n2);
                    /* Forward traversal. */
TAILQ_FOREACH(np, &head, entries)
    np-> ...
                    /* Reverse traversal. */
TAILQ_FOREACH_REVERSE(np, &head, tailhead, entries)
    np-> ...
                    /* TailQ Deletion. */
while (!TAILQ_EMPTY(&head)) {
    n1 = TAILQ_FIRST(&head);
    TAILQ_REMOVE(&head, n1, entries);
    free(n1);
}
                    /* Faster TailQ Deletion. */
n1 = TAILQ_FIRST(&head);
while (n1 != NULL) {
    n2 = TAILQ_NEXT(n1, entries);
    free(n1);
    n1 = n2;
}

TAILQ_INIT(&head);
n2 = malloc(sizeof(struct entry));  /* Insert before. */
CIRCLEQ_INSERT_BEFORE(&head, n1, n2, entries);
                                    /* Forward traversal. */
for (np = head.cqh_first; np != (void *)&head;
        np = np->entries.cqe_next)
    np-> ...
                                    /* Reverse traversal. */
for (np = head.cqh_last; np != (void *)&head; np = np->entries.cqe_prev)
    np-> ...
                                    /* Delete. */
while (head.cqh_first != (void *)&head)
    CIRCLEQ_REMOVE(&head, head.cqh_first, entries);