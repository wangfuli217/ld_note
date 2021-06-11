// 使用标准的初始化和停止 API 来重设
//ev_init(timer, callback);
//ev_timer_set (timer, 60.0, 0.0);
ev_timer_init (timer, callback, 60.0, 6.0);
ev_timer_start (loop, timer)

// 使用ev_timer_again重设 使用ev_timer_again，可以忽略ev_timer_start
ev_init (timer, callback);
timer->repeat = 60.0;
ev_timer_again (loop, timer);

// 初始化完全后，可在callback中改变 timeout 值，不管 timer 是否 active:
timer->repeat = 60.0;
ev_timer_again (loop, timer);



ev_tstamp g_timeout = 60.0;
ev_tstamp g_last_activity;
ev_timer  g_timer;
static void callback (EV_P_ev_timer *w, int revents){
    ev_tstamp after = g_last_activity - ev_now(EV_A) + g_timeout;
    
    // 如果小于零，表示时间已经发生了，已超时
    if (after < 0.0) {
        ......    // 执行 timeout 操作
    }
    else {
        // callback 被调用了，但是却有一些最近的活跃操作，说明未超时
        // 此时就按照需要设置的新超时事件来处理
        ev_timer_set (w, after, 0.0);
        ev_timer_start (loop, g_timer);
    }
}

启用这种模式，记得初始化时将g_last_activity设置为ev_now，并且调用一次callback (loop, &g_timer, 0)；当活跃时间到来时，只需修改全局的 timeout 变量即可，然后再调用一次 callback

g_timeout = new_value
ev_timer_stop (loop, &timer)
callback (loop, &g_timer, 0)