/**
 * Bit field
 * Declares a member with explicit width, in bits. Adjacent bit field members
 * may be packed to share and straddle the individual bytes.
 * A bit field declaration is a struct or union member declaratioin which uses
 * the following declarator:
 *      identifier(optional) : width
 *      identifier - the name of the bit field that is being declared. The name
 *                   is optional: nameless bitfields introduce the specified
 *                   number of bits of padding
 *           width - an integer constant expression with a value greater or
 *                   equal to zero and less or equal to the number of bits in 
 *                   the underlying type. When greater than zero, this is the 
 *                   number of bits that this bit field will occupy. The value 
 *                   zero is only allowed for nameless bitfields and has 
 *                   special meaning: it specifies that the next bit field in 
 *                   the class definition will begin at an allocation units 
 *                   boundary.
 * Explanation:
 *  Bit fields can have only one of four types (possibly const or volatile
 *  qualified):
 *    * unsigned int, for unsigned bit fields (unsigned int b:3; has the range
 *      0..7)
 *    * signed int, for signed bit fields (signed int b:3; has the range -4..3)
 *    * int, for bit fields with implementation-defined signedness (Note that
 *      this differs from the meaning of the keyword int everywhere else, where
 *      it means "signed int"). For example, int b:3; may have the range of
 *      value 0..7 or -4..3
 *    * _Bool, for single-bit bit fields (bool x:1; has the range 0..1 and
 *      implicit conversions to and from it follow the boolean conversion rules.
 *  Additional implementation-defined types may be acceptable. It is also
 *  implementation-defined whether a bit field may have atomic type.(since C11)
 *  The number of bits in a bit field (width) sets the limit ot the range of
 *  values it can hold.
 *  Because bit fields do not necessarily begin at the beginning of a byte,
 *  address of a bit field cannot be taken. Pointers to bit fields are not
 *  possible. Bit fields cannot be used with sizeof and alignas (since C11).
 * Note:
 *  Even though the number of bits in the object representation of _Bool is at
 *  least CHAR_BIT, the width of the bit field of type _Bool cannot be greater
 *  than 1.
 *  In the C++ programming language, the width of a bit field can exceed the
 *  width of the underlying type.
 * Compilation:
 *  gcc -o bit_fields bit_fields.c -std=c99
 * Created@:
 *  2015-08-05
 */

#include <stdio.h>

int main()
{
    struct s1 {
        // three-bit unsigned field,
        // allowed values are 0...7
        unsigned int b: 3;
    };
    struct s1 s1 = {7};
    ++s1.b; // unsigned overflow
    printf("s1.b = %d\n", s1.b); // output: 0

    /* Multiple adjacent bit fields are permitted to be (and usually are) packed
     * together
     */
    struct s2 {
        // will usually occupy 4 bytes:
        // 5 bits: value of b1
        // 11 bits: unused
        // 6 bits: value b2
        // 2 bits: value b3
        // 8 bits: unused
        unsigned b1 : 5, : 11, b2 : 6, b3 : 2;
    };
    printf("%zu\n", sizeof(struct s2)); // usually prints 4

    struct s3 {
        // will usually occupy 8 bytes
        // 5 bits: value of b1
        // 27 bits: unused
        // 6 bits: value of b2
        // 15 bits: value b3
        // 11 bits: unused
        unsigned b1 : 5;
        unsigned : 0; // start a new unsigned int
        unsigned b2 : 6;
        unsigned b3 : 15;
    };
    printf("%zu\n", sizeof(struct s3)); // usually prints 8
}
