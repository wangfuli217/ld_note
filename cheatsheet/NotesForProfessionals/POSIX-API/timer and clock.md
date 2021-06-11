---
title: 闹钟、睡眠和时间函数
comments: true
---

# 计时单位

*	秒          m  second          Hz
*	毫秒        ms millisecond     kHz
*	微秒        us microsecond     mHz
*	纳秒        ns nanosecond      gHz

# 进程时间

*	时钟时间(墙上时钟时间wall clock time)：从进程从开始运行到结束，时钟走过的时间，这其中包含了进程在阻塞和等待状态的时间。
*	用户CPU时间：就是用户的进程获得了CPU资源以后，在CPU在用户态执行的时间。
*	系统CPU时间：用户进程获得了CPU资源以后，在CPU内核态的执行时间。

用户CPU时间和系统CPU时间两者统称CPU时间，墙上时钟是进程运行的时间总量，与调度有关

## 获取进程CPU时间的时钟ID

    int clock_getcpuclockid(pid_t pid, clockid_t *clock_id);

## 获取线程运行CPU，pthread_getcpuclockid

    int pthread_getcpuclockid(pthread_t thread, clockid_t *clock_id);

# Linux中关于时间的数据结构

## jiffies

内核用jiffies变量记录系统启动以来经过的时钟滴答数，它的声明如下：

    extern u64 __jiffy_data jiffies_64;
    extern unsigned long volatile __jiffy_data jiffies;

可见，在32位的系统上，jiffies是一个32位的无符号数，系统每过1/HZ秒，jiffies的值就会加1，最终该变量可能会溢出，所以内核同时又定义了一个64位的变量jiffies_64，链接的脚本保证jiffies变量和jiffies_64变量的内存地址是相同的，通常，我们可以直接访问jiffies变量，但是要获得jiffies_64变量，必须通过辅助函数get_jiffies_64来实现。jiffies是内核的低精度定时器的计时单位，所以内核配置的HZ数决定了低精度定时器的精度，如果HZ数被设定为1000，那么，低精度定时器（timer_list）的精度就是1ms=1/1000秒。因为jiffies变量可能存在溢出的问题，所以在用基于jiffies进行比较时，应该使用以下辅助宏来实现：

    time_after(a,b)
    time_before(a,b)
    time_after_eq(a,b)
    time_before_eq(a,b)
    time_in_range(a,b,c)

同时，内核还提供了一些辅助函数用于jiffies和毫秒以及纳秒之间的转换：

    unsigned int jiffies_to_msecs(const unsigned long j);
    unsigned int jiffies_to_usecs(const unsigned long j);
    unsigned long msecs_to_jiffies(const unsigned int m);
    unsigned long usecs_to_jiffies(const unsigned int u);

<!--more-->

## struct timeval

    struct timeval {
        __kernel_time_t     tv_sec;     /* seconds */
        __kernel_suseconds_t    tv_usec;    /* microseconds */
    };

## struct timespec

    struct timespec {
        __kernel_time_t tv_sec;         /* seconds */
        long        tv_nsec;        /* nanoseconds */
    };

同样地，内核也提供了一些辅助函数用于jiffies、timeval、timespec之间的转换：

    static inline int timespec_equal(const struct timespec *a, const struct timespec *b);
    static inline int timespec_compare(const struct timespec *lhs, const struct timespec *rhs);
    static inline int timeval_compare(const struct timeval *lhs, const struct timeval *rhs);
    extern unsigned long mktime(const unsigned int year, const unsigned int mon,
    const unsigned int day, const unsigned int hour,
    const unsigned int min, const unsigned int sec);
    extern void set_normalized_timespec(struct timespec *ts, time_t sec, s64 nsec);
    static inline struct timespec timespec_add(struct timespec lhs, struct timespec rhs);
    static inline struct timespec timespec_sub(struct timespec lhs, struct timespec rhs);
    static inline s64 timespec_to_ns(const struct timespec *ts);
    static inline s64 timeval_to_ns(const struct timeval *tv);
    extern struct timespec ns_to_timespec(const s64 nsec);
    extern struct timeval ns_to_timeval(const s64 nsec);
    static __always_inline void timespec_add_ns(struct timespec *a, u64 ns);
    unsigned long timespec_to_jiffies(const struct timespec *value);
    void jiffies_to_timespec(const unsigned long jiffies, struct timespec *value);
    unsigned long timeval_to_jiffies(const struct timeval *value);
    void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value);

timekeeper中的xtime字段用timespec作为时间单位。

## struct ktime

Linux的通用时间架构用ktime来表示时间，为了兼容32位和64位以及big-little endian系统，ktime结构被定义如下：

    union ktime {
    	s64 tv64;
    #if BITS_PER_LONG != 64 && !defined(CONFIG_KTIME_SCALAR)
    	struct {
    # ifdef __BIG_ENDIAN
    		s32 sec, nsec;
    # else
    		s32 nsec, sec;
    # endif
    	} tv;
    #endif
    };

