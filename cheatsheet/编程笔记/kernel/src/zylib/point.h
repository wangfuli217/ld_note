/*
 * =====================================================================================
 *
 *       Filename:  point.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  19.03.10 10:55
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		POINT_H
#define		POINT_H

#include	"object.h"

#ifndef		extern
#ifndef		POINT_IMPLEMENTATION
#define		extern		extern
#else
#define		extern
#endif
#endif

extern void init_point(void);
extern void draw(const void *);

extern const void * class_point;
extern const void * point;

#endif
