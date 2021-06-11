/*
 * =====================================================================================
 *
 *       Filename:  object.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  17.03.10 18:16
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		OBJECT_H
#define		OBJECT_H

#include	<stdio.h>
#include	<string.h>
#include	<stdarg.h>
#include	<stdlib.h>

#ifndef		extern
#ifndef		OBJECT_IMPLEMENTATION
#define		extern		extern
#else
#define		extern
#endif
#endif

/* #define		class		struct */


/*-----------------------------------------------------------------------------
 *  sentinel for the last parameter in the va_list
 *-----------------------------------------------------------------------------*/
extern void *new(const void *, ...) __attribute__ ((__sentinel__));
extern void delete(void *);

extern const void * object;
extern const void * class;

#endif
