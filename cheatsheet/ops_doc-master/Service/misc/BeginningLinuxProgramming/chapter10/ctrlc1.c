/*  We'll start by writing the function which reacts to the signal
    which is passed in the parameter sig.
    This is the function we will arrange to be called when a signal occurs.
    We print a message, then reset the signal handling for SIGINT
    (by default generated by pressing CTRL-C) back to the default behavior.
    Let's call this function ouch.  */

#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void ouch(int sig)
{
    printf("OUCH! - I got signal %d\n", sig);
    (void) signal(SIGINT, SIG_DFL);
}

/*  The main function has to intercept the SIGINT signal generated when we type Ctrl-C .
    For the rest of the time, it just sits in an infinite loop,
    printing a message once a second. 
������û�б�ɱ��ʱ������һֱִ��while(1)ѭ����������ɱ��ʱ��
����ִ���ź�����ĺ���
    */

int main(void)
{
//	SIGINT����Ctrl+C�ź�
    (void) signal(SIGINT, ouch);

	 kill(2083, SIGINT);
    while(1) 
	{
        printf("Hello World!\n");
        sleep(1);
    }
	
#if 0
	(void) signal(SIGINT, ouch);
    while(1) {
        printf("Hello Me!\n");
        sleep(1);
    }
#endif
}
//	��������������ʱ�����ͻ᲻ͣ�Ĵ�ӡHello World
//	������ɱ��ʱ��(void) signal(SIGINT, ouch);�ͻ��յ��ź�
//	Ȼ��������ִ�У��������ٴα�ɱ��ʱ�����ͻᱻɱ��