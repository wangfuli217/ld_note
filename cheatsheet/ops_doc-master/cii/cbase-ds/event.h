/**
 * File: event.h
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#ifndef _EVENT_H
#define _EVENT_H

#include <rbtree.h>

#define EVENT_T_READ	1
#define EVENT_T_WRITE	2
#define EVENT_T_TIMER	3

typedef void (*event_handler)(void *);

struct event {
	int fd;			/* which fd to listen for io events */
	int type;		/* EVENT_T_XXX */
	event_handler handler;	/* callback */
	void *data;		/* callback argument */
	unsigned long when;	/* timeout for timer event */
	struct event *buddy;	/* maybe two events point to one fd */
	struct rb_node node;	/* timer event tree node */
	unsigned int active:1;	/* if added before */
};

/* init event module */
int event_init(int max_events);

/* deinit event module */
void event_deinit(void);

/* wait for events */
int event_wait(void);

/* register an event */
int event_add(struct event *ev);

/* unregister an event */
int event_del(struct event *ev);

#endif /* _EVENT_H */
