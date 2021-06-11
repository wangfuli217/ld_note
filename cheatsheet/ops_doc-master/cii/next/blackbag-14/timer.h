/* This file is part of the Project Athena Zephyr Notification System.
 * It contains definitions used by timer.c
 *
 *      Created by:     John T. Kohl (in 1988!) 
 *      Derived from timer_manager_.h by Ken Raeburn
 *	+ tqbf:
 * 	- store time in u64 milliseconds (increase granularity)
 * 	- implement set_abs()
 * 	- add utility functions
 *      - allow reschedulable timers
 */

#ifndef __TIMER_H
#define __TIMER_H


/*
 * A timer callback takes void* data arg and returns 1 if it should
 * be rescheduled, 0 if not.
 */
typedef int (*timer_proc)(void *);

typedef struct _Timer {
        int		heap_pos;	/* Position in timer heap */
        u_int64_t    	abstime;
	u_int64_t 	rel;
        timer_proc	func;
        void		*arg;
} Timer;

/* generate a relative timer (in milliseconds), see above */
/*@only@*/ Timer *timer_set_rel(long, timer_proc, void *);

/* generate an absolute timer (in milliseconds) */
/*@only@*/ Timer *timer_set_abs(u_int64_t, timer_proc, void *);

/* remove a timer from the heap, unschedule and free */

typedef /*@only@*/ Timer *onlyTimer_t;
void timer_release(onlyTimer_t *t) /*@modifies *t, **t@*/ ;

/* generate a trivial repeating timer */
void timer_permanent(long ms, void (*proc)(void *arg), void *arg);

/* generate a trivial one-shot timer */
void timer_oneshot(long msrelative, void (*proc)(void *arg), void *arg);

/* tick all timers forward  (call from event loop); _wtime()
 * passes in the timeval so you don't have to call gettimeofday.
 * _process_[wtime]() is one-at-a-time, call until it returns
 * nonzero. process_all*() does the loop for you.
 */

int timer_process(void);
int timer_process_wtime(struct timeval *tv);
void timer_process_all(void);
void timer_process_all_wtime(struct timeval *tv);

/* what's the next timer that is going to fire? pass this
 * to select if you want precise timers; otherwise, just 
 * pick a minimum granularity (say 100ms) and tell select
 * to timeout every 100ms and call timer_process_all().
 */
struct timeval *timer_timeout(struct timeval *tvbuf);

/* utilities */

/* convert u64 milliseconds into timeval */
struct timeval timer_ms2tv(u_int64_t ms);

/* convert timeval into u64 milliseconds */
u_int64_t timer_tv2ms(struct timeval *tm);

/* get current timestamp */
u_int64_t timer_now(void);

/* timeval math */
struct timeval timer_add(struct timeval *a, struct timeval *b);
struct timeval timer_sub(struct timeval *a, struct timeval *b);

size_t timer_count(void);

#endif /* __TIMER_H */

