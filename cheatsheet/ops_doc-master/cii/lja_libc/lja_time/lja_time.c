#include "lja_time.h"

long
lja_time_sub(
		struct timeval *start,
		struct timeval *end)
{
	assert( NULL != start);
	assert( NULL != end);

	return (1000000 * (end->tv_sec - start->tv_sec) 
			+ (end->tv_usec - start->tv_usec));
}

intmax_t
lja_real_time(
		clock_t *st_time,
		clock_t *ed_time)
{
	assert(NULL != st_time);
	assert(NULL != ed_time);

	return (intmax_t)(*ed_time - *st_time);
}

intmax_t
lja_user_time(
		struct tms *st_cpu, 
		struct tms *ed_cpu)
{
	assert(NULL != st_cpu);
	assert(NULL != ed_cpu);

	return (intmax_t)(ed_cpu->tms_utime - st_cpu->tms_utime);
}


intmax_t
lja_sys_time(
		struct tms *st_cpu, 
		struct tms *ed_cpu)
{
	assert(NULL != st_cpu);
	assert(NULL != ed_cpu);

	return (intmax_t)(ed_cpu->tms_stime - st_cpu->tms_stime);
}

void
lja_cpu_time(
		struct tms *st_cpu, 
		struct tms *ed_cpu,
		intmax_t *user,
		intmax_t *sys)
{
	assert(NULL != user);
	assert(NULL != sys);

	*user = (intmax_t)(ed_cpu->tms_utime - st_cpu->tms_utime);
	*sys  = (intmax_t)(ed_cpu->tms_stime - st_cpu->tms_stime);
}

void 
lja_start_clock(
		clock_t *st_time,
		struct tms *st_cpu)
{
	assert(NULL != st_time);
	assert(NULL != st_cpu);

	*st_time = times(st_cpu);
}

void
lja_end_clock(
		char *prefix,
		clock_t *st_time,
		clock_t *ed_time,
		struct tms *st_cpu, 
		struct tms *ed_cpu,
		char *suffix)
{
	assert(NULL != st_time);
	assert(NULL != ed_time);
	assert(NULL != st_cpu);
	assert(NULL != ed_cpu);

	*ed_time = times(ed_cpu);

	long cl = sysconf(_SC_CLK_TCK);

	printf("%s", prefix);
	printf("Clock: %ld/s\n",cl);
	printf("Real time: %jd\n",lja_real_time(st_time, ed_time));
	printf("User time: %jd\n",lja_user_time(st_cpu, ed_cpu));
	printf("SYS  time: %jd\n",lja_sys_time(st_cpu, ed_cpu));
	printf("%s", suffix);
}
