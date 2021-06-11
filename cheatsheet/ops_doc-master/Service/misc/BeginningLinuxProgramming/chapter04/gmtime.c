#include <time.h>
#include <stdio.h>

//----------------------------------------------------
//这里的主要还是要知道，各个数据的标识和
// 现实的区别，分钟 秒小时星期年月日等
//----------------------------------------------------

int main(void)
{
    struct tm *tm_ptr;
    time_t the_time;

    (void) time(&the_time);
    tm_ptr = localtime(&the_time);

    printf("Raw time is %ld\n", the_time);
    printf("gmtime gives:\n");
    printf("date: %02d/%02d/%02d\n", 
        tm_ptr->tm_year+1900, tm_ptr->tm_mon+1, tm_ptr->tm_mday);
    printf("time: %02d:%02d:%02d\n",
        tm_ptr->tm_hour, tm_ptr->tm_min, tm_ptr->tm_sec);
    exit(0);
}
