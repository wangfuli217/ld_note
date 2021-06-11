microcom(microcom -t 15000 -s 115200 /dev/ttyS0)
{
-t 单位毫秒，无操作自动退出时间。
-s 单位bps，串口波特率。
ttyS0 要操作的串口。

#microcom -t 5000 -s 115200 /dev/ttyS1
这样，就可以使用ttyS1进行串口通信了。如果要进行AT指令发送，只需输入AT回车即可：
# microcom -t 5000 -s 115200 /dev/ttyS1
AT
OK
# microcom -t 5000 -s 115200 /dev/ttyS1
ATE
OK
}

uptime(09:38:44 up 15:48, load average: 0.00, 0.01, 0.04)
{
time(&current_secs);    localtime(&current_secs);    -> 当前时间
    time_t                  struct tm

sysinfo(&info);           -> info.uptime / (60*60*24);                                           日
 struct sysinfo info;     -> upminutes = (int) info.uptime / 60; upminutes %= 60;                分
                          ->                                   uphours = (upminutes / 60) % 24;  小时
info.loads[0] 1分钟负载
info.loads[1] 5分钟负载
info.loads[2] 15分钟负载                         
}


用于创建文件和修改文件的最近访问时间和修改时间；
1、可以分别修改最近访问时间和最近修改时间
2、可以根据当前时间、根据文件、根据指定时间设置最近访问时间和最近修改时间。
touch(Update the access and modification times of each FILE to the current time.)
{
-r, --reference=FILE 将最近访问时间和修改时间设置成FILE的最近访问时间和修改时间
设置成指定时间 ， 格式： [[CC]YY]MMDDhhmm[.ss] 

修改文件的最近访问和修改时间
int utime(const char *filename, const struct utimbuf *times);
struct utimbuf {
               time_t actime;       /* 最近访问时间 */
               time_t modtime;      /* 最近修改时间 */
           };
如果times为NULL，则将filename的最近修改时间和访问时间设置为当前时间；


创建一个文件
open(*argv, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);

}

用于统计一个程序执行数据。

# -p 以POSIX缺省的时间格式打印时间统计结果，单位为秒。详细的输出格式见例2。
# time -p date

# export TIMEFORMAT=$'real %2R\nuser %2U\nsys %2S'
# time date

# export TIMEFORMAT=$'\nHello, ThinkerABC!\nreal time :       %lR\nuser CUP time :   %lU\nsystem CPU time : %lS'
# time date
            
time(give resource usage)
{
pid = vfork();
BB_EXECVP(cmd[0], cmd); ->  execvp(prog,cmd)
pid_t wait3(int *status, int options, struct rusage *rusage);  ## caught == -1 && errno != EINTR

interrupt_signal = signal(SIGINT, SIG_IGN);
quit_signal = signal(SIGQUIT, SIG_IGN);
signal(SIGINT, interrupt_signal);
signal(SIGQUIT, quit_signal);   

struct rusage {
               struct timeval ru_utime; /* user time used */
               struct timeval ru_stime; /* system time used */
               long   ru_maxrss;        /* maximum resident set size */
               long   ru_ixrss;         /* integral shared memory size */
               long   ru_idrss;         /* integral unshared data size */
               long   ru_isrss;         /* integral unshared stack size */
               long   ru_minflt;        /* page reclaims */
               long   ru_majflt;        /* page faults */
               long   ru_nswap;         /* swaps */
               long   ru_inblock;       /* block input operations */
               long   ru_oublock;       /* block output operations */
               long   ru_msgsnd;        /* messages sent */
               long   ru_msgrcv;        /* messages received */
               long   ru_nsignals;      /* signals received */
               long   ru_nvcsw;         /* voluntary context switches */
               long   ru_nivcsw;        /* involuntary context switches */
           };
}

用于文件类型、文件大小、存在性和两个数字比较、两个字符串比较

test(check file types and compare values)
{
[用于文件类型、文件大小、存在性]
stat(mode_t    st_mode;    /* protection */)
-b FILE     S_ISBLK
-c FILE     S_ISCHR
-d FILE     S_ISDIR
-e FILE     只要打开就存在
-f FILE     S_ISREG
-g FILE     st.st_mode & S_ISGID
-G FILE     
-h FILE     !S_ISLNK(st.st_mode);
-k FILE     
-L FILE     !S_ISLNK(st.st_mode);
-O FILE     
-p FILE     S_ISFIFO(st.st_mode)
-r FILE     access(toys.optargs[1], 1 << (id - 12)) == -1;
-s FILE     [FILE exists and has a size greater than zero]
-S FILE     S_ISSOCK(st.st_mode)
-t FD       tcgetattr(atoi(toys.optargs[1]), &termios) == -1;
-u FILE     st.st_mode & S_ISUID
-w FILE     access(toys.optargs[1], 1 << (id - 12)) == -1;
-x FILE     access(toys.optargs[1], 1 << (id - 12)) == -1;
-z FILE     toys.optargs[1] && !*toys.optargs[1] ^ (id - 15);
-n FILE     toys.optargs[1] && !*toys.optargs[1] ^ (id - 15);      
[两个数字比较]
long a = atol(toys.optargs[0]), b = atol(toys.optargs[2]);
"eq" a != b;
"ne" a == b;
"gt" a < b;
"ge" a <= b;
"lt" a > b;
"le" a >= b; 
[两个字符串比较]
strcmp

S_IFMT     0170000   bit mask for the file type bit fields
S_IFSOCK   0140000   socket
S_IFLNK    0120000   symbolic link
S_IFREG    0100000   regular file
S_IFBLK    0060000   block device
S_IFDIR    0040000   directory
S_IFCHR    0020000   character device
S_IFIFO    0010000   FIFO
S_ISUID    0004000   set UID bit
S_ISGID    0002000   set-group-ID bit (see below)
S_ISVTX    0001000   sticky bit (see below)
S_IRWXU    00700     mask for file owner permissions
S_IRUSR    00400     owner has read permission
S_IWUSR    00200     owner has write permission
S_IXUSR    00100     owner has execute permission
S_IRWXG    00070     mask for group permissions
S_IRGRP    00040     group has read permission
S_IWGRP    00020     group has write permission
S_IXGRP    00010     group has execute permission
S_IRWXO    00007     mask for permissions for others (not in group)
S_IROTH    00004     others have read permission
S_IWOTH    00002     others have write permission
S_IXOTH    00001     others have execute permission

}

启动一个进程并设置进程的亲和性
  taskset 03 sshd -b 1024
获取一个进程的CPU亲和性
  taskset -p 700
设置一个进程的CPU亲和性
  taskset -p 03 700
以列表的形式，设置进程的亲和性
  taskset -pc 0,3,7-11 700

