
类型          机制                         应用场合
spinlock        使用忙等方法，进程不挂起    (1)用于多处理器间共享数据
                                            (2)在可抢占的内核线程里共享数据
                                            (3)自旋锁适合于保持时间非常短的情况，它可以在任何上下文使用，比如中断上下文
信号量         阻塞式等待，进程挂起         (1)适合于共享区保持时间教长的情况
                                            (2)只能用于进程上下文
原子操作       数据的原子访问               (1)共享简单的数据类型：整型，比特性
                                            (2)适合高效率的场合
rwlock          特殊的自旋锁                (1)允许同时读共享资源，但只能有一个写
                                            (2)读优先于写，读写不能同时
顺序锁         一种免锁机制，基于访问计数   (1)允许同时读共享资源，但只能有一个写
                                            (2)写优先于读，读写不能同时
RCU            通过副本的免锁访问           (1)对读占主要的场合提供高性能
                                            (2)读访问不必获取锁，不必执行原子操作或禁止中断
关闭中断        通过禁止中断的手段，排除单处理器上的并发，会导致中断延迟
                                            (1)中断与正常进程共享数据
                                            (2)多个中断共享数据
                                            (3)临界区一般很短


自旋锁对信号量
需求                                建议的加锁方法

低开销加锁                          优先使用自旋锁
短期锁定                            优先使用自旋锁
长期加锁                            优先使用信号量
中断上下文中加锁                    使用自旋锁
持有锁是需要睡眠、调度              使用信号量


http://blog.csdn.net/zhangskd/article/details/21992933

(1) 硬中断
由与系统相连的外设(比如网卡、硬盘)自动产生的。主要是用来通知操作系统系统外设状态的变化。比如当网卡收到数据包
的时候，就会发出一个中断。我们通常所说的中断指的是硬中断(hardirq)。
 
(2) 软中断
为了满足实时系统的要求，中断处理应该是越快越好。linux为了实现这个特点，当中断发生的时候，硬中断处理那些短时间
就可以完成的工作，而将那些处理事件比较长的工作，放到中断之后来完成，也就是软中断(softirq)来完成。
 
(3) 中断嵌套
Linux下硬中断是可以嵌套的，但是没有优先级的概念，也就是说任何一个新的中断都可以打断正在执行的中断，但同种中断
除外。软中断不能嵌套，但相同类型的软中断可以在不同CPU上并行执行。
 
(4) 软中断指令
int是软中断指令。
中断向量表是中断号和中断处理函数地址的对应表。
int n - 触发软中断n。相应的中断处理函数的地址为：中断向量表地址 + 4 * n。
 
(5)硬中断和软中断的区别
软中断是执行中断指令产生的，而硬中断是由外设引发的。
硬中断的中断号是由中断控制器提供的，软中断的中断号由指令直接指出，无需使用中断控制器。
硬中断是可屏蔽的，软中断不可屏蔽。
硬中断处理程序要确保它能快速地完成任务，这样程序执行时才不会等待较长时间，称为上半部。
软中断处理硬中断未完成的工作，是一种推后执行的机制，属于下半部。 
初始化软件中断，软件中断与硬件中断区别就是中断发生时，软件中断是使用线程来监视中断信号，而硬件中断是使用CPU硬件来监视中断。

软中断是一组静态定义的下半部接口，可以在所有处理器上同时执行，即使两个类型相同也可以。
但一个软中断不会抢占另一个软中断，唯一可以抢占软中断的是硬中断。

开关
-------------------------------------------------------------------------------
(1) 硬中断的开关
简单禁止和激活当前处理器上的本地中断：
local_irq_disable();
local_irq_enable();
保存本地中断系统状态下的禁止和激活：
unsigned long flags;
local_irq_save(flags);
local_irq_restore(flags);
 
(2) 软中断的开关
禁止下半部，如softirq、tasklet和workqueue等：
local_bh_disable();
local_bh_enable();
需要注意的是，禁止下半部时仍然可以被硬中断抢占。
 
(3) 判断中断状态
#define in_interrupt() (irq_count()) // 是否处于中断状态(硬中断或软中断)
#define in_irq() (hardirq_count()) // 是否处于硬中断
#define in_softirq() (softirq_count()) // 是否处于软中断

