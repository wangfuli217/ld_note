#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#include <event2/event.h>
#include <event2/bufferevent.h>

#define LISTEN_PORT 8000
#define LISTEN_BACKLOG 32

void do_accept_cb(evutil_socket_t listener, short event, void *arg);
void read_cb(struct bufferevent *bev, void *arg);
void error_cb(struct bufferevent *bev, short event, void *arg);
void write_cb(struct bufferevent *bev, void *arg);

int main(int argc, char *argv[])
{
    int ret;
    evutil_socket_t listener;
    listener = socket(AF_INET, SOCK_STREAM, 0);
    if(listener < 0)
    {
        printf("socket error!\n");
        return 1;
    }

    evutil_make_listen_socket_reuseable(listener);//端口重用，查看源码evutil.c中可以知道就是对setsockopt做了层封装,之所以这样做是因为为了和Win32 networking API兼容

    struct sockaddr_in sin;
    sin.sin_family = AF_INET;
    sin.sin_addr.s_addr=htonl(INADDR_ANY);
    sin.sin_addr.s_addr=inet_addr("127.0.0.1");
    sin.sin_port = htons(LISTEN_PORT);

    if (bind(listener, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
        perror("bind");
        return 1;
    }

    if (listen(listener, LISTEN_BACKLOG) < 0) {
        perror("listen");
        return 1;
    }

　　printf ("Listening...\n");
　　
　　evutil_make_socket_nonblocking(listener);//设置为非阻塞模式，查看源码evutil.c中可以知道就是对fcntl做了层封装
　　
　　    struct event_base *base = event_base_new();//创建一个event_base对象也既是创建了一个新的libevent实例
　　    if (!base) {
　　        fprintf(stderr, "Could not initialize libevent!\n");
　　        return 1;
　　    }
　　
　　    //创建并绑定一个event
　　    struct event *listen_event;
　　    listen_event = event_new(base, listener, EV_READ|EV_PERSIST, do_accept_cb, (void*)base);
　　    event_add(listen_event, NULL);//注册时间，参数NULL表示无超时设置
　　    event_base_dispatch(base);//）程序进入无限循环，等待就绪事件并执行事件处理
　　
　　    printf("The End.");
　　    return 0;
　　}
　　
　　void do_accept_cb(evutil_socket_t listener, short event, void *arg)
　　{
　　    struct event_base *base = (struct event_base *)arg;
　　    evutil_socket_t fd;
　　    struct sockaddr_in sin;
　　    socklen_t slen;
　　    fd = accept(listener, (struct sockaddr *)&sin, &slen);
　　    if (fd < 0) {
　　        perror("accept");
　　        return;
　　    }
　　
　　    printf("accept: fd = %u\n", fd);
　　
　　    //使用bufferevent_socket_new创建一个struct bufferevent *bev，关联该sockfd，托管给event_base
　　    struct bufferevent *bev = bufferevent_socket_new(base, fd, BEV_OPT_CLOSE_ON_FREE);//BEV_OPT_CLOSE_ON_FREE表示释放buff
　　//erevent时关闭底层传输端口。这将关闭底层套接字，释放底层bufferevent等。
　　
　　    bufferevent_setcb(bev, read_cb, NULL, error_cb, arg);
　　    bufferevent_enable(bev, EV_READ|EV_WRITE|EV_PERSIST);//启用read/write事件
　　}
　　
　　void read_cb(struct bufferevent *bev, void *arg)
　　{
　　#define MAX_LINE    256
　　    char line[MAX_LINE+1];
　　    int n;
　　    evutil_socket_t fd = bufferevent_getfd(bev);
　　
　　    while (n = bufferevent_read(bev, line, MAX_LINE), n > 0) {
　　        line[n] = '\0';
　　        printf("fd=%u, read line: %s\n", fd, line);
　　
　　        bufferevent_write(bev, line, n);
　　    }
　　}
　　
　　void write_cb(struct bufferevent *bev, void *arg) {}
　　
　　void error_cb(struct bufferevent *bev, short event, void *arg)
　　{
　　    evutil_socket_t fd = bufferevent_getfd(bev);
　　    printf("fd = %u, ", fd);
　　    if (event & BEV_EVENT_TIMEOUT) {
　　        printf("Timed out\n"); //if bufferevent_set_timeouts() called
　　    }
　　    else if (event & BEV_EVENT_EOF) {
　　        printf("connection closed\n");
　　    }
　　    else if (event & BEV_EVENT_ERROR) {
　　        printf("some other error\n");
　　    }
　　    bufferevent_free(bev);
　　}