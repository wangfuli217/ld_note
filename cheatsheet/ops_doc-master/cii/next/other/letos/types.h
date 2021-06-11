/** @file types.h
	@brief The definitions of types.

	@author Qing Charles Cao (cao@utk.edu)
*/

#ifndef TYPESH
#define TYPESH

/**\addtogroup type */

/**@{*/

typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef int int16_t;
typedef unsigned int uint16_t;
typedef long int32_t;
typedef unsigned long uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;
typedef unsigned int size_t;
typedef unsigned char bool;
typedef unsigned char boolean;
typedef unsigned char bool2; 
typedef uint8_t result_t;
typedef uint8_t _atomic_t;

#ifndef TRUE
#define TRUE  1
#endif
#ifndef true
#define true  1
#endif
#ifndef FALSE
#define FALSE 0
#endif
#ifndef false
#define false 0
#endif
enum
{
    FAIL = 0, SUCCESS = 1
};
enum
{
    YES = 1, NO = 0
};
inline result_t rcombine(result_t r1, result_t r2);

#ifndef NULL
#define NULL 0
#endif
enum
{
    MILLISECOND = 1, SECOND = 1000, MINUTE = 60000
};

/** @} */

/** \ingroup type */
/** @brief Check if a character is a letter or not. 
*/

#define isLetter(c) (('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z'))

/** \ingroup type */
/** @brief Check if a character is a digit or not. 
*/

#define isDigit(c) (('0' <= c && c <= '9'))

/** \ingroup type */
/** @brief Convert a hex value into real value.
	@param hex The hex value. 
	@return The value of the hex in integer. 
*/

uint16_t hex2value(uint8_t hex);

/** \ingroup type */
/** @brief Convert a dec value into ascii char.
	@param value The decimal value. 
	@return The ascii char. 
*/
char dec2asciichar(uint8_t value);

/** \ingroup type */
/** @brief Starting atomic operations. 
	@return The current status register. 
*/
_atomic_t _atomic_start(void);

/** \ingroup type */
/** @brief Ending atomic operations. 
	@return Void. 
*/
void _atomic_end(_atomic_t oldSreg);

/** \defgroup memory Memory operations.
This module provides basic memory operations.  
*/

/** @{ */

/** @brief Find the top of a stack using an array. */
#define STACK_TOP(stack)    \
(&(((uint16_t *)stack)[(sizeof(stack) / sizeof(uint16_t)) - 1]))


/** @brief Set memory sections. 
	@param to The memory section start. 
	@param val The target value. 
	@param n The size of the setting operation. 
	@return Void. 
*/
inline void *nmemset(void *to, int val, size_t n);

/** @} */
#endif