64位的系统可以直接访问tv64字段，单位是纳秒，32位的系统则被拆分为两个字段：sec和nsec，并且照顾了大小端的不同。高精度定时器通常用ktime作为计时单位。下面是一些辅助函数用于计算和转换：

    ktime_t ktime_set(const long secs, const unsigned long nsecs);
    ktime_t ktime_sub(const ktime_t lhs, const ktime_t rhs);
    ktime_t ktime_add(const ktime_t add1, const ktime_t add2);
    ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
    ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec);
    ktime_t timespec_to_ktime(const struct timespec ts);
    ktime_t timeval_to_ktime(const struct timeval tv);
    struct timespec ktime_to_timespec(const ktime_t kt);
    struct timeval ktime_to_timeval(const ktime_t kt);
    s64 ktime_to_ns(const ktime_t kt);
    int ktime_equal(const ktime_t cmp1, const ktime_t cmp2);
    s64 ktime_to_us(const ktime_t kt);
    s64 ktime_to_ms(const ktime_t kt);
    ktime_t ns_to_ktime(u64 ns);

## time_t

    #ifndef __TIME_T
    #define __TIME_T     /* 避免重复定义 time_t */
    typedef long     time_t;    /* 时间值time_t 为长整型的别名*/
    #endif

## tm

    struct tm
    {
    	   int tm_sec;                   /* Seconds.     [0-60] (1 leap second) */
    	   int tm_min;                   /* Minutes.     [0-59] */
    	   int tm_hour;                  /* Hours.       [0-23] */
    	   int tm_mday;                  /* Day.         [1-31] */
    	   int tm_mon;                   /* Month.       [0-11] */
    	   int tm_year;                  /* Year - 1900.  */
    	   int tm_wday;                  /* Day of week. [0-6] */
    	   int tm_yday;                  /* Days in year.[0-365] */
    	   int tm_isdst;                 /* DST.         [-1/0/1]*/

    #ifdef  __USE_BSD
    	    long int tm_gmtoff;           /* Seconds east of UTC.  */
    	    __const char *tm_zone;        /* Timezone abbreviation.  */
    #else
    	    long int __tm_gmtoff;         /* Seconds east of UTC.  */
    	    __const char *__tm_zone;      /* Timezone abbreviation.  */
    #endif
    };

## timezone

    struct timezone {
    int tz_minuteswest;     /* minutes west of Greenwich */
        int tz_dsttime;         /* type of DST correction */
    };

## timeb

    struct timeb {
    time_t         time;
        unsigned short millitm;
        short          timezone;
        short          dstflag;
    };

## useconds_t

    typedef unsigned int useconds_t

## itimerval

    struct itimerval {
    	struct timeval it_interval;
    	struct timeval it_value;
    };

## itimerspec

    struct itimerspec {
    	struct timespec it_interval;  /* Interval for periodic timer */
    	struct timespec it_value;     /* Initial expiration */
    };

## utimbuf

    struct utimbuf {
    	time_t actime;       /* access time */
    	time_t modtime;      /* modification time */
    };

## 小结

linux的通用时间架构用ktime来表示时间，64位的系统可以直接访问tv64字段，单位是纳秒，32位的系统则被拆分为两个字段，sec和nsec，并且照顾了大小端的不同。高精度定时器通常用ktime作为计时单位。

几个数据结构差别在于jiffies是时钟滴答数，timval精度只能到微秒，timespec精度到纳秒，jiffies和ktime仅用于内核当中。

# 内核管理的时钟

内核管理着多种时间，它们分别是：

*	RTC时间 在PC中，RTC时间又叫CMOS时间，它通常由一个专门的计时硬件来实现，软件可以读取该硬件来获得年月日、时分秒等时间信息，大多数情况下只能达到毫秒级别的精度，
*	xtime ：墙上时间，只是RTC时间的精度通常比较低，大多数情况下只能达到毫秒级别的精度，如果是使用外部的RTC芯片，访问速度也比较慢，为此，内核维护了另外一个wall time时间：xtime，xtime记录的是自1970年1月1日24时到当前时刻所经历的纳秒数。
*	monotonic time单调时间，该时间自系统开机后就一直单调地增加，它不像xtime可以因用户的调整时间而产生跳变，不过该时间不计算系统休眠的时间，也就是说，系统休眠时，monotoic时间不会递增。
*	raw monotonic time该时间与monotonic时间类似，也是单调递增的时间，唯一的不同是：raw monotonic time“更纯净”，他不会受到NTP时间调整的影响，它代表着系统独立时钟硬件对时间的统计。
*	boot time：总启动时间，与monotonic时间相同，不过会累加上系统休眠的时间，它代表着系统上电后的总时间

时间种类	| 精度	|访问速度	|累计休眠时间	| 受NTP调整的影响
---------|-------|--------|------------|--------------
RTC	     |低	    | 慢	     |   Yes     |    Yes
xtime	    | 高	   |   快	 |  Yes	     |   Yes
monotonic	|  高	 |   快	 |   No      |	Yes
raw       | monotonic |	高	 | 快	|No  |	No
boot      | time	 |  高	  |   快   |Yes|	  Yes

如果你用linux的date命令获取当前时间，内核会读取当前的clock source,时钟源是内核计时的基础，系统启动时，内核通过硬件RTC获得当前时间，在这以后，在大多数情况下，内核通过选定的时钟源更新实时时间信息（墙上时间），而不再读取RTC的时间

# Linux时间管理架构

## 架构

