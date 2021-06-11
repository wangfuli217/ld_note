等待队列在内核中有着极其重要的作用，作为异步操作，他的实现简单而又强大。

waitqueue(API)
{
1) wait_queue_head_t my_queue;    //定义等待队列头
2) init_waitqueue_head(&my_queue);    //初始化队列头
   如果觉得上边两步来的麻烦，可以直接使用DECLARE_WAIT_QUEUE_HEAD(name)

   定义和初始化的快捷方式: DECLARE_WAIT_QUEUE_HEAD(my_queue);   
   
3) DECLARE_WAITQUEUE(name,tsk);    //定义并初始化一个名为name的等待队列(wait_queue_t);

3.1) init_waitqueue_entry和DEFINE_WAIT： 初始化wait_queue_t实例
        除了将进程休眠添加到队列里中，内核提供了两个标准方法可用于初始化一个动态分配的wait_queue_t实例，
    分别为init_waitqueue_entry和宏DEFINE_WAIT。

4) void fastcall add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);         未设置进程状态
   void fastcall remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);      回收add_wait_queue等待块
    用于将等待队列wait添加到等待队列头指向的等待队列链表中。                       
                                                                                   
    void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);     设置了进程的状态
    //将我们的等待队列入口添加到队列中，并设置进程的状态。
    void finish_wait(wait_queue_head_t *queue, wait_queue_t *wait);                就到了清理时间
相比于remove_wait_queue；
1. finish_wait会设置当前进程状态为TASK_RUNNING，
2. finish_wait会判断等待队列当前是否为空，以进行删除操作否  
    
5)  等待事件
    wait_event(queue, conditon);
    wait_event_interruptible(queue, condition);//可以被信号打断
    wait_event_timeout(queue, condition, timeout);
    wait_event_interruptible_timeout(queue, condition, timeout);//不能被信号打断
    queue:作为等待队列头的等待队列被唤醒
    conditon：必须满足，否则阻塞
    timeout和conditon相比，有更高优先级， 以jiffy为单位

6)  void wake_up(wait_queue_head_t *queue);
    void wake_up_interruptible(wait_queue_head_t *queue);
    上述操作会唤醒以queue作为等待队列头的所有等待队列中所有属于该等待队列头的等待队列对应的进程。
     wake_up()               <--->    wait_event()
                                      wait_event_timeout()
     wake_up_interruptible() <--->    wait_event_interruptible()  
                                      wait_event_interruptible_timeout()
     wake_up()可以唤醒处于TASK_INTERRUPTIBLE和TASK_UNINTERRUPTIBLE的进程
     wake_up_interruptble()只能唤醒处于TASK_INTERRUPTIBLE的进程。

7)  sleep_on(wait_queue_head_t *q);
    interruptible_sleep_on(wait_queue_head_t *q);
     
    sleep_on作用是把目前进程的状态置成TASK_UNINTERRUPTIBLE,并定义一个等待队列，之后把他附属到等待队列头q，
直到资源可用，q引导的等待队列被唤醒。interruptible_sleep_on作用是一样的， 只不过它把进程状态置为TASK_INTERRUPTIBLE.
    这两个函数的流程是首先，定义并初始化等待队列，把进程的状态置成TASK_UNINTERRUPTIBLE或TASK_INTERRUPTIBLE，
并将对待队列添加到等待队列头。
    sleep_on()               <--->   wake_up()
    interruptible_sleep_on() <--->   wake_up_interruptible()

    然后通过schedule(放弃CPU,调度其他进程执行。最后，当进程被其他地方唤醒，将等待队列移除等待队列头。
    在Linux内核中，使用set_current_state()和__add_wait_queue()函数来实现目前进程状态的改变，直接使用current->state = TASK_UNINTERRUPTIBLE

类似的语句也是可以的。
}

waitqueue(休眠)
{
------ 休眠 ------
1. 永远不要在原子上下文中进入休眠。
   在执行多个步骤时，不能有任何的并发访问，这意味着，对休眠来说，我们的驱动程序不能在拥有自旋锁、seqlock或者RCU锁时休眠。
2. 如果我们已经禁止了中断，也不能休眠。
3. 在拥有信号量时休眠是合法的，但是必须仔细检查拥有信号量时休眠的代码。 
   如果代码在拥有信号量时休眠，任何其他等待该信号量的线程也休眠，因此任何拥有信号量而休眠的代码必须很短，而且还要确保该信号量并不会阻塞最终会唤醒我们自己的那个进程。

1. 当我们被唤醒时，我们永远无法知道休眠了多长时间或者休眠期间都发生了那些事情。
   我们通常也无法知道是否还有其他进程在同一事件上休眠，这个进程可能会在我们之前被唤醒并将我们等待的资源拿走。
   这样，我们对唤醒之后的状态不能做任何假定，因此必须检查以确保我们等待的条件真正为真。

2. 除非我们知道有其他人会在其他地方唤醒我们，否则进程不能休眠。

DECLARE_WAITQUEUE(name, tsk) 	//静态创建

wait_queue_head_t q；
init_waitqueue_head(&q)；		//动态创建
}

