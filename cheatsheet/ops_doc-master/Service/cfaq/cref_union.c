/**
 * Union declaration
 * A union is a type consisting of a sequence of members whose storage overlaps
 * (as opposed to struct, which is a type consisting of a sequence of members
 * whose storage is allocated in an ordered sequence). The value of at most one
 * of the members can be stored in a union at any one time.
 * The {type specifier} for a union is identical to the struct type specifier
 * except for the keyword used:
 * Syntax:
 *   union name(optional) { struct-declaration-list }   (1)
 *   union name                                         (2)
 *                    name - the name of the union that's being defined
 * struct-declaration-list - any number of variable declarations, bit field
 *                           declarations, and static assert declarations.
 *                           Members of incomplete type and members of function
 *                           type are not allowed.
 * Explanation:
 *  The union is only as big as necessary to hold its largest member (additional
 *  unnamed trailing padding may also be added). The other members are allocated
 *  in the same bytes as part of that largest member.
 *  A pointer to a union can be cast to a pointer to each of its members (if a
 *  union has bit field members, the pointer to a union can be cast to the
 *  pointer to the undelying type). Likewise, a pointer to any member of a union
 *  can be cast to a pointer to the enclosing union.
 *  If the member used to access the contents of a union is not the same as the
 *  member last used to store a value, the object representation of the value
 *  that was stored is reinterpreted as an object representation of the new type
 *  (this is known as type punning). If the size of the new type is larger than
 *  the size of the last-written type, the contents of the excess bytes are
 *  unspecified (and may be a trap representation)
 *  ___________________________________________________________________________
 *  | Similar to struct, an unnamed member of a union whose type is a union    |
 *  | without name is known as anonymous union. Every member of an anonymous   |
 *  | union is considered to be a member of the enclosing struct or union. This|
 *  | applies recursively if the enclosing struct or union is also anonymous.  |
 *  |----------------------------------------------------------                |
 *  | struct v {                                              |                |
 *  |   union { // anonymous union                            |                |
 *  |     struct { int i, j; }; // anonymous struct           |                |
 *  |     struct { long k, l; } w;                            |                |
 *  |   };                                                    | (since C11)    |
 *  |   int m;                                                |                |
 *  | } v1;                                                   |                |
 *  | v1.i = 2; // valid                                      |                |
 *  | v1.k = 3; // invalid: inner structure is not anonymous  |                |
 *  | v1.w.k = 5; // valid                                    |                |
 *  |----------------------------------------------------------                |
 *  | Similar to struct, the behavior of the program is undefined if union is  |
 *  | without any named members (including those obtained via anonymous nested |
 *  | structs or unions                                                        |
 *  |__________________________________________________________________________|
 * Notes:
 *  See {struct initialization} for the rules about initialization of structs
 *  and unions.
 * Compilation:
 *  gcc -o union union.c -std=c99
 * Created@:
 *  2015-08-06
 */

#include <stdio.h>
#include <stdint.h>

int main(void)
{
    union S {
        uint32_t u32;
        uint16_t u16[2];
        uint8_t  u8;
    } s = {0x12345678}; // s.u32 is now the active member
    printf("Union S has size %zu and holds %x\n", sizeof s, s.u32);
    s.u16[0] = 0x0011;  // s.u16 is now the active member
    // reading from s.u32 or from s.u8 reinterprets the object representation
     printf("s.u8 is now %x\n", s.u8); // unspecified, typically 11 or 00
     printf("s.u32 is now %x\n", s.u32); // unspecified, typically 12340011 or
    // 00115678

    // pointers to all members of a union compare equal to themeselves
    // and the union
    if ((uint8_t*) &s != &s.u8) printf("Oops!\n");

    // this union has 3 bytes of trailing padding
    union pad {
        char c[5]; // occupies 5 bytes
        float f;   // occupies 4 bytes, imposes alignment 4
    } p = { .f=1.23 }; // the size is 8 to satisfy float's alignment
    printf("size of union char[5] and float is %zu\n", sizeof p);
}