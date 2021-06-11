#ifndef PLUGBOARD_INCLUDED
#define PLUGBOARD_INCLUDED

/* An evented plugboard proxy. Provide a callback for the TCP data from 
 * the client, and one for data from the server.
 */

/* Hook client conn/disco ("openp" is nonzero on new connections)
 */ 
typedef void (*onclient_handler)(u_int32_t ip, u_int16_t port, int openp, void *arg);

/* Hook data from (s)erver 2 (c)lient or c2s
 */
typedef size_t (*ondata_handler)(u_int32_t ip, u_int16_t port, u_char *data, size_t len, void *arg);

typedef struct plug_s plug_t;

/* Bind "localport", and plug incoming connections in to new connections
 * to "server:port", with the specified hooks (none can be NULL).
 *
 * Make as many plug_t's as you want. This should scale reasonably.
 */
plug_t * 	plug_new(int localport, char *server, int port, onclient_handler onclient, ondata_handler c2s, ondata_handler s2c, void *arg);

/* undo all of this
 */
void		plug_release(plug_t **pp);

#endif
