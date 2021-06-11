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

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifndef WIN32
#include <signal.h>
#endif
#include <unistd.h>
#include <event2/event.h>
#include <event2/buffer.h>
#include <event2/bufferevent.h>
#include <event2/bufferevent_ssl.h>
#include <event2/util.h>

#include <openssl/ssl.h>
#include <openssl/pem.h>

#include "bench-log.h"
#include "bench-messages.h"
#include "ssl-utils.h"

#define DEFAULT_PLAIN_ADDR "127.0.0.1:5501"
#define DEFAULT_SSL_ADDR "127.0.0.1:5502"

struct peer {
	ev_uint32_t id;
	struct property_list properties;
};

struct client {
	ev_uint32_t id;
	int ssl;
	struct peer **friends;
	struct property_list properties;
	struct bufferevent *bev;
	struct evbuffer *inbuf;
	struct evbuffer *outbuf;
	struct message *inmsg;
	struct message *outmsg;
	TAILQ_ENTRY(client) next;
};
TAILQ_HEAD(client_list, client);

static void client_event_cb(struct bufferevent *bev, short what, void *_client);
static void client_read_cb(struct bufferevent *bev, void *_client);
static void client_write_cb(struct bufferevent *bev, void *_client);

static size_t ssl_divisor = 3;
static size_t num_friends = 4;
static size_t num_clients = 64;
static size_t num_clients_connected = 0;
static size_t num_peers_expected = 64;
static size_t num_peers = 0;
static struct peer *peers = NULL;
static int association_complete = 0;
static struct client_list all_clients;
static struct file_list server_files;
static size_t max_messages_queued = 16;
static size_t message_data_len = 2048;
static char *message_data = NULL;

static void
client_do_chat(struct client *client)
{
	size_t i, j;

	/* TODO use a greater range of tests */	
	for (i = 0; i < num_friends; ++i) {
		for (j = 0; j < max_messages_queued; ++j) {
			message_encode_send_chat(client->outmsg, client->id,
					client->friends[i]->id, message_data,
					message_data_len, client->outbuf);
		}
	}
}

static void
associate_peers_with_clients(void)
{
	struct client *client;
	size_t i, j;

	if (association_complete)
		return;	
	if (num_clients_connected < num_clients)
		return;
	if (num_peers < num_peers_expected)
		return;

	log_notice("client: associating with peers, sending messages");

	TAILQ_FOREACH(client, &all_clients, next) {
		client->friends = calloc(num_friends, sizeof(struct peer));
		if (!client->friends)
			log_fatal("client: can't allocate friend list!");
		/* XXX there could be better ways of selecting peers */
		for (i = rand(), j = 0; j < num_friends; ++i) {
			struct peer *p = &peers[i % num_peers];
			if (client->id == p->id)
				continue;
			client->friends[j++] = p;
		}

		client_do_chat(client);
	}

	association_complete = 1;
}

static void
client_destroy(struct client *client)
{
	TAILQ_REMOVE(&all_clients, client, next);
	property_list_clear(&client->properties);
	if (client->inmsg)
		message_destroy(client->inmsg);
	if (client->outmsg)
		message_destroy(client->outmsg);
	if (client->bev)
		bufferevent_free(client->bev);
	if (client->friends)
		free(client->friends);
	free(client);
}

static struct client *
client_new(struct event_base *base, SSL_CTX *ctx)
{
	struct client *client;

	client = calloc(1, sizeof(*client));
	if (!client)
		return NULL;

	TAILQ_INIT(&client->properties);
	TAILQ_INSERT_TAIL(&all_clients, client, next);

	/* Use SSL or no? */
	if (ctx) {
		SSL *ssl;

		ssl = SSL_new(ctx);
		if (!ssl)
			goto out;
		client->bev = bufferevent_openssl_socket_new(base, -1, ssl,
					BUFFEREVENT_SSL_CONNECTING,
					BEV_OPT_CLOSE_ON_FREE);
		client->ssl = 1;
	} else {
		client->bev = bufferevent_socket_new(base, -1,
					BEV_OPT_CLOSE_ON_FREE);
	}

	if (!client->bev)
		goto out;

	client->inmsg = message_new();
	if (!client->inmsg)
		goto out;
	client->outmsg = message_new();
	if (!client->outmsg)
		goto out;

	client->inbuf = bufferevent_get_input(client->bev);
	client->outbuf = bufferevent_get_output(client->bev);

	bufferevent_setcb(client->bev, client_read_cb, client_write_cb,
			  client_event_cb, client);
	bufferevent_enable(client->bev, EV_READ | EV_WRITE);

	return client;

out:
	client_destroy(client);

	return NULL;
}

