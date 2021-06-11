#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <time.h>
#include "lfq.h"

lfq_t myq;
HANDLE hEvent;
HANDLE hqEvent;

static unsigned int __stdcall winthread_proc (PVOID param) {
    printf ("%s\n", "running!!!!");
    void *data;
    while (1) {
      out:
        if ((data = lfq_deq (&myq)) == NULL) {
            // SuspendThread(GetCurrentThread());
            ResetEvent (hEvent);
            fprintf (stderr, "%s\n", "Going sleep!");
            WaitForSingleObject (hEvent, INFINITE);
            fprintf (stderr, "%s\n", "Wake up!");
            goto out;
        }

        printf ("%d\n", *((int *) data));
    }

    return 0;
}

int main (void) {

    HANDLE h;

    lfq_init (&myq);
    hEvent = CreateEvent (NULL, TRUE, FALSE, NULL);
    hqEvent = CreateEvent (NULL, TRUE, FALSE, NULL);

    h = (HANDLE) _beginthreadex (0, 0, winthread_proc, NULL, /*CREATE_SUSPENDED */ 0, 0);

    Sleep (1000);
    int i, *data;
    for (i = 0; i < 10; i++) {
        data = malloc (sizeof (int));
        assert (data != NULL);
        *data = i;
        lfq_enq (&myq, data);
    }
    // ResumeThread(h);
    SetEvent (hEvent);

    DWORD dw;
    dw = WaitForSingleObject (hqEvent, INFINITE);
    switch (dw) {
    case WAIT_FAILED:
        fprintf (stderr, "%s\n", "invalid handle??");
        break;
    default:
        fprintf (stderr, "%s\n", "Nothing!!!");
    }

    return 0;
}
