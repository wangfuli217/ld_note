2)工作队列：使用方法和tasklet相似，如下：
struct work_struct my_wq; //定义一个工作队列
void my_wq_func(unsigned long);  //定义一个处理函数
通过INIT_WORK()可以初始化这个工作队列并将工作队列与处理函数绑定，如下：
INIT_WORK(&my_wq, (void (*)(void *))my_wq_func, NULL);  //初始化工作队列并将其与处理函数绑定
同样，使用schedule_work(&my_irq)；来在系统在适当的时候需要调度时使用运行。

3)软中断：使用软件方式模拟硬件中断的概念，实现宏观上的异步执行效果，tasklet也是基于软中断实现的。
    在Linux内核中，用softirq_action结构体表征一个软中断，这个结构体中包含软中断处理函数指针和传递给函数的参数，
使用open_softirq()可以注册软中断对应的处理函数，而raise_softirq()函数可以触发一个中断。
    软中断和tasklet仍然运行与中断上下文，而工作队列则运行于进程上下文。因此，软中断和tasklet的处理函数不能休眠，但工作队列是可以的。
local_bh_disable()和local_bh_enable()是内核用于禁止和使能软中断和tasklet底半部机制的函数。

ksoftirqd/0 内核线程是实现软中断的助手，软中断是由中断发起的可以被延后执行的底半步进程，
            ksoftirq工作是确保高负荷情况下，软中断既不会空闲，又不至于压垮正个系统。
            为了提高系统吞吐量，系统为每个CPU都创建了一个ksoftirq线程。
events/n    线程实现工作队列
pdflush     对高速缓冲中
kjournald    
nfsd


workqueue VS tasklet
1. tasklet在软件中断上下文中运行。因此，所有的tasklet代码都必须是原子的。相反，工作队列函数在一个特殊内核进程的上下文中运行。
   因此他们具有更好的灵活性。尤其是，工作队列函数可以休眠。
2. tasklet始终运行在被初始提交的统一处理器上，但这只是工作队列的默认方式。
3. 内核代码可以请求工作列表函数的执行延迟给定的时间间隔。
4. tasklet会在很短的时间段内很快执行，并以原子模式执行。
工作队列函数可具有更长的延迟并且不必原子化。

在许多情况下，众多的线程可能对性能具有某种程度的杀伤力。

1、由于工作队列的实现中，已有默认的共享工作队列，因此在选择接口时，就出现了 2 种选择：要么使用内核已经提供的共享工作队列，要么自己创建工作队列。
2、工作队列并非没有缺点。首先是公共的共享工作队列不能提供更多的好处，因为如果其中的任一工作项阻塞，则其他工作项将不能被执行，
   因此在实际的使用中，使用者多会自己创建工作队列，而这又导致下面的一些问题：
3、MT 的工作队列导致了内核的线程数增加得非常的快，这样带来一些问题：一个是占用了 pid 数目，这对于服务器可不是一个好消息，
   因为 pid 实际上是一种全局资源；而大量的工作线程对于资源的竞争也导致了无效的调度，而这些调度其实是不需要的，对调度器也带来了压力。
4、现有的工作队列机制某些情况下有导致死锁的倾向，特别是在两个工作项之间存在依赖时。如果你曾经调试过这种偶尔出现的死锁，
   会知道这种问题让人非常的沮丧。

