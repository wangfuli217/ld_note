/**
 * size_t
 *   Defined in header <stddef.h>
 *   Defined in header <stdio.h>
 *   Defined in header <string.h>
 *   Defined in header <time.h>
 *   typedef ..implementation-defined.. size_t;
 * size_t is the unsigned integer type of the result of {sizeof},
 * {alignof}(since C11), and {offset}.
 * Notes:
 *  size_t can store the maximum size of a theoretically possible object of any
 *  type (including array).
 *  size_t is commonly used for array indexing and loop counting. Programs that
 *  use other types, such as unsigned int, for array indexing may fail on, e.g.
 *  64-bit systems when the index exceeds UINT_MAX or if it relies on 32-bit
 *  modular arithmetic.
 * Compilation:
 *  gcc -o size_t size_t.c -std=c99
 * Created@:
 *  2015-08-06
 */

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>

int main(void)
{
    const size_t N = 100;
    int numbers[N];
    for (size_t ndx = 0; ndx < N; ++ndx)
        numbers[ndx] = ndx;
    printf("SIZE_MAX = %lu\n", SIZE_MAX);
    size_t size = sizeof(numbers);
    printf("size = %zu\n", size);

    return 0;
}