irq(中断屏蔽的特点){
由于Linux系统的异步IO，进程调度等很多重要操作都依赖于中断，在屏蔽中断期间所有的中断程序都无法得到处理，
因此长时间的屏蔽是很危险的，有可能造成数据丢失甚至系统崩溃，这就要求在屏蔽中断之后，当前的内核执行路径
应尽快地执行完临界区内的代码

中断屏蔽只能禁止本CPU内的中断，因此并不能解决多CPU引发的竟态，所以单独使用中断屏蔽并不是一个值得推荐
的方法，它一般和自旋锁配合使用。
}


irq(中断屏蔽)
{
出招表一：中断屏蔽(可以保证正在执行的内核执行路径不被中断处理程序抢占,由于Linux内核的进程调度都依赖中断来实现，内核抢占进程之间的竞态就不存在了)
    使用方法:   local_irq_disable()  //屏蔽中断    说明：local_irq_disable()和local_irq_enable()都只能禁止和使能本CPU内的中断
                 ….                                                并不能解决SMP多CPU引发的竞争。
                 critical section  //临界区
                 ….
                 local_irq_enable()  //开中断 
    与local_irq_disable()不同，local_irq_save(flags)除了进行禁止中断操作以外，还保证目前CPU的中断位信息，local_irq_restore(flags)进行相反的操作。
    致命弱点: 由于Linux系统的异步I/O,进程调度等很多重要操作都依赖于中断，在屏蔽中断期间所有的中断都无法处理，因此长时间屏蔽中断是很危险的，有可能造
                成数据丢失甚至系统奔溃。
}

atomic(原子操作特点){
原子操作的优点是系统的开销小且对高速缓存的影响小，缺点是不适用于有高性能要求的代码，原子操作通常用于实现资源的引用计数。
}

atomic(原子整数操作)
{
出招表二：原子操作。 分为整形原子和位原子操作。 
    使用方法一：整形原子操作
            1)设置原子变量的值
              void atomic_set(atomic_t *v, int i);//设置原子变量的值为i
              atomic_t v = ATOMIC_INIT(0);//定义原子变量v并初始化为0
             2)获取原子变量的值
              atomic_read(atomic_t *v);//返回原子变量的值
            3)原子变量加/减
              void atomic_add(int i,atomic_t *v);  //原子变量增加i
              void atomic_sub(int i,atomic_t *v);  //原子变量减少i
            4)原子变量自增/自减
              void atomic_inc(atomic_t *v);  //原子变量加1
              void atomic_dec(atomic_t *v);  //原子变量减1
            5)操作并测试
            int atomic_inc_and_test(atomic_t *v);//这些操作对原子变量执行自增,自减,减操作后测试是否为0,是返回true,否则返回false
            int atomic_dec_and_test(atomic_t *v);
            int atomic_sub_and_test(int i, atomic_t *v);
            6)操作并返回
            int atomic_add_return(int i,atomic_t *v);  //这些操作对原子变量进行对应操作，并返回新的值。
            int atomic_sub_return(int i, atomic_t *v);
            int atomic_inc_return(atomic *v);
            int atomic_dec_return(atomic_t *v);
}

atomic(原子位操作特点){
原子位操作的优点是系统的开销小且对高速缓存的影响小，缺点是不适用于有高性能要求的代码，原子位操作通常用于实现资源的引用计数。
}
atomic(原子位操作)
{
   使用方法二:位原子操作。
            1)设置位
            void set_bit(nr, void *addr);  //设置addr地址的第nr位，所谓设置位即将位写为1
            2)清除位
            void clear_bit(nr,void *addr);  //清除addr地址的第nr位，所谓清除位即将位写为0
            3)改变位
            void change_bit(nr,void *addr);  //对addr地址的第nr位反置
            4)测试位
            void test_bit(nr, void  *addr);  //返回addr地址的第nr位
            5)测试并操作位
            int test_and_set_bit(nr, void *addr);
            int test_and_clear_bit(nr, void *addr);
            int test_and_change_bit(nr, void *addr);

            static atomic_t ato_avi = ATOMIC_INIT(1); //定义原子变量
            static int ato_open(struct inode *inode, struct file *filp)  
            {
              ...
              if (!atomic_dec_and_test(&ato_avi))
              {
                atomic_inc(&ato_avi);
                return = - EBUSY;  //已经打开
                }
              ..
              return 0;  //已经打开
              }
            static int ato_release(struct inode *inode, struct file *filp)
            {
              atomic_inc(&ato_avi);
              return 0;
            }
}

