#include "firebert.h"
#include "hash.h"
#include "util.h"
#include "jenkins-hash/hashtab.h"

/* ------------------------------------------------------------ */

static int 
_l2(unsigned int n) {
    int log2 = 0;

    if (n & (n-1))
	log2++;
    if (n >> 16)
	log2 += 16, n >>= 16;
    if (n >> 8)
	log2 += 8, n >>= 8;
    if (n >> 4)
	log2 += 4, n >>= 4;
    if (n >> 2)
	log2 += 2, n >>= 2;
    if (n >> 1)
	log2++;
    return log2;
}

/* ------------------------------------------------------------ */

struct hash_s {
	htab *h;
};

/* ------------------------------------------------------------ */

hash_t *
hash_new(size_t init) {
	hash_t *h = malloc(sizeof(*h));
	h->h = hcreate((int) _l2(init)); /* wow jenkins is a jackass */				       
	return(h);
}

/* ------------------------------------------------------------ */

void
hash_release(hash_t **hp) {
	hash_t *h = *hp;
	*hp = NULL;

	hdestroy(h->h);
	free(h);
}

/* ------------------------------------------------------------ */

void *
hash_get(hash_t *h, void *key, size_t l) {
	if(hfind(h->h, ((u_char*)key), l)) {
		return(hstuff(h->h));
	}

	return(NULL);
}

/* ------------------------------------------------------------ */

void *
hash_put(hash_t *h, void *key, size_t l, void *data) {
	void *ret = NULL;

	if(!hadd(h->h, ((u_char *)key), l, data)) {
		ret = hstuff(h->h);
		// XXX: free(hkey(h->h))
       		hdel(h->h);
		hadd(h->h, ((u_char *)key), l, data);
	}

	return(ret);
}

/* ------------------------------------------------------------ */

size_t
hash_count(hash_t *h) {
	return(hcount(h->h));
}

/* ------------------------------------------------------------ */

pair_t
hash_delete(hash_t *h, void *key, size_t l) {
	pair_t p = { NULL, NULL };

	if(hfind(h->h, ((u_char *)key), l)) {
		p.key = hkey(h->h);
		p.value = hstuff(h->h);

		hdel(h->h);
	}

	return(p);
}

/* ------------------------------------------------------------ */

void 
hash_clear(hash_t *h) {
	if(hfirst(h->h)) do {
		/*PASS*/;
	} while(hdel(h->h));
}

/* ------------------------------------------------------------ */

void 
hash_map(hash_t *h, void apply(const void *key, size_t l, void **val, void *cl), void *cl) {
	if(hfirst(h->h)) do {
		apply(hkey(h->h), hkeyl(h->h), &(hstuff(h->h)), cl);
	} while(hnext(h->h));
}

