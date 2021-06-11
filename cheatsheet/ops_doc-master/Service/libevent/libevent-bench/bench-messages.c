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

#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include "bench-messages.h"

struct message {
	ev_uint32_t type;
	ev_uint32_t length;
	ev_uint32_t origin_id;
	ev_uint32_t destination_id;
	ev_uint32_t length_remaining;
	struct evbuffer *payload;
	
	union {
		struct property_list properties;
		struct file_list files;
		char *error_msg;
		char *file_name;
	} pl;
};

static char *
pop_string(struct evbuffer *buf, ev_ssize_t n)
{
	char *str;
	size_t len;

	len = evbuffer_get_length(buf);
	if (n >= 0 && n < len)
		len = n;

	str = malloc(len + 1);
	if (!str)
		return NULL;
	str[len] = '\0';
	evbuffer_remove(buf, str, len);

	return str;
}

static ev_uint32_t
pop_uint32(struct evbuffer *buf)
{
	ev_uint32_t n;

	evbuffer_remove(buf, &n, sizeof(n));
	
	return ntohl(n);
}

static void
push_uint32(struct evbuffer *buf, ev_uint32_t n)
{
	n = htonl(n);
	evbuffer_add(buf, &n, sizeof(n));
}

int
property_list_add(struct property_list *props, const char *k, const char *v)
{
	struct property *prop;

	prop = calloc(1, sizeof(*prop));
	if (!prop)
		return MSGST_FAIL;

	prop->name = strdup(k);
	if (!prop->name)
		goto out;
	prop->value = strdup(v);
	if (!prop->value)
		goto out;

	TAILQ_INSERT_TAIL(props, prop, next);

	return MSGST_OK;

out:
	if (prop->name)
		free(prop->name);
	if (prop->value)
		free(prop->value);
	free(prop);

	return MSGST_FAIL;
}

int
property_list_add_long(struct property_list *props, const char *k, long v)
{
	char buf[128];

	evutil_snprintf(buf, sizeof(buf), "%ld", v);
	
	return property_list_add(props, k, buf);
}

static int
property_list_parse(struct property_list *props, struct evbuffer *buf)
{
	char *ln = NULL;
	char *p;

	while ((ln = evbuffer_readln(buf, NULL, EVBUFFER_EOL_ANY))) {
		p = strchr(ln, ' ');
		if (!p)
			goto out;
		*p = '\0';
		p++;
		if (property_list_add(props, ln, p) != MSGST_OK)
			goto out;
		free(ln);
	}

	return MSGST_OK;

out:
	if (ln)
		free(ln);
	return MSGST_FAIL;
}

static void
property_list_encode(const struct property_list *props, struct evbuffer *buf)
{
	struct property *prop;
	
	TAILQ_FOREACH(prop, props, next)
		evbuffer_add_printf(buf, "%s %s\n", prop->name, prop->value);
}

void
property_list_clear(struct property_list *props)
{
	struct property *prop;

	while ((prop = TAILQ_FIRST(props))) {
		TAILQ_REMOVE(props, prop, next);
		free(prop->name);
		free(prop->value);
		free(prop);
	}
}

void
property_list_move(struct property_list *to, struct property_list *from)
{
	struct property *prop;

	while ((prop = TAILQ_FIRST(from))) {
		TAILQ_REMOVE(from, prop, next);
		TAILQ_INSERT_TAIL(to, prop, next);
	}
}

const char *
property_list_find(struct property_list *props, const char *name)
{
	struct property *prop;

	TAILQ_FOREACH(prop, props, next) {
		if (!strcmp(prop->name, name))
			return prop->value;
	}

	return NULL;
}

int
property_list_find_long(struct property_list *props,
		        const char *name, long *lv)
{
	const char *v;
	char *endp = NULL;
	long tmp;

	v = property_list_find(props, name);
	if (!v)
		return -1;
	
	errno = 0;
	tmp = strtol(v, &endp, 10);
	if (errno == ERANGE || !endp || endp == v || *endp != '\0')
		return -1;
	
	*lv = tmp;

	return 0;
}

