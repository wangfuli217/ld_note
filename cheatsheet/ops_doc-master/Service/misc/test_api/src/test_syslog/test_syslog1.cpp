#include <syslog.h>

/*
    1. ��/etc/rsyslog.conf����
        $IncludeConfig /etc/rsyslog.d/*.conf
    2.�½�/etc/rsyslog.d/Ŀ¼ �� log.conf�ļ�
    3.log.conf�������
        local4.*    -/var/log/SyslogTest.log
    4.���в������Ӻ�
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
