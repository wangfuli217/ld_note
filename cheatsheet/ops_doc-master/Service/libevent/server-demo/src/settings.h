#ifndef __SETTINGS_H__
#define __SETTINGS_H__

struct settings {
    int port;
    int num_threads;
    int daemonize;
    int maxconns;
    char *test;
};

#endif
