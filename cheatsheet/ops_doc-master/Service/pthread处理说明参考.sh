http://man7.org/articles/index.html

https://github.com/luoxn28/ThinkInTechnology/issues/5

https://www.ibm.com/developerworks/cn/linux/l-cn-mthreadps/index.html
https://www.ibm.com/developerworks/cn/linux/thread/posix_thread1/index.html
https://www.ibm.com/developerworks/cn/linux/l-threading.html

POSIX 线程详解
Posix线程编程指南

线程创建：
1、 屏蔽不予处理的信号；
2、 配置僵死线程回收方式：detach还是join; 如果是join方式，pthread_cancel、pthread_join的调用；
                                                          pthread_exit、  pthread_join的调用；
3、 设置栈空间大小

                                                                                                             通知线程
线程间通信：
1、 初始化pthread_mutex_init、pthread_cond_init、以及相关的全局变量（链表）调用pthread_mutex_lock；  加锁          添加数据      信号通知             解锁
2、 测试全局变量或链表是否有数据，如果while为空阻塞在pthread_cond_wait;              阻塞状态； pthread_mutex_lock 添加数据 pthread_cond_signal pthread_mutex_unlock
                                                          等待通知
3、 调用pthread_mutex_unlock；获取全局变量数据，处理数据；调用pthread_mutex_lock更新状态；
            解锁                   处理数据                        解锁          更新状态
4、 重新进入步骤2.


消息队列：
1. 消息队列与直接线程间通信差异：
   消息队列可以指定为有限长度的消息队列，作为生产者的线程可能会被阻塞在消息队列的添加部分；而直接线程间通信不会这样。
   消息队列的消费者线程从消息队列中获取消息，获取过程有链表相关处理，在获取过程没有消息内容的处理。
   消息队列可以更好的模块化实现，也很容易实现线程池功能，而线程间通信就比较麻烦了。
   
////////////////////////////////////////////////////////////////////////////////////////////////////////
进程原语与线程原语的比较
进程原语    线程原语                描述
fork        pthread_create          创建新的控制流
exit        pthread_exit            从现有的控制流中退出
waitpid     pthread_join            从控制流中得到退出状态
atexit      pthread_cleanup_push    注册在退出控制流时调用的函数
getpid      pthread_self            获取控制流的ID
abort       pthread_cancel          请求控制流的非正常退出


pthread(信号量 互斥量 条件变量){
    信号量的主要目的是提供一种进程间同步的方式。这种同步的进程可以共享也可以不共享内存区。虽然信号量的意图
在于进程间的同步，互斥量和条件变量的意图在于线程间同步，但信号量也可用于线程间同步，互斥量和条件变量也可通
过共享内存区进行进程间同步。但应该根据具体应用考虑到效率和易用性进行具体的选择。

    互斥量必须由给它上锁的线程解锁。而信号量不需要由wait它的线程进行post，可以在其他进程进行post操作。
互斥量要么被锁住，要么是解开状态，只有这两种状态。而信号量的值可以支持多个进程成功进行wait操作。
    信号量的挂出操作总是被记住，因为信号量有一个计数值，post操作总会将该计数值加1，然而当向条件变量发送
一个信号时，如果没有线程等待在条件变量，那么该信号会丢失。
}

pthread(整体){
1. 线程之间具有不同的stack，具有相同的data和heap
2. 线程共享的属性：进程ID 父进程ID 进程组ID 会话ID 控制终端 用户和组ID 打开的文件描述符 
                   记录锁fcntl 信号处理函数signal|signation|sigwaitinfo|sigwait|sigtimedwait
                   创建文件模式umask 当前目录chdir 根目录chroot 定时器setitimer POSIX定时器 create_timer
                   优先级setpriority 资源限制setrlimit CPU使用计时times 资源统计getrusage
3. 线程独立的属性：线程ID pthread_t
                   信号掩码pthread_sigmask
                   错误值 errno
                   信号栈 sigaltstack
                   实时调度策略 sched_setscheduler 和优先级 sched_setparam
                   能力 capabilities
                   CPU粘性 sched_setaffinity
4. 线程返回值：多数线程函数成功返回0，失败返回错误值；线程调用失败不设置errno，线程函数调用返回一个错误值；
5. 线程ID： pthread_t pthread_create|pthread_self； 
            线程ID仅能保证进程内线程ID唯一，
            线程ID可以在其他线程终止后重新使用
6. 线程安全函数: 相同时间内在多个线程内调用同样的函数，返回同样的结果；
7. 异步终止安全函数：pthread_setcancelstate() | pthread_cancel() | pthread_setcanceltype()
8. 阻塞点： 
9. 编译： cc -pthread.
10. LinuxThreads特点：thread group
10. NPTL特点: thread group; 没有管理线程；使用两个实时信号；不具用相同的nice值； times和getrusage与定义不一致
11. getconf GNU_LIBPTHREAD_VERSION
}