Linux时间子系统存在clock-source device，clock-event device两种时钟设备，，这两种设备又分别有低精度和高精度两种底层设备。其中时钟源本身不会产生中断，要获得时钟源的当前计数，只能通过主动调用它的read回调函数来获得当前技术值，注意这里只获得计数值，也就是所谓的cycle, time、monotonic time、raw time都是基于该时钟源进行计时操作，好像都是给系统提供时钟的设备，实际上，clocksource不能被编程，没有产生事件的能力，它主要被用于timekeeper来实现对真实时间进行精确的统计，而clock_event_device则是可编程的，它可以工作在周期触发或单次触发模式，系统可以对它进行编程，以确定下一次事件触发的时间，clock_event_device主要用于实现普通定时器和高精度定时器，同时也用于产生tick事件，供给进程调度子系统使用。

时钟触发两种模式：

*	周期触发：周期性的中断内核，由于会周期性的中断内核，因此系统无法长时间休眠，导致耗电大
*	单触发模式：单触发模式应该每次触发后都需要重新编程指定下一次事件到期事件

## 低精度和高精度计时器基本原理

低分辨率定时器使用5个链表数组来组织timer_list结构，形成了著名的时间轮概念，系统使用了分组来管理多个定时器事件，根据即将到达的时间来分组，避免同时处理所有定时器，虽然大部分时间里，时间轮可以实现O(1)时间复杂度，但是当有进位发生时，不可预测的O(N)定时器级联迁移时间，这对于低分辨率定时器来说问题不大，可是它大大地影响了定时器的精度；低分辨率定时器几乎是为“超时”而设计的，并为此对它进行了大量的优化，对于这些以“超时”为目的而使用定时器，它们大多数期望在超时到来之前获得正确的结果，然后删除定时器，精确时间并不是它们主要的目的，例如网络通信、设备IO等等。
高精度定时器，处于效率和上锁的考虑，每个cpu有一个hrtimer_cpu_base结构。hrtimer_cpu_base结构管理着3种不同的时间基准系统的hrtimer，分别是：实时时间，启动时间和单调时间；每种时间基准系统通过它的active字段（timerqueue_head结构指针），指向它们各自的红黑树。红黑树上，按到期时间进行排序，最先到期的hrtimer位于最左下的节点，并被记录在active.next字段中；3种时间基准的最先到期时间可能不同，所以，它们之中最先到期的时间被记录在hrtimer_cpu_base的expires_next字段中。它在标准红黑树节点rb_node的基础上增加了expires字段，该字段和hrtimer中的_softexpires字段一起，设定了hrtimer的到期时间的一个范围，hrtimer可以在hrtimer._softexpires至timerqueue_node.expires之间的任何时刻到期，我们也称timerqueue_node.expires为硬过期时间(hard)，意思很明显：到了此时刻，定时器一定会到期，有了这个范围可以选择，定时器系统可以让范围接近的多个定时器在同一时刻同时到期，这种设计可以降低进程频繁地被hrtimer进行唤醒。

Linux中的时钟事件都是由一个周期时钟提供，不管系统中的clock_event_device是工作于周期触发模式，还是工作于单触发模式，也不管定时器系统是工作于低分辨率模式，还是高精度模式，内核都竭尽所能，用不同的方式提供周期时钟，以产生定期的tick事件，tick事件或者用于全局的时间管理（jiffies和时间的更新），或者用于本地cpu的进程统计、时间轮定时器框架等等。周期性时钟虽然简单有效，但是也带来了一些缺点，尤其在系统的功耗上，因为就算系统目前无事可做，也必须定期地发出时钟事件，激活系统。为此，内核的开发者提出了动态时钟这一概念，我们可以通过内核的配置项CONFIG_NO_HZ来激活特性。有时候这一特性也被叫做tickless，不过还是把它称呼为动态时钟比较合适，因为并不是真的没有tick事件了，只是在系统无事所做的idle阶段，我们可以通过停止周期时钟来达到降低系统功耗的目的，只要有进程处于活动状态，时钟事件依然会被周期性地发出。

没有动态时钟的低分辨率系统，总是用周期时钟。这时不会支持单触发模式。启用了动态时钟的低分辨率系统，将以单触发模式使用时钟设备。高分辨率系统总是用单触发模式，无论是否启用了动态时钟特性，当系统切换到高分辨率模式时，周期性的tick功能就被关闭了，此时需要使用高分辨率定时器进行周期性时钟仿真，只有在有任务需要实际执行时，才激活周期时钟，否则就禁用周期时钟的技术。作法是如果需要调度idle来运行，禁用周期时钟；直到下一个定时器到期为止或者有中断发生时为止再启用周期时钟。单触发时钟是实现动态时钟的前提条件，因为动态时钟的关键特性是可以根据需要来停止或重启时钟，而纯粹的周期时钟不适用于这种场景。在某些情况下，为了节省电力，系统中的时钟设备可能进入休眠状态，即不工作。这时候仍需要有一个时钟设备来运行以提供一些基本的时钟功能，比如需要时唤醒其它时钟设备，这个设备称为广播时钟设备。

对于SMP系统，内核区分下面两种时钟：

*	全局时钟：负责提供周期时钟，主要用于更新jiffies的值（do_timer）。记录在tick_do_timer_cpu变量中
每个CPU一个的本地时钟：用来进行进程统计（update_process_times）、实现高分辨率定时器、进程度量（profile_tick）。
*	全局时钟是由一个明确选择的局部时钟担任的。高分辨率定时器只能在每个CPU都提供了本地时钟源的系统上实现。

