static __init int helper_init(void)    
 {    
   //����һ�����̵߳Ĺ����ж�    
    helper_wq = create_singlethread_workqueue("kthread");    
    BUG_ON(!helper_wq);    
    return 0;    
}    
core_initcall(helper_init);
//������������ж�kthread_create�ᶨ��һ���������ڹ����ڴ�������������̡߳�

struct kthread_create_info    
{    
    /* Information passed to kthread() from keventd. */    
    int (*threadfn)(void *data);              //�̴߳�����    
    void *data;                               //�̲߳���    
    struct completion started;                //�ڹ����еȴ�kernel_thread�����߳���ɣ��̴߳�������̻߳�֪ͨ����������    
    
    /* Result passed back to kthread_create() from keventd. */    
    struct task_struct *result;                // started���յ��̴߳������ź�started��������Ŵ���������ṹ��    
    struct completion done;                   // �������̼߳���һ���������ȴ��������꣬�������ֻ�Ǵ����̡߳�     
    struct work_struct work;                  // �����̵߳Ĺ��������幤��������Դ��    
};

/**  
 * kthread_create - ����һ���߳�.  
 * @threadfn: the function to run until signal_pending(current).  
 * @data: data ptr for @threadfn.  
 * @namefmt: printf-style name for the thread.  
 *  
 * ���������������������������һ���ں��̣߳��̴߳����󲢲����У�ʹ��wake_up_process() ���������У��ο�kthread_run(), kthread_create_on_cpu()  
 *  
  *�����Ѻ��̵߳���threadfn()����data��Ϊ����������Ƕ����߳�û�������̵߳��� kthread_stop()��ô����ֱ��ʹ��do_exit()���򵱼�⵽kthread_should_stop()������ʱ��kthread_stop()�ѱ������ˣ����ش����� ��  Ӧ����0����������ֵ�ᴫ�� kthread_stop()���ء�  
 */    
struct task_struct *kthread_create(int (*threadfn)(void *data),  void *data, const char namefmt[], ...)    
{    
    struct kthread_create_info create;    
    
        //�������г�ʼ��kthread_create_info    
    create.threadfn = threadfn;                                                
    create.data = data;    
    init_completion(&create.started);    
    init_completion(&create.done);    
    INIT_WORK(&create.work, keventd_create_kthread); //�ɼ������Ĺ�������keventd_create_kthread�����ڽ���    
    
    /*The workqueue needs to start up first:*/    
    if (!helper_wq)                                                               //���ϵͳ�������������Ѿ���ʼ���˵�    
        create.work.func(&create.work);                          //��û��ʼ����ֻ���ڵ�ǰ��������ɹ����˶�������kthread ��    
    else {    
        queue_work(helper_wq, &create.work);               //�����������жӲ�����    
        wait_for_completion(&create.done);                    //�ȴ�����ִ���ִ꣬�����create.result���ش���������ṹ��������ڹ�������kthread ��ִ�����Ա���ȴ�����������ܷ���    
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
//���濴��������������keventd_create_kthread�������ô����keventd_create_kthread����
/* We are keventd: create a thread.   �������������keventd�ں��߳���*/    
static void keventd_create_kthread(struct work_struct *work)    
{    
    struct kthread_create_info *create =container_of(work, struct kthread_create_info, work);    
    int pid;    
    
    /* We want our own signal handler (we take no signals by default)*/    
        /*����ʹ���Լ����źŴ���Ĭ�ϲ������ź�*/    
        pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);//�����ﴴ���������̴߳�����Ϊkthread����,����Ϊstruct kthread_create_infoָ��create��    
    
    if (pid < 0) {    
        create->result = ERR_PTR(pid);    
    } else {    
        wait_for_completion(&create->started);  //�ȴ��������߳�ִ�У��߳�ִ�к�ᷢ������ź�create->started    
        read_lock(&tasklist_lock);    
        create->result = find_task_by_pid(pid);    
        read_unlock(&tasklist_lock);    
    }    
    complete(&create->done);    
}
//��ʱkthread_create�ڵȴ�create->done�źţ��ں��߳�keventd�ڵȴ��̴߳�����create->started�����洴�����̣߳�������Ϊkthread

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
    
