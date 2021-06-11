
etc(访问文件|tcpd){}
/etc/host.conf  告诉网络域名服务器如何查找主机名。（通常是 /etc/hosts，然后就是名称服务器；可通过netconf对其进行更改）
/etc/hosts      包含（本地网络中）已知主机的一个列表。如果系统的 IP 不是动态生成，就可以使用它。/etc/hosts.conf 通常会告诉解析程序先查看这里。
/etc/hosts.allow请参阅 hosts_access 的联机帮助页。至少由 tcpd 读取。
/etc/hosts.deny 请参阅 hosts_access 的联机帮助页。至少由 tcpd 读取。

可以通过配置hosts.allow和hosts.deny来控制访问权限。原文如下:
他们两个的关系为：/etc/hosts.allow 的设定优先于 /etc/hosts.deny
1. 当档案 /etc/hosts.allow 存在时，则先以此档案内之设定为准；
2. 而在 /etc/hosts.allow 没有规定到的事项，将在 /etc/hosts.deny 当中继续设定！
也就是说， /etc/hosts.allow 的设定优先于 /etc/hosts.deny 啰

那个 service_name 『必需』跟你的 xinetd 或者是 /etc/rc.d/init.d/* 里面的程序名称要相同。

1. 只允许 140.116.44.0/255.255.255.0 与 140.116.79.0/255.255.255.0 这两个网域，及 140.116.141.99 这个主机可以进入我们的 telnet 服务器；
2. 此外，其它的 IP 全部都挡掉！
这样则首先可以设定 /etc/hosts.allow 这个档案成为：　
[root @test root]# vi /etc/hosts.allow
telnetd: 140.116.44.0/255.255.255.0 : allow
telnetd: 140.116.79.0/255.255.255.0 : allow
telnetd: 140.116.141.99 : allow　
再来，设定 /etc/hosts.deny 成为『全部都挡掉』的状态：　
[root @test root]# vi /etc/hosts.deny
telnetd: ALL : deny
-----------------------------------------
# 当当有其它人扫瞄我的 telnet port 时，我就将他的IP记住！以做为未来的查询与认证之用！那么你可以将 /etc/hosts.deny 这个档案改成这个样子：
[root @test root]# vi /etc/hosts.deny
telnetd: ALL : spawn (echo Security notice from host `/bin/hostname`; \
echo; /usr/sbin/safe_finger @%h ) | \
/bin/mail -s "%d-%h security" root & \
: twist ( /bin/echo -e "\n\nWARNING connection not allowed. Your attempt has been logged.
\n\n\n警告您尚未允许登入，您的联机将会被纪录，并且作为以后的参考\n\n ". )

-----------------------------------------
etc/hosts.allow和/etc/hosts.deny
这两个文件是tcpd服务器的配置文件，tcpd服务器可以控制外部IP对本机服务的访问。这两个配置文件的格式如下：
#服务进程名:主机列表:当规则匹配时可选的命令操作 server_name:hosts-list[:command] 
/etc/hosts.allow控制可以访问本机的IP地址，/etc/hosts.deny控制禁止访问本机的IP。如果两个文件的配置有冲突，以/etc/hosts.deny为准。

etc(引导和登录／注销){}
/etc/issue & /etc/issue.net 这些文件由 mingetty（和类似的程序）读取，用来向从终端（issue）或通过 telnet 会话
                           （issue.net）连接的用户显示一个“welcome”字符串。 它们包括几行声明 Red Hat 版本号、
                           名称和内核 ID 的信息。它们由 rc.local 使用。
/etc/redhat-release         包括一行声明 Red Hat 版本号和名称的信息。由 rc.local 使用
/etc/rc.d/rc                通常在所有运行级别运行，级别作为参数传送。 例如，要以图形（Graphics）模式（X-Server）
                            引导机器，请在命令行运行下面的命令： init 5 。运行级别 5 表示以图形模式引导系统。
/etc/rc.d/rc.local          非正式的。可以从 rc、rc.sysinit 或 /etc/inittab 调用。
/etc/rc.d/rc.sysinit        通常是所有运行级别的第一个脚本。
/etc/rc.d/rc/rcX.d          从 rc 运行的脚本（ X 表示 1 到 5 之间的任意数字）。  

etc(文件系统){}
/etc/mtab        这将随着 /proc/mount 文件的改变而不断改变。换句话说，文件系统被安装和卸载时，改变会立即反映到此文件中。
/etc/fstab       列举计算机当前“可以安装”的文件系统。 这非常重要，因为计算机引导时将运行 mount -a 命令，该命令负责安装 fstab 的倒数第二列中带有“1”标记的每一个文件系统。
/etc/mtools.conf DOS 类型的文件系统上所有操作（创建目录、复制、格式化等等）的配置。
mtab 文件以同样的方式读取包含当前安装的文件系统的 /proc/mount 文件。
/proc/modules 文件列举系统中当前加载的模块。lsmod 命令读取此信息，然后将其以人们可以看懂的格式显示出来。

etc(系统管理){}
/etc/group      包含有效的组名称和指定组中包括的用户。单一用户如果执行多个任务，可以存在于多个组中。
/etc/nologin    如果有 /etc/nologin 文件存在，login(1) 将只允许 root 用户进行访问。它将对其它用户显示此文件的内容并拒绝其登录。
/etc/passwd     请参阅“man passwd”。它包含一些用户帐号信息，包括密码（如果未被 shadow 程序加密过）。
/etc/rpmrc      rpm 命令配置。所有的 rpm 命令行选项都可以在这个文件中一起设置，这样，当任何 rpm 命令在该系统中运行时，所有的选项都会全局适用。
/etc/securetty  包含设备名称，由 tty 行组成（每行一个名称，不包括前面的 /dev/），root 用户在这里被允许登录。
/etc/usertty
/etc/shadow	包含加密后的用户帐号密码信息，还可以包括密码时效信息。包括的字段有：
    登录名
    加密后的密码
    从 1970 年 1 月 1 日到密码最后一次被更改的天数
    距密码可以更改之前的天数
    距密码必须更改之前的天数
    密码到期前用户被警告的天数
    密码到期后帐户被禁用的天数
    从 1970 年 1 月 1 日到帐号被禁用的天数
/etc/shells 包含系统可用的可能的“shell”的列表。
/etc/motd   每日消息；在管理员希望向 Linux 服务器的所有用户传达某个消息时使用。

etc(联网){}
/etc/gated.conf	gated 的配置。只能被 gated 守护进程所使用。
/etc/gated.version	包含 gated 守护进程的版本号。
/etc/gateway	由 routed 守护进程可选地使用。
/etc/networks	列举从机器所连接的网络可以访问的网络名和网络地址。通过路由命令使用。允许使用网络名称。
/etc/protocols	列举当前可用的协议。请参阅 NAG（网络管理员指南，Network Administrators Guide）和联机帮助页。 C 接口是 getprotoent。绝不能更改。
/etc/resolv.conf	在程序请求“解析”一个 IP 地址时告诉内核应该查询哪个名称服务器。
/etc/rpc	包含 RPC 指令／规则，这些指令／规则可以在 NFS 调用、远程文件系统安装等中使用。
/etc/exports	要导出的文件系统（NFS）和对它的权限。
/etc/services	将网络服务名转换为端口号／协议。由 inetd、telnet、tcpdump 和一些其它程序读取。有一些 C 访问例程。
/etc/inetd.conf	inetd 的配置文件。请参阅 inetd 联机帮助页。 包含每个网络服务的条目，inetd 必须为这些网络服务控制守护进程或其它服务。注意，服务将会运行，但在 /etc/services 中将它们注释掉了，这样即使这些服务在运行也将不可用。 格式为：<service_name> <sock_type> <proto> <flags> <user> <server_path> <args>
/etc/sendmail.cf	邮件程序 sendmail 的配置文件。比较隐晦，很难理解。
/etc/sysconfig/network	指出 NETWORKING=yes 或 no。至少由 rc.sysinit 读取。
/etc/sysconfig/network-scripts/if*  Red Hat 网络配置脚本。

etc(系统命令){}
/etc/lilo.conf	包含系统的缺省引导命令行参数，还有启动时使用的不同映象。您在 LILO 引导提示的时候按 Tab 键就可以看到这个列表。
/etc/logrotate.conf	维护 /var/log 目录中的日志文件。
/etc/identd.conf	identd 是一个服务器，它按照 RFC 1413 文档中指定的方式实现 TCP/IP 提议的标准 IDENT 用户身份识别协议。identd 的操作原理是查找特定 TCP/IP 连接并返回拥有此连接的进程的用户名。作为选择，它也可以返回其它信息，而不是用户名。请参阅 identd 联机帮助页。
/etc/ld.so.conf	“动态链接程序”（Dynamic Linker）的配置。
/etc/inittab	按年代来讲，这是 UNIX 中第一个配置文件。在一台 UNIX 机器打开之后启动的第一个程序是 init，它知道该启动什么，这是由于 inittab 的存在。在运行级别改变时，init 读取 inittab，然后控制主进程的启动。
/etc/termcap	一个数据库，包含所有可能的终端类型以及这些终端的性能。

etc(守护进程){}
/etc/syslogd.conf	syslogd 守护进程的配置文件。syslogd 是一种守护进程，它负责记录（写到磁盘）从其它程序发送到系统的消息。这个服务尤其常被某些守护进程所使用，这些守护进程不会有另外的方法来发出可能有问题存在的信号或向用户发送消息。
/etc/httpd.conf	Web 服务器 Apache 的配置文件。这个文件一般不在 /etc 中。它可能在 /usr/local/httpd/conf/ 或 /etc/httpd/conf/ 中，但是要确定它的位置，您还需要检查特定的 Apache 安装信息。
/etc/conf.modules or /etc/modules.conf	kerneld 的配置文件。有意思的是，kerneld 并不是“作为守护进程的”内核。它其实是一种在需要时负责“快速”加载附加内核模块的守护进程。

etc(/proc/sys/kernel/printk){}
首先，printk有8个loglevel,定义在<linux/kernel.h>中，其中数值范围从0到7，数值越小，优先级越高。
#define    KERN_EMERG      "<0>"      系统崩溃
#define    KERN_ALERT       "<1>"必须紧急处理
#define    KERN_CRIT "<2>"      临界条件，严重的硬软件错误
#define    KERN_ERR    "<3>"      报告错误
#define    KERN_WARNING "<4>"      警告
#define    KERN_NOTICE     "<5>"      普通但还是须注意
#define    KERN_INFO "<6>"      信息
#define    KERN_DEBUG      "<7>"      调试信息

从这里也可以看出他们的优先级是数值越小，其紧急和严重程度就越高。
extern int console_printk[];
#define console_loglevel (console_printk[0])
#define default_message_loglevel (console_printk[1])
#define minimum_console_loglevel (console_printk[2])
#define default_console_loglevel (console_printk[3])

未指定优先级的默认级别定义在/kernel/printk.c中：
#define DEFAULT_MESSAGE_LOGLEVEL 4
#define MINIMUM_CONSOLE_LOGLEVEL 1
#define DEFAULT_CONSOLE_LOGLEVEL 7

int console_printk[4] = {
       DEFAULT_CONSOLE_LOGLEVEL,   终端级别
       DEFAULT_MESSAGE_LOGLEVEL,   默认级别
       MINIMUM_CONSOLE_LOGLEVEL, 让用户使用的最小级别
       DEFAULT_CONSOLE_LOGLEVEL,   默认终端级别
};

当优先级的值小于console_loglevel这个整数变量的值，信息才能显示出来。而console_loglevel的初始值
DEFAULT_CONSOLE_LOGLEVEL也定义在/kernel/printk.c中：

# echo 1       4       1      7 > /proc/sys/kernel/printk
或者
# echo 0       4       0      7 > /proc/sys/kernel/printk

cat /proc/sys/kernel/printk
4   4   1   7
这个默认值是在sysctl.conf中写的，在系统启动时就把这个值写到/proc/sys/kernel/printk这个文件了。也可以使用下面的命令修改其值
echo 0 > /proc/sys/kernel/printk
cat /proc/sys/kernel/printk
0   4   1   7

它们根据日志记录消息的重要性，定义将其发送到何处。关于不同日志级别的更多信息，请阅读 syslog(2) 联机帮助页。该文件的四个值为：
控制台日志级别：优先级高于该值的消息将被打印至控制台
缺省的消息日志级别：将用该优先级来打印没有优先级的消息
最低的控制台日志级别：控制台日志级别可被设置的最小值（最高优先级）
缺省的控制台日志级别：控制台日志级别的缺省值

messages，kern.log，syslog，debug。这四个文件都在/var/log/这个目录下。它的日志文件经观察未出现这些printk信息。
cat /proc/sys/kernel/printk
4   4   1   7

在上面这种情况下日志文件的变化情况是：
l         kern.log：   纪录了级别是0—7包括<8>的所有信息，在这些纪录当中，其中<8>的纪录是这样的。<8>goodluck8!
l         Messages： 只是记录了456和<8>。
l         Syslog：     记录和kern.log一样。
l         Debug：     之记录级别是7的信息。

syslogd的配置文件是/etc/syslog.conf。

下面是我机子上这个文件的部分内容。主要是对debug和messages文件要记录内容的设置。

*.=debug;\
        auth,authpriv.none;\
        news.none;mail.none     -/var/log/debug
*.=info;*.=notice;*.=warn;\
        auth,authpriv.none;\
        cron,daemon.none;\
        mail,news.none          -/var/log/messages
        
etc(/proc/sysrq-trigger){}
重启服务器
1.     # echo 1 > /proc/sys/kernel/sysrq  
2.     # echo b > /proc/sysrq-trigger  
1. /proc/sys/kernel/sysrq
向sysrq文件中写入1是为了开启SysRq功能。根据linux/Documentations/sysrq.txt中所说：SysRq代表的是Magic System Request Key。开启了这个功能以后，只要内核没有挂掉，它就会响应你要求的任何操作。但是这需要内核支持(CONFIG_MAGIC_SYSRQ选项)。向/proc/sys/kernel/sysrq中写入0是关闭sysrq功能，写入1是开启，其他选项请参考sysrq.txt。需要注意的是，/proc/sys/kernel/sysrq中的值只影响键盘的操作。
那么怎么使用SysRq键呢？
在x86平台上，组合键"<ALT> + SysRq + <command key>"组成SysRq键以完成各种功能。但是，在一些键盘上可能没有SysRq键。SysRq键实际上就是"Print Screen"键。并且可能有些键盘不支持同时按三个按键，所以你可以按住"ALT键"，按一下"SysRq键"，再按一下"<command key>键"，如果你运气好的话，这个会有效果的。不过放心，现在的键盘一般都支持同时按3个或3个以上的键。
<command key>有很多，这里只挑几个来说，其他的可以参考sysrq.txt文件。
· 'b' —— 将会立即重启系统，并且不会管你有没有数据没有写回磁盘，也不卸载磁盘，而是完完全全的立即关机
· 'o' —— 将会关机
· 's' —— 将会同步所有以挂在的文件系统
· 'u' —— 将会重新将所有的文件系统挂在为只读属性

2. /proc/sysrq-trigger
从文件名字就可以看出来这两个是有关系的。写入/proc/sysrq-trigger中的字符其实就是sysrq.txt中说的键所对应的字符，其功能也和上述一样。
所以，这两行命令先开启SysRq功能，然后用'b'命令让计算机立刻重启。
/proc/sysrq-trigger该文件能做些什么事情呢？ 
# 立即重新启动计算机 （Reboots the kernel without first unmounting file systems or syncing disks attached to the system）
echo "b" > /proc/sysrq-trigger
# 立即关闭计算机（shuts off the system）
echo "o" > /proc/sysrq-trigger
# 导出内存分配的信息 （可以用/var/log/message 查看）（Outputs memory statistics to the console） 
echo "m" > /proc/sysrq-trigger
# 导出当前CPU寄存器信息和标志位的信息（Outputs all flags and registers to the console）
echo "p" > /proc/sysrq-trigger
# 导出线程状态信息 （Outputs a list of processes to the console）
echo "t" > /proc/sysrq-trigger
# 故意让系统崩溃 （ Crashes the system without first unmounting file systems or syncing disks attached to the system）
echo "c" > /proc/sysrq-trigger
# 立即重新挂载所有的文件系统 （Attempts to sync disks attached to the system）
echo "s" > /proc/sysrq-trigger
# 立即重新挂载所有的文件系统为只读 （Attempts to unmount and remount all file systems as read-only）
echo "u" > /proc/sysrq-trigger
此外还有两个，类似于强制注销的功能
e — Kills all processes except init using SIGTERM
i — Kills all processes except init using SIGKILL


etc(/proc/sys/kernel/){}
1)      /proc/sys/kernel/ctrl-alt-del
该文件有一个二进制值，该值控制系统在接收到ctrl+alt+delete按键组合时如何反应。这两个值分别是：
零（0）值，表示捕获ctrl+alt+delete，并将其送至 init 程序；这将允许系统可以安全地关闭和重启，就好象输入shutdown命令一样。
壹（1）值，表示不捕获ctrl+alt+delete，将执行非正常的关闭，就好象直接关闭电源一样。

缺省设置：0
建议设置：1，防止意外按下ctrl+alt+delete导致系统非正常重启。
2)      proc/sys/kernel/msgmax
该文件指定了从一个进程发送到另一个进程的消息的最大长度（bytes）。进程间的消息传递是在内核的内存中进行的，不会交换到磁盘上，所以如果增加该值，则将增加操作系统所使用的内存数量。

缺省设置：8192
3)      /proc/sys/kernel/msgmnb
该文件指定一个消息队列的最大长度（bytes）。

缺省设置：16384
4)      /proc/sys/kernel/msgmni
该文件指定消息队列标识的最大数目，即系统范围内最大多少个消息队列。

缺省设置：16
5)      /proc/sys/kernel/panic
该文件表示如果发生“内核严重错误（kernel panic）”，则内核在重新引导之前等待的时间（以秒为单位）。
零（0）秒，表示在发生内核严重错误时将禁止自动重新引导。

缺省设置：0
6)      proc/sys/kernel/shmall
该文件表示在任何给定时刻，系统上可以使用的共享内存的总量（bytes）。

缺省设置：2097152
7)      /proc/sys/kernel/shmmax
该文件表示内核所允许的最大共享内存段的大小（bytes）。

缺省设置：33554432
建议设置：物理内存 * 50%

实际可用最大共享内存段大小=shmmax * 98%，其中大约2%用于共享内存结构。
可以通过设置shmmax，然后执行ipcs -l来验证。
8)      /proc/sys/kernel/shmmni
该文件表示用于整个系统的共享内存段的最大数目（个）。

缺省设置：4096
9)      /proc/sys/kernel/threads-max
该文件表示内核所能使用的线程的最大数目。

缺省设置：2048
10) /proc/sys/kernel/sem
该文件用于控制内核信号量，信号量是System VIPC用于进程间通讯的方法。

建议设置：250 32000 100 128
第一列，表示每个信号集中的最大信号量数目。
第二列，表示系统范围内的最大信号量总数目。
第三列，表示每个信号发生时的最大系统操作数目。
第四列，表示系统范围内的最大信号集总数目。
所以，（第一列）*（第四列）=（第二列）

以上设置，可以通过执行ipcs -l来验证。
11) sysrq   如果值为 1，Alt-SysRq 则为激活状态。

12) osrelease	显示操作系统的发行版版本号
13) ostype	显示操作系统的类型。
14) hostname	系统的主机名。
15) domainname	网络域，系统是该网络域的一部分。
16) modprobe	指定 modprobe 是否应该在启动时自动运行并加载必需的模块。
17）modules_disabled 前者包含一个路径指向内核模块加载器(kernel module loader)，
         用于加载内核模块；而后一个用于控制是否允许在系统启动后热插拔模块，即进行modprobe/rmmod操作，0表示不禁止；
18) modprobe Linux启动初始化时需执行/etc/rc.d/rc.sysinit，而该脚本其中一项就是加载用户自定义模块/etc/sysconfig/modules/*.modules
该系统在启动时会自动加载nvram/floppy/parport/lp/snd-powermac系统
19) pid_max 系统最大pid值，在大型系统里可适当调大
20) hung_task_panic softlockup_thresh
linux下每个CPU都有一个看门狗(watchdog)进程，可通过ps -ef | grep -i watchdog查看，该进程每秒获取其CPU的当前时间戳并保存于per-CPU，而timer interrupt()
会调用softlock_tick()，该函数比较CPU当前时间与per-CPU保存的时间，若差值大于softlockup_thresh则系统产生一条告警信息，
BUG: soft lockup - CPU#1 stuck for 15s! [swapper:0] Pid: 0
如遇到此情形可配置kdump自动产生vcore跟踪文件；
默认情况下，当出现soft lockup时系统仅产生告警信息，而将hung_task_panic设置为1时系统会panic；
justin_$ more hung_task_panic
0
justin_$ more softlockup_thresh
60
/sbin/modinfo softdog
/lib/modules/2.6.32-279.el6.x86_64/kernel/drivers/watchdog/softdog.ko

21） nmi_watchdog
NMI watchdog(non maskable interrupt)又称硬件watchdog，用于检测OS是否hang，系统硬件定期产生一个NMI，而每个NMI调用内核查看其中断数量，如果一段时间(10秒)后其数量没有显著增长，则判定系统已经hung，接下来启用panic机制即重启OS，如果开启了Kdump还会产生crash dump文件；
APIC(advanced programmable interrupt controller)：高级可编程中断控制器，默认内置于各个x86CPU中，在SMP中用于CPU间的中断；比较高档的主板配备有IO-APIC，负责收集硬件设备的中断请求并转发给APIC；
要使用NMI Watchdog必须先激活APIC，SMP内核默认启动
该参数有2个选项：0不激活；1/2激活，有的硬件支持1有的支持2；
当前系统便没有激活；
justin_$ more nmi_watchdog
0
justin_$ grep NMI /proc/interrupts
 NMI:          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0          0   Non-maskable interrupts
小结
当watchdog启动后，如果/dev/watchdog一定时间间隔内没有被更新，则判定系统hang并根据相应参数决定是否重启
Watchdog有两种：软件/硬件模式，前者基于hrtimer而后者基于perf子系统，两者不能同时运行

22) Panic
当内核panic时是否重启，0不重启，非0值表示N秒后重启
justin_$ more panic
0
23) panic_on_io_nmi
当内核收到因I/O错误导致的NMI时是否panic
0表示不
justin_$ more panic_on_io_nmi
0
24) panic_on_io_nmi
panic_on_oops
内核oops不同于panic，后者会导致OS重启，而设备驱动引发的oops通常不会如此；
Oops是由于内核引用了无效指针；发生于用户空间程序通常产生一个段错误segfault，而用户态程序自身无法恢复；发生于内核空间时则称作oops；
由于X86架构限制，当linux系统panic时 默认无法保存crash dump，因为此时内核不工作无法保存当前内存信息，SPARC架构则可完成，而RedHat分别开发了NetDump/Diskdump从而做到此功能；
justin_$ more panic_on_oops
1
如下是一段oops信息，oops号码很重要，EIP显示了代码段和当前正在执行的指令集地址




         
etc(/proc/sys/vm/){}
三、/proc/sys/vm/优化
1)      /proc/sys/vm/block_dump
该文件表示是否打开Block Debug模式，用于记录所有的读写及Dirty Block写回动作。

缺省设置：0，禁用Block Debug模式
2)      /proc/sys/vm/dirty_background_ratio
该文件表示脏数据到达系统整体内存的百分比，此时触发pdflush进程把脏数据写回磁盘。

缺省设置：10
3)      /proc/sys/vm/dirty_expire_centisecs
该文件表示如果脏数据在内存中驻留时间超过该值，pdflush进程在下一次将把这些数据写回磁盘。

缺省设置：3000（1/100秒）
4)      /proc/sys/vm/dirty_ratio
该文件表示如果进程产生的脏数据到达系统整体内存的百分比，此时进程自行把脏数据写回磁盘。

缺省设置：40
5)      /proc/sys/vm/dirty_writeback_centisecs
该文件表示pdflush进程周期性间隔多久把脏数据写回磁盘。

缺省设置：500（1/100秒）
6)      /proc/sys/vm/vfs_cache_pressure
该文件表示内核回收用于directory和inode cache内存的倾向；缺省值100表示内核将根据pagecache和swapcache，把directory和inode cache保持在一个合理的百分比；降低该值低于100，将导致内核倾向于保留directory和inode cache；增加该值超过100，将导致内核倾向于回收directory和inode cache。

缺省设置：100
7)      /proc/sys/vm/min_free_kbytes
该文件表示强制Linux VM最低保留多少空闲内存（Kbytes）。

缺省设置：724（512M物理内存）
8)      /proc/sys/vm/nr_pdflush_threads
该文件表示当前正在运行的pdflush进程数量，在I/O负载高的情况下，内核会自动增加更多的pdflush进程。

缺省设置：2（只读）
9)      /proc/sys/vm/overcommit_memory
该文件指定了内核针对内存分配的策略，其值可以是0、1、2。
0， 表示内核将检查是否有足够的可用内存供应用进程使用；如果有足够的可用内存，内存申请允许；否则，内存申请失败，并把错误返回给应用进程。
1， 表示内核允许分配所有的物理内存，而不管当前的内存状态如何。
2， 表示内核允许分配超过所有物理内存和交换空间总和的内存（参照overcommit_ratio）。

缺省设置：0
10) /proc/sys/vm/overcommit_ratio
该文件表示，如果overcommit_memory=2，可以过载内存的百分比，通过以下公式来计算系统整体可用内存。
系统可分配内存=交换空间+物理内存*overcommit_ratio/100

缺省设置：50（%）
11) /proc/sys/vm/page-cluster
该文件表示在写一次到swap区的时候写入的页面数量，0表示1页，1表示2页，2表示4页。

缺省设置：3（2的3次方，8页）
12) /proc/sys/vm/swapiness
该文件表示系统进行交换行为的程度，数值（0-100）越高，越可能发生磁盘交换。

缺省设置：60
13) legacy_va_layout
该文件表示是否使用最新的32位共享内存mmap()系统调用，Linux支持的共享内存分配方式包括mmap()，Posix，System VIPC。
0， 使用最新32位mmap()系统调用。
1， 使用2.4内核提供的系统调用。

缺省设置：0
14) nr_hugepages
该文件表示系统保留的hugetlb页数。
15) hugetlb_shm_group
该文件表示允许使用hugetlb页创建System VIPC共享内存段的系统组ID。
16) 待续。。。
四、/proc/sys/fs/优化
1)      /proc/sys/fs/file-max
该文件指定了可以分配的文件句柄的最大数目。如果用户得到的错误消息声明由于打开
文件数已经达到了最大值，从而他们不能打开更多文件，则可能需要增加该值。

缺省设置：4096
建议设置：65536
2)      /proc/sys/fs/file-nr
该文件与 file-max 相关，它有三个值：
已分配文件句柄的数目
已使用文件句柄的数目
文件句柄的最大数目
该文件是只读的，仅用于显示信息。
3)      待续。。。

etc(/proc/sys/net/core/){}
五、/proc/sys/net/core/优化
　　该目录下的配置文件主要用来控制内核和网络层之间的交互行为。
1） /proc/sys/net/core/message_burst
写新的警告消息所需的时间（以 1/10 秒为单位）；在这个时间内系统接收到的其它警告消息会被丢弃。这用于防止某些企图用消息“淹没”系统的人所使用的拒绝服务（Denial of Service）攻击。

缺省设置：50（5秒）
2） /proc/sys/net/core/message_cost
该文件表示写每个警告消息相关的成本值。该值越大，越有可能忽略警告消息。

缺省设置：5
3） /proc/sys/net/core/netdev_max_backlog
该文件表示在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目。

缺省设置：300
4） /proc/sys/net/core/optmem_max
该文件表示每个套接字所允许的最大缓冲区的大小。

缺省设置：10240
5） /proc/sys/net/core/rmem_default
该文件指定了接收套接字缓冲区大小的缺省值（以字节为单位）。

缺省设置：110592
6） /proc/sys/net/core/rmem_max
该文件指定了接收套接字缓冲区大小的最大值（以字节为单位）。

缺省设置：131071
7） /proc/sys/net/core/wmem_default
该文件指定了发送套接字缓冲区大小的缺省值（以字节为单位）。

缺省设置：110592
8） /proc/sys/net/core/wmem_max
该文件指定了发送套接字缓冲区大小的最大值（以字节为单位）。

缺省设置：131071
9） 待续。。。

etc(/proc/sys/net/ipv4/){}
六、/proc/sys/net/ipv4/优化
1)      /proc/sys/net/ipv4/ip_forward
该文件表示是否打开IP转发。
0，禁止
1，转发

缺省设置：0
2)      /proc/sys/net/ipv4/ip_default_ttl
该文件表示一个数据报的生存周期（Time To Live），即最多经过多少路由器。

缺省设置：64
增加该值会降低系统性能。
3)      /proc/sys/net/ipv4/ip_no_pmtu_disc
该文件表示在全局范围内关闭路径MTU探测功能。

缺省设置：0
4)      /proc/sys/net/ipv4/route/min_pmtu
该文件表示最小路径MTU的大小。

缺省设置：552
5)      /proc/sys/net/ipv4/route/mtu_expires
该文件表示PMTU信息缓存多长时间（秒）。

缺省设置：600（秒）
6)      /proc/sys/net/ipv4/route/min_adv_mss
该文件表示最小的MSS（Maximum Segment Size）大小，取决于第一跳的路由器MTU。

缺省设置：256（bytes）
6.1 IP Fragmentation
1)      /proc/sys/net/ipv4/ipfrag_low_thresh/proc/sys/net/ipv4/ipfrag_low_thresh
两个文件分别表示用于重组IP分段的内存分配最低值和最高值，一旦达到最高内存分配值，其它分段将被丢弃，直到达到最低内存分配值。

缺省设置：196608（ipfrag_low_thresh）
　　　　　262144（ipfrag_high_thresh）
2)      /proc/sys/net/ipv4/ipfrag_time
该文件表示一个IP分段在内存中保留多少秒。

缺省设置：30（秒）
6.2 INET Peer Storage
1)      /proc/sys/net/ipv4/inet_peer_threshold
INET对端存储器某个合适值，当超过该阀值条目将被丢弃。该阀值同样决定生存
时间以及废物收集通过的时间间隔。条目越多，存活期越低，GC 间隔越短。

缺省设置：65664
2)      /proc/sys/net/ipv4/inet_peer_minttl
条目的最低存活期。在重组端必须要有足够的碎片(fragment)存活期。这个最低
存活期必须保证缓冲池容积是否少于 inet_peer_threshold。该值以 jiffies为
单位测量。

缺省设置：120
3)      /proc/sys/net/ipv4/inet_peer_maxttl
条目的最大存活期。在此期限到达之后，如果缓冲池没有耗尽压力的话(例如：缓
冲池中的条目数目非常少)，不使用的条目将会超时。该值以 jiffies为单位测量。

缺省设置：600
4)      /proc/sys/net/ipv4/inet_peer_gc_mintime
废物收集(GC)通过的最短间隔。这个间隔会影响到缓冲池中内存的高压力。 该值
以 jiffies为单位测量。
5)      /proc/sys/net/ipv4/inet_peer_gc_maxtime
废物收集(GC)通过的最大间隔，这个间隔会影响到缓冲池中内存的低压力。 该值
以 jiffies为单位测量。

缺省设置：120
6.3 TCP Variables
1)      /proc/sys/net/ipv4/tcp_syn_retries
该文件表示本机向外发起TCP SYN连接超时重传的次数，不应该高于255；该值仅仅针对外出的连接，对于进来的连接由tcp_retries1控制。

缺省设置：5
2)      /proc/sys/net/ipv4/tcp_keepalive_probes
该文件表示丢弃TCP连接前，进行最大TCP保持连接侦测的次数。保持连接仅在
SO_KEEPALIVE套接字选项被打开时才被发送。

缺省设置：9（次）
3)      /proc/sys/net/ipv4/tcp_keepalive_time
该文件表示从不再传送数据到向连接上发送保持连接信号之间所需的秒数。

缺省设置：7200（2小时）
4)      /proc/sys/net/ipv4/tcp_keepalive_intvl
该文件表示发送TCP探测的频率，乘以tcp_keepalive_probes表示断开没有相应的TCP连接的时间。

缺省设置：75（秒）
5)      /proc/sys/net/ipv4/tcp_retries1
　　该文件表示放弃回应一个TCP连接请求前进行重传的次数。
　　
　　缺省设置：3
6)      /proc/sys/net/ipv4/tcp_retries2
　　该文件表示放弃在已经建立通讯状态下的一个TCP数据包前进行重传的次数。
　　
　　缺省设置：15
7)      /proc/sys/net/ipv4/tcp_orphan_retries
在近端丢弃TCP连接之前，要进行多少次重试。默认值是 7 个，相当于 50秒–
16分钟，视 RTO 而定。如果您的系统是负载很大的web服务器，那么也许需
要降低该值，这类 sockets 可能会耗费大量的资源。另外参考
tcp_max_orphans。
8)      /proc/sys/net/ipv4/tcp_fin_timeout
对于本端断开的socket连接，TCP保持在FIN-WAIT-2状态的时间。对方可能
会断开连接或一直不结束连接或不可预料的进程死亡。默认值为 60 秒。过去在
2.2版本的内核中是 180 秒。您可以设置该值，但需要注意，如果您的机器为负
载很重的web服务器，您可能要冒内存被大量无效数据报填满的风险，
FIN-WAIT-2 sockets 的危险性低于 FIN-WAIT-1，因为它们最多只吃 1.5K
的内存，但是它们存在时间更长。另外参考 tcp_max_orphans。

缺省设置：60（秒）
9)      /proc/sys/net/ipv4/tcp_max_tw_buckets
系统在同时所处理的最大timewait sockets 数目。如果超过此数的话，
time-wait socket 会被立即砍除并且显示警告信息。之所以要设定这个限制，纯
粹为了抵御那些简单的 DoS 攻击，千万不要人为的降低这个限制，不过，如果
网络条件需要比默认值更多，则可以提高它(或许还要增加内存)。

缺省设置：180000
10) /proc/sys/net/ipv4/tcp_tw_recyle
打开快速 TIME-WAIT sockets 回收。除非得到技术专家的建议或要求，请不要随
意修改这个值。

缺省设置：0
11) /proc/sys/net/ipv4/tcp_tw_reuse
该文件表示是否允许重新应用处于TIME-WAIT状态的socket用于新的TCP连接。

缺省设置：0
12) /proc/sys/net/ipv4/tcp_max_orphans
系统所能处理不属于任何进程的TCP sockets最大数量。假如超过这个数量，那
么不属于任何进程的连接会被立即reset，并同时显示警告信息。之所以要设定这
个限制，纯粹为了抵御那些简单的 DoS 攻击，千万不要依赖这个或是人为的降
低这个限制。

缺省设置：8192
13) /proc/sys/net/ipv4/tcp_abort_on_overflow
当守护进程太忙而不能接受新的连接，就向对方发送reset消息，默认值是false。
这意味着当溢出的原因是因为一个偶然的猝发，那么连接将恢复状态。只有在你确
信守护进程真的不能完成连接请求时才打开该选项，该选项会影响客户的使用。

缺省设置：０
14) /proc/sys/net/ipv4/tcp_syncookies
该文件表示是否打开TCP同步标签(syncookie)，内核必须打开了 CONFIG_SYN_COOKIES项进行编译。 同步标签(syncookie)可以防止一个套接字在有过多试图连接到达时引起过载。

缺省设置：0
15) /proc/sys/net/ipv4/tcp_stdurg
使用 TCP urg pointer 字段中的主机请求解释功能。大部份的主机都使用老旧的
BSD解释，因此如果您在 Linux 打开它，或会导致不能和它们正确沟通。

缺省设置：0
16) /proc/sys/net/ipv4/tcp_max_syn_backlog
对于那些依然还未获得客户端确认的连接请求，需要保存在队列中最大数目。对于
超过 128Mb 内存的系统，默认值是 1024，低于 128Mb 的则为 128。如果
服务器经常出现过载，可以尝试增加这个数字。警告！假如您将此值设为大于
1024，最好修改 include/net/tcp.h 里面的 TCP_SYNQ_HSIZE，以保持
TCP_SYNQ_HSIZE*16 0)或者bytes-bytes/2^(-tcp_adv_win_scale)(如
果tcp_adv_win_scale 128Mb 32768-610000)则系统将忽略所有发送给自己
的ICMP ECHO请求或那些广播地址的请求。

缺省设置：1024
17) /proc/sys/net/ipv4/tcp_window_scaling
该文件表示设置tcp/ip会话的滑动窗口大小是否可变。参数值为布尔值，为1时表示可变，为0时表示不可变。tcp/ip通常使用的窗口最大可达到65535 字节，对于高速网络，该值可能太小，这时候如果启用了该功能，可以使tcp/ip滑动窗口大小增大数个数量级，从而提高数据传输的能力。

缺省设置：1
18) /proc/sys/net/ipv4/tcp_sack
该文件表示是否启用有选择的应答（Selective Acknowledgment），这可以通过有选择地应答乱序接收到的报文来提高性能（这样可以让发送者只发送丢失的报文段）；（对于广域网通信来说）这个选项应该启用，但是这会增加对 CPU 的占用。

缺省设置：1
19) /proc/sys/net/ipv4/tcp_timestamps
该文件表示是否启用以一种比超时重发更精确的方法（请参阅 RFC 1323）来启用对 RTT 的计算；为了实现更好的性能应该启用这个选项。

缺省设置：1
20) /proc/sys/net/ipv4/tcp_fack
该文件表示是否打开FACK拥塞避免和快速重传功能。

缺省设置：1
21) /proc/sys/net/ipv4/tcp_dsack
该文件表示是否允许TCP发送“两个完全相同”的SACK。

缺省设置：1
22) /proc/sys/net/ipv4/tcp_ecn
该文件表示是否打开TCP的直接拥塞通告功能。

缺省设置：0
23) /proc/sys/net/ipv4/tcp_reordering
该文件表示TCP流中重排序的数据报最大数量。

缺省设置：3
24) /proc/sys/net/ipv4/tcp_retrans_collapse
该文件表示对于某些有bug的打印机是否提供针对其bug的兼容性。

缺省设置：1
25) /proc/sys/net/ipv4/tcp_wmem
该文件包含3个整数值，分别是：min，default，max
Min：为TCP socket预留用于发送缓冲的内存最小值。每个TCP socket都可以使用它。
Default：为TCP socket预留用于发送缓冲的内存数量，默认情况下该值会影响其它协议使用的net.core.wmem中default的 值，一般要低于net.core.wmem中default的值。
Max：为TCP socket预留用于发送缓冲的内存最大值。该值不会影响net.core.wmem_max，今天选择参数SO_SNDBUF则不受该值影响。默认值为128K。

缺省设置：4096 16384 131072
26) /proc/sys/net/ipv4/tcp_rmem
该文件包含3个整数值，分别是：min，default，max
Min：为TCP socket预留用于接收缓冲的内存数量，即使在内存出现紧张情况下TCP socket都至少会有这么多数量的内存用于接收缓冲。
Default：为TCP socket预留用于接收缓冲的内存数量，默认情况下该值影响其它协议使用的 net.core.wmem中default的 值。该值决定了在tcp_adv_win_scale、tcp_app_win和tcp_app_win的默认值情况下，TCP 窗口大小为65535。
Max：为TCP socket预留用于接收缓冲的内存最大值。该值不会影响 net.core.wmem中max的值，今天选择参数 SO_SNDBUF则不受该值影响。

缺省设置：4096 87380 174760
27) /proc/sys/net/ipv4/tcp_mem
该文件包含3个整数值，分别是：low，pressure，high
Low：当TCP使用了低于该值的内存页面数时，TCP不会考虑释放内存。
Pressure：当TCP使用了超过该值的内存页面数量时，TCP试图稳定其内存使用，进入pressure模式，当内存消耗低于low值时则退出pressure状态。
High：允许所有tcp sockets用于排队缓冲数据报的页面量。
一般情况下这些值是在系统启动时根据系统内存数量计算得到的。

缺省设置：24576 32768 49152
28) /proc/sys/net/ipv4/tcp_app_win
该文件表示保留max(window/2^tcp_app_win, mss)数量的窗口由于应用缓冲。当为0时表示不需要缓冲。

缺省设置：31
29) /proc/sys/net/ipv4/tcp_adv_win_scale
该文件表示计算缓冲开销bytes/2^tcp_adv_win_scale(如果tcp_adv_win_scale >; 0)或者bytes-bytes/2^(-tcp_adv_win_scale)(如果tcp_adv_win_scale <= 0）。

缺省设置：2
6.4 IP Variables
1)      /proc/sys/net/ipv4/ip_local_port_range
该文件表示TCP／UDP协议打开的本地端口号。

缺省设置：1024 4999
建议设置：32768 61000
2)      /proc/sys/net/ipv4/ip_nonlocal_bind
该文件表示是否允许进程邦定到非本地地址。

缺省设置：0
3)      /proc/sys/net/ipv4/ip_dynaddr
该参数通常用于使用拨号连接的情况，可以使系统动能够立即改变ip包的源地址为该ip地址，同时中断原有的tcp对话而用新地址重新发出一个syn请求包，开始新的tcp对话。在使用ip欺骗时，该参数可以立即改变伪装地址为新的ip地址。该文件表示是否允许动态地址，如果该值非0，表示允许；如果该值大于1，内核将通过log记录动态地址重写信息。

缺省设置：0
4)      /proc/sys/net/ipv4/icmp_echo_ignore_all/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
该文件表示内核是否忽略所有的ICMP ECHO请求，或忽略广播和多播请求。
0， 响应请求
1， 忽略请求

缺省设置：０
建议设置：1
5)      /proc/sys/net/ipv4/icmp_ratelimit
6)      /proc/sys/net/ipv4/icmp_ratemask
7)      /proc/sys/net/ipv4/icmp_ignore_bogus_error_reponses
某些路由器违背RFC1122标准，其对广播帧发送伪造的响应来应答。这种违背行
为通常会被以告警的方式记录在系统日志中。如果该选项设置为True，内核不会
记录这种警告信息。

缺省设置：0
8)      /proc/sys/net/ipv4/igmp_max_memberships
该文件表示多播组中的最大成员数量。

缺省设置：20
6.5 Other Configuration
1)      /proc/sys/net/ipv4/conf/*/accept_redirects
　　　如果主机所在的网段中有两个路由器，你将其中一个设置成了缺省网关，但是该网关
　　　在收到你的ip包时发现该ip包必须经过另外一个路由器，这时这个路由器就会给你
　　　发一个所谓的“重定向”icmp包，告诉将ip包转发到另外一个路由器。参数值为布尔
　　　值，1表示接收这类重定向icmp 信息，0表示忽略。在充当路由器的linux主机上缺
　　　省值为0，在一般的linux主机上缺省值为1。建议将其改为0以消除安全性隐患。
2)      /proc/sys/net/ipv4/*/accept_source_route
　是否接受含有源路由信息的ip包。参数值为布尔值，1表示接受，0表示不接受。在
　充当网关的linux主机上缺省值为1，在一般的linux主机上缺省值为0。从安全性角
　度出发，建议关闭该功能。
3)      /proc/sys/net/ipv4/*/secure_redirects
　其实所谓的“安全重定向”就是只接受来自网关的“重定向”icmp包。该参数就是
　用来设置“安全重定向”功能的。参数值为布尔值，1表示启用，0表示禁止，缺省值
　为启用。
4)      /proc/sys/net/ipv4/*/proxy_arp
　设置是否对网络上的arp包进行中继。参数值为布尔值，1表示中继，0表示忽略，
　缺省值为0。该参数通常只对充当路由器的linux主机有用。

etc(性能优化策略){}
7.1 基本优化
1)      关闭后台守护进程
系统安装完后，系统会默认启动一些后台守护进程，有些进程并不是必需的；因此，关闭这些进程可以节省一部分物理内存消耗。以root身份登录系统，运行ntsysv，选中如下进程：
　　iptables
network
syslog
random
apmd
xinetd
vsftpd
crond
local
修改完后，重新启动系统。
如此，系统将仅仅启动选中的这些守护进程。
2)      减少终端连接数
系统默认启动6个终端，而实际上只需启动3个即可；以root身份登录系统，运行vi /etc/inittab，修改成如下：
# Run gettys in standard runlevels
1:2345:respawn:/sbin/mingetty tty1
2:2345:respawn:/sbin/mingetty tty2
3:2345:respawn:/sbin/mingetty tty3
#4:2345:respawn:/sbin/mingetty tty4
#5:2345:respawn:/sbin/mingetty tty5
#6:2345:respawn:/sbin/mingetty tty6
如上所述，注释掉4、5、6终端。
3)      待续。。。
7.2 网络优化
1)      优化系统套接字缓冲区
net.core.rmem_max=16777216
net.core.wmem_max=16777216
2)      优化TCP接收／发送缓冲区
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
3)      优化网络设备接收队列
net.core.netdev_max_backlog=3000
4)      关闭路由相关功能
net.ipv4.conf.lo.accept_source_route=0
net.ipv4.conf.all.accept_source_route=0
net.ipv4.conf.eth0.accept_source_route=0
net.ipv4.conf.default.accept_source_route=0

net.ipv4.conf.lo.accept_redirects=0
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.eth0.accept_redirects=0
net.ipv4.conf.default.accept_redirects=0

net.ipv4.conf.lo.secure_redirects=0
net.ipv4.conf.all.secure_redirects=0
net.ipv4.conf.eth0.secure_redirects=0
net.ipv4.conf.default.secure_redirects=0

net.ipv4.conf.lo.send_redirects=0
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.eth0.send_redirects=0
net.ipv4.conf.default.send_redirects=0
5)      优化TCP协议栈
打开TCP SYN cookie选项，有助于保护服务器免受SyncFlood攻击。
net.ipv4.tcp_syncookies=1

打开TIME-WAIT套接字重用功能，对于存在大量连接的Web服务器非常有效。
net.ipv4.tcp_tw_recyle=1
net.ipv4.tcp_tw_reuse=1

减少处于FIN-WAIT-2连接状态的时间，使系统可以处理更多的连接。
net.ipv4.tcp_fin_timeout=30

减少TCP KeepAlive连接侦测的时间，使系统可以处理更多的连接。
net.ipv4.tcp_keepalive_time=1800

增加TCP SYN队列长度，使系统可以处理更多的并发连接。
net.ipv4.tcp_max_syn_backlog=8192
