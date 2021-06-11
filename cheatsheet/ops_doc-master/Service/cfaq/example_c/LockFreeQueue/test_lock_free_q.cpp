// ============================================================================
/// @file  test_lock_free_q.cpp
/// @brief Benchmark lock free queue
// ============================================================================


#include <iostream>
#include <glib.h>  // GTimeVal + g_get_current_time
#include <omp.h>   // parallel processing support in gcc
#include "array_lock_free_queue.h"

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
#define QUEUE_SIZE       1024
#endif

void TestLockFreeQueue()
{
    ArrayLockFreeQueue<int, QUEUE_SIZE> theQueue;
    GTimeVal iniTimestamp;
    GTimeVal endTimestamp;

    std::cout << "=== Start of testing lock-free queue ===" << std::endl;
    g_get_current_time(&iniTimestamp);
    #pragma omp parallel shared(theQueue) num_threads (2)
    {
        if (omp_get_thread_num() == 0)
        {
            //std::cout << "=== Testing Non blocking queue with " << omp_get_num_threads() << " threads ===" << std::endl;

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
                    //if (omp_get_thread_num() == 0)
                    //{
                    //    std::cout << "\t Producers: " << omp_get_num_threads() << std::endl;
                    //}
                    int i;
                    #pragma omp for schedule(static) private(i) nowait
                    for (i = 0 ; i < N_ITERATIONS ; i++)
                    {
                        while(!theQueue.push(i))
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
                    //if (omp_get_thread_num() == 0)
                    //{
                    //    std::cout << "\t Consumers: " << omp_get_num_threads() << std::endl;
                    //}

                    int i;
                    int result;
                    #pragma omp for schedule(static) private(i, result) nowait
                    for (i = 0 ; i < N_ITERATIONS ; i++)
                    {
                        while (!theQueue.pop(result))
                        {
                            // queue empty
                        }

#if (N_CONSUMERS == 1 && N_PRODUCERS == 1)
                        if (i != result)
                        {
                            std::cout << "FAILED i=" << i << " result=" << result << std::endl;
                        }
#endif
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
    std::cout << "=== End of testing lock-free queue ===" << std::endl;    
}

int main(int /*argc*/, char** /*argv*/)
{

	TestLockFreeQueue();
    std::cout << "Done!!!" << std::endl;

	return 0;
}

