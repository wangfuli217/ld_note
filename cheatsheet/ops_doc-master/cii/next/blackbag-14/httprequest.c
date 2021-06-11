#include "firebert.h"
#include "httprequest.h"
#include "httputils.h"
#include "util.h"
#include "tbuf.h"
#include "slist.h"
#include "pair.h"

struct httprequest_s { 
	char *url;
	char *meth;
	int port;
	char *host;
	int soapflag;
	slist_t *headers;
	slist_t *kill;
	u_char *data;
	size_t l;
};

// ------------------------------------------------------------ 

static pair_t *
_strs(char *x, char *y) {
	return(mpair(strdup(x), strdup(y)));
}

// ------------------------------------------------------------ 

static slist_t *
_stdhdrs(void) {
	slist_t *ret = NULL;

	ret = slist_push(ret, _strs("User-Agent", "Mozilla/5.0"));
	ret = slist_push(ret, _strs("Accept", "*/*"));
	ret = slist_push(ret, _strs("Accept-Language", "en-us,en;q=0.5"));
	ret = slist_push(ret, _strs("Accept-Charset", "ISO-8859-1,utf-8;q=0.7,*;q=0.7"));
	ret = slist_push(ret, _strs("Keep-Alive", "0"));
	ret = slist_push(ret, _strs("Connection", "close"));

	return(ret);
}

/* ------------------------------------------------------------ 
 * change the value if it already exists, add it otherwise
 */

static slist_t *
_sethdr(slist_t *h, char *k, char *v) {
	slist_t *ret = h;

	if(v) {
		for(h = h; h; h = h->next) {
			pair_t *p = h->data;
			char *hk = (char*)p->key;
			if(!strcasecmp(hk, k)) {
				free(p->value);
				p->value = strdup(v);
				break;
			}
		}

		if(!h) 
			ret = slist_push(ret, mpair(strdup(k), strdup(v)));
	}

	return(ret);
}

/* ------------------------------------------------------------ 
 * add a header unless it already exists
 */

static slist_t *
_defhdr(slist_t *h, char *k, char *v) {
	slist_t *ret = h;

	if(v) {
		for(h = h; h; h = h->next) {
			pair_t *p = h->data;
			char *hk = (char*)p->key;
			if(!strcasecmp(hk, k)) {
				break;
			}
		}

		if(!h) 
			ret = slist_push(ret, mpair(strdup(k), strdup(v)));
	}

	return(ret);
}

/* ------------------------------------------------------------ 
 * strike out a header
 */

static slist_t *
_killhdr(slist_t *h, char *k) {
	slist_t *ret = h, *pv = NULL;

	for(h = h; h; pv = h, h = h->next) {
		pair_t *p = h->data;
		char *hk = (char*)p->key;
		if(!strcasecmp(hk, k)) {
			if(pv) 
				pv->next = h->next;
			else
				ret = h->next;				
			break;	
		}
	}

	return(ret);
}

/* ------------------------------------------------------------ 
 * retrieve a header
 */ 

pair_t *
_gethdr(slist_t *h, char *k) {
	pair_t *ret = NULL;

	for(h = h; h && !ret; h = h->next) {
		pair_t *p = h->data;
		char *hk = (char*)p->key;
		if(!strcasecmp(hk, k)) 
			ret = p;
	}

	return(ret);		
}

/* ------------------------------------------------------------ 
 * given known POST data, set the POST headers appropriately
 */

static slist_t *
_posthdrs(slist_t *h, void *content, size_t len) {
	slist_t *ret = h;

	ret = _defhdr(ret, "Content-Type", "application/x-www-form-urlencoded");
	ret = _defhdr(ret, "Content-Length", fmt_string("%lu", len));

	return(ret);
}

// ------------------------------------------------------------ 

httprequest_t *
httprequest_blank(void) {
	httprequest_t *ret = calloc(1, sizeof(*ret));
	ret->headers = _stdhdrs();
	return(ret);
}

// ------------------------------------------------------------ 

httprequest_t *
httprequest_new(char *url) {
	httprequest_t *ret = httprequest_blank();
	ret->url = strdup(url);
	return(ret);
}

// ------------------------------------------------------------ 

void
httprequest_url(httprequest_t *r, char *url) {
	r->url = strdup(url);
}

// ------------------------------------------------------------ 

void
httprequest_killheader(httprequest_t *r, char *key) {
	r->kill = slist_push(r->kill, strdup(key));
}

// ------------------------------------------------------------ 

void
httprequest_setheader(httprequest_t *r, char *key, char *value) {
	r->headers = _sethdr(r->headers, key, value);
}

// ------------------------------------------------------------ 

void
httprequest_defheader(httprequest_t *r, char *key, char *value) {
	r->headers = _defhdr(r->headers, key, value);
}

