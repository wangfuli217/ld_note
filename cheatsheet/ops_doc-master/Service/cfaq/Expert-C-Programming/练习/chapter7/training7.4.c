#include <setjmp.h>
#include <signal.h>
#include <stdio.h>

jmp_buf buf;

void handler(int s)
{
    if(s == SIGINT) printf(" now got a SIGINT signal\n");
    longjmp(buf, 1);
}

int main()
{
    signal(SIGINT, handler);
    if(setjmp(buf))
    {
        printf("back in main\n");
        return 0;
    }
    else
        printf("first time through\n");
    loop:
        goto loop;
}
