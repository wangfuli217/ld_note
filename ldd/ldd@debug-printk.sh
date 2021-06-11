不鼓励/proc下添加文件，建议通过sysfs向外界到处信息

debug(内核中的调试支持)
{
------ 内核中的调试支持 ------
CONFIG_DEBUG_KERNEL = y  
CONFIG_DEBUG_SLAB = y           # 内存溢出和忘记初始化。malloc[0xa5] free[0x6b]
CONFIG_DEBUG_PAGEALLOC = y         # 在释放时，全部内存页从内核地址空间中移除。  快速定位特定的内存损坏错误的所在位置。
CONFIG_DEBUG_SPINLOCK = y       # 捕获未初始化自旋锁的操作；捕获诸如两次解开同一锁的操作。
CONFIG_DEBUG_SPINLOCK_SLEEP = y # 拥有自旋锁时的休眠企图
CONFIG_INIT_DEBUG                # 标记为__init(或__initdata)的符号将会在系统初始化或者模块装载之后被丢失。
CONFIG_INIT_INFO                # 如果读者利用gdb调试内核，将需要这些信息 CONFIG+FRAME_POINTER选项
CONFIG_MAGIC_SYSRQ                # 打开SysRq魔法

CONFIG_DEBUG_STACKOVERFLOW = y
CONFIG_DEBUG_STACK_USAGE = y    # 栈溢出

CONFIG_IKCONFIG = y
CONFIG_IKCONFIG_PROC = y         # 会让完整的内核配置状态包含在内核中，并通过/proc访问。

CONFIG_DEBUG_DRIVER = y         # 在Device Drivers菜单中，打开驱动程序核心中的调试信息，可以帮助跟踪底层支持代码中的问题。
CONFIG_INPUT_EVBUG = y             # 在Device Drivers/Input device support中，它会记录你输入的任何东西包括密码。

CONFIG_KLLSYMS = y              # Gernel setup /Standard features 相当于gcc -g选项
}

