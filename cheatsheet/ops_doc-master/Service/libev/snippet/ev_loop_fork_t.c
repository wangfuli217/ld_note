static void
post_fork_child (void)
{
    ev_loop_fork (EV_DEFAULT);
}

...
pthread_atfork (0, 0, post_fork_child);


int pthread_atfork(void (*prepare)(void), void (*parent)(void),
              void (*child)(void));