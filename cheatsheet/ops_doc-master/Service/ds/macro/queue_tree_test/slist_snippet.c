SLIST_HEAD(listhead, entry) head;
struct entry {
     ...
     SLIST_ENTRY(entry) entries;     /* Simple list. */
     ...
} *n1, *n2, *np;

SLIST_INIT(&head);                      /* Initialize simple list. */

n1 = malloc(sizeof(struct entry));      /* Insert at the head. */
SLIST_INSERT_HEAD(&head, n1, entries);

n2 = malloc(sizeof(struct entry));      /* Insert after. */
SLIST_INSERT_AFTER(n1, n2, entries);

SLIST_FOREACH(np, &head, entries)       /* Forward traversal. */
     np-> ...

while (!SLIST_EMPTY(&head)) {           /* Delete. */
     n1 = SLIST_FIRST(&head);
     SLIST_REMOVE_HEAD(&head, entries);
     free(n1);
}