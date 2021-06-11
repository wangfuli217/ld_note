static __init int helper_init(void)    
 {    
   //创建一个单线程的共享列队    
    helper_wq = create_singlethread_workqueue("kthread");    
    BUG_ON(!helper_wq);    
    return 0;    
}    
core_initcall(helper_init);
//就是这个共享列队kthread_create会定义一个工作，在工作内创建创建具体的线程。

struct kthread_create_info    
{    
    /* Information passed to kthread() from keventd. */    
    int (*threadfn)(void *data);              //线程处理函数    
    void *data;                               //线程参数    
    struct completion started;                //在工作中等待kernel_thread创建线程完成，线程创建完后线程会通知工作继续。    
    
    /* Result passed back to kthread_create() from keventd. */    
    struct task_struct *result;                // started当收到线程创建完信号started后，用来存放创建的任务结构体    
    struct completion done;                   // 工作者线程加入一个工作后会等待工作做完，这个工作只是创建线程。     
    struct work_struct work;                  // 创建线程的工作，具体工作看后面源码    
};

/**  
 * kthread_create - 创建一个线程.  
 * @threadfn: the function to run until signal_pending(current).  
 * @data: data ptr for @threadfn.  
 * @namefmt: printf-style name for the thread.  
 *  
 * 描述：这个帮助函数创建并命名一个内核线程，线程创建后并不运行，使用wake_up_process() 函数来运行，参考kthread_run(), kthread_create_on_cpu()  
 *  
  *被唤醒后，线程调用threadfn()函数data作为参数，如果是独立线程没有其他线程调用 kthread_stop()那么可以直接使用do_exit()，或当检测到kthread_should_stop()返回真时（kthread_stop()已被调用了）返回处理函数 ，  应返回0或负数，返回值会传给 kthread_stop()返回。  
 */    
struct task_struct *kthread_create(int (*threadfn)(void *data),  void *data, const char namefmt[], ...)    
{    
    struct kthread_create_info create;    
    
        //下面五行初始化kthread_create_info    
    create.threadfn = threadfn;                                                
    create.data = data;    
    init_completion(&create.started);    
    init_completion(&create.done);    
    INIT_WORK(&create.work, keventd_create_kthread); //可见创建的工作是在keventd_create_kthread函数内进行    
    
    /*The workqueue needs to start up first:*/    
    if (!helper_wq)                                                               //这个系统启动后正常是已经初始化了的    
        create.work.func(&create.work);                          //如没初始化那只有在当前进程下完成工作了而不是在kthread 里    
    else {    
        queue_work(helper_wq, &create.work);               //将工作加入列队并调度    
        wait_for_completion(&create.done);                    //等待工作执行完，执行完后create.result返回创建的任务结构或错误，由于工作是在kthread 里执行所以必须等待工作做完才能返回    
    }    
    if (!IS_ERR(create.result)) {    
        va_list args;    
        va_start(args, namefmt);    
        vsnprintf(create.result->comm, sizeof(create.result->comm),    
              namefmt, args);    
        va_end(args);    
    }    
    
    return create.result;    
}
//上面看到创建工作是在keventd_create_kthread函数里，那么看下keventd_create_kthread函数
/* We are keventd: create a thread.   这个函数工作在keventd内核线程中*/    
static void keventd_create_kthread(struct work_struct *work)    
{    
    struct kthread_create_info *create =container_of(work, struct kthread_create_info, work);    
    int pid;    
    
    /* We want our own signal handler (we take no signals by default)*/    
        /*我们使用自己的信号处理，默认不处理信号*/    
        pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);//在这里创建函数，线程处理函数为kthread函数,参数为struct kthread_create_info指针create。    
    
    if (pid < 0) {    
        create->result = ERR_PTR(pid);    
    } else {    
        wait_for_completion(&create->started);  //等待创建的线程执行，线程执行后会发送完成信号create->started    
        read_lock(&tasklist_lock);    
        create->result = find_task_by_pid(pid);    
        read_unlock(&tasklist_lock);    
    }    
    complete(&create->done);    
}
//这时kthread_create在等待create->done信号，内核线程keventd在等待线程创建完create->started。上面创建了线程，处理函数为kthread

