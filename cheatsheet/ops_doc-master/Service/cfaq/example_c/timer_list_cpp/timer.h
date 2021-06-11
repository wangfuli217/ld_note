#ifndef __TIMER_H_
#define __TIMER_H_

typedef void (*timerout_handler_t)(void*);

unsigned long
timer_start(unsigned long sec, 
			timerout_handler_t handler, 
			void* data, 
			unsigned int dlen);

void
timer_stop(unsigned long id);

void
timer_run();

#endif 