static int
client_finish_setup(struct client *client)
{
	if (message_parse_payload(client->inmsg) != MSGST_OK) {
		log_warn("client: malformed data recieved from server");
		return -1;
	}

	client->id = message_get_destination(client->inmsg);
	num_clients_connected++;

	log_debug("client: %u/%u connection setup complete. (id = %u)",
		  (unsigned)num_clients_connected, (unsigned)num_clients,
		  (unsigned)client->id);

	associate_peers_with_clients();

	return 0;	
}

static int
client_add_peer(struct client *client)
{
	size_t i;

	if (num_peers == num_peers_expected) {
		log_notice("client: ignoring peer notice");
		return 0;
	}

	if (message_parse_payload(client->inmsg) != MSGST_OK) {
		log_warn("client: malformed data recieved from server");
		return -1;
	}

	i = num_peers++;
	peers[i].id = message_get_origin(client->inmsg);
	TAILQ_INIT(&peers[i].properties);
	property_list_move(&peers[i].properties,
			   message_payload_get_properties(client->inmsg));

	log_debug("client: %u/%u added peer %u", (unsigned)num_peers,
		  (unsigned)num_peers_expected, (unsigned)peers[i].id);

	associate_peers_with_clients();

	return 0;
}

static int
client_set_file_list(struct client *client)
{
	if (message_parse_payload(client->inmsg) != MSGST_OK) {
		log_warn("client: malformed data recieved from server");
		return -1;
	}

	file_list_clear(&server_files);
	file_list_move(&server_files,
		       message_payload_get_files(client->inmsg));

	return 0;
}

static void
client_event_cb(struct bufferevent *bev, short what, void *_client)
{
	struct client *client = _client;

	if (what & BEV_EVENT_CONNECTED) {
		message_encode_greeting_req(client->outmsg, &client->properties,
				client->outbuf);
	} else if (what & BEV_EVENT_ERROR) {
		log_warn("client: socket error: %s",
			  evutil_socket_error_to_string(
				evutil_socket_geterror(-1)));
		client_destroy(client);
	} else if (what & BEV_EVENT_EOF) {
		log_notice("client: connection closed");
		client_destroy(client);
	}
}

static int
client_read_message(struct client *client)
{
	int rv;
	
	rv = message_read(client->inmsg, client->inbuf);
	if (rv <= MSGST_CONT) {
		if (rv == MSGST_FAIL) {
			log_error("client: received malformed message");
			client_destroy(client);
		}
		return -1;
	}

	rv = 0;

	switch (message_get_type(client->inmsg)) {
	case MSG_GREETING_RSP:
		rv = client_finish_setup(client);
		break;
	case MSG_PEER_NOTICE:
		rv = client_add_peer(client);
		break;
	case MSG_FILE_LIST_RSP:
		rv = client_set_file_list(client);
		break;
	case MSG_ECHO_REQ:
	case MSG_ECHO_RSP:
	case MSG_FILE_CONTENTS:
	case MSG_SEND_CHAT:
	case MSG_OK:
	case MSG_ERROR:
		// TODO
		break;
	
	/* These messages shouldn't be sent to the client. */
	case MSG_GREETING_REQ:
	case MSG_FILE_LIST_REQ:
	case MSG_SEND_FILE:
		rv = -1;
		log_warn("client: received invalid message");
		break;
	}

	message_reset(client->inmsg);
	message_reset(client->outmsg);
	if (rv < 0)
		client_destroy(client);

	return rv;
}

static void
client_read_cb(struct bufferevent *bev, void *_client)
{
	struct client *client = _client;

	while (evbuffer_get_length(client->inbuf) &&
	       !client_read_message(client))
		;
}

static void
client_write_cb(struct bufferevent *bev, void *_client)
{
	struct client *client = _client;

	if (association_complete)
		client_do_chat(client);
}

