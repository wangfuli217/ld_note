moosefs()
{

}

redis()
{

}

libevent(数据驱动程序与函数指针+时间驱动程序与函数指针+信号驱动程序转数据驱动程序+分析表)
{
数据驱动程序与函数指针
event_init();
event_set(&ev, pair[1], EV_WRITE, write_cb, &ev); #write_cb函数指针
event_set(&ev, pair[1], EV_READ, read_cb, &ev);   #read_cb函数指针
event_add(&ev, NULL);
event_dispatch();

base = event_base_new();
event_set(&ev1, pair[1], EV_READ, simple_read_cb, &ev1);   #simple_read_cb函数指针
event_set(&ev1, pair[0], EV_WRITE, simple_write_cb, &ev1); #simple_write_cb函数指针
event_base_set(base, &ev1);
event_add(&ev1, NULL);
event_base_dispatch(base);
event_base_free(base);

时间驱动程序与函数指针
event_init();
evtimer_set(ev[i], time_cb, ev[i]);  #time_cb函数指针
evtimer_add(ev[i], &tv);
event_dispatch();

信号驱动程序转数据驱动程序
event_init();
event_set(&signal_int, SIGINT, EV_SIGNAL|EV_PERSIST, signal_cb, &signal_int);  #signal_int函数指针
evtimer_add(ev[i], &tv);
event_dispatch();
}