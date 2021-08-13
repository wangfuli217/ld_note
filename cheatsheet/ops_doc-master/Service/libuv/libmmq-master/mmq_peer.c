#ifdef WIN32
#define _CRT_RAND_S
#endif

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>

#include "mmq.h"
#include "mmq_msg.h"
#include "uv.h"


struct _mmq_peer_t;

typedef struct _mmq_peer_sub_t {
    char topic[MMQ_MSG_TOPIC_MAX_SIZE];
    struct _mmq_peer_sub_t* next;
} _mmq_peer_sub_t;

typedef struct {
    struct _mmq_peer_t* peer;
    struct _mmq_msg_t* msg;
    uv_write_t write_req;
} _mmq_write_req_t;


typedef struct _mmq_peer_t {
    struct sockaddr_in ip_addr;
    int ip_type;
    int flags;
    char id[MMQ_PEER_ID_MAX_SIZE];

    uv_connect_t uv_connect;
    uv_tcp_t uv_tcp_socket;
    uv_loop_t* uv_loop;
    uv_write_t uv_write_req;

    int connect_status;
    
    unsigned int send_buf_size;
    unsigned int send_buf_end;
    unsigned int send_buf_start;
    char* send_buf;

    unsigned int recv_buf_size;
    unsigned int recv_buf_end;
    unsigned int recv_buf_start;
    char* recv_buf;

    int inbox_size;
    struct _mmq_msg_t* inbox;
    int outbox_size;
    struct _mmq_msg_t* outbox;


    struct _mmq_peer_sub_t* subscriptions;
    struct _mmq_peer_t* parent;
    struct _mmq_peer_t* next;
    struct _mmq_peer_t* bridge;
} _mmq_peer_t;


void _mmq_peer_connect(_mmq_peer_t* peer);
void _mmq_peer_bind(_mmq_peer_t* peer);
void _mmq_peer_send(_mmq_peer_t* peer, _mmq_msg_t* msg);
void _mmq_peer_gen_id(_mmq_peer_t* peer);
void _mmq_peer_send_hello(_mmq_peer_t* peer);
void _mmq_peer_send_subscribe(_mmq_peer_t* peer, const char* topic);
void _mmq_peer_send_subscriptions(_mmq_peer_t* peer);
void _mmq_peer_append_subscriber(_mmq_peer_t* peer, const char* topic);
void _mmq_peer_flush(_mmq_peer_t* peer);

int _mmq_peer_parse_connection_str(_mmq_peer_t* peer, const char* connection_str) {
    char protocol[8];
    char address[64];
    int port;
    int rc;
    rc = sscanf(connection_str,"%7[^:]://%63[^:]:%i", protocol, address, &port);
    if (rc != 3) {
        return -1;
    }
    if (strcmp(protocol,"tcp") == 0 || strcmp(protocol,"tcp4") == 0) {
        rc = uv_ip4_addr(address, port, &peer->ip_addr);
        if (rc) return -2;
        peer->ip_type = MMQ_PEER_TYPE_TCP;
    } else {
        return -3;
    }
    return 0;
}