pthread(接口函数){
线程管理：
$gcc  -pthread
#include<pthread.h>
pthread_self()/pthread_equal()                                      获得ThreadID
pthread_attr_init()/pthread_attr_setdetachstate()                   创建一个线程前设置      
pthread_create()                                                    创建一个线程          
pthread_detach()pthread_setcancelstate()/pthread_setcanceltype()    已有一个线程后设置 
void pthread_testcancel(void);                                      自己添加取消点    
pthread_kill()                                                      向线程发送一个信号       
void pthread_exit(void *retval)                                     退出线程但不退出进程  
pthread_cancel()                                                    终止另一个线程         
pthread_join()                                                      等待一个线程

线程状态：
pthread_equal(): 对两个线程的线程标识号进行比较
pthread_detach(): 分离线程
pthread_self(): 查询线程自身线程标识号
pthread_attr_getschedparam();获取线程优先级
pthread_attr_setschedparam();设置线程优先级

线程特有数据：
pthread_key_t key               创建用于保护线程私有资源的key
pthread_once_t once_key         创建用于初始化key的once_key,要求用PTHREAD_INIT_ONCE来赋值，否则结果不确定
pthread_key_create()            创建key
pthread_once()                  初始化key
pthread_getspedifc()            从key表中获得线程私有资源的地址
pthread_setspedifc()            将线程私有资源的地址放到key中

条件变量
#include<pthread.h>
pthread_t cond                                      准备条件变量
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;     初始化静态的条件变量
pthread_cond_init()                                 初始化一个动态的条件变量
pthread_cond_wait()                                 等待条件变量变为真
pthread_cond_timedwait()                            等待条件变量变为真，等待有时间限制。
pthread_cond_signal()                               至少唤醒一个等待该条件的线程
pthread_cond_broadcast()                            唤醒等待该条件的所有线程
pthread_cond_destroy()                              销毁一个条件变量

互斥量模型
#include <pthread.h>
//成功返回0,失败返回error number
#include <pthread.h>
int pthread_mutex_init  (pthread_mutex_t *mutex, const pthread_mutexattr_t *mutexattr);
int pthread_mutex_lock  (pthread_mutex_t *mutex);
int pthread_mutex_trylock   (pthread_mutex_t *mutex);
int pthread_mutex_unlock    (pthread_mutex_t *mutex);
int pthread_mutex_destroy   (pthread_mutex_t *mutex);

更改attr对象的函数
//成功返回0,失败返回error number
typedef struct{
    int                 detachstate;    线程的分离状态       
    int                 schedpolicy;    线程调度策略
    struct sched_param  schedparam;     线程的调度参数
    int                 inheritsched;   线程的继承性
    int                 scope;          线程的作用域
    size_t              guardsize;      线程栈末尾的警戒缓冲区大小
    int                 stackaddr_set;  线程的栈设置
    void *              stackaddr;      线程栈的位置
    size_t              stacksize;      线程栈的大小
}pthread_attr_t;

pthread_attr_setdetachstate(pthread_attr_t* attr, int detachstate)
pthread_attr_getdetachstate(const pthread_attr_t* attr, int* detachstate)
int detachstate;
    PTHREAD_CREATE_JOINABLE | PTHREAD_CREAT_DETACHED

pthread_attr_getdetachstate(&attr,&detachstate);
if(PTHREAD_CREATE_JOINABLE==detachstate)
    printf("1.PTHREAD_CREATE_JOINABLE\n");      
    

pthread_attr_setschedpolicy(pthread_attr_t *attr, int policy);
pthread_attr_getschedpolicy(const pthread_attr_t *attr, int *policy);
SCHED_OTHER     /   SCHED_FIFO  /   SCHED_RR

pthread_attr_setsschedchedparam(pthread_attr_t *attr, const struct sched_param *param);
pthread_attr_getschedparam(const pthread_attr_t *attr, struct sched_param *param);
struct sched_param {
    int sched_priority;// Scheduling priority，int sched_get_priority_max/sched_get_priority_min (int policy)
};

pthread_attr_setinheritsched(pthread_attr_t *attr, int inheritsched);
pthread_attr_getinheritsched(const pthread_attr_t *attr, int *inheritsched);
PTHREAD_INHERIT_SCHED       /    PTHREAD_EXPLICIT_SCHED

pthread_attr_setscope(pthread_attr_t *attr, int scope);
pthread_attr_getscope(const pthread_attr_t *attr, int *scope);
PTHREAD_SCOPE_SYSTEM        /   PTHREAD_SCOPE_PROCESS


pthread_attr_setguardsize ( pthread_attr_t *attr, size_t guardsize );
pthread_attr_getguardsize ( const pthread_attr_t *attr, size_t *guardsize );
>0              |   0
(默认1 page,当然还可以指定任意值)
}
https://www.ibm.com/developerworks/cn/linux/thread/posix_thread2/index.html
pthread(pthread_mutex_t){

}
https://www.ibm.com/developerworks/cn/linux/thread/posix_thread3/index.html
pthread(pthread_cond_t){
int pthread_cond_destroy(pthread_cond_t *cond); # 释放条件变量
1. 需要注意的是只有在没有线程在该条件变量上等待时，才可以注销条件变量，否则会返回EBUSY。
2. 注销一个线程不使用的条件变量，注销一个线程正在使用的条件变量将触发不可预知的问题。
int pthread_cond_init(pthread_cond_t *restrict cond, const pthread_condattr_t *restrict attr); # 初始化条件变量
1. 不能由多个线程同时初始化一个条件变量。当需要重新初始化或释放一个条件变量时，应用程序必须保证这个条件变量未被使用。
2. 初始化一个条件变量。当参数cattr为空指针时，函数创建的是一个缺省的条件变量。函数返回时，条件变量被存放在参数cv指向的内存中。
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

int pthread_cond_wait(pthread_cond_t *restrict cond, pthread_mutex_t *restrict mutex); # 阻塞在条件变量上
1. 函数将解锁mutex参数指向的互斥锁，并使当前线程阻塞在cv参数指向的条件变量上。
2. 被阻塞的线程可以被pthread_cond_signal函数，pthread_cond_broadcast函数唤醒，也可能在被信号中断后被唤醒。
3. pthread_cond_wait函数的返回并不意味着条件的值一定发生了变化，必须重新检查条件的值。
4. pthread_cond_wait函数返回时，相应的互斥锁将被当前线程锁定，即使是函数出错返回。
    一般一个条件表达式都是在一个互斥锁的保护下被检查。当条件表达式未被满足时，线程将仍然阻塞在这个条件变量上。
当另一个线程改变了条件的值并向条件变量发出信号时，等待在这个条件变量上的一个线程或所有线程被唤醒，接着都试图
再次占有相应的互斥锁。
    阻塞在条件变量上的线程被唤醒以后，直到pthread_cond_wait()函数返回之前条件的值都有可能发生变化。所以函数
返回以后，在锁定相应的互斥锁之前，必须重新测试条件值。最好的测试方法是循环调用pthread_cond_wait函数，并把满足
    条件的表达式置为循环的终止条件。如：
    pthread_mutex_lock();
    while (condition_is_false)
        pthread_cond_wait();
    pthread_mutex_unlock();
阻塞在同一个条件变量上的不同线程被释放的次序是不一定的。
    注意：pthread_cond_wait()函数是退出点，如果在调用这个函数时，已有一个挂起的退出请求，且线程允许退出，这个
线程将被终止并开始执行善后处理函数，而这时和条件变量相关的互斥锁仍将处在锁定状态。

int pthread_cond_signal(pthread_cond_t *cv); # 解除在条件变量上的阻塞
返回值：函数成功返回0；任何其他返回值都表示错误
函数被用来释放被阻塞在指定条件变量上的一个线程。
必须在互斥锁的保护下使用相应的条件变量。否则对条件变量的解锁有可能发生在锁定条件变量之前，从而造成死锁。
唤醒阻塞在条件变量上的所有线程的顺序由调度策略决定，如果线程的调度策略是SCHED_OTHER类型的，系统将根据线程的优先级唤醒线程。
如果没有线程被阻塞在条件变量上，那么调用pthread_cond_signal()将没有作用。

int pthread_cond_timedwait(pthread_cond_t *cv,
pthread_mutex_t *mp, const structtimespec * abstime); # 阻塞直到指定时间
返回值：函数成功返回0；任何其他返回值都表示错误
    函数到了一定的时间，即使条件未发生也会解除阻塞。这个时间由参数abstime指定。函数返回时，相应的互斥锁往往是锁定的，
即使是函数出错返回。
注意：pthread_cond_timedwait函数也是退出点。
超时时间参数是指一天中的某个时刻。使用举例：
pthread_timestruc_t to;
to.tv_sec = time(NULL) + TIMEOUT;
to.tv_nsec = 0;
超时返回的错误码是ETIMEDOUT。

int pthread_cond_broadcast(pthread_cond_t *cv); # 释放阻塞的所有线程
返回值：函数成功返回0；任何其他返回值都表示错误
    函数唤醒所有被pthread_cond_wait函数阻塞在某个条件变量上的线程，参数cv被用来指定这个条件变量。
当没有线程阻塞在这个条件变量上时，pthread_cond_broadcast函数无效。
    由于pthread_cond_broadcast函数唤醒所有阻塞在某个条件变量上的线程，这些线程被唤醒后将再次竞争
相应的互斥锁，所以必须小心使用pthread_cond_broadcast函数。

唤醒丢失问题
在线程未获得相应的互斥锁时调用pthread_cond_signal或pthread_cond_broadcast函数可能会引起唤醒丢失问题。
唤醒丢失往往会在下面的情况下发生：
    一个线程调用pthread_cond_signal或pthread_cond_broadcast函数；
    另一个线程正处在测试条件变量和调用pthread_cond_wait函数之间；
    没有线程正在处在阻塞等待的状态下。
}
pthread(pthread_cleanup){
线程可以安排它退出时需要调用的函数，这样的函数称为线程清理处理程序，线程可以建立多个清理处理程序。
处理程序记录在栈中，也就是说它们的执行顺序与它们注册时的顺序相反。
void pthread_cleanup_push(void (*routine)(void *), void *arg); # void(*rtn)(void *): 线程清理函数 注册
void pthread_cleanup_pop(int execute);                         #                                  清除
线程清理处理程序
pthread_cleanup_push来注册清理函数rtn,这个函数有一个参数arg。在以下三种情形之一发生时，注册的清理函数被执行：
　　1）调用pthread_exit。
　　2）作为对取消线程请求(pthread_cancel)的响应。
　　3）以非0参数调用pthread_cleanup_pop。
}
pthread(attr){
int pthread_attr_init(pthread_attr_t *attr);
int pthread_attr_destroy(pthread_attr_t *attr);

调度特性设置：pthread_setschedparam(), pthread_setschedprio(3), or pthread_create(3)
1. 调度特性 # pthread_setschedparam
int pthread_attr_setschedparam(pthread_attr_t *attr,
                              const struct sched_param *param);
int pthread_attr_getschedparam(pthread_attr_t *attr,
                                      struct sched_param *param);
struct sched_param { # sched_setscheduler 
           int sched_priority;     /* Scheduling priority */
       };
2. 调度特性 # sched_setscheduler
pthread_setschedparam(pthread_t thread, int policy,
                     const struct sched_param *param);
pthread_getschedparam(pthread_t thread, int *policy,
                             struct sched_param *param);
       
           
1. 栈缓冲区及大小
pthread_attr_setstack(pthread_attr_t *attr, void *stackaddr, size_t stacksize);
pthread_attr_getstack(const pthread_attr_t *attr, void **stackaddr, size_t *stacksize);
2. 栈大小
pthread_attr_setstacksize ( pthread_attr_t *attr, size_t size );
pthread_attr_getstacksize ( const pthread_attr_t *attr, size_t *size );
可能错误：PTHREAD_STACK_MIN (16384) 
}

