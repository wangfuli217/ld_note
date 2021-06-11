file:///D:/workkit/20150316/sheepdog/monit/monit-master/doc/help.htm
file:///D:/workkit/20150316/sheepdog/monit/monit-master/doc/monit.html#host_and_network_allow_list


SYNOPSIS()
{
    monit [options] {arguments}
1. 用于管理和监控进程、程序、文件、目录和文件系统。
   网络连接情况：支持TCP，UDP、Unix Domain Sockets等等。内置支持HTTP，SMTP等，其他也支持。
2. 在异常情况下，自动维护和修复，执行有意义的操作。
   程序未运行，可以启动该程序
   程序未响应，可以重启该程序
   程序使用资源超配，可以停止该程序
   可以监控文件、目录、文件系统系统时间戳改变，校验码和大小改变。
3. monit可以将异常写入syslog、自己的日志文件或者通过邮件通知。   
4. monit可以检查TCP/IP网络，协议甚至SSL，提供了Web服务器，用以管理monit

monit被命令行选项和配置文件控制(monitrc)。
5. ~/monitrc, /etc/monitrc, ./monitrc, 通过-c设定。## monit -t
   ./configure --sysconfdir # ./configure --sysconfdir /var/monit/etc
   monitrc文件属性：0700
   
6. ./monit.state保存monit的状态并且利用她从一个毁坏性的状态恢复！
    ~/.monit.id保存他自己的唯一ID到这个文件里面  
   
######
进程：sendmail,sshd,apache,mysql。当一个错误发生的时候：

Monit配置文件有两部分："Global"（全局）和"Services"（服务）。

Global set-statements                  set
Global include-statement               include
One or more service entry statements.  check
}

Options()
{
 -c file       monitrc
 -d n          "set daemon"
 -g name       Set group name for monit commands
 -l logfile    "set logfile" 
 -p pidfile    "set pidfile" 
 -s statefile  "set statefile"
 -I            前台运行
 --id          Print Monit's unique ID
 --resetid     Reset Monit's unique ID. Use with caution
 -B            Batch command line mode (do not output tables or colors)
 -t            monitrc语法正确检验
 -v            详细输出
 -vv           更加详细输出

 通过127.0.0.1:2812与monit进行交互；
Optional commands are as follows:
 start all             - Start all services
 start <name>          - Only start the named service
 stop all              - Stop all services
 stop <name>           - Stop the named service
 restart all           - Stop and start all services
 restart <name>        - Only restart the named service
 monitor all           - Enable monitoring of all services
 monitor <name>        - Only enable monitoring of the named service
 unmonitor all         - Disable monitoring of all services
 unmonitor <name>      - Only disable monitoring of the named service
 reload                - Reinitialize monit
 status [name]         - Print full status information for service(s)
 summary [name]        - Print short status information for service(s)
 report [up|down|..]   - Report state of services. See manual for options
 quit                  - Kill the monit daemon process
 validate              - Check all services and start if not running
 procmatch <pattern>   - Test process matching pattern

}

metaword()
{
'if', 'and', 'with(in)', 'has', 'us(ing|e)', 'on(ly)', 'then', 'for', 'of'
grammar, numbers and strings.
}


global(全局配置：Web状态页面)
{
#### 全局配置：Web状态页面

Monit可以使用邮件服务来发送通知，也可以使用HTTP/HTTPS页面来展示。我们先使用如下配置的web状态页面吧：
    Monit监听1966端口。
    对web状态页面的访问是通过SSL加密的。
    使用monituser/romania作为用户名/口令登录。
    只允许通过localhost、myhost.mydomain.ro和在局域网内部（192.168.0.0/16）访问。
    Monit使用pem格式的SSL证书。
    
首先，在/var/cert生成一个自签名的证书（monit.pem）：

    # mkdir /var/certs
    # cd /etc/pki/tls/certs
    # ./make-dummy-cert monit.pem
    # cp monit.pem /var/certs
    # chmod 0400 /var/certs/monit.pem

现在将下列代码片段放到Monit的主配置文件中。你可以创建一个空配置文件，或者基于自带的配置文件修改。

    set httpd port 1966and
    SSL ENABLE
    PEMFILE /var/certs/monit.pem
    allow monituser:romania
    allow localhost
    allow 192.168.0.0/16
    allow myhost.mydomain.ro
}


global(全局配置：邮件通知)
{
 #### 全局配置：邮件通知
然后，我们来设置Monit的邮件通知。我们至少需要一个可用的SMTP服务器来让Monit发送邮件。这样就可以（按照你的实际情况修改）：

    邮件服务器的机器名：smtp.monit.ro
    Monit使用的发件人：monit@monit.ro
    邮件的收件人：guletz@monit.ro
    邮件服务器使用的SMTP端口：587（默认是25）

有了以上信息，邮件通知就可以这样配置：

    set mailserver smtp.monit.ro port 587
    set mail-format {
    from: monit@monit.ro
    subject: $SERVICE $EVENT at $DATE on $HOST
    message:Monit $ACTION $SERVICE $EVENT at $DATE on $HOST : $DESCRIPTION.
    Yours sincerely,
    Monit
    }
    set alert guletz@monit.ro

就像你看到的，Monit会提供几个内部变量（$DATE、$EVENT、$HOST等），你可以按照你的需求自定义邮件内容。如果你想要从Monit所在机器发送邮件，就需要一个已经安装的与sendmail兼容的程序（如postfix或者ssmtp）。

}

