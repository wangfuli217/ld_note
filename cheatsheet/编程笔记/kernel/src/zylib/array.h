/*
 * =====================================================================================
 *
 *       Filename:  array.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04.03.10 19:21
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		ZY_ARRAY_H
#define		ZY_ARRAY_H

/*-----------------------------------------------------------------------------
 *  array.c includes array.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		ZY_ARRAY_IMPLEMENTATION
#define		EXTERN			extern
#else
#define		EXTERN		
#endif


struct array_desc {
	size_t size;                                                  /* elem size */
	int len;                                                /* array length */
	void *head;                                         /* array start addr */
};
typedef struct array_desc array_desc;


EXTERN array_desc *array_create(size_t, int);
EXTERN void array_free(array_desc *);

EXTERN int array_length(array_desc *);
EXTERN int array_size(array_desc *);

EXTERN void *array_get_elem(array_desc *, int);
EXTERN void *array_substitute_elem(array_desc *, int, void *);

EXTERN void array_resize(array_desc *, int);
EXTERN array_desc *array_copy(array_desc *, int);

#endif
