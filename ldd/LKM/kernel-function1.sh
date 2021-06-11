

在Linux kernel中，
0号进程是scheduler，
1号进程是init/systemd（所有user thread的祖先），
2号进程是[kthreadd]（所有kernel thread的父进程）。

kthread(kernel_thread)
{
         内核线程（thread）或叫守护进程(daemon)，在操作系统中占据相当大的比例，当Linux操作系统启动以后，你可以用
"ps -ef"命令查看系统中的进程，这时会发现很多以”d”结尾的进程名，确切说名称显示里面加 "[]"的，这些进程就是内核线程。

内核线程：进行繁忙的异步事务处理，也可以睡眠等待某事件的发生。
内核线程和用户进程相似，唯一不同的是内核线程位于内核空间并可以访问内核函数和数据结构。

ksoftirqd：内核线程是实现软中的助手，软中断是由中断发起的可以被延后执行的底半步进程，这里的基本思想是让中断处理程序中的代码越少越好，
系统屏蔽中断的时间会越短，时延越低，ksoftirqd的工作是确保高负荷情况下，软中断既不会空闲，又不至于压垮系统，在对称多处理器上，多个线程实力可以
并行第运行在不同的处理器上。为了提高吞吐量，系统为每个CPU都创建一个ksoftirqd线程[ksoftirqd/n 其中n代表了CPU序号]

ksoftirqd是一个在主机处于沉重的软中断负载情况下运行的针对每个cpu的内核线程。软中断通常服务于一个硬件中断的返回，但是有可能软中断会比它们所服务
的对象更快地触发。如果一个软中断正在被处理时候又一次触发，则ksoftirq服务就被触发在进程的上下文中处理这个软中断。如果ksoftirqd占用了超出了CPU
时间中少量百分比，就表明主机处于严重的软中断负载中。

kevent/n:其中n代表CPU序号，线程实现了工作队列，它是另一种的内核中延后执行的手段，内核中期待延迟执行工作的程序可以创建自己的工作队列。或者使用
默认的event/n工作者线程。

kpdflush 对高速缓存中的脏页进行回写
bdflush和kupdated是2.4内核中高速缓存中的脏页进行回写的实现
kjournald是通用的内核日志线程
khubd用来监视USB集线器

ret = kernel_thread(mythread, NULL, CLONE_FS|CLONE_FILES|CLONE_SIGHAND|SIGCHLD);
kthreadd:内核线程的父线程，用于僵死线程回收。
}

kthread_queue(内核线程、等待队列、线程状态)
{
加入等待队列：add_wait_queue() remove_wait_queue() 
唤醒等待线程：wake_up_interruptible()
设置县城状态：set_current_state()

1. 加入等待队列；设置线程状态，进行线程调度
2. 唤醒通知；非SIGKILL类型的唤醒通知。

##################### 内核线程、等待队列、线程状态 #########################
add_wait_queue(&myevent_waitqueue, &wait);
for(;;)
{
/* ....  */
set_current_state(TASK_INTERRUPTIBLE);
schedule()
/* Point A */
/* ... ... */

}
set_current_state(TASK_RUNNING);
remove_wait_queue(&myevent_waitqueue, &wait);

}

run_umode_handler(call_usermodehelper用户模式辅助程序)
{

内核支持这种机制：向用户模式的进程发送请求，让其执行某些程序。run_umode_handler()通过调用call_usermodehelper()使用了这种机制。
内核中mdev用户态进程 echo /sbin/mdev > /proc/sys/kernel/hotplug
/sys/kernel/uevent_helper
}