// ------------------------------------------------------------ 

void
httprequest_method(httprequest_t *r, char *meth) {
	r->meth = strdup(meth);       
}

// ------------------------------------------------------------ 

void
httprequest_port(httprequest_t *r, int port) {
	r->port = port;
}

// ------------------------------------------------------------ 

int
httprequest_get_port(httprequest_t *r) {
	return(r->port ? r->port : http_url2port(r->url));
}

// ------------------------------------------------------------ 

char *
httprequest_get_host(httprequest_t *r) {
	return(r->host ? r->host : http_url2host(r->url));       
}

// ------------------------------------------------------------ 

void
httprequest_soap(httprequest_t *r) {
	r->soapflag = 1;
}

// ------------------------------------------------------------ 

void
httprequest_target(httprequest_t *r, char *hostport) {	
	char *cp = strchr((hostport = strdup(hostport)), ':');
	if(cp) {
		*cp++ = 0;
		httprequest_port(r, atoi(cp));
	}

	r->host = hostport;
}

/* ------------------------------------------------------------ 
 * SOAP envelope and appropriate headers
 */

static u_char *
_soapatize(httprequest_t *r, u_char *in, size_t *l) {
	size_t pl = 0, sl = 0;
	char *prefix = 	"<SOAP-ENV:Envelope "
			"xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" "
#if 0
			"SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\r\n"
#else
			">\r\n"
#endif
			"<SOAP-ENV:Body>\r\n";

	char *suffix =  "</SOAP-ENV:Body>\r\n"
			"</SOAP-ENV:Envelope>\r\n";

	u_char *ret = malloc(*l + (pl = strlen(prefix)) + (sl = strlen(suffix)) + 40);
	memcpy(ret, prefix, pl);
	memcpy(&ret[pl], in, *l);
	memcpy(&ret[pl + *l], suffix, sl);

	*l += (pl + sl);

	r->headers = _defhdr(r->headers, "SOAPAction", "");
	r->headers = _sethdr(r->headers, "Content-Type", "text/xml");

	return(ret);
}

// ------------------------------------------------------------ 

u_char *
httprequest_marshall(httprequest_t *r, size_t *l) {
	slist_t *kp = NULL;
	char *meth = r->meth ? r->meth : http_url2meth(r->url);	
	char buf[65535];
	tbuf_t b, *bp = &b;
	u_char *data = NULL;
	size_t dl = 0;		

	if(!strcasecmp(meth, "soap")) {
       		meth = "POST";
		r->soapflag = 1;
	}

	r->headers = _defhdr(r->headers, "Host", httprequest_get_host(r));

	if(!strcasecmp(meth, "post")) {
		if(r->data) {
			data = r->data;
			dl = r->l;
		}

		if(r->soapflag) 
			data = _soapatize(r, data, &dl);

		r->headers = _posthdrs(r->headers, data, dl);
	}

	for(kp = r->kill; kp; kp = kp->next) {
		char *k = kp->data;
		r->headers = _killhdr(r->headers, k);
	}

	fmt_sfmt(buf, sizeof buf, "%s %s HTTP/1.1\r\n", meth, http_url2query(r->url));

	tbuf_init(bp, (u_char*)buf, strlen(buf));

	for(kp = r->headers; kp; kp = kp->next) {
		pair_t *p = kp->data;	
		fmt_sfmt(buf, sizeof buf, "%s: %s\r\n", p->key, p->value);
		tbuf_cat(bp, (u_char*)buf, strlen(buf));
	}

	tbuf_cat(bp, (u_char*) "\r\n", 2);

	if(data) {
		tbuf_cat(bp, data, dl);
	}

	if(r->soapflag)
		free(data);

	return(tbuf_data(bp, l));
}

// ------------------------------------------------------------ 

void		
httprequest_content(httprequest_t *r, u_char *data, size_t l) {
	r->l = l;
	r->data = bufdup(data, r->l);
}

// ------------------------------------------------------------ 

void
httprequest_release(httprequest_t **tp) {
	slist_t *np = NULL;
	httprequest_t *t = *tp;
	*tp = NULL;
	
	free(t->url);
	free(t->meth);
	free(t->host);
	
	for(np = t->headers; np; np = np->next) {
		pair_t *p = np->data;
		free(p->key);
		free(p->value);
		free(p);
	}
	
	slist_release(&(t->headers));

	for(np = t->kill; np; np = np->next)
		free(np->data);

	slist_release(&(t->kill));

	free(t->data);

	free(t);
}

// ------------------------------------------------------------ 

int
httprequest_needcontent(httprequest_t *r) {
	if(r->data)
		return(0);
	else {
		char *meth = r->meth ? r->meth : http_url2meth(r->url);	
		if(!strcasecmp(meth, "get"))
			return(0);
	}

	return(1);	
}
