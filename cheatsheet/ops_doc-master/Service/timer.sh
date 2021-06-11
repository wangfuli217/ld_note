settimeofday | gettimeofday
time         | stime
int adjtimex(struct timex *buf);

date(1),  time(1),  adjtimex(2),  alarm(2),  clock_gettime(2),  clock_nanosleep(2), getitimer(2), getrlimit(2),
getrusage(2), gettimeofday(2), nanosleep(2), stat(2), time(2),  timer_create(2),  timerfd_create(2),  times(2),
utime(2),  adjtime(3),  clock(3),  clock_getcpuclockid(3),  ctime(3), pthread_getcpuclockid(3), sleep(3), strf-
time(3), strptime(3), timeradd(3), usleep(3), rtc(4), hwclock(8)


date     命令
hwclock  命令
ntpdate  命令
ntpd     命令
uptime   命令
cron     命令


man(Real time and process time){ 实时和进程时间
1. 进程时间: 进程消耗CPU的时间总量；进程时间又可以分为用户态时间和内核态时间。
   time命令统计进程消耗的CPU时间；
   下面函数可以得到进程时间:
   clock_t times(struct tms *buf);
   int getrusage(int who, struct rusage *usage);
   clock_t clock(void);
}

man(The Hardware Clock){ 硬件设备时钟
1. 硬件时钟：多数计算机有电池供电的硬件时钟，在计算机启动的时候用来初始化计算机时间。
    rtc(4)                         int ioctl(fd, RTC_request, param); 函数
    hwclock [functions] [options]                                     命令
}

man(The Software Clock, HZ, and Jiffies){ 软件时钟，HZ 和 Jiffies
1. 软件时钟：用与系统调用相关的超时函数和对CPU使用量进行限制；
   select(2),      int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);
   poll(2),        int poll(struct pollfd *fds, nfds_t nfds, int timeout);
   epoll_wait(2)   int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);
   sigtimedwait(2) int sigtimedwait(const sigset_t *set, siginfo_t *info, const struct timespec *timeout);

   getrusage(2)    int getrusage(int who, struct rusage *usage);
   
2. 软件时钟的测量依赖内核中的jiffies变量，而jiffies变量依赖内核常量HZ
   2.4.x, HZ == 100; 0.01秒
   2.6.0, HZ == 1000; 0.001秒
   2.6.13,HZ == 可配置成100,250,1000; 0.01秒, 0.004秒, 0.001秒
   2.6.20,HZ == 300
3.  sysconf(_SC_CLK_TCK)
   times(2) 依赖USER_HZ。
}


man(High-Resolution Timers){ 高精度定时器
1. 自2.6.21以后，Linux内核通过CONFIG_HIGH_RES_TIMERS可以配置高精度定时器
通过 /proc/timer_list 和 clock_getres(2) 可以确认当前系统是否支持高精度定时器
高精度定时器使得sleep和超时耗时不再受内核jiffies限制

2. 当前支持的CPU包括x86, arm, and powerpc, among others

}

man(The Epoch){
1. 从1970-01-01 00:00:00 +0000 (UTC)开始的时间
   gettimeofday(2)
   time(2)
   settimeofday(2)
}

man(Broken-down time){ 分解时间
1. 系统中包含struct tm的分解时间函数
    year, month, day, hour, minute, secon
ctime(3), strftime(3), and strptime(3).
}

man(Sleeping and Setting Timers){ 睡眠和定时器超时
1. nanosleep(2), clock_nanosleep(2), and sleep(3).
2. alarm(2), getitimer(2), timerfd_create(2), and timer_create(2).
}

man(uptime){ 系统统计相关信息
int sysinfo(struct sysinfo *info);
}

