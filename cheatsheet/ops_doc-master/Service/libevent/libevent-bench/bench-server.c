/*
 * Copyright (c) 2010 Christopher Davis
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <sys/queue.h>
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#ifndef WIN32
#include <signal.h>
#endif
#include <unistd.h>
#include <event2/event.h>
#include <event2/event_struct.h>
#include <event2/listener.h>
#include <event2/bufferevent.h>
#include <event2/bufferevent_ssl.h>

#include <openssl/ssl.h>
#include <openssl/pem.h>

#include "bench-log.h"
#include "bench-messages.h"
#include "ssl-utils.h"

#define DEFAULT_PLAIN_ADDR "127.0.0.1:5501"
#define DEFAULT_SSL_ADDR "127.0.0.1:5502"
#define RATE_MAX 0x7fffffff

static void conn_read_cb(struct bufferevent *bev, void *_conn);
static void conn_write_cb(struct bufferevent *bev, void *_conn);
static void conn_event_cb(struct bufferevent *bev, short what, void *_conn);

// components:
// 	Client
//	Server

struct ssl_listener_info {
	SSL_CTX *ctx;
	X509 *cert;
	EVP_PKEY *key;
};

struct data_stats {
	ev_uint64_t bytes_written;
	ev_uint64_t messages_written;
	ev_uint64_t bytes_read;
	ev_uint64_t messages_read;
};

struct conn {
	ev_uint32_t id;
	struct bufferevent *bev;
	struct message *inmsg;
	struct message *outmsg;
	struct evbuffer *inbuf;
	struct evbuffer *outbuf;
	struct property_list properties;
	long notifications;
	struct data_stats data_total;
	struct data_stats data_pending;
};

/* valid client id's start at one. if a client has an id of zero, the
   connection hasn't finished handshaking yet. */
static ev_uint32_t id_count = 1;
static size_t active_conns_allocated = 0;
static struct conn **active_conns = NULL;
static struct evconnlistener *listener_plain = NULL;
static struct evconnlistener *listener_ssl = NULL;
static struct file_list server_files;
static ev_uint32_t global_read_rate = RATE_MAX;
static ev_uint32_t global_write_rate = RATE_MAX;
static ev_uint32_t bucket_tick = 1000;
static int print_stats_interval = 5;
static struct bufferevent_rate_limit_group *global_rate_limit = NULL;
static struct data_stats global_data_stats = {0,0,0,0};
static struct data_stats global_data_stats_last = {0,0,0,0};

static int
active_conns_add(struct conn *conn)
{
	struct conn **newconns;
	size_t amt = active_conns_allocated;

	assert(conn->id == 0);
	conn->id = id_count++;

	while (conn->id >= amt) {
		if (amt < 16)
			amt = 16;
		else
			amt <<= 1;
		newconns = realloc(active_conns, amt * sizeof(struct conn *));
		if (!newconns)
			return -1;
		memset(newconns + active_conns_allocated, 0,
		       (amt - active_conns_allocated) * sizeof(struct conn *));
		active_conns_allocated = amt;
		active_conns = newconns;
	}

	assert(active_conns[conn->id] == NULL);
	active_conns[conn->id] = conn;

	return 0;
}

static inline int
conn_has_handshaked(struct conn *conn)
{
	return conn->id != 0;
}

static void
active_conns_del(struct conn *conn)
{
	if (!conn_has_handshaked(conn))
		return;
	assert(active_conns[conn->id] == conn);
	active_conns[conn->id] = NULL;
}

static inline struct conn *
active_conns_get(ev_uint32_t id)
{
	if (id >= active_conns_allocated)
		return NULL;
	return active_conns[id];
}

static void
conn_destroy(struct conn *conn)
{
	active_conns_del(conn);
	if (conn->inmsg)
		message_destroy(conn->inmsg);
	if (conn->outmsg)
		message_destroy(conn->outmsg);
	if (conn->bev)
		bufferevent_free(conn->bev);
	free(conn);
}

