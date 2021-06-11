#ifndef NETWORK_H
#define NETWORK_H
#include "terminal_define.h"

#define FORWARD_OUT 1
#define STAY_IN  2
extern struct conn_queue REQ;
extern struct conn_queue RSP;
extern struct settings settings;
extern int notify_receive_fd;
extern int notify_send_fd;

int process_command(conn *c, char *command);

int try_read_command(conn *c);

int try_read_network(conn *c);

void drive_machine(conn *c);

void event_handler(const int fd, const short which, void *arg);

void notify_handler(const int fd, const short which, void *arg);

int new_socket();

int server_socket(const int port);

int update_event(conn *c, const int new_flags);
#endif //NETWORK_H
