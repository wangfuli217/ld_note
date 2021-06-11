1)tasklet：使用比较简单，如下：
void my_tasklet_function(unsigned long); //定义一个处理函数
DECLARE_TASKLET(my_tasklet, my_tasklet_function, data); //定义了一个名叫my_tasklet的tasklet并将其与处理函数绑定，而传入参数为data
在需要调度tasklet的时候引用一个tasklet_schedule()函数就能使系统在适当的时候进行调度运行：tasklet_schedule(&my_tasklet);


timer VS tasklet
1、 我们不能要求tasklet在某个给定时间执行。希望内核选在某个其后的时间来执行给定的函数。
2、 使用tasklet，表明我们只是希望内核选择某个其后的时间来执行给定的函数。  ----- 常与中断一起使用
3、 只要CPU忙于运行某个进程，tasklet就会在下一个定时滴答运行，但是如果CPU空闲，则会立即运行。
    内核为每个CPU提供了一组ksoftirq内核线程，用于运行"软件中断"处理例程。

softirq VS tasklet
softirq和tasklet都属于软中断，tasklet是softirq的特殊实现；
    1.softirq处理函数需要被编写成可重入的，因为多个cpu可能同时执行同一个softirq处理函数，为了防止数据出现不一致性，
所以softirq的处理函数必须被编写成可重入。最典型的就是要在softirq处理函数中用spinlock保护一些共享资源。

    2.而tasklet机制本身就保证了tasklet处理函数不会同时被多个cpu调度到。因为在tasklet_schedule()中，就保证了多个cpu
不可能同时调度到同一个tasklet处理函数，这样tasklet就不用编写成可重入的处理函数，这样就大大减轻了kernel编程人员
的负担。

https://www.ibm.com/developerworks/cn/linux/l-tasklets/
1、tasklet的构建基于软中断，用于允许动态生成可延迟函数。
    工作队列允许将任务延迟到中断上下文之外，进入内核处理上下文。
2、软中断最初为具有 32 个软中断条目的矢量， 用来支持一系列的软件中断特性。 当前，只有 9 个矢量被用于软中断， 
tasklet(desc)
{
其中之一是 TASKLET_SOFTIRQ（参见 ./include/linux/interrupt.h）。 虽然软中断还存在于内核中，推荐采用tasklet和工作队列，
而不是分配新的软中断矢量。

1、 不同于tasklet一步到位的延迟方法，工作队列采用通用的延迟机制， 
2、 工作队列的处理程序函数能够休眠（这在tasklet模式下无法实现）。 
3、 工作队列可以有比tasklet更高的时延，并为任务延迟提供功能更丰富的 API。 
从前，延迟功能通过 keventd 对任务排队来实现， 但是现在由内核工作线程 events/X 来管理。

驱动程序使用tasklet机制
	驱动程序在初始化时，通过函数task_init建立一个tasklet，然后调用函数tasklet_schedule将这个tasklet 放在 
tasklet_vec链表的头部，并唤醒后台线程ksoftirqd。当后台线程ksoftirqd运行调用__do_softirq时，会执行在
中断向量表softirq_vec里中断号TASKLET_SOFTIRQ对应的tasklet_action函数，然后tasklet_action遍历tasklet_vec链表，
调用每个tasklet的函数完成软中断操作。
}

