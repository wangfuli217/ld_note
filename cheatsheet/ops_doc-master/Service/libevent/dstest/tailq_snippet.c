TAILQ_HEAD(tailhead, entry) head;
struct entry {
     ...
     TAILQ_ENTRY(entry) entries;     /* Tail queue. */
     ...
} *n1, *n2, *np;

TAILQ_INIT(&head);                      /* Initialize queue. */

n1 = malloc(sizeof(struct entry));      /* Insert at the head. */
TAILQ_INSERT_HEAD(&head, n1, entries);

n1 = malloc(sizeof(struct entry));      /* Insert at the tail. */
TAILQ_INSERT_TAIL(&head, n1, entries);

n2 = malloc(sizeof(struct entry));      /* Insert after. */
TAILQ_INSERT_AFTER(&head, n1, n2, entries);

n2 = malloc(sizeof(struct entry));      /* Insert before. */
TAILQ_INSERT_BEFORE(n1, n2, entries);
                                     /* Forward traversal. */
TAILQ_FOREACH(np, &head, entries)
     np-> ...
                                     /* Manual forward traversal. */
for (np = n2; np != NULL; np = TAILQ_NEXT(np, entries))
     np-> ...
                                     /* Delete. */
while ((np = TAILQ_FIRST(&head))) {
     TAILQ_REMOVE(&head, np, entries);
     free(np);
}