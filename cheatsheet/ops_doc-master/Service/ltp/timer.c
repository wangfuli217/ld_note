#include <stdio.h>
#include <signal.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

/*
这是一个非常好的定时器，也是一个超时计时器,是从安卓中移植过来的,在工作中经常用到 编译需要加 -lrt
*/
#define PRELOAD_START_TIMEOUT_MS 5000  // 1 seconds

static void start_wait_timer(void);
static void setTimer(union sigval);
static void wait_timeout(union sigval);

typedef struct {
	int timer_created;
	timer_t timer_id[10];
} test_preload;

static  test_preload preload_retry_cb;

static  timeout_count=0;
static  create_count=0;
time_t  timearry[20];

static void wait_timeout(union sigval sig)
{
	int i=0;
	printf("****\n");
	setTimer(sig);
}

static void start_wait_timer(void)
{
	int status;
	struct sigevent se;

	se.sigev_notify = SIGEV_THREAD;
	se.sigev_value.sival_ptr = &preload_retry_cb.timer_id[create_count];
	se.sigev_notify_function = (void *)wait_timeout;
	se.sigev_notify_attributes = NULL;
	status = timer_create(CLOCK_MONOTONIC, &se, &preload_retry_cb.timer_id[create_count]);
	if (status == 0)
		preload_retry_cb.timer_created = 1;

	setTimer(se.sigev_value);
	create_count++;
}

static void setTimer(union sigval sig)
{
	int status;
	struct itimerspec ts;
	unsigned int timeout_ms = PRELOAD_START_TIMEOUT_MS;
	int i=0;
	if (preload_retry_cb.timer_created == 1) {
		ts.it_value.tv_sec = timeout_ms/1000;
		ts.it_value.tv_nsec = 1000000*(timeout_ms%1000);
		ts.it_interval.tv_sec = 0;
		ts.it_interval.tv_nsec = 0;
		status = timer_settime(*(timer_t*)sig.sival_ptr, 0, &ts, 0);
		if (status == -1)
			printf("failed \n");
	}
}

static void stop_wait_timer(void)
{
	if (preload_retry_cb.timer_created == 1) {
		timer_delete(preload_retry_cb.timer_id[create_count]);
		preload_retry_cb.timer_created = 0;
	}
}

int static count=0;
int main(int argc, const char *argv[])
{

	memset(&preload_retry_cb, 0, sizeof(preload_retry_cb));

	start_wait_timer();
	start_wait_timer();
	start_wait_timer();
	start_wait_timer();
	start_wait_timer();
	while(1) {

		sleep(1);
	}
	return 0;
}