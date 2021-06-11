/* $Id: aguri.c,v 1.3 2005/06/23 20:09:11 tqbf Exp $ */
/*
 * Copyright (C) 2001-2003 WIDE Project.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the project nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE PROJECT AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */


#include "firebert.h"
#include "aguri.h"
#include "queue.h"
#include "pair.h"

#define	MAX_KEYBYTES	16
#define	MAX_KEYBITS	(MAX_KEYBYTES * 8)

typedef struct tree_node {
	struct	tree_node *tn_parent;		/* parent node */
	struct	tree_node *tn_left;		/* left child node */
	struct	tree_node *tn_right;		/* right child node */
	aguri_t *tn_tree;			/* back pointer to tree head */
	TAILQ_ENTRY(tree_node) tn_chain;	/* the LRU list entry */
	
	size_t	tn_prefixlen;			/* prefix length of the key */
	u_char	tn_key[MAX_KEYBYTES];		/* key value */

	u_char		tn_intree;
	short		tn_depth;		/* set in tree_walk */
	u_int64_t	tn_count;
} anode_t;

/* ------------------------------------------------------------ */

struct  aguri_s {
	struct	tree_node *tr_top;		/* top node of the tree */
	size_t	tr_keylen;			/* key size in bits */
	u_int	tr_nfree;			/* free node count */

	u_int64_t	tr_count;

	TAILQ_HEAD(_lru, tree_node)	tr_lru;	/* LRU list */
};

/* ------------------------------------------------------------ */

typedef int (*node_walker)(anode_t *, void *);

void aguri_print(aguri_t *tp);
static int _preorder(anode_t *top, node_walker func, void *arg);
static int _postorder(anode_t *top, node_walker func, void *arg);

static void _free(aguri_t *tp, anode_t *leaf);
static anode_t *_find(aguri_t *tp, const void *key, size_t len);
static void _reduce(aguri_t *tp, anode_t *np, int depth);
static int _agg(anode_t *np, void *arg);

/*
 * radix (or patricia) tree implementation for aguri
 */
		
static unsigned char bitpos[8] =
		{ 0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01 };

static unsigned char prefixmask[8] =
	{ 0x00, 0x80, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc, 0xfe };

static void
_set(void *p, size_t pos) {
	unsigned char *cp = p;
	size_t off = (pos - 1) / 8;

	cp[off] |= bitpos[(pos - 1) & 7];
}

/* ------------------------------------------------------------ */

static void
_kprint(u_char *key, size_t len, size_t prefixlen) {
	int i;

	printf("0x");
	for (i=0; i<len/8; i++)
		printf("%02x", key[i]);
	printf("/%u", (u_int)prefixlen);
}

/* ------------------------------------------------------------ */

static int
_nprint(anode_t *np, void *arg) {
	int i;

	for (i=0; i<np->tn_depth; i++)
		printf(" ");
	_kprint(np->tn_key, np->tn_tree->tr_keylen, np->tn_prefixlen);
	printf(": %llu (%.2f%%)\n",
	       np->tn_count,
	       (double)np->tn_count/np->tn_tree->tr_count*100);
	return(0);
}

/* ------------------------------------------------------------ */

static int
_isset(const void *p, size_t pos) {
	const unsigned char *cp = p;
	size_t off = (pos - 1) / 8;

	return (cp[off] & bitpos[(pos - 1) & 7]);
}

/* ------------------------------------------------------------ */

/*
 * extract a common prefix from p1 and p2 to p3, return the common prefixlen
 */
static size_t
_common(const void *p1, const void *p2, size_t len, void *p3) {
	const unsigned char 	*c1 = p1, 
				*c2 = p2, 
				*end = NULL;
	unsigned char 		val = 0, 
				*c3 = p3;
	size_t 			bytes = len / 8, 
				bits = len & 7, 
				n = 0;

	end = p3 + ((len + 7) / 8);

	while (bytes-- != 0) {
		if (*c1 != *c2) {
			bits = 7; /* at most 7 bits can be common */
			break;
		}
		*c3++ = *c1++;
		c2++;
		n += 8;
	}
	if (bits != 0) {
		val = *c1 ^ *c2;
		do {
			if (val & 0x80)
				break;
			n++;
			val <<= 1;
		} while (--bits != 0);
		*c3++ = *c1 & prefixmask[n & 7];
	}
	/* clear the remaining bytes */
	while (c3 < end)
		*c3++ = 0;
	return (n);
}

/* ------------------------------------------------------------ */

static void _nreset(anode_t *np) {
	np->tn_parent = np->tn_left = np->tn_right = NULL;
	np->tn_count = 0;
	np->tn_prefixlen = 0;
}

