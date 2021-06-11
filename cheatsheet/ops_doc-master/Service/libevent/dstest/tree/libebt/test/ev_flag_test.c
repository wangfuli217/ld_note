#include <stdio.h>
#include <stdlib.h>
#include <ebt.h>

void flag_cb (short flag, void *arg) {
    printf ("%s called", __func__);
    printf ("%x | %p", flag, arg);
}

int main (void) {
    struct eb_t *ebt = ebt_new (E_READ | E_WRITE | E_TIMER | E_FLAG);
    int fd = create_fifo ("ev.fifo");
    struct ev *ev = ev_flag (0x0fff, flag_cb, ev);

    ev_opt (ev, E_ONCE);
    ev_attach (ev, ebt);

    ebt_loop (ebt);
    ebt_free (ebt);

    return 0;
}
