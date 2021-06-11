#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
  
//类似wget的进度条的实现，实际就是转移符\r的使用，\r的作用是返回至行首而不换行
int main(int argc, char *argv[])
{
    unsigned len = 60;
    char *bar = (char *)malloc(sizeof(char) * (len + 1));
    for (int i = 0; i < len + 1; ++i)
    {
        bar[i] = '#';
    }
    for (int i = 0; i < len; ++i)
    {
        printf("progress:[%s]%d%%\r", bar+len-i, i+1);
        fflush(stdout);//一定要fflush，否则不会会因为缓冲无法定时输出。
        usleep(100000);
        //sleep(1);
    }
    printf("\n");
    return 0;
}