/* ------------------------------------------------------------ */

static int _nresetcount(anode_t *np, void *arg) {
	np->tn_count = 0;
	return(0);	       
}

/* ------------------------------------------------------------ */

static int _nsum(anode_t *np, void *arg) {
	u_int64_t *p = arg;
	*p += np->tn_count;
	return(0);
}

/* ------------------------------------------------------------ */

/*
 * compare prefixes of p1 and p2
 */
static int
_cmp(const void *p1, const void *p2, size_t len) {
	const unsigned char *c1 = p1, *c2 = p2;
	unsigned char mask = 0;
	size_t bytes = len / 8, bits = len & 7;

	if(!len)
		return (0);

	while (bytes-- != 0)
		if (*c1++ != *c2++)
			return (*--c1 - *--c2);

	if ((mask = prefixmask[bits]) == 0)
		return (0);

	return ((*c1 & mask) - (*c2 & mask));
}

/* ------------------------------------------------------------ */

/*
 * initialize a tree.
 * the lru list contains free nodes and leaf nodes, but not internal nodes.
 */
aguri_t *
aguri_new(size_t keylen, size_t maxnodes) {
	aguri_t *tp = calloc(1, sizeof(*tp));
	anode_t *np = NULL;
	int i = 0;

	tp->tr_keylen = keylen;
	TAILQ_INIT(&tp->tr_lru);

	for (i = 0; i < maxnodes; i++) {
		np = malloc(sizeof(*np));
		TAILQ_INSERT_TAIL(&tp->tr_lru, np, tn_chain);
		_nreset(np);
		np->tn_tree = tp;
		np->tn_intree = 0;
		tp->tr_nfree++;
	}

	/* allocate the top node */
	np = TAILQ_FIRST(&tp->tr_lru);
	_nreset(np);
	memset(&np->tn_key, 0, sizeof(np->tn_key));
	np->tn_prefixlen = 0;
	tp->tr_top = np;
	np->tn_intree = 1;
	tp->tr_nfree--;
	TAILQ_REMOVE(&tp->tr_lru, np, tn_chain);
	return(tp);
}

/* ------------------------------------------------------------ */

void
aguri_release(aguri_t **tpp) {
	aguri_t *tp = *tpp;	
	anode_t *np = NULL;

	*tpp = NULL;

	/* first, remove nodes from the tree */
	if (tp->tr_top->tn_left != NULL)
		_reduce(tp, tp->tr_top, 0);

	/*
	 * at this point, only top is remaining in the tree,
	 * and all nodes are in the LRU list.
	 */
	assert(tp->tr_top->tn_left == NULL && tp->tr_top->tn_right == NULL);
	while ((np = TAILQ_FIRST(&tp->tr_lru)) != NULL) {
		TAILQ_REMOVE(&tp->tr_lru, np, tn_chain);
		free(np);
	}

	free(tp);
}

/* ------------------------------------------------------------ */

static int 
_adapter(anode_t *n, void *arg) {
	pair_t *p = arg;
	aguri_walker f = p->key;
	return f(n->tn_prefixlen, n->tn_key, n->tn_count, n->tn_depth, p->value);       
}

/* ------------------------------------------------------------ */

/*
 * preorder tree walk
 */
int aguri_walk(aguri_t *tp, aguri_walker func, void *arg) {
	pair_t p = pair(func, arg);
	return _preorder(tp->tr_top, _adapter, &p);
}

/* ------------------------------------------------------------ */

void
aguri_reset(aguri_t *tp) {
	_preorder(tp->tr_top, _nresetcount, 0);
	tp->tr_count = 0;
}

/* ------------------------------------------------------------ */

void
aguri_aggregate(aguri_t *tp, u_int64_t thresh) {
	_postorder(tp->tr_top, _agg, (void *)&thresh);
}

/* ------------------------------------------------------------ */

void
aguri_print(aguri_t *tp) {
	_preorder(tp->tr_top, _nprint, 0);
}

/* ------------------------------------------------------------ */

static int
_preorder(anode_t *top, node_walker func, void *arg) {
	anode_t *np = top;
	int error = 0, depth = 0;

	while (1) {
		np->tn_depth = depth;
		if ((error = (*func)(np, arg)) != 0)
			return (error);

		if (np->tn_left != NULL) {
			np = np->tn_left;
			depth++;
		} else {
			while (np != top &&
			       np == np->tn_parent->tn_right) {
				np = np->tn_parent;
				depth--;
			}
			if (np == top)
				break;
			np = np->tn_parent->tn_right;
		}
	}
	return (0);
}

