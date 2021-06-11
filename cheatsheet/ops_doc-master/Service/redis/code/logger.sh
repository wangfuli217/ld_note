1. 分级别：syslog对象的输出级别
2. 分模块：特定模块输出特定级别
3. 分输出类型：前台输出，文件输出，syslog输出
4. 断言输出exit，正常输出printf，崩溃输出exit
5. 附加信息：日期，模块名，文件名，行数，信号类型，PC值，线程pid或进程PID值、

#define redisDebug(fmt, ...) \
    printf("DEBUG %s:%d > " fmt "\n", __FILE__, __LINE__, __VA_ARGS__)
#define redisDebugMark() \
    printf("-- MARK %s:%d --\n", __FILE__, __LINE__)

redisLog(int level, const char *fmt, ...)   输入接口  受打印级别控制
{
    va_list ap;
    char msg[REDIS_MAX_LOGMSG_LEN];

    if ((level&0xff) < server.verbosity) return;

    va_start(ap, fmt);
    vsnprintf(msg, sizeof(msg), fmt, ap);
    va_end(ap);
}

redisLogRaw(int level, const char *msg)     输入接口  不受打印级别控制
{
    fp = log_to_stdout ? stdout : fopen(server.logfile,"a");             输出到文件还是终端
    if (!log_to_stdout) fclose(fp);                                      是否输出到文件或终端
    if (server.syslog_enabled) syslog(syslogLevelMap[level], "%s", msg); 输出到syslog文件
}


_exit(redisAssertWithInfo, redisAssert, redisPanic)
{
#define redisAssertWithInfo(_c,_o,_e) ((_e)?(void)0 : (_redisAssertWithInfo(_c,_o,#_e,__FILE__,__LINE__),_exit(1)))
    void _redisAssertWithInfo(redisClient *c, robj *o, char *estr, char *file, int line) 
    客户端中的对象，在文件中指定行出现特定错误。                  客户端信息，对象信息
    
    void redisLogObjectDebugInfo(robj *o)               对象信息打印
    void _redisAssertPrintClientInfo(redisClient *c)    客户端信息打印
    
#define redisAssert(_e) ((_e)?(void)0 : (_redisAssert(#_e,__FILE__,__LINE__),_exit(1)))
    void _redisAssert(char *estr, char *file, int line) 
    在文件中指定行出现特定错误。程序逻辑出现错误，多用于调试。            断言
    
#define redisPanic(_e) _redisPanic(#_e,__FILE__,__LINE__),_exit(1)
    void _redisPanic(char *msg, char *file, int line)
    在文件中指定行出现特定错误。程序出现非逻辑性错误，多为意料之外错误。   bug
}


watchdog()
{
利用SIGALRM进行watchdog喂狗。

void enableWatchdog(int period)                                     watchdog打开
void disableWatchdog(void)                                          watchdog关闭
void watchdogScheduleSignal(int period)                             wathcdog喂狗
void watchdogSignalHandler(int sig, siginfo_t *info, void *secret)  watchdog喂狗超时处理

}