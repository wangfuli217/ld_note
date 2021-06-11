/** @file string.h
	@brief The functional prototypes of string handling. 

	@author Qing Charles Cao (cao@utk.edu)
*/

#ifndef STRINGH
#define STRINGH
#include "types.h"

/** \defgroup string String operations. 
This module provides basic string operations 
*/

/**@{ */

/** @brief Copy string.
	@param dest The dest address.
	@param src The source address.
	@return Void. 
*/
void mystrcpy(char *dest, const char *src);


/** @brief Copy string with size.
	@param dest The dest address.
	@param src The source address.
	@param n The total size. 
	@return Void. 
*/
void mystrncpy(char *dest, const char *src, uint8_t n);

/** @brief Append a string. 
	@param base The string to be used as base.
	@param string The string to be added. 
	@return Void. 
*/
void strappend(char *base, char *string);

/** @brief Convert a string from an integer. 
	@param num The integer.
	@return The string converted from the integer.  
*/

char *str_from_integer(int num);

/** @brief Check if the string1 is a superstring of string2. 
	@param string1 The superstring.
	@param string2 The substring. 
	@return 0 if yes, 1 if no.  
*/

int superstring(char *string1, char *string2);


/** @brief Compare two strings with length.
	@param s The first string.
	@param start1 The starting location of the first string.
	@param t The second string.
	@param start2 The starting location of the second string.
	@param length The total length of the comparison. 
	@return 0 if match, 1 if not match. 	
*/



int mystrncmp(char *s, uint8_t start1, char *t, uint8_t start2,
              uint8_t length);


/** @brief The string length of a string. 
	@param s The string. 
	@return The total length of the string. 
*/

int mystrlen(char *s);

/**@} */
#endif
