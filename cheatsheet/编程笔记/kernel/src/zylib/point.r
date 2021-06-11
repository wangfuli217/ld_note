/*
 * =====================================================================================
 *
 *       Filename:  point.r
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  19.03.10 11:04
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		POINT_R
#define		POINT_R

#include	"object.r"

struct point{
	const struct object _;                          /* always have const */
	int x;
	int y;
};

struct class_point {
	const struct class _;
	void (* draw) (const void *);
};

extern void super_draw(const void *, const void *);

#endif
