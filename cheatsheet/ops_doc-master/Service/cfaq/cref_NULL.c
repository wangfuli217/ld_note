/**
 * NULL
 *   Defined in header <stddef.h>
 *   Defined in header <string.h>
 *   Defined in header <wchar.h>
 *   Defined in header <time.h>
 *   Defined in header <locale.h>
 *   Defined in header <stdio.h>
 *  #define NULL ..implementation-defined..
 * Expands into implementation-defined null-pointer constant.
 * Compilation:
 *  gcc -o NULL NULL.c
 * Created@:
 *  2015-08-08
 */

#include <stdlib.h>

struct S;
void (*f)() = NULL;

int main(void)
{
    char *ptr = malloc(sizeof(char)*10);
    if (ptr == NULL) exit(EXIT_FAILURE);
    free(ptr);
    ptr = NULL;

    int *p = NULL;
    struct S *s = NULL;

    return EXIT_SUCCESS;
}
