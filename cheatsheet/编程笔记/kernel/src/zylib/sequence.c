/*
 * =====================================================================================
 *
 *       Filename:  sequence.c
 *
 *    Description:  array.c wrapper, more functionalities
 *
 *    		    we use MEMMOVE(), the shortcoming is we only can deal with the
 *    		    types which has certain length, i.e. can't use on "char *"
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

#include	<stdarg.h>
#include	<string.h>
#include	<assert.h>

#include	<zy/alloc.h>
#include	<zy/array.h>
#include	<zy/sequence.h>

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_create
 *  Description:  return a seq descriptor
 *  		  malloc a seq desc and a array desc simultaneously
 * =====================================================================================
 */
seq_desc *seq_create(size_t size, int len, int start)
{
	seq_desc *sed = (seq_desc *) MALLOC(sizeof(seq_desc));
	/*-----------------------------------------------------------------------------
	 *  init arr-size; arr-len; arr-*head
	 *-----------------------------------------------------------------------------*/
	array_desc *ard = array_create(size, len);

	if (sed && ard) {
		sed->ard_p = ard;	/* the others */
		sed->len = len;
		sed->start = start;
	} else {
		FAILURE();
	}

	return sed;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_attach_array
 *  Description:  return a seq descriptor
 *  		  a known array, make a seq descriptor attach to it
 * =====================================================================================
 */
seq_desc *seq_attach_array(array_desc * ard, int len, int start)
{
	assert(ard);
	assert(start && start < len);	/* assert(len) also */

	/*-----------------------------------------------------------------------------
	 *  if length wanted > original array length
	 *  resize the array with the new length
	 *-----------------------------------------------------------------------------*/
	if (len > ard->len) {
		array_resize(ard, len);
	}

	seq_desc *sed = (seq_desc *) MALLOC(sizeof(seq_desc));
	if (sed) {
		sed->ard_p = ard;	/* the others */
		sed->len = len;
		sed->start = start;
	} else {
		FAILURE();
	}

	return sed;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_free
 *  Description:  free the sed/ard & the array
 * =====================================================================================
 */
void seq_free(seq_desc * sed)
{
	assert(sed);
	array_free(sed->ard_p);
	FREE(sed);
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_len
 *  Description:  return the val of len elem
 * =====================================================================================
 */
int seq_len(seq_desc * sed)
{
	assert(sed);
	return sed->len;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_start
 *  Description:  return the val of start elem
 * =====================================================================================
 */
int seq_start(seq_desc * sed)
{
	assert(sed);
	return sed->start;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_get_elem
 *  Description:  get a wanted
 * =====================================================================================
 */
void *seq_get_elem(seq_desc * sed, int i)
{
	assert(sed);
	assert(i > 0 && i < sed->len - 1);	/* index max == len - 1 */

	void *ptr;
	array_desc *ard = sed->ard_p;

	return ptr = array_get_elem(ard, (sed->start + i) % ard->len);
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_subtitute_elem
 *  Description:  substitute a wanted
 * =====================================================================================
 */
void *seq_substitute_elem(seq_desc * sed, int i, void *x)
{
	assert(sed);
	assert(x);
	assert(i > 0 && i < sed->len - 1);	/* index max == len - 1 */

	void *ptr;
	array_desc *ard = sed->ard_p;

	return ptr = array_substitute_elem(ard, (sed->start + i) % ard->len, x);
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_addhi
 *  Description:  add one to the seq end
 * =====================================================================================
 */
void *seq_addhi(seq_desc * sed, void *x)
{
	assert(sed);
	assert(x);

	array_desc *ard = sed->ard_p;
	int n = sed->len++;
	int arr_len = ard->len;
	int seq_len = sed->len;
	void *add_addr = (void *)(ard->head + arr_len % n);

	/*-----------------------------------------------------------------------------
	 *  no more space in the array, resize it 
	 *-----------------------------------------------------------------------------*/
	if (arr_len == seq_len) {
		array_resize(ard, arr_len * 2);
	}

	/*-----------------------------------------------------------------------------
	 *  care about the length, 'cause the last one
	 *  see the definition of add_addr
	 *-----------------------------------------------------------------------------*/
	memmove(add_addr, x, ard->size);
	return add_addr;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_addlo
 *  Description:  add one to the seq start
 * =====================================================================================
 */
void *seq_addlo(seq_desc * sed, void *x)
{
	assert(sed);
	assert(x);

	array_desc *ard = sed->ard_p;
	int n = sed->len++;
	int arr_len = ard->len;
	int seq_len = sed->len;
	void *add_addr;

	/*-----------------------------------------------------------------------------
	 *  no more space in the array, resize it 
	 *-----------------------------------------------------------------------------*/
	if (arr_len == seq_len) {
		array_resize(ard, arr_len * 2);
	}
	if (--sed->start < 0) {
		sed->start = ard->len - 1;
	}

	/*-----------------------------------------------------------------------------
	 *  care about the start, 'cause the 1st one
	 *-----------------------------------------------------------------------------*/
	add_addr = (void *)(ard->head + sed->start);
	memmove(add_addr, x, ard->size);
	return add_addr;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_rmhi
 *  Description:  remove one from the seq end
 * =====================================================================================
 */
void seq_rmhi(seq_desc * sed)
{
	assert(sed);
	/*-----------------------------------------------------------------------------
	 *  no need to remove explicitly,
	 *  just follow the principle -- move, recover
	 *-----------------------------------------------------------------------------*/
	sed->len--;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_rmlo
 *  Description:  remove one from the seq start
 * =====================================================================================
 */
void seq_rmlo(seq_desc * sed)
{
	assert(sed);
	array_desc *ard = sed->ard_p;
	sed->len--;
	/*-----------------------------------------------------------------------------
	 *  if sed->start == max index, 	then
	 *     sed->start == ard->len - 1,	so
	 *   ++sed->start == ard->len
	 *-----------------------------------------------------------------------------*/
	if (++sed->start == ard->len) {
		sed->start = 0;	/* 1st index */
	}
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  seq_add_list
 *  Description:  add a list simultaneously
 * =====================================================================================
 */
void seq_add_list(seq_desc * sed, void *x, ...)
{
	void *arg;
	va_list list;
	va_start(list, x);
	for (; arg; arg = va_arg(list, void *)) {	/* end with NULL */
		seq_addhi(sed, arg);
	}
	va_end(list);
}
