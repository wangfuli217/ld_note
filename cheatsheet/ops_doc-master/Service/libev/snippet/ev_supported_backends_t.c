assert (("sorry, no epoll, no sex",
    ev_supported_backends () & EVBACKEND_EPOLL));