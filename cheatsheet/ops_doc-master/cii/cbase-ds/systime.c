/**
 * File: systime.c
 * Author: ZhuXindi
 * Date: 2017-04-02
 */

#include <systime.h>

pid_t pid;

time_t current_time;
char str_time[] = "2017-01-25 23:41:36";
struct timeval time_of_day;
unsigned long current_msecs;

void update_sys_time(void)
{
	gettimeofday(&time_of_day, NULL);

	current_time  = time_of_day.tv_sec;
	current_msecs = (unsigned long)time_of_day.tv_sec * 1000 +
			(unsigned long)time_of_day.tv_usec / 1000;

	strftime(str_time, sizeof(str_time), "%F %T", localtime(&current_time));
}

void update_pid(void)
{
	pid = getpid();
}
