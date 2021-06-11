#include "timer.h"
#include "list.h"
#include <time.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

typedef struct timer_s timer_t;
struct timer_s {
	struct list_head 	entry;
	unsigned long 		expires;
	time_t				time;
	timeout_handler_t	handler;
	void*				data;
} __attribute__((aligned(sizeof(long))));

typedef struct timer_list_s timer_list_t;
struct timer_list_s {
	timer_t	*tl;
	time_t	curr; /* 当前时间，判断过期使用 */
};

#define now	time(NULL)
#define time_after(a, b, c) (b - a >= c)
#define tety(p) list_entry(p, timer_t, entry)
#define tdel(t) do {					\
	if (t->data) {						\
		free(t->data);					\
		t->data = NULL;					\
	}									\
	free(t);t = NULL;					\
} while(0)								


timer_list_t	*t;


static inline void
handle_timeout(void* arg)
{
	printf("handler_timerout: %d\n", *(int*)arg);
}

static void 
__timer_list_init(timer_list_t** tl)
{
	timer_list_t* 		_t;
	
	*tl = malloc(sizeof **tl);
	_t = *tl;
	
	if (_t) {
		_t->tl = malloc(sizeof *(_t->tl));
		_t->tl->entry.prev = _t->tl->entry.next = &(_t->tl->entry);
		_t->tl->expires = 0;
		_t->tl->handler = NULL;
		_t->tl->time = 0;
		_t->tl->data = NULL;
		_t->curr = now;
	}
}

static void
__timer_list_del(timer_list_t** tl)
{
	timer_t 		*tr;
	timer_list_t 	*list;
	
	list = *tl;
	tr = list->tl;
	
	free(tr);
	free(list);
	*tl = NULL;
}

unsigned long
timer_start(unsigned long sec, 
			timeout_handler_t handler, 
			void* arg, 
			unsigned int alen, 
			bool isloop)
{
	if (t == NULL) {
		__timer_list_init(&t);
	}
	
	timer_t* nt = (timer_t*)malloc(sizeof *nt);
	
	if (nt) {
		nt->expires = sec;
		nt->time = now;
		nt->entry.prev = nt->entry.next = NULL;
		nt->handler = handler ? handler : handle_timeout;
		nt->data = malloc(alen);
		memcpy(nt->data, arg, alen);
		
		list_add_tail(&nt->entry, &t->tl->entry);
		
		return (unsigned long)&nt->entry;
	}
	
	return (unsigned long)0;
}

void
timer_stop(unsigned long id)
{
	struct list_head 	*l;
	timer_t 			*p;
	
	l = (struct list_head*)id;
	
	if (l) { 
		list_del(l);
		p = tety(l);
		tdel(p);
	}
}

void 
timer_run()
{
	struct list_head 	*head, *pos, *n;
	timer_t	*			tr;
	
	head = &t->tl->entry;
	pos = n = NULL;
	
	t->curr = now;
	
	for (pos = head->next, n = pos->next ; pos != head; pos = n, n = n->next) {
		printf("pos: 0x%p\n", pos);
		tr = tety(pos); //list_entry(pos, timer_t, entry);
		if (tr) {
			printf("curr: %lu time: %lu\n", tr->time, t->curr);			
			if (t->curr - tr->time >= tr->expires) {
				list_del(pos);
				tr->handler(tr->data);
				tdel(tr);
			}
		}		
	}
}

void
timer_list_del()
{
	__timer_list_del(&t);
}


