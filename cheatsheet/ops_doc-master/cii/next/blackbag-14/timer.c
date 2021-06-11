/* This file is part of the Project Athena Zephyr Notification System.
 * It contains functions for managing multiple timeouts.
 *
 *      Created by:     John T. Kohl
 *      Derived from timer_manager_ by Ken Raeburn
 *
 */

/*
 * timer_manager_ -- routines for handling timers in login_shell
 * (and elsewhere)
 *
 * Copyright 1986 Student Information Processing Board,
 * Massachusetts Institute of Technology
 *
 * written by Ken Raeburn  
 */

#define timer_t mytimer_t

/*
 * External functions:
 *
 * Timer *timer_set_rel (time_rel, proc, arg)
 *      long time_rel;
 *      void (*proc)();
 *      caddr_t arg;
 * Timer *timer_set_abs (time_abs, proc, arg)
 *      u_int64_t time_abs;
 *      void (*proc)();
 *      caddr_t arg;
 *
 * void timer_release(tmr)
 *      Timer **tmr;
 *
 * void timer_process()
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/time.h>

#include "timer.h"

/* DELTA is just an offset to keep the size a bit less than a power 
 * of two.  It's measured in pointers, so it's 32 bytes on most
 * systems. */
#define DELTA 8
#define INITIAL_HEAP_SIZE (1024 - DELTA)

/* We have three operations which we need to be able to perform
 * quickly: adding a timer, deleting a timer given a pointer to
 * it, and determining which timer will be the next to go off.  A
 * heap is an ideal data structure for these purposes, so we use
 * one.  The heap is an array of pointers to timers, and each timer
 * knows the position of its pointer in the heap.
 *
 * Okay, what is the heap, exactly?  It's a data structure,
 * represented as an array, with the invariant condition that
 * the timeout of heap[i] is less than or equal to the timeout of
 * heap[i * 2 + 1] and heap[i * 2 + 2] (assuming i * 2 + 1 and
 * i * 2 + 2 are valid * indices).  An obvious consequence of this
 * is that heap[0] has the lowest timer value, so finding the first
 * timer to go off is easy.  We say that an index i has "children"
 * i * 2 + 1 and i * 2 + 1, and the "parent" (i - 1) / 2.
 *
 * To add a timer to the heap, we start by adding it to the end, and
 * then keep swapping it with its parent until it has a parent with
 * a timer value less than its value.  With a little bit of thought,
 * you can see that this preserves the heap property on all indices
 * of the array.
 *
 * To delete a timer at position i from the heap, we discard it and
 * fill in its position with the last timer in the heap.  In order
 * to restore the heap, we have to consider two cases: the timer
 * value at i is less than that of its parent, or the timer value at
 * i is greater than that of one of its children.  In the first case,
 * we propagate the timer at i up the tree, swapping it with its
 * parent, until the heap is restored; in the second case, we
 * propagate the timer down the tree, swapping it with its least
 * child, until the heap is restored. */

/* In order to ensure that the back pointers from timers are consistent
 * with the heap pointers, all heap assignments should be done with the
 * HEAP_ASSIGN() macro, which sets the back pointer and updates the
 * heap at the same time. */
#define PARENT(i) (((i) - 1) / 2)
#define CHILD1(i) ((i) * 2 + 1)
#define CHILD2(i) ((i) * 2 + 2)
#define TIME(i) (heap[i]->abstime)
#define HEAP_ASSIGN(pos, tmr) ((heap[pos] = (tmr))->heap_pos = (pos))

static Timer **heap;
static int num_timers = 0;
static int heap_size = 0;

static int timer_botch(void *);
static Timer *add_timer(Timer *);

struct tpair {
	void (*fn)(void *arg);
	void *arg;
};

static int 
repeater(void *arg) {
	struct tpair *tp = arg;
	tp->fn(tp->arg);
	return(1);
}

static int
oneshot(void *arg) {
	struct tpair *tp = arg;
	tp->fn(arg);
	return(0);
}

void
timer_permanent(long ms, void (*fn)(void *arg), void *arg) {
	struct tpair *tp = calloc(1, sizeof(*tp));
	timer_set_rel(ms, repeater, tp);
	tp->fn = fn;
	tp->arg = arg;
}

void
timer_oneshot(long ms, void (*fn)(void *arg), void *arg) {
	struct tpair *tp = calloc(1, sizeof(*tp));
	timer_set_rel(ms, oneshot, tp);
	tp->fn = fn;
	tp->arg = arg;
}

Timer *timer_set_rel(long time_rel, int (*proc)(void *), void *arg)
{
	Timer *new_t;

	new_t = malloc(sizeof(*new_t));       
	new_t->rel = time_rel;
	new_t->abstime = timer_now() + time_rel;
	new_t->func = proc;
	new_t->arg = arg;

	return(add_timer(new_t));
}

static void
timer_retarget(Timer *t, struct timeval *tv) {
	t->abstime = t->rel + timer_tv2ms(tv);
}

Timer *
timer_set_abs(u_int64_t time_abs, int (*proc)(void *), void *arg)
{
	Timer *new_t = malloc(sizeof(*new_t));
	new_t->rel = 0;
	new_t->abstime = time_abs;
	new_t->func = proc;
	new_t->arg = arg;
	return(add_timer(new_t));
}  

static void removepos(int pos);