man(ntp){ 基于UDP 端口号为123. 用于网络时间同步的协议RFC 5905 ; 通常可获得毫秒级的精度
0  1    4      7              15             23                        31
┌──────────────────────────────────────────────────────────────────────┐       
│LI│ VN │ Mode │    Stratum    │     Poll     │      Precision         │
├──────────────────────────────────────────────────────────────────────┤
│          Root Delay(根延时)  32                                      │
├──────────────────────────────────────────────────────────────────────┤
│          Root Dispersion(根差量)32                                   │
├──────────────────────────────────────────────────────────────────────┤       
│          Reference Identifier(参考标识符)32                          │
├──────────────────────────────────────────────────────────────────────┤       
│          Reference timestamp(参考时间戳)64                           │
├──────────────────────────────────────────────────────────────────────┤       
│          Originate timestamp(原始时间戳) 64                          │
├──────────────────────────────────────────────────────────────────────┤       
│          Receive timestamp(接收时间戳) 64                            │
├──────────────────────────────────────────────────────────────────────┤       
│          Transmite timestamp(传输时间戳) 64                          │
├──────────────────────────────────────────────────────────────────────┤       
│          Authenticator (认证符)96                                    │
├──────────────────────────────────────────────────────────────────────┤       
   
LI 闰秒标识器，占用2个bit
---|-------|----------------------
LI | Value | 含义
---|-------|----------------------
00 | 0     | 无预告
01 | 1     | 醉经一分钟有 61s
10 | 2     | 最近一分钟有 59s
11 | 3     | 警告状态(时钟未同步)
----------------------------------
VN 版本号，占用3个bits，表示NTP的版本号，现在为3
目前最新的版本是 4, 向下兼容指定于 RFC 1305 的版本 3.
Mode 模式，占用3个bits，表示模式
------|-------|-------------------
Mode  | Value | 含义
------|-------|-------------------
000   | 0     | 保留
001   | 1     | 主动对称模式
010   | 2     | 被动对称模式
011   | 3     | 客户端模式
100   | 4     | 服务器模式
101   | 5     | 广播或组播模式
110   | 6     | NTP控制报文
111   | 7     | 预留给内部使用
----------------------------------
    stratum(层)，占用8个bits
系统时钟的层数, 长度为 8 Bits, 取值范围 1~16, 定义时钟的准确度. 层数为 1 的时钟准确度最高,
准确度从 1 到 16 依次递减, 阶层的上限为15, 层数为 16的时钟处于未同步状态, 不能作为参考时钟.
    Poll 测试间隔，占用8个bits，表示连续信息之间的最大间隔
两个连续NTP报文之间的时间间隔, 用 2 的幂来表示, 比如值为 6 表示最小间隔为 2^6 = 64s.
    Precision 精度，占用8个bits，，表示本地时钟精度
用 2 的幂来表示, 比如 50Hz(20ms)或者60Hz(16.67ms) 可以表示成值 -5 (2^-5 = 0.03125s = 31.25ms).
    Root Delay根时延，占用8个bits，表示在主参考源之间往返的总共时延
本地到主参考时钟源的往返时间, 长度为 32 Bits, 有 15～16 位小数部分的无符号定点小数.
    Root Dispersion根离散，占用8个bits，表示在主参考源有关的名义错误
系统时钟相对于主参考时钟的最大误差, 长度为 32 Bits, 有 15～16 位小数部分的无符号定点小数.
    Reference Identifier参考时钟标识符，占用32个bits，用来标识特殊的参考源    
    参考时间戳，64bits时间戳，本地时钟被修改的最新时间。
系统时钟最后一次被设定或更新的时间, 长度为 64 Bits, 无符号定点数, 前 32 Bits 表示整数部分, 
后 32 Bits 表示小数部分, 理论分辨率 2^?32s.
    原始时间戳，客户端发送的时间，64bits。
NTP请求报文离开发送端时发送端的本地时间, 长度为 64 Bits.
    接受时间戳，服务端接受到的时间，64bits。
NTP请求报文到达接收端时接收端的本地时间, 长度为 64 Bits.
    传送时间戳，服务端送出应答的时间，64bits。
应答报文离开应答者时应答者的本地时间, 长度为 64 Bits.
    认证符(可选项)
验证信息, 长度为 96 Bits, (可选信息), 当实现了 NTP 认证模式时, 主要标识符和信息数字域
就包括已定义的信息认证代码 (MAC) 信息.
           135ms 137ms
           t1    t2
Server -|---/|--|\----|----------> time
        |  / |  | \   |
        | /  |  |  \  |
        |/   |  |   \ |
Client /|----|--|----\|----------> time
        t0            t4
      231ms          298ms
1.客户端和服务端都有一个时间轴，分别代表着各自系统的时间，当客户端想要同步服务端的时间时，
客户端会构造一个NTP协议包发送到NTP服务端，客户端会记下此时发送的时间t0
2.经过一段网络延时传输后，服务器在t1时刻收到数据包，经过一段时间处理后在t2时刻向客户端返回数据包，
再经过一段网络延时传输后客户端在t3时刻收到NTP服务器数据包。

特别声明，t0和t3是客户端时间系统的时间、t1和t2是NTP服务端时间系统的时间，它们是有区别的。
对于时间要求不那么精准设备，直接使用NTP服务器返回t2时间也没有太大影响。

但是作为一个标准的通信协议，它是精益求精且容不得过多误差的，于是必须计算上网络的传输延时。
客户端与服务端的时间系统的偏移定义为θ、网络的往返延迟定义为δ，基于此，可以对t2进行精确的修正，
已达到相关精度要求，它们的计算公式如下：
θ = ((t1 - t0) + (t2- t3))/2
δ = (t3 - t0) - (t2 - t1)
式中：
t0是请求数据包传输的客户端时间戳
t1是请求数据包回复的服务器时间戳
t2是响应数据包传输的服务器时间戳
t3是响应数据包回复的客户端时间戳
对此，我们只需将NTP服务端返回的时间t2加上网络延时δ的一半就可以了(t2+δ/2)。

ntpdate
由于 timedatectl 的存在，各发行版已经弃用了 ntpdate，默认不再进行安装。如果你安装了，
它会在系统启动的时候根据 Ubuntu 的 NTP 服务器来设置你电脑的时间。之后每当一个新的
网络接口启动时，它就会重新尝试同步时间 —— 在这期间只要其涵盖的时间差不是太大，它就会
慢慢偏移时间。该行为可以通过 -B/-b 开关来进行控制。
ntpdate ntp.ubuntu.com

ntpd
ntp 的守护进程 ntpd 会计算你的系统时钟的时间偏移量并且持续的进行调整，所以不会出现时间
差距较大的更正，比如说，不会导致不连续的日志。该进程只花费少量的进程资源和内存，但对于
现代的服务器来说实在是微不足道的了。
}
GMT：Greenwich Mean Time，格林尼治平均时。格林尼治标准时间是19世纪中叶大英帝国的基准时间，同时也是事实上的世界基准时间。
UTC：Universal Time Coordinated，环球通用协调时间。基本上UTC的本质强调的是比GMT更为精确的世界时间标准，在不需要精确到秒的情况通常也将GMT和UTC视作等同。
DST：Daylight Saving Time，指在夏天太阳升起的比较早时，将时钟拨快一小时以提早日光的使用;
CST：CST可以同时表示美国UT-6:00，澳大利亚UT+9:30，中国UT+8:00，古巴UT-4:00四个国家的标准时间;
Epoch：时间轴上特定的一个时间点，定义为从格林威治时间1970年01月01日00时00分00秒。记为1970年1月1日00:00:00 UTC。
UNIX时间戳：英文表示为Unix timestamp、Unix time或者POSIX time。是从Epoch开始所经过的秒数，不考虑闰秒。在大多数的UNIX系统中UNIX时间戳存储为32位，这样会引发2038年问题或Y2038。
Calendar Time：表示的意义同UNIX时间戳。
Broken-down Time：使用tm结构存储的时间,tm 数据结构将时间分别保存到代表年，月，日，时，分，秒等不同的变量中，不再是一个令人费解的64位整数。tm数据结构是各种自定义格式转换函数所需要的输入形式。
Real-Time：也称wall-clock，即我们人类自然感受的时间。
Virtual-Time：进程执行所占用的cpu时间(即站在进程的角度看时间)，如果在过去的一秒钟指定进程没有被调用，则virtual time为0s，real time为1s。
Prof-Time：系统在用户态和内核态所占用cpu时间的总和；
clock tick：时钟滴答，当PIT通道0的计数器减到0值时，它就在IRQ0上产生一次时钟中断，即一次时钟滴答。
jiffies：记录着从电脑开机到现在总共的"时钟中断"的次数。启动时内核将该变量初始化为0，此后每次时钟中断处理程序都会增加该变量的值。jiffies类型为无符号长整型(unsigned long)，其他任何类型存放它都不正确。
xtime：从cmos电路或rtc芯片中取得的时间，一般是从某一历史时刻开始到现在的时间；