static struct conn *
conn_new(struct event_base *base, struct bufferevent *cbev)
{
	struct conn *conn;

	conn = calloc(1, sizeof(*conn));
	if (!conn)
		return NULL;

	conn->bev = cbev;
	conn->inmsg = message_new();
	if (!conn->inmsg)
		goto out;
	conn->outmsg = message_new();
	if (!conn->outmsg)
		goto out;
	conn->inbuf = bufferevent_get_input(cbev);
	conn->outbuf = bufferevent_get_output(cbev);
	TAILQ_INIT(&conn->properties);

	return conn;

out:
	conn_destroy(conn);

	return NULL;
}

static void
conn_update_write_stats(struct conn *conn)
{
	conn->data_pending.messages_written++;
	conn->data_pending.bytes_written +=
		message_get_total_length(conn->outmsg);
}

static void
conn_update_read_stats(struct conn *conn)
{
	conn->data_total.messages_read++;
	conn->data_total.bytes_read +=
		message_get_total_length(conn->inmsg);
	global_data_stats.messages_read++;
	global_data_stats.bytes_read +=
		message_get_total_length(conn->inmsg);
}

static void
conn_create(struct event_base *base, struct bufferevent *bev)
{
	struct conn *conn;

	conn = conn_new(base, bev);
	if (!conn) {
		log_error("server: unable to create connection.");
		return;
	}

	bufferevent_setcb(bev, conn_read_cb, conn_write_cb,
			  conn_event_cb, conn);

	bufferevent_enable(bev, EV_READ|EV_WRITE);

	if (global_rate_limit)
		bufferevent_add_to_rate_limit_group(bev, global_rate_limit);
}

static void
conn_send_error(struct conn *conn, const char *what)
{
	log_warn("server: error: %s", what);
	message_encode_error(conn->outmsg, what, conn->outbuf);
	conn_update_write_stats(conn);
}

static inline void
conn_send_peer_notice(struct conn *conn, struct conn *peer)
{
	if (!conn->notifications)
		return;
	message_encode_peer_notice(conn->outmsg, peer->id,
			&peer->properties, conn->outbuf);
	conn_update_write_stats(conn);
	conn->notifications--;
}

static int
conn_finish_setup(struct conn *conn)
{
	ev_uint32_t i;

	if (message_parse_payload(conn->inmsg) != MSGST_OK) {
		log_warn("server: handshake with client failed");
		return -1;
	}

	property_list_move(&conn->properties,
			   message_payload_get_properties(conn->inmsg));

	conn->notifications = 0;
	property_list_find_long(&conn->properties, "max_peer_notifications",
				&conn->notifications);
	if (conn->notifications) {
		log_debug("server: client %u can recv %ld peer notifications",
			  (unsigned)conn->id, conn->notifications);
	}

	active_conns_add(conn);

	/* Let everyone know about this new peer */
	message_encode_greeting_rsp(conn->outmsg, conn->id, conn->outbuf);
	conn_update_write_stats(conn);

	for (i = 0; i < id_count; ++i) {
		struct conn *ac = active_conns[i];
		if (!ac)
			continue;
		conn_send_peer_notice(ac, conn);
		conn_send_peer_notice(conn, ac);
	}

	return 0;
}

static int
conn_relay_chat(struct conn *conn)
{
	struct conn *dest_conn;

	dest_conn = active_conns_get(message_get_destination(conn->inmsg));
	if (!dest_conn) {
		conn_send_error(conn, "unknown destination");
		return -1;
	}

	message_encode_relay(conn->outmsg, conn->inmsg, dest_conn->outbuf);
	conn_update_write_stats(conn);
	
	return 0;
}

