/**
 * calloc
 *      Defined in header <stdlib.h>
 *      void* calloc( size_t num, size_t size);
 * Allocates memeory for an array of <num> objects of size <size> and
 * initializes all bits in the allocated storage ot zero.
 * If allocation succeeds, returns a pointer to the lowest (first) byte in the
 * allocated memory block that is suitably aligned for any object type.
 * If size is zero, the behaviour is implementation defined (null pionter may be
 * returned, or some non-null pointer may be returned that may not be used to
 * access storage)
 * Parameters:
 *       num - number of objects
 *      size - size of each objects
 * Return value:
 *      On success, returns the pointer to the beginning of newly allocated
 *      memory. The returned pointer must be deallocated with free() or
 *      realloc().
 *      On failure, returns null pointer.
 * Note:
 *      Due to the alignment requiments, the number of allocated bytes is not
 *      necessarily equal to num*size.
 *      Intialization to all bits zero does not guarantee that a floating-point
 *      or a pointer would be initialized to 0.0 and the null pointer value,
 *      respectively (although that is true on all common platforms)
 *      Originally (in C89), support for zero size was added to accomodate code
 *      such as:
 *          OBJ *p = calloc(0, sizeof(OBJ)); // "zero-length" placeholder
 *          ...
 *          while (1) {
 *              p = realloc(p, c * sizeof(OBJ)); // realloc until size settles
 *              ... // code that may change c or break out of loop
 *          }
 *
 *      since C11:
 *      calloc is thread-safe: it behaves as though only accessing the memory
 *      locations visible through its argument, and not any static storage.
 *      A previous call to free or realloc that deallocates a region of memory
 *      synchronizes-with a call to calloc that allocates the same or a part of
 *      the same region of memory. This synchronization occurs after any access
 *      to the memeory by the deallocating function and before any access to the
 *      memory by calloc. There is a single total order of all allocation and
 *      deallocation functions operating on each particular region of memory.
 * Compilation:
 *      gcc -o calloc calloc.c -std=c99
 * Created@:
 *      2015-08-03
 */
 
#include <stdio.h>
#include <stdlib.h>
int main(void)
{
    int *p1 = calloc(4, sizeof(int));   // allocate and zero out an array of 4 int
    int *p2 = calloc(1, sizeof(int[4]));// same, naming the array type directly
    int *p3 = calloc(4, sizeof(*p3));    // same, without repeating the type name

    if (p2) {
        for (int n = 0; n < 4; ++n) // print the array
            printf("p2[%d] == %d\n", n, p2[n]);
    }

    free(p1);
    free(p2);
    free(p3);
}