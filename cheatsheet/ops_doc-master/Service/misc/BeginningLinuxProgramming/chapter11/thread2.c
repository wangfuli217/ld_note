#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>

void *thread_function(void *arg);

char message[] = "Hello World";

int main(void) 
{
    int res;
    pthread_t a_thread;
    void *thread_result;

	//创建线程的函数，该线程马上执行message参数--
	//其实说明了:线程之间可以传递数据，主要通过全局变量
    res = pthread_create(&a_thread, NULL, thread_function, (void *)message);
    if (res != 0)
	{
        perror("Thread creation failed");
        exit(EXIT_FAILURE);
    }
    printf("Waiting for thread to finish...\n");
	//等待线程thread_function的结束，知道该线程结束，相当于wait函数
    res = pthread_join(a_thread, &thread_result);
    if (res != 0)
	{
        perror("Thread join failed");
        exit(EXIT_FAILURE);
    }
    printf("Thread joined, it returned %s\n", (char *)thread_result);
	//从子线程返回的数据会被打印出来
    printf("Message is now %s\n", message);
    exit(EXIT_SUCCESS);
}

void *thread_function(void *arg) 
{
    printf("thread_function is running. Argument was %s\n", (char *)arg);
    sleep(3);
    strcpy(message, "Bye!");
    pthread_exit("Thank you for the CPU time");
}
