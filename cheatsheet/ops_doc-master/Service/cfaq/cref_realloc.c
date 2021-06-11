/**
 * realloc 
 *      Defined in header <stdlib.h>
 *      void *realloc( void *ptr, size_t new_size)
 * Reallocates the given area of memory. It must be previously allocated by
 * malloc(), calloc() or realloc() and not yet freed with free, otherwise, the
 * results are undefined.
 * The reallocation is done by either:
 *      a) expanding or contracting the existing area pointed to by ptr, if
 *         possible. The contents of the area remain unchanged up to the lesser
 *         of the new and old sizes. If the area is expanded, the contents of
 *         the new part of the array are undefined.
 *      b) allocating a new memory block of size <new_size> bytes, copying
 *         memory area with size equal the lesser of the new and the old sizes,
 *         and freeing the old block.
 * If there is not enough memory, the old memory block is not freed and null
 * pointer is returnd.
 * If ptr is NULL, the behavior is the same as calling malloc(new_size)
 * If <new_size> is zero, the behaviour is implementation defined (null pointer
 * may be returnd (in which case the old memory block is not freed), or some
 * non-null pointer may be returned that may not be used to access storage).
 * Parameters:
 *           ptr - pointer to the memory area to be reallocated 
 *      new_size - new size of thea array
 * Return value:
 *      On success, returns the pointer to the beginning of newly allocated
 *      memory. The returned pointer must be deallocated with free() or
 *      realloc(). The original pointer ptr is invalidated and any access to it
 *      is undefined behaviour (even if realocation was in-place).
 *      On failure, returns null pointer. The orignal pointer ptr remains valid
 *      and may need to be deallocated with free() or realloc().
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
 *      realloc is thread-safe: it behaves as though only accessing the memory
 *      locations visible through its argument, and not any static storage.
 *      A previous call to free or realloc that deallocates a region of memory
 *      synchronizes-with a call to any allocation function, including realloc
 *      that allocates the same or a part the same region of memory. This 
 *      synchronization occurs after any access to the memeory by the 
 *      deallocating function and before any access to the memory by realloc. 
 *      There is a single total order of all allocation and deallocation 
 *      functions operating on each particular region of memory.
 *      ! Support for zero size is deprecated as of C11 DR 400.
 * Compilation:
 *      gcc -o realloc realloc.c -std=c99
 * Created@:
 *      2015-08-03
 */
 
#include <stdio.h>
#include <stdlib.h>
int main(void)
{
    int *pa = malloc(10 * sizeof *pa); // allocate an array of 10 int
    if (pa) {
        printf("%zu bytes allocated. Storing ints: ", 10*sizeof(int));
        for (int n = 0; n < 10; ++n)
            printf("%d ", pa[n] = n);
    }

    int *pb = realloc(pa, 1000000 * sizeof *pb); // reallocate array to a larger size
    if (pb) {
        printf("\n%zu bytes allocated, first 10 ints are: ", 1000000*sizeof(int));
        for (int n = 0; n < 10; ++n)
            printf("%d ", pb[n]); // show the array
        free(pb);
    } else {    // if realloc failed, the original pointer needs to be freed
        free(pa);
    }
}

