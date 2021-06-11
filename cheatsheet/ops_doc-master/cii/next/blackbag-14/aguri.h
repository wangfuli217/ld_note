#ifndef AGURI_INCLUDED
#define AGURI_INCLUDED

/*
 * Copyright (C) 2001-2003 WIDE Project.
 */

/*
 * Aguri Trie: Fixed-Length LRU-Controlled Radix Trie
 *
 * Insert "keys" (usually IP addresses) into the trie along with 
 * counter values ("100 more packets for 1.2.3.4"). The tree will 
 * grow to hold as many keys as you tell it to, then start reclaiming
 * nodes LRU-style by merging "adjacent" nodes (the two /32's in a /31,
 * the two /25's in a /24, etc).
 *
 * The result is that, based on traffic and observation frequency, 
 * you can infer netmasks (or port ranges, or whatever) from individual
 * samples.
 *
 */

typedef struct aguri_s aguri_t;

/* where "key" might be ptr-to-u_int32_t, with prefixlen=0-32 depending
 * on netmask
 */            
typedef int (*aguri_walker)(size_t prefixlen, u_char *key, u_int64_t ticks, int depth, void *cl);

/* make a new trie. keybits=32 for IP addresses, etc. the trie will
 * never hold more than "maxnodes" nodes.
 */
aguri_t *	aguri_new(size_t keybits, size_t maxnodes);

/* add a new address (or port or whatever) to the trie
 */
void		aguri_add(aguri_t *t, void *k, u_int64_t ticks);

/* merge/aggregate all nodes that have counters lower than "thresh"
 */
void 		aguri_aggregate(aguri_t *t, u_int64_t thresh);

/* retrieve values from the trie. There's no exposed "find" because
 * the trie will modify itself out from under you (that's the point).
 */
int		aguri_walk(aguri_t *t, aguri_walker f, void *arg);

/* add the nodes (preserving inferred prefix lengths) from "other"
 * to "this"
 */
void		aguri_merge(aguri_t *this, aguri_t *other);

/* add a node with a specific prefix length to the trie
 */
void		aguri_addprefix(aguri_t *t, void *k, size_t kl, u_int64_t ticks);

/* reuse the same trie for multiple runs without reallocating
 */
void		aguri_reset(aguri_t *tp);

/* ditch the trie
 */
void		aguri_release(aguri_t **tp);

#endif