printk(klogd, dmesg)
{
------ 通过打印调试 ------
http://www.ibm.com/developerworks/cn/linux/l-kernel-logging-apis/
printk(KERN_DEBUG "Here I am: %s %i\n", __FILE__, __LINE__);    相同含义
printk("<7>" "Here I am: %s %i\n", __FILE__, __LINE__);         相同含义
printk("<7> Here I am: %s %i\n", __FILE__, __LINE__);           相同含义

0. printk函数能够在终端中一次最多显示大小为1024字节的字符串。
printk 1. 表示日志级别的宏会展开为一个字符串，在编译时由预编译其将它和消息文本拼接在一起；这就是为什么下面的例子中优先级和
          格式化字串之间没有逗号的原因。
       2. KERN_EMERG"<0>" KERN_ALERT"<1>" KERN_CRIT"<2>" KERN_ERR"<3>" KERN_WARNING"<4>" KERN_NOTICE"<5>" KERN_INFO"<6>" KERN_DEBUG"<7>"
            KERN_EMERG    <0>    紧急消息（导致系统崩溃） 可以直接被发送到控制台
            KERN_ALERT    <1>    必须立即处理的错误
            KERN_CRIT    <2>    严重错误（硬件或软件）           严重的硬件或软件操作失败
            KERN_ERR    <3>    错误状况（一般出现在驱动程序上）  驱动程序常用于报告硬件的错误信息
            KERN_WARNING    <4>    警告状况（可能导致错误）      系统安全相关的消息输出
            KERN_NOTICE    <5>    不是错误，但是一个重要状况     输出需要注意的情况
            KERN_INFO    <6>    报告消息
            KERN_DEBUG    <7>    仅用于调试的消息
            KERN_DEFAULT    <d>    默认内核日志级别
            KERN_CONT    <c>    日志行继续（避免增加新的时间截）
       
       
       3. 未指定优先级的printk语句采用的默认级别是DEFAULT_MESSAGE_LOGLEVEL 这个宏在kernel/printk.c中被指定为一个整数。
          #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL    # kernel/printk.c
          #define CONFIG_DEFAULT_MESSAGE_LOGLEVEL 4                         # include/generated/autoconf.h
       4. 控制台：一个字符式的终端；一个串口打印机；一个并口打印机。
       5. 当优先级小于console_loglevel这个整数变量的值，消息才能显示出来。 /proc/sys/kernel [4       4       1       7]
       echo "1       4       1      7" > /proc/sys/kernel/printk
       echo "0[新的打印级别]       4       0      7" > /proc/sys/kernel/printk
           #define console_loglevel (console_printk[0])            4     当前的日志级别
           #define default_message_loglevel (console_printk[1])    4     未明确指定日志级别时的默认消息级别
           #define minimum_console_loglevel (console_printk[2])    1     最小允许的日志级别
           #define default_console_loglevel (console_printk[3])    7     引导时的默认日志级别
           192.168.1.232 [7       4       1       7]
           [rsyslogd]
           rsyslogd 1992 root    1w   REG              253,3    19986    2754435 /var/log/messages
           rsyslogd 1992 root    2w   REG              253,3    24900    2754371 /var/log/cron
           rsyslogd 1992 root    3r   REG                0,3        0 4026532071 /proc/kmsg
           rsyslogd 1992 root    4w   REG              253,3     1037    2754504 /var/log/secure
           rsyslogd 1992 root    5w   REG              253,3     1179    2754424 /var/log/maillog

           console_loglevel 的初始值是DEFAULT_MESSAGE_LOGLEVEL，而且可以通过sys_syslog系统调用进行修改。
           调用klogd时可以指定-c开关项来修改这个变量。
           
           klogd 是一个专门截获并记录 Linux 内核消息的守护进程。将klogctl调用中获得消息通过syslog方式打印出来。
                 syslog的打印依赖于/etc/syslog.conf配置文件。
                 klogd可以指定-f，将数据输出到指定的文件中。或者修改/etc/syslog.conf
                 
           klogd -c 7 ## 修改/proc/sys/kernel/printk变量中console_loglevel的值。
           
           busybox -> klogd dmesg
           int klogctl(int type, char *bufp, int len);
               SYSLOG_ACTION_CLOSE (0)    关闭日志（未实现）
               SYSLOG_ACTION_OPEN (1)    打开日志（未实现）
               SYSLOG_ACTION_READ (2)    从日志读取
               SYSLOG_ACTION_READ_ALL (3)    从日志读取所有消息（非破坏地）
               SYSLOG_ACTION_READ_CLEAR (4)    从日志读取并清除所有消息
               SYSLOG_ACTION_CLEAR (5)    清除环缓冲区
               SYSLOG_ACTION_CONSOLE_OFF (6)    Disable printks to the console
               SYSLOG_ACTION_CONSOLE_ON (7)    激活控制台 printk
               SYSLOG_ACTION_CONSOLE_LEVEL (8)    将消息级别设置为控制接受
               SYSLOG_ACTION_SIZE_UNREAD (9)    返回日志中未读取的字符数
               SYSLOG_ACTION_SIZE_BUFFER (10)    返回内核环缓冲区大小
           
           busybox -> syslogd
            #    dev_log_name = xmalloc_follow_symlinks("/dev/log");
            #    if (dev_log_name) {
            #        safe_strncpy(sunx.sun_path, dev_log_name, sizeof(sunx.sun_path));
            #        free(dev_log_name);
            #    }
            #    unlink(sunx.sun_path);
            #    
            #    sock_fd = xsocket(AF_UNIX, SOCK_DGRAM, 0);
            #    xbind(sock_fd, (struct sockaddr *) &sunx, sizeof(sunx));
            #    chmod("/dev/log", 0666);
            netstat -anp | grep rsyslogd
           unix  21     [ ]         DGRAM                    13302  1992/rsyslogd       /dev/log
           
/dev/log：由rsyslogd进程创建，监听系统其他进程的打印请求。为AF_UNIX类型的DGRAM类型socket。
/proc/kmsg： 被rsyslogd进程监听，接收来自内核的printk打印信息。  
           
           
        6. 如果系统同时运行了klogd和syslogd，则无论console_loglevel为何值，内核都会将之追加到/var/log/messages中。
           安装syslogd的配置进行处理； 如果klogd没有运行，这些消息就不会传递到用户空间。
        7. klogd 不会保存连续相同的信息行，它只会保存连续相同的第一行，并在最后打印这一行的重复次数。
        8. Linux消息处理方法的特点是：可以在任何地方调用printk，甚至在中断处理函数里也可以调用，而且对数据量的大小没有限制，
           唯一的缺点就是可能丢失某些数据。
}