kernel(双向链表 散列链表 工作队列 通知链 完成接口 kthread辅助接口)
{

##################### 双向链表 散列链表 工作队列 通知链 #########################
双向链表 list_head
INIT_LIST_HEAD               初始化表头                              
list_add                     在表头后增加一个元素                    hlist_add_head(struct hlist_node *n, struct hlist_head *h)
list_add_tail                在链表尾部增加一个元素                  hlist_add_before |　hlist_add_after
list_del                     从链表尾中删除一个元素                  hlist_move_list
list_replace                 用另一个元素替代元表中的某一个元素      hlist_del(struct hlist_node *n)
list_entry                   遍历链表中的所有节点                    hlist_entry
list_for_each_entry          简化的链表递归接口                      hlist_for_each(pos, head)
list_for_each_entry_safe                                             hlist_for_each_safe(pos, n, head)
list_empty                   检查链表是否为空                        hlist_empty
list_splice                  将两个链表联合起来                      
INIT_LIST_HEAD               初始化表头                              INIT_HLIST_HEAD
LIST_HEAD_INIT               {&{name}, &{name}}                      HLIST_HEAD_INIT
LIST_HEAD                    静态初始化表头                          HLIST_HEAD
list_for_each_entry(pos, head, member) 遍历链表中每个元素            hlist_for_each_entry(tpos, pos, head, member)


散列链表 hlist_head hlist_node   ### http://blog.csdn.net/hs794502825/article/details/24597773
//hash桶的头结点  
struct hlist_head {  
    struct hlist_node *first;//指向每一个hash桶的第一个结点的指针  
};  
//hash桶的普通结点  
struct hlist_node {  
    struct hlist_node *next;//指向下一个结点的指针  
    struct hlist_node **pprev;//指向上一个结点的next指针的地址  
};
hlist_head结构体只有一个域，即first。 first指针指向该hlist链表的第一个节点。
hlist_node结构体有两个域，next 和pprev。 next指针很容易理解，它指向下个hlist_node结点，倘若该节点是链表的最后一个节点，next指向NULL。
pprev是一个二级指针， 它指向前一个节点的next指针的地址。

如果hlist_node采用传统的next,prev指针，对于第一个节点和后面其他节点的处理会不一致。这样并不优雅，而且效率上也有损失。
hlist_node巧妙地将pprev指向上一个节点的next指针的地址，由于hlist_head的first域指向的结点类型和hlist_node指向的下一个结点的结点类型相同，
这样就解决了通用性！
删除第一个普通结点和删除非第一个普通结点的代码是一样的。


工作队列：是内核中用于进行延后工作的一种方式。 wrokqueue_struct work_struct
    1. 1个错误中断发生后，触发网络适配器重新启动
    2. 同步磁盘缓冲区的文件系统任务
    3. 给磁盘发送一个命令，并跟踪存储协议状态机
   
1. 1.创建一个工作队列(或一个workqueue_struct)，该工作队列于一个或多个内核线程关联，可以使用create_singlethread_workqueue()创建一个
     服务于workqueue_struct的内核线程，为了在系统中的每个CPU上创建一个工作者线程，可以使用create_workqueue()变体。另外，内核中也
     存在默认的针对每个CPU的工作者线程 (event/n, n是CPU序号)，可以分时共享 这个线程，而不是创建一个单独的工作者线程。
   2. 创建一个工作元素(或者一个work_struct)，使用INIT_WORK可以初始化一个work_struct，填充它的工作函数的地址和参数。
   3. 将工作 元素提交给工作线程。可以通过queue_work()将work_struct提交给一个专用的create_singlethread_workqueue()，或通过
      schedule_work提交给默认的内核工作者线程。
    
通知链：可用于将状态改变信息发送给请求这些变化的代码段。与硬编码不同，通知是一项在感兴趣的事件产生时获得告警的.
    1. 死亡通知：当内核触发了陷阱和错误时发送死亡通知。
    2. 网络设备通知：当一个网络接口卡启动或关闭的时候发送该通知
    3. CPU频率通知：当处理器的频率发生跳变的时候，会分发一通知
    4. 因特网地址通知：当侦查到网络接口卡的IP地址发生改变的时候，会发送此通知。
阻塞通知链：通知事件处理函数总是在进程上下文被调用，因此可以进入睡眠状态。
原子通知链：如果通知处理函数允许从中断上下文调用，需要原子通知链。

wait_for_completion
complete
completeall

完成接口：内核中的许多地方会激发某些单独的执行线程，之后等待他们完成。完成接口是一个充分的、简单的此类编程的实现模式。
     驱动模块中包含一个辅助内核线程，当卸载这个模块时，在模块的代码从内核空间被移除之前，release函数被调用。释放例程要求内核线程退出，并且
在线程退出前一直保持阻塞状态
     假设编写块设备驱动程序中将设备读请求排队的部分。这激活了以单独线程或工作队列方式实现的一个状态机的变更，而驱动程序本身想一直等到该
操作完成后再执行下一次操作，driver/block/floppy.c就是这样一个例子。
     一个应用程序请求模拟数字转换器驱动程序完成一次数据采样，该驱动程序初始化了一个转换请求，接下来一直等待转换完成的中断产生，并返回转换后的数据。

     
kthread辅助接口：kthread为原始的线程创建例程添加了一层"外衣"，由此简化了线程管理的任务。
kthread_create = kernel_thread + daemonize
kthread允许自由地调用内建的、由完成接口所实现的退出同步机制。因此，可以直接点用kthread_stop()，而不必再设置pink_slip、唤醒
my_thread()并使用wait_for_completion()等待它的完成。
}
    
kthread_create_kernel_thread(kthread_create和kernel_thread的区别和总结)
{
    kthread_should_stop()返回should_stop标志。它用于创建的线程检查结束标志，并决定是否退出。线程完全可以在完成自己的工作后主动结束，
不需等待should_stop标志。

该函数定义在include/linux/kthread.h中，与其相关的还有：
struct task_struct kthread_run(int (*threadfn)(void *data), void *data,constchar namefmt[],...);
int kthread_stop(struct task_struct *k);

    kthread_run()负责内核线程的创建，参数包括入口函数 threadfn，参数data，线程名称namefmt。可以看到线程的名字可以是类似sprintf方式组成
的字符串。如果实际看到 kthread.h文件，就会发现kthread_run实际是一个宏定义，它由kthread_create()和wake_up_process() 两部分组成，
这样的好处是用kthread_run()创建的线程可以直接运行，使用方便。
    kthread_stop()负责结束创建的线程，参数是创建时返回的task_struct指针。kthread设置标志should_stop，并等 待线程主动结束，返回线程的
返回值。线程可能在kthread_stop()调用前就结束。

上面分析了kthread_create和kernel_thread的代码的不同部分，其中也提到了几点不同，现在总结一下：
（1）最重要的不同：kthread_create创建的内核线程有干净的上那上下文环境，适合于驱动模块或用户空间的程序创建
     内核线程使用，不会把某些内核信息暴露给用户程序
（2）二者创建的进程的父进程不同： kthread_create创建的进程的父进程被指定为kthreadd, 而kernel_thread创建的进程
     可以是init或其他内核线程。
}