int
file_list_add(struct file_list *files, const char *name)
{
	struct file_entry *fe;

	fe = calloc(1, sizeof(*fe));
	if (!fe)
		return MSGST_FAIL;
	fe->name = strdup(name);
	if (!fe->name) {
		free(fe);
		return MSGST_FAIL;
	}

	TAILQ_INSERT_TAIL(files, fe, next);

	return MSGST_OK;
}

static int
file_list_parse(struct file_list *files, struct evbuffer *buf)
{
	int rv;
	char *ln = NULL;

	while ((ln = evbuffer_readln(buf, NULL, EVBUFFER_EOL_ANY))) {
		rv = file_list_add(files, ln);
		free(ln);
		if (rv != MSGST_OK)
			return rv;
	}

	return MSGST_OK;
}

static void
file_list_encode(const struct file_list *files, struct evbuffer *buf)
{
	struct file_entry *fe;

	TAILQ_FOREACH(fe, files, next)
		evbuffer_add_printf(buf, "%s\n", fe->name);
}

void
file_list_clear(struct file_list *files)
{
	struct file_entry *fe;

	while ((fe = TAILQ_FIRST(files))) {
		TAILQ_REMOVE(files, fe, next);
		free(fe->name);
		free(fe);
	}
}

void
file_list_move(struct file_list *to, struct file_list *from)
{
	struct file_entry *fe;

	while ((fe = TAILQ_FIRST(from))) {
		TAILQ_REMOVE(from, fe, next);
		TAILQ_INSERT_TAIL(to, fe, next);
	}
}

struct message *
message_new(void)
{
	struct message *msg;

	msg = calloc(1, sizeof(*msg));
	if (!msg)
		return NULL;

	msg->payload = evbuffer_new();
	if (!msg->payload) {
		free(msg);
		return NULL;
	}

	return msg;
}

void
message_reset(struct message *msg)
{
	/* clear parsed payload */
	switch (msg->type) {
	case MSG_PEER_NOTICE:
	case MSG_GREETING_REQ:
		property_list_clear(&msg->pl.properties);
		break;
	case MSG_FILE_LIST_RSP:
		file_list_clear(&msg->pl.files);
		break;
	case MSG_ERROR:
		if (msg->pl.error_msg)
			free(msg->pl.error_msg);
		msg->pl.error_msg = NULL;
		break;
	case MSG_SEND_FILE:
		if (msg->pl.file_name)
			free(msg->pl.file_name);
		msg->pl.file_name = NULL;
		break;
	}

	msg->type = MSG_UNKNOWN;
	msg->destination_id = 0;
	msg->length = 0;
	msg->length_remaining = 0;
	evbuffer_drain(msg->payload, evbuffer_get_length(msg->payload));
}

void
message_destroy(struct message *msg)
{
	message_reset(msg);
	evbuffer_free(msg->payload);
	free(msg);
}

int
message_parse_header(struct message *msg, struct evbuffer *buf)
{
	assert(msg->type == MSG_UNKNOWN);
	if (evbuffer_get_length(buf) < 16)
		return MSGST_CONT;

	msg->type = pop_uint32(buf);
	msg->length = pop_uint32(buf);
	msg->origin_id = pop_uint32(buf);
	msg->destination_id = pop_uint32(buf);
	msg->length_remaining = msg->length;

	if (msg->type <= MSG_TYPE_MIN ||
	    msg->type >= MSG_TYPE_MAX)
		return MSGST_FAIL;

	return MSGST_OK;
}

int
message_read_payload(struct message *msg, struct evbuffer *buf)
{
	int amt;

	amt = evbuffer_remove_buffer(buf, msg->payload, msg->length_remaining);
	assert(amt <= msg->length_remaining);
	msg->length_remaining -= amt;
	if (msg->length_remaining)
		return MSGST_CONT;

	return MSGST_OK;
}

int
message_read(struct message *msg, struct evbuffer *buf)
{
	int rv;

	if (msg->type == MSG_UNKNOWN) {
		rv = message_parse_header(msg, buf);
		if (rv != MSGST_OK)
			return rv;
	}

	rv = message_read_payload(msg, buf);

	return rv;
}

