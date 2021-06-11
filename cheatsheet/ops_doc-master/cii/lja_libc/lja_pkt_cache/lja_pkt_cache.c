#include "lja_pkt_cache.h"

void 
pkt_cache_init(
		PktCacheHead *cache)
{
	memset(cache, '\0', sizeof(PktCacheHead));
	return;
}

void
pkt_cache_insert(
		PktCacheHead *cache,
		void *pkt,
		int len,
		unsigned long secs,
		unsigned long usecs)
{
	assert(NULL != cache);
	assert(NULL != pkt);
	assert(0 != len);

	PktCache *pc = (PktCache *)PKT_MALLOC(sizeof(PktCache)+len);

	assert(NULL != pc);

	memcpy(pc->pkt, pkt, len);

	pc->len = len;
	pc->secs = secs;
	pc->usecs = usecs;
	pc->next = NULL;

	if(NULL == cache->head){
		cache->head = pc;
	}

	if(NULL == cache->end){
		cache->end = pc;
	}else{
		cache->end->next = pc;
		cache->end = pc;
	}

	cache->pktnum++;

	return;
}

void
pkt_cache_free(
		PktCacheHead *cache)
{
	assert(NULL != cache);

	PktCache * nextpc = cache->head;
	PktCache * pc;


	while(NULL != nextpc){
		pc = nextpc;
		nextpc = pc->next;
		PKT_FREE(pc);
	}

	pkt_cache_init(cache);
	return;
}

void
pkt_cache_register(
		PktCacheHead *cache,
		int user)
{
	assert(NULL != cache);
	assert(user >= 0 && user < 32);

	cache->user |= 1<<user;
}


void
pkt_cache_cancel(
		PktCacheHead *cache,
		int user)
{
	assert(NULL != cache);
	assert(user >= 0 && user < 32);

	cache->user &= 0xffffffff ^ (1<<user);
}


int
pkt_cache_using(
		PktCacheHead *cache)
{
	assert(NULL != cache);
	
	return cache->user;
}


int 
pkt_cache_only_user(
		PktCacheHead *cache,
		int user)
{
	assert(NULL != cache);
	assert(user >= 0 && user < 32);

	if( (0 == (cache->user & (0xffffffff ^ (1 <<user)))) && (0 != cache->user)){
			return 1;
	}
	return 0;

}

void
pkt_cache_replace(
		PktCacheHead *cache,
		void *pkt,
		int len,
		unsigned long secs,
		unsigned long usecs)
{
	assert(NULL != cache);
	assert(NULL != pkt);
	assert(0 != len);
	PktCache  *pc;

	if(0 == cache->pktnum){
		pkt_cache_insert(cache, pkt, len, secs, usecs);
	}else{
		if(cache->end->len > len){
			memset(cache->end->pkt, '\0', cache->end->len);
			memcpy(cache->end->pkt, pkt, len);
			cache->end->len = len;
			cache->end->secs = secs;
			cache->end->usecs = usecs;
		}else{
			pc = cache->head;
			if(pc != cache->end){
				while(cache->end != pc->next){
					pc = pc->next;
				}
				PKT_FREE(cache->end);
				pc->next = (PktCache *)PKT_MALLOC(sizeof(PktCache) + len);
				cache->end = pc->next;
			}else{
				PKT_FREE(cache->head);
				cache->head = (PktCache *)PKT_MALLOC(sizeof(PktCache) + len);
				cache->end = cache->head;
			}

			memcpy(cache->end->pkt, pkt, len);
			cache->end->len = len;
			cache->end->secs = secs;
			cache->end->usecs = usecs;
			cache->end->next = NULL;
		}
	}
	return ;
}

void
pkt_cache_module_test(void)
{
	PktCacheHead cache;

	pkt_cache_init(&cache);

	assert(NULL == cache.head);
	assert(NULL == cache.end);
	assert(0 == cache.user);
	assert(0 == cache.pktnum);

	//////////////////////////////////////
	//
	// test user register
	//
	//////////////////////////////////////
	
	int user0 = 0;
	pkt_cache_register(&cache, user0);
	assert(1 == cache.user);
	assert(pkt_cache_using(&cache));
	assert(pkt_cache_only_user(&cache, user0));

	int user4 = 4;
	pkt_cache_register(&cache, user4);
	assert(0x00000011 == cache.user);

	pkt_cache_cancel(&cache, user0);
	assert(0x00000010 == cache.user);

	assert(pkt_cache_using(&cache));
	assert(pkt_cache_only_user(&cache, user4));

	pkt_cache_cancel(&cache, user4);
	assert(!pkt_cache_using(&cache));
	assert(!pkt_cache_only_user(&cache, user4));

	//////////////////////////////////////
	//
	// test insert 
	//
	//////////////////////////////////////
	
	char* buf1="Hello Word";
	int len1 = strlen(buf1);
	unsigned long sec1 = 10;
	unsigned long usec1 = 100;

	char* buf2="Hello Word XXXXX";
	int len2 = strlen(buf2);
	unsigned long sec2 = 20;
	unsigned long usec2 = 200;

	char* buf3="adfafa Hello Word";
	int len3 = strlen(buf3);
	unsigned long sec3 = 30;
	unsigned long usec3 = 300;

	pkt_cache_insert(&cache, buf1, len1, sec1, usec1);
	assert(1 == cache.pktnum);
	assert(cache.head == cache.end && NULL != cache.head);
	assert(len1 == cache.head->len);
	assert(sec1 == cache.head->secs);
	assert(usec1 == cache.head->usecs);
	assert(!strcmp(cache.head->pkt, buf1));

	pkt_cache_replace(&cache, buf3, len3, sec3, usec3);
	assert(1 == cache.pktnum);
	assert(cache.head  == cache.end && NULL != cache.end);
	assert(len3 == cache.end->len);
	assert(sec3 == cache.end->secs);
	assert(usec3 == cache.end->usecs);
	assert(!strcmp(cache.end->pkt, buf3));

	pkt_cache_insert(&cache, buf2, len2, sec2, usec2);
	assert(2 == cache.pktnum);
	assert(cache.head->next == cache.end && NULL != cache.end);
	assert(len2 == cache.end->len);
	assert(sec2 == cache.end->secs);
	assert(usec2 == cache.end->usecs);
	assert(!strcmp(cache.end->pkt, buf2));

	pkt_cache_replace(&cache, buf3, len3, sec3, usec3);
	assert(2 == cache.pktnum);
	assert(cache.head->next == cache.end && NULL != cache.end);
	assert(len3 == cache.end->len);
	assert(sec3 == cache.end->secs);
	assert(usec3 == cache.end->usecs);
	assert(!strcmp(cache.end->pkt, buf3));

	//////////////////////////////////////
	//
	// test free
	//
	//////////////////////////////////////
	
	pkt_cache_free(&cache);
	assert(NULL == cache.head);
	assert(NULL == cache.end);
	assert(0 == cache.user);
	assert(0 == cache.pktnum);
}