## 时间子系统启动流程

现在可以系统的介绍内核时钟子系统的初始化过程。系统刚上电时，需要注册 IRQ0 时钟中断，完成时钟源设备，时钟事件设备，tick device 等初始化操作并选择合适的工作模式。由于刚启动时没有特别重要的任务要做，因此默认是进入低精度 + 周期 tick 的工作模式，之后会根据硬件的配置（如硬件上是否支持 HPET 等高精度 timer）和软件的配置（如是否通过命令行参数或者内核配置使能了高精度 timer 等特性）进行切换。在一个支持 hrtimer 高精度模式并使能了 dynamic tick 的系统中，第一次发生 IRQ0 的软中断时 hrtimer 就会进行从低精度到高精度的切换，然后再进一步切换到 NOHZ 模式。IRQ0 为系统的时钟中断，使用全局的时钟事件设备（global_clock_event）来处理的。可以通过查看 /proc/timer_list 来显示系统当前配置的所有时钟的详细情况，譬如当前系统活动的时钟源设备，时钟事件设备，tick device 等。也可以通过查看 /proc/timer_stats 来查看当前系统中所有正在使用的 timer 的统计信息。包括所有正在使用 timer 的进程，启动 / 停止 timer 的函数，timer 使用的频率等信息。内核需要配置 CONFIG_TIMER_STATS=y，而且在系统启动时这个功能是关闭的，需要通过如下命令激活

    "echo 1 >/proc/timer_stats"

# 定时器

## alarm， ualarm

    unsigned int alarm(unsigned int seconds);

当计时器超时时，向进程发送SIGALARM信号。如果不捕捉或不忽略此信号，则其默认动作是终止调用该alarm函数的进程，一个进程只能有一个闹钟，之前已经设置闹钟，则返回剩余时间，否则返回0，出错返回-1。参数为0取消之前设置的时钟。

    useconds_t ualarm(useconds_t usecs, useconds_t interval);

如果interval参数不为0，则每隔interval时间产生SIGALARM信号，被信号中断时，将error设置为EINTR；任意参数大于1000000，将视为出错，置为EINVAL，其它情况和alarm相同，MT, obsolete，微秒，对该函数的调用会在真实时间(real time)seconds秒之后将SIGALRM信号。

### 例子

    #include "apue.h"

    static void	sig_alrm(int);

    int
    main(void)
    {
    	int		n;
    	char	line[MAXLINE];

    	if (signal(SIGALRM, sig_alrm) == SIG_ERR)
    		err_sys("signal(SIGALRM) error");

    	alarm(10);
    	if ((n = read(STDIN_FILENO, line, MAXLINE)) < 0)
    		err_sys("read error");
    	alarm(0);

    	write(STDOUT_FILENO, line, n);
    	exit(0);
    }

    static void
    sig_alrm(int signo)
    {
    	/* nothing to do, just return to interrupt the read */
    }

    #include "apue.h"
    #include <setjmp.h>

    static void		sig_alrm(int);
    static jmp_buf	env_alrm;

    int
    main(void)
    {
    	int		n;
    	char	line[MAXLINE];

    	if (signal(SIGALRM, sig_alrm) == SIG_ERR)
    		err_sys("signal(SIGALRM) error");
    	if (setjmp(env_alrm) != 0)
    		err_quit("read timeout");

    	alarm(10);
    	if ((n = read(STDIN_FILENO, line, MAXLINE)) < 0)
    		err_sys("read error");
    	alarm(0);

    	write(STDOUT_FILENO, line, n);
    	exit(0);
    }

    static void
    sig_alrm(int signo)
    {
    	longjmp(env_alrm, 1);
    }

存在与其它信号处理程序交互问题，可以使用select、poll、epoll

## setitimer，getitimer

    int setitimer(int which, const struct itimerval *value, struct itimerval *ovalue);
    int getitimer(int which, struct itimerval *curr_value);

which为定时器类型，setitimer支持3种类型的定时器：

*	ITIMER_REAL: 以系统真实的时间来计算，它送出SIGALRM信号。
*	ITIMER_VIRTUAL: -以该进程在用户态下花费的时间来计算，它送出SIGVTALRM信号。
*	ITIMER_PROF: 以该进程在用户态下和内核态下所费的时间来计算，它送出SIGPROF信号。

第二个参数是结构itimerval的一个实例；第三个参数可不做处理。

setitimer调用成功返回0，否则返回-1，errno被设为以下的某个值。

*	EFAULT：value或ovalue是不有效的指针；
*	EINVAL：其值不是ITIMER_REAL，ITIMER_VIRTUAL 或 ITIMER_PROF之一

value.it_value指定间隔时间，同时指定 value.it_interval，则超时后，系统会重新初始化it_value为it_interval，实现重复定时；两者都清零，则会清除定时器。ovalue用来保存上一个定时器的值，常设为NULL。

如果是以setitimer提供的定时器来休眠，只需阻塞等待定时器信号就可以了。

## alarm和setitimer需要注意地方

