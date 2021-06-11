#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void ouch(int sig)
{
    printf("OUCH! - I got signal %d\n", sig);
}

int main(void)
{
    struct sigaction act;

	//	信号sigemptyset，设置信号为空，
    act.sa_handler = ouch;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;

    sigaction(SIGINT, &act, 0);

  while(1) 
  {
    printf("Hello World!\n");
    sleep(1);
  }
}
//	 sigemptyset(&act.sa_mask);和 (void) signal(SIGINT, ouch);两个是不一样的，总的来说
//	sigemptyset是操作系统自身的；signal是C语言标准库的；
//	signal接收到一个Ctrl-C的时候，就执行自身的中断代码；
//	sigemptyset接收到一个Ctrl-C的时候，就执行自身的中断代码；
//	signal仅仅能接受到一个信号，到第二信号的时候，就结束自身信号
//	sigemptyset接受到一个Ctrl-C的时候，就执行自身的代码，而且是多次的。