错误处理助手：
IS_ERR和PTR_ERR

ksoftirqd pdflushd khubd内核线程代码分别位于kernel/softirq.c mm/pdflush.c和drivers/usb/core/hub.c文件
在kernel/exit.c文件中可以找到daemonize().以用户模式助手实现的代码可以见kernel/exit.c文件。
kernel/workqueue.c 参见drivers/net/wireless/ipw2200.c


wait_queue_t        include/linux/wait.h        内核线程欲等待某事件或系统资源时使用 
list_head           include/linux/list.h        用于构建双向链表数据结构的内核结构体 
hlist_head          include/linux/list.h        用于实现散列列表的内核结构体 
work_struct         include/linux/workqueue.h   实现工作队列，它是一种在内核中进行延后工作的方式 
notifier_block      include/linux/notifier.h    实现通知链，用于将状态变化信息发送给请求此变更的代码段 
completion          include/linux/completion.h  用于开始某线程活动并等待它们完成。 
     
DECLWAR_WAITQUEUE       inlcue/linux/wait.h               定义等待队列
add_wait_queue          kernel/wait.c                     将一个任务加入一个等待队列，该任务进入睡眠状态，直到它被另一个线程或中断处理函数唤醒
remove_wait_queue       kernel/wait.c                     从等待队列中删除任务
wake_up_interruptible   inlcue/linux/wait.h               唤醒一个正在等待队列中睡眠的任务，将返回调度器的运行队列
schedule                kernel/sched.h                    放弃CPU，然内核的其他部分运行
set_current_state       include/linux/sched.h             如下状态的一种：TASK_RUNNING、TASK_INTERRUPTIBLE、TASK_UNINTERRUPTIBLE、
                                                          TASK_STOPPED、TASK_TASKTRACED、EXIT_ZOMBIE、EXIT_DEAD
kernel_thread           arch/your-arch/kernel/process.c   创建内核线程
deamonize                        kernel/exit.c                       激活内核线程，并将调用线程的父线程改为ktheadd
allow_signal                     kernel/exit.c                       使能某指定信号的分发
signal_pending                   include/linux/sched.h               检查是否有信号已经被传送，在内核中没有信号处理函数，因此不得不显示地检查信号是否已分发
call_usermodehelper              include/linux/kmod.h kernel/kmod.c  执行用户模式的程序
register_die_notifier            arch/your-arch/kernel/trap.c        注册死亡通知链
register_netdevice_notifier      net/core/dev.c                      注册网络通知链
register_inetaddr_notifier       net/ipv4/devinet.c                  注册inetaddr通知链
BLOCKING_NOTIFIER_HEAD           include/linux/notifier.h            创建用户定义的阻塞性的通知
blocking_notifier_chain_register kernel/sys.c                        注册阻塞性的通知
blocking_notifier_call_chain     kernel/sys.c                        将事件分发给阻塞的通知链
ATOMIC_NOTIFIER_HEAD             include/linux/notifier.h            创建原子性的通知
atomic_notifier_chain_register   kernel/sys.c                        注册原子性的通知
DECLARE_COMPLETION               include/linux/completion.h          静态定义完成实例
init_completion                  include/linux/completion.h          动态定义完成实例
complete                         kernel/sched.c                      宣布完成
wait_for_completion              kernel/sched.c                      一直等待完成实例的完成
complete_and_exit                kernel/exit.c                       原子性的通知完成并退出
kthread_create                   kernel/sched.c                      创建内核线程
kthread_stop                     kernel/sched.c                      让一个内核线程停止
kthread_should_stop              kernel/sched.c                      内核县城可以使用该函数轮询是否其他的执行单元已经调用kthread_stop让其停止
IS_ERR                           include/linux/err.h                 查看返回值是否是一个错误码



内存启动始于执行arch/x86/boot目录中的实模式汇编代码，查看arch/x86/kernel/setup_32.c文件可以看出
保护模式的内核怎么样获取实模式内核收集的信息。

第一条信息来自init/main.c中的代码，深入挖掘int/calibrate.c可以对BogoMIPS校准理解的更清楚，而
/include/asm-your-arch/bugs.h则包含体系架构相关的检查。

内核中的时间服务由驻留于arch/your-arh/kernel中的体系架构相关的部分和实现于kernel/timer.c中的通用部分组成。
从include/linux/time*.h都文件中可以获取相关的定义。

jiffies定义于linux/jiffise.h文件中，HZ的值与处理器相关，可以从include/asm-your-arch/param.h找到。
内存管理源代码存放在顶层mm目录中。

     
     
     