*	alarm，setitimer共用同一个计时器，两者混用将相互影响。
*	alarm，setitimer对于fork后都被清除，但是execve不会。
*	sleep的实现可能用到SIGALRM，因此不要混用sleep和alarm。
*	alarm可能被信号中断返回，但是setitimer要直到超时才返回。

## POSIX Timer

间隔定时器 setitimer 有一些重要的缺点，POSIX Timer 对 setitimer 进行了增强，克服了 setitimer 的诸多问题：

*	首先，一个进程同一时刻只能有一个 timer。假如应用需要同时维护多个 Interval 不同的计时器，必须自己写代码来维护。这非常不方便。使用 POSIX Timer，一个进程可以创建任意多个 Timer。
*	setitmer 计时器时间到达时，只能使用信号方式通知使用 timer 的进程，而 POSIX timer 可以有多种通知方式，比如信号，或者启动线程。
*	使用 setitimer 时，通知信号的类别不能改变：SIGALARM，SIGPROF 等，而这些都是传统信号（1-31），而不是实时信号，因此有 timer overrun 的问题；而 POSIX Timer 则可以使用实时信号。

### timer_create, timer_delete, timer_settime, timer_gettime, timer_getoverrun

    int timer_create(clockid_t clockid, struct sigevent *sevp, timer_t *timerid);
    int timer_delete(timer_t timerid);
    int timer_settime(timer_t timerid, int flags, const struct itimerspec *new_value, struct itimerspec *old_value);
    int timer_gettime(timer_t timerid, struct itimerspec *curr_value);
    int timer_getoverrun(timer_t timerid);

Clock ID	描述

>CLOCK_REALTIME	Settable system-wide real-time clock；
>
>CLOCK_MONOTONIC	Nonsettable monotonic clock
>
>CLOCK_PROCESS_CPUTIME_ID	Per-process CPU-time clock
>
>CLOCK_THREAD_CPUTIME_ID	Per-thread CPU-time clock
>
>CLOCK_BOOTTIME 	和单调时间一样，包括挂起时间
>
>CLOCK_REALTIME_ALARM 	进程如果被挂起，会被唤醒
>
>CLOCK_BOOTTIME_ALARM 	进程如果被挂起，会被唤醒

通知方式	描述

>SIGEV_NONE	定时器到期时不产生通知。
>
>SIGEV_SIGNAL	定时器到期时将给进程投递一个信号，sigev_signo可以用来指定使用什么信号。
>
>SIGEV_THREAD	定时器到期时将启动新的线程进行需要的处理
>
>SIGEV_THREAD_ID（仅Linux)	定时器到期时将向指定线程发送信号。

*	EAGAIN 内核分配timer数据结构临时错误
*	EINVAL clock ID，通知方式不正确
*	ENOMEM 不能分配内存

定时器不会被继承，但是并且execve也不会删除这些定时器。

### 内核定时器函数

***add_timer， mod_timer， del_timer， add_timer_on， mod_timer_pending， mod_timer_pinned，set_timer_slack， del_timer_syncinit_timers，init_timer， del_timer_sync，del_timer***

# 睡眠函数

## pause

    int pause(void);

## sleep

    unsigned int sleep(unsigned int seconds);

此函数使调用进程被挂起，直到满足以下条件之一：

*	已经过了seconds所指定的墙上时钟时间，
*	调用进程捕捉到一个信号并从信号处理程序返回，当由于捕捉到某个信号sleep提前返回时，返剩余值。

MT，使用longjmp从信号处理函数返回或者改变SIGALARM在sleeping期间的处理方式，都会导致未定义行为。sleep可能实现可能使用了SIGALARM，因此不要和alarm混用，如果同时使用函数alarm与sleep，二者可能会相互影响，而POSIX.1标准对于这些影响并没有相关要求。举例来说，如果我们执行函数sleep(10)，等待3秒钟以后，在执行sleep(5),那么会发生什么呢？sleep函数将在5秒钟后返回(假设其他信号并没有在这段时间内被捕获到)，但是在2秒钟以后是否会产生信号SIGALRM呢?这一细节与实现有关。

### alarm实现sleep

使用alarm实现sleep，可能导致sleep和alarm相互影响，Linux中sleep由nanosleep函数实现，因此和alarm函数不冲突。

    #include	<signal.h>
    #include	<unistd.h>

    static void
    sig_alrm(int signo)
    {
    	/* nothing to do, just return to wake up the pause */
    }

    unsigned int
    sleep1(unsigned int seconds)
    {
    	if (signal(SIGALRM, sig_alrm) == SIG_ERR)
    		return(seconds);
    	alarm(seconds);		/* start the timer */
    	pause();			/* next caught signal wakes us up */
    	return(alarm(0));	/* turn off timer, return unslept time */
    }

### setjmp, longjmp， alarm实现sleep

在调用sleep1前已经设置闹钟，因此需要先检查alarm返回值

修改了SIGALRM处理方式，因此需要保存原先SIGALRM处理方式。返回前恢复原先的处理方式。

在一个繁忙系统中，alarm可能在pause调用前超时，导致进程永远被挂起。

    #include	<setjmp.h>
    #include	<signal.h>
    #include	<unistd.h>

    static jmp_buf	env_alrm;

    static void
    sig_alrm(int signo)
    {
    	longjmp(env_alrm, 1);
    }

    unsigned int
    sleep2(unsigned int seconds)
    {
    	if (signal(SIGALRM, sig_alrm) == SIG_ERR)
    		return(seconds);
    	if (setjmp(env_alrm) == 0) {
    		alarm(seconds);		/* start the timer */
    		pause();			/* next caught signal wakes us up */
    	}
    	return(alarm(0));		/* turn off timer, return unslept time */
    }

