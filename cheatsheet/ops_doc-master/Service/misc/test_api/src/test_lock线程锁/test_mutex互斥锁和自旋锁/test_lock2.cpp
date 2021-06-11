//Name: svm2.c
//Source: http://www.solarisinternals.com/wiki/index.php/DTrace_Topics_Locks
//Compile(spin lock version): gcc -o spin -DUSE_SPINLOCK svm2.c -lpthread
//Compile(mutex version): gcc -o mutex svm2.c -lpthread
/*
gchen@gchen-desktop:~/Workspace/mutex$ time ./spin
Creating 2 threads...
Thread 31796 started.
Thread 31797 started.
Thread 31797 wins!
Thread 31797 finished!
Thread 31796 finished!
Done.

real    0m5.748s
user    0m10.257s
sys    0m0.004s

gchen@gchen-desktop:~/Workspace/mutex$ time ./mutex
Creating 2 threads...
Thread 31801 started.
Thread 31802 started.
Thread 31802 wins!
Thread 31802 finished!
Thread 31801 finished!
Done.

real    0m4.823s
user    0m4.772s
sys    0m0.032s

 */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/syscall.h>

#define        THREAD_NUM     2

pthread_t g_thread[THREAD_NUM];
#ifdef USE_SPINLOCK
pthread_spinlock_t g_spin;
#else
pthread_mutex_t g_mutex;
#endif
__uint64_t g_count;

pid_t gettid()
{
    return syscall(SYS_gettid);
}

void *run_amuck(void *arg)
{
       int i, j;

       printf("Thread %lu started.\n", (unsigned long)gettid());

       for (i = 0; i < 10000; i++) {
#ifdef USE_SPINLOCK
           pthread_spin_lock(&g_spin);
#else
               pthread_mutex_lock(&g_mutex);
#endif
               for (j = 0; j < 100000; j++) {
                       if (g_count++ == 123456789)
                               printf("Thread %lu wins!\n", (unsigned long)gettid());
               }
#ifdef USE_SPINLOCK
           pthread_spin_unlock(&g_spin);
#else
               pthread_mutex_unlock(&g_mutex);
#endif
       }

       printf("Thread %lu finished!\n", (unsigned long)gettid());

       return (NULL);
}

int main(int argc, char *argv[])
{
       int i, threads = THREAD_NUM;

       printf("Creating %d threads...\n", threads);
#ifdef USE_SPINLOCK
       pthread_spin_init(&g_spin, 0);
#else
       pthread_mutex_init(&g_mutex, NULL);
#endif
       for (i = 0; i < threads; i++)
               pthread_create(&g_thread[i], NULL, run_amuck, (void *) i);

       for (i = 0; i < threads; i++)
               pthread_join(g_thread[i], NULL);

       printf("Done.\n");

       return (0);
}
