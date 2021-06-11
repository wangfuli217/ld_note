//windows7中不可用，没有filio.h
#include <sys/filio.h>

int kbhit()
{
    int i;
    ioctl(0,FIONREAD,&i);
    return i;   //返回可以读取的字符的计数值
}

main()
{
    int i=0;
    int c=' ';
    system("stty raw -echo");
    printf("enter 'q' to quit \n");
    for(; c != 'q'; i++)
    {
        if(kbhit())
        {
            c = getchar();
            printf("\n got %c, on iteration %d", c, i);
        }
    }
    system("stty cooked echo");
}
