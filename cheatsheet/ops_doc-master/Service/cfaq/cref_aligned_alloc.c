/**
 * aligned_alloc (since C11)
 *      Defined in header <stdlib.h>
 *      void *aligned_alloc( size_t alignment, size_t size); (since C11)
 * Allocate size bytes of uninitialized storage whose alignment is specified by
 * <alignment>. The size parameter must be an integral multiple of <alignment>.
 * aligned_alloc is thread_safe: it behaves as though only accessing the memory
 * locations visible through its argument, and not any static storage.
 * A previous call to free or realloc that deallocates a region of memory
 * synchronizes-with a calll to aligned_alloc that allocates the same or a part
 * of the same region of memory. This synchronization occurs after any access to
 * the memory by the deallocating function and before any access to the memory
 * by aligned_alloc. There is a single total order of all allocation and
 * deallocation functions operating on each particular region of memory.
 * Parameters:
 *      alignment - specifies the alignment. Must be a valid alignment supported
 *                  by the implementation.
 *           size - number of bytes to allocate. An integral multiple of
 *                  alignment.
 * Return value:
 *      On success, returns the pointer to the beginning of newly allocated
 *      memory. The returned pointer must be deallocated with free() or
 *      realloc().
 *      On failure, returns a null pointer
 * Notes:
 *      Passing a size which is not an integeral multiple of <alignment> or a  
 *      <aligment> which is not valid or not supported by the implementation 
 *      causes the function to fail and return a null pointer.
 *      As an example of the "supported by the implementation" requirement,
 *      POSIX function {posix_memalign} accepts any alignment that is a power of
 *      two and a multiple of sizeof(void*), and POSIX-based implementations of
 *      aligned_alloc inherit this requirements.
 *      Regular {malloc} aligns memory suitable for any object type (which, in
 *      practice, mean that it is aligned to alignof(max_align_t). This function
 *      is useful for over-aligned allocations, such as to SSE, cache line, ov
 *      VM page boundary.
 * Compilation:
 *      gcc -o aligned_alloc aligned_alloc.c -std=c11
 * Created@:
 *      2015-08-03
 */

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *p1 = malloc(10*sizeof *p1);
    printf("default-aligned addr: %p\n", (void *) p1);
    free(p1);

    int *p2 = aligned_alloc(1024, 10*sizeof *p2);
    printf("1024-byte aligned addr: %p\n", (void *) p2);
    free(p2);
}
