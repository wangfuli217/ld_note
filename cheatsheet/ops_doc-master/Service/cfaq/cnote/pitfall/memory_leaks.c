#include <stdlib.h>
#include <stdio.h>
int main(void)
{
    char *line = NULL;
    size_t size = 0;
    /* The loop below leaks memory as fast as it can */
    for(;;) {
        getline(&line, &size, stdin); /* New memory implicitly allocated */
        /* <do whatever> */
        line = NULL;
    }
    return 0;
}


int main(void)
{
    char *line = NULL;
    size_t size = 0;
    for(;;) {
        if (getline(&line, &size, stdin) < 0) {
            free(line);
            line = NULL;
            /* Handle failure such as setting flag, breaking out of loop and/or exiting */
        }
        /* <do whatever> */
        free(line);
        line = NULL;
    }
    return 0;
}