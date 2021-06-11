struct event *ev;

// event loop仅被执行一次，而cb会被无限的递归调用中。

static void cb(int sock, short which, void *arg) {
        /* Whoops: Calling event_active on the same event unconditionally
           from within its callback means that no other events might not get
           run! */
	event_active(ev, EV_WRITE, 0);
}

int main(int argc, char **argv) {
	struct event_base *base = event_base_new();
	ev = event_new(base, -1, EV_PERSIST | EV_READ, cb, NULL);
	event_add(ev, NULL);
	event_active(ev, EV_WRITE, 0);
	event_base_loop(base, 0);
	return 0;
}

#if 0
// 上面问题解决方案 timer

struct event *ev;
struct timeval tv;

static void cb(int sock, short which, void *arg) {
   if (!evtimer_pending(ev, NULL)) {
       event_del(ev);
       evtimer_add(ev, &tv);
   }
}

int main(int argc, char **argv) {
   struct event_base *base = event_base_new();

   tv.tv_sec = 0;
   tv.tv_usec = 0;
   ev = evtimer_new(base, cb, NULL);
   evtimer_add(ev, &tv);
   event_base_loop(base, 0);
   return 0;
}

#endif

#if 0
// 上面问题解决方案 event_config_set_max_dispatch_interval

struct event *ev;
static void cb(int sock, short which, void *arg) {
	event_active(ev, EV_WRITE, 0);
}

int main(int argc, char **argv) {
    struct event_config *cfg = event_config_new();
    /* Run at most 16 callbacks before checking for other events. */
    event_config_set_max_dispatch_interval(cfg, NULL, 16, 0);
	struct event_base *base = event_base_new_with_config(cfg);
	ev = event_new(base, -1, EV_PERSIST | EV_READ, cb, NULL);
	event_add(ev, NULL);
	event_active(ev, EV_WRITE, 0);
	event_base_loop(base, 0);
	return 0;
}
#endif