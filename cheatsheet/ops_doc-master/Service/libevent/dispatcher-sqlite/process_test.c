#include <stdio.h>
#include <unistd.h>
#include "vec.h"
#include "process.h"

int main (void) {
    int i, num_jobs;
    process_pool *pool;
    vec (job_t) cq;
    vec_init (&cq);

    num_jobs = 10000;
    for (i = 0; i < num_jobs; i++) {
        job_t jobs = { "Yhm, Forever!", i };
        vec_push (&cq, jobs);
    }

    printf ("Master[%d] Runnig\n", getpid ());

    process_pool_envinit ();
    pool = process_pool_new (3);
    process_pool_start (pool);

    for (i = 0; i < num_jobs; i++) {
        process_pool_dispatch (pool, &cq.data[i]);
    }

    wait (NULL);

    vec_deinit (&cq);

    return 0;
}