waitqueue(休眠机制说明){
---- 休眠机制说明 ----
1、 当进程休眠时，他将期待某个条件未来成为真。也即：当一个休眠进程被唤醒时，它必须再次检查他所等待的条件的确为真。
     Linux内核中最简单的休眠方式时称为wait_enent的宏。
2、 调用wait_event在任务休眠前后都要对该表达式进行求值；
3、 在条件为真之前，进行会保持休眠。注意：该条件可能会被多次求值，因此对该表达式的求值不能带来任何副作用。
4、 在实践中，约定做法是在使用wait_event时使用wake_up，而在使用wait_event_interruptible时使用wake_up_interruptilbe。

5、 TASK_RUNNIG表示进程可运行，尽管进程并不一定在任何给定时间都运行在某特处理器上。
    TASK_INTERRUPTIBLE:可信号中断休眠
	TASK_UNINTERRUPTIBLE：不可信号中断休眠
	
	通过void set_current_state(int new_state); 或者 
	current->state = TASK_INTERRUPTIBLE 设置进程处于休眠。该方法改变了进程状态，但是尚未使进程让出(schedule())处理器。
	
}

waitqueue(interface)
{
---- 简单休眠 ----
#define wait_event(wq, condition) 	
#define wait_event_interruptible(wq, condition)	  -ERESTARTSYS(整数值，非零表示休眠被某个信号中断)
#define wait_event_timeout(wq, condition, timeout)	
#define wait_event_interruptible_timeout(wq, condition, timeout) -ERESTARTSYS
wq：等待队列头  值传递
condition：布尔表达式 为真唤醒；为假休眠
timeout：以jiffy表示。

返回值：整数值。 非零表示休眠被某特信号中断。 零表示被唤醒。  
        condition条件下返回：当给定的时间到期时，都会返回0值，而无论condition如何求值。
---- 简单唤醒 ----		
void wake_up(wait_queue_head_t *queue);                 唤醒等待在给定queue上的所有进程。
void wake_up_interruptilbe(wait_queue_head_t *queue);	只会唤醒哪些执行可中断休眠的进程。


---- 高级休眠 ----	
void set_current_state(int new_state); 或
current->state = TASK_INTERRUPTIBLE
if(condtion)
	schedule();  ## timeo = schedule_timeout(timeo);

---- 手工休眠 ----	
DEFINE_WAIT(my_wait);	//建立并初始化一个等待队列入口  静态创建
wait_queue_t my_wait;	//建立并初始化一个等待队列入口  动态创建
init_wait(&my_wait);
	
void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);  //将我们的等待队列入口添加到队列中，并设置进程的状态。
q和wait分别是等待队列头和进程入口。
state是进程的新状态；TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE
在调用 prepare_to_wait 之后，进程即刻调用schedule();当然在这之前，应确保仍有必要等待。
一旦schedule()返回，就到了清理时间了。这个工作也可通过下面的特殊函数完成：
void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);

将scull中pipe.c文件中读操作和写操作。  这个比较固化!!!! 
	

---- 独占等待 ----
独占等待 VS 休眠等待
1. 等待队列入口设置了WQ_FLAG_EXCLUSIVE标志时，则会被添加到等待队列的尾部，而没有这个标志的入口被添加到头部。
2. 在某个等待队列上调用wake_up时，他会在唤醒第一个具有WQ_FLAG_EXCLUSIVE标志的进程之后停止唤醒其他进程。
最终结果是，执行独占等待的进程每次只会唤醒其中一个(以某种有序的方式)，从而不会产生"疯狂兽群"问题，但是，内核每次仍然会唤醒所有非独占等待的进程。

独占等待使用条件：
1. 对某个资源存在严重竞争。
2. 唤醒某个进程就能完整消耗掉该资源。

void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state); 来替换prepare_to_wait
注意，使用wait_event及其变种无法执行独占等待。