workqueue()
{
------ workqueue ------   
linux/workqueue.h

struct workqueue_struct *create_workqueue(const char *name)                        // 创建工作队列
struct workqueue_struct *create_singlethread_workqueue(const char *name)           // 创建工作队列
每个工作队列有一个或多个专用的进程(内核线程)，这些进程运行提交到该队列的函数。
create_workqueue：内核会在系统中的每个处理上为该工作队列创建专用的线程。
create_singlethread_workqueue：内核创建单个工作线程。

    [创建工作项]
#define DECLARE_WORK(n, f)  // 静态接口
DECLARE_WORK(name, void (*function)(void*), void *data)
name：要声明的结构说明
function：要从工作队列中调用的函数
data要传递给该函数的值。

#define INIT_WORK(_work, _func)     // 动态接口
#define PREPARE_WORK(_work, _func)  // 动态接口
INIT_WORK完成更加彻底的结构化初始工作；在首次构造结构时，使用该宏。
PREPARE_WORK他不会初始化用来将workqueue_struct结构连接到工作队列的指针。--- 需要修改该接口使用
如果开发人员需要在任务被排入工作队列之前发生延迟，可以使用宏 INIT_DELAYED_WORK 和 INIT_DELAYED_WORK_DEFERRABLE。


int queue_work(struct workqueue_struct *wq, struct work_struct *work); // 添加到队列
int queue_delayed_work(struct workqueue_struct *wq,
	struct delayed_work *work, unsigned long delay);                   // 添加到队列,指定一个jiffies的延迟时间。
返回1：添加成功
返回0：当前已在队列中
queue_work_on 来指定处理程序在哪个 CPU 上运行。 

static inline bool cancel_delayed_work(struct delayed_work *work)
如果该入口项在开始执行前被取消，则上述函数返回非零值。
如果该入口项在开始执行后被取消，则上述函数返回零值。
如果该入口项正在其他处理器上执行，因此cancel_delayed_work后可能仍在运行。

void flush_workqueue(struct workqueue_struct *wq)
要绝对确保工作函数没有在 cancel_delayed_work 返回 0 后在任何地方运行，你必须跟随这个调用之后接着调用 flush_workqueue。
在 flush_workqueue 返回后。任何在改调用之前提交的工作函数都不会在系统任何地方运行。

bool flush_delayed_work(struct delayed_work *dwork);
任何在该调用之前被提交的函数都不会在系统任何地方运行。

void destroy_workqueue(struct workqueue_struct *wq);
释放相关资源
}

work_struct()
{

------ 共享队列 ------
1. 我们正在和其他人共享该工作队列
2. 我们不应长期独占共享队列
3. 添加任务不能长时间休眠，任务可能需要更长的时间才能获得处理器时间。

int schedule_work(struct work_struct *work);
在利用共享队列时，模块使用的是不同的函数，因为他要求work_struct结构能够带有参数。
int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
延时调用。

创建工作项
    [静态创建工作项]
typedef void (*work_func_t)(struct work_struct *work);               //
                                                                     
 DECLARE_WORK(name, func);                                           
 DECLARE_DELAYED_WORK(name, func);                                   
 
    [动态创建工作项]
INIT_WORK(struct work_struct work, work_func_t func);                //
PREPARE_WORK(struct work_struct work, work_func_t func);             
INIT_DELAYED_WORK(struct delayed_work work, work_func_t func);       
PREPARE_DELAYED_WORK(struct delayed_work work, work_func_t func);    

调度工作项       //将工作项添加到共享的工作队列，工作项随后在某个合适时机将被执行。
int schedule_work(struct work_struct *work); 
int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
}



https://www.ibm.com/developerworks/cn/linux/l-tasklets/
https://www.ibm.com/developerworks/cn/linux/l-cn-cncrrc-mngd-wkq/
------ 并发可管理工作队列 (Concurrency-managed workqueues) -----
	在 2.6.36 之前的工作队列，其核心是每个工作队列都有专有的内核线程为其服务——系统范围内的 ST 或每个 CPU 都有一个内核线程的 MT。
新的 cmwq 在实现上摒弃了这一点，不再有专有的线程与每个工作队列关联，事实上，现在变成了 Online CPU number + 1 个线程池来为工作队列服务，
这样将线程的管理权实际上从工作队列的使用者交还给了内核。当一个工作项被创建以及排队，将在合适的时机被传递给其中一个线程，
而 cmwq 最有意思的改变是：被提交到相同工作队列，相同 CPU 的工作项可能并发执行，这也是命名为并发可管理工作队列的原因。

cmwq 的实现遵循了以下几个原则：
    与原有的工作队列接口保持兼容，cmwq 只是更改了创建工作队列的接口，很容易移植到新的接口。
    工作队列共享 per-CPU 的线程池，提供灵活的并发级别而不再浪费大量的资源。
    自动平衡工作者线程池和并发级别，这样工作队列的用户不再需要关注如此多的细节。

	struct workqueue_struct *alloc_workqueue(char *name, unsigned int flags, int max_active);
	
