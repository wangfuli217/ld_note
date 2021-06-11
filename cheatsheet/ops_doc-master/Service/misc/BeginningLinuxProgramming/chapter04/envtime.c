#include <time.h>
#include <stdio.h>
#include <unistd.h>

//-----------------------------------------------------
//	其实该函数的主要作用还是sleep()
// 	每个2秒，在执行程序，程序的执行
// 	上很简单，其实涉及到了进程之间的
//	调度的知识ld
//-----------------------------------------------------
int main(void)
{
    int i;
    time_t the_time;

    for(i = 1; i <= 10; i++)
	{
        the_time = time((time_t *)0);
        printf("The time is %ld\n", the_time);
		 printf("The Time is %s",ctime(&the_time));
        sleep(2);
    }
    exit(0);
}
