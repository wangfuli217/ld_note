/**
 * offsetof
 *   Defined in header <stddef.h>
 *   #define offsetof(type, member) // implementaion-defined
 * The macro offsetof expands to a constant of type {size_t}, the value of which
 * is the offset, in bytes, from the beginning of an object of specified type to
 * its specified member, including padding if any.
 * Compilation:
 *  gcc -o offsetof offsetof.c -std=c99
 * Created@:
 *  2015-08-06
 */

#include <stdio.h>
#include <stddef.h>

struct S {
    char c;
    double d;
};

int main(void)
{
    printf("the first element is at offset %zu\n", offsetof(struct S, c));
    printf("the double is at offset %zu\n", offsetof(struct S, d));
}