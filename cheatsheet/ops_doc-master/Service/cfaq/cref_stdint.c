/**
 * <stdint.h> header    since C99
 * Fixed width integer types
 * Types:
 *   Defined in header <stdint.h>
 * _____________________________________________________________________________
 * int8_t           signed integer type with width of exactly 8, 16, 32 and 64
 * int16_t          bits respectively with no padding bits and using 2's 
 * int32_t          complement for negative values (provided only if the 
 * int64_t          implementation directly supports the type)
 * _____________________________________________________________________________
 * int_fast8_t      
 * int_fast16_t     fastest signed integer type with width of at least 8, 16, 32
 * int_fast32_t     and 64 bits respectively
 * int_fast64_t
 * _____________________________________________________________________________
 * int_least8_t     
 * int_least16_t    smallest signed integer type with width of at least 8, 16,
 * int_least32_t    32 and 64 bits respectively
 * int_least64_t
 * _____________________________________________________________________________
 * intmax_t         maximum width integer type
 * _____________________________________________________________________________
 * intptr_t         integer type capable of holding a pointer
 * _____________________________________________________________________________
 * uint8_t          unsigned integer type with width of exactly 8, 16, 32 and 
 * uint16_t         64 bits respectively provided only if the implementation 
 * uint32_t         directly supports the type)
 * uint64_t          
 * _____________________________________________________________________________
 * uint_fast8_t      
 * uint_fast16_t    fastest unsigned integer type with width of at least 8, 16, 
 * uint_fast32_t    32 and 64 bits respectively
 * uint_fast64_t
 * _____________________________________________________________________________
 * uint_least8_t     
 * uint_least16_t   smallest unsigned integer type with width of at least 8, 16,
 * uint_least32_t   32 and 64 bits respectively
 * uint_least64_t
 * _____________________________________________________________________________
 * uintmax_t        maximum width unsigned integer type
 * _____________________________________________________________________________
 * uintptr_t        unsigned integer type capable of holding a pointer
 * _____________________________________________________________________________
 *
 *
 * Macro constants
 *   Defined in header <stdint.h>
 *  Signed integers: minimum value
 * _____________________________________________________________________________
 * INT8_MIN
 * INT16_MIN        minimum value of an object of type int8_t, int16_t, int32_t
 * INT32_MIN        int64_t (macro constant)
 * INT64_MIN
 * _____________________________________________________________________________
 * INT_FAST8_MIN    
 * INT_FAST16_MIN   minimum value of an object of type int_fast8_t, int_fast16_t
 * INT_FAST32_MIN   , int_fast32_t, int_fast64_t (macro constant)
 * INT_FAST64_MIN
 * _____________________________________________________________________________
 * INT_LEAST8_MIN   
 * INT_LEAST16_MIN  minimum value of an object of type int_least8_t,
 * INT_LEAST32_MIN  int_least16_t, int_least32_t, int_least64_t (macro constant)
 * INT_LEAST64_MIN
 * _____________________________________________________________________________
 * INTPTR_MIN       minimum value of an object of type intptr_t
 * _____________________________________________________________________________
 * INTMAX_MIN       minimum value of an object of type intmax_T
 * _____________________________________________________________________________
 *
 *  Signed integers: maximum value
 * _____________________________________________________________________________
 * INT8_MAX
 * INT16_MAX        maximum value of an object of type int8_t, int16_t, int32_t
 * INT32_MAX        int64_t (macro constant)
 * INT64_MAX
 * _____________________________________________________________________________
 * INT_FAST8_MAX    
 * INT_FAST16_MAX   maximum value of an object of type int_fast8_t, int_fast16_t
 * INT_FAST32_MAX   , int_fast32_t, int_fast64_t (macro constant)
 * INT_FAST64_MAX
 * _____________________________________________________________________________
 * INT_LEAST8_MAX   
 * INT_LEAST16_MAX  maximum value of an object of type int_least8_t,
 * INT_LEAST32_MAX  int_least16_t, int_least32_t, int_least64_t (macro constant)
 * INT_LEAST64_MAX
 * _____________________________________________________________________________
 * INTPTR_MAX       maximum value of an object of type intptr_t
 * _____________________________________________________________________________
 * INTMAX_MAX       maximum value of an object of type intmax_T
 *
 *  Unsigned integers: maximum value
 * _____________________________________________________________________________
 * UINT8_MAX
 * UINT16_MAX       maximum value of an object of type uint8_t, uint16_t, 
 * UINT32_MAX       uint32_t, uint64_t (macro constant)
 * UINT64_MAX
 * _____________________________________________________________________________
 * UINT_FAST8_MAX    
 * UINT_FAST16_MAX  maximum value of an object of type uint_fast8_t, 
 * UINT_FAST32_MAX  uint_fast16_t, uint_fast32_t, uint_fast64_t (macro constant)
 * UINT_FAST64_MAX
 * _____________________________________________________________________________
 * UINT_LEAST8_MAX   
 * UINT_LEAST16_MAX maximum value of an object of type uint_least8_t,
 * UINT_LEAST32_MAX uint_least16_t, uint_least32_t, uint_least64_t 
 * UINT_LEAST64_MAX (macro constant)
 * _____________________________________________________________________________
 * UINTPTR_MAX      maximum value of an object of type uintptr_t
 * _____________________________________________________________________________
 * UINTMAX_MAX      maximum value of an object of type uintmax_T
 * _____________________________________________________________________________
 *
 *
 * Function macros for minimum-width integer constants
 * _____________________________________________________________________________
 * INT8_C       expands to an integer constant expression having the value
 * INT16_C      specified by its argument and the type int_least8_t, 
 * INT32_C      int_least16_t, int_least32_t, int_least64_t respectively
 * INT64_C      (function macro)
 * _____________________________________________________________________________
 * INTMAX_C     expands to an integer constant expression having the value 
 *              specified by its argument and the type intmax_t (function macro) 
 * _____________________________________________________________________________
 * UINT8_C      expands to an integer constant expression having the value
 * UINT16_C     specified by its argument and the type uint_least8_t, 
 * UINT32_C     uint_least16_t, uint_least32_t, uint_least64_t respectively
 * UINT64_C     (function macro)
 * _____________________________________________________________________________
 * UINTMAX_C    expands to an integer constant expression having the value 
 *              specified by its argument and the type intmax_t (function macro) 
 * _____________________________________________________________________________
 *
 * Compilation:
 *  gcc -o stdint stdint.c -std=c11
 * Created@:
 *  2015-08-08
 */


#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

 int main(void)
{
    printf("%zu\n", sizeof(UINT64_C(0x123)));
    printf("%zu\n", sizeof(int64_t));
    printf("%s\n", PRId64);
    printf("%+"PRId64"\n", INT64_MIN);
    printf("%+"PRId64"\n", INT64_MAX);

    int64_t n = 7;
    printf("%+"PRId64"\n", n);

    return 0;
}