pthread(joinable detached){
joinable：可连接的
detached：分离的 

int pthread_detach(pthread_t thread); # 设定线程时分离的 pthread_detach(pthread_self());
连接一个detach状态的线程，将触发不能确定的状态
int pthread_join(pthread_t thread, void **retval); # 连接一个线程；连接自身会存在不确定状态
  阻塞等待指定线程结束；如果指定线程已经结束；pthread_join会立刻返回；
  如果retval不为空，将pthread_exit的值返回给pthread_join; 如果pthread_cancel()终止线程，retval等于PTHREAD_CANCELED
  如果多个线程同时调用pthread_join获取一个thread_t线程的接收状态，结束状态未定义，其他线程可能仍处于阻塞状态。
  注意: 1. 成功调用pthread_create之后，pthread_join保证线程正常结束
        2. 连接一个已经被连接的线程，将使当前线程处于未知状态。
        3. 不连接一个执行结束的线程，将会产生一个zombie thread僵尸线程
        4. 在进程中的所有线程是等同的，任何线程可以pthread_join任何线程
  
1. 主线程处理各种信号，其他线程阻塞各种信号；当主线程接收到结束信号后，主线程通过全局变量或者条件变量方式，
   通知其他线程结束，主线程调用pthread_join阻塞等待其他线程终止;           # 整体框架性 -- 阻塞等待
   a. 主线程依次通知线程结束；依次调用pthread_join阻塞等待线程结束
   b. 主线程通知的线程是单实例线程；单实例线程往往绑定系统资源，线程会驻留到进程结束时刻。
2. 主线程创建线程池管理线程，线程池管理线程根据业务需求，创建子线程，执行业务，pthread_join阻塞等待子线程结束 # 非阻塞收死
   c. 线程池管理线程通过数据结构管理多实例子线程；线程往往不绑定系统资源，线程初始化和结束会阻塞在特定IO，且很少申请系统级别资源
   d. 线程池管理线程在线程接收以后才调用pthread_join函数，可以视为非阻塞情况；

int pthread_attr_setdetachstate(pthread_attr_t *attr, int detachstate);
int pthread_attr_getdetachstate(pthread_attr_t *attr, int *detachstate);
size： PTHREAD_CREATE_DETACHED | PTHREAD_CREATE_JOINABLE 默认值是PTHREAD_CREATE_JOINABLE

non-portable # 非标准，不可移植的
int pthread_tryjoin_np(pthread_t thread, void **retval);
int pthread_timedjoin_np(pthread_t thread, void **retval,
                        const struct timespec *abstime);
返回值0： 连接到终止的线程
EBUSY ： 没有连接到终止线程
ETIMEDOUT： 超时，没有连接到终止线程
从来不会返回EINTR错误
}
pthread_create(){
int pthread_create(pthread_t *thread, const pthread_attr_t *attr, # attr=NULL，使用默认值
                          void *(*start_routine) (void *), void *arg);
返回值：pthread_create返回一个int类型值，线程创建成功时返回0；其他值都表示创建线程发生错误。
第一个参数：pthread_t类型指针，实质上是将一个pthread_t变量的地址传递给函数，
            pthread_create函数将创建线程的ID写入该pthread_t变量，便可通过该pthread_t获得线程ID。
线程退出情况：1. pthread_exit() 退出； pthread_join() 获取返回状态；
              2. 从start_routine中return value 等同于pthread_exit(value)
              3. pthread_cancel
              4. 任何一个线程执行exit，或者主线程从main中退出。
1. 新建线程从创建者线程获得了信号掩码pthread_sigmask， 信号挂起状态pending是空的;
    capabilities和sched_setaffinity也是从创建者线程获得的
2. 初始的cpu-time等于0 (pthread_getcpuclockid)
3. /proc/sys/kernel/threads-max 和 RLIMIT_NPROC 影响线程创建

void pthread_exit(void *retval); # 终止被调用线程
1. 终止被调用线程，同时返回retval给另一个join线程；
2. 如果线程有任何thread-specific数据，清理函数将执行，执行顺序不可控；
3. retval值不要保留到线程栈中。

int pthread_cancel(pthread_t thread); # 给指定线程发送一个终止请求
终止方式的state和type；
state: pthread_setcancelstate (enabled|disabled)
1. 如果disabled了线程的cancellation，则cancellation请求则保留在队列中，直到线程处于enabled状态；
2. 如果线程处于enabled状态，cancelability的type决定了什么时候cancelability发生
type : pthread_setcanceltype  (asynchronous|deferred)
1. Asynchronous类型的cancellation决定线程可以在任何情况下终止
2. Deferred类型的cancelability线程只能在cancellation阻塞点被终止， 见 pthreads(7)
步骤： # asynchronously类型； 该功能在NPTL中使用实时信号实现。
1. Cancellation clean-up handlers被弹出执行。 pthread_cleanup_push(3)
2. 线程私有数据将被释放。 pthread_key_create(3)
3. 线程将被终止。 pthread_exit(3)

int pthread_setcancelstate(int state, int *oldstate); # PTHREAD_CANCEL_ENABLE | PTHREAD_CANCEL_DISABLE
int pthread_setcanceltype(int type, int *oldtype);    # PTHREAD_CANCEL_DEFERRED | PTHREAD_CANCEL_ASYNCHRONOUS
       
void pthread_testcancel(void);
在调用线程创建一个cancellation point。
}

