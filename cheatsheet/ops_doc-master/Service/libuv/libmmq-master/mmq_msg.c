#include"mmq_msg.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


mmq_msg mmq_msg_create(const char* data, unsigned int size) {
    char* new_msg_buf = (char*)malloc(size + sizeof(_mmq_msg_t));
    if (!new_msg_buf) {
        return NULL;
    }
    _mmq_msg_t* new_msg = (_mmq_msg_t*)new_msg_buf;
    new_msg->signature = MMQ_MSG_HEADER_SIGNATURE;
    new_msg->size = size;
    memset(new_msg->topic,0,MMQ_MSG_TOPIC_MAX_SIZE);
    new_msg->data = new_msg_buf + sizeof(_mmq_msg_t);
    new_msg->type = MMQ_MSG_TYPE_MESSAGE;
    new_msg->next = NULL;
    if (data && size) {
        memmove(new_msg->data, data, size);
    }
    return (mmq_msg)new_msg;
}

mmq_msg mmq_msg_copy(mmq_msg msg) {
    _mmq_msg_t* _msg = (_mmq_msg_t*)msg;
    char* new_msg_buf = (char*)malloc(_msg->size + sizeof(_mmq_msg_t));
    if (!new_msg_buf) {
        return NULL;
    }
    memmove(new_msg_buf,_msg,_msg->size + sizeof(_mmq_msg_t));
    _mmq_msg_t* new_msg = (_mmq_msg_t*)new_msg_buf;
    new_msg->data = new_msg_buf + sizeof(_mmq_msg_t);
    return (mmq_msg)new_msg_buf;
}

int mmq_msg_set_size(mmq_msg* msg, unsigned int size) {
    if (!msg || !*msg) return -1;
    _mmq_msg_t* _msg = *(_mmq_msg_t**)msg;
    if (_msg->size == size) {
        return 0;
    }
    _mmq_msg_t* new_msg = (_mmq_msg_t*)mmq_msg_create(NULL, size);
    if (_msg->data) {
        unsigned int move_size = _msg->size;
        if (move_size > new_msg->size) {
            move_size = new_msg->size;
        }
        memmove(new_msg->data , _msg->data, move_size);
    }
    free(*msg);
    *msg = new_msg;
    return 0;
}
unsigned int mmq_msg_get_size(mmq_msg msg) {
    if (!msg) return 0;
    _mmq_msg_t* _msg = (_mmq_msg_t*)msg;
    return _msg->size;
}

char* mmq_msg_get_data(mmq_msg msg) {
    if (!msg) return NULL;
    _mmq_msg_t* _msg = (_mmq_msg_t*)msg;
    return _msg->data;
}
int mmq_msg_set_data(mmq_msg *msg, const char* data, unsigned int size) {
    if (!msg || !*msg) return -1;
    int r = mmq_msg_set_size(msg, size);
    if (r < 0) return r;
    _mmq_msg_t* _msg = *(_mmq_msg_t**)msg;
    memmove(_msg->data, data, size);
    return 0;
}

const char* mmq_msg_get_topic(mmq_msg msg) {
    if (!msg) return NULL;
    _mmq_msg_t* _msg = (_mmq_msg_t*)msg;
    return _msg->topic;
}

int mmq_msg_set_topic(mmq_msg msg, const char* topic, unsigned int size) {
    if (!msg) return -1;
    _mmq_msg_t* _msg = (_mmq_msg_t*)msg;
    if (size >= MMQ_MSG_TOPIC_MAX_SIZE) {
        size = MMQ_MSG_TOPIC_MAX_SIZE-1;
    }
    strncpy(_msg->topic, topic, size);
    _msg->topic[MMQ_MSG_TOPIC_MAX_SIZE-1] = 0;
    return size;
}

void mmq_msg_close(mmq_msg* msg) {
    if (!msg || !msg) return;
    free(*msg);
    *msg = NULL;
}

int _mmq_msg_parse(_mmq_msg_t** msg, char* buf, unsigned int size, int* bytes_parsed) {
    _mmq_msg_t* header = (_mmq_msg_t*)buf;

    if (size < sizeof(_mmq_msg_t)) return -1;
    if (header->signature != MMQ_MSG_HEADER_SIGNATURE) {
        return -1;
    }
    if (header->size > (size - sizeof(_mmq_msg_t))) {
        return header->size - (size - sizeof(_mmq_msg_t));
    }
    _mmq_msg_t* _msg = (_mmq_msg_t*)mmq_msg_copy((mmq_msg)header);
    if (bytes_parsed) {
        *bytes_parsed = sizeof(_mmq_msg_t) + _msg->size;
    }
    *msg = _msg;
    return 0;
}
