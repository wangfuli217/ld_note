#include <syslog.h>

/*
    1. 在/etc/rsyslog.conf增加
        $IncludeConfig /etc/rsyslog.d/*.conf
    2.新建/etc/rsyslog.d/目录 和 log.conf文件
    3.log.conf内容添加
        local4.*    -/var/log/SyslogTest.log
    4.运行测试例子后
        cat /var/log/SyslogTest.log
        Mar 16 09:40:21 localhost SyslogTest.log[28879]: Hello World.
*/

int main(int argc, char **argv)
{
    syslog(LOG_ERR|LOG_USER,"test - %m/n");
    openlog("SyslogTest.log", LOG_CONS | LOG_PID, LOG_LOCAL4);

//    openlog("SyslogTest.log", 0, LOG_LOCAL4);
    syslog(LOG_DEBUG,"Hello World.\n");

    closelog();
    return 0;
}
