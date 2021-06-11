/**
 * Enumerations
 * An enumerated type is distinct type whose value is restricted to one of
 * several explicitly named constants (enumeration constants).
 * Syntax:
 *  Enumerated type is declared using the following enumeration specifier as the
 *  type specifier in the declaratioin grammar:
 *    enum identifier(optionall) { enumerator-list }
 *  where <enumerator-list> is a comma-separated list (with trailing comma
 *  permitted (since C99)) of <enumerators>, each of which has the form:
 *    enumerator                      (1)
 *    enumerator=constant-expression  (2)
 *  where
 *  identifier, enumerator - identifiers that are introduced by this declaration
 *     constant-expression - integer constant expression whose value is
 *                           representable as a value of type int
 *  As with struct or union, a declaration that introduced an enumerated type
 *  and one or more enumeration constants may also delcare one ore more objects
 *  of that type derived from it.
 *    enum color_t {RED, GREEN, BLUE} c = RED, *cp = &c; 
 * Explanation:
 *  Each <enumerator> that appears in the body of an enumeration specifier
 *  becomes an integer constant with type int in the enclosing scope and can be
 *  used whenever integer constants are required (e.g. as a case label or as a
 *  non-VLA array size).
 *  If <enumerator> is followed by =constant-expression, its value is the value
 *  of that constant expression. If <enumerator> is not followed by
 *  =constant-expression, its value is the value one greater than the value of
 *  the previous enumerator in the same enumeration. The value of the first
 *  enumerator (if it does not use =constant-expression) is zero.
 *  The identifier itself, if used, becomes the name of the enumerated type in
 *  the tags name space and requires the use of keyword enum (unless typedef'd
 *  into the ordinary name space).
 * Note:
 *  Unlike struct or union, there are no forward-declared enums in C:
 *    enum Color;   // Error: no forward-declarations for enums in C
 *    enum Color {RED, GREEN, BLUE};
 */

#include <stdio.h>

int main(void)
{
    enum color_t {RED, GREEN, BLUE} c = RED, *cp = &c;
    printf("RED=%d, GREEN=%d, BLUE=%d\n", RED, GREEN, BLUE);

    enum Foo { A, B, C=10, D, E=1, F, G=F+C };
    // A=0, B=1, C=10, D=11, E=1, F=2, G=12

    {
        enum color_t {RED=1, GREEN, BLUE} c = RED, *cp = &c;
        printf("RED=%d, GREEN=%d, BLUE=%d\n", RED, GREEN, BLUE);
    }
}