https://www.ibm.com/developerworks/cn/linux/l-cn-signalsec/index.html
pthread(线程和信号){
每个线程都有自己的信号屏蔽字，但是信号的处理是进程中所有线程共享的。
进程中的信号是传递到单个线程的，进程中的信号屏蔽函数sigprocmask函数在线程中没有定义，线程中必须使用pthread_sigmask。
线程可以调用sigwait函数等待一个或者多个信发送。调用pthread_kill函数将信号发送到线程。
具体函数原型如下：
#include <signal.h>
int pthread_sigmask(int how, const sigset_t *set, sigset_t *oldset); 
成功返回0 否则返回错误值
   每个线程均有自己的信号屏蔽集（信号掩码），可以使用pthread_sigmask函数来屏蔽某个线程对某些信号的
   响应处理，仅留下需要处理该信号的线程来处理指定的信号。实现方式是：利用线程信号屏蔽集的继承关系
  （在主进程中对sigmask进行设置后，主进程创建出来的线程将继承主进程的掩码）
   
int sigwait(const sigset_t *set, int *sig);
线程等待set中的信号(任何一个即可)发生，若发生，设置*sig为已发生的信号，返回0。如果出错返回-1.
sigwait接收信号(将set中设定的信号从pending中移除掉)，即使去除阻塞信号集中信号掩码，也不会触发信号处理函数执行
注意：sigwait并不等待hander执行发生的信号相当于被sigwait截获，handler根本不会被调用执行。
      sigwait调用时自动取消mask中的信号掩码状态，直到有新得信号到达，返回时恢复线程的信号屏蔽字。
      
int sigwaitinfo(const sigset_t *set, siginfo_t *info);
如果已经有信号处于pending状态，那么sigwaitinfo会携带siginf_t信号信息立即返回。
与sigwait相比：sigwait返回一个信号值，sigwaitinfo返回信号描述符
               sigwait和sigwaitinfo两个函数返回值不同
sigtimedwait()比sigwaitinfo增加了一个超时参数；>1 信号值 =-1(EAGAIN:超时|EINTR:其他信号中断|EINVAL：错误参数)

int signalfd(int fd, const sigset_t *mask, int flags); 创建一个文件描述符来接收信号；
fd  : -1 创建一个新的文件描述符；!= -1 则为signalfd创建的文件描述符，mask替代已设置的mask
mask：指定要接收的信号
flags:  SFD_NONBLOCK|SFD_CLOEXEC
read:signalfd_siginfo对象；
fork，execve都继承此文件描述符。

sigsuspend(const sigset_t *mask)：设置阻塞信号为mask，等待其他信号(除mask之外的信号)的发生，
      若信号发生且对应的handler已执行，则sigsuspend返回-1，并设置相应的errno(EINTR)，进程的信号掩码恢复sigsuspend设置前状态
      若信号终止了程序运行，则sigsuspend被阻塞，不退出。
      注意：sigsuspend总是返回-1； SIGKILL和SIGSTOP被设置在掩码中秒，不影响进程对这两个信号的捕获。
            sigsuspend调用改变进程的信号掩码状态，阻塞mask中的信号，调用返回时将掩码改为调用前的状态
    sigprocmask(设置) -> pause(sigsuspend)阻塞 -> sigprocmask(恢复)
    
int pthread_kill(pthread_t thread, int sig); 给指定线程发送一个信号
int tkill(int tid, int sig);                 给指定线程发送一个信号
int tgkill(int tgid, int tid, int sig);      废弃
}
pthread(fork){
父进程调用fork为子进程创建了整个进程地址空间的副本，子进程从父进程那里继承了所有互斥量、读写锁和条件变量的状态。
如果父进程包括多个线程，子进程在fork返回以后，如果紧接着不马上调用exec的话，就需要清理锁。
在子进程内部只存在一个线程，它是由父进程中调用fork的线程的副本构成的，父进程中的线程占有锁，则子进程同样占有锁，但是子进程不包含占有锁的线程的副本。
通过pthread_atfork函数建立fork处理程序清除锁状态。函数原型如下：
int pthread_atfork(void (*prepare)(void), void (*parent)(void),void (*child)(void))
prepare处理程序由父进程在fork创建子进程前调用，获取父进程定义的所有锁。
parent处理程序在fork创建子进程以后，但在fork返回之前在父进程环境调用，对prepare处理程序获得的所有锁进行解锁，child处理程序在fork返回之前在子进程环境中调用，也必须释放prepare处理程序获得的所有锁。
parent和child处理程序与它们注册时顺序相同，prepare处理程序调用则与注册时的顺序相反。
}
sysconf(线程限制){
PTHREAD_DESTRUCTOR_ITERATIONS: 销毁一个线程数据最大的尝试次数，可以通过_SC_THREAD_DESTRUCTOR_ITERATIONS作为sysconf的参数查询。
PTHREAD_KEYS_MAX: 一个进程可以创建的最大key的数量。可以通过_SC_THREAD_KEYS_MAX参数查询。
PTHREAD_STACK_MIN: 线程可以使用的最小的栈空间大小。可以通过_SC_THREAD_STACK_MIN参数查询。
PTHREAD_THREADS_MAX:一个进程可以创建的最大的线程数。可以通过_SC_THREAD_THREADS_MAX参数查询
}
moosefs(线程创建和主线程分离，主要表现为信号处理函数)
{
    pthread_create(common|main.c)
    {
        封装了pthread_attr_init函数，可以初始化线程栈空间大小；封装了pthread_attr_setdetachstate函数，可以设定线程退出的方式；
        int main_minthread_create(pthread_t *th,uint8_t detached,void *(*fn)(void *),void *arg)
        封装了pthread_sigmask函数，使得线程该线程不执行被主线程注册的信号处理函数
        int main_thread_create(pthread_t *th,const pthread_attr_t *attr,void *(*fn)(void *),void *arg) 
    }
    pthread_create(mfsmount|main.c)
    {
        mfsmount的main_thread_create忽略了很多需要忽略的信号处理。其他没有差异。
            sigemptyset(&newset);                          初始化信号参数值
            sigaddset(&newset, SIGTERM);                   添加SIGTERM
            sigaddset(&newset, SIGINT);                    添加SIGINT
            sigaddset(&newset, SIGHUP);                    添加SIGHUP
            sigaddset(&newset, SIGQUIT);                   添加SIGQUIT
            pthread_sigmask(SIG_BLOCK, &newset, &oldset);  屏蔽SIGTERM、SIGINT、SIGHUP\SIGQUIT
            res = pthread_create(th,attr,fn,arg);          创建线程
            pthread_sigmask(SIG_SETMASK, &oldset, NULL);   恢复屏蔽信号
    }

}

