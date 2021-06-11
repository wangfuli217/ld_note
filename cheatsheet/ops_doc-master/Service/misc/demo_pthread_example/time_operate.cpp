#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <vector>
#include <queue>
#include <unistd.h>
#include <map>
#include <execinfo.h>
#include "log.h"

/**
 * \brief 获取从1970-1-1零点零分到当前时间系统所偏移的秒数时间转换为本地时间（考虑到时区）
 */
void print_local_time() {
    time_t tmpcal_ptr;
    struct tm *tmp_ptr = NULL;

    printf("size of time_t: %d\n", sizeof(time_t));
    printf("size of int: %d\n", sizeof(int));
    printf("size of uint32_t: %d\n", sizeof(uint32_t));

    tmpcal_ptr = time(NULL);

    printf("d %d -> %d\r\n", tmpcal_ptr, tmpcal_ptr); //Error 2.
    printf("u %u -> %u\r\n", tmpcal_ptr, tmpcal_ptr); //Error 2.
    printf("lld %lld -> %lld\r\n", tmpcal_ptr, tmpcal_ptr); // for linux 4.

//    tmp_ptr = gmtime(&tmpcal_ptr);
//    printf("after gmtime, the time is:\n%d:%d:%d", tmp_ptr->tm_hour, tmp_ptr->tm_min, tmp_ptr->tm_sec);

    tmp_ptr = localtime(&tmpcal_ptr);
    printf("after localtime, the time is:%d:%d:%d\n", tmp_ptr->tm_hour, tmp_ptr->tm_min, tmp_ptr->tm_sec);
}

