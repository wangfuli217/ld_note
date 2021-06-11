#ifndef __TIMER_H_
#define __TIMER_H_

#include <stdbool.h>

#ifdef __cplusplus 
extern "C" {
#endif


typedef void (*timeout_handler_t)(void*);

unsigned long
timer_start(unsigned long sec, 
			timeout_handler_t handler, 
			void* arg, 
			unsigned int alen, 
			bool isloop);

void 
timer_stop(unsigned long id);

void 
timer_run();

void 
timer_list_del();

#ifdef __cplusplus 
}
#endif

#endif 