static int
conn_send_file(struct conn *conn)
{
	struct conn *dest_conn;
	struct file_entry *fe;
	const char *fname;
	int found;
	FILE *fp;
	char buf[1024];
	size_t amt;

	if (message_parse_payload(conn->inmsg) != MSGST_OK) {
		log_warn("server: invalid file request");
		return -1;
	}

	dest_conn = active_conns_get(message_get_destination(conn->inmsg));
	if (!dest_conn) {
		conn_send_error(conn, "destination unknown");
		return 0;
	}

	fname = message_payload_get_file_name(conn->inmsg);
	assert(fname != NULL);

	found = 0;
	TAILQ_FOREACH(fe, &server_files, next) {
		if (!strcmp(fe->name, fname)) {
			found = 1;
			break;
		}
	}
	if (!found) {
		conn_send_error(conn, "unknown file");
		return 0;
	}

	fp = fopen(fname, "rb");
	if (!fp) {
		log_error("server: unable to open %s!", fname);
		conn_send_error(conn, "unable to open file");
		return 0;
	}

	/* XXX this isn't very efficient */
	while ((amt = fread(buf, 1, sizeof(buf), fp)))
		evbuffer_add(message_get_payload(conn->outmsg), buf, amt);

	fclose(fp);

	message_encode_file_contents(dest_conn->outmsg,
		message_get_origin(conn->inmsg), dest_conn->id,
		dest_conn->outbuf);

	conn_update_write_stats(conn);
	
	return 0;
}

static int
conn_read_message(struct conn *conn)
{
	int rv;

	rv = message_read(conn->inmsg, conn->inbuf);
	if (rv <= MSGST_CONT) {
		if (rv == MSGST_FAIL) {
			log_warn("server: received malformed message");
			conn_destroy(conn);
		}
		return -1;
	}

	if (!conn_has_handshaked(conn) &&
	    message_get_type(conn->inmsg) != MSG_GREETING_REQ) {
		log_warn("server: client messaging without greeting first");
		conn_destroy(conn);
		return -1;
	}

	conn_update_read_stats(conn);

	rv = 0;

	switch (message_get_type(conn->inmsg)) {
	case MSG_GREETING_REQ:
		rv = conn_finish_setup(conn);
		break;
	case MSG_SEND_CHAT:
	case MSG_ECHO_REQ:
	case MSG_ECHO_RSP:
		/* Forward a chat message to another client. */
		rv = conn_relay_chat(conn);
		break;
	case MSG_FILE_LIST_REQ:
		message_encode_file_list_rsp(conn->outmsg, &server_files,
					     conn->outbuf);
		conn_update_write_stats(conn);
		break;
	case MSG_SEND_FILE:
		rv = conn_send_file(conn);
		break;

	/* These messages shouldn't be sent to the server. */
	case MSG_PEER_NOTICE:
	case MSG_FILE_CONTENTS:
	case MSG_OK:
	case MSG_ERROR:
	case MSG_FILE_LIST_RSP:
	case MSG_GREETING_RSP:
		conn_send_error(conn, "server received invalid message");
		break;
	}

	message_reset(conn->inmsg);
	message_reset(conn->outmsg);

	if (rv < 0)
		conn_destroy(conn);

	return rv;
}

static void
conn_read_cb(struct bufferevent *bev, void *_conn)
{
	struct conn *conn = _conn;

	while (evbuffer_get_length(conn->inbuf) &&
	       !conn_read_message(conn))
		;
}

static void
conn_write_cb(struct bufferevent *bev, void *_conn)
{
	struct conn *conn = _conn;

	global_data_stats.messages_written +=
		conn->data_pending.messages_written;
	global_data_stats.bytes_written +=
		conn->data_pending.bytes_written;

	conn->data_total.messages_written +=
		conn->data_pending.messages_written;
	conn->data_total.bytes_written +=
		conn->data_pending.bytes_written;

	memset(&conn->data_pending, 0, sizeof(conn->data_pending));
}

static void
conn_event_cb(struct bufferevent *bev, short what, void *_conn)
{
	struct conn *conn = _conn;

	/* SSL */
	if (what & BEV_EVENT_CONNECTED)
		return;

	if (what & BEV_EVENT_ERROR) {
		log_warn("server: socket error: %s",
			 evutil_socket_error_to_string(
				evutil_socket_geterror(-1)));
	} else {
		log_debug("server: connection %u closed", (unsigned)conn->id);
	}

	conn_destroy(conn);
}

