#include <stdio.h>
#include <malloc.h>
#include <sched.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

#define FIBER_STACK 8192
int a;
void * stack;

int do_something(void * arg)
{
    printf("This is son, the pid is:%d, the a is: %d\n", getpid(), ++a);
    printf("free\n");
    free(stack); //������Ҳ�������������ﲻ�ͷţ���֪�����߳������󣬸��ڴ��Ƿ���ͷţ�֪���߿��Ը�����,лл
    exit(1);
}

int main()
{
    void * stack;
    a = 1;
    stack = malloc(FIBER_STACK);//Ϊ�ӽ�������ϵͳ��ջ

    if(!stack)
    {
        printf("The stack failed\n");
        exit(0);
    }
    printf("creating son thread!!!\n");

//    clone(&do_something, (char *)stack + FIBER_STACK, CLONE_VM|CLONE_VFORK, 0);//�������߳�
    clone(&do_something, (char *)stack + FIBER_STACK,
            CLONE_VM|
//            CLONE_FS|
//            CLONE_FILES|
//            CLONE_SIGHAND|
            CLONE_VFORK,
            0);//�������߳�

    printf("This is father, my pid is: %d, the a is: %d\n", getpid(), a);
    while(1)
        sleep(1);
    exit(1);
}
