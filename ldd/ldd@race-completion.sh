
init_completion(API)
{
使用方法:
1)定义完成量
struct completion my_completion;
2)初始化
init_completion(&my_completion); //要是觉得这两步麻烦,就再给你来个宏即定义又初始化
DECLARE_COMPLETION(my_completion);

3)等待完成量
void wait_for_completion(structcompletion *c);   //等待一个completion被唤醒
wait_for_completion_interruptible(struct completion *c); //可中断的wait_for_completion
unsigned long wait_for_completion_timeout(struct completion *x,unsigned long timeout);  //带超时处理的wait_for_completion
4)唤醒完成量
void complete(struct completion *c);   //只唤醒一个等待的执行单元。
void complete_all(struct completion *c);   //唤醒所有等待这个完成量的执行单元

NORET_TYPE void complete_and_exit(struct completion *comp, long code)
}

http://guojing.me/linux-kernel-architecture/posts/completion/


完成量（completion）机制基于等待队列，内核利用这个机制等待某一个操作结束，这两种机制使用得都比较频繁，主要用于设备的驱动程序。
                    完成量与信号量有些相似，但完成量是基于等待队列实现的。

我们只感兴趣完成量的接口。在场景中有两个参与者，一个在等待某操作的完成，而另一个在操作完成时发出声明，
实际上，这已经被简化过了。
实际上，可以有任意数目的进程等待操作完成，为表示进程等待的即将完成的『某操作』，内核使用了complietion数据结构，代码如下：
<kernel/completion.h>

struct completion {
    unsigned int done;
    wait_queue_head_t wait;
};

我们可以看到wait变量是一个wait_queue_head_t结构体，是等待队列链表的头，
            done是一个计数器。每次调用completion时，该计数器就加1，仅当done等于0时，wait_for系列函数才会使调用进程进入睡眠。
            实际上，这意味着进程无需等待已经完成的事件。
其中wait_queue_head_t已经在等待队列中记录过了，代码如下：
<linux/wait.h>

struct __wait_queue_head {
    spinlock_t lock;
    struct list_head task_list;
};
typedef struct __wait_queue_head wait_queue_head_t;

init_completion()函数用于初始化一个动态分配的completion实例，而DECLARE_COMPLETION宏用来建立该数据结构的静态实例。init_completion()函数代码如下：

<kernel/completion.h>

static inline void init_completion(struct completion *x)
{
    x->done = 0;
    init_waitqueue_head(&x->wait);
}

从上面代码中可以看到，初始化完成量会将done字段初始化为0，并且初始化wait链表。进程可以用wait_for_completion添加到等待队列，进程在其中等待，
并以独占睡眠状态直到请求被内核的某些部分处理，这些函数都需要一个completion


----------------------------------------------------------------------------------------

completion()
{
linux/completion.h
struct completion;

问题描述：
    内核编程中常见的一种模式是，在当前线程之外初始化某个活动，然后等待该活动的结束，这个活动可能是，
    创建一个新的内核线程或者新的用户空间进程、对一个已有进程的某天请求、或者某种类型的硬件动作。
    编程模式： 
    struct semaphore sem;
    init_MUTEX_LOCKED(&sem);
    start_external_task(&sem);
    dowm(&sem);
    当外部任务完成其工作时，将调用up(&sem);
    但信号量并不是适用这种情况的最好工具，在通常的使用中，试图锁定某个信号量的代码会发现该信号几乎总是可用：
    而如果存在针对该信号的严重竞争，性能受到影响。

机制描述：
completion：是一种轻量级的机制，它允许一个线程告诉另一个线程某个工作已经完成。
一个completion通常是一个单次设备；也就是说，他只会被使用一次然后就被丢弃。
如果仔细处理：completion结构也可以被重复使用。INIT_COMPLETION快速对一个completion进行初始化。
completion机制典型使用是模块退出时的内核线程终止。在这种原型中，某些驱动程序的内部工作由一个内部线程在while(1)循环中完成，
当内核准备清除该模块时，exit函数会告诉该线程退出并等待completion。为了实现这个目的，内核包含了可用于这种线程的一个特殊函数
void complete_and_exit(struct completion *comp, long code)

静态声明
DECLARE_COMPLETION(work)   创建completion（声明+初始化）
动态声明
struct completion x;       动态声明completion 结构体
void init_completion(struct completion *x)  动态初始化completion


void wait_for_completion(struct completion *x);  等待completion
要等待completion，进行如上待用。该函数执行一个非中断的等待。如果代码调用了wait_for_completion且没有人会完成该任务，
则将产生一个不杀死的进程。

int wait_for_completion_interruptible(struct completion *x);
int wait_for_completion_killable(struct completion *x);
unsigned long wait_for_completion_timeout(struct completion *x,unsigned long timeout);
long wait_for_completion_interruptible_timeout(struct completion *x, unsigned long timeout);
long wait_for_completion_killable_timeout(struct completion *x, unsigned long timeout);
bool try_wait_for_completion(struct completion *x);
bool completion_done(struct completion *x);

通常进程在等待事件的完成时处于不可中断状态，但如果使用wait_for_completion_interruptible可以改变这一设置，
如果进程被中断，则函数返回-ERESTARTSYS，否则返回0.

wait_for_completion_timeout等待一个完成事件发送，但提供了超时的设置，如果等待时间超过了这一设置，则取消等待。这有助于防止无限等待某一时间，
如果在超时之间就已经完成，函数就返回剩余时间，否则就返回0。
wait_for_completion_interruptible_timeout是前两种的结合体。

在请求由内核的另一部分处理之后，必须调用complete或者complete_all来唤醒等待的进程。因为每次调用只能从完成量的等待队列移除一个进程，
对n个等待进程来说，必须调用函数n次。另一方面，complete_all会唤醒所有等待该完成的进程。

void complete(struct completion *);
void complete_all(struct completion *);
实际的completion事件可通过调用下面的函数之一来触发。
这两个函数在是否有多个线程在等待相同的completion事件上有所不同。
complete只会唤醒一个等待线程；
complete_all允许唤醒所有等待线程。

NORET_TYPE void complete_and_exit(struct completion *comp, long code)
/*如果未使用completion_all，completion可重复使用；否则必须使用以下函数重新初始化completion*/
INIT_COMPLETION(struct completion c);/*快速重新初始化completion*/
}
