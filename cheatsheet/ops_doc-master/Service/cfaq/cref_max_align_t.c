/**
 * max_align_t  (since C11)
 *   Defined in header <stddef.h>
 *   typedef ..implementation-defined.. max_align_t;    (since C11)
 * max_align_t is a type whose alignment requirement is at least as strict (as
 * large) as that of every scalar type.
 * Notes:
 *  Pointers returned by allocation functions such as {malloc} are suitably
 *  aligned for any object, which means they are aligned at least as strict as
 *  max_align_t.
 *  max_align_t is usually synonymous with the largest scalar type, which is
 *  long double on most platforms, and its alignment requirement is either 8 or
 *  16.
 * Compilation:
 *  gcc -o max_align_t max_align_t.c -std=c11
 * Created@:
 *  2015-08-06
 */

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdalign.h>   // C11

int main(void)
{
    size_t a = alignof(max_align_t);
    printf("Alignment of max_align_t is %zu (%#zx)\n", a, a);
    printf("sizeof(max_align_t) = %zu\n", sizeof(max_align_t));
    a = alignof(long double);
    printf("Alignment of long double is %zu (%#zx)\n", a, a);
    printf("sizeof(long double) = %zu\n", sizeof(long double));

    int *p = malloc(123);
    printf("The address obtained from malloc(123) is %#" PRIxPTR"\n",
            (uintptr_t)p);
    free(p);
}