syslog(klogctl)
{
----- syslog
syslog 调用（在内核中调用 ./linux/kernel/printk.c 的 do_syslog）是一个相对较小的函数，它能够读取和控制内核环缓冲区。
注意在 glibc 2.0 中，由于词汇 syslog 使用过于广泛，这个函数的名称被修改成 klogctl，它指的是各种调用和应用程序。
syslog 和 klogctl（在用户空间中）的原型函数定义为：

int syslog( int type, char *bufp, int len );
int klogctl( int type, char *bufp, int len ); 
}
          
           
print_dev_t(打印设备编号)
{
------ 打印设备编号 ------
int print_dev_t(char *buff, dev_t dev);
char *format_dev_t(char *buff, dev_t dev);
将设备编号打印到给定的缓冲区。 print_dev_t  返回的是打印的字符数；format_dev_t返回的是缓冲区。
print_dev_t返回打印字符数，format_dev_t返回缓冲区指针。注意缓冲区char *buffer的大小应至少有20B。
}       

           
printk_limit(速度限制)
{
------ 速度限制 ------
int printk_ratelimit(void)在打印一条可能被重复的信息之前，应调用上面这个函数。
if(printk_ratelimit()) //为了避免printk重复输出过快而阻塞系统，内核使用以下函数跳过部分输出
    printk(KERNEN_NOTICE "Ths printer is still on fire\n");
    
    
printk_delay 值表示的是printk消息之间的延迟毫秒数（用于提高某些场景的可读性）。注意，这里它的值为0，而它是不可以通过/proc设置的。

printk_ratelimit 定义了消息之间允许的最小时间间隔（当前定义为每 5 秒内的某个内核消息数）。
                 在重新打开消息之前应该等待的秒数。
                 
printk_ratelimit_burst： 消息数量是由 printk_ratelimit_burst 定义的（当前定义为 10）。
                 在进行速度限制之前可以接受的消息数。

注意，在内核中，速度限制是由调用者控制的，而不是在 printk 中实现的。如果一个 printk 用户要求进行速度限制，
那么该用户就需要调用printk_ratelimit函数。
}    

setconsole(重定向控制台消息)
{
------ 重定向控制台消息 ------        
内核可以将消息发送到一个指定的虚拟控制台。默认情况下，"控制台"就是当前的虚拟终端。
可以在任何一个控制台上调用ioctl(TIOCLINUX)来指定接收消息的其他虚拟终端。

setconsole可用来指定系统终端。
setconsole [serial][ttya][ttyb]
参数：
    serial 　使用PROM终端。
    ttya,cua0或ttyS0 　使用第１个串口设备作为终端。
    ttyb,cua1或ttyS1 　使用第２个串口设备作为终端。
    video 　使用主机上的现卡作为终端。

    setconsole ttyS0
}


------ 消息如何被记录 ------    
printk函数将消息写到一个长度为__LOG_BUF_LEN字节的循环缓冲区中；
---- 我们可在配置内核时为__LOG_BUF_LEN指定4KB-1MB之间的值。
然后，该函数会唤醒任何在等待消息的进程，即那些睡眠在syslog系统调用上的进行，或者正在读取/proc/kmsg的进程。

/proc/kmsg进行读操作时，日志缓冲区中被读取的数据就不再保留。
syslog系统调用确能通过选项返回日志数据保留这些数据，以便其他进程也能使用。


------ 开启和关闭消息 ------    
1、可以通过在宏名字中删减或增加一个字母来开启或禁用每一条打印语句。
2、在编译前修改CFLAGS变量，则可以一次禁用所有消息。
3、同样的打印语句可以在内核代码中也可以在用户级代码使用，因此，关于这些额外的调试信息，
   驱动程序和测试程序可以用同样的方式来进行管理。
----  头文件
/*
 * Macros to help debugging
 */

#undef PDEBUG             /* 取消对PDEBUG的定义，以防止重复定义 */
#ifdef SCULL_DEBUG
#  ifdef __KERNEL__
     /* 表明打开调试，并处于内核空间 */
#    define PDEBUG(fmt, args...) printk( KERN_DEBUG "scull: " fmt, ## args)
#  else
     /* 标明处于用户空间 */
#    define PDEBUG(fmt, args...) fprintf(stderr, fmt, ## args)
#  endif
#else
#  define PDEBUG(fmt, args...) /* 调试开关关闭，不做任何事情 */
#endif

#undef PDEBUGG
#define PDEBUGG(fmt, args...) /* 不做任何事情，仅仅是个占位符 */

#DEBUG = y

----  Makefile
# Add your debugging flag (or not) to EXTRA_CFLAGS
ifeq ($(DEBUG),y)
  DEBFLAGS = -O -g -DSCULL_DEBUG # "-O" is needed to expand inlines
else
  DEBFLAGS = -O2
endif

EXTRA_CFLAGS += $(DEBFLAGS)