spinlock(自旋锁特点){
一个被征用的自旋锁使得请求它的线程在等待锁重新可用时自旋，特别浪费处理器的时间，这种行为是自旋锁的特点。
所以自旋锁不应该被长时间持有。这点正是使用自旋锁的初衷：在短时间内进行轻量级加锁。

还可以采用另外的方式处理对锁的争用：让请求线程随眠，这道锁重新可用时再唤醒他。这样处理器就不必循环等待，
可以去执行其他代码。这也会带来一定的开销----两次明显的上下文切换额外使用很多的代码。因此，持有自旋锁的
时间最好小于完成两次上下文切换的耗时。

自旋锁保持期间是抢占失效的，而信号量和读写信号量保持期间是可以被抢占的。自旋锁只有在内核可抢占或SMP的情况下才真正需要，
在单CPU且不可抢占的内核下，自旋锁的所有操作都是空操作。

1. 自旋锁可用于：进程之间竞争，进程和硬中断之间竞争，进程和软中断之间竞争，软中断和硬中断之间竞争，
2. 自旋锁不能睡眠，不能阻塞。

}

spinlock(自身特点)
{
spin_unlock_bh：
1. 如果被保护的共享资源只在进程上下文访问和软中断上下文访问，那么当在进程上下文访问共享资源时，可能被软中断打断，
   从而可能进入软中断上下文来对被保护的共享资源访问，因此对于这种情况，对共享资源的访问必须使用spin_lock_bh和
   spin_unlock_bh来保护。
2. 当然使用spin_lock_irq和spin_unlock_irq以及spin_lock_irqsave和spin_unlock_irqrestore也可以，它们失效了
   本地硬中断，失效硬中断隐式地也失效了软中断。但是使用spin_lock_bh和spin_unlock_bh是最恰当的，它比其他两个快。
3. 如果被保护的共享资源只在进程上下文和tasklet或timer上下文访问，那么应该使用与上面情况相同的获得和释放锁的宏，
   因为tasklet和timer是用软中断实现的。   

很少会出现的情况： tasklet和timer
4. 如果被保护的共享资源只在一个tasklet或timer上下文访问，那么不需要任何自旋锁保护，因为同一个tasklet或timer只能
   在一个CPU上运行，即使是在SMP环境下也是如此。实际上tasklet在调用tasklet_schedule标记其需要被调度时已经把该tasklet
   绑定到当前CPU，因此同一个tasklet决不可能同时在其他CPU上运行。
5. timer也是在其被使用add_timer添加到timer队列中时已经被帮定到当前CPU，所以同一个timer绝不可能运行在其他CPU上。
   当然同一个tasklet有两个实例同时运行在同一个CPU就更不可能了。
   
spin_lock:
6. 如果被保护的共享资源只在两个或多个tasklet或timer上下文访问，那么对共享资源的访问仅需要用spin_lock和spin_unlock来保护，
   不必使用_bh版本，因为当tasklet或timer运行时，不可能有其他tasklet或timer在当前CPU上运行。
7. 如果被保护的共享资源只在一个软中断（tasklet和timer除外）上下文访问，那么这个共享资源需要用spin_lock和spin_unlock来保护，
   因为同样的软中断可以同时在不同的CPU上运行。
8. 如果被保护的共享资源在两个或多个软中断上下文访问，那么这个共享资源当然更需要用spin_lock和spin_unlock来保护，
   不同的软中断能够同时在不同的CPU上运行。

spin_lock_irq
9. 如果被保护的共享资源在软中断（包括tasklet和timer）或进程上下文和硬中断上下文访问，那么在软中断或进程上下文访问期间，
   可能被硬中断打断，从而进入硬中断上下文对共享资源进行访问，因此，在进程或软中断上下文需要使用spin_lock_irq和spin_unlock_irq
   来保护对共享资源的访问。

10. 而在中断处理句柄中使用什么版本，需依情况而定，如果只有一个中断处理句柄访问该共享资源，那么在中断处理句柄中仅需要
    spin_lock和spin_unlock来保护对共享资源的访问就可以了。   
    
11. 因为在执行中断处理句柄期间，不可能被同一CPU上的软中断或进程打断。但是如果有不同的中断处理句柄访问该共享资源，那么需要
    在中断处理句柄中使用spin_lock_irq和spin_unlock_irq来保护对共享资源的访问。
    
　　在使用spin_lock_irq和spin_unlock_irq的情况下，完全可以用spin_lock_irqsave和spin_unlock_irqrestore取代，那具体应该使用
    哪一个也需要依情况而定，如果可以确信在对共享资源访问前中断是使能的，那么使用spin_lock_irq更好一些。
    
　　因为它比spin_lock_irqsave要快一些，但是如果你不能确定是否中断使能，那么使用spin_lock_irqsave和spin_unlock_irqrestore更好，
    因为它将恢复访问共享资源前的中断标志而不是直接使能中断。
    
}

