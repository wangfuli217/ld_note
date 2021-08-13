#ifndef MMQ_MSG_H
#define MMQ_MSG_H
#include"mmq.h"



typedef struct _mmq_msg_t {
    unsigned int signature;
    unsigned int type;
    unsigned int size;
    char peer_id[MMQ_MSG_CLIENT_ID_MAX_SIZE];
    char topic[MMQ_MSG_TOPIC_MAX_SIZE];
    struct _mmq_msg_t* next;
    char* data;
} _mmq_msg_t;

int _mmq_msg_parse(_mmq_msg_t** msg, char* buf, unsigned int size, int* bytes_parsed);


#endif