static int
connect_clients(struct event_base *base, struct sockaddr *plain_addr,
		int plain_len, struct sockaddr *ssl_addr, int ssl_len)
{
	size_t i;
	struct client *client;
	struct sockaddr *saddr;
	int len;
	SSL_CTX *ctx = NULL;

	log_notice("client: starting %u clients", (unsigned)num_clients);
	log_notice("client: expecting %u peers", (unsigned)num_peers_expected);
	
	if (ssl_addr && ssl_len >= 0) {
		log_notice("client: starting %u ssl clients",
			   (unsigned)(num_clients / ssl_divisor));
		ssl_init();
		ctx = SSL_CTX_new(SSLv23_method());
		if (!ctx) {
			log_error("client: can't allocate ssl ctx!");
			return -1;
		}
	}
			
	for (i = 0; i < num_clients; ++i) {
		if (ctx && !(i % ssl_divisor)) {
			saddr = ssl_addr;
			len = ssl_len;
			client = client_new(base, ctx);
		} else {
			saddr = plain_addr;
			len = plain_len;
			client = client_new(base, NULL);
		}
		if (!client) {
			log_error("client: can't allocate client!");
			return -1;
		}
		/* only first client accepts peer notification msgs */
		property_list_add_long(&client->properties,
				"max_peer_notifications",
				i?0:num_peers_expected);

		bufferevent_socket_connect(client->bev, saddr, len);
	}

	return 0;
}

static int
initialize_globals(void)
{
	size_t i;

	TAILQ_INIT(&all_clients);

	message_data = malloc(message_data_len);
	if (!message_data) {
		log_error("client: can't allocate message data!");
		return -1;
	}

	/* load some printable chars into the message */ 
	for (i = 0; i < message_data_len; ++i)
		message_data[i] = 33 + (i % 94);

	peers = calloc(num_peers_expected, sizeof(struct peer));
	if (!peers) {
		log_error("client: can't allocate peer list!");
		return -1;
	}

	return 0;
}

static void
usage(void)
{
	printf("usage: client [-lsndpm] [-vq]\n");
	printf("-l [ plain_addr | none ]\n"
	       "-s [ ssl_addr | none]\n"
	       "-n num_clients\n"
	       "-d ssl_divisor (n_ssl_clients = num_clients / ssl_divisor)\n"
	       "-p num_peers_expected\n"
	       "-m message_data_len\n");
	exit(0);
}

int
main(int argc, char **argv)
{
	struct sockaddr_storage ssl_addr;
	struct sockaddr_storage plain_addr;
	int plain_len, ssl_len;
	struct event_base *base;
	int rv, c;
#ifdef WIN32
	WORD wVersionRequested = MAKEWORD(2,2);
	WSADATA wsaData;

	WSAStartup(wVersionRequested, &wsaData);
#else
	signal(SIGPIPE, SIG_IGN);
#endif


	plain_len = ssl_len = sizeof(struct sockaddr_storage);

	evutil_parse_sockaddr_port(DEFAULT_PLAIN_ADDR,
			(struct sockaddr *)&plain_addr, &plain_len);
	evutil_parse_sockaddr_port(DEFAULT_SSL_ADDR,
			(struct sockaddr *)&ssl_addr, &ssl_len);

	log_set_file(NULL);

	while ((c = getopt(argc, argv, "l:s:n:d:p:m:vq")) != -1) {
		switch (c) {
		case 'l':
			plain_len = sizeof(struct sockaddr_storage);
			rv = evutil_parse_sockaddr_port(optarg,
				(struct sockaddr *)&plain_addr, &plain_len);
			if (rv < 0)
				plain_len = -1;
			break;
		case 's':
			ssl_len = sizeof(struct sockaddr_storage);
			rv = evutil_parse_sockaddr_port(optarg,
				(struct sockaddr *)&ssl_addr, &ssl_len);
			if (rv < 0)
				ssl_len = -1;
			break;
		case 'n':
			num_clients = atoi(optarg);
			break;
		case 'd':
			ssl_divisor = atoi(optarg);
			break;
		case 'p':
			num_peers_expected = atoi(optarg);
			break;
		case 'm':
			message_data_len = atoi(optarg);
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

	if (initialize_globals() < 0)
		return 1;

	base = event_base_new();
	if (!base) {
		log_error("client: can't allocate event base!");
		return 0;
	}
	
	if (connect_clients(base,
	    (struct sockaddr *)&plain_addr, plain_len,
	    (struct sockaddr *)&ssl_addr, ssl_len) < 0)
		return 0;

	event_base_dispatch(base);	
			
	return 0;
}
