/**
 * File: systime.h
 * Author: ZhuXindi
 * Date: 2017-04-02
 */

#ifndef _SYSTIME_H
#define _SYSTIME_H

#include <unistd.h>
#include <sys/time.h>
#include <time.h>

extern pid_t pid;

extern time_t current_time;
extern char str_time[];
extern struct timeval time_of_day;
extern unsigned long current_msecs;

void update_sys_time(void);
void update_pid(void);

#endif /* _SYSTIME_H */