global(全局配置：Monit守护进程)
{

 #### 全局配置：Monit守护进程
 接下来就该配置Monit守护进程了。可以将其设置成这样：

    在120秒后进行第一次检测。
    每3分钟检测一次服务。
    使用syslog来记录日志。

如下代码段可以满足上述需求。

    set daemon 120
    with start delay 240
    set logfile syslog facility log_daemon

我们必须定义“idfile”，Monit守护进程的一个独一无二的ID文件；以及“eventqueue”，当monit的邮件因为SMTP或者网络故障发不出去，邮件会暂存在这里；以及确保/var/monit路径是存在的。然后使用下边的配置就可以了。

    set idfile /var/monit/id
    set eventqueue
    basedir /var/monit
}

global(config)
{
# Global Section
# status webpage and acl's
set httpd port 1966and
SSL ENABLE
PEMFILE /var/certs/monit.pem
allow monituser:romania
allow localhost
allow 192.168.0.0/16
allow myhost.mydomain.ro
# mail-server
set mailserver smtp.monit.ro port 587
# email-format
set mail-format {
from: monit@monit.ro
subject: $SERVICE $EVENT at $DATE on $HOST
message:Monit $ACTION $SERVICE $EVENT at $DATE on $HOST : $DESCRIPTION.
Yours sincerely,
Monit
}
set alert guletz@monit.ro
# delay checks
set daemon 120
with start delay 240
set logfile syslog facility log_daemon
# idfile and mail queue path
set idfile /var/monit/id
set eventqueue
basedir /var/monit
}

mem(服务配置：CPU、内存监控)
{
    check system localhost
    if loadavg (1min)>10then alert
    if loadavg (5min)>6then alert
    if memory usage >75%then alert
    if cpu usage (user)>70%then alert
    if cpu usage (system)>60%then alert
    if cpu usage (wait)>75%then alert

你可以很容易理解上边的配置。最上边的check是指每个监控周期（全局配置里设置的120秒）都对本机进行下面的操作。如果满足了任何条件，monit守护进程就会使用邮件发送一条报警。

如果某个监控项不需要每个周期都检查，可以使用如下格式，它会每240秒检查一次平均负载。

    if loadavg (1min)>10for2 cycles then alert
}

process(sshd)
{

先检查我们的sshd是否安装在/usr/sbin/sshd：
    check file sshd_bin with path /usr/sbin/sshd
我们还想检查sshd的启动脚本是否存在：
    check file sshd_init with path /etc/init.d/sshd

最后，我们还想检查sshd守护进程是否存活，并且在监听22端口：

    check process sshd with pidfile /var/run/sshd.pid
    start program "/etc/init.d/sshd start"
    stop program "/etc/init.d/sshd stop"
    if failed port 22 protocol ssh then restart
    if restarts within 5 cycles then timeout

我们可以这样解释上述配置：我们检查是否存在名为sshd的进程，并且有一个保存其pid的文件存在（/var/run/sshd.pid）。如果任何一个不存在，我们就使用启动脚本重启sshd。我们检查是否有进程在监听22端口，并且使用的是SSH协议。如果没有，我们还是重启sshd。如果在最近的5个监控周期（5x120秒）至少重启5次了，sshd就被认为是不能用的，我们就不再检查了。
}


SMTP(服务配置：SMTP服务监控)
{
服务配置：SMTP服务监控

现在我们来设置一个检查远程SMTP服务器（如192.168.111.102）的监控。假定SMTP服务器运行着SMTP、IMAP、SSH服务。

    check host MAIL with address 192.168.111.102
    if failed icmp type echo within 10 cycles then alert
    if failed port 25 protocol smtp then alert
    elseif recovered thenexec"/scripts/mail-script"
    if failed port 22 protocol ssh then alert
    if failed port 143 protocol imap then alert

我们检查远程主机是否响应ICMP协议。如果我们在10个周期内没有收到ICMP回应，就发送一条报警。如果监测到25端口上的SMTP协议是异常的，就发送一条报警。如果在一次监测失败后又监测成功了，就运行一个脚本（/scripts/mail-script）。如果检查22端口上的SSH或者143端口上的IMAP协议不正常，同样发送报警。
}

