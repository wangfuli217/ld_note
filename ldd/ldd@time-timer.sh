timer(API)
{
定时器分为硬件和软件定时器，软件定时器最终还是要依靠硬件定时器来完成。内核在时钟中断发生后检测各定时器是否到期，
到期后的定时器处理函数将作为软中断在底半部执行。实质上，时钟中断处理程序执行update_process_timers函数，
该函数调用run_local_timers函数，这个函数处理TIMER_SOFTIRQ软中断，运行当前处理上到期的所有定时器。
Linux内核中定义提供了一些用于操作定时器的数据结构和函数如下：
1)timer_list:说定时器，当然要来个定时器的结构体
  struct timer_list{
     struct list_head entry;  //定时器列表
      unsigned long expires;  //定时器到期时间
      void (*function)(unsigned long) ;//定时器处理函数
      unsigned long data;   //作为参数被传入定时器处理函数
      struct timer_base_s *base;
}
2)初始化定时器：void init_timer(struct timer_list *timer);经过这个初始化后，entry的next为NULL,并给base赋值
3)增加定时器：void add_timer(struct timer_list *timer); 该函数用于注册内核定时器，并将定时器加入到内核动态定时器链表中。
4)删除定时器：int del_timer(struct timer_list *timer);
  说明：del_timer_sync是del_timer的同步版，主要在多处理器系统中使用，如果编译内核时不支持SMP,del_timer_sync和del_timer等价.
5)修改定时器：int mod_timer(struct timer_list *timer, unsigned long expires);
}

https://www.ibm.com/developerworks/cn/linux/l-tasklets/

定时器的实现被设计来符合下列要求和假设:
    定时器管理必须尽可能简化.
    设计应当随着激活的定时器数目上升而很好地适应.
    大部分定时器在几秒或最多几分钟内到时, 而带有长延时的定时器是相当少见.
    一个定时器应当在注册它的同一个 CPU 上运行.

timer(内核定时器说明)
{
------ 内核定时器 ------
1、 如果我们需要在将来的某个时间点调度执行某个动作，同时在该时间点到达前不会阻塞当前进程，则可以使用内核定时器。
    内核定时器用来调度一个函数在将来一个特定的时间（基于时钟嘀哒）执行，从而可完成各类任务。
2、 内核定时器是基于时钟滴答的。
3、 使用场景：
	1. 硬件无法产生中断，内核定时器可以周期性的轮询设备状态。
	2. 关闭软驱马达或者结束长时间的关闭操作。
	3. schedule_timeout利用内核定时器实现任务调度。
4、 被调度运行的函数几乎肯定不会在注册这个函数的进程正在执行时运行。相反，这个函数会异步地运行。
    当定时器运行时，调度该定时器的进程可能在休眠；在其处理上执行；或进程已经退出。
5、 定时器可以将自己注册到在稍后的时间重新运行。常用于轮询设备。
6、 即使在单处理器系统上，定时器也会是竟态的潜在源，这是由于其异步执行的特点直接导致的。因此，任何通过定时函数访问
    的数据结构都应针对并发访问进行保护。
7、 内核定时器离完美还有很大差距，因为它受到jitter以及由硬件中断，其他定时器或异步任务所产生的影响。和简单数字IO关联的定时器对简单任务来说够了
    比如：控制步进电机或业余电子设备。不适合工业环境下的生产系统。 ---- 借助某种实时的内核扩展。
	
进程上下文 & 中断上下文	
linux/timer.h 和kernel/timer.c 
1. 不允许访问用户空间。因为没有进程上下文，无法将特定进程与用户空间关联起来。
2. current指针在原子模式下没有意义，也是不可用的，因为相关代码和被中断的进程没有任何关联。
3. 不能执行休眠或调度。原子代码不可以调度schedule()或者wait_event，也不能调用任何可能引起休眠的函数。信号量互斥量等。

内核代码可以通过调用函数in_interrupt()来判断自己是否正运行在中断上下文，
如果处理器运行在中断上下文就返回非零值，而无论是硬件中断还是软件中断。

in_interrupt() & in_atomic()  asm/hardirq.h
in_interrupt() 非零(软中断或应中断中)
in_atomic()    非零(调度不被允许时)  [硬件或中断上下文以及拥有自旋锁的任何时间点]
                                     自旋锁的任何时间点:current可用，但禁止访问用户空间，因为这会导致调度的发生。
                                      硬件或中断上下文:current不可用。
不管何时使用in_interrupt()都应考虑是否真正该使用的是in_atomic()。
}

in_interrupt(API)
{
通过调用函数 in_interrupt() 能够告知是否它在中断上下文中运行，无需参数并如果处理器当前在中断上下文运行就返回非零。
}

in_atomic(API)
{
    通过调用函数 in_atomic() 能够告知调度是否被禁止，若调度被禁止返回非零; 调度被禁止包含硬件和软件中断上下文以
及任何持有自旋锁的时候。

    在后一种情况, current 可能是有效的，但是访问用户空间是被禁止的，因为它能导致调度发生. 当使用 in_interrupt() 时，
都应考虑是否真正该使用的是 in_atomic 。他们都在 <asm/hardirq.h> 中声明。

    内核定时器的另一个重要特性是任务可以注册它本身在后面时间重新运行，因为每个 timer_list 结构都会在运行前从激活的
定时器链表中去连接,因此能够立即链入其他的链表。一个重新注册它自己的定时器一直运行在同一个 CPU.

    即便在一个单处理器系统，定时器是一个潜在的态源，这是异步运行直接结果。因此任何被定时器函数访问的数据结构应当
通过原子类型或自旋锁被保护，避免并发访问。
}

timer(API)
{
timer 用于任务定期执行。
init_waitqueue_head，wait_event_interruptible，wake_up_interruptible(&data->wait);  用于进程阻塞同步执行

#define init_timer(timer)
#define TIMER_INITIALIZER(_function, _expires, _data) // jiffies 到达_expires的值。就执行_function

在初始化之后，可在调用add_timer之前修改上面讲到的三个公共字段。
如果要在定时到期之前禁止一个已注册的定时器，可以调用del_timer函数。

void add_timer(struct timer_list *timer);
int del_timer(struct timer_list * timer);

int mod_timer(struct timer_list *timer, unsigned long expires);
int del_timer_sync(struct timer_list *timer);
static inline int timer_pending(const struct timer_list * timer)

unsigned long j = jiffies;

data = kmalloc(sizeof(*data), GFP_KERNEL);
if (!data)
        return -ENOMEM;

init_timer(&data->timer);
init_waitqueue_head (&data->wait);

/* write the first lines in the buffer */
buf2 += sprintf(buf2, "   time   delta  inirq    pid   cpu command\n");
buf2 += sprintf(buf2, "%9li  %3li     %i    %6i   %i   %s\n",
                j, 0L, in_interrupt() ? 1 : 0,
                current->pid, smp_processor_id(), current->comm);

/* fill the data for our timer function */
data->prevjiffies = j;
data->buf = buf2;
data->loops = JIT_ASYNC_LOOPS;

/* register the timer */
data->timer.data = (unsigned long)data;
data->timer.function = jit_timer_fn;
data->timer.expires = j + tdelay; /* parameter */
add_timer(&data->timer);

/* wait for the buffer to fill */
wait_event_interruptible(data->wait, !data->loops);
}