其中：

name：为工作队列的名字，而不像 2.6.36 之前实际是为工作队列服务的内核线程的名字。
flag 指明工作队列的属性，可以设定的标记如下：
    WQ_NON_REENTRANT：默认情况下，工作队列只是确保在同一 CPU 上不可重入，即工作项不能在同一 CPU 上被多个工作者线程并发执行，但容许在多个 CPU 上并发执行。但该标志标明在多个 CPU 上也是不可重入的，工作项将在一个不可重入工作队列中排队，并确保至多在一个系统范围内的工作者线程被执行。
    WQ_UNBOUND：工作项被放入一个由特定 gcwq 服务的未限定工作队列，该客户工作者线程没有被限定到特定的 CPU，这样，未限定工作者队列就像简单的执行上下文一般，没有并发管理。未限定的 gcwq 试图尽可能快的执行工作项。
    WQ_FREEZEABLE：可冻结 wq 参与系统的暂停操作。该工作队列的工作项将被暂停，除非被唤醒，否者没有新的工作项被执行。
    WQ_MEM_RECLAIM：所有的工作队列可能在内存回收路径上被使用。使用该标志则保证至少有一个执行上下文而不管在任何内存压力之下。
    WQ_HIGHPRI：高优先级的工作项将被排练在队列头上，并且执行时不考虑并发级别；换句话说，只要资源可用，高优先级的工作项将尽可能快的执行。高优先工作项之间依据提交的顺序被执行。
    WQ_CPU_INTENSIVE：CPU 密集的工作项对并发级别并无贡献，换句话说，可运行的 CPU 密集型工作项将不阻止其它工作项。这对于限定得工作项非常有用，因为它期望更多的 CPU 时钟周期，所以将它们的执行调度交给系统调度器。
max_active：决定了一个 wq 在 per-CPU 上能执行的最大工作项。比如 max_active 设置为 16 表示一个工作队列上最多 16 个工作项能同时在 per-CPU 上同时执行。当前实行中，对所有限定工作队列，max_active 的最大值是 512，而设定为 0 时表示是 256；而对于未限定工作队列，该最大值为：MAX[512，4 * num_possible_cpus() ]，除非有特别的理由需要限流或者其它原因，一般设定为 0 就可以了。

cmwq 本质上是提供了一个公共的内核线程池的实现，其接口基本上和以前保持了兼容，只是更改了创建工作队列的函数的后端，
它实际上是将工作队列和内核线程的一一绑定关系改为由内核来管理内核线程的创建，因此在 cmwq 中创建工作队列并不意味着
一定会创建内核线程。
	

------ 2.6.22 版本前后变更 ------  
#define INIT_WORK(_work, _func, _data) \
do { \
INIT_LIST_HEAD(&(_work)->entry); \
(_work)->pending = 0; \
PREPARE_WORK((_work), (_func), (_data)); \
init_timer(&(_work)->timer); \
} while (0)

#define PREPARE_WORK(_work, _func, _data) \
do { \
(_work)->func = _func; \
(_work)->data = _data; \
} while (0)
google以下知道动态初始化用的，但是这个函数具体实现什么功能，这里的INIT_WORK(_work, _func, _data)的_func在初始化的时候执行吗

 

 

INIT_WORK会在你定义的_work工作队列里面增加一个工作任务，该任务就是_func。_func这个任务会需要一些数据作为参数，这个参数就是通过_data传递的。
任务的启动是通过调度程序schedule_work来处理的。
INIT_LIST_HEAD是初始化一个链表，就是在此之前，链表是不存在的。
(_work)->pending是调度程序需要使用的一个标志，没有仔细研究用处。
PREPARE_WORK就是进行赋值，确定链表中这个对象的任务和数据。
init_timer是初始化这个对象的任务时间，具体作用没有研究。

在2.6.22版本中，INIT_WORK已经做了大幅度的修改。INIT_WORK现在使用2个参数，分别是链表和任务，去掉了数据。这时我们的任务func以_work作为参数。我们需要将我们的work结构加入到我们的data结构中，然后使用container_of这个函数来求出我们的data的指针。