这个实现中，即使pause从未执行，发送SIGLARM时，sleep2函数也会返回。但是SIGALRM中断了某个其他信号处理函数A，而sig_alrm调用longjmp返回，将导致A提前终止。如下

    #include "apue.h"

    unsigned int	sleep2(unsigned int);
    static void		sig_int(int);

    int
    main(void)
    {
      unsigned int	unslept;

      if (signal(SIGINT, sig_int) == SIG_ERR)
        err_sys("signal(SIGINT) error");
      unslept = sleep2(5);
      printf("sleep2 returned: %u\n", unslept);
      exit(0);
    }

    static void
    sig_int(int signo)
    {
      int				i, j;
      volatile int	k;

      /*
       * Tune these loops to run for more than 5 seconds
       * on whatever system this test program is run.
       */
      printf("\nsig_int starting\n");
      for (i = 0; i < 300000; i++)
        for (j = 0; j < 4000; j++)
          k += i * j;
      printf("sig_int finished\n");
    }

    #include "apue.h"

    static void	sig_alrm(int);

    int
    main(void)
    {
      int		n;
      char	line[MAXLINE];

      if (signal(SIGALRM, sig_alrm) == SIG_ERR)
        err_sys("signal(SIGALRM) error");

      alarm(10);
      if ((n = read(STDIN_FILENO, line, MAXLINE)) < 0)
        err_sys("read error");
      alarm(0);

      write(STDOUT_FILENO, line, n);
      exit(0);
    }

    static void
    sig_alrm(int signo)
    {
      /* nothing to do, just return to interrupt the read */
    }

alarm和read之间有竞争条件，如果内核在两个函数调用之间使进程阻塞，并且阻塞时间超过闹钟时间，则read可能永远阻塞

read是自重启的，因此SIGALRM返回时，read并不被中断。要想系统调用不自动重启，调用sigaction函数时sa_flags字段置为SA_INTERRUPT

    #include "apue.h"
    #include <setjmp.h>

    static void		sig_alrm(int);
    static jmp_buf	env_alrm;

    int
    main(void)
    {
    	int		n;
    	char	line[MAXLINE];

    	if (signal(SIGALRM, sig_alrm) == SIG_ERR)
    		err_sys("signal(SIGALRM) error");
    	if (setjmp(env_alrm) != 0)
    		err_quit("read timeout");

    	alarm(10);
    	if ((n = read(STDIN_FILENO, line, MAXLINE)) < 0)
    		err_sys("read error");
    	alarm(0);

    	write(STDOUT_FILENO, line, n);
    	exit(0);
    }

    static void
    sig_alrm(int signo)
    {
    	longjmp(env_alrm, 1);
    }

这个实现不管系统调用是否重新自启动，都能正常工作，但是存在与其它信号程序交互问题，即SIGALRM中断了另一个信号A处理函数，而sig_alrm调用longjmp将导致信号A处理函数提前终止。

### sleep 3

    sleep(unsigned int seconds)
    {
    	struct sigaction newact, oldact;
    	sigset_t newmask, oldmask, suspmask;
    	unsigned int unslept;
    	/* set our handler, save previous information */
    	newact.sa_handler = sig_alrm;
    	sigemptyset(&newact.sa_mask);
    	newact.sa_flags = 0;
    	sigaction(SIGALRM, &newact, &oldact);
    	/* block SIGALRM and save current signal mask */
    	sigemptyset(&newmask);
    	sigaddset(&newmask, SIGALRM);
    	sigprocmask(SIG_BLOCK, &newmask, &oldmask);
    	alarm(seconds);
    	suspmask = oldmask;
    	/* make sure SIGALRM isn’t blocked */
    	sigdelset(&suspmask, SIGALRM);
    	/* wait for any signal to be caught */
    	sigsuspend(&suspmask);
    	/* some signal has been caught, SIGALRM is now blocked */
    	unslept = alarm(0);
    	/* reset previous action */
    	sigaction(SIGALRM, &oldact, NULL);
    	/* reset signal mask, which unblocks SIGALRM */
    	sigprocmask(SIG_SETMASK, &oldmask, NULL);
    	return(unslept);
    }

不存在竞争条件，但是和alarm设置的闹钟有相互作用

## usleep

    int usleep(useconds_t usec);

微秒，MT，过时，成功0，-1如果出错。

*	EINTR, 被信号中断置。
*	EINVAL参数大于1000000置。

## nanosleep

    int nanosleep(const struct timespec *req, struct timespec *rem);

参数中nanoseconds字段的范围在0到999999999间。休眠达到要求时间，返回0，出错返回-1，从用户拷贝信息出错置EFAULT，被信号中断时，剩余时间会写入rem，可以再次调用nanosleep。nanosleep被信号中断，再次调用nanosleep时，会有时间流逝，因此时间上可能不准确，可以使用clock_nanosleep的绝对时间来避免。因为函数nanosleep并不涉及任何信号的产生，我们可以放心大胆地使用它而不用担心与其他函数相互影响。有些系统的sleep是又nanosleep实现的，不会产生信号交互。