int
message_parse_payload(struct message *msg)
{
	assert(msg->type != MSG_UNKNOWN);

	switch (msg->type) {
	case MSG_GREETING_REQ:
		TAILQ_INIT(&msg->pl.properties);
		return property_list_parse(&msg->pl.properties, msg->payload);
	case MSG_GREETING_RSP:
		break;

	case MSG_PEER_NOTICE:
		TAILQ_INIT(&msg->pl.properties);
		return property_list_parse(&msg->pl.properties, msg->payload);
		
	case MSG_FILE_LIST_REQ:
		break;
	case MSG_FILE_LIST_RSP:
		TAILQ_INIT(&msg->pl.files);
		return file_list_parse(&msg->pl.files, msg->payload);

	case MSG_SEND_CHAT:
		break;

	case MSG_ECHO_REQ:
		break;
	case MSG_ECHO_RSP:
		break;

	case MSG_SEND_FILE:
		msg->pl.file_name = pop_string(msg->payload, -1);
		if (!msg->pl.file_name)
			return MSGST_FAIL;
		break;
	case MSG_FILE_CONTENTS:
		break;
	
	case MSG_OK:
		break;

	case MSG_ERROR:
		msg->pl.error_msg = pop_string(msg->payload, -1);
		if (!msg->pl.error_msg)
			return MSGST_FAIL;
		break;

	default:
		abort();
	}

	return MSGST_OK;
}

size_t
message_encode_buf(struct message *msg, struct evbuffer *payload,
		   struct evbuffer *outbuf)
{
	msg->length = evbuffer_get_length(payload);
	evbuffer_expand(outbuf, 16);
	push_uint32(outbuf, msg->type);
	push_uint32(outbuf, msg->length);
	push_uint32(outbuf, msg->origin_id);
	push_uint32(outbuf, msg->destination_id);
	evbuffer_add_buffer(outbuf, payload);

	return msg->length + 16;
}

size_t
message_encode(struct message *msg, struct evbuffer *outbuf)
{
	return message_encode_buf(msg, msg->payload, outbuf);
}

size_t
message_encode_ref(struct message *msg, const void *data, size_t len,
		   struct evbuffer *outbuf)
{
	msg->length = len;
	evbuffer_expand(outbuf, 16);
	push_uint32(outbuf, msg->type);
	push_uint32(outbuf, msg->length);
	push_uint32(outbuf, msg->origin_id);
	push_uint32(outbuf, msg->destination_id);
	evbuffer_add_reference(outbuf, data, len, NULL, NULL);

	return msg->length + 16;
}

size_t
message_encode_relay(struct message *outmsg, struct message *inmsg,
		     struct evbuffer *outbuf)
{
	outmsg->type = inmsg->type;
	outmsg->origin_id = inmsg->origin_id;
	outmsg->destination_id = inmsg->destination_id;
	return message_encode_buf(outmsg, inmsg->payload, outbuf);
}

size_t
message_encode_greeting_req(struct message *msg, struct property_list *props,
			    struct evbuffer *outbuf)
{
	msg->type = MSG_GREETING_REQ;
	msg->origin_id = 0;
	msg->destination_id = 0;
	property_list_encode(props, msg->payload);
	return message_encode(msg, outbuf);
}

size_t
message_encode_greeting_rsp(struct message *msg, ev_uint32_t client_id,
			    struct evbuffer *outbuf)
{
	msg->type = MSG_GREETING_RSP;
	msg->origin_id = 0;
	msg->destination_id = client_id;
	return message_encode(msg, outbuf);
}

size_t
message_encode_peer_notice(struct message *msg, ev_uint32_t peer_id,
			   const struct property_list *props,
			   struct evbuffer *outbuf)
{
	msg->type = MSG_PEER_NOTICE;
	msg->origin_id = peer_id;
	msg->destination_id = 0;
	property_list_encode(props, msg->payload);
	return message_encode(msg, outbuf);
}

