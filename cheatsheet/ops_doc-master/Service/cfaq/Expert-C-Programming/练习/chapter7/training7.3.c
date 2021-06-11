//捕捉段错误信号的信号处理程序(windows没有SIGBUS)
#include <signal.h>
#include <stdio.h>

void handler(int s)
{
//  if (s == SIGBUS) printf(" now got a bus error signal\n");
    if (s == SIGSEGV) printf(" now got a segmentation violation signal\n");
    if (s == SIGILL) printf(" now got an illegal instruction signal\n");
    exit(1);
}

main()
{
    int *p=NULL;
//  signal(SIGBUS, handler);
    signal(SIGSEGV, handler);
    signal(SIGILL, handler);
    *p=0;
}
