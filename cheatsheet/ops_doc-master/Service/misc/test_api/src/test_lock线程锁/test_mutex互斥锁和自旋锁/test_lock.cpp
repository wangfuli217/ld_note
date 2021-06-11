// Name: spinlockvsmutex1.cc
// Source: http://www.alexonlinux.com/pthread-mutex-vs-pthread-spinlock
// Compiler(spin lock version): g++ -o spin_version -DUSE_SPINLOCK spinlockvsmutex1.cc -lpthread
// Compiler(mutex version): g++ -o mutex_version spinlockvsmutex1.cc -lpthread

/*
gchen@gchen-desktop:~/Workspace/mutex$ g++ -o spin_version -DUSE_SPINLOCK spinvsmutex1.cc -lpthread
gchen@gchen-desktop:~/Workspace/mutex$ g++ -o mutex_version spinvsmutex1.cc -lpthread
gchen@gchen-desktop:~/Workspace/mutex$ time ./spin_version
Consumer TID 5520
Consumer TID 5521
Result - 5.888750

real    0m10.918s
user    0m15.601s
sys    0m0.804s

gchen@gchen-desktop:~/Workspace/mutex$ time ./mutex_version
Consumer TID 5691
Consumer TID 5692
Result - 9.116376

real    0m14.031s
user    0m12.245s
sys    0m4.368s

可以看见spin lock的版本在该程序中表现出来的性能更好。
另外值得注意的是sys时间，mutex版本花费了更多的系统调用时间，这就是因为mutex会在锁冲突时调用system wait造成的。
*/
#include <stdio.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <errno.h>
#include <sys/time.h>
#include <list>
#include <pthread.h>

#define LOOPS 50000000

using namespace std;

list<int> the_list;

#ifdef USE_SPINLOCK
pthread_spinlock_t spinlock;
#else
pthread_mutex_t mutex;
#endif

//Get the thread id
pid_t gettid() { return syscall( __NR_gettid ); }

void *consumer(void *ptr)
{
    int i;

    printf("Consumer TID %lu\n", (unsigned long)gettid());

    while (1)
    {
#ifdef USE_SPINLOCK
        pthread_spin_lock(&spinlock);
#else
        pthread_mutex_lock(&mutex);
#endif

        if (the_list.empty())
        {
#ifdef USE_SPINLOCK
            pthread_spin_unlock(&spinlock);
#else
            pthread_mutex_unlock(&mutex);
#endif
            break;
        }

        i = the_list.front();
        the_list.pop_front();

#ifdef USE_SPINLOCK
        pthread_spin_unlock(&spinlock);
#else
        pthread_mutex_unlock(&mutex);
#endif
    }

    return NULL;
}

int main()
{
    int i;
    pthread_t thr1, thr2;
    struct timeval tv1, tv2;

#ifdef USE_SPINLOCK
    pthread_spin_init(&spinlock, 0);
#else
    pthread_mutex_init(&mutex, NULL);
#endif

    // Creating the list content...
    for (i = 0; i < LOOPS; i++)
        the_list.push_back(i);

    // Measuring time before starting the threads...
    gettimeofday(&tv1, NULL);

    pthread_create(&thr1, NULL, consumer, NULL);
    pthread_create(&thr2, NULL, consumer, NULL);

    pthread_join(thr1, NULL);
    pthread_join(thr2, NULL);

    // Measuring time after threads finished...
    gettimeofday(&tv2, NULL);

    if (tv1.tv_usec > tv2.tv_usec)
    {
        tv2.tv_sec--;
        tv2.tv_usec += 1000000;
    }

    printf("Result - %ld.%ld\n", tv2.tv_sec - tv1.tv_sec,
        tv2.tv_usec - tv1.tv_usec);

#ifdef USE_SPINLOCK
    pthread_spin_destroy(&spinlock);
#else
    pthread_mutex_destroy(&mutex);
#endif

    return 0;
}
