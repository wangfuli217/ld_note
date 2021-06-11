/*
 * =====================================================================================
 *
 *       Filename:  pkt_cache.h
 *
 *    Description:  报文缓存链表
 *
 *        Version:  1.0
 *        Created:  12/24/2013 06:38:54 PM
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  YOUR NAME (), 
 *   Organization:  
 *
 * =====================================================================================
 */

#ifndef __PKT_CACHE_H__
#define __PKT_CACHE_H__

#include <string.h>
#include <assert.h>
#include <stdlib.h>

#define PKT_MALLOC malloc
#define PKT_FREE  free

typedef struct st_PktCache{
	struct st_PktCache *    next;
	int           len;
	unsigned long secs;
	unsigned long usecs;
	char          pkt[0];
}PktCache;

typedef struct st_PktCacheHead{
	PktCache *    head;
	PktCache *    end;
	unsigned int  user;
	unsigned int  pktnum;
}PktCacheHead;


void 
pkt_cache_init(
		PktCacheHead *cache);

void
pkt_cache_insert(
		PktCacheHead *cache,
		void *pkt,
		int len,
		unsigned long secs,
		unsigned long usecs);

void
pkt_cache_free(
		PktCacheHead *cache);

void
pkt_cache_register(
		PktCacheHead *cache,
		int user);

void
pkt_cache_cancel(
		PktCacheHead *cache,
		int user);

int
pkt_cache_using(
		PktCacheHead *cache);

int 
pkt_cache_only_user(
		PktCacheHead *cache,
		int user);

void
pkt_cache_replace(
		PktCacheHead *cache,
		void *pkt,
		int len,
		unsigned long secs,
		unsigned long usecs);

void
pkt_cache_module_test(void);

#endif
