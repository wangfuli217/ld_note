/*
 * =====================================================================================
 *
 *       Filename:  array.c
 *
 *    Description:  dynamic array generation
 *    		    no need to define "add elem" interface explicitly
 *    		    if u want, use sequence instead
 *
 *    		    no direct add function
 *
 *        Version:  1.0
 *        Created:  04.03.10
 *       Revision:  
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include	<string.h>
#include	<assert.h>

#include	<zy/alloc.h>
#include	<zy/array.h>

#define		WANTED_ELEM		(void *)((int)desc->head + i * desc->size)

/*-----------------------------------------------------------------------------
 *   		desc	    array
 *  *desc --> +----+ --> +------+
 *  	      |	   |	 |	|
 *  	      |    |	 |	|
 *  	      |    |	 |	|
 *  	      +----+	 |	|
 *  	      		 |	|
 *  	      		 |	|
 *  	      		 |	|
 *  	      		 |	|
 *  	      		 |	|
 *  	      		 |	|
 *  	      		 |	|
 *  	      		 +------+
 *-----------------------------------------------------------------------------*/

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_create
 *  Description:  create a new array as request
 *  		  return a pointer to the array descriptor
 * =====================================================================================
 */
array_desc *array_create(size_t size, int len)
{
	assert(size);
	assert(len);

	array_desc *desc = (array_desc *) MALLOC(sizeof(array_desc));
	void *ptr = CALLOC(len, size);

	if (desc && ptr) {
		desc->size = size;
		desc->len = len;
		desc->head = ptr;
	} else {
		FAILURE();
	}

	return desc;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_free
 *  Description:  just like it's name
 * =====================================================================================
 */
void array_free(array_desc * desc)
{
	assert(desc);

	FREE(desc->head);
	FREE(desc);
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_length
 *  Description:  array length
 * =====================================================================================
 */
int array_length(array_desc * desc)
{
	assert(desc);
	return desc->len;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_size
 *  Description:  element size in the array
 * =====================================================================================
 */
int array_size(array_desc * desc)
{
	assert(desc);
	return desc->size;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_get_elem
 *  Description:  return the ptr to the wanted one
 * =====================================================================================
 */
void *array_get_elem(array_desc * desc, int i)
{
	assert(desc && desc->head);
	assert(i >= 0 && i < desc->len);

	return WANTED_ELEM;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_substitute_elem
 *  Description:  substitute the index i in the wanted array
 * =====================================================================================
 */
void *array_substitute_elem(array_desc * desc, int i, void * elem)
{
	assert(desc && desc->head && elem);
	assert(i >= 0 && i < desc->len);

	/*-----------------------------------------------------------------------------
	 *  copy desc->size bytes from src to dst
	 *-----------------------------------------------------------------------------*/
	memmove(WANTED_ELEM, elem, desc->size);
	return WANTED_ELEM;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_resize
 *  Description:  resize the original array, meanwhile modify the array descriptor
 *  		  if new_len == 0, free the original array
 * =====================================================================================
 */
void array_resize(array_desc * desc, int new_len)
{
	assert(desc);
	assert(new_len >= 0);

	void *new_ptr;

	if (!new_len) {
		array_free(desc->head);	/* not array_free(desc) */
		desc->head = NULL;	/* modify descriptor */
		desc->len = 0;
	} else {
		new_ptr = REALLOC(desc->head, new_len * desc->size);
		if (new_ptr) {
			desc->head = new_ptr;	/* modify descriptor */
			desc->len = new_len;
		}
	}
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  array_copy
 *  Description:  make a new array descriptor
 *  		  copy copy_len elements from the original to the new one
 *  		  return the new descriptor
 * =====================================================================================
 */
array_desc *array_copy(array_desc * desc, int copy_len)
{
	assert(desc);
	assert(copy_len > 0);	/* wanted */

	array_desc *new_desc = array_create(desc->size, copy_len);

	if (new_desc) {
		/*------------------------------------------------------------
		 *  len <= desc->len ? len : desc->len
		 *-----------------------------------------------------------*/
		if (copy_len <= desc->len) {
			memmove(new_desc->head, desc->head, copy_len);
		} else {
			memmove(new_desc->head, desc->head, desc->len);
		}
	} else {
		FAILURE();
	}

	return new_desc;
}
