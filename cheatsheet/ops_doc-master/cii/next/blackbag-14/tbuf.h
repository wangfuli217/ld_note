#ifndef TBUF_INCLUDED
#define TBUF_INCLUDED

#include <stdarg.h>
#include "pair.h"

/* a cheaper variant of mfile --- doesn't ring, can't remove data, doesn't
 * provide file abstraction, but is reasonably efficient. Use for 
 * "printf to a buffer" situations
 */

typedef struct tbuf_s { 
	u_char *bp;
	u_char *tp;
	u_char *ep;
} tbuf_t;

/* create a new tbuf
 */ 
tbuf_t *	tbuf_new(u_char *data /* or NULL */, size_t len);

/* convenience for when you don't have any data to start with
 */
tbuf_t *	tbuf_empty(void);

/* use a tbuf on the stack --- careful not to call _raw or _release!
 */ 
tbuf_t *	tbuf_init(tbuf_t *r, u_char *data /* or NULL */, size_t len);

/* add more data to it
 */ 
void		tbuf_cat(tbuf_t *r, u_char *data, size_t len);

/* clear out all the data to reuse it
 */
void		tbuf_reset(tbuf_t *r);

/* get a handle to the underlying data
 */
u_char *	tbuf_data(tbuf_t *r, size_t *l);

/* how much data is in the tbuf?
 */
size_t		tbuf_length(tbuf_t *r);

/* cat a string to the buf
 */
void		tbuf_cats(tbuf_t *t, char *str);

/* get the tbuf as an iovec
 */
iopair_t 	tbuf_get(tbuf_t *t);

/* compute SHA1 of the tbuf
 */
void		tbuf_hash(tbuf_t *t, u_char *out/*20*/);

/* tack another tbuf on
 */
void		tbuf_add(tbuf_t *t, tbuf_t *other);

/* free the metadata, keep the raw data
 */
u_char*		tbuf_raw(tbuf_t **rp, size_t *l); 

/* printf into a tbuf, which you could also do with fmt_build
 */
void		tbuf_catp(tbuf_t *t, char *fmt, ...);

/* get rid of the tbuf
 */
void		tbuf_release(tbuf_t **rp);

#endif
