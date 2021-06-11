1. 如何度量时间差，如何比较时间
2. 如何获得当前时间
3. 如何将操作延迟指定的一段时间
4. 如何调度异步函数到指定的时间之后执行。

初始化软件中断，软件中断与硬件中断区别就是中断发生时，软件中断是使用线程来监视中断信号，而硬件中断是使用CPU硬件来监视中断。

https://www.ibm.com/developerworks/cn/linux/l-cn-cncrrc-mngd-wkq/
内核中提供了许多机制来提供延迟执行，如
1. 中断的下半部处理可延迟中断上下文中的部分工作；
2. 定时器可指定延迟一定时间后执行某工作；
3. 工作队列则允许在进程上下文环境下延迟执行等。
除此之外，
4. 内核中还曾短暂出现过慢工作机制 (slow work mechanism)，
5. 还有异步函数调用 (asynchronous function calls) 
6. 以及各种私有实现的线程池等

jiffies(计数器, timeval_to_jiffies, jiffies_to_timeval, timespec_to_jiffies, jiffies_to_timespec)
{


##  内核通过定时器中断来跟踪时间流。   中断。

时钟中断有系统定时硬件以周期性的间隔产生。  间隔由内核根据HZ的值设定，HZ是一个与体系结构有关的常数，定义于linux/param.h或者
该文件包含的某个子平台相关的文件中。对真实硬件，已发布的linux内和源代码为大多数平台定义的默认HZ值范围是50~1200，而软件仿真器的HZ值时24.

某些内部计算的实现仅仅适用于HZ取12~1525之间的情况： linux/timex.h 和RFC-1589

每当时钟中断发生时，内核内部计数器的值就增加1，这个计数器的值在系统引导时被初始化为0，因此，它的值就是上次操作系统引导以来的时钟滴答数。
64位置，称为juffues_64.但驱动程序开发者通常访问的是jiffies变量，它是unsigned long型的变量，要么和jiffies_64相同，要么仅仅是jiffies_64的低32位。

CONFIG_HZ
CONFIG_NO_HZ

------ jiffies计数器 ------
该计数器和读取计数器的工具函数包含在Linux/jiffies.h中，但是通常只需要包含linux/sched.h文件，后者就自动放入jiffies.h。
jiffies和jiffies_64均被看做只读变量。

unsigned long j, stamp_l, stamp_half, stamp_n;
j = jiffies;                 读取当前值
stamp_1 = j + HZ;            未来的1秒
stamp_half = j + HZ/2;       半秒
stamp_n = j + HZ*n/1000;     n 毫秒

32位平台上：HZ等于1000，大约50天计数器才会溢出一次。

#define time_after(a,b)       a比b靠后，则返回真 a > b
#define time_before(a,b)      a比b靠前，则返回真 b > a
#define time_after_eq(a,b)    a比b靠后或相等，则返回真 a >= b
#define time_before_eq(a,b)   a比b靠前或相等，则返回真 b >= a

struct timeval 和 struct timespec
unsigned long timeval_to_jiffies(const struct timeval *value);
void jiffies_to_timeval(const unsigned long jiffies,
			       struct timeval *value);
				   
unsigned long timespec_to_jiffies(const struct timespec *value);
void jiffies_to_timespec(const unsigned long jiffies,
				struct timespec *value);
				
jiffies 和 jiffies_64 ## vmlinux*.lds* 文件，字节序解决。
u64 get_jiffies_64(void)
{
	unsigned long seq;
	u64 ret;

	do {
		seq = read_seqbegin(&xtime_lock);
		ret = jiffies_64;
	} while (read_seqretry(&xtime_lock, seq));
	return ret;
}

注意：实际的时钟频率对用户空间来讲几乎是完全不可见的。当用户空间程序包含param.h时，HZ始终被扩展为100，而每个报告给用户空间的计数器值
均做了相应的装换。这一说法是适应于clock(3),times(2)以及其他任何相关函数。对用户来讲，如果想知道定时器中断的确切HZ值，只能通过/proc/interrupts
获得。例如：将通过/proc/interrupts获得的计数值除以/proc/uptime文件报告的系统运行时间，即可获得内核的确切值。

}

