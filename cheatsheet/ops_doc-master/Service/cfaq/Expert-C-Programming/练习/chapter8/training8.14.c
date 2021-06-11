//异步I/O
//Windows无法编译成功，缺少库
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stropts.h>
#include <sys/types.h>
#include <sys/conf.h>

int iteration = 0;
char crlf[] = {0xd, 0xa, 0};

void handler(int s)
{
    int c = getchar(); // 读入一个字符
    printf("got char %c,at count %d %s", c, iteration, crlf);
    if(c == 'q')
    {
        system("stty sane");
        exit(0);
    }
}

int main()
{
    sigset(SIGPOLL, handler);   //建立处理程序
    system("stty raw -echo");
    ioctl(0, I_SETSIG, S_RDNORM);   //请求中断驱动的输入

    for(;;iteration++);
    //可以在这里进行一些其他的处理
}
