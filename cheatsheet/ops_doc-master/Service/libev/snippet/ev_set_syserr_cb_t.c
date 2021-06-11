static void
fatal_error (const char *msg){
    perror (msg);
    abort ();
}

...
ev_set_syserr_cb (fatal_error);