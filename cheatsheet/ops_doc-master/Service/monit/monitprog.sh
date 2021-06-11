main()
{
prog = Util_basename()  prog是程序名称
                        
init_env()              set_sandbox：初始化PATH环境变量，关闭fd大于3的所有文件描述符；
                        set_environment：初始化用户名，用户工作目录，程序运行目录和mask值
handle_options()        c controlfile
                        d isdaemon
                        g mygroup
                        l logfile
                        p pidfile
                        s statefile
                        I init
                        t testing
                        v debug
                        H Hash ...
                        V version()
                        h help()
                        
 do_init()              SIGTERM, do_destroy     Run.stopped = TRUE;
                        SIGUSR1, do_wakeup      Run.dowakeup = TRUE;
                        SIGINT, do_destroy      Run.stopped = TRUE;
                        SIGHUP, do_reload       Run.doreload = TRUE;
                        SIGPIPE, SIG_IGN        
                        srandom(time(NULL) + getpid()) 生成随机数
                        Run.mutex       pthread_mutex_init
                        heartbeatMutex  pthread_mutex_init
                        heartbeatCond   pthread_cond_init
                        File_findControlFile : -c 选项指定 ~/.monitrc -> /etc/monitrc -> /SYSCONFDIR/monitrc /usr/local/etc/monitrc -> ./monitrc
                        init_process_info()  初始化systeminfo：/proc/meminfo gettimeofday uname
                        parse() ... ...
                        log_init() openlog 或 fopen(Run.logfile,"a+") setvbuf(LOG, NULL, _IONBF, 0);
                        log_close() closelog();  或 fclose()
                        File_init() -p 选项执行 -> /var/run/pidfile -> ./pidfile
                                   set idfile -> ~/monitid
                                   ~/monit.state
 do_action                                  
    do_default
    [start|stop|monitor|unmonitor|restart] control_service_daemon : control_service_string
    [reload] kill_daemon
    [status] status(LEVEL_NAME_FULL);
    [summary] status(LEVEL_NAME_SUMMARY);
    [procmatch] process_testmatch(service);
    [quit] process_testmatch(SIGTERM);
    [validate] validate()
                        
                        
                        
                        
}   

myprocesstree(struct)
{
pid;             进程自身PID
ppid;            进程父进程PID
status_flag;     进程当前状态
starttime;       进程开始时间
*cmdline;        当前进程名称
                 
visited;         
children_num;    
children_sum;    
cpu_percent;     
cpu_percent_sum; 
mem_kbyte;       
mem_kbyte_sum;   
                 
 time;                                      
 time_prev;      上次time                           
 cputime;        cputime                           
 cputime_prev;   上次cputime                           
                 
 parent;         
*children;       

}

parse()
{


}         

Util_monitId() -> run.id
{
# STRLEN = 256 digest=256 buf=256
## 初始化buf缓冲区
snprintf(buf, STRLEN, "%lu%d%lu", (unsigned long)time(NULL), getpid(), random());

## 从buf缓冲区到digest缓冲区
struct md5_ctx ctx;
md5_init_ctx (&ctx);
md5_process_bytes (buf, len, &ctx);
md5_finish_ctx (&ctx, digest);

## 从digest到id缓冲区
static unsigned char hex[] = "0123456789abcdef";     
#for(i= 0; i < 16; i++) {
  *id++ = hex[digest[i] >> 4];
  *id++ = hex[digest[i] & 0xf];
}
*id = '\0';

}           

## 程序整体配置信息 
Util_printRunList()
{
Adding 'allow 192.168.10.0/255.255.0.0'
Adding credentials for user 'admin'
Runtime constants:
 Control file       = /root/gitbook/monit-5.19.0/monitrc
 Log file           = syslog
 Pid file           = /var/run/monit.pid
 Id file            = /root/.monit.id
 State file         = /root/.monit.state
 Debug              = True
 Log                = True
 Use syslog         = True
 Is Daemon          = True
 Use process engine = True
 Limits             = {
                    =   programOutput:     512 B
                    =   sendExpectBuffer:  256 B
                    =   fileContentBuffer: 512 B
                    =   httpContentBuffer: 1024 kB
                    =   networkTimeout:    5 s
                    = }
 Poll time          = 30 seconds with start delay 0 seconds
 Start monit httpd  = True
 httpd bind address = 192.168.10.109
 httpd portnumber   = 2812
 httpd ssl          = Disabled
 httpd signature    = Enabled
 httpd auth. style  = Basic Authentication and Host/Net allow list

The service list contains the following entries:

System Name           = agent109.cloud.com
 Monitoring mode      = active
 On reboot            = start

-------------------------------------------------------------------------------
pidfile '/var/run/monit.pid' does not exist
Starting Monit 5.19.0 daemon with http interface at [192.168.10.109]:2812

}

## 程序资源配置信息
Util_printServiceList() 
{
myservicegroup # 组管理

}

do_action()
{

}

check_process()
{
myservice对象测试：
1. 是否正在运行
2. 是否处于Zombie状态
3. pid是否发生变化
4. ppid是否发生变化
5. 进程自身CPU是否超限 对Linux无意义
6. 超过系统总CPU使用率
7. 超过内核总CPU使用率
8. 超过用户态CPU使用率
9. 超过IO系统CPU使用率
10. 超过内存使用率
11. 超过内存量阀值
12. 超过SWAP内存使用率
13. 超过SWAP内存使用量
14. 1分钟负载
15. 5分钟负载
16. 15分钟负载
17. 子进程超过

RESOURCE_ID_TOTAL_MEM_KBYTE
RESOURCE_ID_TOTAL_MEM_PERCENT

协议相关测试：
create_apache_status();
create_dns();
create_dwp();
create_ftp();
create_generic();
create_http();
create_imap();
create_clamav();
create_ldap2();
create_ldap3();
create_mysql();
create_nntp();
create_ntp3();
create_postfix_policy();
create_pop();
create_smtp();
create_ssh();
create_rdate();
create_rsync();
create_tns();
create_pgsql();
create_sip();
create_lmtp();
create_gps();
create_radius();
create_memcache();
tcp协议
udp协议

}

check_filesystem()
{
1. 文件系统不存在
2. 文件系统符号连接失败
3. 权限不正确
4. uid不正确
5. gid不正确
6. 文件系统表示不正确
7. inode使用超过使用率或使用量
8. 空间超过使用率或使用量

}

check_file()
{
1. mode发生变化
2. checksum发生变化
3. 权限不正确
4. uid不正确
5. gid不正确
6. size超过某个值
7. timestamplist发生变化
8. 文件多少行内容不正确

}

check_directory()
{
1. mode发生变化
2. 权限不正确
3. uid不正确
4. gid不正确
5. timestamplist发生变化
}

check_fifo()
{
1. 权限不正确
2. uid不正确
3. gid不正确
4. timestamplist发生变化
}

check_status()
{

}


check_remote_host()
{

}

check_system()
{

}

check_connection()
{

}

check_checksum()
{

}

check_perm()
{

}

check_uid()
{

}

check_gid()
{

}

check_timestamp()
{

}

check_size()
{

}

check_match()
{

}

check_match_ignore()
{

}

check_match_if()
{

}

check_filesystem_flags()
{

}

check_filesystem_resources()
{

}

check_timeout()
{

}

check_skip()
{

}

























