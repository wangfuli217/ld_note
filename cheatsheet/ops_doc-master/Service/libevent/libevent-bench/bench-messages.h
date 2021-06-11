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

#ifndef _BENCH_MESSAGES_H_
#define _BENCH_MESSAGES_H_

#include <sys/queue.h>
#include <event2/util.h>
#include <event2/buffer.h>

enum message_status {
	MSGST_FAIL = -1,
	MSGST_CONT = 0,
	MSGST_OK = 1
};

enum message_type {
	MSG_UNKNOWN,

	MSG_TYPE_MIN,

	MSG_GREETING_REQ,
	MSG_GREETING_RSP,

	MSG_PEER_NOTICE,

	MSG_FILE_LIST_REQ,
	MSG_FILE_LIST_RSP,

	MSG_SEND_CHAT,

	MSG_ECHO_REQ,
	MSG_ECHO_RSP,

	MSG_SEND_FILE,
	MSG_FILE_CONTENTS,
	
	MSG_OK,
	MSG_ERROR,

	MSG_TYPE_MAX,
};

struct property {
	char *name;
	char *value;
	TAILQ_ENTRY(property) next;
};
TAILQ_HEAD(property_list, property);

struct file_entry {
	char *name;
	// XXX need more file meta data?
	TAILQ_ENTRY(file_entry) next;
};
TAILQ_HEAD(file_list, file_entry);

struct message;

int property_list_add(struct property_list *props, const char *k,
		      const char *v);
int property_list_add_long(struct property_list *props, const char *k, long v);
void property_list_clear(struct property_list *props);
void property_list_move(struct property_list *to, struct property_list *from);
const char *property_list_find(struct property_list *props, const char *name);
int property_list_find_long(struct property_list *props,
		        const char *name, long *lv);

int file_list_add(struct file_list *files, const char *name);
void file_list_clear(struct file_list *files);
void file_list_move(struct file_list *to, struct file_list *from);

struct message *message_new(void);
void message_reset(struct message *msg);
void message_destroy(struct message *msg);
int message_parse_header(struct message *msg, struct evbuffer *buf);
int message_read_payload(struct message *msg, struct evbuffer *buf);
int message_read(struct message *msg, struct evbuffer *buf);
int message_parse_payload(struct message *msg);
size_t message_encode_buf(struct message *msg, struct evbuffer *payload,
		   struct evbuffer *outbuf);
size_t message_encode(struct message *msg, struct evbuffer *outbuf);
size_t message_encode_ref(struct message *msg, const void *data, size_t len,
		   struct evbuffer *outbuf);
size_t message_encode_relay(struct message *outmsg, struct message *inmsg,
		     struct evbuffer *outbuf);
size_t message_encode_greeting_req(struct message *msg,
				struct property_list *props,
				struct evbuffer *outbuf);
size_t message_encode_greeting_rsp(struct message *msg, ev_uint32_t client_id,
			    struct evbuffer *outbuf);
size_t message_encode_peer_notice(struct message *msg, ev_uint32_t peer_id,
			   const struct property_list *props,
			   struct evbuffer *outbuf);
size_t message_encode_file_list_req(struct message *msg,
			struct evbuffer *outbuf);
size_t message_encode_file_list_rsp(struct message *msg,
		struct file_list *files, struct evbuffer *outbuf);
size_t message_encode_send_chat(struct message *msg, ev_uint32_t origin,
			 ev_uint32_t dest, const void *chat, size_t len,
			 struct evbuffer *outbuf);
size_t message_encode_echo_req(struct message *msg, ev_uint32_t origin,
			ev_uint32_t dest, const void *echo, size_t len,
			struct evbuffer *outbuf);
size_t message_encode_echo_rsp(struct message *msg, struct message *echo,
			struct evbuffer *outbuf);
size_t message_encode_send_file(struct message *msg, ev_uint32_t origin,
			 ev_uint32_t dest, const char *fn,
			 struct evbuffer *outbuf);
size_t message_encode_file_contents(struct message *msg, ev_uint32_t origin,
			     ev_uint32_t dest, struct evbuffer *outbuf);
size_t message_encode_ok(struct message *msg, struct evbuffer *outbuf);
size_t message_encode_error(struct message *msg, const char *errmsg,
		     struct evbuffer *outbuf);

struct evbuffer *message_get_payload(struct message *msg);
size_t message_get_total_length(const struct message *msg);
ev_uint32_t message_get_type(const struct message *msg);
ev_uint32_t message_get_length(const struct message *msg);
ev_uint32_t message_get_origin(const struct message *msg);
ev_uint32_t message_get_destination(const struct message *msg);
const char *message_payload_get_error_msg(const struct message *msg);
const char *message_payload_get_file_name(const struct message *msg);
struct property_list *message_payload_get_properties(struct message *msg);
struct file_list *message_payload_get_files(struct message *msg);

#endif