MONITRC()
{
SERVICE MONITORING MODE
MODE <ACTIVE | PASSIVE | MANUAL>

active--Monitj监控一个服务，为了防止一系列问题，Monit会执行以及发送警报，停止，启动，重启，这是一个缺省的模式
passive--MOnit监控一个服务，不会尝试去修复这个问题，但还是会发送警报
manual--Monit监控进入active模式，通过monit的控制，比如在控制台执行命令，比如 Monit start sybase
  

ALERT：  当状态发生变化的，发送一个告警信息给用户。
RESTART：重启任务，并发送一个告警信息给用户；
         要么调用restart配置，要么调用stop命令，再调用start命令
         
IF <number> RESTART <number> CYCLE(S) THEN <action>   ## 依赖restart次数和检查周期配置      
if 2 restarts within 3 cycles then unmonitor #TIMEOUT 
if 5 restarts within 5 cycles then exec "/foo/bar" #TIMEOUT 
if 7 restarts within 10 cycles then stop #TIMEOUT 
      
START：  调用start方法，并发送一个告警信息给用户；       
STOP：   调用stop方法，并发送一个告警信息给用户； 
EXEC:    执行exec配置，并发送一个告警信息给用户； 
exec "/usr/local/tomcat/bin/startup.sh"
      as uid nobody and gid nobody

UNMONITOR:取消检查，并发送一个告警信息给用户； 


check filesystem rootfs with path /dev/hda1 
    if space usage > 80% for 5 times within 15 cycles then alert 
    if space usage > 90% for 5 cycles then exec '/try/to/free/the/space'
    
if failed 
    port 80 
    for 3 times within 5 cycles 
then alert

1. SERVICE DEPENDENCIES
DEPENDS on service[, service [,...]]
check process apache 
with pidfile "/usr/local/apache/logs/httpd.pid" 
... 
depends on httpd 

check file httpd with path /usr/local/apache/bin/httpd 
if failed checksum then unmonitor

WEB-SERVER -> APPLICATION-SERVER -> DATABASE -> FILESYSTEM 
     (a)             (b)               (c)        (d)
     
If no servers are running
    Monit will start the servers in the following order: d, c, b, a
If all servers are running   
    When you run 'Monit stop all' this is the stop order: a, b, c, d. 
    If you run 'Monit stop d' then a, b and c are also stopped because they depend on d and finally d is stopped.

If a does not run
    When Monit runs it will start a
If b does not run
    When Monit runs it will first stop a then start b and finally start a again.
If c does not run
    When Monit runs it will first stop a and b then start c and finally start b then a.
If d does not run
    When Monit runs it will first stop a, b and c then start d and finally start c, b then a.

2. SERVICE GROUPS
GROUP groupname
  monit -g <groupname> start
  monit -g <groupname> stop
  monit -g <groupname> restart
  
  
group www 
group filesystem

3. SERVICE POLL TIME
set daemon n
  
EVERY [number] CYCLES
EVERY [cron]
NOT EVERY [cron]

 Name:        | Allowed values:            | Special characters:
 ---------------------------------------------------------------
 Minutes      | 0-59                       | * - ,
 Hours        | 0-23                       | * - ,
 Day of month | 1-31                       | * - ,
 Month        | 1-12 (1=jan, 12=dec)       | * - ,
 Day of week  | 0-6 (0=sunday, 6=saturday) | * - ,
 
 

 Character:   | Description:
 ---------------------------------------------------------------
 * (asterisk) | The asterisk indicates that the expression will
              | match for all values of the field; e.g., using
              | an asterisk in the 4th field (month) would
              | indicate every month.
 - (hyphen)   | Hyphens are used to define ranges. For example,
              | 8-9 in the hour field indicate between 8AM and
              | 9AM. Note that range is from start time until and
              | including end time. That is, from 8AM and until
              | 10AM unless minutes are set. Another example,
              | 1-5 in the weekday field, specify from monday to
              | friday (including friday).
 , (comma)    | Comma are used to specify a sequence. For example
              | 17,18 in the day field indicate the 17th and 18th
              | day of the month. A sequence can also include
              | ranges. For example, using 1-5,0 in the weekday
              | field indicate monday to friday and sunday.
 

check process nginx with pidfile /var/run/nginx.pid
      every 2 cycles

check program checkOracleDatabase
       with path /var/monit/programs/checkoracle.pl
      every "* 8-19 * * 1-5"
      
check process mysqld with pidfile /var/run/mysqld.pid
       not every "* 0-3 * * 0"
 
4. SERVICE METHODS
  <START | STOP | RESTART> [PROGRAM] = "program"
        [[AS] UID <number | string>]
        [[AS] GID <number | string>]
        [[WITH] TIMEOUT <number> SECOND(S)]
        
check process mmonit with pidfile /usr/local/mmonit/mmonit/logs/mmonit.pid
   start program = "/usr/local/mmonit/bin/mmonit" as uid "mmonit" and gid "mmonit"
   stop program = "/usr/local/mmonit/bin/mmonit stop" as uid "mmonit" and gid "mmonit"
   
 check process foobar with pidfile /var/run/foobar.pid
   start program = "/etc/init.d/foobar start" with timeout 60 seconds
   stop program = "/etc/init.d/foobar stop"

5. ALERT MESSAGES 

SET ALERT mail-address [[NOT] {event, ...}] [REMINDER cycles]
set alert foo@bar

ALERT mail-address [[NOT] {event, ...}] [REMINDER cycles]
check host myhost with address 1.2.3.4 
    if failed port 3306 protocol mysql then alert 
    if failed port 80 protocol http then 
    alert alert foo@baz # Local service alert

set alert foo@bar only on { timeout, nonexist }
set alert foo@bar but not on { instance }
set alert foo@bar { nonexist, timeout, resource, icmp, connection } 
set alert security@bar on { checksum, permission, uid, gid } 
set alert admin@bar

SET ALERT mail-address [WITH] REMINDER [ON] number [CYCLES]
alert foo@bar with reminder on 10 cycles
alert foo@bar with reminder on 1 cycle


set alert foo@bar 
check process p1 with pidfile /var/run/p1.pid 
check process p2 with pidfile /var/run/p2.pid 
check process p3 with pidfile /var/run/p3.pid 
noalert foo@bar


SET MAIL-FORMAT {mail-format}
 set mail-format {
      from: monit@foo.bar
  reply-to: support@domain.com
   subject: $SERVICE $EVENT at $DATE
   message: Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
            Yours sincerely,
            monit
 }
 
 SET MAILSERVER <hostname|ip-address [PORT number] [USERNAME string] 
 [PASSWORD string] [using SSLAUTO|SSLV2|SSLV3|TLSV1|TLSV11|TLSV12] [
 CERTMD5 checksum]>, ... 
 [with TIMEOUT X SECONDS] 
 [using HOSTNAME hostname]
 
 set mailserver smtp.gmail.com, smtp.other.host
 
 Event queue
 SET EVENTQUEUE BASEDIR <path> [SLOTS <number>]
 set eventqueue basedir /var/monit slots 5000
 
}

