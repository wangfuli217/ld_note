char *dest = malloc(strlen(src)); /* WRONG */
char *dest = malloc(strlen(src) + 1); /* RIGHT */
strcpy(dest, src);

#define MAX_INPUT_LEN 42
char buffer[MAX_INPUT_LEN]; /* WRONG */
char buffer[MAX_INPUT_LEN + 1]; /* RIGHT */
scanf("%42s", buffer);  /* Ensure that the buffer is not overflowed */

