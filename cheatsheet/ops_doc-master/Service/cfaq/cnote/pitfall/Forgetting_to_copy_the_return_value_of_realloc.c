char *buf, *tmp;
buf = malloc(...);
...
/* WRONG */
if ((buf = realloc(buf, 16)) == NULL)
    perror("realloc");



/* RIGHT */
if ((tmp = realloc(buf, 16)) != NULL)
    buf = tmp;
else
    perror("realloc");