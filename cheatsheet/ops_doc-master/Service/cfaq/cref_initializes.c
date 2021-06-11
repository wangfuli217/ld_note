/**
 * Initialization
 * A declaration of an object may provide its initial value through the process
 * known as initialization.
 * For each declarator, the initializer, if not ommited, may be one of the
 * following:
 *  = expression            (1)
 *  = { initializer-list }  (2)
 * where <initializer-list> is non-empty comma-separated list of <initializer>s
 * (with an optional trailing comma), where each initializer has one of three
 * possible forms:
 *  expression                      (1)
 *  { initializer-list }            (2)
 *  designator-list = initializer   (3)
 * where <designator-list> is a list of either array designators of the form
 * [ <constant-expression> ] or struct/union member designators of the form 
 * .<identifier>; see array initialization and struct initialization.
 * Explanation:
 *  The initializer specifies the initial value stored in an object.
 * Explicit intialization:
 *  If an intializer is provider, see
 *   * {scalar intialization} for the initialization of scalar types
 *   * {array initialization} for the initialization of array types
 *   * {struct initialization} for the initialization of struct and union types
 * Implicit initialization:
 *  If an initializer is not provided:
 *   * objects with automatic storage duration are initialized to indeterminate
 *     values (which may be {trap representations})
 *   * objects with static and thread_local storage duration are intialized as
 *     follows:
 *     * pointers are initialized to null pointer values of the types
 *     * objects of integral types are initialized to unsigned zero
 *     * objects of floating types are initialized to positive zero
 *     * members of arrays, structs, and unions are initialized as described
 *       above, recursively, plus all padding bits are initialized to zero
 *     (on platforms where null pointers and floating zeroes have all-bit-zero 
 *      representations, this form of initialization for statics is normally 
 *      implemented by allocating them in the .bss section of the program image)
 * Notes:
 *  When initializing an object of static or thread-local storage duration,
 *  every <expression> in the initializer must be a constant expression or string
 *  literal.
 *  Initializers cannot be used in declarations of objects of incomplete type,
 *  VLAs, and block-scope objects with linkage.
 *  The initial values of function parameters are established as if by
 *  assignment from the arguments of a function call, rather than by
 *  initialization (until the post-C11 defect report DR 427, which changes the
 *  wording to use initialization).
 * Compilation:
 *  gcc -o initialization initialization.c -std=c99
 * Created@:
 *  2015-08-05
 */

#include <stdio.h>
#include <stdlib.h>

int a[2]; // initializes a to {0, 0}

int main(void)
{
    int i;        // initializes i to an indeterminate value
    static int j; // initializes j to 0
    int k = 1;    // initializes k to 1

    // initializes int x[3] to 1, 3, 5
    // initializes int* p to &x[0]
    int x[] = { 1, 3, 5 }, *p = x;

    // initializes w (an array of two structs) to
    // { { {1,0,0}, 0}, { {2,0,0}, 0} }
    struct { int a[3], b; } w[] = {[0].a = {1}, [1].a[0] = 2};
    for (int i = 0; i < 3; ++i)
        printf("w[0].a[%d] = %d, w[1].a[%d] = %d\n",
            i, w[0].a[i], i, w[1].a[i]);
    
    // function call to expression can be used for a local variable
    char *ptr = malloc(10);
    free(ptr);

    // Error: objects with static storage duration require constant initializers
    // static char *ptr = malloc(10);

    // Error: VLA cannot be initialized
    // int vla[n] = {0};
}
