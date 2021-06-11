SIMPLEQ_HEAD(listhead, entry) head = SIMPLEQ_HEAD_INITIALIZER(head);
struct entry {
     ...
     SIMPLEQ_ENTRY(entry) entries;   /* Simple queue. */
     ...
} *n1, *n2, *np;

n1 = malloc(sizeof(struct entry));      /* Insert at the head. */
SIMPLEQ_INSERT_HEAD(&head, n1, entries);

n2 = malloc(sizeof(struct entry));      /* Insert after. */
SIMPLEQ_INSERT_AFTER(&head, n1, n2, entries);

n2 = malloc(sizeof(struct entry));      /* Insert at the tail. */
SIMPLEQ_INSERT_TAIL(&head, n2, entries);
                                     /* Forward traversal. */
SIMPLEQ_FOREACH(np, &head, entries)
     np-> ...
                                     /* Delete. */
while (!SIMPLEQ_EMPTY(&head)) {
     n1 = SIMPLEQ_FIRST(&head);
     SIMPLEQ_REMOVE_HEAD(&head, entries);
     free(n1);
}