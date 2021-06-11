#ifndef CONNECTION_QUEUE_H
#define CONNECTION_QUEUE_H
#include "terminal_define.h"
typedef struct conn_queue {
    conn *head;
    conn *tail;
    uint32_t length;
    int wakeup;
    pthread_mutex_t lock;
    pthread_cond_t  cond;
} conn_queue;

//initial
void cq_init(struct conn_queue *cq, int wakeup);

//push item
void cq_push(struct conn_queue *cq, conn *item);

//pop item
conn *cq_pop(struct conn_queue *cq);

//head
conn *cq_peek(struct conn_queue *cq);

//length of queue
uint32_t cq_length(struct conn_queue *cq);

#endif //CONNECTION_QUEUE_H
