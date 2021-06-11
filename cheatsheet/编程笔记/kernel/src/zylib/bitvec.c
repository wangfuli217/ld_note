/*
 * =====================================================================================
 *
 *       Filename:  bitvec.c
 *
 *    Description:  regard 32 bits(unsigned int) as a unit
 *
 * 		    the reason why use ssize_t instead of size_t
 * 		    see 
 * 		    bitvec_first_set() & bitvec_first_unset()
 *
 *        Version:  1.0
 *        Created:  10.03.10
 *       Revision:  
 *       Compiler:  GCC 4.4.3
 *
 *         Author:  Yang Zhang, imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include	<assert.h>
#include	<unistd.h>

#include	<zy/alloc.h>

#define		BITVEC_IMP_ZY
#include	<zy/bitvec.h>

/*-----------------------------------------------------------------------------
 *  NOTICE:
 *  unit is u32, not byte
 *-----------------------------------------------------------------------------*/
#define		U32_NEED(n)		(((n) - 1 + 32) >> 5)
#define		BIT_INDEX(n)		((n) >> 5)
#define		BIT_OFFSET(n)		((n) % 32)

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  bitvec_create
 *  Description:  calloc, with U32_NEED(num) * sizeof(unsigned)
 * =====================================================================================
 */
unsigned *bitvec_create(ssize_t num)
{
	assert(num > 0);
	unsigned *bitvec;
	return bitvec = (unsigned *)CALLOC(sizeof(unsigned), U32_NEED(num));
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  bitvec_free
 *  Description:  free a pointer which points to the unsigned array
 * =====================================================================================
 */
void bitvec_free(unsigned *bitvec)
{
	assert(bitvec);
	FREE(bitvec);
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  bitvec_first_set
 *  Description:  find the first set bit in the queue
 *
 *  		  NOTICE:
 *  		  return 0 ~ (end - 1), not 1 ~ end
 *  		  i.e. return the index in the wanted array, not the NO.
 * =====================================================================================
 */
ssize_t bitvec_first_set(unsigned *bitvec, ssize_t max)
{
	assert(bitvec);
	unsigned test;
	for (int i = 0; i < max; i++) {
		/*-----------------------------------------------------------------------------
		 *  32 bits are all 0, so next loop
		 *-----------------------------------------------------------------------------*/
		if (!(test = bitvec[i])) {
			continue;
		}
		for (int j = 0; j < 32; j += 1) {
			if ((test >> j) & 1) {
				return i << 5 + j;	/* the index */
			}
		}
	}
	/*-----------------------------------------------------------------------------
	 *  that's why use ssize_t instead of size_t
	 *-----------------------------------------------------------------------------*/
	return -1;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  bitvec_first_unset
 *  Description:  find the first unset bit in the queue
 *
 *  		  NOTICE:
 *  		  return 0 ~ (end - 1), not 1 ~ end
 *  		  i.e. return the index in the wanted array, not the NO.
 * =====================================================================================
 */
ssize_t bitvec_first_unset(unsigned *bitvec, ssize_t max)
{
	assert(bitvec);
	unsigned test;
	for (int i = 0; i < max; i++) {
		test = bitvec[i];
		for (int j = 0; j < 32; j += 1) {
			if (~(test >> j) & 1) {	/* NOTICE: ~ */
				return i << 5 + j;	/* the index */
			}
		}
	}
	/*-----------------------------------------------------------------------------
	 *  that's why use ssize_t instead of size_t
	 *-----------------------------------------------------------------------------*/
	return -1;
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  bitvec_set
 *  Description:  set a certain bit
 *
 *  		  NOTICE:
 *  		  parameter index is 0 ~ (end - 1), not 1 ~ end
 *  		  i.e. the index in the wanted array, not the NO.
 * =====================================================================================
 */
void bitvec_set(unsigned *bitvec, ssize_t index)
{
	assert(bitvec);
	/*-----------------------------------------------------------------------------
	 *  >= not >
	 *  frame index may be 0
	 *-----------------------------------------------------------------------------*/
	assert(index > 0);
	unsigned target = bitvec[BIT_INDEX(index)];
	target |= (1 << BIT_OFFSET(index));
}

/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  bitvec_unset
 *  Description:  unset a certain bit
 *
 *  		  NOTICE:
 *  		  parameter index is 0 ~ (end - 1), not 1 ~ end
 *  		  i.e. the index in the wanted array, not the NO.
 * =====================================================================================
 */
void bitvec_unset(unsigned *bitvec, ssize_t index)
{
	assert(bitvec);
	/*-----------------------------------------------------------------------------
	 *  >= not >
	 *  frame index may be 0
	 *-----------------------------------------------------------------------------*/
	assert(index > 0);
	unsigned target = bitvec[BIT_INDEX(index)];
	target &= (0 << BIT_OFFSET(index));
}
