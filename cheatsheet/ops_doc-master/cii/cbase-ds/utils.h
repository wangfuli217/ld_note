/**
 * File: utils.h
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#ifndef _UTILS_H
#define _UTILS_H

#include <stddef.h>

#define container_of(ptr, type, member) ({			\
	const typeof(((type *)0)->member) *__ptr = (ptr);	\
	(type *)((char *)__ptr - offsetof(type, member));	\
})

#define min(a, b) ((a) < (b) ? (a) : (b))

#define max(a, b) ((a) > (b) ? (a) : (b))

#endif /* _UTILS_H */