---- 高级唤醒 ----
int default_wake_function(wait_queue_t *wait, 
	unsigned mode, int flags, void *key); #将进程设置为可运行状态，并且如果该进程具有更高的优先级，则会执行一次上下文切换以便切换到该进程。

	
#define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL) 
唤醒队列上所有非独占等待的进程，以及单个独占等待者(如果存在)。
#define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
只会唤醒nr个等待进程，而不是只有一个。注意：传递0标明请求唤醒所有的等待进程，而不是唤醒任何一个。
#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
全部唤醒
#define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL)

#define wake_up_interruptible(x)	__wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
唤醒队列上所有非独占等待的进程，以及单个独占等待者(如果存在)。跳过不可中断休眠的那些进程。
#define wake_up_interruptible_nr(x, nr)	__wake_up(x, TASK_INTERRUPTIBLE, nr, NULL)
只会唤醒nr个独占等待进程，而不是只有一个。注意：传递0标明请求唤醒所有的独占等待进程，而不是唤醒任何一个。
#define wake_up_interruptible_all(x)	__wake_up(x, TASK_INTERRUPTIBLE, 0, NULL)
全部唤醒
#define wake_up_interruptible_sync(x)	__wake_up_sync((x), TASK_INTERRUPTIBLE, 1)
通常，被唤醒的进程可能会抢占当前的进程，并在wake_up返回前被调度到处理器上。换句话说，对wake_up的调用可能不是原子的。
如果调用wake_up的进程运行在原子上行文(例如拥有自旋锁，或者一个中断处理例程)中，则重新调度就不会发送。通常这是一个适当的保护。

建议不要调用：
extern void sleep_on(wait_queue_head_t *q);
extern long sleep_on_timeout(wait_queue_head_t *q,
				      signed long timeout);
extern void interruptible_sleep_on(wait_queue_head_t *q);
extern long interruptible_sleep_on_timeout(wait_queue_head_t *q,
					   signed long timeout);
sleep_on没有提供对竟态的任何保护方法。在代码决定休眠及sleep_on真正作用之间，总有一个窗口，而窗口期间出现的唤醒将会被丢失。为此，调用
sleep_on的代码整体是不安全。
}

instance(睡眠等待某个条件发生  条件为假时睡眠)
{
睡眠方式：wait_event, wait_event_interruptible
            唤醒方式：wake_up (唤醒时要检测条件是否为真，如果还为假则继续睡眠，唤醒前一定要把条件变为真)
}

instance(手工休眠方式一 建立并初始化一个等待队列项)
{
1)建立并初始化一个等待队列项
    DEFINE_WAIT(my_wait) <==> wait_queue_t my_wait; init_wait(&my_wait);
2)将等待队列项添加到等待队列头中，并设置进程的状态
    prepare_to_wait(wait_queue_head_t *queue, wait_queue_t *wait, int state)
3)调用schedule()，告诉内核调度别的进程运行
4)schedule返回，完成后续清理工作
    finish_wait()
}

instance(手工休眠方式一 建立并初始化一个等待队列项)
{
3. 手工休眠方式二：

1)建立并初始化一个等待队列项：
    DEFINE_WAIT(my_wait) <==> wait_queue_t my_wait; init_wait(&my_wait);
2)将等待队列项添加到等待队列头中：
    add_wait_queue
3)设置进程状态
    __set_current_status(TASK_INTERRUPTIBLE);
4) schedule()
5)将等待队列项从等待队列中移除
    remove_wait_queue()
    
其实，这种休眠方式相当于把手工休眠方式一中的第二步prepare_to_wait拆成两步做了，即prepare_to_wait <====>add_wait_queue + __set_current_status，其他都是一样的。               
}

instance(sleep_on)
{
4. 老版本的睡眠函数sleep_on(wait_queue_head_t *queue)：
    将当前进程无条件休眠在给定的等待队列上，极不赞成使用这个函数，因为它对竞态没有任何保护机制。
}