/* ------------------------------------------------------------ */

static int
_postorder(anode_t *top, node_walker func, void *arg) { 
	anode_t *np = top;
	int error = 0, depth = 0;

	while (np->tn_left) {
		np = np->tn_left;
		depth++;
	}
	while (1) {
		np->tn_depth = depth;
		if ((error = (*func)(np, arg)) != 0)
			return (error);

		if (np == top)
			break;

		/*
		 * move on to the next node
		 */
		if (np == np->tn_parent->tn_right) {
			/* at right child, go up */
			np = np->tn_parent;
			depth--;
		} else {
			/*
			 * at left child. move to its sibling, then
			 * go down to the left most child.
			 */
			np = np->tn_parent->tn_right;
			while (np->tn_left != NULL) {
				np = np->tn_left;
				depth++;
			}
		}
	}
	return (0);
}

/* ------------------------------------------------------------ */

static u_int64_t _subsum(anode_t *np) {
	u_int64_t cnt = 0;
	_preorder(np, _nsum, &cnt);
	return (cnt);
}

/* ------------------------------------------------------------ */

/*
 * reduce a subtree into a single leaf node
 */
static void
_reduce(aguri_t *tp, anode_t *np, int depth) {
	if (depth > 0) {
		/* nodes to be deleted */
		if (np->tn_left == NULL) {
			/* leaf node */
			assert(np->tn_right == NULL);
			TAILQ_REMOVE(&tp->tr_lru, np, tn_chain);
		} else {
			/* internal node */
			assert(np->tn_right != NULL);
			_reduce(tp, np->tn_left, depth + 1);
			_reduce(tp, np->tn_right, depth + 1);
		}

		np->tn_parent->tn_count += np->tn_count;
		if (np->tn_parent->tn_left == np)
			np->tn_parent->tn_left = NULL;
		else
			np->tn_parent->tn_right = NULL;
		np->tn_intree = 0;
		TAILQ_INSERT_TAIL(&tp->tr_lru, np, tn_chain);
		tp->tr_nfree++;
		return;
	}

	/* remaining node, converted from an internal node to a leaf */
	assert(np->tn_left != NULL && np->tn_right != NULL);
	_reduce(tp, np->tn_left, depth + 1);
	_reduce(tp, np->tn_right, depth + 1);
	assert(np->tn_left == NULL && np->tn_right == NULL);
	TAILQ_INSERT_HEAD(&tp->tr_lru, np, tn_chain);
}

/* ------------------------------------------------------------ */

/*
 * creat a leaf node and its branch point.
 * then, insert the branch point as the parent of the specified node.
 */
static anode_t *
_alloc(aguri_t *tp, const void *key, anode_t *np) {
	anode_t *bp = NULL, *leaf = NULL;

	/* reclaim two nodes from the LRU list */
	leaf = TAILQ_LAST(&tp->tr_lru, _lru);
	while (leaf->tn_intree)
		leaf = TAILQ_PREV(leaf, _lru, tn_chain);
	TAILQ_REMOVE(&tp->tr_lru, leaf, tn_chain);
	TAILQ_INSERT_HEAD(&tp->tr_lru, leaf, tn_chain);
	leaf->tn_intree = 1;
	tp->tr_nfree--;
	_nreset(leaf);
	memcpy(leaf->tn_key, key, tp->tr_keylen/8);
	leaf->tn_prefixlen = tp->tr_keylen;

	assert(tp->tr_nfree > 0);
	bp = TAILQ_LAST(&tp->tr_lru, _lru);
	while (bp->tn_intree)
		bp = TAILQ_PREV(bp, _lru, tn_chain);
	TAILQ_REMOVE(&tp->tr_lru, bp, tn_chain);
	bp->tn_intree = 1;
	tp->tr_nfree--;
	_nreset(bp);
	bp->tn_prefixlen = _common(np->tn_key, key, tp->tr_keylen, bp->tn_key);

	if (bp->tn_prefixlen >= np->tn_prefixlen) {
		/*
		 * leaf should be a child of np
		 */
		assert(np->tn_left == NULL && np->tn_right == NULL);
		TAILQ_REMOVE(&tp->tr_lru, np, tn_chain);
		TAILQ_INSERT_HEAD(&tp->tr_lru, bp, tn_chain);
		if (bp->tn_prefixlen != np->tn_prefixlen) {
			_set(bp->tn_key, np->tn_prefixlen + 1);
			np->tn_left = leaf;
			np->tn_right = bp;
		} else {
			np->tn_left = bp;
			np->tn_right = leaf;
		}
		bp->tn_parent = np;
		leaf->tn_parent = np;
		return (leaf);
	}

	if (np->tn_parent->tn_left == np)
		np->tn_parent->tn_left = bp;
	else
		np->tn_parent->tn_right = bp;
	bp->tn_parent = np->tn_parent;
	if (_isset(key, bp->tn_prefixlen + 1)) {
		bp->tn_left = np;
		bp->tn_right = leaf;
	} else {
		bp->tn_left = leaf;
		bp->tn_right = np;
	}
	np->tn_parent = bp;
	leaf->tn_parent = bp;

	return (leaf);
}

