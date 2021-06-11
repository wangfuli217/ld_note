struct ev_loop *epoller = ev_loop_new (EVBACKEND_EPOLL | EVFLAG_NOENV);
if (!epoller)
    fatal ("no epoll found here, maybe it hides under your chair");
    
struct ev_loop *loop = ev_loop_new (ev_recommended_backends () | EVBACKEND_KQUEUE);
    
    