*	EFAULT:从用户空间拷贝信息出错。
*	EINTR:被信号中断返回。
*	EINVAL: tv_nsec字段不在0到999999999区间，或者是负的

## clock_nanosleep

    int clock_nanosleep(clockid_t clock_id, int flags, const struct timespec *request, struct timespec *remain);

休眠达到要求时间，返回0，否则返回错误码。clock_nanosleep可以使用相对于特定时钟

*	CLOCK_REALTIME   使用clock_settime会使用新的时间。
*	CLOCK_MONOTONIC
*	CLOCK_PROCESS_CPUTIME_ID
  Flags为0相对时间，1（TIMER_ABSTIME）位绝对时间。clock_nanosleep被信号中断不会自动重启，即使sigaction使用了SA_RESTART标志。
*	EFAULT request or remain地址错误.
*	EINTR  被信号中断.
*	EINVAL  tv_nsec字段值不在0到999999999或为负值。
*	EINVAL clock_id 非法，比如使用了CLOCK_THREAD_CPUTIME_ID。

## 内核忙等函数

    void ndelay(unsigned long nsecs);         纳秒级：1/10^-10
    void udelay(unsigned long usecs);         微秒级: 1/10^-6
    void mdelay(unsigned long msecs);         毫秒级：1/10^-3

## msleep

    unsigned long msleep_interruptible(unsigned int msecs)

这些函数只在内核使用。

# 时间函数

## clock_getres, clock_gettime, clock_settime墙上时间

    int clock_getres(clockid_t clk_id, struct timespec *res);//获取clk_id的时间精度
    int clock_gettime(clockid_t clk_id, struct timespec *tp);返回当前时间
    int clock_settime(clockid_t clk_id, const struct timespec *tp);修改指定时钟时间

*	EFAULT tp指向非法地址
*	EINVAL 不支持的clk_id
*	EPERM clock_settime没有权限

MT，纳秒级别。

clk_id；

    CLOCK_REALTIME	系统实时时间，从Epoch计时，受用户更改以及adjtime和NTP影响
    CLOCK_REALTIME_COARSE	系统实时时间，有更快的获取速度，更低一些的精确度。
    CLOCK_MONOTONIC	从系统启动这一刻开始计时，即使系统时间被用户改变，也不受影响。系统休眠时不会计时。受adjtime和NTP影响。
    CLOCK_MONOTONIC_COARSE	有更快的获取速度和更低一些的精确度。受NTP影响。
    CLOCK_MONOTONIC_RAW	系统开启时计时，但不受NTP影响，受adjtime影响
    CLOCK_BOOTTIME	从系统启动这一刻开始计时，包括休眠时间，受到settimeofday的影响。
    CLOCK_PROCESS_CPUTIME_ID	本进程开始到此刻调用的时间。
    CLOCK_THREAD_CPUTIME_ID	本线程开始到此刻调用的时间

    syscall(SYS_clock_gettime, CLOCK_MONOTONIC_RAW, &monotonic_time)

## gettimeofday,settimeofday墙上时间

    int gettimeofday(struct timeval *tv, struct timezone *tz);
    int settimeofday(const struct timeval *tv, const struct timezone *tz);设置系统时间

返回从epoch以来的时间，精度到微秒microsecond，gettimeofday返回的时间可能和系统时间不一致，假如手动修改系统时间。

*	EFAULT tv或tz地址非法
*	EINVAL timezone不正确
*	EPERM settimeofday没有权限

## stime

int stime(const time_t *t);

## 调整系统时间，adjtime

    int adjtime(const struct timeval *delta, struct timeval *olddelta);

MT，时间值delta来微调系统时间， 若delta为负，时钟将慢走直到较正结束；若为正，时钟将走快。若之前的adjtime调用没有完成，则用olddelta返回。

*	EINVAL delta超出允许范围
*	EPERM 没有足够权限

设定系统时间

## 调整内核时间，adjtimex，ntp_adjtime

    struct timex {
        int  modes;      /* Mode selector */
        long offset;     /* Time offset; nanoseconds, if STA_NANO
                            status flag is set, otherwise
                            microseconds */
        long freq;       /* Frequency offset; see NOTES for units */
        long maxerror;   /* Maximum error (microseconds) */
        long esterror;   /* Estimated error (microseconds) */
        int  status;     /* Clock command/status */
        long constant;   /* PLL (phase-locked loop) time constant */
        long precision;  /* Clock precision
                            (microseconds, read-only) */
        long tolerance;  /* Clock frequency tolerance (read-only);
                            see NOTES for units */
        struct timeval time;
                         /* Current time (read-only, except for
                            ADJ_SETOFFSET); upon return, time.tv_usec
                            contains nanoseconds, if STA_NANO status
                            flag is set, otherwise microseconds */
        long tick;       /* Microseconds between clock ticks */
        long ppsfreq;    /* PPS (pulse per second) frequency
                            (read-only); see NOTES for units */
        long jitter;     /* PPS jitter (read-only); nanoseconds, if
                            STA_NANO status flag is set, otherwise
                            microseconds */
        int  shift;      /* PPS interval duration
                            (seconds, read-only) */
        long stabil;     /* PPS stability (read-only);
                            see NOTES for units */
        long jitcnt;     /* PPS count of jitter limit exceeded
                            events (read-only) */
        long calcnt;     /* PPS count of calibration intervals
                            (read-only) */
        long errcnt;     /* PPS count of calibration errors
                            (read-only) */
        long stbcnt;     /* PPS count of stability limit exceeded
                            events (read-only) */
        int tai;         /* TAI offset, as set by previous ADJ_TAI
                            operation (seconds, read-only,
                            since Linux 2.6.26) */
        /* Further padding bytes to allow for future expansion */
    };

    #include <sys/timex.h>
    int adjtimex(struct timex *buf);
    int ntp_adjtime(struct timex *buf);