html(http://guojing.me/linux-kernel-architecture/posts/wait-queue/)
{

------  数据结构  ------
------ wait_queue_head_t
每个等待队列都有一个队列的头，我们可以看看等待队列的代码：
<linux/wait.h>

struct __wait_queue_head {
    spinlock_t lock;
    struct list_head task_list;
};
typedef struct __wait_queue_head wait_queue_head_t;

因为等待队列也可以在中断的时候修改，在操作队列之前必须获得一个自旋锁，task_list是一个双链表，用于实现双联表最擅长表示的结构，就是队列：

------ __wait_queue - init_waitqueue_entry & 宏DEFINE_WAIT
<linux/wait.h>

struct __wait_queue {
    unsigned int flags;
#define WQ_FLAG_EXCLUSIVE   0x01
    void *private;
    wait_queue_func_t func;
    struct list_head task_list;
};

我们可以看到链表__wait_queue中的各个字段，其字段意义如下：

字段 		说明
flags 		为WQ_FLAG_EXCUSIVE或为0，WQ_FLAG_EXCUSIVE表示等待进程想要被独占地唤醒
private 	是一个指针，指向等待进程的task_struct实例，这个变量本质上可以指向任意的私有数据
func 		等待唤醒进程
task_list 	用作一个链表元素，用于将wait_queue_t实例防止到等待队列中

为了使当前进程在一个等待队列中睡眠，需要调用wait_event函数。进程进入睡眠，将控制权释放给调度器。内核通常会在向块设备发出传输数据的请求后
调用这个函数，因为传输不会立即发送，而在此期间又没有其他事情可做，所以进程就可以进入睡眠，将CPU时间交给系统中的其他进程。

在内核中的另一处，例如，来自块设备的数据到达后，必须调用wake_up函数来唤醒等待队列中的睡眠进程。在使用wait_event让进程睡眠后，必须确保在
内核的另一块一定有一个对应的wake_up调用，这是必须的，否则睡眠的进程永远无法醒来。


------  进程睡眠  ------  add_wait_queue & prepare_to_wait & DEFINE_WAIT_FUNC[autoremove_wake_function]
                  ------  sleep_on & wait_event_interruptible & wait_event_interruptible_timeout & wait_event_timeout
add_wait_queue函数用于将一个进程增加到等待队列，这个函数必须要获得自旋锁，在获得自旋锁之后，将工作委托给__add_wait_queue。
<linux/wait.h>

static inline void __add_wait_queue(
    wait_queue_head_t *head,
    wait_queue_t *new)
{
    list_add(&new->task_list, &head->task_list);
}

在将新进程统计到等待队列的时候，除了使用list_add函数并没有其他的工作要做，内核还提供了add_wait_queue_exclusive函数，
它的工作方式和这个函数相同，但是将进程插入到链表的尾部，并将其设置为WQ_EXCLUSIVE标志。

让进程在等待队列上进入睡眠的另一种方法是prepare_to_wait，在这个函数中还需要进程的状态，代码如下：
<kernel/wait.c>
void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
{
    unsigned long flags;
    /* 将进程添加到等待队列的尾部
     * 这种实现确保在混合访问类型的队列中
     * 首先唤醒所有的普通进程
     * 然后才考虑到对内核堆栈进程的限制
     */
    wait->flags &= ~WQ_FLAG_EXCLUSIVE;
    // 创建一个自旋锁
    spin_lock_irqsave(&q->lock, flags);
    if (list_empty(&wait->task_list))
        // 添加到链表中
        __add_wait_queue(q, wait);
    set_current_state(state);
    // 解锁一个自旋锁
    spin_unlock_irqrestore(&q->lock, flags);
}
EXPORT_SYMBOL(prepare_to_wait);


除了将进程休眠添加到队列里中，内核提供了两个标准方法可用于初始化一个动态分配的wait_queue_t实例，分别为init_waitqueue_entry和宏DEFINE_WAIT。
<linux/wait.h>

static inline void init_waitqueue_entry(
    wait_queue_t *q,
    struct task_struct *p)
{
    q->flags = 0;
    q->private = p;
    q->func = default_wake_function;
}

default_wake_function只是一个进行参数转换的前端，然后使用try_to_wake_up函数来唤醒进程。

宏DEFINE_WAIT创建wait_queue_t的静态实例：
<linux/wait.h>

#define DEFINE_WAIT_FUNC(name, function)
    wait_queue_t name = {
        .private    = current,
        .func       = function,
        .task_list  = LIST_HEAD_INIT((name).task_list),
    }

#define DEFINE_WAIT(name) \
    DEFINE_WAIT_FUNC(name, autoremove_wake_function)

这里用autoremove_wake_function来唤醒进程，这个函数不仅调用default_waike_function将所述等待队列从等待队列删除。
add_wait_queue通常不直接使用，我们更经常使用wait_event，这是一个宏，代码如下：

<linux/wait.h>
#define wait_event(wq, condition)
do {
    if (condition)
        break;
    __wait_event(wq, condition);
} while (0)

这个宏等待一个条件，会确认这个条件是否满足，如果条件已经满足，就可以立即停止处理，因为没有什么可以继续等待的了，然后将工作交给__wait_event。

<linux/wait.h>
#define __wait_event(wq, condition)
do {
    DEFINE_WAIT(__wait);
    for (;;) {
        prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);
        if (condition)
            break;
        schedule();
    }
    finish_wait(&wq, &__wait);
} while (0)

使用DEFINE_WAIT建立等待队列的成员之后，这个宏产生一个无限循环。使用prepare_to_wait使进程在等待队列上睡眠。每次进程被唤醒时，
内核都会检查指定的条件是否满足，如果条件满足，就退出无线循环，否则将控制权交给调度器，进程再次睡眠。

在条件满足时，finish_wait将进程状态设置回TASK_RUNNING，并从等待队列的链表移除对应项。


除了wait_event之外，内核还定义了其他几个函数，可以将当前进程置于等待队列中，实现等同于sleep_on。

<linux/wait.h>
#define wait_event_interruptible(
    wq, condition)