static void
print_stats_cb(evutil_socket_t s, short what, void *arg)
{
	double messages_written_per_sec;
	double bytes_written_per_sec;
	double messages_read_per_sec;
	double bytes_read_per_sec;
	
	messages_written_per_sec =
		(double)(global_data_stats.messages_written -
			 global_data_stats_last.messages_written) /
		(double)print_stats_interval;

	bytes_written_per_sec =
		(double)(global_data_stats.bytes_written -
			 global_data_stats_last.bytes_written) /
		(double)print_stats_interval;

	messages_read_per_sec =
		(double)(global_data_stats.messages_read -
			 global_data_stats_last.messages_read) /
		(double)print_stats_interval;

	bytes_read_per_sec =
		(double)(global_data_stats.bytes_read -
			 global_data_stats_last.bytes_read) /
		(double)print_stats_interval;

	memcpy(&global_data_stats_last, &global_data_stats,
		sizeof(global_data_stats));

	// XXX need to measure latency

	log_notice("server: rates, msgs w/sec %lf, bytes w/sec %lf, "
		   "msgs r/sec %lf, bytes r/sec %lf",
		   messages_written_per_sec,
		   bytes_written_per_sec,
		   messages_read_per_sec,
		   bytes_read_per_sec);
}

static void
listener_cb(struct evconnlistener *listener, evutil_socket_t s,
	    struct sockaddr *addr, int socklen, void *arg)
{
	struct ssl_listener_info *info = arg;
	struct event_base *base;
	struct bufferevent *bev;

	base = evconnlistener_get_base(listener);

	if (info) {
		SSL *ssl = SSL_new(info->ctx);
		SSL_use_certificate(ssl, info->cert);
		SSL_use_PrivateKey(ssl, info->key);

		bev = bufferevent_openssl_socket_new(base, s, ssl,
				BUFFEREVENT_SSL_ACCEPTING,
				BEV_OPT_CLOSE_ON_FREE);
	} else {
		bev = bufferevent_socket_new(base, s, BEV_OPT_CLOSE_ON_FREE);
	}

	conn_create(base, bev);
}

static void
usage(void)
{
	printf("usage: server [-lsrwtvqi] [file1 file2 ...]\n");
	printf("-l [ plain_listen_addr | none ]\n"
	       "-s [ ssl_listen_addr | none ]\n"
	       "-r global_read_rate_bps\n"
	       "-w global_write_rate_bps\n"
               "-t bucket_tick_ms\n"
	       "-i print_stats_interval_sec\n");
	exit(0);
}

static int
set_global_rate_limit(struct event_base *base)
{
	struct ev_token_bucket_cfg *cfg;
	struct timeval tick = {0,0};

	if (global_read_rate < RATE_MAX || global_write_rate < RATE_MAX) {
		tick.tv_usec = bucket_tick * 1000;
		cfg = ev_token_bucket_cfg_new(global_read_rate,
				global_read_rate, global_write_rate,
				global_write_rate, &tick);
		if (!cfg) {
			log_error("server: can't allocate rate limit cfg!");
			return -1;
		}
		global_rate_limit = bufferevent_rate_limit_group_new(base, cfg);
		if (!global_rate_limit) {
			log_error("server: can't allocate rate limit group!");
			return -1;
		}
	}

	return 0;
}

