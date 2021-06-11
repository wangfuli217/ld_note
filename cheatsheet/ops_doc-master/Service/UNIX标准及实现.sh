http://www.cnblogs.com/SmileLion/p/5863570.html          # 标准
https://blog.csdn.net/todd911/article/details/20484087   # 实例

unix(限制){
限制分为编译时限制和运行时限制
    编译时限制应该在头文件中进行定义，在头文件中有定义的限制就叫做编译时限制
    而运行时限制应该利用sysconf，pathconf，fpathconf函数进行确定
    
但是注意，如果一个运行时限制在一个系统中并不改变，择可以定义在头文件中
}
unix(选项){
3.1定义：如果我们编写可移植的应用程序，而这些程序可能会依赖于这些可选的功能，那么就需要一种方法判断实现是否支持一个给定的选项
3.2几种处理选项的方法
1>编译时选项定义在<unistd.h>中
2>与文件或目录无关的运行时选项用sysconf
3>与文件或目录有关的运行时选项通过调用pathconf或fpathconf函数来判断
3.3三种平台支持状态
1）如果符号常亮没有定义或者定义为-1，那么改平台并不支持该选项
2）如果符号常量的定义值大于0，那么改平台支持相应的选项
3）如果符号常量的定义值为0，则必须调用sysconf，pathconf，fpathconf来判断是否支持
}

sysconf(){
    当前计算机都是多核的，linux2.6提供了进程绑定cpu功能，将进程指定到某个core上执行，方便管理进程。
linux提供了sysconf系统调用可以获取系统的cpu个数和可用的cpu个数。
　　man一下sysconf，解释这个函数用来获取系统执行的配置信息。例如页大小、最大页数、cpu个数、打开句柄
的最大个数等等。详细说明可以参考man。
printf("The number of processors configured is :%ld\n",
        sysconf(_SC_NPROCESSORS_CONF));
    printf("The number of processors currently online (available) is :%ld\n",
        sysconf(_SC_NPROCESSORS_ONLN));
    printf ("The pagesize: %ld\n", sysconf(_SC_PAGESIZE));  
    printf ("The number of pages: %ld\n", sysconf(_SC_PHYS_PAGES));  
    printf ("The number of available pages: %ld\n", sysconf(_SC_AVPHYS_PAGES)); 
    printf ("The memory size: %lld MB\n", 
        (long long)sysconf(_SC_PAGESIZE) * (long long)sysconf(_SC_PHYS_PAGES) / ONE_MB );  
    printf ("The number of files max opened:: %ld\n", sysconf(_SC_OPEN_MAX));  
    printf("The number of ticks per second: %ld\n", sysconf(_SC_CLK_TCK));  
    printf ("The max length of host name: %ld\n", sysconf(_SC_HOST_NAME_MAX));  
    printf ("The max length of login name: %ld\n", sysconf(_SC_LOGIN_NAME_MAX));
}

POSIX标准定义的头文件<dirent.h> 目录项
<fcntl.h> 文件控制
<fnmatch.h> 文件名匹配类型
<glob.h> 路径名模式匹配类型
<grp.h> 组文件
<netdb.h> 网络数据库操作
<pwd.h> 口令文件
<regex.h> 正则表达式
<tar.h> TAR归档值
<termios.h> 终端I/O
<unistd.h> 符号常量
<utime.h> 文件时间
<wordexp.h> 字符扩展类型
 
--------------------------------------------------------------------------------
<arpa/inet.h> INTERNET定义
<net/if.h> 套接字本地接口
<netinet/in.h> INTERNET地址族
<netinet/tcp.h> 传输控制协议定义
 
--------------------------------------------------------------------------------
<sys/mman.h> 内存管理声明
<sys/select.h> Select函数
<sys/socket.h> 套接字借口
<sys/stat.h> 文件状态
<sys/times.h> 进程时间
<sys/types.h> 基本系统数据类型
<sys/un.h> UNIX域套接字定义
<sys/utsname.h> 系统名
<sys/wait.h> 进程控制
 
--------------------------------------------------------------------------------
POSIX定义的XSI扩展头文件<cpio.h> cpio归档值
<dlfcn.h> 动态链接
<fmtmsg.h> 消息显示结构
ftw.h> 文件树漫游
<iconv.h> 代码集转换使用程序
<langinfo.h> 语言信息常量
<libgen.h> 模式匹配函数定义
<monetary.h> 货币类型
<ndbm.h> 数据库操作
<nl_types.h> 消息类别
<poll.h> 轮询函数
<search.h> 搜索表
<strings.h> 字符串操作
<syslog.h> 系统出错日志记录
<ucontext.h> 用户上下文
<ulimit.h> 用户限制
<utmpx.h> 用户帐户数据库
 
--------------------------------------------------------------------------------
<sys/ipc.h> IPC(命名管道)
<sys/msg.h> 消息队列
<sys/resource.h> 资源操作
<sys/sem.h> 信号量
<sys/shm.h> 共享存储
<sys/statvfs.h> 文件系统信息
<sys/time.h> 时间类型
<sys/timeb.h> 附加的日期和时间定义
<sys/uio.h> 矢量I/O操作
 
--------------------------------------------------------------------------------
POSIX定义的可选头文件<aio.h> 异步I/O
<mqueue.h> 消息队列
<pthread.h> 线程
<sched.h> 执行调度
<semaphore.h> 信号量
<spawn.h> 实时spawn接口
<stropts.h> XSI STREAMS接口
<trace.h> 事件跟踪
