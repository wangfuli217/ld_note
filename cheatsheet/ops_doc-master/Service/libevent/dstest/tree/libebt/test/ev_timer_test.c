#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ebt.h>

struct ev_param {
    char buf[256];
    struct timeval tv;
};

void tcb (short num, void *arg) {
    struct ev_param *evp = (struct ev_param *) arg;
    printf ("tcb was invoke: [ev_param=%p] [tv.tv_sec=%d] [tv.tv_usec=%d] [buf=%s]", arg, evp->tv.tv_sec, evp->tv.tv_usec, evp->buf);
    printf ("tcb was invoke: [num=%d]", num);
}

int main (void) {
    srand ((unsigned) time (NULL));

    struct eb_t *ebt = ebt_new (E_READ | E_WRITE | E_TIMER);

    for (j = 0; j < 10; j++) {
        struct ev_param *dt = calloc (1, sizeof (struct ev_param));
        memcpy (dt->buf, buf, strlen (buf) + 1);
        tv.tv_sec = rand () % 15 + 5;
        tv.tv_usec = 0;
        dt->tv = tv;

        struct ev *ev = ev_timer (&tv, tcb, dt);
        rev = ev_attach (ev, ebt);
    }

    ebt_loop (ebt);
    ebt_free (ebt);

    return 0;
}