RESOURCE()
{
IF resource operator value THEN action

resource: "CPU", "TOTAL CPU", "CPU([user|system|wait])", "MEMORY", "SWAP", "CHILDREN", "TOTAL MEMORY", "LOADAVG([1min|5min|15min])"

CPU([user|system|wait])
   if cpu usage (user) > 70% then alert
   if cpu usage (system) > 30% then alert
   if cpu usage (wait) > 20% then alert
   if cpu > 60% for 2 cycles then alert
   if cpu > 80% for 5 cycles then restart 
   
MEMORY  
    if memory usage > 75% then alert 

SWAP
    if swap usage > 25% then alert
    
CHILDREN
    if children > 200 then alert

TOTAL MEMORY
    if totalmem > 100 Mb then alert
    if totalmem > 100 MB then stop
    if totalmem > 1000.0 MB for 5 cycles then alert 
    if totalmem > 1500.0 MB for 5 cycles then alert 
    if totalmem > 2000.0 MB for 5 cycles then restart
    
LOADAVG
    if loadavg (1min) > 4 then alert 
    if loadavg (5min) > 2 then alert
    
if cpu is greater than 50% for 5 cycles 
    then restart

}

PROCESS()
{
CHECK PROCESS <unique name> <PIDFILE <path> | MATCHING <regex>>
# 如果PIDFILE不存在或者pidfile中包含的文件pid对应的进程不存在，则重新启动该进程。

check process apache with pidfile /usr/local/apache/logs/httpd.pid
  start program = "/etc/init.d/httpd start" with timeout 60 seconds
  stop program  = "/etc/init.d/httpd stop"
  if cpu > 60% for 2 cycles then alert                  # cpu 使用情况
  if cpu > 80% for 5 cycles then restart                # cpu 使用情况
  if totalmem > 200.0 MB for 5 cycles then restart      # 内存使用情况
  if children > 250 then restart                        # 子进程
  if loadavg(5min) greater than 10 for 8 cycles then stop   # 负载
  if failed host www.tildeslash.com port 80 protocol http 
     and request "/somefile.html"
     then restart
  if failed port 443 type tcpssl protocol http
     with timeout 15 seconds
     then restart
  if 3 restarts within 5 cycles then timeout
  depends on apache_bin
  group server

  
1. PROCESS UPTIME TESTING 程序运行了多长时间测试
IF UPTIME [[operator] value [unit]] THEN action
operator : "<", ">", "!=", "==" 或者 "GT", "LT", "EQ", "NE" 或者 "GREATER", "LESS", "EQUAL", "NOTEQUAL"
value    : uptime watermark.  
unit     : "SECOND", "MINUTE", "HOUR"  "DAY" (可能需要需要用 "SECONDS", "MINUTES", "HOURS", or "DAYS").  
action   ："ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".

check process myapp with pidfile /var/run/myapp.pid 
    start program = "/etc/init.d/myapp start" 
    stop program = "/etc/init.d/myapp stop" 
    if uptime > 3 days then restart
    
2. PROGRAM STATUS TESTING  程序当前状态
IF STATUS operator value THEN action
IF CHANGED STATUS THEN action
operator : "<", ">", "!=", "==" 或者 "GT", "LT", "EQ", "NE" 或者 "GREATER", "LESS", "EQUAL", "NOTEQUAL"
action   ："ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".

check program myscript with path /usr/local/bin/myscript.sh
    if status != 0 then alert
check program list-files with path "/bin/ls -lrt /tmp/" 
    if status != 0 then alert

check program ls with path "/bin/ls /tmp" as uid "www" and gid "staff" 
    if status != 0 then alert    
程序的检查是异步进行的。monit不会等待指定停止进程停止以后再执行下条monitrc的配置；
monit也不会等待指定启动进程启动以后再执行下条monitrc的配置。monit会在下个周期检查进程
启动和停止情况，如果异常上报异常。
    
check program hwtest 
    with path /usr/local/bin/hwtest.sh with timeout 500 seconds 
    if status = 1 then alert 
    if status = 3 for 5 cycles then exec "/usr/local/bin/emergency.sh"

3. PPID TESTING #检查进程的父进程发生变化
IF CHANGED PPID THEN action  

check process myproc with pidfile /var/run/myproc.pid 
    if changed ppid then exec "/my/script"
    
4. PID TESTING #检查进程的自身PID发生变化，该PID由monit管理
IF CHANGED PID THEN action
check process sshd with pidfile /var/run/sshd.pid 
    if changed pid then alert

5. GID TESTING ##  file, fifo, directory or process
IF FAILED GID group THEN action
check file shadow with path /etc/shadow
       if failed gid shadow then alert

6. UID TESTING ## file, fifo, directory or owner and effective user of a process.
IF FAILED [E]UID user THEN action
check file shadow with path /etc/shadow 
    if failed uid root then alert


    
}

