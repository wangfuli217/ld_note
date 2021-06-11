#include "timer.h"
#include <time.h>
#include <sys/time.h>
#include <map>
#include <stdlib.h>
#include <string.h>

using namespace std;

typedef struct timer_s timer_t;
struct timer_s {
	unsigned long 		id;
	unsigned long		expires;
	time_t				when;
	timerout_handler_t	handler;
	void				*data;
} __attribute__((aligned(sizeof(long))));


typedef unsigned long 					timer_key_t;
typedef map<unsigned long, timer_t*> 	timer_list_t;
typedef timer_list_t::iterator			timer_list_itr_t;

#define now time(NULL)
#define tdel(t) do { 					\
	if (t->data) {						\
		free(t->data);					\
		t->data = NULL;					\
	}									\
	free(t);							\
} while(0)				

timer_list_t *tl;

static unsigned long _timers = 0;

static void
__timer_list_init(timer_list_t **list)
{
	*list = new timer_list_t();
}

static void
__timer_list_del(timer_list_t **list)
{
	if (*list) {
		delete *list;
		*list = NULL;
	}
}

unsigned long 
timer_start(unsigned long sec, 
			timerout_handler_t handler, 
			void* data, 
			unsigned int dlen)
{
	timer_t *nt;
	
	if (tl == NULL) {
		__timer_list_init(&tl);
	}
	
	nt = (timer_t*)malloc(sizeof *nt);
	
	if (nt) {
		memset(nt, 0, sizeof *nt);
		
		if (data) {
			nt->data = malloc(dlen);
			
			if (nt->data) memcpy(nt->data, data, dlen);
		}
		
		nt->handler = handler;
		nt->expires = sec,
		nt->when = now;
		nt->id = ++_timers;
		
		(*tl)[nt->id] = nt; // tl->insert(pair<unsigned long, timer_t*>(nt->id, nt))
	}
}

void
timer_stop(unsigned long id)
{
	timer_list_itr_t it;
	
	it = tl->find(id);
	
	if (it != tl->end()) {
		timer_t* p = it->second;
		tl->erase(it);
		
		tdel(p);
	}
}

void
timer_run()
{
	timer_list_itr_t 	it;
	timer_t				*t;
	unsigned long		id;
	time_t				curr;
	
	curr = now;
	
	for (it = tl->begin(); it != tl->end();) {
		id = it->first;
		t = it->second;
		
		if ((unsigned long)curr - t->when >= t->expires) {
			t->handler(t->data);
			tl->erase(it++);
			
			tdel(t);
		} else {
			it++;
		}
	}
}
