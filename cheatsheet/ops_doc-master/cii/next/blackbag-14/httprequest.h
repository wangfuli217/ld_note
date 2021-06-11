#ifndef HTTPREQUEST_INCLUDED
#define HTTPREQUEST_INCLUDED

/* marshall a complete HTTP request with valid headers. If your URLs are
 * simple and complete, you can use nothing more than _new() and _marshall().
 *
 * makes internal copies of all data and strings passed.
 *
 * this is basically the librarization of httpcat.
 */

typedef struct httprequest_s httprequest_t;

#undef 			T
#define			T		      	httprequest_t

T *		httprequest_new(char *url);

/* if you need to fill in headers and fields before knowing the
 * the URL --- but _do not_ forget to fill in the URL later! ie, for getopt()
 */
T *		httprequest_blank(void);
void		httprequest_url(T *r, char *url);


/* the following methods can be sensed from the URL
 */
void		httprequest_method(T *r, char *method); 
void		httprequest_target(T *r, char *hostport); 
void		httprequest_port(T *r, int port); 

/* create standard SOAP envelope around request
 */
void		httprequest_soap(T *r);

/* to allow requests to dispatch 
 */ 
int		httprequest_get_port(T *r); 
char * 		httprequest_get_host(T *r); 
int		httprequest_needcontent(T *r);

/* sane defaults are provided if none are set
 */
void		httprequest_setheader(T *r, char *key, char *value); 
void		httprequest_defheader(T *r, char *key, char *value); 
void		httprequest_killheader(T *r, char *key); 

/* for POST URLs
 */ 
void		httprequest_content(T *r, u_char *content, size_t len); 

/* the output of this module:
 */
u_char *	httprequest_marshall(T *r, size_t *l); 

void		httprequest_release(T **rp);

#undef 			T
#endif
