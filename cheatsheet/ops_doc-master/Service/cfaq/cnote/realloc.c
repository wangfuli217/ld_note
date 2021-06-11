#include <stdio.h>
#include <stdlib.h>
 
int main(void)
{
    int *p = malloc(10 * sizeof *p);
    if (NULL == p)
    {
        perror("malloc() failed");
        return EXIT_FAILURE;
    }
 
    p[0] = 42;
    p[9] = 15;
    /* Reallocate array to a larger size, storing the result into a
     * temporary pointer in case realloc() fails. */
    {
        int *temporary = realloc(p, 1000000 * sizeof *temporary);
        /* realloc() failed, the original allocation was not free'd yet. */
        if (NULL == temporary)
        {
            perror("realloc() failed");
            free(p); /* Clean up. */
            return EXIT_FAILURE;
        }      
        p = temporary;
    }
    /* From here on, array can be used with the new size it was
     * realloc'ed to, until it is free'd. */
    /* The values of p[0] to p[9] are preserved, so this will print:
       42 15
    */
    printf("%d %d\n", p[0], p[9]);
    free(p);

    return EXIT_SUCCESS;
}