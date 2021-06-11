/*
 * =====================================================================================
 *
 *       Filename:  sequence.h
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  04.03.10 23:36
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Yang Zhang (ZY), imyeyeslove@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#ifndef		ZY_SEQUENCE_H
#define		ZY_SEQUENCE_H

/*-----------------------------------------------------------------------------
 *  sequence.c includes sequence.h, so no "extern"
 *-----------------------------------------------------------------------------*/
#ifndef		ZY_SEQUENCE_IMPLEMENTATION
#define		EXTERN			extern
#else
#define		EXTERN		
#endif

/*-----------------------------------------------------------------------------
 *  i.e.:
 *	arr-size
 *	arr-len
 *	arr-*head
 *	len
 *	start
 *-----------------------------------------------------------------------------*/
struct seq_desc {
	array_desc *ard_p;
	int len;
	int start;                                              /* index, 0 ~ len-1 */
};
typedef struct seq_desc seq_desc;



EXTERN seq_desc *seq_create(size_t, int, int);
EXTERN seq_desc *seq_attach_array(array_desc *, int, int);
EXTERN void seq_free(seq_desc *);

EXTERN int seq_len(seq_desc *);
EXTERN int seq_start(seq_desc *);

EXTERN void *seq_get_elem(seq_desc *, int);
EXTERN void *seq_substitute_elem(seq_desc *, int, void *);
EXTERN void *seq_addhi(seq_desc *, void *);
EXTERN void *seq_addlo(seq_desc *, void *);
EXTERN void seq_rmhi(seq_desc *);
EXTERN void seq_rmlo(seq_desc *);
EXTERN void seq_add_list(seq_desc *, void *, ...);

#endif