pcqueue(消息队列)
{
void* queue_new(uint32_t size);                                                       创建指定长度的消息队列，当size为0的时候表示不指定长度的消息队列
void queue_delete(void *que);                                                         删除已创建的消息队列
void queue_close(void *que);                                                          清除被阻塞在消息队列的生产者线程统计和被阻塞在消息队列的消费者线程统计
                                                                                      queue_close设置了close关键字。使得后续queue_put和queue_get都会返回EIO的异常值。
int queue_isempty(void *que);                                                         消息队列是否为空
uint32_t queue_elements(void *que);                                                   消息队列中元素数量
int queue_isfull(void *que);                                                          消息队列是否为满
uint32_t queue_sizeleft(void *que);                                                   消息队列还可以添加多少元素
void queue_put(void *que,uint32_t id,uint32_t op,uint8_t *data,uint32_t leng);        添加数据，可能被阻塞
int queue_tryput(void *que,uint32_t id,uint32_t op,uint8_t *data,uint32_t leng);      添加数据，不会被阻塞
void queue_get(void *que,uint32_t *id,uint32_t *op,uint8_t **data,uint32_t *leng);    获取数据，可能被阻塞
int queue_tryget(void *que,uint32_t *id,uint32_t *op,uint8_t **data,uint32_t *leng);  获取数据。不会被阻塞

原则
1. 加锁状态做消息入队，和条件变量阻塞；解锁状态做数据处理或者数据返回。
2. [消息队列]发送结束后，使消息队列处于unlock状态。[消息队列]接收完成后，调用lock后再调用pthread_cond_wait使线程处于阻塞状态。
2. [进程间通信]发送结束后，使数据链表处于unlock状态。[进程间通信]接收完成后，调用lock后再调用pthread_cond_wait使线程处于阻塞状态。
   pthread_mutex_lock while(1) pthread_cond_wait 获取数据 pthread_mutex_unlock 处理数据 pthread_mutex_lock 从链表中去除 ->(while(1))
   实际上：获取数据和从链表中去除可以合并在一起处理。

初始化：
pthread_cond_init   waitfull [消息队列长度被限定的时候，会初始化该变量]  阻塞添加
pthread_cond_init   waitfree                                             阻塞获取
pthread_mutex_init  lock                                                 数据处理互斥锁

queue_put 添加：
1. 创建消息队列元素qentry实例
2. pthread_mutex_lock       lock加锁
3. 将数据添加到消息队列 
   [消息队列长度被限定] 添加数据量大于设置数据量；pthread_cond_wait阻塞在waitfull条件变量
4. 通知pthread_cond_signal   waitfree条件变量
5. pthread_mutex_unlock     lock解锁

queue_get获取：
1. pthread_mutex_lock   lock加锁
2. pthread_cond_wait    阻塞在waitfree条件变量
3. 从消息队列中获取qentry实例
   [消息队列长度被限定] pthread_cond_signal通知waitfull条件变量。
4. pthread_mutex_unlock lock解锁
5. 返回指定的数据
}

