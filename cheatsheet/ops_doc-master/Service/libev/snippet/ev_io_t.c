#include <stdio.h>
#include <ev.h>

ev_io stdin_watcher;
ev_io stdout_watcher;

static void
stdin_cb (EV_P_ ev_io *w, int revents)
{
	printf("w->fd = %d\n", w->fd);
	puts ("stdin ready");
	ev_io_stop (EV_A_ w); 
	ev_break (EV_A_ EVBREAK_ALL);
}

int
main (void)
{
    struct ev_loop *loop = EV_DEFAULT;
    ev_io_init (&stdin_watcher, stdin_cb, 0, EV_READ);
    ev_io_init (&stdout_watcher, stdout_cb, 1, EV_WRITE);
    ev_io_start (loop, &stdin_watcher);
    ev_io_start (loop, &stdout_watcher);
    ev_run (loop, 0);
    return 0;
}