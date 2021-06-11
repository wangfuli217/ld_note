#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
//#include <sys/types.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <fcntl.h>
#include <sys/epoll.h>
#include <sys/time.h>
#include <sys/resource.h>
#define MAXBUF 1024
#define MAXEPOLLSIZE 10000

struct myevent_s {
     int fd;
     void (*call_back)(int fd, int events, void *arg);
     int events;
     void *arg;
     int status; // 1: in epoll wait list, 0 not in
     char buff[128]; // recv data buffer
     int len;
     long last_active; // last active time
 };
typedef struct myevent_s myevent_s;


int g_epoll_fd = -1;
myevent_s g_events[MAXEPOLLSIZE + 1]; // g_events[MAXEPOLLSIZE] is used
int keep_alive = 1; // enable keepalive
int keep_idle = 60; // if no data comes in,then begin to probe, unit is second.
int keep_interval = 5; // time interval for probe, unit is second.
int keep_count = 3; // total times of probe

void receive_data(int fd, int events, void *arg);
void send_data(int fd, int events, void *arg);

 // set event
void event_set(myevent_s *ev, int fd, void (*call_back)(int, int, void*), void *arg) {
     ev->fd = fd;
     ev->call_back = call_back;
     ev->events = 0;
     ev->arg = arg; 
     ev->status = 0;  
     ev->last_active = time(NULL);  
 }

 // add/mod an event to epoll  
 void event_add(int epoll_fd, int events, myevent_s *ev) {
     struct epoll_event epv = {0, {0}};
     int op;
     epv.data.ptr = ev;
     epv.events = ev->events = events;
     if(ev->status == 1){
         op = EPOLL_CTL_MOD;
     }else{
         op = EPOLL_CTL_ADD;
         ev->status = 1;
     }
     if(epoll_ctl(epoll_fd, op, ev->fd, &epv) < 0)
         printf("event add failed[fd=%d]\n", ev->fd);
     else
         printf("event add OK[fd=%d]\n", ev->fd);
 }

 // delete an event from epoll  
 void event_del(int epoll_fd, myevent_s *ev) {
     struct epoll_event epv = {0, {0}};
     if(ev->status != 1) return;
     epv.data.ptr = ev;
     ev->status = 0;
     epoll_ctl(epoll_fd, EPOLL_CTL_DEL, ev->fd, &epv);
 }

int setnonblocking(int sockfd){
    if (fcntl(sockfd, F_SETFL, fcntl(sockfd, F_GETFD, 0)|O_NONBLOCK) == -1){
        return -1;
    }
    return 0;
}

// accept new connections from clients  
void accept_conn(int fd, int events, void *arg){
     struct sockaddr_in sin;
     socklen_t len = sizeof(struct sockaddr_in);
     int nfd, i;
     // accept
     if((nfd = accept(fd, (struct sockaddr*)&sin, &len)) == -1){
	 if(errno == EPERM){//Firewall rules forbid connection on linux platform.
	     printf("%s: firewall not permitted", __func__);
	 }else if(errno != EAGAIN && errno != EINTR){
		 //if errno == EAGAIN try again;
             printf("%s: bad accept", __func__);  
         }
         return;
     }
     do {  //find the first unused slot
         for(i = 0; i < MAXEPOLLSIZE; i++) {
             if(g_events[i].status == 0){
                 break;
             }
         }
	 
         if(i ==  MAXEPOLLSIZE){
             printf("%s:max connection limit[%d].", __func__,  MAXEPOLLSIZE);
             break;
         }
         // set nonblocking
         if(fcntl(nfd, F_SETFL, O_NONBLOCK) < 0) break;
         // add a read event for receive data
         event_set(&g_events[i], nfd, receive_data, &g_events[i]);
         event_add(g_epoll_fd, EPOLLIN|EPOLLET, &g_events[i]);
         printf("new conn[%s:%d][time:%d]\n", inet_ntoa(sin.sin_addr), ntohs(sin.sin_port), g_events[i].last_active);
     }while(0);
 }

void send_data(int fd, int events, void *arg) {
     struct myevent_s *ev = (struct myevent_s*)arg;
     int len;
     // send data
     len = send(fd, ev->buff, ev->len, 0);
     ev->len = 0;
     event_del(g_epoll_fd, ev);
     if(len > 0){// change to receive event
         event_set(ev, fd, receive_data, ev);
         event_add(g_epoll_fd, EPOLLIN|EPOLLET, ev);
     }else{
         close(ev->fd);
         printf("send_data[fd=%d] error[%d]\n", fd, errno);
     }
 }