readdata(动态线程池){
read_data_spawn_worker(void)            创建线程
read_data_close_worker(worker *w)       清除线程
read_worker(void *arg)                  执行线程
}
writedata(动态线程池){
write_data_spawn_worker(void)           创建线程
write_data_close_worker(worker *w)      清除线程
write_worker(void *arg)                 执行线程
}                  
bgjob(动态线程池){
void job_spawn_worker(jobpool *jp)      创建线程
void job_close_worker(worker *w)        清除线程
void* job_worker(void *arg)             执行线程

void* job_pool_new(uint32_t jobs)       线程池初始化
globalpool = job_pool_new(cfg_getuint32("WORKERS_QUEUE_LENGTH",250)) 创建线程池
}                  

hddspacemgr(线程私有变量)
{
static pthread_key_t hdrbufferkey;
static pthread_key_t blockbufferkey;

zassert(pthread_key_create(&hdrbufferkey,free));
zassert(pthread_key_create(&blockbufferkey,hdd_blockbuffer_free));

blockbuffer = pthread_getspecific(blockbufferkey);
pthread_setspecific(blockbufferkey,blockbuffer)


pthread_key_create(): 分配用于标识进程中线程特定数据的键
pthread_setspecific(): 为指定线程特定数据键设置线程特定绑定
pthread_getspecific(): 获取调用线程的键绑定，并将该绑定存储在 value 指向的位置中
pthread_key_delete(): 销毁现有线程特定数据键

}

redis()
{


}

bio(简单生产者消费者模型)
{
@@@ 不适合线程池  @@@ 
    void bioInit(void) 
        初始化进程通信全局变量
        pthread_mutex_init(&bio_mutex[j],NULL);
        pthread_cond_init(&bio_condvar[j],NULL);
        bio_jobs[j] = listCreate();
        bio_pending[j] = 0;
        设置线程属性
        pthread_attr_init(&attr);
        pthread_attr_getstacksize(&attr,&stacksize);
        pthread_attr_setstacksize(&attr, stacksize);
        创建线程
        pthread_create(&thread,&attr,bioProcessBackgroundJobs,arg) != 0)
        
    void bioCreateBackgroundJob(int type, void *arg1, void *arg2, void *arg3)     
        pthread_mutex_lock(&bio_mutex[type]);   锁保护开始
        listAddNodeTail(bio_jobs[type],job);    向消息队列添加数据
        bio_pending[type]++;                    消息队列长度增加
        pthread_cond_signal(&bio_condvar[type]);通知线程，有数据
        pthread_mutex_unlock(&bio_mutex[type]); 锁保护结束
        
    void *bioProcessBackgroundJobs(void *arg)
        pthread_mutex_lock(&bio_mutex[type]);   锁保护开始
        while(1)
            if (listLength(bio_jobs[type]) == 0) {  线程等待数据通知
                pthread_cond_wait(&bio_condvar[type],&bio_mutex[type]);
                continue;
            }
            取数据     fetch()
            pthread_mutex_unlock(&bio_mutex[type]); 锁保护结束
            处理数据   handle()
            pthread_mutex_lock(&bio_mutex[type]);   锁保护开始
            listDelNode(bio_jobs[type],ln);         更新数据状态
            bio_pending[type]--;                    更新数据状态
            
    unsigned long long bioPendingJobsOfType(int type) 
        pthread_mutex_lock(&bio_mutex[type]);   锁保护开始
        val = bio_pending[type];
        pthread_mutex_unlock(&bio_mutex[type]); 锁保护结束
            
    void bioKillThreads(void) 
        pthread_cancel(bio_threads[j])          通知线程结束
        pthread_join(bio_threads[j],NULL)       回收线程资源
}