void _mmq_peer_gen_id(_mmq_peer_t* peer) {
    bool done = false;
    unsigned int val[3];
#ifdef _CRT_RAND_S
    errno_t err;
    done = true;
    for (int i = 0; i < 3; i++) {
        err = rand_s(val+i);
        if (err != 0) {
            done = false;
            break;
        }
    }
#endif
    if (!done) {
        time_t t;
        srand((unsigned int)time(&t));
        for (int i = 0; i < 3; i++) {
            val[i] = (unsigned int)(INT_MAX*(double)(rand())/RAND_MAX) ;
        }
    }
    static char enc_tbl[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
    char* data = (char*)val;
    memset(peer->id,0,sizeof(peer->id));
    unsigned int length = sizeof(val);
    for (int i = 0, j = 0; i < sizeof(val) && j < MMQ_PEER_ID_MAX_SIZE-1;) {
        unsigned int a = i < length ? (unsigned char)data[i++] : 0;
        unsigned int b = i < length ? (unsigned char)data[i++] : 0;
        unsigned int c = i < length ? (unsigned char)data[i++] : 0;
        uint32_t t = (a << 0x10) + (b << 0x08) + c;
        peer->id[j++] = enc_tbl[(t >> 3 * 6) & 0x3F]; if (j >= MMQ_PEER_ID_MAX_SIZE-1) break;
        peer->id[j++] = enc_tbl[(t >> 2 * 6) & 0x3F]; if (j >= MMQ_PEER_ID_MAX_SIZE-1) break;
        peer->id[j++] = enc_tbl[(t >> 1 * 6) & 0x3F]; if (j >= MMQ_PEER_ID_MAX_SIZE-1) break;
        peer->id[j++] = enc_tbl[(t >> 0 * 6) & 0x3F]; if (j >= MMQ_PEER_ID_MAX_SIZE-1) break;
    }
    //printf("Client ID: %16s\n",peer->id);
}
void _mmq_peer_close_cb(uv_handle_t* handle) {
    _mmq_peer_t* peer = (_mmq_peer_t*)handle->data;
    if (peer->connect_status == MMQ_PEER_STATUS_CLOSED) {
        free(peer);
    }
}
void _mmq_peer_disconnect(_mmq_peer_t* peer) {
    if (peer->connect_status == MMQ_PEER_STATUS_CONNECTED 
        || peer->connect_status == MMQ_PEER_STATUS_LISTENING) {
        uv_close((uv_handle_t*)&peer->uv_tcp_socket, _mmq_peer_close_cb);
    }
    peer->connect_status = MMQ_PEER_STATUS_DISCONNECTED;
    peer->recv_buf_end = 0;
    peer->send_buf_end = 0;
    
}
void _mmq_peer_alloc_buffer(uv_handle_t* handle, size_t suggested_size, uv_buf_t* buf) {
    _mmq_peer_t* peer = (_mmq_peer_t*)handle->data;
    *buf = uv_buf_init((char*) malloc(suggested_size), suggested_size);
}

void _mmq_peer_inbox_append_msg(_mmq_peer_t* peer, _mmq_msg_t* msg) {
    if (peer->inbox == NULL) {
        peer->inbox = msg;
    } else {
        _mmq_msg_t* _msg = peer->inbox;
        while (_msg->next) {
            _msg = _msg->next;
        }
        _msg->next = msg;
    }
    msg->next = NULL;
    peer->inbox_size++;
}
void _mmq_peer_remove_peer(_mmq_peer_t* host, _mmq_peer_t* peer) {
    if (host->next == NULL) return;
    _mmq_peer_t* i = host->next;
    _mmq_peer_t* prev = host;
    while (i) {
        if (i == peer) break;
        prev = i;
        i = i->next;
    }
    if (i) {
        prev->next = i->next;
        //mmq_peer_close((mmq_peer*)&i); //todo: fix potential leak
    }
}

void _mmq_peer_append_peer(_mmq_peer_t* host, _mmq_peer_t* peer) {
    peer->parent = host;
    if (host->next == NULL) {
        host->next = peer;
    } else {
        _mmq_peer_t* i = host->next;
        while (i->next) {
            i = i->next;
        }
        i->next = peer;
    }
    peer->next = NULL;
}

void _mmq_peer_outbox_append_msg(_mmq_peer_t* peer, _mmq_msg_t* msg) {
    if (peer->outbox == NULL) {
        peer->outbox = msg;
    } else {
        _mmq_msg_t* _msg = peer->outbox;
        while (_msg->next) {
            _msg = _msg->next;
        }
        _msg->next = msg;
    }
    msg->next = NULL;
    peer->outbox_size++;
}

void _mmq_peer_clear_inbox(_mmq_peer_t* peer) {
    _mmq_msg_t* msg = peer->inbox;
    while (msg) {
        _mmq_msg_t* next = msg->next;
        mmq_msg_close((mmq_msg*)&msg);
        peer->inbox_size--;
        msg = next;
    }
    peer->inbox = NULL;
}
void _mmq_peer_clear_outbox(_mmq_peer_t* peer) {
    _mmq_msg_t* msg = peer->outbox;
    while (msg) {
        _mmq_msg_t* next = msg->next;
        mmq_msg_close((mmq_msg*)&msg);
        peer->outbox_size--;
        msg = next;
    }
    peer->outbox = NULL;
    
}
_mmq_peer_t* _mmq_peer_find_peer_by_id(_mmq_peer_t* peer, const char* id) {
    if (peer == NULL) return NULL;
    _mmq_peer_t* i = peer->next;
    while (i) {
        if (strcmp(i->id, id) == 0) break;
        i = i->next;
    }
    return i;
}
_mmq_peer_sub_t* _mmq_peer_find_subscriber(_mmq_peer_t* peer, const char* topic) {
    _mmq_peer_sub_t* i = peer->subscriptions;
    if (i == NULL) return NULL;
    while (i) {
        if (strncmp(i->topic, topic, sizeof(i->topic)) == 0) break;
        i = i->next;
    }
    return i;
}
void _mmq_peer_append_subscriber(_mmq_peer_t* peer, const char* topic) {
    _mmq_peer_sub_t* sub = _mmq_peer_find_subscriber(peer, topic);
    if (sub == NULL) {
        sub = (_mmq_peer_sub_t*)malloc(sizeof(_mmq_peer_sub_t));
        sub->next = NULL;
        strncpy(sub->topic, topic, sizeof(sub->topic));
        _mmq_peer_sub_t* i = peer->subscriptions;
        if (i == NULL) {
            peer->subscriptions = sub;
        } else {
            while (i->next) {
                i = i->next;
            }
            i->next = sub;    
        }
    }
}

void _mmq_peer_remove_subscriber(_mmq_peer_t* peer, const char* topic) {
    _mmq_peer_sub_t* i = peer->subscriptions;
    if (i == NULL) {
        return;
    } else {
        _mmq_peer_sub_t* prev = NULL;

        while (i) {
            if (strcmp(i->topic, topic) == 0) {
                break;
            }
            prev = i;
            i = i->next;
        }
        if (i) {
            if (prev) {
                prev->next = i->next;
            } else {
                peer->subscriptions = NULL;
            }
            free(i);
        }


    }
    
}

#ifdef WIN32
#define _mmq_strtok_s strtok_s
#else
#define _mmq_strtok_s strtok_r
#endif
void _mmq_peer_handle_command(_mmq_peer_t* peer, _mmq_msg_t* msg) {
    struct _mmq_peer_t* sender = NULL;
    if (peer->parent) {
        strcpy(peer->id, msg->peer_id);
        sender = _mmq_peer_find_peer_by_id(peer->parent, msg->peer_id);
    }
    //printf("Got Command from %s - %s\n",msg->peer_id, msg->data);
    char* next_tok = NULL;
    char* tok = _mmq_strtok_s(msg->data, " ", &next_tok);

    if (strcmp(tok,"hello") == 0) {
        //printf("Do Command - hello\n");
    } else if (strcmp(tok,"subscribe") == 0) {        
        char* topic = _mmq_strtok_s(NULL, " ", &next_tok);
        if (topic) { 
            //printf("Do Command - subscribe %s\n", topic);
            _mmq_peer_append_subscriber(peer,topic);
        }
    }  else if (strcmp(tok,"unsubscribe") == 0) {        
        char* topic = _mmq_strtok_s(NULL, " ", &next_tok);
        if (topic) { 
            //printf("Do Command - unsubscribe %s\n", topic);
            _mmq_peer_remove_subscriber(peer,topic);
        }
    }
    mmq_msg_close((mmq_msg*)&msg);
}
void _mmq_peer_relay_msg(_mmq_peer_t* peer, _mmq_msg_t* msg) {
    _mmq_peer_t* i = peer->bridge;
    while (i) {
        struct _mmq_msg_t* msg_copy = (_mmq_msg_t*)mmq_msg_copy((mmq_msg)msg);
        mmq_peer_publish((mmq_peer)i, msg_copy->topic, (mmq_msg)msg_copy);
        i = i->next;
    }
}
void _mmq_peer_broadcast(_mmq_peer_t* peer, _mmq_peer_t* sender, _mmq_msg_t* msg) {
    _mmq_peer_t* i = peer->next;
    while (i) {
        _mmq_peer_sub_t* sub = _mmq_peer_find_subscriber(i,msg->topic);
        if (strlen(msg->topic) != 0 && sub) {
            if (strcmp(i->id, sender->id) != 0) {
                _mmq_msg_t* msg_cpy = (_mmq_msg_t*)mmq_msg_copy((mmq_msg)msg);
                _mmq_peer_send(i,msg_cpy);
                _mmq_peer_flush(i);
            }
        } 
        i = i->next;
    }
}
void _mmq_peer_handle_message(_mmq_peer_t* peer, _mmq_msg_t* msg) {
    if (peer->parent) {
        _mmq_peer_t* host = peer->parent;
        _mmq_peer_broadcast(host,peer,msg);
        _mmq_peer_sub_t* sub = _mmq_peer_find_subscriber(peer->parent,msg->topic);
        if (sub) {
            _mmq_peer_inbox_append_msg(peer->parent, msg);
        } else {
            mmq_msg_close((mmq_msg*)&msg);
        }
    } else if (!(peer->flags & MMQ_PEER_FLAG_CLIENT)) {
        _mmq_peer_sub_t* sub = _mmq_peer_find_subscriber(peer,msg->topic);
        if (sub) {
            _mmq_peer_inbox_append_msg(peer, msg);
        } else {
            mmq_msg_close((mmq_msg*)&msg);
        }
        
    } else {
        mmq_msg_close((mmq_msg*)&msg);
    }
}
void _mmq_peer_parse_messages(_mmq_peer_t* peer) {
    int parse_result = 0;
    int parse_count = 0;
    int total_bytes_parsed = 0;
    while (parse_result == 0) {
        int bytes_parsed = 0;
        _mmq_msg_t* msg = NULL;
        parse_result = _mmq_msg_parse(&msg, 
            peer->recv_buf + peer->recv_buf_start, 
            peer->recv_buf_end - peer->recv_buf_start, 
            &bytes_parsed);
        if (parse_result != 0) break;
        peer->recv_buf_start += bytes_parsed;
        //if (!peer->flags) {
        //_mmq_peer_route_msg(peer, msg);
        //}
        switch (msg->type) {
        case MMQ_MSG_TYPE_COMMAND: _mmq_peer_handle_command(peer, msg); break;
        case MMQ_MSG_TYPE_MESSAGE: _mmq_peer_handle_message(peer, msg); break;
        default: mmq_msg_close((mmq_msg*)&msg);
        }
        total_bytes_parsed += bytes_parsed;
        parse_count++;
    }
    if (parse_count) {
        int remain_size = peer->recv_buf_end - peer->recv_buf_start;
        memmove(peer->recv_buf,peer->recv_buf + peer->recv_buf_start, remain_size);
        peer->recv_buf_start = 0;
        peer->recv_buf_end = remain_size;
        //_mmq_peer_clear_inbox(peer);
    }
}

void _mmq_peer_recv(uv_stream_t* stream, ssize_t nread, const uv_buf_t* buf) {
    _mmq_peer_t* peer = (_mmq_peer_t*)stream->data;
    if (nread > 0) {
        if (peer->recv_buf_end + nread > peer->recv_buf_size) {
            peer->recv_buf = (char*)realloc(peer->recv_buf, peer->recv_buf_end + nread);
            peer->recv_buf_size = peer->recv_buf_end + nread;
        }
        memmove(peer->recv_buf + peer->recv_buf_end, buf->base, nread);
        peer->recv_buf_end += nread;
        _mmq_peer_parse_messages(peer);
    } else if (nread < 0) {
        //printf("_mmq_peer_recv status: %i - %s\n", nread, uv_err_name(nread));
        _mmq_peer_disconnect(peer);
        if (!(peer->flags & MMQ_PEER_FLAG_CLIENT)) {
            _mmq_peer_connect(peer);
        } else if (peer->parent) {
            _mmq_peer_remove_peer(peer->parent, peer);
        }
    }
    if (buf->base) {
        free(buf->base);
    }
}


void _mmq_peer_on_connect(uv_connect_t* req, int status) {
    _mmq_peer_t* peer = (_mmq_peer_t*)req->data;
    if (status == 0) {
        peer->connect_status = MMQ_PEER_STATUS_CONNECTED;
        _mmq_peer_send_hello(peer);
        _mmq_peer_send_subscriptions(peer);
        uv_read_start((uv_stream_t*)&peer->uv_tcp_socket, 
            _mmq_peer_alloc_buffer, _mmq_peer_recv);
    } else {
        //printf("Connect error %i %s\n", status, uv_err_name(status));
        _mmq_peer_disconnect(peer);
        if (!(peer->flags & MMQ_PEER_FLAG_CLIENT)) {
            _mmq_peer_connect(peer);
        } else if (peer->parent) {
            _mmq_peer_remove_peer(peer->parent, peer);
        }
    }
}

void _mmq_peer_on_send(uv_write_t* req, int status) {
    _mmq_write_req_t* write_req = (_mmq_write_req_t*)req->data;
    _mmq_peer_t* peer = write_req->peer;
    if (status) {
         //printf("_mmq_peer_on_send status: %i - %s", status, uv_err_name(status));
         _mmq_peer_disconnect(peer);
         if (!(peer->flags & MMQ_PEER_FLAG_CLIENT)) {
            _mmq_peer_connect(peer);
        } else if (peer->parent) {
            _mmq_peer_remove_peer(peer->parent, peer);
        }
        _mmq_peer_send(peer, write_req->msg);
    } else {
        mmq_msg_close((mmq_msg*)&write_req->msg);
    }
    free(write_req);
}



void _mmq_peer_send(_mmq_peer_t* peer, _mmq_msg_t* msg) {
    if (!peer) {
        mmq_msg_close((mmq_msg*)&msg);   
        return;
    }
    memcpy(msg->peer_id,peer->id,sizeof(peer->id));
    if (peer->flags & MMQ_PEER_FLAG_HOST) {
        _mmq_peer_broadcast(peer, peer, msg);
        mmq_msg_close((mmq_msg*)&msg);
    } else {
        _mmq_peer_outbox_append_msg(peer, msg);
    }
    
}

void _mmq_peer_flush(_mmq_peer_t* peer) {
    if (peer->connect_status != MMQ_PEER_STATUS_DISCONNECTED) {
        _mmq_msg_t* msg = peer->outbox;
        _mmq_msg_t* failed = NULL;
        while (msg) {
            peer->uv_write_req.data = (void*)peer;
            uv_buf_t buf = uv_buf_init((char*)msg,sizeof(_mmq_msg_t)+msg->size);
            _mmq_write_req_t* write_req = (_mmq_write_req_t*)malloc(sizeof(_mmq_write_req_t));
            write_req->msg = msg;
            write_req->peer = peer;
            write_req->write_req.data = write_req;
            int rc = uv_write(&write_req->write_req, 
                (uv_stream_t*)&peer->uv_tcp_socket, &buf, 1, _mmq_peer_on_send);
            if (rc) {
                //printf("uv write error: %i %s", rc, uv_err_name(rc));
                if (failed) {
                    failed->next = msg;
                } else {
                    failed = msg;
                }
            } else {
                peer->outbox_size--;
            }

            msg = msg->next;
        }
        peer->outbox = failed;
        if (failed) {
            failed->next = NULL;
        }
    }
}
void _mmq_peer_send_hello(_mmq_peer_t* peer) {
    _mmq_msg_t* msg;
    char greeting[] = "hello";
    msg = (_mmq_msg_t*)mmq_msg_create(greeting,sizeof(greeting));
    msg->type = MMQ_MSG_TYPE_COMMAND;
    _mmq_peer_send(peer, msg);
}
void _mmq_peer_send_subscribe(_mmq_peer_t* peer, const char* topic) {
    _mmq_msg_t* msg;
    char command[128] = "subscribe ";
    strncat(command, topic, 128);
    msg = (_mmq_msg_t*)mmq_msg_create(command,sizeof(command));
    msg->type = MMQ_MSG_TYPE_COMMAND;
    _mmq_peer_send(peer, msg);
}

void _mmq_peer_send_unsubscribe(_mmq_peer_t* peer, const char* topic) {
    _mmq_msg_t* msg;
    char command[128] = "unsubscribe ";
    strncat(command, topic, 128);
    msg = (_mmq_msg_t*)mmq_msg_create(command, sizeof(command));
    msg->type = MMQ_MSG_TYPE_COMMAND;
    _mmq_peer_send(peer, msg);
}



void _mmq_peer_send_subscriptions(_mmq_peer_t* peer) {
    _mmq_peer_sub_t* i = peer->subscriptions;
    if (i == NULL) return;
    while (i) {
        _mmq_peer_send_subscribe(peer, i->topic);
        i = i->next;
    }
}
void _mmq_peer_connect(_mmq_peer_t* peer) {
    //printf("_mmq_peer_connect\n");
    peer->recv_buf_end = 0;
    peer->send_buf_end = 0;
    uv_tcp_init(peer->uv_loop, &peer->uv_tcp_socket);
    int rc = uv_tcp_connect(&peer->uv_connect, &peer->uv_tcp_socket, 
        (struct sockaddr*)&peer->ip_addr, _mmq_peer_on_connect);
    if (rc) {
        printf("uv_tcp_connect result: %i - %s", rc, uv_err_name(rc));
    }
}

void _mmq_peer_on_new_connection(uv_stream_t* req, int status) {
    _mmq_peer_t* server = (_mmq_peer_t*)req->data;

    if (status != 0) {
        printf("_mmq_peer_on_new_connection error %s\n", uv_err_name(status));
    } else {
        _mmq_peer_t* peer = (_mmq_peer_t*) mmq_peer_create();
        mmq_peer_connect((mmq_peer)peer, NULL, MMQ_PEER_FLAG_CLIENT);
        peer->uv_tcp_socket.data = peer;
        uv_tcp_init(peer->uv_loop, &peer->uv_tcp_socket);
        status = uv_accept(req, (uv_stream_t*)&peer->uv_tcp_socket);
        if (status == 0) {
            peer->connect_status = MMQ_PEER_STATUS_CONNECTED;
            _mmq_peer_append_peer(server, peer);
            _mmq_peer_send_hello(peer);
            uv_read_start((uv_stream_t*)&peer->uv_tcp_socket, 
                _mmq_peer_alloc_buffer, _mmq_peer_recv);
        } else {
            printf("_mmq_peer_on_new_connection accept error %s\n", uv_err_name(status));
            mmq_peer_close((mmq_msg*)&peer);
        }
    }


}
void _mmq_peer_bind(_mmq_peer_t* peer) {
    //printf("_mmq_peer_bind\n");
    int rc = uv_tcp_init(peer->uv_loop, &peer->uv_tcp_socket);

    if (rc) {
        printf("uv_tcp_init error %s\n", uv_err_name(rc));
        return;
    }
    rc = uv_tcp_bind(&peer->uv_tcp_socket, (struct sockaddr*)&peer->ip_addr, 0);
    if (rc) {
        printf("uv_tcp_bind error %s\n", uv_err_name(rc));
        return;
    }
    rc = uv_listen((uv_stream_t*)&peer->uv_tcp_socket, 128, _mmq_peer_on_new_connection);
    if (rc) {
        printf("uv_listen error %s\n", uv_err_name(rc));
        return;
    }
    peer->connect_status = MMQ_PEER_STATUS_LISTENING;
}

_mmq_msg_t* _mmq_peer_pop_msg(_mmq_peer_t* peer) {
    _mmq_msg_t* msg = peer->inbox;
    if (!msg) return NULL;
    peer->inbox = msg->next;
    peer->inbox_size--;
    msg->next = NULL;
    return msg;

}

mmq_peer mmq_peer_create() {
    _mmq_peer_t* peer =  (_mmq_peer_t*)malloc(sizeof(_mmq_peer_t));
    
    peer->inbox = NULL;
    peer->outbox = NULL;
    peer->uv_loop = uv_default_loop();
    peer->uv_connect.data = (void*)peer;
    peer->uv_tcp_socket.data = (void*)peer;
    peer->connect_status = MMQ_PEER_STATUS_DISCONNECTED;
    peer->inbox_size = 0;
    peer->outbox_size = 0;

    peer->recv_buf_start = 0;
    peer->recv_buf_end = 0;
    peer->recv_buf_size = MMQ_PEER_BUFFER_INIT_SIZE;
    peer->recv_buf = (char*)malloc(MMQ_PEER_BUFFER_INIT_SIZE);
    if (!peer->recv_buf) return NULL;
    

    peer->send_buf_start = 0;
    peer->send_buf_end = 0;
    peer->send_buf_size = MMQ_PEER_BUFFER_INIT_SIZE;
    peer->send_buf = (char*)malloc(MMQ_PEER_BUFFER_INIT_SIZE);
    if (!peer->send_buf) return NULL;

    peer->next = NULL;
    peer->parent = NULL;
    peer->subscriptions = NULL;
    peer->flags = 0;
    peer->bridge = NULL;
    _mmq_peer_gen_id(peer);

    return peer;
}

int mmq_peer_connect(mmq_peer peer, const char* connection_str, int flags) {
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    _peer->flags = flags;
    _mmq_peer_disconnect(_peer);
    int r = 0;
    if (connection_str) {
        r = _mmq_peer_parse_connection_str(_peer, connection_str);
    } else {
        r = -1;
    }
    if (flags & MMQ_PEER_FLAG_HOST) {
        _mmq_peer_bind(_peer);
    } else if (flags & MMQ_PEER_FLAG_CLIENT) {
       r = 0;
    } else if (flags == 0) {
        _mmq_peer_connect(_peer);
    } else {
        r = -1;
    }
    return r;
}


int mmq_peer_publish(mmq_peer peer, const char* topic, mmq_msg msg) {
    mmq_msg_set_topic(msg,topic,strlen(topic));
    _mmq_peer_relay_msg((_mmq_peer_t*)peer, (_mmq_msg_t*)msg);
    _mmq_peer_send((_mmq_peer_t*)peer, (_mmq_msg_t*)msg);
    return 0;
}

void mmq_peer_close(mmq_peer *peer) {
    if (!peer) return;
    _mmq_peer_t* _peer = *(_mmq_peer_t**)peer;
    _mmq_peer_clear_inbox(_peer);
    _mmq_peer_clear_outbox(_peer);
    if (_peer->recv_buf) free(_peer->recv_buf);
    if (_peer->send_buf) free(_peer->send_buf);
    _mmq_peer_disconnect(_peer);
    _peer->connect_status = MMQ_PEER_STATUS_CLOSED;
    _mmq_peer_sub_t* sub = _peer->subscriptions;
    while (sub) {
        _mmq_peer_sub_t* s = sub;
        sub = sub->next;
        free(s);
    }
    if (!_peer->parent) {
        _mmq_peer_t* child = _peer->next;
        while (child) {
            _mmq_peer_t* p = child;
            child = p->next;
            mmq_peer_close((mmq_peer*)&p);
        }
    }
    free(_peer);
    *peer = NULL;
}

int mmq_peer_subscribe(mmq_peer peer, const char* topic) {
    if (!peer) return -1;
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    _mmq_peer_append_subscriber(_peer, topic);
    _mmq_peer_send_subscribe(_peer, topic);
    return 0;
}
int mmq_peer_relay(mmq_peer peer, mmq_peer other) {
    if (!peer) return -1;
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    _mmq_peer_t* _other = (_mmq_peer_t*)other;
    if (!_peer->bridge) {
        _peer->bridge = _other;
    } else {
        _mmq_peer_t* i = _peer->bridge;
        while (i->next) {
            i = i->next;
        }
        i->next = _other;
    }
    _other->next = NULL;
    return 0;
}
int mmq_peer_unsubscribe(mmq_peer peer, const char* topic) {
    if (!peer) return -1;
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    _mmq_peer_remove_subscriber(_peer, topic);
    _mmq_peer_send_unsubscribe(_peer, topic);
    return 0;
}
int mmq_peer_get_status(mmq_peer peer) {
    if (!peer) return 0;
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    return _peer->connect_status;
}
mmq_msg* mmq_peer_get_msg(mmq_peer peer) {
    if (!peer) return NULL;
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    return (mmq_msg*)_mmq_peer_pop_msg(_peer);
}
int mmq_peer_run(mmq_peer peer) {
    if (!peer) return -1;
    _mmq_peer_t* _peer = (_mmq_peer_t*)peer;
    _mmq_peer_flush(_peer);
    return uv_run(_peer->uv_loop, UV_RUN_NOWAIT);
}