({
    int __ret = 0;
    if (!(condition))
        __wait_event_interruptible(
            wq, condition, __ret
        );
    __ret;
})

wait_event_interruptible使用的进程状态为TASK_INTERRUPTIBLE，因而睡眠进程可以通过接收信号而唤醒。
<linux/wait.h>

#define wait_event_interruptible_timeout(
    wq, condition, timeout)
({
    long __ret = timeout;
    if (!(condition))
        __wait_event_interruptible_timeout(
            wq, condition, __ret
        );
    __ret;
})

wait_event_interruptible_timeout让进程睡眠，但可以通过接受信号唤醒，它注册了一个超时限制。
<linux/wait.h>

#define wait_event_timeout(wq, condition, timeout)
({
    long __ret = timeout;
    if (!(condition))
        __wait_event_timeout(
            wq, condition, __ret
        );
    __ret;
})

wait_event_timeout等待满足指定的条件，但如果等待时间超过了指定的超时限制，那么就停止，这防止了永远睡眠的情况。


------  唤醒进程  ------  wake_up_poll &  wake_up_locked_poll & wake_up_interruptible_poll & wake_up_interruptible_sync_poll

唤醒进程的过程比较简单，内核定义了一些列的宏用户唤醒进程。
<linux/wait.h>

#define wake_up_poll(x, m)
    __wake_up(x, TASK_NORMAL, 1, (void *) (m))

#define wake_up_locked_poll(x, m)
    __wake_up_locked_key((x), TASK_NORMAL, (void *) (m))

#define wake_up_interruptible_poll(x, m)
    __wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))

#define wake_up_interruptible_sync_poll(x, m)
    __wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))

在获得了用户保护等待队列首部的锁之后，_wake_up将工作委托给_wake_up_common，代码如下：
<linux/wait.h>

static void __wake_up_common(
    wait_queue_head_t *q, unsigned int mode,
    int nr_exclusive, int wake_flags, void *key)
{
    wait_queue_t *curr, *next;
    // 反复扫描链表，直到没有更多需要唤醒的进程
    list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
        unsigned flags = curr->flags;

        if (curr->func(curr, mode, wake_flags, key) &&
                (flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
                /* 检查唤醒进程的数目是否达到了nr_exclusive
                 * 避免所谓的惊群问题
                 * 如果几个进程在等待独占访问某一资源
                 * 那么同时唤醒所有的等进程时没有意义的
                 * 因为除了其中的一个进程之外
                 * 其他的进程都会再次进入睡眠
                 */
            break;
    }
}

q用于选定等待队列，而mode指定进程的状态，用于控制唤醒进程的条件，nr_exclusive表示将要唤醒的设置了WQ_FLAG_EXCLUSIVE标志的进程的数目。
从上面的注释可以看出nr_exclusive是非常有用的，这个数字表示检查唤醒进程的数目是否达到了nr_exclusive，从而避免所谓的惊群的问题。

惊群问题是，当需要唤醒进程的时候，不需要将所有等待某一资源的进程全部唤醒，因为即便全部唤醒，也只能有一个进程需要唤醒，而其他的进程都要再次
进入睡眠，这是非常浪费资源的，更不要说每次进程唤醒都会出现这样的问题。

但并不是说所有的进程都不能同时被唤醒，如果进程在等待的数据传输结束，那么唤醒等待队列中的所有进程是可行的，因为这几个进程的数据可以同时
读取而不会被干扰。
}