/* ------------------------------------------------------------ */

static void
_free(aguri_t *tp, anode_t *leaf) {
	anode_t *bp, *np, *parent;

	assert(leaf->tn_intree);
	assert(leaf->tn_left == NULL && leaf->tn_right == NULL);
	bp = leaf->tn_parent;
	assert(bp->tn_left != NULL && bp->tn_right != NULL);
	parent = bp->tn_parent;
	assert(parent != NULL);

	/*
	 * aggregate the counter values of the nodes to be deleted
	 * into their parent node
	 */
	parent->tn_count += bp->tn_count + leaf->tn_count;

	if (bp->tn_left == leaf)
		np = bp->tn_right;
	else
		np = bp->tn_left;
	if (parent->tn_left == bp)
		parent->tn_left = np;
	else
		parent->tn_right = np;
	np->tn_parent = parent;

	leaf->tn_intree = 0;
	bp->tn_intree = 0;
	TAILQ_REMOVE(&tp->tr_lru, leaf, tn_chain);
	TAILQ_INSERT_TAIL(&tp->tr_lru, leaf, tn_chain);
	TAILQ_INSERT_TAIL(&tp->tr_lru, bp, tn_chain);
	tp->tr_nfree += 2;
}

/* ------------------------------------------------------------ */

/*
 * reclaim leaf nodes using the LRU replacement algorithm.
 * we don't select a node as a possible victim if the node is
 *  - already reclaimed
 *  - the counter value is larger than the threshold
 *  - both of its parent and sibling's subtree are larger than the threshold
 * then, we compare parent's count with sibling's subtree sum.
 * - if parent is larger, reduce the subtree into parent.
 * - otherwise, reclaim this node and parent, and leave the sibling's subtree.
 */
static void
_reclaim(aguri_t *tp, int n) {
	anode_t *np, *after, *parent, *sibling;
	u_int64_t thresh, sum, moved_to_head;

	thresh = tp->tr_count / 64;
	if (thresh == 0)
		thresh = 1;
	while (tp->tr_nfree < n) {
		/*
		 * select a victim from the LRU list.
		 * exclude nodes whose count is more than the threshold.
		 */
		moved_to_head = 0;
		np = TAILQ_LAST(&tp->tr_lru, _lru);
		while (np != NULL) {
			if (np->tn_intree == 0) {
				/* free node */
				np =  TAILQ_PREV(np, _lru, tn_chain);
				continue;
			} else if (np->tn_count > thresh) {
				/* if bigger than thresh, move it to head */
				after = np;
				np = TAILQ_PREV(np, _lru, tn_chain);
				if (moved_to_head > 3)
					continue;
				TAILQ_REMOVE(&tp->tr_lru, after, tn_chain);
				TAILQ_INSERT_HEAD(&tp->tr_lru, after, tn_chain);
				moved_to_head++;
				continue;
			}
			/*
			 * a possible victim found.
			 * see if either its parent or sibling's subtree is
			 * smaller than the threshold.
			 * also check if parent is not the top node.
			 */
			parent = np->tn_parent;
			if (parent->tn_left == np)
				sibling = parent->tn_right;
			else
				sibling = parent->tn_left;
			sum = _subsum(sibling);
			if (sum > thresh && (parent->tn_count > thresh
			    || parent == tp->tr_top)) {
				after = np;
				np =  TAILQ_PREV(np, _lru, tn_chain);
				if (moved_to_head > 3)
					continue;
				TAILQ_REMOVE(&tp->tr_lru, after, tn_chain);
				TAILQ_INSERT_HEAD(&tp->tr_lru, after, tn_chain);
				moved_to_head++;
				continue;
			}

			/*
			 * at this point, we are about to reclaim this victim.
			 * compare parent's count with sibling's subtree sum.
			 * if parent is larger, reduce the subtree into parent.
			 * otherwise, reclaim this node and parent, and leave
			 * sibling.
			 */
			if (parent->tn_count > sum || parent == tp->tr_top)
				_reduce(tp, np->tn_parent, 0);
			else
				_free(tp, np);
			break;
		}

		if (np == NULL) {
			thresh *= 2;
#if 0
			fprintf(stderr, "thresh increased to %llu\n", thresh);
#endif
		}
	}
}

