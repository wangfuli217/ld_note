/**
 * _Alignof operator    (since C11)
 * Queries the alignment requirement of its operand type.
 * Syntax:
 *   _Alignof( type-name )      (since C11)
 *  This operator is typically used through the convenience macro {alignof},
 *  which is provided in the header <stdalign.h>
 * Expplanation:
 *  Returns the {alignment requirement} of the type named by <type-name>. If
 *  <type-name> is an array type, the result is the alignment requirement of the
 *  array element type. The <type-name> cannot be function type or an
 *  incomplete type.
 *  The result is an integer constant of type {size_t}.
 *  The operand is not evaluated (so external identifiers used in the operand do
 *  not have to be defined).
 * Note:
 *  The use of alignof with expressinos (as in C++) is allowed by some C
 *  compilers as non-standard extension.
 * Compilation:
 *  gcc -o alignof alignof.c -std=c11
 * Created@:
 *  2015-08-06
 */

#include <stdio.h>
#include <stddef.h>
#include <stdalign.h>   // C11

int main(void)
{
    printf("Alignment of char = %zu\n", alignof(char));
    printf("Alignment of short = %zu\n", alignof(short));
    printf("Alignment of int = %zu\n", alignof(int));
    printf("Alignment of long = %zu\n", alignof(long));
    printf("Alignment of long long = %zu\n", alignof(long long));
    printf("Alignment of float = %zu\n", alignof(float));
    printf("Alignment of double = %zu\n", alignof(double));
    printf("Alignment of long double = %zu\n", alignof(long double));
    printf("Alignment of max_align_t = %zu\n", alignof(max_align_t));
    printf("alignof(float[10]) = %zu\n", alignof(float[10]));
    printf("alignof(struct{char c; int n;}) = %zu\n",
            alignof(struct {char c; int n;}));
}
