LIST_HEAD(listhead, entry) head;
struct entry {
     ...
     LIST_ENTRY(entry) entries;      /* List. */
     ...
} *n1, *n2, *np;

LIST_INIT(&head);                       /* Initialize list. */

n1 = malloc(sizeof(struct entry));      /* Insert at the head. */
LIST_INSERT_HEAD(&head, n1, entries);

n2 = malloc(sizeof(struct entry));      /* Insert after. */
LIST_INSERT_AFTER(n1, n2, entries);

n2 = malloc(sizeof(struct entry));      /* Insert before. */
LIST_INSERT_BEFORE(n1, n2, entries);
                                     /* Forward traversal. */
LIST_FOREACH(np, &head, entries)
     np-> ...

while (!LIST_EMPTY(&head)) {            /* Delete. */
     n1 = LIST_FIRST(&head);
     LIST_REMOVE(n1, entries);
     free(n1);
}