tasklet(interface)
{
------ tasklet ------  滴答数 即 jiffies
static struct softirq_action softirq_vec[NR_SOFTIRQS];

enum {
    HI_SOFTIRQ = 0, /* 优先级高的tasklets */
    TIMER_SOFTIRQ, /* 定时器的下半部 */
    NET_TX_SOFTIRQ, /* 发送网络数据包 */
    NET_RX_SOFTIRQ, /* 接收网络数据包 */
    BLOCK_SOFTIRQ, /* BLOCK装置 */
    BLOCK_IOPOLL_SOFTIRQ,
    TASKLET_SOFTIRQ, /* 正常优先级的tasklets */
    SCHED_SOFTIRQ, /* 调度程序 */
    HRTIMER_SOFTIRQ, /* 高分辨率定时器 */
    RCU_SOFTIRQ, /* RCU锁定 */
    NR_SOFTIRQS /* 10 */
};


struct tasklet_hrtimer {
	struct hrtimer		timer;
	struct tasklet_struct	tasklet;
	enum hrtimer_restart	(*function)(struct hrtimer *);
};
extern void tasklet_init(struct tasklet_struct *t,
			 void (*func)(unsigned long), unsigned long data);
#define DECLARE_TASKLET(name, func, data)
#define DECLARE_TASKLET_DISABLED(name, func, data) 

1. 一个tasklet可在稍后被禁止或者重新启用；只有启用的次数和禁用的次数相同时，tasklet才会被执行。
2. 和定时器类似，tasklet可以注册自己本身。
3. tasklet可被调度已在通常的优先级或高优先级执行。高优先级的tasklet总是首先执行。
4. 如果系统负荷不重，则tasklet会立即得到执行，但始终不会晚于下一个定时器滴答。
5. 一个tasklet可以和其他tasklet并发，但对自身来讲是严格串行处理的，也就是说：
   同一个tasklet永远不会在多个处理器上同时运行。当然我们已经指出，tasklet时钟在调度自己的同一CPU上运行。
   
static inline void tasklet_disable(struct tasklet_struct *t)  #可能进入忙等待
禁止指定的tasklet，该tasklet仍然可以用tasklet_schedule()调度，但其执行被推迟，直到tasklet被重新启用。
如果tasklet当前正在运行，该函数会进入忙等待直到tasklet退出为止；
在调用tasklet_disable之后，我们可以确信该tasklet不会在系统中任何地方运行。

static inline void tasklet_disable_nosync(struct tasklet_struct *t) #不会进入忙等待
当该函数返回时，指定的tasklet可能仍在其他CPU上运行。

static inline void tasklet_enable(struct tasklet_struct *t)
启用一个先前被禁用的tasklet。
如果该tasklet已经被调度，它很快就会运行。

static inline void tasklet_schedule(struct tasklet_struct *t)
调度指定的tasklet。
如果在获得运行机会之前，某个tasklet被再次调度，则该tasklet只会运行一次。
但是如果在该tasklet运行时被调度，就会在完成后再次运行。
这样，可确保正在处理事件时发生的其他事件也会被接收并注意到，这种行为也允许tasklet重新调度自身。

static inline void tasklet_hi_schedule(struct tasklet_struct *t)  以高优先级执行
当软件中断处理例程运行时，它会在处理其他软件中断之前处理高优先级的tasklet。
理想状态下，只有具备低延迟需要的任务才能使用这个函数。这样可避免由其他软件中断处理例程引入的额外延迟。

extern void tasklet_kill(struct tasklet_struct *t);   --- tasklet不会再运行， 并且，如果按进度该tasklet应该运行，将会等到它运行完，然后再 kill 该线程。
确保指定的tasklet不会被再次调度运行。
当设备要被关闭或者模块要被移除时，我们通常调用这个函数。
如果tasklet在被调度执行，该函数会等待直到其退出。

void tasklet_kill_immediate( struct tasklet_struct *, unsigned int cpu );
 tasklet_kill_immediate 只在指定的 CPU 处于 dead 状态时被采用。
}

tasklet(template)
{

void xxx_do_tasklet(unsigned long);
DECLARE_TASKLET(xxx_tasklet,xxx_do_tasklet,0);
void xxx_do_tasklet(unsigned long)
{
……
}

irqreturn_t xxx_interrupt(int irq,void *dev_id,struct pt_regs *regs)
{
      ……
      tasklet_schedule(&xxx_tasklet);
      ……
}

int _init xxx_init(void)
{
      ……
      result=request_irq(xxx_irq,xxx_interrupt,SA_INTERRUPT,”xxx”,NULL)
      ……
}

void _exit xxx_exit(void)
{
      ……
      free_irq(xxx_irq,xxx_irq_interrupt);
      ……
}

}