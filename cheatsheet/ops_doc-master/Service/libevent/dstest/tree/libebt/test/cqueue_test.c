#include <stdio.h>
#include <stdlib.h>
#include <ebt.h>

struct item_bz {
    char buf[128];
    int a;
    struct item_bz *next;
};

void printCqueue (struct cqueue *cq) {
    printf ("cq: [adr=%p] [mem=%p] [num=%d] [head=%d] [tail=%d] [tail_tag=%d] [head_tag=%d]", cq, cq->mem, cq->num, cq->head, cq->tail, (int) cq->tail_tag, (int) cq->head_tag);
}

int main (void) {
    struct cqueue *cq = cqueue_new (1024 * 128, 512, 0);

    printCqueue (cq);

    struct item_bz bz = { "BB|||-----HELC%%%%", 1, &bz };
    char bf[256] = "%%||@$$$$___|||@#FEWCCCsabss%%";
    int a = 128;

    cqueue_unshift (cq, &bz, sizeof (struct item_bz));
    cqueue_unshift (cq, bf, 256);
    cqueue_unshift (cq, &a, sizeof (a));

    printCqueue (cq);

    return 0;
}
