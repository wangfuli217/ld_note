
kthread_create VS kernel_thread
上面分析了kthread_create和kernel_thread的代码的不同部分，其中也提到了几点不同，现在总结一下：
（1）最重要的不同：kthread_create创建的内核线程有干净的上那上下文环境，适合于驱动模块或用户空间的程序创建内核线程使用，不会把某些内核信息暴露给用户程序
（2）二者创建的进程的父进程不同： kthread_create创建的进程的父进程被指定为kthreadd, 而kernel_thread创建的进程可以是init或其他内核线程。


 rest_init()
 {
    Linux内核在完成初始之后，会把控制权交给应用程序。只有当硬件中断、软中断、异常等发生时，CPU才会从用户空间切换到
内核空间来执行相应的处理，完成后又回来用户空间。
    如果内核需要周期性地做一些事情（比如页面的换入换出，磁盘高速缓存的刷新等），又该怎么办呢？内核线程（内核进程）
可以解决这个问题。
    内核线程(kernel thread)是由内核自己创建的线程，也叫做守护线程(deamon)。在终端上用命令”ps -Al”列出的所有进程中，
名字以k开关以d结尾的往往都是内核线程，比如kthreadd、kswapd。

内核线程与用户线程的相同点是：
    1. 都由do_fork()创建，每个线程都有独立的task_struct和内核栈；
    2. 都参与调度，内核线程也有优先级，会被调度器平等地换入换出。
不同之处在于：
    1. 内核线程只工作在内核态中；而用户线程则既可以运行在内核态，也可以运行在用户态；
    2. 内核线程没有用户空间，所以对于一个内核线程来说，它的0~3G的内存空间是空白的，它的current->mm是空的，
       与内核使用同一张页表；而用户线程则可以看到完整的0~4G内存空间。

    在Linux内核启动的最后阶段，系统会创建两个内核线程，一个是init，一个是kthreadd。其中init线程的作用是运行文件系统
上的一系列”init”脚本，并启动shell进程，所以init线程称得上是系统中所有用户进程的祖先，它的pid是1。kthreadd线程是内核
的守护线程，在内核正常工作时，它永远不退出，是一个死循环，它的pid是2。

    内核初始化工作的最后一部分是在函数rest_init()中完成的。在这个函数中，主要做了4件事情，分别是：
1. 创建init线程，
2. 创建kthreadd线程，
3. 执行schedule()开始调度，
4. 执行cpu_idle()让CPU进入idle状态。

在内核线程创建过程中还有两个有趣的细节值得说一下：
    1. 虽然init线程是在kthreadd之前创建的，pid也比较小，但是在schedule()的时候，最先被选中先运行的是kthreadd。
       这不会有任何影响，因为kthreadd总会让出CPU，init线程一定能启动。
    2. 进程号PID的分配是从0开始的，但是在”ps”命令中看不到0号进程。这是因为0号pid被分给了“启动”内核进程，就是完成
       了系统引导工作的那个进程。在函数rest_init()中，0号进程在创建完成了init和kthreadd两个内核线程之后，
       调用schedule()使得pid=1和2的两个线程得以启动，但是pid=0的线程并不参与调度，所以这个进程就再也得不到运行了。
       
 }
 
kthreadd(API)
{
   1. 所有其它的内核线程的 ppid 都是 2，也就是说它们都是由 kthreadd thread 创建的
   2. 所有的内核线程在大部分时间里都处于阻塞状态(TASK_INTERRUPTIBLE)只有在系统满足进程需要的某种资源的情况下
      才会运行.
      
创建一个内核 thread 的接口函数是:
kthread_create()
kthread_run()   
    这两个函数的区别就是 kthread_run() 函数中封装[ kthread_run()负责内核线程的创建，它由kthread_create()和
wake_up_process()两部分组成，这样的好处是用kthread_run()创建的线程可以直接运行。]了前者，由 kthread_create() 
创建的 thread 不会立即运行，而后者创建的 thread 会立刻运行，原因是在 kthread_run() 中调用了 wake_up_process().  

    如果你要让你创建的 thread 运行在指定的 cpu 上那必须用前者(因为它创建的 thread 不会运行)，然后再用 kthread_bind()
完成绑定，最后 wake up.

int kthread_stop(struct task_struct *k);
int kthread_should_stop(void);
    kthread_stop()负责结束创建的线程，参数是创建时返回的task_struct指针。kthread设置标志should_stop，并等待线程主动结束，
返回线程的返回值。在调用 kthread_stop()结束线程之前一定要检查该线程是否还在运行（通过 kthread_run 返回的 task_stuct 
是否有效），否则会造成灾难性的后果。kthread_run的返回值tsk。不能用tsk是否为NULL进行检查，而要用IS_ERR()宏定义检查，
这是因为返回的是错误码，大致从0xfffff000~0xffffffff。

kthread_should_stop()返回should_stop标志（参见 struct kthread ）。它用于创建的线程检查结束标志，并决定是否退出。

    kthread() (注：原型为：static int kthread(void *_create) )的实现在kernel/kthread.c中，头文件是include/linux/kthread.h。
内核中一直运行一个线程kthreadd，它运行kthread.c中的kthreadd函数。在kthreadd()中，不断检查一个kthread_create_list链表。
kthread_create_list中的每个节点都是一个创建内核线程的请求，kthreadd()发现链表不为空，就将其第一个节点退出链表，
并调用create_kthread()创建相应的线程。create_kthread()则进一步调用更深层的kernel_thread()创建线程，入口函数设在kthread()中。
      
   外界调用kthread_stop()删除线程。kthread_stop首先设置结束标志should_stop，然后调用wake_for_completion(&kthread->exited)上，
这个其实是新线程task_struct上的vfork_done，会在线程结束调用do_exit()时设置。

}