#include "firebert.h"
#include "httputils.h"
#include "util.h"
#include "arena.h"
#include "slist.h"

/* ------------------------------------------------------------ */

/* bounded string to arena-allocated strz
 */ 
static char *
_anult(arena_t *a, char *sp, char *ep) {
	size_t l = (size_t)(ep - sp);
	char *ret = arena_alloc(a, l + 1);
	memcpy(ret, sp, l);
	ret[l] = 0;
	return(ret);
}

/* ------------------------------------------------------------ */

/* in-place dehexify, returning resulting length
 */
size_t 
_dehex(u_char *in, size_t l) {
	u_char *cp = in, *wp = cp;

	while(cp < &in[l]) {
		if(*cp == '%' && &cp[2] < &in[l]) {
			char hc[3];
			hc[0] = cp[1];
			hc[1] = cp[2];
			hc[2] = 0;
			dehexify(hc, wp);
			wp++;		       
			cp += 3;
		} else {
			*wp++ = *cp++;
		}
	}

	return((size_t)(wp - in));
}

/* ------------------------------------------------------------ */

size_t
http_dehexify(u_char *inout) {
	return(_dehex(inout, strlen((char*)inout)));
}

/* ------------------------------------------------------------ */

slist_t *
http_parse_args(arena_t *a, char *bp, char *ep) {
	slist_t *ret = NULL;
	char *ap = NULL;

	if((ap = strchrs(bp, "?&")) && ap < ep) {
		ap += 1;

       		while(ap < ep) {
			char *xp = NULL, *endp = ((xp = strchrs(ap, "?&")) ? xp : ep); 
			char *eqp = strchr(ap, '=');
			if(eqp && &eqp[1] < endp) {
				http_arg_t *at = arena_alloc(a, sizeof(*at));
				size_t vl = 0;

				at->key = _anult(a, ap, eqp);
				at->value = arena_bufdup(a, (u_char*) &eqp[1], (vl = ((size_t)(endp - &eqp[1]))) + 1);
				at->value[vl] = 0;
				at->len = _dehex(at->value, vl);

				ret = tslist_push(a, ret, at);
			}

			ap = endp + 1;
		}
	}
	
	return(ret);
}

/* ------------------------------------------------------------ */

size_t
http_process_stream(u_char *input, u_char *ep, http_request_handler h, void *arg) {
	size_t ret = 0;
	u_char *cp = input;

	while(cp < ep) {
		http_meta_t m;
		size_t bl = 4;

		u_char *bounds = memstrb(cp, ep, (u_char*)"\r\n\r\n", bl);
		if(!bounds) bounds = memstrb(cp, ep, (u_char*)"\n\n", (bl = 2));

		zero(&m);	

		if(bounds) {
			u_char clhs[] = "\nContent-Length";
			u_char *clh = memstrb(cp, bounds, (u_char*) clhs, sizeof clhs - 1);
			if(clh) {
				if(&clh[sizeof clhs + 1] < bounds) {
					int v = 0;
					size_t cl = atoulv((char*) &clh[sizeof clhs + 1], &v);

					if(!v || (bounds = (bounds + cl)) >= ep) 
						break;
				}
			} 

			h(cp, bounds, arg);
			cp = &bounds[bl];
		} else break;
	}

	ret = (size_t)(cp - input);

	return(ret);
}

// ------------------------------------------------------------ 

char *		
http_url2host(char *url) {
	char *cp = NULL, *ep = NULL;

	if((cp = strcasestr(url, "://"))) {
		cp += 3;
	} else {
		cp = url;
	}

	if(!(ep = strchrs(cp, ":/")))
		ep = &cp[strlen(cp)];

	return(nult(cp, ep));	
}

// ------------------------------------------------------------ 

int
http_url2port(char *url) {
	int port = 80;
	char *cp = NULL, *ep = NULL;

	if((cp = strcasestr(url, "://"))) 
		cp += 3;
	else 
		cp = url;

	if((ep = strchrp(cp, ':', '/'))) {
		cp = ep + 1;
		while(*ep && *ep != '/') ep++;
		port = strtoul(nult(cp, ep), NULL, 0);
	}

	return(port);
}

// ------------------------------------------------------------ 

char *
http_url2meth(char *url) {
	char *cp = strchrp(url, ':', '/');
	char *ret = NULL;

	if(cp) {
		ret = nult(url, cp);
		if(!strcasecmp(ret, "http") || !strcasecmp(ret, "https"))
			ret = "GET";
	} else
		ret = "GET";

	for(cp = ret; *cp; cp++)
		if(islower(*cp)) // don't step on bss
			*cp = toupper(*cp);

	return(ret);
}

// ------------------------------------------------------------ 

char *
http_url2query(char *url) {
	char *cp = NULL;

	if((cp = strcasestr(url, "://"))) 
		cp += 3;
	else 
		cp = url;

	return(strchr(cp, '/'));
}

