#ifndef HTTPUTILS_INCLUDED
#define HTTPUTILS_INCLUDED

#include "arena.h"
#include "slist.h"

/* HTTP processing code that is independent of usage (decode, httpcat, etc)
 */

typedef struct http_arg_s {
	char *key;
	u_char *value;
	size_t len;
} http_arg_t;

/* return an arena-allocated slist of http_arg_t from bounded bp:ep
 */
slist_t *	http_parse_args(arena_t *a, char *bp, char *ep);

/* in-place dehexify
 */
size_t		http_dehexify(u_char *inout);

/* extract host from URL
 */
char *		http_url2host(char *url);

/* extract port from URL
 */
int		http_url2port(char *url);

/* extract method from URL
 */
char *		http_url2meth(char *url);

/* directories, filenames, and query args from URL
 */ 
char *		http_url2query(char *url);

/* ------------------------------------------------------------ */

/* process a stream of requests, calling back for each parsed request,
 * handling Content-Length
 */
typedef struct http_meta_s {
	u_char *content;
} http_meta_t;

typedef void (*http_request_handler)(u_char *start, u_char *end, void *arg);

size_t 		http_process_stream(u_char *input, u_char *ep, http_request_handler h, void *arg);

#endif
