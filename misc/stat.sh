cat stat  | tr ' ' "\n" | less -N

stat(process)
{
sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
task_pid_nr_ns(task, ns), /*进程(包括轻量级进程，即线程)号(task->pid)*/
tcomm, /*应用程序的名字(task->comm)*/
state,/*进程的状态信息(task->state),具体参见http://blog.chinaunix.net/u2/73528/showart_1106510.html*/
ppid,/*父进程ID*/
pgid,/*线程组ID*/
sid,/*会话组ID*/
tty_nr,/*该进程的tty终端的设备号，INT（34817/256）=主设备号，（34817-主设备号）=次设备号*/
tty_pgrp,/*终端的进程组号，当前运行在该进程所在终端的前台进程(包括shell 应用程序)的PID*/
task->flags,/*进程标志位，查看该进程的特性(定义在/include/kernel/sched.h中)*/
min_flt,/*累计进程的次缺页数（Copy on　Write页和匿名页）*/
cmin_flt,/*该进程所有的子进程发生的次缺页的次数*/
maj_flt,/*主缺页数（从映射文件或交换设备读入的页面数）*/
cmaj_flt,/*该进程所有的子进程发生的主缺页的次数*/
cputime_to_clock_t(utime),/*该进程在用户态运行的时间，单位为jiffies*/
cputime_to_clock_t(stime),/*该进程在核心态运行的时间，单位为jiffies*/
cputime_to_clock_t(cutime),/*该进程所有的子进程在用户态运行的时间总和，单位为jiffies*/
cputime_to_clock_t(cstime),/*该进程所有的子进程在内核态运行的时间的总和，单位为jiffies*/
priority,/*进程的动态优先级*/
nice,/*进程的静态优先级*/.
num_threads,/*该进程所在的线程组里线程的个数*/.
start_time,/*该进程创建的时间*/.
vsize,/*该进程的虚拟地址空间大小*/.
mm ? get_mm_rss(mm) : 0,/*该进程当前驻留物理地址空间的大小*/.
rsslim,/*该进程能驻留物理地址空间的最大值*/.
mm ? mm->start_code : 0,/*该进程在虚拟地址空间的代码段的起始地址*/.
mm ? mm->end_code : 0,/*该进程在虚拟地址空间的代码段的结束地址*/.
mm ? mm->start_stack : 0,/*该进程在虚拟地址空间的栈的结束地址*/.
esp,/*esp(32 位堆栈指针) 的当前值, 与在进程的内核堆栈页得到的一致*/.
eip,/*指向将要执行的指令的指针, EIP(32 位指令指针)的当前值*/.
/* The signal information here is obsolete.
* It must be decimal for Linux 2.0 compatibility.
* Use /proc/#/status for real-time signals.
*/
task->pending.signal.sig[0] & 0x7fffffffUL,/*待处理信号的位图，记录发送给进程的普通信号*/.
task->blocked.sig[0] & 0x7fffffffUL,/*阻塞信号的位图*/.
sigign .sig[0] & 0x7fffffffUL,/*忽略的信号的位图*/.
sigcatch .sig[0] & 0x7fffffffUL,/*被俘获的信号的位图*/.
wchan,/*如果该进程是睡眠状态，该值给出调度的调用点*/.
0UL,/*被swapped的页数,当前没用*/.
0UL,/*所有子进程被swapped的页数的和，当前没用*/.
task->exit_signal,/*该进程结束时，向父进程所发送的信号*/.
task_cpu(task),/*运行在哪个CPU上*/.
task->rt_priority,/*实时进程的相对优先级别*/.
task->policy,/*进程的调度策略，0=非实时进程，1=FIFO实时进程；2=RR实时进程*/.
(unsigned long long)delayacct_blkio_ticks(task),/**/.
cputime_to_clock_t(gtime),/**/.
cputime_to_clock_t(cgtime));/**/.
}


stat(proc)
{
第一行的CPU是你所有CPU负载信息的总和。后面的CPUn（n是数字）表示你那个CPU的信息，我这里只有一个CPU，所以是CPU0。也就是说我的前两行信息相同。


user ： 从系统启动开始累计到当前时刻，用户态的CPU时间（单位：jiffies） ，不包含 nice值为负进程。1jiffies=0.01秒
nice： 从系统启动开始累计到当前时刻，nice值为负的进程所占用的CPU时间（单位：jiffies）
system ： 从系统启动开始累计到当前时刻，核心时间（单位：jiffies）
idle ： 从系统启动开始累计到当前时刻，除硬盘IO等待时间以外其它等待时间（单位：jiffies）
iowait ： 从系统启动开始累计到当前时刻，硬盘IO等待时间（单位：jiffies） ，
irq： 从系统启动开始累计到当前时刻，硬中断时间（单位：jiffies）
softirq ： 从系统启动开始累计到当前时刻，软中断时间（单位：jiffies）
从2.6.11加了第8列stealstolen time：which is the time spent in other operating systems when running in a virtualized environment
从 2.6.24加了第9列 guest： which is the time spent running a virtual  CPU  for  guest operating systems under the control of the Linux kernel.

intr:这行给出中断的信息，第一个为自系统启动以来，发生的所有的中断的次数；然后每个数对应一个特定的中断自系统启动以来所发生的次数，依次对应的是0号中断发生的次数，1号中断发生的次数……
ctxt:给出了自系统启动以来CPU发生的上下文交换的次数
btime:给出了从系统启动到现在为止的时间，单位为秒
processes:自系统启动以来所创建的任务的个数目
procs_running:当前运行队列的任务的数目
procs_blocked:当前被阻塞的任务的数目
可以从这个文件提取一些数据来计算处理器的使用率。
处理器使用率 ：
从/proc/stat中提取四个数据：用户模式（user）、低优先级的用户模式（nice）、内核模式（system）以及空闲的处理器时间（idle）。它们均位于/proc/stat文件的第一行。CPU的利用率使用如下公式来计算。
CPU利用率   =   100   *（user   +   nice   +   system）/（user   +   nice   +   system   +   idle）
}