get_cycles(处理器特定的寄存器)
{
------ 处理器特定的寄存器 ------	 ARM没
TSC(timestamp counter 时间戳计数器)
asm/msr.h x86 rdtsc(low32, high32)
              rdtsc1(low32)
			  rdtscll(var64)
跨CPU封装
#include <linux/timex.h>
cycles_t get_cycles(void);
在没有时钟周期计数器的平台上总是返回0.cycles_t类型是能装入读取值的合适的无符号类型。

在SMP系统中，他们不会在多个处理期间保持同步，为了确保获得一致的值，我们需要为查询该计数器的代码禁止抢占。

    rdtsc(low32,high32);/*原子地读取 64-位TSC 值到 2 个 32-位 变量*/ 
    rdtscl(low32);/*读取TSC的低32位到一个 32-位 变量*/ 
    rdtscll(var64);/*读 64-位TSC 值到一个 long long 变量*/ 
    /*下面的代码行测量了指令自身的执行时间:*/ 
    unsigned long ini, end; 
    rdtscl(ini); 
    rdtscl(end); 
    printk("time lapse: %li\n", end - ini);
}

do_gettimeofday(获取当前时间, mktime, timeval, timespec)
{
------ 获取当前时间 ------
内核一般通过jiffies值来获取当前时间。

使用jiffies值来测量时间间隔在大多数情况下已经足够了，如果还需要测量更短的时间差，就只能使用处理器特定的寄存器了。
jiffies 和 墙上时钟
extern unsigned long mktime(const unsigned int year, const unsigned int mon,
			    const unsigned int day, const unsigned int hour,
			    const unsigned int min, const unsigned int sec);
秒和微秒级别
void do_gettimeofday(struct timeval *tv);

xtime变量  纳秒
struct timespec current_kernel_time(void);

/proc/currenttime文件；
}

cpu_relax(cpu_relax, schedule)
{
------ 延迟操作 ------
长延时：忙等待(不推荐)
忙等待 while(time_before(jiffies, j1))
		cpu_relax();
        
让出处理器
让出CPU while(time_before(jiffies, j1))
		schedule();
		
超时： 如果驱动程序使用等待队列来等待其他的一些事件，而我们同时希望在特定时间段中运行，则可以使用：
#define wait_event_timeout(wq, condition, timeout)			
#define wait_event_interruptible_timeout(wq, condition, timeout)
timeout：要等待的时间值，不是绝对时间值。

set_current_state(TASK_INTERRUPTIBLE)
signed long schedule_timeout(signed long timeout);
}

schedule_timeout()
{
schedule_timeout会做两件事
1. 设置timer
2. Schedule

他不会把当前的进程的状态由TASK_RUNNING变为TASK_INTERRUPTIBLE和TASK_UNINTERRUPTIBLE或者TASK_KILLABLE
所以在__schedule()中，不会把这个task从runqueue中移出去。那么当系统进行调度的时候这个进程仍然会被调度进来。
所以推荐调用
Schedule_timeout_interruptible
Schedule_timeout_uninterruptible
Schedule_timeout_killable
这几个函数都会在调用schedule_timeout之前调用set_current_state，来把进程的状态设置为非TASK_RUNNING得状态。
其中msleep就是调用schedule_timeout_uninterruptible。
}