设置和获取执行进程的亲和性；该进程可以是已运行的进程，也可以是由taskset自身启动的进程。
taskset(retrieve or set a process’s CPU affinity)
{

int sched_setaffinity(pid_t pid, size_t cpusetsize,  cpu_set_t *mask);
int sched_getaffinity(pid_t pid, size_t cpusetsize,  cpu_set_t *mask);

/* 将数值转换为掩码 */
# for (j = 0; j<k; j++) {
#       unsigned long digit = *(--s) - '0';
# 
#       if (digit > 9) digit = 10 + tolower(*s)-'a';
#       if (digit > 15) error_exit("bad mask '%s'", *toys.optargs);
#       mask[j/(2*sizeof(long))] |= digit << 4*(j&((2*sizeof(long))-1));
#     }
# }

sync(Write all pending data to disk)
{
sync();
}

管理/etc/sysctl.conf文件和/proc/sys/下文件中关联的内核参数
kernel.msgmnb = 65536 中的.点对应为配置过程的/
sysctl(read and manipulate the sysctl parameters)
{
-a 递归查看/proc/sys目录下文件，并打印文件的内容。
    -n 不打印键名
    -N 不打印键值
-p 从/etc/sysctl.conf读取配置，并将配置设置给内核。

usage:  sysctl [-n] [-e] variable ...
        sysctl [-n] [-e] [-q] -w variable=value ...
        sysctl [-n] [-e] -a
        sysctl [-n] [-e] [-q] -p <file>   (default /etc/sysctl.conf)
        sysctl [-n] [-e] -A
}


/dev/log
/etc/syslog.conf 
/var/log/messages
syslogd与klogd(监控linux内核提交的消息)守护进程负责记录,发送系统或工具产生的信息,二者的配置文件都是/etc/syslog.conf.
当系统内核或工具产生信息时,通过调用相关函数将信息发送到syslogd或klogd守护进程.syslogd与klogd守护进程会根据
/etc/syslog.conf中的配置信息,对消息的去向作出处理.

将从/dev/log socket获得的信息根据/etc/syslog.conf 转发到对应的文件和服务器。

syslogd(a system logging utility)
{
syslogd  [-a socket] [-O logfile] [-f config file] [-m interval]
                  [-p socket] [-s SIZE] [-b N] [-R HOST] [-l N] [-nSLKD]
                  
 -f: /etc/syslog.conf                   ##指定配置文件和默认配置文件
 -a      Extra unix socket for listen   ## 监听额外的unix socket
 
 用于监听多个unix socket
# struct unsocks {
#   struct unsocks *next;
#   char *path;
#   struct sockaddr_un sdu;
#   int sd;
# };

for (temp = strtok(TT.socket, ":"); temp; temp = strtok(NULL, ":"))

<unix socket>
1. tsd->sdu.sun_family = AF_UNIX;
2. strcpy(tsd->sdu.sun_path, tsd->path);
3. tsd->sd = socket(AF_UNIX, SOCK_DGRAM, 0);
4. unlink(tsd->sdu.sun_path);
5. bind(tsd->sd, (struct sockaddr *) &tsd->sdu, sizeof(tsd->sdu));
6. chmod(tsd->path, 0777);

int flags = fcntl(TT.sigfd[1], F_GETFL);
fcntl(TT.sigfd[1], F_SETFL, flags | O_NONBLOCK);

< if -K then open only /dev/kmsg >

}

详细情况可参见：RFC3164
syslogd(syslog.conf)
{
"facility.level"部分也被称为选择符(seletor). seletor和action之间使用一个或多个空白分隔.它指定了一系列日志
记录规则.规则的格式如下:
    seletor(facility.level)    action
    选择符(seletor)(选择符由 facility 和 level 两部分组成,之间用一个句点(.)连接)
    
A.facility 指定了产生日志的子系统,可以是下面的关键字之一:
                关键字              值       解释
                kern                0        内核信息,首先通过 klogd 传递.
                user                1        由用户程序生成的信息.
                mail                2        与电子邮件有关的信息.
                daemon              3        与 inetd 守护进程有关的信息.
                auth                4        由 pam_pwdb 报告的认证活动.
                syslog              5        由 syslog 生成的信息.
                lpr                 6        与打印服务有关的信息.
                news                7        来自新闻服务器的信息.
                uucp                8        由 uucp 生成的信息.(uucp = unix to unix copy)
                cron                9        与 cron 和 at 有关的信息.
                authpriv           10        包括私有信息(如用户名)在内的认证活动
                ftp                11        与 FTP 有关的信息.
                                12-15        系统保留
                local0 ~ local7  16-23        由自定义程序使用,例如使用 local5 做为 ssh 功能
                mark                         syslog内部功能用于生成时间戳.
                *                            通配符代表除了 mark 以外的所有功能
        在大多数情况下,任何程序都可以通过任何facility发送日志消息,但是一般都遵守约定俗成的规则.比如,只有内核才能使用"kern"facility.

B.level指定了消息的优先级,可以是下面的关键字之一(降序排列,严重性越来越低)：
                关键字               值        解释
                emerg                0        系统不可用
                alert                1        需要立即被修改的条件
                crit                 2        (临界)阻止某些工具或子系统功能实现的错误条件
                err                  3        阻止工具或某些子系统部分功能实现的错误条件
                warning              4        预警信息
                notice               5        具有重要性的普通条件
                info                 6        提供信息的消息
                debug                7        不包含函数条件或问题的其他信息
                none                          (屏蔽所有来自指定设备的消息)没有优先级,通常用于排错
                *                             除了none之外的所有级别
        facility部分可以是用逗号(,)分隔的多个子系统,而多个seletor之间也可以通过分号(;)组合在一起.
        注意:多个组合在一起的选择符,后面的会覆盖前面的,这样就允许从模式中排除一些优先级.
动作(action)
        动作确定了syslogd与klogd守护进程将日志消息发送到什么地方去.有以下几种选择：
        普通文件        使用文件的绝对路径来指明日志文件所在的位置,例如：/var/log/cron.
        终端设备        终端可以是/dev/tty0~/dev/tty6,也可以为/dev/console.
        用户列表        例如动作为“root hackbutter”,将消息写入到用户root与hackbutter的计算机屏幕上.
        远程主机        将信息发往网络中的其他主机的syslogd守护进程,格式为“@hostname”.
 
 
        配置文件的语法说明
                (1)    *用作设备或优先级时,可以匹配所有的设备或优先级.
                (2)    *用作动作时,将消息发送给所有的登录用户.
                (3)    多个选择器可在同一行中,并使用分号分隔开,且后面的会覆盖前面的.如,uucp,news.crit.
                (4)    关键字none用作优先级时,会屏蔽所有来自指定设备的消息.
                (5)    通过使用相同的选择器和不同的动作,同一消息可以记录到多个位置.
                (6)    syslog.conf文件中后面的配置行不会覆盖前面的配置行,每一行指定的动作都独立的运作.  
实例详解：
        //将info或更高级别的消息送到/var/log/messages,除了mail,authpriv,cron以外.
        //其中*是通配符,代表任何设备；none表示不对任何级别的信息进行记录.
        *.info;mail.none;authpriv.none;cron.none                /var/log/messages
        //将mail设备中的任何级别的信息记录到/var/log/maillog文件中,这主要是和电子邮件相关的信息.
        mail.*                                                  -/var/log/maillog
 
        //将authpirv设备的任何级别的信息记录到/var/log/secure文件中,这主要是一些和权限使用相关的信息.
        authpriv.*                                              /var/log/secure
        //将cron设备中的任何级别的信息记录到/var/log/cron文件中,这主要是和系统中定期执行的任务相关的信息.
        cron.*                                                  /var/log/cron
        //将任何设备的emerg(系统不可用)级别的信息发送给所有正在系统上的用户.
        *.emerg                                                 *
        //将uucp和news设备的crit(临界)级别的信息记录到/var/log/spooler文件中.
        uucp,news.crit                                          /var/log/spooler
        //将和系统启动相关的信息记录到/var/log/boot.log文件中.
        local7.*                                                /var/log/boot.log
}


tac(concatenate and print files in reverse)
{
struct arg_list {
  struct arg_list *next;
  char *arg;
};
void loopfiles_rw(char **argv, int flags, int permissions, int failok,
  void (*function)(int fd, char *name))

  printf 方式输出
}

cat(concatenate files and print on the standard output)
{
  fputc 方式输出
}

tail(-n lines)
{
c, bytes=N  输出最后N个字节
n, lines=N  输出最后N行,而非默认的最后10行
f, follow[={name|descriptor}] 当文件增长时, 输出后续添加的数据; -f, --follow 以 及 --follow=descriptor 都是相同的意思
}

head(-n lines)
{
-c, --bytes=SIZE打印起始的SIZE字节
-n, --lines=NUMBER显示起始的NUMBER行,而非默认的起始10行
}

more(){}

tar(Create, extract, or list files from a tar file)
{
tar -[cxtzhmvO] [-X FILE] [-T FILE] [-f TARFILE] [-C DIR]
  
}

Create UDP socket, bind to IP:PORT and wait
Create TCP socket, bind to IP:PORT and listen

tcpsvd(TCP(UDP)/IP service daemon ) ??
{
    usage: tcpsvd [-hEv] [-c N] [-C N[:MSG]] [-b N] [-u User] [-l Name] IP Port Prog
    usage: udpsvd [-hEv] [-c N] [-u User] [-l Name] IP Port Prog
    
    ip              IP to listen on. '0' = all
    port            Port to listen on
    prog [arg]      Program to run
    -l name         Local hostname (else looks up local hostname in DNS)
    -u user[:group] Change to user/group after bind
    -c n            Handle up to n connections simultaneously
    -b n            Allow a backlog of approximately n TCP SYNs
    -C n[:msg]      Allow only up to n connections from the same IP
                    New connections from this IP address are closed
                    immediately. 'msg' is written to the peer before close
    -h              Look up peer s hostname
    -E              Do not set up environment variables
    
}

可以将从stdin的输入，输出到多个文件和stdout
tee(cat to multiple outputs.)
{
usage: tee [-ai] [file...]
    -a	append to files.
    -i	ignore SIGINT.
    
echo i\'m a little teapot | busybox tee -a bar >/dev/null
echo i\'m a little teapot | busybox tee bar >baz

}

一个从stdin到server之间转发数据的转发器，通过poll进行读写阻塞

telnet(telnet ip:23) ????
{
  TT.win_width = 80; //columns
  TT.win_height = 24; //rows
  
  TT.ttype = getenv("TERM");
  if(!TT.ttype) TT.ttype = "";
  if(strlen(TT.ttype) > IACBUFSIZE-1) TT.ttype[IACBUFSIZE - 1] = '\0';

  if (!tcgetattr(0, &TT.def_term)) {
    TT.term_ok = 1;
    TT.raw_term = TT.def_term;
    cfmakeraw(&TT.raw_term);
  }
  terminal_size(&TT.win_width, &TT.win_height);
  
  
}

telnetd(????)
{
#include <pty.h>
int openpty(int *amaster, int *aslave, char *name,const struct termios *termp,  const struct winsize *winp);
pid_t forkpty(int *amaster, char *name, const struct termios *termp,const struct winsize *winp);
#include <utmp.h>
int login_tty(int fd);
Link with -lutil.

forkpty combines openpty(), fork(2), and login_tty() to create a new process operating in a pseudoterminal.

https://github.com/fffaraz/inSecure-SHell

}


chmod(who处理operator处理permission处理)
{
命令格式：chmod [who] operator [permission] filename

    who包含的选项及其含义：
        u 文件属主权限。
        g 属组用户权限。
        o 其他用户权限。
        a 所有用户(文件属主、属组用户及其他用户)。

    operator包含的选项及其含义：
        + 增加权限。
        - 取消权限。
        = 设定权限。
    
    permission包含的选项及其含义：
        r 读权限。
        w 写权限。
        x 执行权限。
        s 文件属主和组set-ID。
        t 粘性位*。
        l 给文件加锁，使其他用户无法访问。
        u,g,o 针对文件属主、属组用户及其他用户的操作。
}


bootchartd()
{

}

dd(指定大小的块拷贝一个文件，并在拷贝的同时进行指定的转换)
{
    usage: dd [if=FILE] [of=FILE] [ibs=N] [obs=N] [bs=N] [count=N] [skip=N]
            [seek=N] [conv=notrunc|noerror|sync|fsync]

    Options:
    if=FILE   Read from FILE instead of stdin
    of=FILE   Write to FILE instead of stdout
    bs=N      Read and write N bytes at a time
    ibs=N     Read N bytes at a time
    obs=N     Write N bytes at a time
    count=N   Copy only N input blocks
    skip=N    Skip N input blocks
    seek=N    Skip N output blocks
    conv=notrunc  Don not truncate output file
    conv=noerror  Continue after read errors
    conv=sync     Pad blocks with zeros
    conv=fsync    Physically write data out before finishing
}

httpd(){
监听接收http请求
-c FILE        配置文件
-p [IP:]PORT   IP地址和端口
-i             Inetd mode
-f             前台运行
-v[v]          详细信息
-u USER[:GRP]  指定用户名和组名
-r REALM
-m PASS
-h HOME
-e STRING
-d STRING

/usr/sbin/httpd -p 80 -h /www
/usr/sbin/httpd -p 8080 -h /www2 -c /etc/httpd2.conf
}
httpd(httpd.conf){

https://wiki.openwrt.org/doc/howto/http.httpd
#
# httpd.conf - BusyBox v1.00 (2005.04.23-22:18+0000) multi-call binary
# Contribute by Dubravko Penezic, dpenezic@gmail.com , 2005-05-15
#

#
# Allow/Deny part
#
# [aA]:from    ip address allow, * for wildcard, network subnet allow
# [dD]:from    ip address deny, * for wildcard, network subnet allow
#
# network subnet definition
#  172.20.                    address from 172.20.0.0/16
#  10.0.0.0/25                address from 10.0.0.0-10.0.0.127
#  10.0.0.0/255.255.255.128   address that previous set
#
#  The Deny/Allow IP logic:
#
#  - Default is to allow all.  No addresses are denied unless
#         denied with a D: rule.
#  - Order of Deny/Allow rules is significant
#  - Deny rules take precedence over allow rules.
#  - If a deny all rule (D:*) is used it acts as a catch-all for unmatched
#       addresses.
#  - Specification of Allow all (A:*) is a no-op
#
# Example:
#   1. Allow only specified addresses
#     A:172.20          # Allow any address that begins with 172.20.
#     A:10.10.          # Allow any address that begins with 10.10.
#     A:127.0.0.1       # Allow local loopback connections
#     D:*               # Deny from other IP connections
#
#   2. Only deny specified addresses
#     D:1.2.3.        # deny from 1.2.3.0 - 1.2.3.255
#     D:2.3.4.        # deny from 2.3.4.0 - 2.3.4.255
#     A:*             # (optional line added for clarity)
#
# Note:
# A:*
# D:*
# Mean deny ALL !!!!
#

A:*

#
# Authentication part
#
# /path:user:pass     username/password
#
# password may be clear text or MD5 cript
#
# Example :
# /cgi-bin:admin:FOO
#
# MD5 crypt password :
# httpd -m "_password_"
# Example :
# httpd -m "astro"  =>  $1$$e6xMPuPW0w8dESCuffefU.
# /work:toor:$1$$e6xMPuPW0w8dESCuffefU.
#

#
# MIME type part
#
# .ext:mime/type   new mime type not compiled into httpd
#
# Example :
# .ipk:application/octet-stream
#
# MIME type compiled into httpd
#
# .htm:text/html
# .html:text/html
# .jpg:image/jpeg
# .jpeg:image/jpeg
# .gif:image/gif
# .png:image/png
# .txt:text/plain
# .h:text/plain
# .c:text/plain
# .cc:text/plain
# .cpp:text/plain
# .css:text/css
# .wav:audio/wav
# .avi:video/x-msvideo
# .qt:video/quicktime
# .mov:video/quicktime
# .mpe:video/mpeg
# .mpeg:video/mpeg
# .mid:audio/midi
# .midi:audio/midi
# .mp3:audio/mpeg
#
# Default MIME type is application/octet-stream if extension isnt set
#

}
httpd(cgi){
Standard set of Comon Gateway Interface environment variable are :

CONTENT_TYPE=application/x-www-form-urlencoded
GATEWAY_INTERFACE=CGI/1.1
REMOTE_ADDR=192.168.1.180
QUERY_STRING=Zbr=1234567&SrceMB=&ime=jhkjhlkh+klhlkjhlk+%A9%D0%C6%AE%C6%AE&prezime=&sektor=OP
REMOTE_PORT=2292
CONTENT_LENGTH=128
REQUEST_URI=/cgi-bin/test
SERVER_SOFTWARE=busybox httpd/1.35 6-Oct-2004
PATH=/bin:/sbin:/usr/bin:/usr/sbin
HTTP_REFERER=http://192.168.1.1/index1.html
SERVER_PROTOCOL=HTTP/1.0
PATH_INFO=
REQUEST_METHOD=POST
PWD=/www/cgi-bin
SERVER_PORT=80
SCRIPT_NAME=/cgi-bin/test
REMOTE_USER=[http basic auth username]

/cgi-bin/test

#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "Sample CGI Output"
echo ""
echo ""
env
echo ""
echo ""
}
hwclock(){
-r      显示硬件时钟时间          ctime(&t);
-s      根据硬件时钟设置系统时间  settimeofday | xioctl(fd, RTC_RD_TIME, &tm);
-w      根据系统时间设置硬件时钟  gettimeofday | xioctl(rtc, RTC_SET_TIME, &tm);
-u      显示UTC时间               oldtz = getenv("TZ"); putenv((char*)"TZ=UTC0"); tzset();
-l      显示localtime时间         localtime(&t)
-f FILE 指定设备文件
}
inetd(){
监听网络连接，并根据连接请求启动程序。
-f 前台运行
-e 通过stderr输出
-q N Socket监听队列大小 128
-R N 每秒接受服务大小N以后，挂起后续网络请求

CONFFILE
# /etc/inetd.conf:  see inetd(8) for further informations.
#echo     stream  tcp   nowait  root    internal

# These are standard services.
vsftpd  stream  tcp     nowait  root    /sbin/vsftpd            /sbin/vsftpd

* 服务名
    服务名是在/etc/services文件中经过定义的有效服务名称(如telnet,echo等)。
    如果服务被用来定义Sun-RPC服务，它就必须在/etc/rpc文件中定义。
* 套接字类型
    stream - stram
    dgram - datagram
    raw - raw
    rdm - reliabl! y delivered message
    seqpacket - sequenced packet
* 协议类型
    /etc/protocols
* wait/nowait[.max]
    Wait/nowait域只用于数据报套接字，其它的都使用nowait参数。
    如果服务是多线程的，意味着在与对端建立连接后将释放套接字，inetd进程可以通过些套接字接收更多的消息，这时些用"nowait"条目。
    如果服务是单线程，表示服务将在同一个socket中处理所有的外来数据报，直到超时，这种情况下使用"wait"条目。
    Max参数，用一个点与wait/nowait隔开，定义了inetd进程在一分钟之内最大产生的实例数目。
* 用户名[.组]
    用户域定义了服务的使用者，组参数，通过点与用户名隔开。定义了除/etc/passwd文件中之外的可以运行服务的组ID。服务程序是在套接字请求时执行的程序的完整路径。
    如果是inted进程内置的服务，此处应为“internally”。服务程序参数提供程序运行的所需的参数，同样的，如果是内置服务，此处也为“internally”。
* 服务程序
* 服务程序的参数

telnet   stream   tcp      ;nowait   root     /usr/sbin/tcpd   in.telnetd
    服务名:   telnet
    套接字类型:   stream
    协议类型:   tcp
    Wait/Nowait[.max]: nowait
    用户名[.组]:   root
    服务程序:   /usr/sbin/tcpd
    参数:   in.telnetd
}
usage.h  L 1709
# Format for each entry: <id>:<runlevels>:<action>:<process>
没有inittab的时候                 如果/dev/console不是串口的时候    不是单用户的时候，boot以后首先启动    -开头假定为一个登录shell
::sysinit:/etc/init.d/rcS         tty2::askfirst:/bin/sh            ::sysinit:/etc/init.d/rcS             ::askfirst:-/bin/sh
::askfirst:/bin/sh                tty3::askfirst:/bin/sh                                                  tty2::askfirst:-/bin/sh
::ctrlaltdel:/sbin/reboot         tty4::askfirst:/bin/sh                                                  tty3::askfirst:-/bin/sh
::shutdown:/sbin/swapoff -a                                                                               tty4::askfirst:-/bin/sh
::shutdown:/bin/umount -a -r
::restart:/sbin/init

# /sbin/getty invocations for selected ttys     将getty绑定到一个串口上                      restart命令的内容       reboot命令执行前需要执行的任务
tty4::respawn:/sbin/getty 38400 tty5            ::respawn:/sbin/getty -L ttyS0 9600 vt100    ::restart:/sbin/init    ::ctrlaltdel:/sbin/reboot
tty5::respawn:/sbin/getty 38400 tty6            ::respawn:/sbin/getty -L ttyS1 9600 vt100                            ::shutdown:/bin/umount -a -r
                                                                                                                     ::shutdown:/sbin/swapoff -a
# Example how to put a getty on a modem line
::respawn:/sbin/getty 57600 ttyS2                                                                                                                 
                                                                                                                     
init(初始化管理进程)
{
1. 保证只有一个init运行 if (getpid() != 1) error_exit("Already running"); 
2. 控制台 prevlevel=N  HOME=/  runlevel=S  TERM=linux  PATH=/sbin:/bin:/usr/sbin:/usr/bin  PWD=/
                       HOME=/              TERM=linux  PATH=/sbin:/bin:/usr/sbin:/usr/bin
   说明initialize_console控制台为/dev/null
3. reset_term：tcgetattr(fd, &terminal); 设置变量 tcsetattr(fd, TCSANOW, &terminal);   终端管理
4. setsid(); 创建新会话
5. 设置环境变量
6. inittab_parsing 解析配置文件
7. /etc/inittab配置文件和/etc/init.d/rcS "/sbin/getty -n -l /bin/sh -L 115200 tty1 vt100" 是互斥的，
8.  struct action_list_seed {
        struct action_list_seed *next;
        pid_t pid;
        uint8_t action;
        char *terminal_name;
        char *command;
   }   *action_list_pointer = NULL;
   对象建立，说明如上。
9. 注册信号
    SIGUSR1, halt_poweroff_reboot_handler   halt            RB_HALT_SYSTEM
    SIGUSR2, halt_poweroff_reboot_handler   poweroff        RB_POWER_OFF
    SIGTERM, halt_poweroff_reboot_handler   reboot          RB_AUTOBOOT
    SIGQUIT, restart_init_handler           restart init
    SIGTSTP, pause_handler
    SIGINT, SIGHUP,  catch_signal
    SIGINT           run_action_from_list(CTRLALTDEL);
    
10. SHUTDOWN|ONCE|SYSINIT|CTRLALTDEL|WAIT   final_run(x);
    SHUTDOWN|SYSINIT|CTRLALTDEL|WAIT        waitforpid(pid);     
    ASKFIRST|RESPAWN                        x->pid = final_run(x);

顺序:        sysinit -> init -> wait -> once -> respawn -> askfirst 进一步执行顺序在/etc/inittab文件中。
sysinit     为init提供初始化命令行的路径 # sysinit是在之后第一运行脚本，init等到sysinit脚本运行完再运行。
respawn     每当相应的进程终止执行便会重新启动 # 在once之后执行，init进程检测发现子进程退出时，重新启动他，永不结束，比如shell命令解释器
askfirst    类似respawn，不过它的主要用途是减少系统上执行的终端应用程序的数量。它将会促使init在控制台上显示
            "Please press Enter to active this console"的信息，并在重新启动之前等待用户按下enter键
wait        告诉init必须等到相应的进程完成之后才能继续执行 # wait在sysinit之后运行，init阻塞于wait动作执行结束。
once        仅执行相应的进程一次，而且不会等待它完成 # once异步执行，init非阻塞于once动作执行结束，在wait之后执行
ctratldel   当按下Ctrl+Alt+Delete组合键时，执行相应的进程 # CTRL-ALT-DEL键
shutdown    当系统关机时，执行相应的进程  # reboot操作系统重启使执行动作，卸载文件系统，卸载交换分区
restart     当init重新启动时，执行相应的进程，通常此处所执行的进程就是init本身 # restart动作在init被执行restart的重新执行

11. run_action_from_list(SYSINIT);
    check_if_pending_signals();
    run_action_from_list(WAIT);
    check_if_pending_signals();
    run_action_from_list(ONCE);  

toybox中init命令的inittab_parsing函数的处理，可以参看busybox.txt中inittab的配置部分。
char *act_name = "sysinit\0wait\0once\0respawn\0askfirst\0ctrlaltdel\0"
                    "shutdown\0restart\0";也很有意思。
<id>:<runlevels>:<action>:<process>
1:id：表示这个子进程要用的控制台，如果省略，则使用与init进程一样的控制台。
2:runlevel：这个字段没有意义，可以省略。在linux下是具有意义的。
3:action:表示init进程如何控制这个子进程，下面会给出一个表格
4:process:这个就是我们要执行的可执行程序，当然也可以是一个脚本，如果process字段钱有一个“-”字符，这个程序就被称作是交互的。

# Format for each entry: <id>:<runlevels>:<action>:<process>
没有inittab的时候                 如果/dev/console不是串口的时候    不是单用户的时候，boot以后首先启动    -开头假定为一个登录shell
::sysinit:/etc/init.d/rcS         tty2::askfirst:/bin/sh            ::sysinit:/etc/init.d/rcS             ::askfirst:-/bin/sh
::askfirst:/bin/sh                tty3::askfirst:/bin/sh                                                  tty2::askfirst:-/bin/sh
::ctrlaltdel:/sbin/reboot         tty4::askfirst:/bin/sh                                                  tty3::askfirst:-/bin/sh
::shutdown:/sbin/swapoff -a                                                                               tty4::askfirst:-/bin/sh
::shutdown:/bin/umount -a -r
::restart:/sbin/init

# /sbin/getty invocations for selected ttys     将getty绑定到一个串口上                      restart命令的内容       reboot命令执行前需要执行的任务
tty4::respawn:/sbin/getty 38400 tty5            ::respawn:/sbin/getty -L ttyS0 9600 vt100    ::restart:/sbin/init    ::ctrlaltdel:/sbin/reboot
tty5::respawn:/sbin/getty 38400 tty6            ::respawn:/sbin/getty -L ttyS1 9600 vt100   

sysvinit###
------
init			   /sbin/init
inittab		   	   /etc/inittab
initscript.sample          /etc/initscript.sample
telinit		   	   a link (with ln(1) ) to init, either
			   in /bin or in /sbin.
halt			   /sbin/halt
reboot			   a link to /sbin/halt in the same directory
killall5		   /sbin/killall5
pidof			   a link to /sbin/killall5 in the same directory.
runlevel		   /sbin/runlevel
shutdown		   /sbin/shutdown.
wall			   /usr/bin/wall
mesg			   /usr/bin/mesg
last			   /usr/bin/last
sulogin			   /sbin/sulogin
bootlogd		   /sbin/bootlogd
utmpdump                   do not install, it is just a debug thingy.
}


hostname(utsname在内核中的作用)
{
系统调用，对应内核中的utsname对象中的char nodename[_UTSNAME_NODENAME_LENGTH];变量
sethostname                      设置
gethostname                      获取
int uname(struct utsname *buf);  获取

}

hostid(主机标识符)
{
hostid命令用于打印当前主机的十六进制数字标识。是主机的唯一标识，是被用来限时软件的使用权限，不可改变。
long gethostid(void);
int sethostid(long hostid);
在没有设置的时候，返回主机的IPv4地址。
}

reboot(halt poweroff reboot是同一个函数)
{
   -f   不发送信号给Init         kill(1, sigs[idx]);
   -n   在重启前不sync同步数据   sync();
   调用reboot(types[idx]);函数
   
   halt          SIGUSR1
   poweroff      SIGUSR2
   reboot        SIGTERM
   restart init  SIGQUIT
} 

top(termios)
{
usage: [-h HEADER] -o OUTPUT -k SORT
usage:  top -hv | -abcHimMsS -d delay -n iterations [-u user | -U user] -p pid [,pid ...]


}

ps(top,iotop,ps,pskill,termios)
{
********* simple selection *********  ********* selection by list *********
-A all processes                      -C by command name
-N negate selection                   -G by real group ID (supports names)
-a all w/ tty except session leaders  -U by real user ID (supports names)
-d all except session leaders         -g by session OR by effective group name
-e all processes                      -p by process ID
T  all processes on this terminal     -s processes in the sessions given
a  all w/ tty, including other users  -t by tty
g  OBSOLETE -- DO NOT USE             -u by effective user ID (supports names)
r  only running processes             U  processes for specified users
x  processes w/o controlling ttys     t  by tty
*********** output format **********  *********** long options ***********
-o,o user-defined  -f full            --Group --User --pid --cols --ppid
-j,j job control   s  signal          --group --user --sid --rows --info
-O,O preloaded -o  v  virtual memory  --cumulative --format --deselect
-l,l long          u  user-oriented   --sort --tty --forest --version
-F   extra full    X  registers       --heading --no-heading --context
                    ********* misc options *********
-V,V  show version      L  list format codes  f  ASCII art forest
-m,m,-L,-T,H  threads   S  children in sum    -y change -l format
-M,Z  security data     c  true command name  -c scheduling class
-w,w  wide output       n  numeric WCHAN,UID  -H process hierarchy

*****************************************************************************
Which FIELDs to show. (Default = -o PID,TTY,TIME,CMD)

-f	Full listing (-o USER:8=UID,PID,PPID,C,STIME,TTY,TIME,CMD)
-l	Long listing (-o F,S,UID,PID,PPID,C,PRI,NI,ADDR,SZ,WCHAN,TTY,TIME,CMD)
-o	Output FIELDs instead of defaults, each with optional :size and =title
-O	Add FIELDS to defaults
-Z	Include LABEL

Command line -o fields:

  ARGS     Command line (argv[] -path)    CMD    COMM, or ARGS with -f
  CMDLINE  Command line (argv[])          COMM   Original command name (stat[2])
  COMMAND  Command name (/proc/$PID/exe)  NAME   Command name (COMMAND -path)
  TNAME    Thread name (argv[0] of $PID)

Process attribute -o FIELDs:

  ADDR  Instruction pointer               BIT   Is this process 32 or 64 bits
  CPU   Which processor running on        ETIME   Elapsed time since PID start
  F     Flags (1=FORKNOEXEC 4=SUPERPRIV)  GID     Group id
  GROUP Group name                        LABEL   Security label
  MAJFL Major page faults                 MINFL   Minor page faults
  NI    Niceness (lower is faster)
  PCPU  Percentage of CPU time used       PCY     Android scheduling policy
  PGID  Process Group ID
  PID   Process ID                        PPID    Parent Process ID
  PRI   Priority (higher is faster)       PSR     Processor last executed on
  RGID  Real (before sgid) group ID       RGROUP  Real (before sgid) group name
  RSS   Resident Set Size (pages in use)  RTPRIO  Realtime priority
  RUID  Real (before suid) user ID        RUSER   Real (before suid) user name
  S     Process state:
        R (running) S (sleeping) D (device I/O) T (stopped)  t (traced)
        Z (zombie)  X (deader)   x (dead)       K (wakekill) W (waking)
  SCHED Scheduling policy (0=other, 1=fifo, 2=rr, 3=batch, 4=iso, 5=idle)
  STAT  Process state (S) plus:
        < high priority          N low priority L locked memory
        s session leader         + foreground   l multithreaded
  STIME Start time of process in hh:mm (size :19 shows yyyy-mm-dd hh:mm:ss)
  SZ    Memory Size (4k pages needed to completely swap out process)
  TCNT  Thread count                      TID     Thread ID
  TIME  CPU time consumed                 TTY     Controlling terminal
  UID   User id                           USER    User name
  VSZ   Virtual memory size (1k units)    %VSZ    VSZ as % of physical memory
  WCHAN What are we waiting in kernel for
}


ionice(ioprio_get, ioprio_set, cfq)
{
ionice [-t] [-c CLASS] [-n LEVEL] [COMMAND...|-p PID]
    -c	CLASS = 1-3: 1(realtime), 2(best-effort, default), 3(when-idle)
    -n	LEVEL = 0-7: (0 is highest priority, default = 5)
    -p	Affect existing PID instead of spawning new child
    -t	Ignore failure to set I/O priority

int ioprio_get(int which, int who);
int ioprio_set(int which, int who, int ioprio);

IOPRIO_PRIO_VALUE(class, data)
IOPRIO_PRIO_CLASS(mask)
IOPRIO_PRIO_DATA(mask)

$ cat /sys/block/hda/queue/scheduler
noop anticipatory deadline [cfq]

# echo cfq > /sys/block/hda/queue/scheduler

IOPRIO_CLASS_RT (1)
IOPRIO_CLASS_BE (2)
IOPRIO_CLASS_IDLE (3)
}

iorenice(ioprio_get, ioprio_set, cfq)
{
iorenice PID [CLASS] [PRIORITY]

}


inotifyd(inotify, poll)
{
inotify_init
inotify_add_watch(fds.fd, path, mask) 
ret = poll(&fds, 1, -1);


}

ip(netlink)
{

}

/proc/kmsg

klogd()
{
    usage: klogd [-n] [-c N]
    -c  N   Print to console messages more urgent than prio N (1-8)
    -n    Run in foreground.
    
openlog("Kernel", 0, LOG_KERN);  
klogctl(2, start, sizeof(msg_buffer) - used - 1);
}

logger()
{
logger [-s] [-t tag] [-p [facility.]priority] [message]

openlog(TT.ident, (toys.optflags & FLAG_s ? LOG_PERROR : 0) , facility);
syslog(priority, "%s", message);
closelog();

}

base64()
{
    base64 [-di] [-w COLUMNS] [FILE...]
通常一个网页下载下来，离线打开，你可能会发现网页上的图片还在。但你搜遍整个网页都没有打到对应的二进制数据。
原来是图片数据被转换成文本的形式。

加密字串：echo -n "Hi, I am Hevake Lee" | base64 
加密文件: base64 photo.jpg
解密方法与加密方法是一样的，只不过base64加一个'-d'参数表示解码。
    
}

blkid(/proc/partitions, /dev/[partitions.name], fstypes格式)
{
struct fstype {
  char *name;
  uint64_t magic;
  int magic_len, magic_offset, uuid_off, label_len, label_off;
};

static const struct fstype fstypes[] = {
  {"ext2", 0xEF53, 2, 1080, 1128, 16, 1144}, // keep this first for ext3/4 check
  {"swap", 0x4341505350415753LL, 8, 4086, 1036, 15, 1052},
  // NTFS label actually 8/16 0x4d80 but horrible: 16 bit wide characters via
  // codepage, something called a uuid that is only 8 bytes long...
  {"ntfs", 0x5346544e, 4, 3, 0x48+(8<<24), 0, 0},

  {"adfs", 0xadf5, 2, 0xc00, 0,0,0},
  {"bfs", 0x1badface, 4, 0, 0,0,0},
  {"btrfs", 0x4D5F53665248425FULL, 8, 65600, 65803, 256, 65819},
  {"cramfs", 0x28cd3d45, 4, 0, 0, 16, 48},
  {"f2fs", 0xF2F52010, 4, 1024, 1132, 16, 1110},
  {"jfs", 0x3153464a, 4, 32768, 32920, 16, 32904},
  {"nilfs", 0x3434, 2, 1030, 1176, 80, 1192},
  {"reiserfs", 0x724573496552ULL, 6, 8244, 8276, 16, 8292},
  {"reiserfs", 0x724573496552ULL, 6, 65588, 65620, 16, 65636},
  {"romfs", 0x2d6d6f72, 4, 0, 0,0,0},
  {"squashfs", 0x73717368, 4, 0, 0,0,0},
  {"xiafs", 0x012fd16d, 4, 572, 0,0,0},
  {"xfs", 0x42534658, 4, 0, 32, 12, 108},
  {"vfat", 0x3233544146ULL, 5, 82, 67+(4<<24), 11, 71},  // fat32
  {"vfat", 0x31544146, 4, 54, 39+(4<<24), 11, 43}     // fat1
};


}

cksum()
{
usage: cksum [-IPLN] [file...]

For each file, output crc32 checksum value, length and name of file.
If no files listed, copy from stdin.  Filename "-" is a synonym for stdin.

-H	Hexadecimal checksum (defaults to decimal)
-L	Little endian (defaults to big endian)
-P	Pre-inversion
-I	Skip post-inversion
-N	Do not include length in CRC calculation
}

md5sum(){}
sha1sum(){}

expand(将TAB转换为空格)
{
-i, --initial
              do not convert tabs after non blanks
-t, --tabs=NUMBER
      have tabs NUMBER characters apart, not 8
-t, --tabs=LIST
      use comma separated list of explicit tab positions
}

unexpand(将空格转换为TAB)
{
 -a, --all
       convert all blanks, instead of just initial blanks
--first-only
       convert only leading sequences of blanks (overrides -a)
-t, --tabs=N
       have tabs N characters apart instead of 8 (enables -a)
-t, --tabs=LIST
       use comma separated LIST of tab positions (enables -a)
}

dos2unix(将win文档转换转换为uinx文档转换)
{
    从\r\n到\n
}
unix2dos(将unix文档格式转换为win文档格式)
{
    从\n到\r\n
}

fold(对文档进行定长断行)
{
    fold [-bs][-w<每列行数>][--help][--version][文件...]

    -b	Fold based on bytes instead of columns
    -s	Fold/unfold at whitespace boundaries if possible
    -u	Unfold text (and refold if -w is given)
    -w	Set lines to WIDTH columns or bytes
}
fmt(编排文本文件){
Linux fmt命令用于编排文本文件。
fmt指令会从指定的文件里读取内容，将其依照指定格式重新编排后，输出到标准输出设备。若指定的文件名为"-"，
则fmt指令会从标准输入设备读取数据。

-c或--crown-margin 每段前两列缩排。
-p<列起始字符串>或-prefix=<列起始字符串> 仅合并含有指定字符串的列，通常运用在程序语言的注解方面。
-s或--split-only 只拆开字数超出每列字符数的列，但不合并字数不足每列字符数的列。
-t或--tagged-paragraph 每列前两列缩排，但第1列和第2列的缩排格式不同。
-u或--uniform-spacing 每个字符之间都以一个空格字符间隔，每个句子之间则两个空格字符分隔。
-w<每列字符数>或--width=<每列字符数>或-<每列字符数> 设置每列的最大字符数。

}

nl(添加行号){}

od(){}
hexdump(){}
rev(将文件每行反向显示)
split(切分文件)
strings(打印文件中的可打印字符串)
{
Linux系统里的命令strings，即打印文件中的可打印字符串（print the strings of printable characters in files），
常用来在二进制文件中查找字符串，与grep配合使用。strings命令输出的字符串是至少包含连续4个可打印字符的，
这个可以通过参数来修改。
}

mkfifo(命令管道)
{
$ mkfifo backpipe
$ nc –l 8080 0<backpipe | /bin/bash > backpipe

实现函数：mknod(*s, S_IFIFO | TT.mode, 0)
}

nice(修改进程优先级)
{
nice(TT.priority) 优先级在进程之间是继承的。
}

who ? 显示已经登录的用户
w(who uptime w)
{
struct utmp *getutent(void);
struct utmp *getutid(struct utmp *ut);
struct utmp *getutline(struct utmp *ut);

struct utmp *pututline(struct utmp *ut);

void setutent(void);
void endutent(void);

int utmpname(const char *file);

执行流程
setutxent();
while ((entry = getutxent())) if (entry->ut_type == USER_PROCESS) users++;
endutxent();

如果没有指定 FILE, 缺省使用 /var/run/utmp. /var/log/wtmp 是比较常用的FILE. 如果给出 ARG1 ARG2, who 设定 ?m 有效:
}

timeout(当子进程没有结束的时候，给子进程发送一个信号然后退出)
{
setitimer(ITIMER_REAL, &TT.itv, (void *)toybuf);
kill(TT.pid, TT.nextsig);

usage: timeout [-k LENGTH] [-s SIGNAL] LENGTH COMMAND...

Run command line as a child process, sending child a signal if the
command does not exit soon enough.

Length can be a decimal fraction. An optional suffix can be "m"
(minutes), "h" (hours), "d" (days), or "s" (seconds, the default).

-s	Send specified signal (default TERM)
-k	Send KILL signal if child still running this long after first signal.
}


ls()
{
    usage: ls [-ACFHLRSZacdfhiklmnpqrstux1] [directory...]

    list files

    what to show:
    -a  all files including .hidden    -b  escape nongraphic chars
    -c  use ctime for timestamps       -d  directory, not contents
    -i  inode number                   -k  block sizes in kilobytes
    -p  put a '/' after dir names      -q  unprintable chars as '?'
    -s  size (in blocks)               -u  use access time for timestamps
    -A  list all files but . and ..    -H  follow command line symlinks
    -L  follow symlinks                -R  recursively list files in subdirs
    -F  append /dir *exe @sym |FIFO    -Z  security context
    
        output formats:
    -1  list one file per line         -C  columns (sorted vertically)
    -g  like -l but no owner           -h  human readable sizes
    -l  long (show full details)       -m  comma separated
    -n  like -l but numeric uid/gid    -o  like -l but no group
    -x  columns (horizontal sort)

    sorting (default is alphabetical):
    -f  unsorted    -r  reverse    -t  timestamp    -S  size
}

netcat(Forward stdin/stdout to a file or network connection)
{
netcat -s 127.0.0.1 -p 1234 -tL /bin/bash -l
}

sendmail()
{

}


wtmp(wtmp utmp 与 init getty login bash)
{
who命令：显示已经登录的用户                                             utmp
w命令：显示已经登录的用户以及他们在做什么                               utmp
last, lastb ? 显示最近登录的用户列表                                    wtmp
lastlog读取/var/log/lastlog文件内容并输出                               lastlog
ac - 输出用户连接时间                                                   wtmp
users用单独的一行打印出当前登录的用户，每个显示的用户名对应一个登录会话 utmp

utmp 文件用于记录当前系统用户是哪些人。但实际的人数可能比这个数目要多，因为并非所有用户都用utmp登录。
     警告: utmp必须置为不可写，因为很多系统程序（ 有 点 傻 的 那 种 ）依赖于它。如果你将它置为可写 ，其他用户可能会修改它。
     这个结构给出了与用户终端联系的文件，用户的登录名，记录于time(2)表中的登录时间。字符串如果比给定的大小小的话，则以’\0’结束之。
wtmp 文件记录了所有的登录和退出。它的格式与 utmp 几乎完全一样（例外是：用空用户名来表示在相关终端上的退出）。除此以外，
     用终端名 "~" 和用 户 名 "shutdown" 或 "reboot" 表示系统关机或重启，

     
1、有关当前登录用户的信息记录在文件utmp中；    ==who命令：显示已经登录的用户                    
                                               ==w命令：显示已经登录的用户以及他们在做什么   
                                               == 数据产生： getty写入utmp文件，sshd和telnetd写入utmp, sulogin也会写入utmp文件
                                               
2、登录进入和退出纪录在文件wtmp中；            ==last, lastb ? 显示最近登录的用户列表
                                               == 数据产生： halt将utmp文件中信息写入wtmp文件  
                                               
ac - 输出用户连接时间
ac：基于当前的 /var/log/wtmp 文件中的登录和退出时间输出一个关于连接时间(以小时为单位)的报告。并且还输出一个总计时间。

记帐文件  /var/log/wtmp 由 init(8)  和  login(1)  维护。ac  和login  均不生成 /var/log/wtmp 文件，如果记帐文件不存在，则不
做记帐工作。如果要开始记帐，应生成一个长度为零的记帐文件。

                                               
3、最后一次登录文件可以用lastlog命令察看；     == /var/log/lastlog 用户最近登录服务器时间 lastlog命令
                                               == lastlog读取/var/log/lastlog文件内容并输出
                                               ==从syslog中记录信息   
4、messages 


init -> getty -> login -> bash

----init
init   1. 命令行参数， 
       2. /etc/inittab 或者 /etc/init.d/rcS 2步骤内重点"/sbin/getty -n -l /bin/sh -L 115200 tty1 vt100"
       
实例：sysvinit upstart systemd 以及toybox和busybox都实现了该功能。       
       
----getty
getty  1. 命令行参数， 会将登录用户的数据写入utmp文件中。
       2. /etc/issue，提示当前登录用户

实例：sshd telnet xterm xdm以及toybox和busybox都实现了该功能。 mingetty ? 控制台最小的 getty

----login
login  1. 命令行参数
       2. /etc/motd
       3. 最后执行/etc/passwd文件中指定的shell

----bash
/bin/sh
toybox中的执行流程和slotd、hostd、otdrd执行流程很相似。最大不同就是handle处理函数不同。

telnetd 1. /etc/issue.net，提示当前登录用户。telnetd、sshd、xterm、xdm和getty具有相似的功能。



}

getty()
{
    usage: getty [OPTIONS] BAUD_RATE[,BAUD_RATE]... TTY [TERMTYPE]
     /sbin/getty -n -l /bin/sh -L 115200 tty1 vt100
     
    -h    启用串口的RTS/CTS使能
    -L    启用CLOCAL (忽略Carrier Detect state)
    -m    从moden状态中获取波特率
    -n    提打印用于户名
    -w    接收到\r或\n的时候，输出/etc/issue内容
    -i    不输出 /etc/issue内容
    -f    ISSUE_FILE  显示ISSUE_FILE内容而不是/etc/issue文件内容
    -l    LOGIN  使用LOGIN程序而不是/bin/login
    -t    SEC    在SEC秒以内没有输入loginname,则退出
    -I    INITSTR  在输出任何内容前，输出INITSTR字符串
    -H    HOST    将HOST作为用于户名添加到utmp，而不是使用hostname

打开终端线，并设置模式
输出登录界面及提示，接受用户名的输入
以该用户名作为login的参数，加载login程序
注：用于远程登录的提示信息位于/etc/issue.net中。
}

mingetty()
{
mingetty 是一个用于虚拟终端的最小的 getty。不像 agetty(8) ， mingetty 不适于串行线。我建议使用 mgetty(8) 来替代。

}

login()
{
    login [-p] [-h host] [-f USERNAME] [USERNAME]
    -p	Preserve environment
    -h	The name of the remote host for this login
    -f	login as USERNAME without authentication
60 秒未输入密码就退出。
3  密码登录失败次数为3次。大于3次就退出login

pwd = getpwnam(username);
struct spwd *spwd = getspnam (username);
int x = pass && (ss = crypt(toybuf, pass)) && !strcmp(pass, ss);

login程序在getty的同一个进程空间中运行，接受getty传来的用户名参数作为登录的用户名。
}

sh()
{
由login启动的bash是作为一个登录shell启动的，它继承了getty设置的TERM、PATH等环境变量，
其中PATH对于普通用户为"/bin:/usr/bin:/usr/local/bin"，对于root 为"/sbin:/bin:/usr/sbin:/usr/bin"。
作为登录shell，它将首先寻找/etc/profile 脚本文件，并执行它；然后如果存在~/.bash_profile，则执行它，
否则执行 ~/.bash_login，如果该文件也不存在，则执行~/.profile文件。然后bash将作为一个交互式shell执行~/.bashrc文件
（如果存在的话），很多系统中，~/.bashrc都将启动 /etc/bashrc作为系统范围内的配置文件。


/etc/profile，/etc/bashrc 是系统全局环境变量设定
~/.profile，~/.bashrc用户家目录下的私有环境变量设定
当登入系统时候获得一个shell进程时，其读取环境设定档有三步
1首先读入的是全局环境变量设定档/etc/profile，然后根据其内容读取额外的设定的文档，如
/etc/profile.d和/etc/inputrc
2然后根据不同使用者帐号，去其家目录读取~/.bash_profile，如果这读取不了就读取~/.bash_login，这个也读取不了才会读取
~/.profile，这三个文档设定基本上是一样的，读取有优先关系
3然后在根据用户帐号读取~/.bashrc
至于~/.profile与~/.bashrc的不区别
都具有个性化定制功能
~/.profile可以设定本用户专有的路径，环境变量，等，它只能登入的时候执行一次
~/.bashrc也是某用户专有设定文档，可以设定路径，命令别名，每次shell script的执行都会使用它一次


对toybox而言，sh处理程序会区分toybox内的模块函数调用，还是toybox外的可执行命令调用。
toybox内的模块调用就是函数调用，toybox外的可执行命令调用就是进程调度。

}

slattach()
{
SLIP, 即Serial Line IP(串行线路IP)， 是一个数据链路层协议，用于在串行线路上传输IP数据报。
本文讲述如何在两台用串口线（RS232）连接的Linux机器之间配置SLIP链路。

设两台机器为A, B。首先，将两台机器用串口线连接好，然后在A机器上依次运行如下指令：
slattach /dev/ttyS0 -p slip -s 9600 -m -d &
ifconfig sl0 192.168.1.1 pointopoint 192.168.1.2 up
route add default gw 192.168.1.2

其中，/dev/ttyS0是第1上串口设备，如果有多个串口，则依次是/dev/ttyS1, /dev/ttyS2...，要视情况而定。
slattach的-p选项指定要使用的数据链路层协议，可以是slip, cslip, ppp等； -s指定传输速率，可以是9600，115200等；
-m告诉串口设备不要工作在RAW data模式，而是要工作在协议驱动模式；-d输出调试信息。
ifconfig用于配置串行接口的ip信息等。sl0代表第一个串行接口，如果有更多，依次是sl1, sl2...。
route将对方ip添加为默认网关。

然后在B机器上依次运行以下指令：
slattach /dev/ttyS0 -p slip -s 9600 -m -d &
ifconfig sl0 192.168.1.2 pointopoint 192.168.1.1 up
route add default gw 192.168.1.1


slattach /dev/tty00 # ifconfig sl0 inet 192.168.1.1 192.168.1.2
slattach /dev/tty00 # ifconfig sl0 inet 192.168.1.2 192.168.1.1
ping 192.168.1.1
}

help()
{
adjtimex 获取和设置系统的时间参数
--------------------------------------------------- 继续
语法：adjtimex [OPTION]… 主要参数说明:
  -p, –print 输出内核时间变量的值
  -t, –tick val 设置内核时钟计数间隔
  -f, –frequency newfreq 设置系统时钟偏移量
  -c, –compare[=count] 比较系统时钟和CMOS时钟
  -i, –interval tim 设置时钟比较间隔时间 (sec)
  -l, –log[=file] 将当前时间记录到文件中
  –host timeserver 查询时间服务器
  -u, –utc 将CMOS时钟设置成UTC
  
chat  与一个连接到标准输入或标准输出的调制解调器互动
chpst  修改进程状态并运行PROG
chrt   操作系统的实时属性
chvt 将前台虚拟终端设置为/dev/ttyN
deallocvt 释放未用的虚拟终端/dev/ttyN
devmem 读写一个物理地址

dhcprelay 将来自客户端设备的DHCP请求中转至服务器设备
dumpleases 显示udhcpd准许的DHCP租约时间
dmesg 打印或管理内核环形缓冲区
dumpkmap 在标准输出中打印二进制键盘转换表
ether-wake 发送一个神奇数据包以唤醒机器

fbset    显示和修改帧缓冲的设置
fbsplash 启动图片

ftpget   通过ftp下载文件
ftpput   通过ftp上传文件
httpd    监听httpd请求
inotifyd 在文件系统变化时启动用户空间代理程序
kbd_mode 报告和设置键盘模式
klogd    内核日志程序
makedevs 根据设备表创建一组特殊文件
microcom 从标准输入复制字节到TTY并从TTY复制字节到标准输出
nmeter  实时监控系统
pscan   扫描一台主机并打印所有开放的端口
rdev    打印根文件系统的设备节点
readprofile 读取内核性能检查信息
runrv  启动并检测一个服务，也可以附加的日志服务
softlimit  设置软资源限制并运行PROG
stty    修改和打印终端行设置

tcpsvd  创建TCP套接字，绑定ip:port 并侦听。接收到请求后运行执行程序，并返回程序运行结果内容

udhcpc  非常小型的DHCP客户端
udhcpd  非常小型的DHCP服务器
udpsvd   创建UDP套接字，绑定到ip:port 并等待
}