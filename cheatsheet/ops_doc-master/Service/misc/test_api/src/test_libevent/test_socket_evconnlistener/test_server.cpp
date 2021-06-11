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

	/* init addr ��ʼ���󶨵�ַ�Ͷ˿�*/
	memset(&sin, 0, sizeof(sin));
	sin.sin_family = AF_INET;
	sin.sin_addr.s_addr = htonl(0);
	sin.sin_port = htons(6666);

	struct evconnlistener* listener;

	/* init a libevent listener ��event_base�󶨵�ַ�Ͷ˿ڣ����ü������ԣ�
	 * ���ûص�����
	 * �����ʹ��evconnlistenner_new�����Ļ���Ҫ�Լ����󶨶˿ںͳ�ʼ��socket������socket_fd���ݸ��ú�����*/
	listener = evconnlistener_new_bind(base, accept_conn_cb, NULL,
			LEV_OPT_CLOSE_ON_FREE | LEV_OPT_REUSEABLE, -1,
			(struct sockaddr*) &sin, sizeof(sin));

	/* start loop for accept_conn_cb */
	event_base_dispatch(base);

	return 0;
}
