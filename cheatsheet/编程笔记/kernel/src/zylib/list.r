/*
 * =====================================================================================
 *
 *       Filename:  list.r
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  29.03.10 18:29
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */
#ifndef		LIST_R
#define		LIST_R

#include	"object.r"

struct list {
	const struct object _;
	struct node * head;
	size_t cnt;
};

#endif