FILE()
{
CHECK FILE <unique name> PATH <path>

1. GID TESTING ##  file, fifo, directory or process
IF FAILED GID group THEN action
check file shadow with path /etc/shadow
       if failed gid shadow then alert

2. UID TESTING ## file, fifo, directory or owner and effective user of a process.
IF FAILED [E]UID user THEN action
check file shadow with path /etc/shadow 
    if failed uid root then alert
    
3. PERMISSION TESTING   ## file, fifo, directory or owner and effective user of a process.
IF FAILED PERM(ISSION) octalnumber THEN action    
IF CHANGED PERM(ISSION) THEN action
 check file shadow with path /etc/shadow
       if failed permission 0640 then alert    
       
4. FILE CONTENT TESTING
IF [NOT] MATCH {regex|path} THEN action
# regex ： man  regex(7)
# path  ； 绝对路径
# NOT 
check file syslog with path /var/log/syslog 
    ignore match "^monit" 
    if match "^mrcoffee" then alert
对比前511个字符。

5. FILE SIZE TESTING
IF SIZE [[operator] value [unit]] THEN action
IF CHANGED SIZE THEN action
#  operator： "<", ">", "!=", "==" 或 "GT", "LT", "EQ", "NE" 或者 "GREATER", "LESS", "EQUAL", "NOTEQUAL"       
#  value ：watermark.
# unit : "B","KB","MB","GB" 或者 "byte", "kilobyte", "megabyte", "gigabyte".
check file mydb with path /data/mydatabase.db 
    if size > 1 GB then alert

6. TIMESTAMP TESTING # file, fifo, directory 时间戳
IF TIMESTAMP [[operator] value [unit]] THEN action
IF CHANGED TIMESTAMP THEN action
#  operator： "<", ">", "!=", "==" 或 "GT", "LT", "EQ", "NE" 或者 "GREATER", "LESS", "EQUAL", "NOTEQUAL"       
#  value ：watermark.
# unit ： "SECOND(S)", "MINUTE(S)", "HOUR(S)" or "DAY(S)".
check file apache_conf with path /etc/apache/httpd.conf 
    if changed timestamp then exec "/usr/bin/apachectl graceful"

check directory bar path /foo/bar
       if timestamp < 1 hour then alert

7. FILE CHECKSUM TESTING
 IF FAILED [MD5|SHA1] CHECKSUM [EXPECT checksum] THEN action
 IF CHANGED [MD5|SHA1] CHECKSUM THEN action

if failed checksum 
    expect 8f7f419955cefa0b33a2ba316cba3659 
then alert

check file apache_conf with path /etc/apache/httpd.conf
     if changed checksum then exec "/usr/bin/apachectl graceful"
     
8. EXISTENCE TESTING     
check file with path /cifs/mydata 
if does not exist 
then exec "/usr/bin/mount_cifs.sh" 


  
}

FIFO()
{
CHECK FIFO <unique name> PATH <path>
1. GID TESTING ##  file, fifo, directory or process
IF FAILED GID group THEN action
check file shadow with path /etc/shadow
       if failed gid shadow then alert

2. UID TESTING ## file, fifo, directory or owner and effective user of a process.
IF FAILED [E]UID user THEN action
check file shadow with path /etc/shadow 
    if failed uid root then alert
    
3. PERMISSION TESTING   ## file, fifo, directory or owner and effective user of a process.
IF FAILED PERM(ISSION) octalnumber THEN action    
IF CHANGED PERM(ISSION) THEN action
 check file shadow with path /etc/shadow
       if failed permission 0640 then alert  
       
4. TIMESTAMP TESTING # file, fifo, directory 时间戳
IF TIMESTAMP [[operator] value [unit]] THEN action
IF CHANGED TIMESTAMP THEN action
#  operator： "<", ">", "!=", "==" 或 "GT", "LT", "EQ", "NE" 或者 "GREATER", "LESS", "EQUAL", "NOTEQUAL"       
#  value ：watermark.
# unit ： "SECOND(S)", "MINUTE(S)", "HOUR(S)" or "DAY(S)".
check file apache_conf with path /etc/apache/httpd.conf 
    if changed timestamp then exec "/usr/bin/apachectl graceful"

check directory bar path /foo/bar
       if timestamp < 1 hour then alert
       
}

FILESYSTEM()
{
CHECK FILESYSTEM <unique name> PATH <path>
1. PERMISSION TESTING   ## file, fifo, directory or owner and effective user of a process.
IF FAILED PERM(ISSION) octalnumber THEN action    
IF CHANGED PERM(ISSION) THEN action
 check file shadow with path /etc/shadow
       if failed permission 0640 then alert  
       
2. INODE TESTING #filesystem
IF INODE(S) operator value [unit] THEN action
IF INODE(S) FREE operator value [unit] THEN action
check filesystem rootfs with path /
       if inode usage > 90% then alert      
       
3. SPACE TESTING  #filesystem or a disk
IF SPACE operator value unit THEN action
IF SPACE FREE operator value unit THEN action
check filesystem rootfs with path / 
    if space usage > 90% then alert
    
4. FILESYSTEM FLAGS TESTING
IF CHANGED FSFLAGS THEN action
check filesystem rootfs with path /
       if changed fsflags then exec "/my/script"

    
}