void receive_data(int fd, int events, void *arg)  {
     struct myevent_s *ev = (struct myevent_s*)arg;  
     int len;
     // receive data
     len = recv(fd, ev->buff, sizeof(ev->buff)-1, 0);
     event_del(g_epoll_fd, ev);
     if(len > 0)  {
         ev->len = len;
         ev->buff[len] = '\0';
         printf("C[%d]:%s\n", fd, ev->buff);
         // change to send event
         event_set(ev, fd, send_data, ev);
         event_add(g_epoll_fd, EPOLLOUT|EPOLLET, ev);
     }  else if(len == 0)  {
         close(ev->fd);
         printf("[fd=%d] closed gracefully.\n", fd);
     }  else{
         close(ev->fd);
         printf("receive_data[fd=%d] error[%d]:%s\n", fd, errno, strerror(errno));
     }
 }
 
void init_listen_socket(int epoll_fd, short port) {
     int listen_fd = socket(AF_INET, SOCK_STREAM, 0);
     fcntl(listen_fd, F_SETFL, O_NONBLOCK); // set non-blocking
     printf("server listen fd=%d\n\r", listen_fd);
#if 1
     setsockopt(listen_fd, SOL_SOCKET, SO_KEEPALIVE, (void *)&keep_alive, sizeof(keep_alive));
     setsockopt(listen_fd, SOL_TCP, TCP_KEEPIDLE, (void*)&keep_idle, sizeof(keep_idle));
     setsockopt(listen_fd, SOL_TCP, TCP_KEEPINTVL, (void *)&keep_interval, sizeof(keep_interval));
     setsockopt(listen_fd, SOL_TCP, TCP_KEEPCNT, (void *)&keep_count, sizeof(keep_count)); 
#endif
     event_set(&g_events[ MAXEPOLLSIZE], listen_fd, accept_conn, &g_events[ MAXEPOLLSIZE]);  //set as the last one to decrease find-time for new conn slot
     // add listen socket
     event_add(epoll_fd, EPOLLIN|EPOLLET, &g_events[MAXEPOLLSIZE]);
     // bind & listen
     struct sockaddr_in sin;
     bzero(&sin, sizeof(sin));
     sin.sin_family = AF_INET;
     sin.sin_addr.s_addr = INADDR_ANY;
     sin.sin_port = htons(port);
     bind(listen_fd, (const struct sockaddr*)&sin, sizeof(sin));
     listen(listen_fd, 5);
 }


int main(int argc, char **argv)
{
    unsigned int port = 12345;
    struct epoll_event ev, events[MAXEPOLLSIZE];
    struct rlimit rt;

    /* set max numb of file resource in this process */
    rt.rlim_max = rt.rlim_cur = MAXEPOLLSIZE;
    if (setrlimit(RLIMIT_NOFILE, &rt) == -1){
        perror("setrlimit");
        exit(1);
    }else{
        printf("set RLIMIT_NOFILE successfully.\n\r");
    }
   
    g_epoll_fd = epoll_create(MAXEPOLLSIZE);
    if(g_epoll_fd <= 0) printf("create epoll failed.%d\n", g_epoll_fd);

    init_listen_socket(g_epoll_fd, port);
    int check_pos = 0;

    while (1) {
	    //a simple timeout check here, every time 100, better to use a mini-heap, and add timer event
	long now = time(NULL);
	for(int i = 0; i < 100; i++, check_pos++){ // doesn't check listen fd
             if(check_pos == MAXEPOLLSIZE) check_pos = 0; // recycle
             if(g_events[check_pos].status != 1) continue;
             long duration = now - g_events[check_pos].last_active;
             if(duration >= 3600){ //3600s timeout
                 close(g_events[check_pos].fd);
                 printf("[fd=%d] timeout[%d--%d].\n", g_events[check_pos].fd, g_events[check_pos].last_active, now);
                 event_del(g_epoll_fd, &g_events[check_pos]);
             }
         }
        /* wait for some event */
        int nfds = epoll_wait(g_epoll_fd, events, MAXEPOLLSIZE, -1);
        if (nfds == -1){
            perror("epoll_wait");
            break;
        }
        /* handle all events */
        for (int i = 0; i < nfds; ++i){
             myevent_s *ev = (struct myevent_s*)events[i].data.ptr;
             if((events[i].events&EPOLLIN)&&(ev->events&EPOLLIN)){ // read event
                 ev->call_back(ev->fd, events[i].events, ev->arg);
             }
             if((events[i].events&EPOLLOUT)&&(ev->events&EPOLLOUT)){ // write event
                 ev->call_back(ev->fd, events[i].events, ev->arg);
             }
        }
    }
    if(g_epoll_fd > 0)
	    close(g_epoll_fd);
    return 0;
}
