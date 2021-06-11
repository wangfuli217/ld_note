#include "firebert.h"
#include "plugboard.h"
#include "slist.h"
#include "event.h"
#include "par.h"
#include "util.h"
#include "pair.h"

/* per connection
 */ 
typedef struct plugc_s {
	u_int32_t src;
	u_int16_t port;
	int cfd;
	int sfd;
	struct event onc2si;
	struct event ons2ci;		
	struct event onc2so;
	struct event ons2co;       
	pwr_t *c2sbuf;
	pwr_t *s2cbuf;
	plug_t *bp;
} plugc_t;

/* for the whole plug proxy
 */
struct plug_s {
	u_int16_t lport;
	char *server;
	u_int16_t port;
	int lfd;
	slist_t *conns;
	onclient_handler onclient;
	ondata_handler onc2s;
	ondata_handler ons2c;
	void *arg;
	struct event oncon;
};

/* ------------------------------------------------------------ */

static void
_releaseclient(void **cpp, void *arg) {
	plugc_t *cp = *(plugc_t**)cpp;
	plug_t *p = cp->bp;
	slist_t *np = NULL;

	*cpp = NULL;

	for(np = p->conns; np; np = np->next) {
		if(np->data == (void*)cp)
			break;
	}
	
	if(np) {
		p->conns = slist_delete(p->conns, np);

		event_del(&(cp->onc2si));	
		event_del(&(cp->ons2ci));	
		event_del(&(cp->onc2so));	
		event_del(&(cp->ons2co));	

		pwr_release(&(cp->c2sbuf));
		pwr_release(&(cp->s2cbuf));

		close(cp->cfd);
		close(cp->sfd);	

		free(cp);		       
	} else {
		assert(0 || !"connection not in list!");
	}
}

/* ------------------------------------------------------------ */

static void
_oncflush(int fd, short code, void *arg) {
	plugc_t *cp = arg;

	if(pwr_flush(cp->c2sbuf))
		event_add(&(cp->onc2so), NULL);
}

static void
_onsflush(int fd, short code, void *arg) {
	plugc_t *cp = arg;

	if(pwr_flush(cp->s2cbuf))
		event_add(&(cp->ons2co), NULL);
}

/* ------------------------------------------------------------ */

static int _ondata(plugc_t *cp, int toserverp);

static void
_onc2s(int fd, short code, void *arg) {
	plugc_t *cp = arg;
	if(_ondata(cp, 0)) {
		event_add(&(cp->onc2si), NULL);
	} 
}

static void
_ons2c(int fd, short code, void *arg) {
	plugc_t *cp = arg;
	if(_ondata(cp, 1)) {
		event_add(&(cp->ons2ci), NULL);       	
	}
}

static int
_ondata(plugc_t *cp, int toserverp) {
	int ret = 0;
	u_char buf[1024];
	int l = 0;
	int fd = toserverp ? cp->sfd : cp->cfd;
	pwr_t *tbuf = toserverp ? cp->c2sbuf : cp->s2cbuf;
	ondata_handler h = toserverp ? cp->bp->ons2c : cp->bp->onc2s;
	struct event *e = toserverp ? &(cp->onc2so) : &(cp->ons2co);

	if((l = read(fd, buf, 1024)) > 0) {
		h(cp->src, cp->port, buf, l, cp->bp->arg);
		if(pwr_produce(tbuf, buf, l)) {
			event_add(e, NULL);
		}
		ret = 1;
	} else {
		cp->bp->onclient(cp->src, cp->port, 0, cp->bp->arg);
		_releaseclient((void**)&cp, NULL);
	}

	return(ret);
}

/* ------------------------------------------------------------ */

static void
_onserverconn(int fd, int code, void *arg) {
	plugc_t *cp = arg;

	cp->sfd = fd;
	cp->s2cbuf = pwr_new(pwr_write_wrapper, v2p(fd));

	cp->bp->onclient(cp->src, cp->port, 1, cp->bp->arg);

	event_set(&(cp->onc2si), cp->cfd, EV_READ, _onc2s, cp);
	event_set(&(cp->ons2ci), cp->sfd, EV_READ, _ons2c, cp);
	event_set(&(cp->onc2so), cp->cfd, EV_WRITE, _oncflush, cp);
	event_set(&(cp->ons2co), cp->sfd, EV_WRITE, _onsflush, cp);
	event_add(&(cp->onc2si), NULL);
	event_add(&(cp->ons2ci), NULL);
}

/* ------------------------------------------------------------ */

static void
_onconnection(int fd, short code, void *arg) {
	plug_t *p = arg;
	int cfd = 0;
	struct sockaddr_in si;
	unsigned len = sizeof(si);	       

	if((cfd = accept(fd, (struct sockaddr *) &si, &len)) >= 0) {
		plugc_t *c = calloc(1, sizeof(*c));

		c->bp = p;
		c->src = si.sin_addr.s_addr;
		c->port = ntohs(si.sin_port);
		c->cfd = cfd;
		c->c2sbuf = pwr_new(pwr_write_wrapper, v2p(c->cfd));

		setblock(c->cfd, 0);	       

		if(nbc(p->server, p->port, _onserverconn, c) < 0) {
			free(c);
			pwr_release(&(c->c2sbuf));
			close(fd);
		} else {
			p->conns = slist_push(p->conns, c);
		}
	}
	
	event_add(&(p->oncon), NULL);
}

/* ------------------------------------------------------------ */

plug_t *
plug_new(int lport, char *server, int port, onclient_handler onclient, ondata_handler c2s, ondata_handler s2c, void *arg) {
	plug_t *ret = NULL;
	int fd = 0;

	if((fd = ltcp(NULL, lport)) >= 0) {
		setblock(fd, 0);

		ret = calloc(1, sizeof(*ret));

		event_set(&(ret->oncon), fd, EV_READ, _onconnection, ret);
		event_add(&(ret->oncon), NULL);

		ret->lport = lport;
		ret->server = strdup(server);
		ret->conns = NULL;
		ret->lfd = fd;
		ret->port = port;
		ret->onclient = onclient;
		ret->onc2s = c2s;
		ret->ons2c = s2c;
		ret->arg = arg;
	}

	return ret;
}

/* ------------------------------------------------------------ */

void
plug_release(plug_t **pp) {
	plug_t *p = *pp;
	*pp = NULL;

	slist_map(p->conns, _releaseclient, NULL);
	slist_release(&(p->conns));	
	free(p->server);
	event_del(&(p->oncon));
	free(p);
}


/* ------------------------------------------------------------ */