DIRECTORY()
{
CHECK DIRECTORY <unique name> PATH <path>
1. GID TESTING ##  file, fifo, directory or process
IF FAILED GID group THEN action
check file shadow with path /etc/shadow
       if failed gid shadow then alert

2. UID TESTING ## file, fifo, directory or owner and effective user of a process.
IF FAILED [E]UID user THEN action
check file shadow with path /etc/shadow 
    if failed uid root then alert
    
3. PERMISSION TESTING   ## file, fifo, directory or owner and effective user of a process.
IF FAILED PERM(ISSION) octalnumber THEN action    
IF CHANGED PERM(ISSION) THEN action
 check file shadow with path /etc/shadow
       if failed permission 0640 then alert     
       
4. TIMESTAMP TESTING # file, fifo, directory 时间戳
IF TIMESTAMP [[operator] value [unit]] THEN action
IF CHANGED TIMESTAMP THEN action
#  operator： "<", ">", "!=", "==" 或 "GT", "LT", "EQ", "NE" 或者 "GREATER", "LESS", "EQUAL", "NOTEQUAL"       
#  value ：watermark.
# unit ： "SECOND(S)", "MINUTE(S)", "HOUR(S)" or "DAY(S)".
check file apache_conf with path /etc/apache/httpd.conf 
    if changed timestamp then exec "/usr/bin/apachectl graceful"

check directory bar path /foo/bar
       if timestamp < 1 hour then alert    
}

HOST()
{
CHECK HOST <unique name> ADDRESS <host address>
}

SYSTEM()
{
CHECK SYSTEM <unique name>
}

PROGRAM()
{
CHECK PROGRAM <unique name> PATH <executable file> [TIMEOUT <number> SECONDS]
}

NETWORK()
{
CHECK NETWORK <unique name> <ADDRESS <ipaddress> | INTERFACE <name>>

1. A network link failed (链路和接口出现关闭或者错误)
# IF FAILED LINK THEN action
# action : "ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".

check network eth0 with interface eth0 
    if failed link then alert

check network eth0 with interface eth0 
    start program = '/sbin/ipup eth0' 
    stop program = '/sbin/ipdown eth0' 
    if failed link then restart
    
2. A network link capacity changed (链路容量发生变化：最大传输速度陡降或者双工变成单工)
虚拟接口或者VMware网络接口不支持该功能。
# IF CHANGED LINK [CAPACITY] THEN action
# action : "ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".
check network eth0 with interface eth0 
    if changed link capacity then alert
    
3. A network link saturation failed (当前数据传输速度与容量比值)
不是所有的接口都支持；具体查看LINK SPEED 描述。
# IF SATURATION operator value% THEN action
# operator : "<",">","!=","==" 或者 "gt", "lt", "eq", "ne"  或者 "greater", "less", "equal", "notequal"  
# action : "ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".
check network eth0 with interface eth0 
    if saturation > 90% then alert

4. A network link upload/download rate failed(24小时内带宽使用情况，可以是当前的上传带宽，
当前的下载带宽，24小时内下载总量，24小时内上传总量)
总量计数时间为1天内，不能超过一天。
# IF UPLOAD operator value unit THEN action
# IF DOWNLOAD operator value unit THEN action
# IF TOTAL UPLOAD operator value unit IN LAST number time-unit THEN action
# IF TOTAL DOWNLOAD operator value unit IN LAST number time-unit THEN action
# operator : "<",">","!=","==" 或者 "gt", "lt", "eq", "ne"  或者 "greater", "less", "equal", "notequal"  
# unit: "B","KB","MB","GB" 或者  "byte", "kilobyte", "megabyte", "gigabyte".
# time-unit ： "MINUTE(S)", "HOUR(S)", "DAY"
# action : "ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".

check network eth0 with interface eth0 
    if upload > 500 kB/s then alert 
    if total download > 1 GB in last 2 hours then alert 
    if total download > 10 GB in last day then alert

5. A network link upload/download rate failed (以数据包为计量单位计算)
# IF UPLOAD operator value PACKETS/S THEN action
# IF DOWNLOAD operator value PACKETS/S THEN action
# IF TOTAL UPLOAD operator value PACKETS IN LAST number time-unit THEN action
# IF TOTAL DOWNLOAD operator value PACKETS IN LAST number time-unit THEN action
# operator : "<",">","!=","==" 或者 "gt", "lt", "eq", "ne"  或者 "greater", "less", "equal", "notequal"  .
# time-unit ： "MINUTE(S)", "HOUR(S)", "DAY"
# action : "ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR".

check network eth0 with interface eth0 
    if upload > 1000 packets/s then alert 
    if total upload > 900000 packets in last hour then alert

6. ping test
IF FAILED PING[4|6] 
    [COUNT number] [WITH] [TIMEOUT number SECONDS] 
THEN action    

check host mmonit.com with address mmonit.com 
    if failed ping then alert # IPv4 or IPv6 
check host mmonit.com with address 62.109.39.247 
    if failed ping then alert # Address is IPv4 so IPv4 is preferred
    
check host mmonit.com with address mmonit.com 
     if failed ping4 then alert # IPv4 only if failed ping6 then alert # IPv6 only    

check host mmonit.com with address mmonit.com
        if failed ping count 5 with timeout 10 seconds then alert

7. tcp connection test 根据端口和Unix Socket
7.1 TCP Socket
 IF FAILED
    [host]
    <port>
    [ipversion]
    [type]
    [protocol | {send/expect}+]
    [timeout]
    [retry]
 THEN action
 
7.2 unixsocket
 IF FAILED
    <unixsocket>
    [type]
    [protocol | {send/expect}+]
    [timeout]
    [retry]
 THEN action
 
 host: HOST
 port: PORT number.
 unixsocket: UNIXSOCKET path.
 ipversion: IPV4 | IPV6 
 type: TYPE {TCP|UDP|TCPSSL}. 
        TCPSSL [SSLAUTO|SSLV2|SSLV3|TLSV1|TLSV11|TLSV12] [CERTMD5 md5sum]
 timeout: [WITH] TIMEOUT number SECONDS. 
 retry: RETRY number.
 action: ALERT", "RESTART", "START", "STOP", "EXEC" or "UNMONITOR
 
 if failed port 80 then alert 
 if failed port 53 type udp protocol dns then alert 
 if failed unixsocket /var/run/sophie then alert
 
if failed 
    port 25 and 
    expect "^220.*" 
    send "HELO localhost.localdomain\r\n" 
    expect "^250.*" 
    send "QUIT\r\n" 
then alert

if failed 
    port 80 
    protocol http 
    request "/data/show?a=b&c=d" 
then restart

if failed 
    port 80 
    protocol http 
    request "/non/existent.php" 
    status = 404 
then alert

if failed 
    port 80 protocol http 
    request "/page.html" 
    checksum 8f7f419955cefa0b33a2ba316cba3659 
then alert


}

