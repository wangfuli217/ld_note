// ============================================================================
/// @file  test_blocking_q.cpp
/// @brief Benchmark blocking queue
// ============================================================================


#include <iostream>
#include <glib.h>   // GTimeVal + g_get_current_time
#include <omp.h>    // parallel processing support in gcc
#include "g_blocking_queue.h"

#ifndef N_PRODUCERS
#define N_PRODUCERS         1
#endif

#ifndef N_CONSUMERS
#define N_CONSUMERS         1
#endif

#ifndef N_ITERATIONS
#define N_ITERATIONS 10000000
#endif

#ifndef QUEUE_SIZE
#define QUEUE_SIZE       1000
#endif

void TestBlockingQueue()
{
    BlockingQueue<int> theQueue(QUEUE_SIZE);
    GTimeVal iniTimestamp;
    GTimeVal endTimestamp;

    std::cout << "=== Start of testing blocking queue ===" << std::endl;
    g_get_current_time(&iniTimestamp);
    #pragma omp parallel shared(theQueue) num_threads (2)
    {
        if (omp_get_thread_num() == 0)
        {
            if (!omp_get_nested())
            {
                std::cerr << "WARNING: Nested parallel regions not supported. Working threads might have unexpected behaviour" << std::endl;
                std::cerr << "Are you running with \"OMP_NESTED=TRUE\"??" << std::endl;
            }
        }

        #pragma omp sections //nowait
        {
            #pragma omp section
            {
                // producer section
                #pragma omp parallel shared(theQueue) num_threads (N_PRODUCERS)
                {
                    int i;
                    #pragma omp for schedule(static) private(i) nowait
                    for (i = 0 ; i < N_ITERATIONS ; i++)
                    {
                        while(!theQueue.Push(i))
                        {
                            // queue full
                        }
                    }
                }
            }

            #pragma omp section
            {
                // consumer section
                #pragma omp parallel shared(theQueue) num_threads (N_CONSUMERS)
                {
                    int i;
                    int result;
                    #pragma omp for schedule(static) private(i, result) nowait
                    for (i = 0 ; i < N_ITERATIONS ; i++)
                    {
                        // this call will block if the queue is empty until
                        // some other thread pushes something into it
                        theQueue.Pop(result);
                    }
                }
            }
        }

    } // #pragma omp parallel

    g_get_current_time(&endTimestamp);
    
    // calculate elapsed time
    GTimeVal elapsedTime;
    if (endTimestamp.tv_usec >= iniTimestamp.tv_usec)
    {
        elapsedTime.tv_sec  = endTimestamp.tv_sec  - iniTimestamp.tv_sec;
        elapsedTime.tv_usec = endTimestamp.tv_usec - iniTimestamp.tv_usec;
    }
    else
    {
        elapsedTime.tv_sec  = endTimestamp.tv_sec  - iniTimestamp.tv_sec - 1;
        elapsedTime.tv_usec = G_USEC_PER_SEC + endTimestamp.tv_usec - iniTimestamp.tv_usec;
    }
    
    std::cout << "Elapsed: " << elapsedTime.tv_sec << "." << elapsedTime.tv_usec << std::endl;
    std::cout << "=== End of testing blocking queue ===" << std::endl;
}

int main(int /*argc*/, char** /*argv*/)
{
    TestBlockingQueue();
    std::cout << "Done!!!" << std::endl;

	return 0;
}

