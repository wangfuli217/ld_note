#include <assert.h>
#include <pthread.h>
#include "connection_queue.h"

void cq_init(struct conn_queue *cq, int wakeup) {
    pthread_mutex_init(&cq->lock, NULL);
    pthread_cond_init(&cq->cond, NULL);
    cq->length = 0;
    cq->wakeup = wakeup;
    cq->head = NULL;
    cq->tail = NULL;
}

void cq_push(struct conn_queue *cq, conn *item) {
    item->next = NULL;

    pthread_mutex_lock(&cq->lock);
    if (NULL == cq->tail)
        cq->head = item;
    else
        cq->tail->next = item;
    cq->tail = item;
    cq->length++;
    if (cq->wakeup) pthread_cond_signal(&cq->cond);
    pthread_mutex_unlock(&cq->lock);
}

conn *cq_pop(struct conn_queue *cq) {
    conn *item;

    assert(cq->wakeup);
    pthread_mutex_lock(&cq->lock);
    while (NULL == cq->head)
        pthread_cond_wait(&cq->cond, &cq->lock);
    item = cq->head;
    cq->head = item->next;
    if (NULL == cq->head)
        cq->tail = NULL;
    cq->length--;
    pthread_mutex_unlock(&cq->lock);

    return item;
}

conn *cq_peek(struct conn_queue *cq) {
    conn *item;

    pthread_mutex_lock(&cq->lock);
    item = cq->head;
    if (NULL != item) {
        cq->head = item->next;
        if (NULL == cq->head)
            cq->tail = NULL;
        cq->length--;
    }
    pthread_mutex_unlock(&cq->lock);

    return item;
}

uint32_t cq_length(struct conn_queue *cq) {
    int length;
    pthread_mutex_lock(&cq->lock);
    length = cq->length;
    pthread_mutex_unlock(&cq->lock);
    return length;
}
