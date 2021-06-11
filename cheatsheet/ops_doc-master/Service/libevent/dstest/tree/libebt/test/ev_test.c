#include <stdio.h>
#include <stdlib.h>
#include <ebt.h>

void fifo_read (short fd, void *arg) {
    int len;
    char buf[255] = { 0 };

    printf ("%s called", __func__);

    len = read (fd, buf, sizeof (buf) - 1);
    err_msg ("read [errno=%d] [errstr=%s]", errno, strerror (errno));

    if (len == -1) {
        printf ("read!");
        return;
    } else if (len == 0) {
        printf ("connection closed");
        return;
    }
    buf[len] = '\0';
    printf ("read:%s", buf);
}

int create_fifo (const char *file) {
    struct stat st;

    if (lstat (file, &st) == 0) {
        if ((st.st_mode & S_IFMT) == S_IFREG) {
            printf ("lstat");
            exit (1);
        }
    }
    unlink (file);

    if (mkfifo (file, 0600) == -1) {
        printf ("mkfifo");
        exit (1);
    }

    int fd;
    fd = open (file, O_RDWR | O_NONBLOCK, 0);

    if (fd == -1) {
        printf ("open");
        exit (1);
    }

    printf ("fifo fd:[%d]", fd);

    return fd;
}

int main (void) {
    //test ebt
    struct eb_t *ebt = ebt_new (E_READ | E_WRITE | E_TIMER | E_FLAG);
    int fd = create_fifo ("ev.fifo");
    struct ev *ev = ev_read (fd, fifo_read, ev);

    ev_attach (ev, ebt);
    ebt_loop (ebt);
    ebt_free (ebt);

    return 0;
}
