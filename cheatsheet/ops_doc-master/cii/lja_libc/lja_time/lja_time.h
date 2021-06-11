#ifndef LJA_TIME

#include <assert.h>
#include <sys/times.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

long
lja_time_sub(
		struct timeval *start,
		struct timeval *end);

intmax_t
lja_real_time(
		clock_t *st_time,
		clock_t *ed_time);

intmax_t
lja_user_time(
		struct tms *st_cpu, 
		struct tms *ed_cpu);

intmax_t
lja_sys_time(
		struct tms *st_cpu, 
		struct tms *ed_cpu);

void
lja_cpu_time(
		struct tms *st_cpu, 
		struct tms *ed_cpu,
		intmax_t *user,
		intmax_t *sys);
void 
lja_start_clock(
		clock_t *st_time,
		struct tms *st_cpu);
void
lja_end_clock(
		char *prefix,
		clock_t *st_time,
		clock_t *en_time,
		struct tms *st_cpu, 
		struct tms *ed_cpu,
		char *suffix);
#endif 