schedule()
{
    今天纠正了一个由来已久的认识错误：
    一个进程的时间片用完之后，当再次发生时钟中断时内核会调用schedule()来进行调度，把当前的进程上下文
切出CPU，并把选定的下一个进程切换进来运行。我一直以为schedule()函数是在时钟中断处理函数中被调用的。
其实不是，如果真是这样的话，那么在第一次这样的调度完成之后，时钟中断可能就要被mute掉了，系统从此失去
"心跳"。

我之前那样理解是基于这样两点考虑：
    1. 在时钟中断发生时会更新进程的时间片（对于CFS调度器来说，就是更新进程的虚拟运行时间virtual run-time）。
更新完这个时间信息之后，立刻运行schedule()顺理成章，调度就应该在这个时机发生；
    2. 中断发生之后，（以arm架构为例）系统会从IRQ模式迅速切换成SVC模式，并且在此后的中断处理过程中，中断是
关闭的，只有在切换回USR模式（其中还经过IRQ模式）时，才回再把中断打开。如果在中断处理函数中调用
schedule()并不会带来中断无法再次打开的问题，因为最后总是要切换到USR模式的，那时时钟中断也总是有机会能
重新打开的。

但是我没有注意到一个问题，就是ARM中断控制器(VIC)的mask/unmask操作。在进入中断响应函数之前，需要先对相应的中断
设计掩码，即把正在处理的这个中断mask掉，在响应完后再把它unmask回来，好让中断能够继续发生。这段代码在
kernel/irq/chip.c中（以下是经简化的示例代码）：

void handle_level_irq(unsigned int irq, struct irq_desc *desc)
{
 ......
 mask_ack_irq(desc, irq);
 ......
 action_ret = handle_IRQ_event(irq, action);
 ......
 unmask_irq(desc, irq);
 ......
}

注：中断的mask/unmask与enable/disable是两个层次的概念：enable/disable是对所有中断而言，如果disable的话任何中断
都不会发生；而mask/unmask是对一个特定的中断而言的，mask之后，指定的中断不会再发生了，但并不影响其它的中断。
    所以，基于这种设计，在中断响应过程中，只能更新进程的时间片，却不可以进行调度。如果一旦在上述的handle_IRQ_event()
里面调用了schedule()函数，就会立刻切换到其它进程（SVC模式，内核态），接下来的unmask_irq()执行不到，时钟中断就再
也没有机会打开。切换到下一个进程之后，因为没有时钟中断，系统也就失去了心跳。
正确的方法是在中断处理快要结束时调用schedule()：
    在中断处理的汇编代码中(arm架构下主要看__irq_usr)，主要的中断处理过程都完成之后，会跑到ret_to_user处准备返回用户
模式。这时就会检查进程的thread_info结构中是否置有“_TIF_NEED_RESCHED”标志，如果是的话，说明需要进行进程调度，
这时再调用函数schedule()。在这个时间点上，中断控制器中相应的位已经被unmask过，接下来只要开中断即可。

上面提到的汇编代码比较零散，这里就不贴了，都在文件arch/arm/kernel/entry-armv.S和entry-common.S中。

}


ndelay(短延时： 忙等待 ndelay, udelay, mdelay)
{
短延时： 忙等待
void ndelay(unsigned long x)      纳秒
void udelay(unsigned long x)      微秒
void mdelay(unsigned int msecs);  毫秒
}

msleep(闲等待, msleep, msleep_interruptible, ssleep)
{
闲等待：
void msleep(unsigned int msecs);
unsigned long msleep_interruptible(unsigned int msecs);
static inline void ssleep(unsigned int seconds)
}

instance(delay)
{
方法1：
while (time_before(jiffies, j1))
                cpu_relax();

方法2：
while (time_before(jiffies, j1)) {
    schedule();
}

方法3：
wait_event_interruptible_timeout(wait, 0, delay);  

方法4：
set_current_state(TASK_INTERRUPTIBLE);
schedule_timeout (delay);


}

------ 三种 bottom half的实现方式 softirqs, tasklets, workqueue ------

------ 硬中断 & 软中断 & 信号 ------
"硬中断是外部设备对CPU的中断"，
"软中断通常是硬中断服务程序对内核的中断"，
"信号则是由内核（或其他进程）对某个进程的中断"
初始化软件中断，软件中断与硬件中断区别就是中断发生时，软件中断是使用线程来监视中断信号，而硬件中断是使用CPU硬件来监视中断。

