基于日历的绝对定时器，periodic watcher不是基于实时（或相对时间，即经过的物理时间）而是基于日历时间（绝对时间，即您可以在日历或时钟上读取的时间）。periodic watcher可以设置在某个特定的时间点后触发，如果你periodic watcher “在10秒内”触发（通过指定ev_now（）+10，即绝对时间而不是延迟），然后将系统时钟重置为上一年的时间，那么触发事件将需要一年的时间（不像ev_timer，它在启动后仍然会触发大约10秒，因为它使用相对超时）。
ev_periodic functions

ev_tstamp (*reschedule_cb)(ev_periodic *w, ev_tstamp now);
void ev_periodic_init (ev_periodic *, callback, ev_tstamp offset, ev_tstamp interval, reschedule_cb);
void ev_periodic_set (ev_periodic *, ev_tstamp offset, ev_tstamp interval, reschedule_cb);
void ev_periodic_start(struct ev_loop *, ev_periodic *);
void ev_periodic_stop(struct ev_loop *, ev_periodic *);
void ev_periodic_again (loop, ev_periodic *);
ev_tstamp ev_periodic_at (ev_periodic *);

ev_periodic_again关闭并重启 periodic watcher reschedule_cb重新安排当前callback,如何不使用的话，可将其值设为0。随时可更改，但更改仅在定期计时器触发或再次调用ev_periodic_again时生效。
ev_periodic 使用场景

    绝对计时器：offset 等于绝对时间，interval 为0，reschedule_cb 为 NULL。在这种设置下，时钟只执行一次，不重复。
    重复内部时钟：offset 小于等于 interval 值，interval 大于0，reschedule_cb 为 NULL。这种设置下，watcher 永远在每一个（offset + N * interval）超时。
    手动排程模式：offset 忽略，reschedule_cb 设置。使用 callback 来返回下次的 trigger 时间。

example

    每小时精确的调用（每当系统时间被3600整除时）callback

static void
clock_cb (struct ev_loop *loop, ev_periodic *w, int revents)
{
  ... its now a full hour (UTC, or TAI or whatever your clock follows)
}
ev_periodic hourly_tick;
ev_periodic_init (&hourly_tick, clock_cb, 0., 3600., 0);
ev_periodic_start (loop, &hourly_tick);
/*or*/
#include <math.h>
static ev_tstamp
my_scheduler_cb (ev_periodic *w, ev_tstamp now)
{
  return now + (3600. - fmod (now, 3600.));
}
 ev_periodic_init (&hourly_tick, clock_cb, 0., 0., my_scheduler_cb);

    从现在开始每小时调用一次callback

ev_periodic hourly_tick;
ev_periodic_init (&hourly_tick, clock_cb,
                  fmod (ev_now (loop), 3600.), 3600., 0);
ev_periodic_start (loop, &hourly_tick);