sheepdog(线程池框架很大，多路IO处理机制比较小，将网络IO处理分配给epoll，将磁盘IO处理分配给线程池){
[event & work ]
event接收到网络数据后，交给线程池处理磁盘IO阻塞读写；
work接收到event的磁盘IO阻塞读写，处理完成后，work再将后续的网络处理交由event处理。


event(sheepdog) 多路IO处理机制
work(sheepdog)  线程池机制

eventfd机制和timefd机制在epoll中应用。
创建一个eventfd，这是一个计数器相关的fd，计数器不为零是有可读事件发生，read以后计数器清零，write递增计数器；返回的fd可以进行如下操作：read、write、select(poll、epoll)、close


int signalfd(int fd, const sigset_t *mask, int flags);
参数fd：如果是-1则表示新建一个，如果是一个已经存在的则表示修改signalfd所关联的信号；
}

event(sheepdog；利用了rbtree，eventfd以及timerfd机制){
typedef void (*event_handler_t)(int fd, int events, void *data);           可以注册的回调函数

int init_event(int nr);                                                     初始化多路IO框架
int register_event_prio(int fd, event_handler_t h, void *data, int prio);   注册基于fd的回调函数(优先级)
void unregister_event(int fd);                                              取消基于fd的回调函数
int modify_event(int fd, unsigned int events);                              修改基于fd的阻塞触发条件
void event_loop(int timeout);                                               非基于优先级调用epoll_wait及处理函数
void event_loop_prio(int timeout);                                          基于优先级调用epoll_wait及处理函数
void event_force_refresh(void);                                             更新调用epoll_wait及处理函数
int register_event(int fd, event_handler_t h, void *data);                  注册基于fd的回调函数

对fd使用rbtree进行管理；
}

work(sheepdog；线程池绑定消息队列，线程池不关联业务，消息队列上的数据绑定业务){
typedef void (*work_func_t)(struct work *);  线程处理函数

struct work {
    struct list_node w_list;                 队列链表
    work_func_t fn;                          线程池或线程处理函数
    work_func_t done;                        线程池对外通知后处理函数
};

struct work_queue {                          消息队列
    int wq_state;
    struct list_head pending_list;
};

int init_work_queue(size_t (*get_nr_nodes)(void));                              初始化消息队列(done函数调用机制部分初始化)
struct work_queue *create_work_queue(const char *name, enum wq_thread_control); 创建线程池
struct work_queue *create_ordered_work_queue(const char *name);                 创建线程池
void queue_work(struct work_queue *q, struct work *work);                       向执行消息队列添加数据
bool work_queue_empty(struct work_queue *q);                                    队列内数据量
int wq_trace_init(void);                                                        跟踪消息队列状态

int sd_thread_create(const char *, sd_thread_t *, void *(*start_routine)(void *), void *);           创建线程，会保存线程名
int sd_thread_create_with_idx(const char *, sd_thread_t *,void *(*start_routine)(void *), void *);   创建线程，会保存线程名和线程pthread_t
int sd_thread_join(sd_thread_t , void **);                                                           
}

thread(){
为了应付"发送给进程的信号"和"发送给线程的信号", task_struct里面维护了两套signal_pending, 一套是线程组共享的, 一套是线程独有的.
通过kill发送的信号被放在线程组共享的signal_pending中, 可以由任意一个线程来处理; 通过pthread_kill发送的信号(pthread_kill是pthread库的接口, 对应的系统调用中tkill)被放在线程独有的signal_pending中, 只能由本线程来处理.
当线程停止/继续, 或者是收到一个致命信号时, 内核会将处理动作施加到整个线程组中.

在linux 2.6中, 内核有了线程组的概念, task_struct结构中增加了一个tgid(thread group id)字段.
如果这个task是一个"主线程", 则它的tgid等于pid, 否则tgid等于进程的pid(即主线程的pid).
在clone系统调用中, 传递CLONE_THREAD参数就可以把新进程的tgid设置为父进程的tgid(否则新进程的tgid会设为其自身的pid).
类似的XXid在task_struct中还有两 个：task->signal->pgid保存进程组的打头进程的pid、task->signal->session保存会话 打头进程的pid。通过这两个id来关联进程组和会话。
有了tgid, 内核或相关的shell程序就知道某个tast_struct是代表一个进程还是代表一个线程, 也就知道在什么时候该展现它们, 什么时候不该展现(比如在ps的时候, 线程就不要展现了).

}
pthread(gcc中-pthread和-lpthread的区别){
    用gcc编译使用了POSIX thread的程序时通常需要加额外的选项，以便使用thread-safe的库及头文件，一些老的书里说
直接增加链接选项 -lpthread 就可以了，像这样：
gcc -c x.c   
gcc x.o -ox -lpthread  
gcc -c x.c  gcc x.o -ox -lpthread
 而gcc手册里则指出应该在编译和链接时都增加 -pthread 选项，像这样：
gcc -pthread -c x.c   
gcc x.o -ox -pthread  
gcc -pthread -c x.c  gcc x.o -ox -pthread
 那么 -pthread 相比于 -lpthread 链接选项究竟多做了什么工作呢？我们可以在verbose模式下执行一下对应的gcc命令行看出来。

 gcc -v x.o -ox -lpthread   # gcc pthread_attr.c -o pthread_attr -v -lpthread
 gcc -v x.o -ox -pthread    # gcc pthread_attr.c -o pthread_attr -v -pthread
    可见编译选项中指定 -pthread 会附加一个宏定义-D_REENTRANT，该宏会导致 libc 头文件选择那些thread-safe的实现；
链接选项中指定 -pthread 则同 -lpthread 一样，只表示链接 POSIX thread 库。由于 libc 用于适应 thread-safe 的宏定义可能变化，
因此在编译和链接时都使用 -pthread 选项而不是传统的 -lpthread 能够保持向后兼容，并提高命令行的一致性。
}