## time获取墙上时间tick

    time_t time(time_t *tloc);

返回自epoch以来的秒数，如果tloc有效，返回值存在tloc。出错返回-1

*	EFAULT如果tloc地址非法，
*	EOVERFLOW 超出范围 ，C库函数中的time函数会引发SIGSEGV信号

## 从NTP获取时间

    struct ntptimeval {
        struct timeval time;        /* Current time */
        long int maxerror;          /* Maximum error */
        long int esterror;          /* Estimated error */
        long int tai;               /* TAI offset */

        /* Further padding bytes allowing for future expansion */
    };
    #include <sys/timex.h>
    int ntp_gettime(struct ntptimeval *ntv);
    int ntp_gettimex(struct ntptimeval *ntv);
    int ntp_adjtime(struct timex *buf);

## times获取CPU时间

    clock_t times(struct tms *buf);

返回进程用户时间和进程系统时间，返回的是clock_t即tick，若调用sleep，或者被调度的时间不会计算在内，相对于clock函数，能够区分用户态和内核态时间。

EFAULT tms不在用户空间地址范围

## clock获取CPU时间

    clock_t clock(void);

返回进程的CPU时间，MT。

## ftime获取墙上时间

    int ftime(struct timeb *tp);

从epoch以来的毫秒数， MT 这个函数应该避免使用。


## 时间格式化和转化函数

    char *asctime(const struct tm *tm); 将日期转换成字符串
    char *asctime_r(const struct tm *tm, char *buf);

    char *ctime(const time_t *timep); 将秒数转换成字符串
    char *ctime_r(const time_t *timep, char *buf);

    struct tm *gmtime(const time_t *timep); 是把日期和时间转换为格林威治(GMT)时间的函数
    struct tm *gmtime_r(const time_t *timep, struct tm *result);

    struct tm *localtime(const time_t *timep);转成当地时间
    struct tm *localtime_r(const time_t *timep, struct tm *result);

    time_t mktime(struct tm *tm); 将时间结构数据转换成time_t

    time_t timelocal(struct tm *tm);
    time_t timegm(struct tm *tm);

asctime、asctime_r、ctime、 ctime_r过时, 应该使用strftime

*	EOVERFLOW 结果不能被重新表示

## strftime时间转化函数

    size_t strftime(char *s, size_t max, const char *format, const struct tm *tm);

使用了环境变量TZ和LC_TIME，MT

## 字符串表示的时间转tm

    char *strptime(const char *s, const char *format, struct tm *tm);
    struct tm *getdate(const char *string);
    extern int getdate_err;
    #include <time.h>
    int getdate_r(const char *string, struct tm *res);

## utime, utimes文件访问和修改时间

    int utime(const char *filename, const struct utimbuf *times);
    int utimes(const char *filename, const struct timeval times[2]);

utime用来修改filename所指文件的inode访问时间和修改时间，参数times为NULL，则设置为当前时间。进程要么需要有足够权限，要么EUID等于文件所有者ID，或者times参数为NULL，并且进程有写权限,秒级。utimes精度更高。

*	EACCESS 文件路径搜索错误
*	EACCESS  参数times为NULL，EUID不等于文件拥有者ID，没有写入权限，没有足够的权限
*	ENOENT 文件不存在
*	EPERM times不为NULL，EUID不等于文件拥有者ID，没有足够权限。
*	EROFS 只读文件系统

## 时间操作函数

    double difftime(time_t time1, time_t time0);MT计算时间差值
    void timeradd(struct timeval *a, struct timeval *b, struct timeval *res);
    void timersub(struct timeval *a, struct timeval *b, struct timeval *res);
    void timerclear(struct timeval *tvp);
    int timerisset(struct timeval *tvp);
    int timercmp(struct timeval *a, struct timeval *b, CMP);

## timerfd_create, timerfd_settime, timerfd_gettime

    int timerfd_create(int clockid, int flags);
    int timerfd_settime(int fd, int flags, const struct itimerspec *new_value, struct itimerspec *old_value);
    int timerfd_gettime(int fd, struct itimerspec *curr_value);

这个接口基于文件描述符，通过文件描述符的可读事件进行超时通知，所以能够被用于select/poll的应用场景

# 参考

http://blog.csdn.net/zhongyunde/article/details/47919765

http://blog.chinaunix.net/uid-361890-id-175421.html

http://www.cnblogs.com/hanyan225/archive/2011/07/26/2117158.html

http://blog.chinaunix.net/uid-24774106-id-3909829.html

https://www.ibm.com/developerworks/cn/linux/l-cn-timerm/

http://kimi.it/508.html
