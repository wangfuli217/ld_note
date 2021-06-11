// 创建一个60s后启动的timer

static void
one_minute_cb (struct ev_loop *loop, ev_timer *w, int revents)
{
  .. one minute over, w is actually stopped right here
}
ev_timer mytimer;
ev_timer_init (&mytimer, one_minute_cb, 60., 0.);
ev_timer_start (loop, &mytimer);

// 创建一个timer，在10秒不活动后超时。

static void
timeout_cb (struct ev_loop *loop, ev_timer *w, int revents)
{
  .. ten seconds without any activity
}
ev_timer mytimer;
ev_timer_init (&mytimer, timeout_cb, 0., 10.); /* note, only repeat used */
ev_timer_again (&mytimer); /* start timer */
ev_run (loop, 0);
// and in some piece of code that gets executed on any "activity":
// reset the timeout to start ticking again at 10 seconds
ev_timer_again (&mytimer);