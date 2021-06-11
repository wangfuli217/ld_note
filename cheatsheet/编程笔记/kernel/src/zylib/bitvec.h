/*
 * =====================================================================================
 *
 *       Filename:  bitvec.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  10.03.10 21:48
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		BITVEC_H_ZY
#define		BITVEC_H_ZY

/*-----------------------------------------------------------------------------
 *  bitvec.c includes bitvec.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		BITVEC_IMP_ZY
#define		extern			extern
#else
#define		extern		
#endif

extern unsigned *bitvec_create(ssize_t);
extern void bitvec_free(unsigned *);
extern ssize_t bitvec_first_set(unsigned *, ssize_t);
extern ssize_t bitvec_first_unset(unsigned *, ssize_t);
extern void bitvec_set(unsigned *, ssize_t);
extern void bitvec_unset(unsigned *, ssize_t);

#endif
