/**
 * External and tentative definitions
 * At the top level of a {translation unit} (that is, a source file with all the
 * #includes after the preprocessor), every C program is a sequence of
 * {declaration}, which declare functions and objects with {external linkage}.
 * These declarations are known as external declarations because they appear
 * outside of any function.
 * -----------------------------------------------------------------------------
 * | extern int n;  // external declaration with external linkage              |
 * | int b = 1;     // external definition with external linkage               |
 * | static const char *c = "abc"; // external definition with internal linkage|
 * | int f(void) { // external definition with external linkage                |
 * |    int a = 1; // non-external                                             |
 * |    return b;                                                              |
 * | }                                                                         |
 * | static void x(void) { // external definition with interal linkage         |
 * | }                                                                         |
 * -----------------------------------------------------------------------------
 * Objects declared with an external declaration have static {storage duration},
 * and as such cannot use auto or register specifiers. The identifiers
 * introduced by external declarations have {file scope}.
 * 
 * Tentative definitions
 * A tentative definition is an external declaration without an initializer, and
 * either without a {storage-class specifier} or with the specifier static.
 * A tentative definition is a declaration that may or may not act as a
 * definition. If an actual external definition is found earlier or later in the
 * same translation unit, then the tentative definition just acts as a
 * declaration.
 * -----------------------------------------------------------------------------
 * | int i1 = 1;// definition, external linkage                                |
 * | int i1;    // tentative definition, act as declaration because i1 defined |
 * | extern int i1; // declaration, refers to the earlier definition           |
 * |                                                                           |
 * | extern int i2 = 3; // definition, external linkage                        |
 * | int i2;  // tentative definition, act as declaration because i2 is defined|
 * | extern int i2;   // declaration, refers to the external linkage definition|
 * -----------------------------------------------------------------------------
 * If there are no definitions in the same translation unit, the the tentative
 * defintion acts as an actual definition with the initializer =0 (or, for array
 * types, ={0}).
 * -----------------------------------------------------------------------------
 * | int i3; // tentative definition, external linkage                         |
 * | int i3; // tentative definition, external linkage                         |
 * | extern int i3; // declaration, external linkage                           |
 * | // in this translation unit, i3 is defined as if by "int i3=3;"           |
 * -----------------------------------------------------------------------------
 * Unlike extern declarations, which don't change the linkage of an identifier
 * if a preious declaration established it, tentative definition may disagree in
 * linkage with another declaration of the same identifier. If two declarations
 * for the same identifier are in scope and have different linkage, the behavior
 * is undefined:
 * -----------------------------------------------------------------------------
 * | static int i4 = 4; // definition, internal linkage                        |
 * | int i4;    // undefined behavior: linkage disagreement with previous line |
 * | extern int i4; // declaration, refers to the internal linkage definition  |
 * -----------------------------------------------------------------------------
 * A tentative definition with internal linkage must have complete type.
 * -----------------------------------------------------------------------------
 * | static int i[]; // Error, incomplete type in a static tentative definition|
 * | int i[];   //Ok, equivalent to int i[1]={0}; unless redeclared later      |
 * |            // in this file                                                |
 * -----------------------------------------------------------------------------
 * One definition rule
 * Each translation unit may have zero or one external definition of every
 * identifier with internal linkage (a static global).
 * If an identifier with internal linkage is used in any expression other than a
 * non-VLA (since C99), sizeof, or alignof (since C11), there must be one and
 * only one external definition for that identifier in the translation unit. 
 * The entire program may have zero or one external definition of every
 * identifier (other than an inline function) (since C99) with external linkage.
 * If an identifier with external linkage is used in any expression other than a
 * non-VLA (since C99), sizeof, or alignof (since C11), there must be one and
 * only one external definition for that identifier somewhere in the entire
 * program.
 * Notes:
 *  See inline for the details on the inline function definitions. 
 *  Tentative definitions were invented to standardize various pre-C89
 *  approaches to forward declaring identifiers with internal linkage.
 */


#include <stdio.h>

extern int i;
int main(void)
{
    extern int i;
    printf("i=%d\n", i);
}