------ Tasklet ------
1.Tasklet 可被hi-schedule和一般schedule，hi-schedule一定比一般shedule早运行；
   2.同一个Tasklet可同时被hi-schedule和一般schedule;
   3.同一个Tasklet若被同时hi-schedule多次，等同于只hi-shedule一次，因为，在tasklet未运行时，hi-shedule同一tasklet无意义，会冲掉前一个tasklet;
   4.对于一般shedule, 同上。
   5.不同的tasklet不按先后shedule顺序运行，而是并行运行。
 6.Tasklet的运行时间：
         a.若在中断中schedule tasklet, 中断结束后立即运行；
         b.若CPU忙，在不在此次中断后立即运行；
         c.不在中断中shedule tasklet;
         d.有软或硬中断在运行；
         e.从系统调用中返回；（仅当process闲时）
         f.从异常中返回;
         g.调试程序调度。（ksoftirqd运行时，此时CPU闲）
 7.Taskelet的hi-schedule 使用softirq 0, 一般schedule用softirq 30；
 8.Tasklet的运行时间最完在下一次time tick 时。（因为最外层中断一定会运行使能的softirq, 面不在中断中便能或shedule的softirq在下一定中断后一定会被调用。）

  综上： Tasklet 能保证的运行时间是(1000/HZ)ms,一般是10ms。Tasklet在CPU闲或中断后被调用.
  
 ------ softirq & tasklet & wrokqueue  ------
softirq和tasklet都属于软中断，tasklet是softirq的特殊实现；

什么情况下使用工作队列，什么情况下使用tasklet。
如果推后执行的任务需要睡眠，那么就选择工作队列。
如果推后执行的任务不需要睡眠，那么就选择tasklet。另外，
如果需要用一个可以重新调度的实体来执行你的下半部处理，也应该使用工作队列。
它是唯一能在进程上下文运行的下半部实现的机制，也只有它才可以睡眠。
这意味着在需要获得大量的内存时、在需要获取信号量时，在需要执行阻塞式的I/O操作时，它都会非常有用。
如果不需要用一个内核线程来推后执行工作，那么就考虑使用tasklet。  

------- 为什么softirq/tasklet运行在中断上下文? ------
#### 
不是有ksoftirqd辅助内核线程吗？
所以我感觉softirq/tasklet应该有时候会运行在这个内核线程的上下文中。
但是，LKD 上面说softirq/tasklet运行在中断上下文，何解？
####

看看ksoftirqd函数就知道了：            asmlinkage void do_softirq(void)       
ksoftirqd()                            {
    do_softirq()                           __u32 pending;
        local_irq_save()                   unsigned long flags;
        __do_softirq                       
        local_irq_restore                  if (in_interrupt())
                                               return;
此时softirq执行是关了中断的            
                                           local_irq_save(flags);
                                           
                                           pending = local_softirq_pending();      
                                       
                                           if (pending)
                                               __do_softirq();
                                       
                                           local_irq_restore(flags);
                                       }
                                       从上面的代码可以看出，如果 in_interrupt()为true，then return
                                        所以，这时候应该是进程上下文。
在__do_softirq()里执行softirq前做了2个动作：
1. __local_bh_disable禁止下半部中断，实际上是禁止了抢占
2. local_irq_enable()使能硬件中断

因此在执行softirq时处于中断上下文（因为禁止了抢占，表明只有硬件中断ISR能够打断当前的softirq，但是其他的内核路径是不能够打断其执行的），
而由于禁止了抢占，所以此时是不能调度的（禁止抢占表明无法调度至别的进程，而你如果调用会调度的函数可想而知会有什么问题）。									   

若系统负载过重（在一个循环中处理的软件中断次数大于10）的时候，一些本来应该在中断上下文中处理的事情，就被转移到内核中的进程上下文处理了，
在do_softirq中会唤醒相应的daemon进程处理。













