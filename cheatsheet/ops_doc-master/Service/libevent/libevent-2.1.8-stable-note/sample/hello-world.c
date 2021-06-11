/*
  This example program provides a trivial server program that listens for TCP
  connections on port 9995.  When they arrive, it writes a short message to
  each client connection, and closes each connection once it is flushed.

  Where possible, it exits cleanly in response to a SIGINT (ctrl-c).
*/


#include <string.h>
#include <errno.h>
#include <stdio.h>
#include <signal.h>
#ifndef _WIN32
#include <netinet/in.h>
# ifdef _XOPEN_SOURCE_EXTENDED
#  include <arpa/inet.h>
# endif
#include <sys/socket.h>
#endif

#include <event2/bufferevent.h>
#include <event2/buffer.h>
#include <event2/listener.h>
#include <event2/util.h>
#include <event2/event.h>

static const char MESSAGE[] = "Hello, World!\n";

static const int PORT = 9995;

// 监听回调函数（即一个新链接到来的时候的回调函数）
static void listener_cb(struct evconnlistener *, evutil_socket_t,
    struct sockaddr *, int socklen, void *);
// 写回调函数
static void conn_writecb(struct bufferevent *, void *);
// 客户端关闭回调函数
static void conn_eventcb(struct bufferevent *, short, void *);
// 信号处理函数
static void signal_cb(evutil_socket_t, short, void *);

int
main(int argc, char **argv){
	struct event_base *base;
	struct evconnlistener *listener;
	struct event *signal_event;

	struct sockaddr_in sin;
#ifdef _WIN32
	WSADATA wsa_data;
	WSAStartup(0x0201, &wsa_data);
#endif

    // 创建一个event_base实例（即一个Reactor实例）
	base = event_base_new();
	if (!base) {
		fprintf(stderr, "Could not initialize libevent!\n");
		return 1;
	}

	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_port = htons(PORT);

     // 创建一个监听器
	listener = evconnlistener_new_bind(base, listener_cb, (void *)base,
	    LEV_OPT_REUSEABLE|LEV_OPT_CLOSE_ON_FREE, -1,
	    (struct sockaddr*)&sin,
	    sizeof(sin));

	if (!listener) {
		fprintf(stderr, "Could not create a listener!\n");
		return 1;
	}

    // 创建一个信号事件处理器,要处理的信号是SIGINT
	signal_event = evsignal_new(base, SIGINT, signal_cb, (void *)base);

    // 将事件处理器添加到event_base的事件处理器注册队列中
	if (!signal_event || event_add(signal_event, NULL)<0) {
		fprintf(stderr, "Could not create/add a signal event!\n");
		return 1;
	}

     // 进入循环
	event_base_dispatch(base);

    // 释放连接监听器,事件处理器,event_base对象
	evconnlistener_free(listener);
	event_free(signal_event);
	event_base_free(base);

	printf("done\n");
	return 0;
}

// 接受到新链接时的回调函数
static void
listener_cb(struct evconnlistener *listener, evutil_socket_t fd,
    struct sockaddr *sa, int socklen, void *user_data)
{
	struct event_base *base = user_data;
	struct bufferevent *bev;

    // 为客户端sockfd创建一个缓冲区, BEV_OPT_CLOSE_ON_FREE 表示当释放 bufferevent 将关闭这个传输端口
	bev = bufferevent_socket_new(base, fd, BEV_OPT_CLOSE_ON_FREE);
	if (!bev) {
		fprintf(stderr, "Error constructing bufferevent!");
		event_base_loopbreak(base);
		return;
	}
    // 设置缓存区的回调函数
	bufferevent_setcb(bev, NULL, conn_writecb, conn_eventcb, NULL);
    // 启用缓存区的写功能,bufferevent将自动尝试在输出缓冲区具有足够数据时将数据写入其文件描述符
	bufferevent_enable(bev, EV_WRITE);
    // 禁用缓冲区的读功能
	bufferevent_disable(bev, EV_READ);

    // 缓冲区写给socket
    bufferevent_write(bev, MESSAGE, strlen(MESSAGE));
}

// 写回调函数
static void
conn_writecb(struct bufferevent *bev, void *user_data)
{
    // 输出buffer
	struct evbuffer *output = bufferevent_get_output(bev);
    // 判断数据是否已经发送完成
    if (evbuffer_get_length(output) == 0) {
		printf("flushed answer\n");
        // 释放缓冲区，因为设置了BEV_OPT_CLOSE_ON_FREE 也会关闭这个socket
		bufferevent_free(bev);
	}
}

// 其他事件的回调函数
static void
conn_eventcb(struct bufferevent *bev, short events, void *user_data)
{
	if (events & BEV_EVENT_EOF) {
        // 如果是客户端主动关闭
		printf("Connection closed.\n");
	} else if (events & BEV_EVENT_ERROR) {
        // 连接上产生一个错误
		printf("Got an error on the connection: %s\n",
		    strerror(errno));/*XXX win32*/
	}
	/* None of the other events can happen here, since we haven't enabled
	 * timeouts */
	bufferevent_free(bev);
}

// 信号处理回调函数
static void
signal_cb(evutil_socket_t sig, short events, void *user_data)
{
	struct event_base *base = user_data;
	struct timeval delay = { 2, 0 };

	printf("Caught an interrupt signal; exiting cleanly in two seconds.\n");

    // 退出事件循环
	event_base_loopexit(base, &delay);
}
