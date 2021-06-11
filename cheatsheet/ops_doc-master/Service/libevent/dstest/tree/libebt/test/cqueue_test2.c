#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
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
    cq = cqueue_new (1024 * 80, 1000, QF_NOTIFY | QF_LOCK | QF_SHM);

    printCqueue (cq);

    pid_t pid;
    int z, worker_num = 5;
    for (z = 0; z < worker_num; z++) {
        if ((pid = fork ()) < 0) {
            printf ("fork");
            exit (1);
        } else if (pid > 0) {
            printf ("created child process success. [pid = %d]", (int) pid);
            continue;
        } else {
            //child process
            int recvn = 0;
            struct item_bz tm_bz;
            char fname[56];
            char mbuff[256];
            FILE *fp;

            sprintf (fname, "/root/src/log_%d.txt", z);
            fp = fopen (fname, "a+");

            while (1) {
                if (cqueue_wait (cq) > 0) {
                    if (cqueue_pop (cq, &tm_bz, sizeof (struct item_bz)) < 0)
                        continue;
                    recvn++;

                    printf ("worker[%d] recv: [buf=%s] [rand=%d]", z, tm_bz.buf, tm_bz.a);
                    sprintf (mbuff, "worker[%d] recv: [buf=%s] [rand=%d]\n", z, tm_bz.buf, tm_bz.a);

                    //write log to file[i];
                    fputs (mbuff, fp);
                }
            }
            printf ("worker[%d] finish: [recvn=%d]", z, recvn);
            fclose (fp);
            exit (0);
        }
    }

  label:sleep (1);

    int sendn = 0;
    int inum = 10000;
    while (inum > 0) {
        struct item_bz ibz = { "--||||||||mmmmmm$$########", rand () % 11, &ibz };
        if (cqueue_push (cq, &ibz, sizeof (struct item_bz)) == 0) {
            cqueue_notify (cq);
            sendn++;
            inum--;
        }
    }

    printCqueue (cq);

    printf ("master send finish: [num=%d] [sendn=%d]", inum, sendn);
    int status;
    for (z = 0; z < worker_num; z++) {
        wait (&status);
    }

    cqueue_free (cq);

    return 0;
}
