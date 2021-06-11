#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>

//run_now 这样操作线程之间很容易产生线程之间死锁的，

void *thread_function(void *arg);
int run_now = 1;
char message[] = "Hello World";

int main(void) 
{
    int res;
    pthread_t a_thread;
    void *thread_result;
    int print_count1 = 0;

    res = pthread_create(&a_thread, NULL, thread_function, (void *)message);
    if (res != 0)
	{
        perror("Thread creation failed");
        exit(EXIT_FAILURE);
    }

    while(print_count1++ < 20) 
	{
        if (run_now == 1)
		{
            printf("1\n");
            run_now = 2;
        }
        else 
		{
            sleep(1);
        }
    }

    printf("\nWaiting for thread to finish...\n");
    res = pthread_join(a_thread, &thread_result);
    if (res != 0) {
        perror("Thread join failed");
        exit(EXIT_FAILURE);
    }
    printf("Thread joined\n");
    exit(EXIT_SUCCESS);
}

void *thread_function(void *arg) 
{
    int print_count2 = 0;

    while(print_count2++ < 20) 
	{
        if (run_now == 2) 
		{
            printf("2\n");
            run_now = 1;
        }
        else 
		{
            sleep(1);
        }
    }

    sleep(3);
}