static int
start_listeners(struct event_base *base,
		const struct sockaddr *plain_addr, int plain_len,
		const struct sockaddr *ssl_addr, int ssl_len)
{
	static struct ssl_listener_info info;

	if (plain_len >= 0) {
		listener_plain = evconnlistener_new_bind(base, listener_cb,
				NULL, LEV_OPT_CLOSE_ON_FREE|LEV_OPT_REUSEABLE,
				-1, plain_addr, plain_len);
		if (!listener_plain) {
			log_error("server: couldn't start plain listener!");
			return -1;
		}
		evconnlistener_enable(listener_plain);
	}

	if (ssl_len >= 0) {
		ssl_init();
		info.key = ssl_build_key();
		if (!info.key) {
			log_error("server: can't build key for ssl listener");
			return -1;
		}
		info.cert = ssl_build_cert(info.key);
		if (!info.cert) {
			log_error("server: can't build cert for ssl listener");
			return -1;
		}
		info.ctx = SSL_CTX_new(SSLv23_method());
		if (!info.ctx) {
			log_error("server: can't allocate ssl ctx");
			return -1;
		}
		listener_ssl = evconnlistener_new_bind(base, listener_cb, &info,
				LEV_OPT_CLOSE_ON_FREE|LEV_OPT_REUSEABLE, -1,
				ssl_addr, ssl_len);
		if (!listener_ssl) {
			log_error("server: couldn't start ssl listener!");
			return -1;
		}
		evconnlistener_enable(listener_ssl);
	}


	return 0;
}

int
main(int argc, char **argv)
{
	struct event_base *base;
	struct event print_stats;
	int ssl_len, plain_len;
	int c, rv, i;
	struct timeval interval;
	struct sockaddr_storage listener_plain_addr;
	struct sockaddr_storage listener_ssl_addr;
#ifdef WIN32
	WORD wVersionRequested = MAKEWORD(2,2);
	WSADATA wsaData;

	WSAStartup(wVersionRequested, &wsaData);
#else
	signal(SIGPIPE, SIG_IGN);
#endif

	ssl_len = plain_len = sizeof(struct sockaddr_storage);
	
	evutil_parse_sockaddr_port(DEFAULT_PLAIN_ADDR,
				(struct sockaddr *)&listener_plain_addr,
				&plain_len);
	evutil_parse_sockaddr_port(DEFAULT_SSL_ADDR,
				(struct sockaddr *)&listener_ssl_addr,
				&ssl_len);

	log_set_file(NULL);

	while ((c = getopt(argc, argv, "l:s:r:w:t:i:vq")) != -1) {
		switch (c) {
		case 'l':
			plain_len = sizeof(struct sockaddr_storage);
			rv = evutil_parse_sockaddr_port(optarg,
				(struct sockaddr *)&listener_ssl_addr,
				&plain_len);
			if (rv < 0)
				plain_len = -1;
			break;
		case 's':
			ssl_len = sizeof(struct sockaddr_storage);
			rv = evutil_parse_sockaddr_port(optarg,
				(struct sockaddr *)&listener_plain_addr,
				&ssl_len);
			if (rv < 0)
				ssl_len = -1;
			break;
		case 'r':
			global_read_rate = atoi(optarg);	
			break;
		case 'w':
			global_write_rate = atoi(optarg);	
			break;
		case 't':
			bucket_tick = atoi(optarg);	
			break;
		case 'i':
			print_stats_interval = atoi(optarg);
			break;
		case 'v':
			log_lower_min_level();
			break;
		case 'q':
			log_raise_min_level();
			break;
		default:
			usage();
		}
	}

	argc -= optind;
	argv += optind;

	if (plain_len < 0 && ssl_len < 0)
		usage();
		
	TAILQ_INIT(&server_files);
	for (i = 0; i < argc; ++i)
		file_list_add(&server_files, argv[i]);

	base = event_base_new();
	if (!base) {
		log_error("server: couldn't base event base!");
		return 0;
	}
	if (set_global_rate_limit(base) < 0)
		return 0;
	if (start_listeners(base,
	    (struct sockaddr*)&listener_plain_addr, plain_len,
	    (struct sockaddr*)&listener_ssl_addr, ssl_len) < 0)
		return 0;

	event_assign(&print_stats, base, -1, EV_TIMEOUT | EV_PERSIST,
		     print_stats_cb, NULL);
	interval.tv_usec = 0;
	interval.tv_sec = print_stats_interval;

	// XXX perhaps wait to start the timer until after the tests
	// have started
	event_add(&print_stats, &interval);
	
	event_base_dispatch(base);

	return 0;
}
