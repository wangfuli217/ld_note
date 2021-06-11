/**
 * File: event_test.c
 * Author: ZhuXindi
 * Date: 2014-04-22
 */

#include <event.h>
#include <log.h>
#include <systime.h>

static struct event rev, wev, timer;

void callback(void *p)
{
	if (p == &rev)
		log_info("can read");
	else if (p == &wev)
		log_info("can write");
	else /* timer */
		log_info("timer timeout");
}

int main()
{
	update_pid();
	update_sys_time();
	set_log_level(LOG_DEBUG);

	rev.fd = 0;
	rev.type = EVENT_T_READ;
	rev.handler = callback;
	rev.data = &rev;

	wev.fd = 1;
	wev.type = EVENT_T_WRITE;
	wev.handler = callback;
	wev.data = &wev;

	timer.when = current_msecs + 5000;
	timer.type = EVENT_T_TIMER;
	timer.handler = callback;
	timer.data = &timer;

	event_init(10);
	event_add(&rev);
	event_add(&timer);

	event_wait();
	event_add(&wev);
	event_wait();

	event_del(&rev);
	event_del(&wev);
	event_del(&timer);
	event_deinit();
	return 0;
}
