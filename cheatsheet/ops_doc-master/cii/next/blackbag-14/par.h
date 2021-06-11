#ifndef PARREAD_INCLUDED
#define PARREAD_INCLUDED

/* Partial-read/Partial-write wrappers for IO functions
 * 
 */ 

typedef struct prd_s prd_t;

/* wrap read() or recv(), with an fd typically tucked into "arg"
 */
typedef size_t  (*prd_reader)(u_char *bp, size_t l, void *arg);

/* given a buffer, determine if we have a complete read-op. For 
 * example, pull ip->len out of "bp" and check it against "l" arg.
 * return nonzero (and set "lp") if complete packet exists.
 */
typedef int     (*prd_recognizer)(u_char *bp, size_t l, size_t *lp);

/* do something with a completed read-op
 */
typedef void    (*prd_consumer)(u_char *msg, size_t l, void *arg);

/* create a new reader-wrapper
 */
prd_t *	prd_new(prd_reader h, void *arg);

/* like pcap_dispatch, feed as many read-ops as possible to consumer,
 * validating with "r" argument, passing "arg" to consumer.
 */
int	prd_consume(prd_t *p, prd_recognizer r, prd_consumer h, void *arg);

/* free up a read-wrapper 
 */
void	prd_release(prd_t **pp);

/* for readops that are just "u32 len, buf..."
 */
int	prd_recognize_netbuf(u_char *bp, size_t l, size_t *lp);

/* wrap read/recv, wants v2p(fd) as "arg"
 */
size_t  prd_read_wrapper(u_char *bp, size_t l, void *arg);
size_t  prd_recv_wrapper(u_char *bp, size_t l, void *arg);

typedef struct pwr_s pwr_t;

/* wrap send() or write(), with fd tucked into "arg" (or something else)
 */
typedef size_t  (*pwr_writer)(u_char *bp, size_t l, void *arg);

/* get a new one
 */
pwr_t * pwr_new(pwr_writer h, void *arg);

/* try to write "buf" (through writer given to pwr_new); if the write
 * is partial, save what's left and return nonzero as an indication to
 * call again to finish the write. Jam as many writeops as you want through
 * this function; it should queue properly. 
 */
int	pwr_produce(pwr_t *p, u_char *buf, size_t l);

/* flush out any queued data (behaves just like "produce", without
 * needing new data);
 */
int	pwr_flush(pwr_t *p);

/* free it up
 */
void	pwr_release(pwr_t **pp);

/* wrap write/send, wants v2p(fd) as "arg"
 */
size_t  pwr_write_wrapper(u_char *bp, size_t l, void *arg);
size_t  pwr_send_wrapper(u_char *bp, size_t l, void *arg);

#endif