Keyword()
{
Here are the legal global keywords:

 Keyword         Function
 ----------------------------------------------------------------
 set daemon      Set a background poll interval in seconds.
 
 守护模式（DAEMON MODE）
use
   set daemon n (where n is a number in seconds)
如果你没有指定这个命令set daemon，那么monit将会运行一次，然后退出，这在某些地方可能会有用处，
但是monit当初设计就是设计为守护进程的
 
 set init        Set Monit to run from init. Monit will not
                 transform itself into a daemon process.
                 
set init 让阻止monit转换他自己为一个守护进程，而把monit作为一个前台进程，
         但是你仍然要在配置文件中设置set daemon，以此来设置轮询的时间
         从init启动是一个最好的方式了，因为这样你可以保证你的系统里面始终有一个Monit进程                 
                 
 set logfile     Name of a file to dump error- and status-
                 messages to. If syslog is specified as the 
                 file, Monit will utilize the syslog daemon
                 to log messages. This can optionally be 
                 followed by 'facility <facility>' where 
                 facility is 'log_local0' - 'log_local7' or 
                 'log_daemon'. If no facility is specified, 
                 LOG_USER is used.
                 
 set mailserver  The mailserver used for sending alert
                 notifications. If the mailserver is not 
                 defined, Monit will try to use 'localhost' 
                 as the smtp-server for sending mail. You 
                 can add more mail servers, if Monit cannot
                 connect to the first server it will try the
                 next server and so on.
                 
 set mail-format Set a global mail format for all alert
                 messages emitted by monit.
                 
 set idfile      Explicit set the location of the Monit id
                 file. E.g. set idfile /var/monit/id.
 set pidfile     Explicit set the location of the Monit lock
                 file. E.g. set pidfile /var/run/xyzmonit.pid.
 set statefile   Explicit set the location of the file Monit 
                 will write state data to. If not set, the
                 default is $HOME/.monit.state. 
 set httpd port  Activates Monit http server at the given 
                 port number.
                 
set httpd port 2812 
    allow localhost 
    allow my.other.work.machine.com 
    allow 10.1.1.1 
    allow 192.168.1.0/255.255.255.0 
    allow 10.0.0.0/8

 
 ssl enable      Enables ssl support for the httpd server.
                 Requires the use of the pemfile statement.
 ssl disable     Disables ssl support for the httpd server.
                 It is equal to omitting any ssl statement.
 pemfile         Set the pemfile to be used with ssl.
 clientpemfile   Set the pemfile to be used when client
                 certificates should be checked by monit.
 address         If specified, the http server will only 
                 accept connect requests to this addresses
                 This statement is an optional part of the
                 set httpd statement.
 allow           Specifies a host or IP address allowed to
                 connect to the http server. Can also specify
                 a username and password allowed to connect
                 to the server. More than one allow statement
                 are allowed. This statement is also an 
                 optional part of the set httpd statement.
 read-only       Set the user defined in username:password
                 to read only. A read-only user cannot change
                 a service from the Monit web interface.
 include         include a file or files matching the globstring

 Here are the legal service entry keywords:

 Keyword         Function
 ----------------------------------------------------------------
 check           Starts an entry and must be followed by the type
                 of monitored service {filesystem|directory|file|host
                 process|system} and a descriptive name for the
                 service.
 pidfile         Specify the  process pidfile. Every
                 process must create a pidfile with its
                 current process id. This statement should only
                 be used in a process service entry.
 path            Must be followed by a path to the block
                 special file for filesystem, regular
                 file, directory or a process s pidfile.
 group           Specify a groupname for a service entry.
 start           The program used to start the specified 
                 service. Full path is required. This 
                 statement is optional, but recommended.
 stop            The program used to stop the specified
                 service. Full path is required. This 
                 statement is optional, but recommended.
 pid and ppid    These keywords may be used as standalone
                 statements in a process service entry to
                 override the alert action for change of
                 process pid and ppid.
 uid and gid     These keywords are either 1) an optional part of
                 a start, stop or exec statement. They may be
                 used to specify a user id and a group id the
                 program (process) should switch to upon start.
                 This feature can only be used if the superuser
                 is running monit. 2) uid and gid may also be
                 used as standalone statements in a file service
                 entry to test a file is uid and gid attributes.
 host            The hostname or IP address to test the port
                 at. This keyword can only be used together
                 with a port statement or in the check host
                 statement.
 port            Specify a TCP/IP service port number which 
                 a process is listening on. This statement
                 is also optional. If this statement is not
                 prefixed with a host-statement, localhost is
                 used as the hostname to test the port at.
 type            Specifies the socket type Monit should use when
                 testing a connection to a port. If the type
                 keyword is omitted, tcp is used. This keyword
                 must be followed by either tcp, udp or tcpssl.
 tcp             Specifies that Monit should use a TCP 
                 socket type (stream) when testing a port.
 tcpssl          Specifies that Monit should use a TCP socket
                 type (stream) and the secure socket layer (ssl)
                 when testing a port connection.
 udp             Specifies that Monit should use a UDP socket
                 type (datagram) when testing a port.
 certmd5         The md5 sum of a certificate a ssl forged 
                 server has to deliver.
 proto(col)      This keyword specifies the type of service 
                 found at the port. See CONNECTION TESTING
                 for list of supported protocols.
                 You are welcome to write new protocol test
                 modules. If no protocol is specified Monit will
                 use a default test which in most cases are good
                 enough.
 request         Specifies a server request and must come
                 after the protocol keyword mentioned above.
                  - for http it can contain an URL and an
                    optional query string.
                  - other protocols does not support this
                    statement yet
 send/expect     These keywords specify a generic protocol. 
                 Both require a string whether to be sent or
                 to be matched against (as extended regex if 
                 supported).  Send/expect can not be used 
                 together with the proto(col) statement.
 unix(socket)    Specifies a Unix socket file and used like 
                 the port statement above to test a Unix 
                 domain network socket connection.
 URL             Specify an URL string which Monit will use for
                 connection testing.
 content         Optional sub-statement for the URL statement.
                 Specifies that Monit should test the content
                 returned by the server against a regular 
                 expression.
 timeout x sec.  Define a network port connection timeout. Must
                 be followed by a number in seconds and the 
                 keyword, seconds.
 timeout         Define a service timeout. Must be followed by
                 two digits. The first digit is max number of
                 restarts for the service. The second digit
                 is the cycle interval to test restarts. 
                 This statement is optional.
 alert           Specifies an email address for notification
                 if a service event occurs. Alert can also
                 be postfixed, to only send a message for
                 certain events. See the examples above. More
                 than one alert statement is allowed in an
                 entry. This statement is also optional.
 noalert         Specifies an email address which do not want
                 to receive alerts. This statement is also
                 optional.
 restart, stop   These keywords may be used as actions for 
 unmonitor,      various test statements. The exec statement is
 start and       special in that it requires a following string
 exec            specifying the program to be execute. You may
                 also specify an UID and GID for the exec 
                 statement. The program executed will then run
                 using the specified user id and group id.
 mail-format     Specifies a mail format for an alert message 
                 This statement is an optional part of the
                 alert statement.
 checksum        Specify that Monit should compute and monitor a
                 file is md5/sha1 checksum. May only be used in a 
                 check file entry.
 expect          Specifies a md5/sha1 checksum string Monit 
                 should expect when testing the checksum. This 
                 statement is an optional part of the checksum 
                 statement.
 timestamp       Specifies an expected timestamp for a file
                 or directory. More than one timestamp statement
                 are allowed. May only be used in a check file or
                 check directory entry.
 changed         Part of a timestamp statement and used as an
                 operator to simply test for a timestamp change.
 every           Validate this entry only at every n poll cycle.
                 Useful in daemon mode when the cycle is short
                 and a service takes some time to start.
 mode            Must be followed either by the keyword active,
                 passive or manual. If active, Monit will restart
                 the service if it is not running (this is the
                 default behavior). If passive, Monit will not
                 (re)start the service if it is not running - it
                 will only monitor and send alerts (resource
                 related restart and stop options are ignored
                 in this mode also). If manual, Monit will enter
                 active mode only if a service was started under
                 monit's control otherwise the service isn't
                 monitored.
 cpu             Must be followed by a compare operator, a number 
                 with "%" and an action. This statement is used
                 to check the cpu usage in percent of a process
                 with its children over a number of cycles. If
                 the compare expression matches then the 
                 specified action is executed.
 mem             The equivalent to the cpu token for memory of a 
                 process (w/o children!).  This token must be 
                 followed by a compare operator a number with 
                 unit "{B|KB|MB|GB|%|byte|kilobyte|megabyte|
                 gigabyte|percent}" and an action.
 swap            Token for system swap usage monitoring. This token
                 must be followed by a compare operator a number with 
                 unit "{B|KB|MB|GB|%|byte|kilobyte|megabyte|gigabyte|percent}"
                 and an action.
 loadavg         Must be followed by [1min,5min,15min] in (), a 
                 compare operator, a number and an action. This
                 statement is used to check the system load 
                 average over a number of cycles. If the compare 
                 expression matches then the specified action is 
                 executed.
 children        This is the number of child processes spawn by a
                 process. The syntax is the same as above.
 totalmem        The equivalent of mem, except totalmem is an
                 aggregation of memory, not only used by a
                 process but also by all its child
                 processes. The syntax is the same as above.
 space           Must be followed by a compare operator, a
                 number, unit {B|KB|MB|GB|%|byte|kilobyte|
                 megabyte|gigabyte|percent} and an action.
 inode(s)        Must be followed by a compare operator, integer
                 number, optionally by percent sign (if not, the
                 limit is absolute) and an action.
 perm(ission)    Must be followed by an octal number describing
                 the permissions.
 size            Must be followed by a compare operator, a
                 number, unit {B|KB|MB|GB|byte|kilobyte|
                 megabyte|gigabyte} and an action.
 depends (on)    Must be followed by the name of a service this
                 service depends on.

}