spinlock()
{
1. 初始化
spinlock_t x;         初始化自旋锁x，
spin_lock_init(x);       
                         
DEFINE_SPINLOCK(x);      
SPIN_LOCK_UNLOCKED; 

DEFINE_SPINLOCK(x)等同于spinlock_t x = SPIN_LOCK_UNLOCKED spin_is_locked(x)

2. 获取自旋锁
spin_lock(lock);
spin_trylock(lock);
spin_lock_irqsave(lock, flag);
spin_trylock_irqsave(lock,flag);
spin_lock_irq(lock);
spin_trylock_irq(lock);
spin_lock_bh(lock);      进程上下文访问和软中断上下文
spin_trylock_bh(lock);   进程上下文访问和软中断上下文
spin_is_lockd(lock);
spin_can_lockd(lock);

3. 释放自旋锁
spin_unlock(lock);
spin_unlock_irqrestore(lock, flag);
spin_unlock_irq(lock);
spin_unlock_bh(lock);
spin_unlock_wait(lock);
}

rwlock(读写自旋锁特点){
在使用Linux读写自旋锁时，要考虑的一点是这种锁机制照顾读比照顾写要多一点。当读锁被持有时，写操作为了互斥访问只能
等待，但是读执行单元却可以继续成功地占用锁。而自旋锁的写执行单元在所有读执行单元释放锁之前无法获得锁。所以，大量
读执行单元必定会使挂起的写执行单元处于饥饿状态。
}

rwlock(读写自旋锁)
{
1. 初始化
rwlock_t my_rwlock = RW_LOCK_UNLOCKED;
rwlock_t my_rwlock;
rwlock_init(&my_rwlock);

2. 读锁定
read_lock(&my_rwlock)
read_lock_irq(&my_rwlock)
read_lock_irqsave(&my_rwlock,flag);
3. 读解锁
read_unlock(&my_rwlock)
read_unlock_irq(&my_rwlock)
read_unlock_irqsave(&my_rwlock,flag);
4. 写锁定
write_lock(&my_rwlock)
write_lock_irq(&my_rwlock)
write_lock_irqsave(&my_rwlock,flag);
5. 写解锁
write_unlock(&my_rwlock)
write_unlock_irq(&my_rwlock)
write_unlock_irqsave(&my_rwlock,flag);

}

seqlock(顺序锁特点){
如果读执行单元在读操作期间，写执行单元已经发生了写操作，那么读操作单元必须重新读取数据，确保得到的数据是完整的。
被保护的共享资源不能含有指针，因为写执行单元可能使指针实效，但读执行单元如果正要访问该指针，将导致错误。
}

seqlock(顺序锁)
{
1. 初始化
DEFINE_SEQLOCK(seqlock);
seqlock_init(&seqlock);
2. 读执行单元相关
read_seqbegin(&seqlock);
read_seqretry(&seqlock);
3. 写执行单元相关
write_seqlock(&seqlock);
write_sequnlock(&seqlock);
write_tryseqlock(&seqlock);

}