    /* Block and flush all signals (in case we're not from keventd). ����ȫ���ź�*/    
    sigfillset(&blocked);    
    sigprocmask(SIG_BLOCK, &blocked, NULL);    
    flush_signals(current);    
    
    /* By default we can run anywhere, unlike keventd. �����߳�������CPU������ keventdֵ��1��CPU������*/    
    set_cpus_allowed(current, CPU_MASK_ALL);    
    
    /* OK, tell user we're spawned, wait for stop or wakeup */    
    __set_current_state(TASK_INTERRUPTIBLE);    
    complete(&create->started);                              //����֪ͨkeventd����̳߳�ʼ����keventd�յ����ȡ���̵߳�����ṹ��Ȼ�󷢳�������ɵ��źź�kthread_create���ء�    
    schedule();    
    
    if (!kthread_should_stop())                                  //�ж���ǰ�Ƿ���ù�kthread_stop    
        ret = threadfn(data);                                         //���������ִ�ж�����̺߳���    
    
    /* It might have exited on its own, w/o kthread_stop.  Check. */    
    if (kthread_should_stop()) {                                //�ж��Ƿ�ִ�й�kthread_stop    
        kthread_stop_info.err = ret;                            //ret���̺߳����ķ��أ�����ᾭ��kthread_stop��������    
        complete(&kthread_stop_info.done);             //��ִ�й�kthread_stop ��Ҫ֪ͨkthread_stop�߳���ɽ����ˣ�����û�����Ĵ�����ʹ����do_exit��ô�Ͳ���֪ͨkthread_stop�����kthread_stopһֱ�ȴ���    
    }    
    return 0;    
}
//�������ǿ���kthread_create����δ����̣߳����߳�����ι�������

struct kthread_stop_info    
{    
    struct task_struct *k;           //Ҫֹͣ���߳̽ṹ    
    int err;                                  //����ֵ    
    struct completion done;      //�߳���ɽ����ĵȴ��ź�    
};    
/* Thread stopping is done by setthing this var: lock serializes multiple kthread_stop calls. */    
/* �߳̽����� kthread_stop������ϵͳ��һ��ֻ�ܱ�һ���̵߳���*/    
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

//���������kthread_stop()�����ú󷵻��棬������Ϊ��ʱ��Ĵ�����Ҫ���أ�����ֵ��ͨ��kthread_stop()���ء�
//������Ĵ�����Ӧ�����ж�kthread_should_stopȻ���˳��Ĵ��롣

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
    mutex_lock(&kthread_stop_lock);                                                            //ϵͳһ��ֻ�ܴ���һ�������߳�����    
    /* It could exit after stop_info.k set, but before wake_up_process. */    
    get_task_struct(k); //�����߳����ü���                                         
    /* Must init completion *before* thread sees kthread_stop_info.k */    
    init_completion(&kthread_stop_info.done);    
    smp_wmb();    
    /* Now set kthread_should_stop() to true, and wake it up. */    
    kthread_stop_info.k = k;//���������֮�� kthread_should_stop()  �᷵����    
    wake_up_process(k);      //�����߳���û���� �Ƚ�����˵������Ѿ����ѹ��������ˣ����߳��ǻ��Ѳ��˵ģ���������ɺ���һֱ�ȴ�kthread_stop_info.done�źţ�������û���н��Ѻ�Ҳ���������û�����ĺ�����    
    put_task_struct(k);    
    /* Once it dies, reset stop ptr, gather result and we're done. */    
    wait_for_completion(&kthread_stop_info.done);//�ȴ��߳̽���    
    kthread_stop_info.k = NULL;                
    ret = kthread_stop_info.err;                                 //����ֵ      
    mutex_unlock(&kthread_stop_lock);    
    return ret;    
}

//ע�����������kthread_stop��Ĵ��������ܵ���do_exit()�����������㴦�����ķ���ֵ������������̻߳�û���ù�wake_up_process()��ô�᷵��-EINTR .