void
timer_release(Timer **tmrp)
{
	Timer *tmr = *tmrp;
	int pos;
	*tmrp = NULL;
	/* Free the timer, saving its heap position. */

	if(!tmr)
		return;
	pos = tmr->heap_pos;
	free(tmr);

	removepos(pos);
}

static void 
removepos(int pos) {
	int min;
	if (pos != num_timers - 1) {
		/* Replace the timer with the last timer in the heap and
		 * restore the heap, propagating the timer either up or
		 * down, depending on which way it violates the heap
		 * property to insert the last timer in place of the
		 * deleted timer. */
		if (pos > 0 && TIME(num_timers - 1) < TIME(PARENT(pos))) {
			do {
				HEAP_ASSIGN(pos, heap[PARENT(pos)]);
				pos = PARENT(pos);
			} while (pos > 0 && TIME(num_timers - 1) < TIME(PARENT(pos)));
			HEAP_ASSIGN(pos, heap[num_timers - 1]);
		} else {
			while (CHILD2(pos) < num_timers) {
				min = num_timers - 1;
				if (TIME(CHILD1(pos)) < TIME(min))
					min = CHILD1(pos);
				if (TIME(CHILD2(pos)) < TIME(min))
					min = CHILD2(pos);
				HEAP_ASSIGN(pos, heap[min]);
				pos = min;
			}
			if (pos != num_timers - 1)
				HEAP_ASSIGN(pos, heap[num_timers - 1]);
		}
	}
	num_timers--;
}

static Timer *
add_timer(Timer *new_t)
{
	int pos;

	/* Create or resize the heap as necessary. */
	if (heap_size == 0) {
		heap_size = INITIAL_HEAP_SIZE;
		heap = malloc(heap_size * sizeof(*heap));
	} else if (num_timers >= heap_size) {
		heap_size = heap_size * 2 + DELTA;
		heap = realloc(heap, heap_size * sizeof(*heap));
	}
	if (!heap) {
		free(new_t);
		return(NULL);
	}

	/* Insert the Timer *into the heap. */
	pos = num_timers;
	while (pos > 0 && new_t->abstime < TIME(PARENT(pos))) {
		HEAP_ASSIGN(pos, heap[PARENT(pos)]);
		pos = PARENT(pos);
	}
	HEAP_ASSIGN(pos, new_t);
	num_timers++;

	return(new_t);
}

void
timer_process_all(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL); /* XXX use a vsyscall based version of gtod */
	timer_process_all_wtime(&tv);
}

void
timer_process_all_wtime(struct timeval *tv) 
{
	while(timer_process_wtime(tv)) ;
}

int
timer_process(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL); /* XXX use a vsyscall based version of gtod */
	return(timer_process_wtime(&tv));
}

int
timer_process_wtime(struct timeval *tv)
{
	Timer *t;
	timer_proc func;
	void *arg;
	u_int64_t rel;

	if (num_timers == 0 || heap[0]->abstime > timer_tv2ms(tv))
		return(0);

	/* Remove the first timer from the heap, remembering its
	 * function and argument. */
	t = heap[0];
	func = t->func;
	arg = t->arg;
	rel = t->rel;
	
	/* Run the function. */
	if(func(arg)) {
		removepos(t->heap_pos);
		timer_retarget(t, tv);
		add_timer(t);
	} else {
		t->func = timer_botch;
		t->arg = NULL;
		timer_release(&t);
	}
	
	return(1);
}

u_int64_t
timer_now(void) 
{
	struct timeval tm;
	gettimeofday(&tm, NULL); /* use vsyscall based version of gtod */
	return(timer_tv2ms(&tm));	
}

struct timeval *
timer_timeout(struct timeval *tvbuf)
{
	if (num_timers > 0) {
		if(heap[0]->abstime < timer_now())
			*tvbuf = timer_ms2tv(0);
		else
			*tvbuf = timer_ms2tv(heap[0]->abstime - timer_now());
		return(tvbuf);
	} else {
		return(NULL);
	}
}

u_int64_t 
timer_tv2ms(struct timeval *tm) {
	u_int64_t v = tm->tv_sec;
	v *= 1000;
	v += (tm->tv_usec / 1000);
	return(v);
}

struct timeval
timer_ms2tv(u_int64_t ms) {
	struct timeval tv;
	tv.tv_sec = ms / 1000;
	tv.tv_usec = (ms % 1000) * 1000;
	return(tv);
}

struct timeval
timer_add(struct timeval *a, struct timeval *b) {
	struct timeval ret;
	ret.tv_sec = a->tv_sec + b->tv_sec;
	ret.tv_usec = a->tv_usec + b->tv_usec;
	if(ret.tv_usec > 1000000L) {
		ret.tv_sec += (ret.tv_usec / 1000000);
		ret.tv_usec %= 1000000L;	
	}
	return(ret);
}

struct timeval
timer_sub(struct timeval *a, struct timeval *b) {
	struct timeval tm;
	long diff;
	diff = a->tv_usec - b->tv_usec;
	if(diff < 0) {
		diff = diff + 1000000L;
		a->tv_sec -= 1;
	}

	tm.tv_usec = diff;
	diff = a->tv_sec - b->tv_sec;
	tm.tv_sec = diff;
	return(tm);
}

size_t
timer_count(void) {
	return(num_timers);
}

static int
timer_botch(void *arg)
{
	abort();
}
