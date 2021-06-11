#include <iostream>
#include <event2/event.h>
#include <event2/listener.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>

using namespace std;

static void accept_conn_cb(struct evconnlistener *listener, evutil_socket_t fd,
		struct sockaddr* addr, int len, void *ptr) {
	/* get libevent event_base from listener */
	struct event_base* base = evconnlistener_get_base(listener);
	cout << "accept a link" << endl;
}

int main(int argc, char** argv) {
	struct event_base* base;

	base = event_base_new();

	struct sockaddr_in sin;

	/* init addr 初始化绑定地址和端口*/
	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_addr.s_addr = htonl(0);
	sin.sin_port = htons(6666);

	struct evconnlistener* listener;

	/* init a libevent listener 给event_base绑定地址和端口，设置监听属性，
	 * 设置回调函数
	 * （如果使用evconnlistenner_new函数的话需要自己来绑定端口和初始化socket，并把socket_fd传递给该函数）*/
	listener = evconnlistener_new_bind(base, accept_conn_cb, NULL,
			LEV_OPT_CLOSE_ON_FREE | LEV_OPT_REUSEABLE, -1,
			(struct sockaddr*) &sin, sizeof(sin));

	/* start loop for accept_conn_cb */
	event_base_dispatch(base);

	return 0;
}