RCU(读取-复制-更新特点){
    RCU的原理就是读取-复制-更新，对于被RCU保护的共享数据结构，读执行单元不需要获得任何锁就可以访问，
但写执行单元在访问时首先复制一个副本，然后对副本进行修改，最后使用一个回调机制在适当的时机把
指向原来数据的指针重新指向新的被修改的数据。

RCU特点：
RCU是一种改进的读写自旋锁，读执行单元没有任何同步开销，而写执行单元的同步开销取决于写执行单元间的同步机制。
读执行单元不需要锁，不使用原子指令，而且在除alpha以外的所有架构上也不需要内存栅，因此不会导致锁竞争、
内存延迟以及流水线停滞等等。因为不需要考虑死锁问题使得使用更便捷。

RCU的优点是既允许多个读执行单元同时访问被保护的数据，也允许多个读执行单元和多个写执行单元同时访问被保护的数据。
但RCU不能替代读写自旋锁，因为如果写比较多时，对读执行单元的性能提高不能弥补写执行单元导致的损失。

使用RCU时，写操作单元需要延迟数据结构的释放，复制被修改的数据结构，它必须使用某种锁机制同步并行其他写执行单元的修改操作。
}

RCU(读取-复制-更新)
{
rcu_read_lock()
rcu_read_unlock()
synchronize_rcu()    该函数由RCU写端调用，它将阻塞写操作执行单元，直到经过grace period后，写执行单元才可以继续下一步操作
                     如果有多个RCU写端调用该函数，他们将在一个grace period之后全部被唤醒，保证所有CPU都处理完正在运行的
                     读端临界区。
synchronize_sched()  该函数用于等待所有CPU都处在可抢占状态，它能保证正在运行的中断处理函数处理完毕，但不能保证正在运行
                     的softirq处理完毕。
void fastcall call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
该函数由RCU写端调用，他不会使写操作单元阻塞，因而可以在中断处理上文或软中断使用，该函数将把函数func挂接到RCU回调函数链上，然后立即返回。
static inline void list_add_rcu(struct list_head *new, struct list_head *head)
该函数把链表项new插入到RCU保护的链表head的开头，内存栅保证了在引用这个新插入的链表项之前，新链表项的链接指针的修改对
所有读执行单元是可见的。
static inline void list_add_tail_rcu(struct list_head *new, struct list_head *head)
static inline void list_del_rcu(struct list_head *entry)                  
static inline void list_replace_rcu(struct list_head *entry) 
          
}

mutex(信号量的特点){
由于信号量会导致睡眠，所以不能用于中断上下文。并且使用down()进入睡眠的进行不能被信号打断。信号量允许任意
多个执行单元持有该信号量，而自旋锁只允许最多一个任务持有。
}

mutex(信号量)
{
1. 初始化
DECLARE_MUTEX(sem);

struct semaphore *sem;
sema_init(sem, val);
init_MUTEX(sem);
init_MUTEX_LOCKED(sem);

2. 获得信号量
void down(struct semaphore *sem);
int down_interruptible(struct semaphore *sem)；
int down_killable(struct semaphore *sem);
int down_trylock(struct semaphore *sem);

3. 释放信号量
void up(struct semaphore *sem);

}

completion(完成量特点){
完成量是一种比信号量更好的同步机制，他用简单的方法是两个任务得以同步：一个执行单元等待另一个执行单元执行完某事。
}
completion()
{
1. 初始化
DELCLARE_COMPLETION(my_completion);

2. 等待完成量
void wait_for_completion(struct completion *c);

3. 唤醒完成量
void complete(struct completion *c)；
void complete_all(struct completion *c);


}

rw_semaphore(读写信号量特点)
{

}
rw_semaphore(读写信号量)
{
1. 定义和初始化读写信号量
DELCLARE_RWSEM(rwsem);

struct rw_semaphore rwsem;
init_rwsem(&rwsem);

2. 读信号量获取和释放

void down_read(struct rw_semaphore *rwsem)；
int down_read_trylock(struct rw_semaphore *rwsem);
void up_read(struct rw_semaphore *rwsem);

3. 写信号量获取和释放
void down_write(struct rw_semaphore *rwsem);
int down_write_trylock(struct rw_semaphore *rwsem);
void up_write(struct rw_semaphore *rwsem);
}

BKL(全局自旋锁特点){

BLK是一个全局自旋锁，用来方便实现从Linux最初的SMP过渡到细粒度机制。

持有BLK的任务仍然可以睡眠。BLK是一种递归锁，可以用在进程上下文，BLK已成为内核扩展性的障碍。
在内核中不鼓励使用BLK。事实上，新代码中不再使用BLK，但是这种锁仍然在部分内核代码中沿用。
}
BKL(全局自旋锁)
{

lock_kernel()
unlock_kernel()
kernel_locked()

}