static int kthread(void *_create)    
{    
    struct kthread_create_info *create = _create;    
    int (*threadfn)(void *data);    
    void *data;    
    sigset_t blocked;    
    int ret = -EINTR;    
    
    kthread_exit_files();    
    
    /* Copy data: it's on keventd's stack */    
    threadfn = create->threadfn;    
    data = create->data;    
    
    /* Block and flush all signals (in case we're not from keventd). 阻塞全部信号*/    
    sigfillset(&blocked);    
    sigprocmask(SIG_BLOCK, &blocked, NULL);    
    flush_signals(current);    
    
    /* By default we can run anywhere, unlike keventd. 允许线程在任意CPU上运行 keventd值在1个CPU上运行*/    
    set_cpus_allowed(current, CPU_MASK_ALL);    
    
    /* OK, tell user we're spawned, wait for stop or wakeup */    
    __set_current_state(TASK_INTERRUPTIBLE);    
    complete(&create->started);                              //这里通知keventd完成线程初始化，keventd收到后获取新线程的任务结构，然后发出工作完成的信号后kthread_create返回。    
    schedule();    
    
    if (!kthread_should_stop())                                  //判断先前是否调用过kthread_stop    
        ret = threadfn(data);                                         //这里才真正执行定义的线程函数    
    
    /* It might have exited on its own, w/o kthread_stop.  Check. */    
    if (kthread_should_stop()) {                                //判断是否执行过kthread_stop    
        kthread_stop_info.err = ret;                            //ret是线程函数的返回，后面会经过kthread_stop函数返回    
        complete(&kthread_stop_info.done);             //如执行过kthread_stop 还要通知kthread_stop线程完成结束了，如果用户定义的处理函数使用了do_exit那么就不会通知kthread_stop，造成kthread_stop一直等待。    
    }    
    return 0;    
}
//至此我们看到kthread_create是如何创建线程，和线程是如何工作的了

struct kthread_stop_info    
{    
    struct task_struct *k;           //要停止的线程结构    
    int err;                                  //返回值    
    struct completion done;      //线程完成结束的等待信号    
};    
/* Thread stopping is done by setthing this var: lock serializes multiple kthread_stop calls. */    
/* 线程结束锁 kthread_stop在整个系统内一次只能被一个线程调用*/    
static DEFINE_MUTEX(kthread_stop_lock);    
static struct kthread_stop_info kthread_stop_info;

/**  
 * kthread_should_stop - should this kthread return now?  
 * When someone calls kthread_stop() on your kthread, it will be woken  
 * and this will return true.  You should then return, and your return  
 * value will be passed through to kthread_stop().  
 */    
int kthread_should_stop(void)    
{    
    return (kthread_stop_info.k == current);    
}

//这个函数在kthread_stop()被调用后返回真，当返回为真时你的处理函数要返回，返回值会通过kthread_stop()返回。
//所以你的处理函数应该有判断kthread_should_stop然后退出的代码。

/**  
 * kthread_stop - stop a thread created by kthread_create().  
 * @k: thread created by kthread_create().  
 *  
 * Sets kthread_should_stop() for @k to return true, wakes it, and  
 * waits for it to exit.  Your threadfn() must not call do_exit()  
 * itself if you use this function!  This can also be called after  
 * kthread_create() instead of calling wake_up_process(): the thread  
 * will exit without calling threadfn().  
 *  
 * Returns the result of threadfn(), or %-EINTR if wake_up_process()  
 * was never called.  
 */    
int kthread_stop(struct task_struct *k)    
{    
    int ret;    
    mutex_lock(&kthread_stop_lock);                                                            //系统一次只能处理一个结束线程申请    
    /* It could exit after stop_info.k set, but before wake_up_process. */    
    get_task_struct(k); //增加线程引用计数                                         
    /* Must init completion *before* thread sees kthread_stop_info.k */    
    init_completion(&kthread_stop_info.done);    
    smp_wmb();    
    /* Now set kthread_should_stop() to true, and wake it up. */    
    kthread_stop_info.k = k;//设置了这个之后 kthread_should_stop()  会返回真    
    wake_up_process(k);      //不管线程有没运行 先叫醒再说（如果已经唤醒过并结束了，该线程是唤醒不了的，这样会造成后面一直等待kthread_stop_info.done信号），即便没运行叫醒后也不会运行用户定义的函数。    
    put_task_struct(k);    
    /* Once it dies, reset stop ptr, gather result and we're done. */    
    wait_for_completion(&kthread_stop_info.done);//等待线程结束    
    kthread_stop_info.k = NULL;                
    ret = kthread_stop_info.err;                                 //返回值      
    mutex_unlock(&kthread_stop_lock);    
    return ret;    
}

//注意如果调用了kthread_stop你的处理函数不能调用do_exit()，函数返回你处理函数的返回值，如果创建的线程还没调用过wake_up_process()那么会返回-EINTR .