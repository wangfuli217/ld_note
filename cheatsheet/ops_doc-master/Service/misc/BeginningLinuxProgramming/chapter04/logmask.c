#include <syslog.h>
#include <stdio.h>
#include <unistd.h>

//-----------------------------------------------------
//	该函数主要讲了日志的书写
//	openlog打开一个日志文件
//	syslog写日志文件
//	写到日志的数据又可以分成好多种形式
//	不同的形式主要决定于该信息的属性
//----------------------------------------------------

int main(void)
{
    int logmask;

    openlog("logmask", LOG_PID|LOG_CONS, LOG_USER);
    syslog(LOG_INFO,"informative message, pid = %d", getpid());
    syslog(LOG_DEBUG,"debug message, should appear");
    logmask = setlogmask(LOG_UPTO(LOG_NOTICE));
    syslog(LOG_DEBUG,"debug message, should not appear");
    exit(0);
}

