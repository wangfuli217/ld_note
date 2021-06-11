/**
 * alignas  (since c11)
 * Appears in the {declaration} syntax as one of the type specifier to modify
 * the alignment requirement of the object being declared.
 * Syntax:
 *   _Alignas ( expression )    (1)     (since C11)
 *   _Alignas ( type )          (2)     (since C11)
 *  expression - any {integer constant expression} whose value is a valid
 *               {alignment} or zero
 *        type - any {type name}
 *  This keyword is also available as convenience macro alignas, available in
 *  the header <stdalign.h>
 * Explanation:
 *  The alignas specifier can only be used when declaring objects that aren't
 *  bit fields, and don't have the register storage class. It cannot be used in
 *  function parameter declarations, and cannot be used in a typedef.
 *  When used in a declaration, the declare object will have its {alignment
 *  requirement} set to
 *    1) the result of the <expression>, unless it is zero
 *    2) to the alignment requirement of <type>, that is, to alignof(type)
 *  except when this would weaken the alignment the type would had naturally.
 *  If <expression> evaluates to zero, this specifier has no effect.
 *  When multiple alignas specifiers appear in the same declaration, the
 *  strictest one is used.
 *  Alignas specifier only needs to appear on the {definition} of an object, but
 *  if any declaration uses alignas, it must specify the same alignment as the
 *  alignas on the definition. The behavior is undefined if different
 *  translation uints specify different alignments for the same object.
 * Notes:
 *  As initially published, C11 does not allow alignas specifiers in structure
 *  and union members; this was corrected by DR 444.
 *  In C++, the alignas specifier may also be applied to the declarations of
 *  class/struct/union types and enumerations. This is not supported in C, but
 *  the alignment of a struct type can be controlled by using alignas in a
 *  member declaration (as of DR 444).
 * Compilation:
 *  gcc -o alignas alignas.c -std=c11
 * Created@:
 *  2015-08-06
 */

#include <stdalign.h>
#include <stdio.h>

// every object of type struct sse_t will be aligned to 16-byte boundary
// (note: needs support for DR 444)
struct sse_t
{
    alignas(16) float sse_data[4];
};

// every object of type struct data will be aligned to 128-byte boundary
struct data {
    char x;
    alignas(128) char cacheline[128]; // over-aligned array of char,
                                           // not array of over-aligned chars
};

int main(void)
{
    printf("sizeof(data) = %zu (1 byte 127 bytes padding + 128-byte array)\n",
            sizeof(struct data)); // %zu=256
    printf("alignment of sse_t is %zu\n", alignof(struct sse_t)); // %zu=16
    alignas(2048) struct data d; // this instance of data is aligned even stricter
}