/* ------------------------------------------------------------ */

static anode_t *
_addcount(aguri_t *tp, const void *key, size_t len, u_int64_t cnt) {
	anode_t *np = NULL;

	np = _find(tp, key, len);

	np->tn_count += cnt;
	tp->tr_count += cnt;

	/* if this is a leaf, place this node at the head of the LRU list */
	if (np->tn_left == NULL)
		if (np != TAILQ_FIRST(&tp->tr_lru)) {
			TAILQ_REMOVE(&tp->tr_lru, np, tn_chain);
			TAILQ_INSERT_HEAD(&tp->tr_lru, np, tn_chain);
		}
	return (np);
}

/* ------------------------------------------------------------ */

static int 
_nadd(anode_t *np, void *arg) {
	aguri_t *that = arg;
	_addcount(that, np->tn_key, np->tn_prefixlen, np->tn_count);
	return(0);
}

/* ------------------------------------------------------------ */

void
aguri_merge(aguri_t *this, aguri_t *other) {
	_preorder(this->tr_top, _nadd, this);
}

/* ------------------------------------------------------------ */

void
aguri_add(aguri_t *t, void *key, u_int64_t cnt) {
	_addcount(t, key, t->tr_keylen, cnt);
}

/* ------------------------------------------------------------ */

void 
aguri_addprefix(aguri_t *t, void *key, size_t len, u_int64_t cnt) {
	_addcount(t, key, len, cnt);
}

/* ------------------------------------------------------------ */

static anode_t *
_find(aguri_t *tp, const void *key, size_t len) {
	anode_t *np = NULL;
	int needfree = 4; /* internal node */

	/*
	 * before starting a search, make sure at least two free nodes
	 * are available at the tail of the LRU list, since two nodes
	 * are required to allocate a new leaf during the search.
	 * for an internal node, we may need 4 free nodes.
	 */
	if (len == tp->tr_keylen)
		needfree = 2;	/* leaf node */

	if (tp->tr_nfree < needfree)
		_reclaim(tp, needfree);

	np = tp->tr_top;
	while (1) {
		if (len < np->tn_prefixlen) {
			/*
			 * a special case for looking for a non-existent
			 * internal node.  we need to create dummy
			 * leaves to make this branch point.
			 *  first case: np is a child of the target
			 *    create a dummy leaf to make the target
			 *  second case: np isn't a child of the target
			 *    we need 4 nodes.  first create
			 *    a branch point by the target key with full
			 *    prefixlen.  then, go on to the first case.
			 */
			u_char	leafkey[MAX_KEYBYTES];

			memcpy(leafkey, key, tp->tr_keylen/8);
			if (_cmp(np->tn_key, key, len) == 0) {
				if (_isset(np->tn_key, len + 1) == 0)
					_set(leafkey, len + 1);
				(void)_alloc(tp, leafkey, np);
				assert(len == np->tn_parent->tn_prefixlen);
				assert(_cmp(np->tn_parent->tn_key,
						  key, len) == 0);
				return (np->tn_parent);
			} else {
				np = _alloc(tp, leafkey, np);
				continue;
			}
		}

		if (_cmp(np->tn_key, key, np->tn_prefixlen) != 0) {
			/*
			 * the prefix doesn't match, we need to
			 * insert new nodes here
			 */
			np = _alloc(tp, key, np);
			if (len != tp->tr_keylen)
				continue;
			return (np);
		}

		/*
		 * the prefix matched.
		 * if len is equal to the prefixlen, we have a match.
		 * otherwise, we have to go down the tree.
		 * since the node holds the common prefix of the
		 * two children, the bit value at prefixlen + 1
		 * shows which way to take.
		 */
		if (len == np->tn_prefixlen) {
			return (np);
		}

		/* if np has no child, create 2 leaves */
		if (np->tn_right == NULL) {
			np = _alloc(tp, key, np);
			if (len != tp->tr_keylen)
				continue;
			return (np);
		}

		if (_isset(key, np->tn_prefixlen + 1))
			np = np->tn_right;
		else
			np = np->tn_left;
	}
	/* NOTREACHED */
}

/* ------------------------------------------------------------ */

static int
_agg(anode_t *np, void *arg) {
	u_int64_t thresh = *(u_int64_t *)arg;

	/* if count is less than thresh, aggregate */
	if (np->tn_parent != NULL && np->tn_count < thresh) {
		np->tn_parent->tn_count += np->tn_count;
		np->tn_count = 0;
	}

	return (0);
}