size_t
message_encode_file_list_req(struct message *msg, struct evbuffer *outbuf)
{
	msg->type = MSG_FILE_LIST_REQ;
	msg->origin_id = 0;
	msg->destination_id = 0;
	return message_encode(msg, outbuf);
}

size_t
message_encode_file_list_rsp(struct message *msg, struct file_list *files,
			     struct evbuffer *outbuf)
{
	msg->type = MSG_FILE_LIST_RSP;
	msg->origin_id = 0;
	msg->destination_id = 0;
	file_list_encode(files, msg->payload);
	return message_encode(msg, outbuf);
}

size_t
message_encode_send_chat(struct message *msg, ev_uint32_t origin,
			 ev_uint32_t dest, const void *chat, size_t len,
			 struct evbuffer *outbuf)
{
	msg->type = MSG_SEND_CHAT;
	msg->origin_id = origin;
	msg->destination_id = dest;
	return message_encode_ref(msg, chat, len, outbuf);
}

size_t
message_encode_echo_req(struct message *msg, ev_uint32_t origin,
			ev_uint32_t dest, const void *echo, size_t len,
			struct evbuffer *outbuf)
{
	msg->type = MSG_ECHO_REQ;
	msg->origin_id = origin;
	msg->destination_id = dest;
	return message_encode_ref(msg, echo, len, outbuf);
}

size_t
message_encode_echo_rsp(struct message *msg, struct message *echo,
			struct evbuffer *outbuf)
{
	msg->type = MSG_ECHO_RSP;
	msg->origin_id = echo->destination_id;
	msg->destination_id = echo->origin_id;
	evbuffer_add_buffer(msg->payload, echo->payload);
	return message_encode(msg, outbuf);
}

size_t
message_encode_send_file(struct message *msg, ev_uint32_t origin,
			 ev_uint32_t dest, const char *fn,
			 struct evbuffer *outbuf)
{
	msg->type = MSG_SEND_FILE;
	msg->origin_id = origin;
	msg->destination_id = dest;
	evbuffer_add(msg->payload, fn, strlen(fn));
	return message_encode(msg, outbuf);
}

size_t
message_encode_file_contents(struct message *msg, ev_uint32_t origin,
			     ev_uint32_t dest, struct evbuffer *outbuf)
{
	msg->type = MSG_FILE_CONTENTS;
	msg->origin_id = origin;
	msg->destination_id = dest;
	return message_encode(msg, outbuf);
}

size_t
message_encode_ok(struct message *msg, struct evbuffer *outbuf)
{
	msg->type = MSG_OK;
	msg->origin_id = 0;
	msg->destination_id = 0;
	return message_encode(msg, outbuf);
}

size_t
message_encode_error(struct message *msg, const char *errmsg,
		     struct evbuffer *outbuf)
{
	msg->type = MSG_ERROR;
	msg->origin_id = 0;
	msg->destination_id = 0;
	evbuffer_add(msg->payload, errmsg, strlen(errmsg));
	return message_encode(msg, outbuf);
}

struct evbuffer *
message_get_payload(struct message *msg)
{
	return msg->payload;
}

size_t
message_get_total_length(const struct message *msg)
{
	return 16 + msg->length;
}

ev_uint32_t
message_get_type(const struct message *msg)
{
	return msg->type;
}

ev_uint32_t
message_get_length(const struct message *msg)
{
	return msg->length;
}

ev_uint32_t
message_get_origin(const struct message *msg)
{
	return msg->origin_id;
}

ev_uint32_t
message_get_destination(const struct message *msg)
{
	return msg->destination_id;
}

const char *
message_payload_get_error_msg(const struct message *msg)
{
	return msg->pl.error_msg;
}

const char *
message_payload_get_file_name(const struct message *msg)
{
	return msg->pl.file_name;
}

struct property_list *
message_payload_get_properties(struct message *msg)
{
	return &msg->pl.properties;
}

struct file_list *
message_payload_get_files(struct message *msg)
{
	return &msg->pl.files;
}