signal(待整理){
1. 在多线程环境下，产生的信号是传递给整个进程的，一般而言，所有线程都有机会收到这个信号，进程在收到信号的的线程上下文执行信号处理函数，具体是哪个线程执行的难以获知。也就是说，信号会随机发个该进程的一个线程。
2 signal函数BSD/Linux的实现并不在信号处理函数调用时，恢复信号的处理为默认，而是在信号处理时阻塞此信号，直到信号处理函数返回。其他实现可能在调用信号处理函数时，恢复信号的处理为默认方式，因而需要在信号处理函数中重建信号处理函数为我们定义的处理函数，在这些系统中，较好的方法是使用sigaction来建立信号处理函数。
3 发送信号给进程，哪个线程会收到？APUE说，在多线程的程序中，如果不做特殊的信号阻塞处理，当发送信号给进程时，由系统选择一个线程来处理这个信号。
4 如果进程中，有的线程可以屏蔽了某个信号，而某些线程可以处理这个信号，则当我们发送这个信号给进程或者进程中不能处理这个信号的线程时，系统会将这个信号投递到进程号最小的那个可以处理这个信号的线程中去处理。
5 如果我们同时注册了信号处理函数，同时又用sigwait来等待这个信号，谁会取到信号？经过实验，Linux上sigwait的优先级高。 
6 在Linux中的posix线程模型中，线程拥有独立的进程号，可以通过getpid()得到线程的进程号，而线程号保存在pthread_t的值中。而主线程的进程号就是整个进程的进程号，因此向主进程发送信号只会将信号发送到主线程中去。如果主线程设置了信号屏蔽，则信号会投递到一个可以处理的线程中去。
7 当调用SYSTEM函数去执行SHELL命令时，可以放心的阻塞SIGCHLD，因为SYSTEM会自己处理子进程终止的问题。 
8 使用sleep()时，要以放心的去阻塞SIGALRM信号，目前sleep函数都不会依赖于ALRM函数的SIGALRM信号来工作。
}
signal(待整理){
1. 默认情况下，信号将由主进程接收处理，就算信号处理函数是由子线程注册的

2. 每个线程均有自己的信号屏蔽字，可以使用sigprocmask函数来屏蔽某个线程对该信号的响应处理，仅留下需要处理该信号的线程来处理指定的信号。

3. 对某个信号处理函数，以程序执行时最后一次注册的处理函数为准，即在所有的线程里，同一个信号在任何线程里对该信号的处理一定相同

4. 可以使用pthread_kill对指定的线程发送信号

APUE的说法:每个线程都有自己的信号屏蔽字,但是信号的处理是进程中所有的线程共享的,这意味着尽管单个线程可以阻止某些信号,但当线程修改了与某个信号相关的处理行为后,所有的线程都共享这个处理行为的改变。这样如果一个线程选择忽略某个信号，而其他线程可以恢复信号的默认处理行为，或者为信号设置一个新的处理程序，从而可以撤销上述线程的信号选择。

进程中的信号是送到单个线程的，如果信号与硬件故障或者计时器超时有关，该型号就被发送到引起该事件的线程中去，而其他的信号则被发送到任意一个线程。

sigprocmask的行为在多线程的进程中没有定义，线程必须使用pthread_sigmask

总结：一个信号可以被没屏蔽它的任何一个线程处理，但是在一个进程内只有一个多个线程共用的处理函数。......
}

signal(待整理){
1 Linux 多线程应用中，每个线程可以通过调用pthread_sigmask() 设置本线程的信号掩码。一般情况下，被阻塞的信号将不能中断此线程的执行，除非此信号的产生是因为程序运行出错如SIGSEGV；另外不能被忽略处理的信号SIGKILL 和SIGSTOP 也无法被阻塞。
2 当一个线程调用pthread_create() 创建新的线程时，此线程的信号掩码会被新创建的线程继承。

3 信号安装最好采用sigaction方式，sigaction，是为替代signal 来设计的较稳定的信号处理，signal的使用比较简单。signal(signalNO,signalproc);

不能完成的任务是：1.不知道信号产生的原因；

2.处理信号中不能阻塞其他的信号

而signaction，则可以设置比较多的消息。尤其是在信号处理函数过程中接受信号，进行何种处理。

sigaction函数用于改变进程接收到特定信号后的行为。

4 sigprocmask函数只能用于单线程，在多线程中使用pthread_sigmask函数。

5 信号是发给进程的特殊消息，其典型特性是具有异步性。

6 信号集代表多个信号的集合，其类型是sigset_t。

7 每个进程都有一个信号掩码（或称为信号屏蔽字），其中定义了当前进程要求阻塞的信号集。

8 所谓阻塞，指Linux内核不向进程交付在掩码中的所有信号。于是进程可以通过修改信号掩码来暂时阻塞特定信号的交付，被阻塞的信号不会影响进程的行为直到该信号被真正交付。 

9 忽略信号不同于阻塞信号，忽略信号是指Linux内核已经向应用程序交付了产生的信号，只是应用程序直接丢弃了该信号而已。

10 sleep和nanosleep，如果没有在它调用之前设置信号屏蔽字的话，都可能会被信号处理函数打断。参见sleep和nanosleep的mannual。
}